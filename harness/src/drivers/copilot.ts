import { mkdtempSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { CopilotClient, type CopilotSession, type PermissionRequest, type PermissionRequestResult } from "@github/copilot-sdk";
import { EXPERIENCE_SKILL, isExperienceSkillRead } from "../checks.ts";
import { HARNESS_DIR } from "../config.ts";
import {
  addUsage,
  emptyUsage,
  installPlugin,
  permissionPolicy,
  realSleep,
  RunStop,
  withRateLimit,
  type AccessDecision,
  type AccessRequest,
  type Driver,
  type DriveOutcome,
  type DriveResult,
  type Rejection,
  type Usage,
  type Warning,
} from "../driver.ts";
import { errorText, retryServiceError, type FailureKind } from "../failure.ts";
import type { Ask } from "../judge.ts";
import { decide, keyText, lastQuestion, nextUnused, normalize, spentReply, textAfterAnswers } from "../replies.ts";

/** Classifies a Copilot SDK or CLI error by its message (R11). */
export function classifyCopilotError(error: unknown): FailureKind {
  const text = errorText(error).toLowerCase();
  if (/premium[- ]request|quota|allowance|usage limit/.test(text)) return "allowance";
  if (/\b429\b|rate[- ]?limit|too many requests/.test(text)) return "rate-limit";
  if (/\b(401|403)\b|unauthori[sz]ed|forbidden|not (?:enabled|entitled)|no copilot access|copilot.*(?:access|subscription)/.test(text)) return "no-access";
  if (/-32603|no response was returned/.test(text)) return "service-error";
  return "unclassified";
}

/** Maps a Copilot permission request to the policy's neutral request. */
export function toAccessRequest(request: PermissionRequest): AccessRequest {
  const r = request as unknown as Record<string, unknown>;
  switch (request.kind) {
    case "read":
      return { kind: "read", path: String(r.resolvedPath ?? r.path ?? "") };
    case "write":
      return { kind: "write", path: String(r.resolvedPath ?? r.fileName ?? "") };
    case "shell":
      return { kind: "shell", command: String(r.fullCommandText ?? r.intention ?? "command") };
    case "memory":
      return { kind: "memory", detail: String(r.fact ?? r.intention ?? "memory") };
    case "url":
      return { kind: "url", url: String(r.url ?? r.intention ?? "url") };
    default:
      return { kind: "other", tool: String(request.kind), detail: String(r.toolName ?? r.intention ?? request.kind) };
  }
}

export function toPermissionResult(decision: AccessDecision): PermissionRequestResult {
  return decision.approved ? { kind: "approve-once" } : { kind: "reject", feedback: decision.feedback ?? "" };
}

/** A skill's own name: a plugin skill may be reported as `<plugin>:<skill>`. */
export function skillName(data: Record<string, unknown>): string {
  const name = String(data.name ?? data.skillName ?? "skill");
  const plugin = typeof data.pluginName === "string" ? data.pluginName : "";
  return plugin !== "" && name.startsWith(`${plugin}:`) ? name.slice(plugin.length + 1) : name;
}

export function copilotVersions(): { sdk: string; runtime: string } {
  const base = join(HARNESS_DIR, "node_modules", "@github", "copilot-sdk");
  let sdk = "unknown";
  let runtime = "unknown";
  try {
    sdk = (JSON.parse(readFileSync(join(base, "package.json"), "utf8")) as { version: string }).version;
  } catch {
    // Reported as unknown; the run continues and the header says so.
  }
  try {
    runtime = /COPILOT_CLI_VERSION\s*=\s*"([^"]+)"/.exec(readFileSync(join(base, "dist", "cliVersion.js"), "utf8"))?.[1] ?? "unknown";
  } catch {
    // Reported as unknown, as above.
  }
  return { sdk, runtime };
}

/** One prompt in a new session with no tools, in its own throwaway home, returning the reply text. */
export function copilotAsk(key: string, model: string): Ask {
  return async (prompt) => {
    const home = mkdtempSync(join(tmpdir(), "hj-"));
    const client = new CopilotClient({ baseDirectory: home, gitHubToken: key, useLoggedInUser: false, workingDirectory: home, logLevel: "error" });
    try {
      await withRateLimit(() => client.start(), classifyCopilotError);
      const session = await withRateLimit(
        () =>
          client.createSession({
            model,
            workingDirectory: home,
            clientName: "highway-harness-judge",
            enableConfigDiscovery: false,
            enableSessionStore: false,
            enableSessionTelemetry: false,
            enableSkills: false,
            onPermissionRequest: () => ({ kind: "reject", feedback: "No tools are available. Answer from the text you were given." }),
          }),
        classifyCopilotError,
      );
      try {
        const reply = await withRateLimit(() => session.sendAndWait({ prompt }, 300_000), classifyCopilotError);
        return reply?.data.content ?? "";
      } finally {
        await session.disconnect().catch(() => undefined);
      }
    } finally {
      await client.stop().catch(() => undefined);
      rmSync(home, { recursive: true, force: true });
    }
  };
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
    baseDirectory: options.agentHome,
    gitHubToken: options.key,
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
    await withRateLimit(() => client.start(), classifyCopilotError, sleep);
    const installed = await installPlugin(client.rpc.plugins, options.plugin, projectDir);
    if (!installed.ok) {
      log({ turn, role: "system", text: installed.message });
      return result("error", { error: { kind: "plugin-install", message: installed.message } });
    }
    log({ turn, role: "system", text: [installed.summary, ...installed.notes].join("\n") });
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
            const access = toAccessRequest(request);
            const decision = permissionPolicy(access, projectDir, scenario.web, options.readRoots);
            if (decision.rejection) rejected.push(decision.rejection);
            if (decision.approved && access.kind === "read" && !outputSeen && !skillsBeforeOutput.includes(EXPERIENCE_SKILL)) {
              if (isExperienceSkillRead(access.path ?? "")) skillsBeforeOutput.push(EXPERIENCE_SKILL);
            }
            log({ turn, role: "permission", text: decision.summary });
            return toPermissionResult(decision);
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
      classifyCopilotError,
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
        const send = (): Promise<unknown> => withRateLimit(() => session!.sendAndWait({ prompt }, Math.max(1, deadline - Date.now())), classifyCopilotError, sleep);
        const retried = retryServiceError(send, classifyCopilotError, () => {
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
    const kind = classifyCopilotError(error);
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
      // The temporary agent home is removed by the runner either way.
    }
  }
};
