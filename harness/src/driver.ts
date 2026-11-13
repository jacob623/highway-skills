import { realpathSync } from "node:fs";
import { isAbsolute, join, resolve, sep } from "node:path";
import { CopilotClient, type CopilotSession, type PermissionRequest, type PermissionRequestResult } from "@github/copilot-sdk";
import { EXPERIENCE_SKILL, isExperienceSkillRead } from "./checks.ts";
import { classifyError, errorText, retryServiceError, type FailureKind } from "./failure.ts";
import type { PluginSource } from "./project.ts";
import { decide, keyText, lastQuestion, nextUnused, normalize, spentReply, textAfterAnswers } from "./replies.ts";
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

export type DriveOutcome = "ended" | "unmatched-question" | "repeated-question" | "turn-limit" | "timeout" | "error";

export interface DriveResult {
  outcome: DriveOutcome;
  turns: number;
  rejected: Rejection[];
  warnings: Warning[];
  usage: Usage;
  usedReplies: number[];
  skillsInvoked: string[];
  /** Skills invoked before the first output the person sees; every skill invoked when nothing was shown. */
  skillsBeforeOutput: string[];
  unmatched?: string;
  /** The unmatched question was answered earlier in the attempt with this reply. */
  respent?: { question: string; reply: string };
  repeated?: { question: string; count: number };
  error?: { kind: FailureKind; message: string };
  lastMessage: string;
}

export type FallbackPicker = (message: string, candidates: number[]) => Promise<number | undefined>;

export interface DriveOptions {
  scenario: Scenario;
  projectDir: string;
  copilotHome: string;
  plugin: PluginSource;
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

/**
 * FR-008: reads and writes inside the project; URLs only with `web: yes`; everything else rejected.
 * Reads are also approved inside each read root, where the installed plugin's skills sit; a write
 * there is an outside write.
 */
export function permissionPolicy(request: PermissionRequest, projectDir: string, web: boolean, readRoots: readonly string[] = []): PolicyDecision {
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
      if (insideProject(projectDir, path) || readRoots.some((root) => insideProject(root, path))) {
        return { result: approve, summary: `approved read: ${path}` };
      }
      const feedback =
        readRoots.length > 0
          ? "Reads are available inside the project and the installed plugin only. Check that the path was copied exactly."
          : "Reads outside the project are not available in this session.";
      return reject("read", path, false, feedback);
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

/** The part of the client's plugin RPC an install uses. */
export interface PluginRpc {
  install(params: { source: string; workingDirectory?: string }): Promise<{
    plugin: { name: string; enabled: boolean };
    skillsInstalled: number;
    warnings?: string[];
    deprecationWarning?: string;
  }>;
  enable(params: { names: string[]; workingDirectory?: string }): Promise<void>;
  list(): Promise<{ plugins: { name: string; enabled: boolean }[] }>;
}

export type InstallOutcome = { ok: true; summary: string; notes: string[] } | { ok: false; message: string };

/**
 * FR-013 and FR-021: installs the plugin into the attempt's agent home through the client's plugin
 * install. A throw, a warning, a skill count short of the build's, or a plugin left disabled fails
 * the attempt. A deprecation warning is only noted: every local-path install carries one.
 */
export async function installPlugin(rpc: PluginRpc, plugin: PluginSource, projectDir: string): Promise<InstallOutcome> {
  let installed: Awaited<ReturnType<PluginRpc["install"]>>;
  try {
    installed = await rpc.install({ source: plugin.dir, workingDirectory: projectDir });
  } catch (error) {
    return { ok: false, message: `plugin ${plugin.name}: the install failed: ${errorText(error)}` };
  }
  const problems: string[] = [];
  const name = installed.plugin.name;
  if (name !== plugin.name) problems.push(`installed as ${name}`);
  if (installed.skillsInstalled !== plugin.skills) problems.push(`${installed.skillsInstalled} of ${plugin.skills} skills installed`);
  for (const warning of installed.warnings ?? []) problems.push(`warning: ${warning}`);
  if (!installed.plugin.enabled) {
    try {
      await rpc.enable({ names: [name], workingDirectory: projectDir });
      const listed = await rpc.list();
      if (!listed.plugins.some((p) => p.name === name && p.enabled)) problems.push("the plugin is still disabled after enabling it");
    } catch (error) {
      problems.push(`enabling the plugin failed: ${errorText(error)}`);
    }
  }
  if (problems.length > 0) return { ok: false, message: `plugin ${plugin.name}: ${problems.join("; ")}` };
  return {
    ok: true,
    summary: `installed plugin ${name} (${installed.skillsInstalled} skills)`,
    notes: installed.deprecationWarning ? [installed.deprecationWarning] : [],
  };
}

/** A skill's own name: a plugin skill may be reported as `<plugin>:<skill>`. */
export function skillName(data: Record<string, unknown>): string {
  const name = String(data.name ?? data.skillName ?? "skill");
  const plugin = typeof data.pluginName === "string" ? data.pluginName : "";
  return plugin !== "" && name.startsWith(`${plugin}:`) ? name.slice(plugin.length + 1) : name;
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
  const skillsBeforeOutput: string[] = [];
  let outputSeen = false;
  const askedCount = new Map<string, number>();
  let usage = emptyUsage();
  let turn = 0;
  let turnMessages: string[] = [];
  let answeredAt = 0;
  let unmatched: string | undefined;
  let respent: DriveResult["respent"];
  const answered = new Map<string, string>();

  const noReply = (question: string): void => {
    unmatched = question;
    const reply = spentReply(question, answered);
    if (reply !== undefined) respent = { question, reply };
  };

  const pickReply = async (message: string, question: string): Promise<number | undefined> => {
    const decision = decide(message, scenario.replies, used);
    if (decision.type === "reply") return decision.index;
    const candidates = decision.type === "fallback" ? decision.candidates : nextUnused(scenario.replies, used);
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
      skillsBeforeOutput,
      unmatched,
      respent,
      repeated,
      lastMessage: turnMessages.join("\n\n"),
      ...extra,
    };
  };

  try {
    await withRateLimit(() => client.start(), sleep);
    const installed = await installPlugin(client.rpc.plugins, options.plugin, projectDir);
    if (!installed.ok) {
      log({ turn, role: "system", text: installed.message });
      return result("error", { error: { kind: "plugin-install", message: installed.message } });
    }
    log({ turn, role: "system", text: [installed.summary, ...installed.notes].join("\n") });
    const readRoots = [join(options.copilotHome, "installed-plugins")];
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
            const decision = permissionPolicy(request, projectDir, scenario.web, readRoots);
            if (decision.rejection) rejected.push(decision.rejection);
            if (!decision.rejection && request.kind === "read" && !outputSeen && !skillsBeforeOutput.includes(EXPERIENCE_SKILL)) {
              const r = request as unknown as Record<string, unknown>;
              if (isExperienceSkillRead(String(r.resolvedPath ?? r.path ?? ""))) skillsBeforeOutput.push(EXPERIENCE_SKILL);
            }
            log({ turn, role: "permission", text: decision.summary });
            return decision.result;
          },
          onUserInputRequest: async (request) => {
            outputSeen = true;
            const question = request.question;
            log({ turn, role: "question", text: [question, ...(request.choices ?? []).map((c, i) => `${i + 1}. ${c}`)].join("\n") });
            const index = await pickReply(question, lastQuestion(question));
            if (index === undefined) {
              noReply(lastQuestion(question));
              log({ turn, role: "answer", text: "(no keyed reply; the scenario fails here)" });
              return { answer: "Stop here.", wasFreeform: true };
            }
            used.add(index);
            const answer = scenario.replies[index].say;
            answered.set(normalize(lastQuestion(question)), answer);
            answeredAt = turnMessages.length;
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
          if (!data.parentToolCallId && typeof data.content === "string" && data.content.trim() !== "") {
            turnMessages.push(data.content);
            if (!Array.isArray(data.toolRequests) || data.toolRequests.length === 0) outputSeen = true;
          }
          break;
        case "assistant.usage":
          usage = addUsage(usage, usageFrom(data));
          break;
        case "skill.invoked": {
          const name = skillName(data);
          skillsInvoked.push(name);
          if (!outputSeen) skillsBeforeOutput.push(name);
          log({ turn, role: "skill", text: `invoked ${name}` });
          break;
        }
        case "session.error":
          log({ turn, role: "system", text: `session error: ${String(data.message ?? data.errorType ?? "")}` });
          break;
      }
    });

    const stuck = (): DriveResult => result(respent ? "repeated-question" : "unmatched-question");
    let message = scenario.open;
    while (true) {
      if (unmatched) return stuck();
      if (turn >= options.maxTurns) return result("turn-limit");
      const remaining = deadline - Date.now();
      if (remaining <= 0) return result("timeout");
      turn++;
      turnMessages = [];
      answeredAt = 0;
      log({ turn, role: "user", text: message });

      const prompt = message;
      let timer: NodeJS.Timeout | undefined;
      const timeout = new Promise<never>((_, fail) => {
        timer = setTimeout(() => fail(new Timeout("attempt time limit")), remaining);
      });
      try {
        const send = (): Promise<unknown> => withRateLimit(() => session!.sendAndWait({ prompt }, Math.max(1, deadline - Date.now())), sleep);
        const retried = retryServiceError(send, () => {
          log({ turn, role: "system", text: "retrying turn after service error" });
          turnMessages = [];
          answeredAt = 0;
        });
        await Promise.race([retried, timeout]);
      } catch (error) {
        if (error instanceof Timeout || /timeout|timed out/i.test(errorText(error))) return result("timeout");
        throw error;
      } finally {
        clearTimeout(timer);
      }

      log({ turn, role: "agent", text: turnMessages.join("\n\n") });
      if (unmatched) return stuck();

      const text = textAfterAnswers(turnMessages, answeredAt);
      const decision = decide(text, scenario.replies, used);
      if (decision.type === "end") return result("ended");
      const question = lastQuestion(text);
      askedCount.set(question, (askedCount.get(question) ?? 0) + 1);
      const index = decision.type === "reply" ? decision.index : await pickReply(text, question);
      if (index === undefined) {
        noReply(question);
        return stuck();
      }
      used.add(index);
      message = scenario.replies[index].say;
      answered.set(normalize(question), message);
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
