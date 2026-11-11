import { realpathSync } from "node:fs";
import { isAbsolute, resolve, sep } from "node:path";
import { CopilotClient, type CopilotSession, type PermissionRequest, type PermissionRequestResult } from "@github/copilot-sdk";
import { classifyError, errorText, type FailureKind } from "./failure.ts";
import { decide, keyText, lastQuestion } from "./replies.ts";
import type { Scenario } from "./scenario.ts";

export interface TranscriptEntry {
  turn: number;
  role: "user" | "agent" | "question" | "answer" | "permission" | "skill" | "system";
  text: string;
}

export interface Rejection {
  kind: string;
  detail: string;
  /** Shell, memory, and outside writes fail the storage invariant (FR-029). */
  fatal: boolean;
}

export interface Warning {
  kind: "paraphrased-question" | "flaky";
  expected?: string;
  actual?: string;
  message: string;
}

export interface Usage {
  calls: number;
  inputTokens: number;
  outputTokens: number;
  cacheReadTokens: number;
  cacheWriteTokens: number;
  cost: number;
}

export type DriveOutcome = "ended" | "unmatched-question" | "turn-limit" | "timeout" | "error";

export interface DriveResult {
  outcome: DriveOutcome;
  turns: number;
  rejected: Rejection[];
  warnings: Warning[];
  usage: Usage;
  usedReplies: number[];
  skillsInvoked: string[];
  unmatched?: string;
  repeated?: { question: string; count: number };
  error?: { kind: FailureKind; message: string };
  lastMessage: string;
}

export type FallbackPicker = (message: string, candidates: number[]) => Promise<number | undefined>;

export interface DriveOptions {
  scenario: Scenario;
  projectDir: string;
  copilotHome: string;
  token: string;
  model: string;
  maxTurns: number;
  timeoutMs: number;
  pickFallback: FallbackPicker;
  raw: (event: unknown) => void;
  log: (entry: TranscriptEntry) => void;
  sleep?: (ms: number) => Promise<void>;
}

export type Driver = (options: DriveOptions) => Promise<DriveResult>;

export function emptyUsage(): Usage {
  return { calls: 0, inputTokens: 0, outputTokens: 0, cacheReadTokens: 0, cacheWriteTokens: 0, cost: 0 };
}

export function addUsage(total: Usage, part: Partial<Usage>): Usage {
  return {
    calls: total.calls + (part.calls ?? 0),
    inputTokens: total.inputTokens + (part.inputTokens ?? 0),
    outputTokens: total.outputTokens + (part.outputTokens ?? 0),
    cacheReadTokens: total.cacheReadTokens + (part.cacheReadTokens ?? 0),
    cacheWriteTokens: total.cacheWriteTokens + (part.cacheWriteTokens ?? 0),
    cost: total.cost + (part.cost ?? 0),
  };
}

function roots(projectDir: string): string[] {
  const out = [resolve(projectDir)];
  try {
    const real = realpathSync(projectDir);
    if (!out.includes(real)) out.push(real);
  } catch {
    // The project exists for the whole attempt; a failed realpath leaves the plain root.
  }
  return out;
}

export function insideProject(projectDir: string, path: string | undefined): boolean {
  if (!path) return false;
  const full = isAbsolute(path) ? resolve(path) : resolve(projectDir, path);
  return roots(projectDir).some((root) => full === root || full.startsWith(root + sep));
}

export interface PolicyDecision {
  result: PermissionRequestResult;
  rejection?: Rejection;
  summary: string;
}

const SHELL_FEEDBACK = "Shell commands are not available in this session. Highway skills read and write files only.";

/** FR-008: reads and writes inside the project; URLs only with `web: yes`; everything else rejected. */
export function permissionPolicy(request: PermissionRequest, projectDir: string, web: boolean): PolicyDecision {
  const r = request as unknown as Record<string, unknown>;
  const approve: PermissionRequestResult = { kind: "approve-once" };
  const reject = (kind: string, detail: string, fatal: boolean, feedback: string): PolicyDecision => ({
    result: { kind: "reject", feedback },
    rejection: { kind, detail, fatal },
    summary: `rejected ${kind}: ${detail}`,
  });
  switch (request.kind) {
    case "read": {
      const path = String(r.resolvedPath ?? r.path ?? "");
      if (insideProject(projectDir, path)) return { result: approve, summary: `approved read: ${path}` };
      return reject("read", path, false, "Reads outside the project are not available in this session.");
    }
    case "write": {
      const path = String(r.resolvedPath ?? r.fileName ?? "");
      if (insideProject(projectDir, path)) return { result: approve, summary: `approved write: ${path}` };
      return reject("outside-write", path, true, "Writes outside the project are not available in this session.");
    }
    case "shell":
      return reject("shell", String(r.fullCommandText ?? r.intention ?? "command"), true, SHELL_FEEDBACK);
    case "memory":
      return reject("memory", String(r.fact ?? r.intention ?? "memory"), true, "Memory is not available in this session.");
    case "url": {
      const url = String(r.url ?? r.intention ?? "url");
      if (web) return { result: approve, summary: `approved url: ${url}` };
      return reject("url", url, false, "Web access is not available in this session.");
    }
    default:
      return reject(String(request.kind), String(r.toolName ?? r.intention ?? request.kind), false, "This tool is not available in this session.");
  }
}

export type StopKind = "rate-limit" | "allowance" | "no-access";

/** Stops the run: no new scenario starts, and the run exits 2 (FR-036b). */
export class RunStop extends Error {
  readonly kind: StopKind;
  constructor(kind: StopKind, message: string) {
    super(message);
    this.kind = kind;
  }
}

export const RATE_LIMIT_WAITS_MS: readonly number[] = [5_000, 20_000, 60_000];

const realSleep = (ms: number): Promise<void> => new Promise((done) => setTimeout(done, ms));

/** R11 and FR-036b: retry a rate-limited call after 5, 20, and 60 seconds; then stop the run. */
export async function withRateLimit<T>(call: () => Promise<T>, sleep: (ms: number) => Promise<void> = realSleep, onWait?: (ms: number) => void): Promise<T> {
  for (let attempt = 0; ; attempt++) {
    try {
      return await call();
    } catch (error) {
      const kind = classifyError(error);
      if (kind === "allowance") throw new RunStop("allowance", errorText(error));
      if (kind !== "rate-limit") throw error;
      if (attempt >= RATE_LIMIT_WAITS_MS.length) throw new RunStop("rate-limit", errorText(error));
      onWait?.(RATE_LIMIT_WAITS_MS[attempt]);
      await sleep(RATE_LIMIT_WAITS_MS[attempt]);
    }
  }
}

class Timeout extends Error {}

function usageFrom(data: Record<string, unknown>): Partial<Usage> {
  const num = (v: unknown): number => (typeof v === "number" && Number.isFinite(v) ? v : 0);
  return {
    calls: 1,
    inputTokens: num(data.inputTokens),
    outputTokens: num(data.outputTokens),
    cacheReadTokens: num(data.cacheReadTokens),
    cacheWriteTokens: num(data.cacheWriteTokens),
    cost: num(data.cost),
  };
}

/** The Copilot SDK driver: one client and one session per attempt (FR-006, FR-007). */
export const copilotDriver: Driver = async (options) => {
  const { scenario, projectDir, log, raw } = options;
  const sleep = options.sleep ?? realSleep;
  const deadline = Date.now() + options.timeoutMs;
  const rejected: Rejection[] = [];
  const warnings: Warning[] = [];
  const used = new Set<number>();
  const skillsInvoked: string[] = [];
  const askedCount = new Map<string, number>();
  let usage = emptyUsage();
  let turn = 0;
  let turnMessages: string[] = [];
  let unmatched: string | undefined;

  const pickReply = async (message: string, question: string): Promise<number | undefined> => {
    const decision = decide(message, scenario.replies, used);
    if (decision.type === "reply") return decision.index;
    const candidates = decision.type === "fallback" ? decision.candidates : scenario.replies.map((_, i) => i).filter((i) => !used.has(i));
    if (candidates.length === 0) return undefined;
    const picked = await options.pickFallback(message, candidates);
    if (picked !== undefined) {
      warnings.push({
        kind: "paraphrased-question",
        expected: keyText(scenario.replies[picked]),
        actual: question,
        message: `Paraphrased question at turn ${turn}: expected "${keyText(scenario.replies[picked])}", got "${question}"`,
      });
    }
    return picked;
  };

  const client = new CopilotClient({
    baseDirectory: options.copilotHome,
    gitHubToken: options.token,
    useLoggedInUser: false,
    workingDirectory: projectDir,
    logLevel: "error",
  });
  let session: CopilotSession | undefined;

  const result = (outcome: DriveOutcome, extra: Partial<DriveResult> = {}): DriveResult => {
    let repeated: DriveResult["repeated"];
    for (const [question, count] of askedCount) if (count > 1 && (!repeated || count > repeated.count)) repeated = { question, count };
    return {
      outcome,
      turns: turn,
      rejected,
      warnings,
      usage,
      usedReplies: [...used],
      skillsInvoked,
      unmatched,
      repeated,
      lastMessage: turnMessages.join("\n\n"),
      ...extra,
    };
  };

  try {
    await withRateLimit(() => client.start(), sleep);
    session = await withRateLimit(
      () =>
        client.createSession({
          model: options.model,
          workingDirectory: projectDir,
          clientName: "highway-harness",
          enableConfigDiscovery: true,
          enableSessionStore: false,
          enableSessionTelemetry: false,
          onPermissionRequest: (request) => {
            const decision = permissionPolicy(request, projectDir, scenario.web);
            if (decision.rejection) rejected.push(decision.rejection);
            log({ turn, role: "permission", text: decision.summary });
            return decision.result;
          },
          onUserInputRequest: async (request) => {
            const question = request.question;
            log({ turn, role: "question", text: [question, ...(request.choices ?? []).map((c, i) => `${i + 1}. ${c}`)].join("\n") });
            const index = await pickReply(question, lastQuestion(question));
            if (index === undefined) {
              unmatched = lastQuestion(question);
              log({ turn, role: "answer", text: "(no keyed reply; the scenario fails here)" });
              return { answer: "Stop here.", wasFreeform: true };
            }
            used.add(index);
            const answer = scenario.replies[index].say;
            log({ turn, role: "answer", text: answer });
            return { answer, wasFreeform: !(request.choices ?? []).includes(answer) };
          },
        }),
      sleep,
    );

    session.on((event) => {
      raw(event);
      const data = (event as { data?: Record<string, unknown> }).data ?? {};
      switch (event.type) {
        case "assistant.message":
          if (!data.parentToolCallId && typeof data.content === "string" && data.content.trim() !== "") turnMessages.push(data.content);
          break;
        case "assistant.usage":
          usage = addUsage(usage, usageFrom(data));
          break;
        case "skill.invoked": {
          const name = String(data.name ?? data.skillName ?? "skill");
          skillsInvoked.push(name);
          log({ turn, role: "skill", text: `invoked ${name}` });
          break;
        }
        case "session.error":
          log({ turn, role: "system", text: `session error: ${String(data.message ?? data.errorType ?? "")}` });
          break;
      }
    });

    let message = scenario.open;
    while (true) {
      if (unmatched) return result("unmatched-question");
      if (turn >= options.maxTurns) return result("turn-limit");
      const remaining = deadline - Date.now();
      if (remaining <= 0) return result("timeout");
      turn++;
      turnMessages = [];
      log({ turn, role: "user", text: message });

      const prompt = message;
      let timer: NodeJS.Timeout | undefined;
      const timeout = new Promise<never>((_, fail) => {
        timer = setTimeout(() => fail(new Timeout("attempt time limit")), remaining);
      });
      try {
        await Promise.race([withRateLimit(() => session!.sendAndWait({ prompt }, remaining), sleep), timeout]);
      } catch (error) {
        if (error instanceof Timeout || /timeout|timed out/i.test(errorText(error))) return result("timeout");
        throw error;
      } finally {
        clearTimeout(timer);
      }

      const text = turnMessages.join("\n\n");
      log({ turn, role: "agent", text });
      if (unmatched) return result("unmatched-question");

      const decision = decide(text, scenario.replies, used);
      if (decision.type === "end") return result("ended");
      const question = lastQuestion(text);
      askedCount.set(question, (askedCount.get(question) ?? 0) + 1);
      const index = decision.type === "reply" ? decision.index : await pickReply(text, question);
      if (index === undefined) {
        unmatched = question;
        return result("unmatched-question");
      }
      used.add(index);
      message = scenario.replies[index].say;
    }
  } catch (error) {
    if (error instanceof RunStop) throw error;
    const kind = classifyError(error);
    if (kind === "no-access") throw new RunStop("no-access", errorText(error));
    return result("error", { error: { kind, message: errorText(error) } });
  } finally {
    try {
      await session?.disconnect();
    } catch {
      // A failed disconnect leaves nothing to clean in the project; the client stops next.
    }
    try {
      await client.stop();
    } catch {
      // The temporary Copilot home is removed by the runner either way.
    }
  }
};
