import { cpSync, existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { Agent, AuthenticationError, CursorAgentError, JsonlLocalAgentStore, RateLimitError, type ToolName } from "@cursor/sdk";
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
  type AccessRequest,
  type Driver,
  type DriveOutcome,
  type DriveResult,
  type PluginRpc,
  type Rejection,
  type Usage,
  type Warning,
} from "../driver.ts";
import { errorText, retryServiceError, type FailureKind } from "../failure.ts";
import type { Ask } from "../judge.ts";
import type { PluginSource } from "../project.ts";
import { decide, keyText, lastQuestion, nextUnused, normalize, spentReply, textAfterAnswers } from "../replies.ts";

/** Serializes HOME overrides so parallel attempts do not race (research R1). */
let homeChain: Promise<unknown> = Promise.resolve();

export async function withCursorHome<T>(home: string, fn: () => Promise<T>): Promise<T> {
  const run = homeChain.then(async () => {
    const prevHome = process.env.HOME;
    const prevData = process.env.CURSOR_DATA_DIR;
    process.env.HOME = home;
    process.env.CURSOR_DATA_DIR = home;
    try {
      return await fn();
    } finally {
      if (prevHome === undefined) delete process.env.HOME;
      else process.env.HOME = prevHome;
      if (prevData === undefined) delete process.env.CURSOR_DATA_DIR;
      else process.env.CURSOR_DATA_DIR = prevData;
    }
  });
  homeChain = run.then(
    () => undefined,
    () => undefined,
  );
  return run;
}

export function classifyCursorError(error: unknown): FailureKind {
  if (error instanceof RateLimitError) return "rate-limit";
  if (error instanceof AuthenticationError) return "no-access";
  const text = errorText(error).toLowerCase();
  const retryable = error instanceof CursorAgentError && error.isRetryable;
  if (/premium[- ]request|quota|allowance|usage limit/.test(text)) return "allowance";
  if (retryable || /\b429\b|rate[- ]?limit|too many requests/.test(text)) return "rate-limit";
  if (/\b(401|403)\b|unauthori[sz]ed|forbidden|invalid api key|authentication/.test(text)) return "no-access";
  if (/no response|service unavailable|econnreset|etimedout|network/.test(text)) return "service-error";
  return "unclassified";
}

function pathFromArgs(args: unknown): string {
  if (!args || typeof args !== "object") return "";
  const a = args as Record<string, unknown>;
  for (const key of [
    "path",
    "filePath",
    "file_path",
    "target",
    "filename",
    "fileName",
    "uri",
    "target_directory",
    "targetDirectory",
    "glob",
    "pattern",
  ]) {
    if (typeof a[key] === "string" && a[key]) return String(a[key]);
  }
  if (typeof a.target_file === "string") return a.target_file;
  return "";
}

const PLUGIN_HIGHWAY_MARKER = ".cursor/plugins/local/highway/";

/**
 * Remaps workspace-rooted or collapsed plugin paths onto the attempt's install read root
 * (research R4). Paths without the highway plugin marker are unchanged.
 */
export function normalizeCursorPluginPath(path: string, readRoot: string): string {
  if (!path || !readRoot) return path;
  const normalized = path.replace(/\\/g, "/");
  const idx = normalized.toLowerCase().indexOf(PLUGIN_HIGHWAY_MARKER);
  if (idx < 0) return path;
  const suffix = normalized.slice(idx + PLUGIN_HIGHWAY_MARKER.length);
  return join(readRoot, suffix);
}

/**
 * Skill id from a Cursor tool_call. Prefer `/skills/<id>/` in the path; never treat the
 * `highway/skills` directory name as a skill id (F29 false positive).
 */
export function skillIdFromCursorTool(name: string, args: unknown): string | undefined {
  const a = args && typeof args === "object" ? (args as Record<string, unknown>) : {};
  for (const key of ["skill", "skillName", "skillId", "skill_id", "name"]) {
    const v = a[key];
    if (typeof v === "string" && /^highway-[a-z0-9-]+$/i.test(v)) return v.toLowerCase();
  }
  if (/^highway-[a-z0-9-]+$/i.test(name)) return name.toLowerCase();
  const path = pathFromArgs(args) || "";
  const fromPath = /(?:^|\/)skills\/(highway-[a-z0-9-]+)(?:\/|$)/i.exec(path.replace(/\\/g, "/"));
  if (fromPath) return fromPath[1].toLowerCase();
  return undefined;
}

function commandFromArgs(args: unknown): string {
  if (!args || typeof args !== "object") return "command";
  const a = args as Record<string, unknown>;
  if (typeof a.command === "string") return a.command;
  if (typeof a.cmd === "string") return a.cmd;
  return "command";
}

/** Maps a Cursor tool_call name/args to the shared AccessRequest (FR-007). */
export function toolCallToAccessRequest(name: string, args: unknown): AccessRequest {
  const n = name.toLowerCase();
  if (n === "shell" || n.includes("shell")) return { kind: "shell", command: commandFromArgs(args) };
  if (n === "read" || n.includes("read_file") || n === "readfile") return { kind: "read", path: pathFromArgs(args) };
  // Allowlisted filesystem tools: treat as reads so shared policy can approve project/read-root paths.
  if (n === "glob" || n === "grep" || n === "ls" || n === "semsearch" || n === "readlints") {
    return { kind: "read", path: pathFromArgs(args) || "." };
  }
  if (n === "edit" || n === "write" || n === "delete" || n.includes("write") || n.includes("strreplace") || n.includes("apply_patch")) {
    return { kind: "write", path: pathFromArgs(args) };
  }
  if (n.includes("memory")) return { kind: "memory", detail: String((args as { fact?: string })?.fact ?? name) };
  if (n === "webfetch" || n === "websearch" || n.includes("web_")) {
    const a = (args ?? {}) as Record<string, unknown>;
    return { kind: "url", url: String(a.url ?? a.query ?? name) };
  }
  if (n === "askquestion" || n === "ask_question") return { kind: "other", tool: name, detail: "askQuestion" };
  return { kind: "other", tool: name, detail: name };
}

export function cursorVersions(): { sdk: string; runtime: string } {
  try {
    const pkg = JSON.parse(readFileSync(join(HARNESS_DIR, "node_modules", "@cursor", "sdk", "package.json"), "utf8")) as { version: string };
    return { sdk: pkg.version, runtime: "local" };
  } catch {
    return { sdk: "unknown", runtime: "local" };
  }
}

function readPluginName(pluginDir: string, fallback: string): string {
  for (const rel of [".cursor-plugin/plugin.json", "plugin.json"]) {
    const path = join(pluginDir, rel);
    if (!existsSync(path)) continue;
    try {
      const raw = JSON.parse(readFileSync(path, "utf8")) as { name?: string };
      if (typeof raw.name === "string" && raw.name) return raw.name;
    } catch {
      // Fall through.
    }
  }
  return fallback;
}

function countSkills(pluginDir: string): number {
  const skills = join(pluginDir, "skills");
  if (!existsSync(skills)) return 0;
  return readdirSync(skills, { withFileTypes: true }).filter((e) => e.isDirectory()).length;
}

/** Filesystem PluginRpc: copy into ~/.cursor/plugins/local under the throwaway HOME (R2). */
export function cursorPluginRpc(agentHome: string): PluginRpc {
  const localRoot = join(agentHome, ".cursor", "plugins", "local");
  return {
    async install(params) {
      mkdirSync(localRoot, { recursive: true });
      const name = readPluginName(params.source, "highway");
      const dest = join(localRoot, name);
      rmSync(dest, { recursive: true, force: true });
      cpSync(params.source, dest, { recursive: true });
      return {
        plugin: { name, enabled: true },
        skillsInstalled: countSkills(dest),
      };
    },
    async enable(params) {
      for (const name of params.names) {
        const dest = join(localRoot, name);
        if (!existsSync(dest)) throw new Error(`plugin ${name} is not installed`);
      }
    },
    async list() {
      if (!existsSync(localRoot)) return { plugins: [] };
      const plugins = readdirSync(localRoot, { withFileTypes: true })
        .filter((e) => e.isDirectory())
        .map((e) => ({ name: e.name, enabled: true }));
      return { plugins };
    },
  };
}

/** Deny-shell / path policy hooks under the throwaway HOME (R3). */
export function writeCursorHooks(agentHome: string, projectDir: string, readRoots: readonly string[]): void {
  const hooksDir = join(agentHome, ".cursor", "hooks");
  mkdirSync(hooksDir, { recursive: true });
  const script = join(hooksDir, "policy.mjs");
  const payload = JSON.stringify({ projectDir, readRoots: [...readRoots] });
  writeFileSync(
    script,
    `#!/usr/bin/env node
import { isAbsolute, join, resolve, sep } from "node:path";
const cfg = ${payload};
const roots = [cfg.projectDir, ...cfg.readRoots].map((p) => resolve(p));
const marker = ".cursor/plugins/local/highway/";
const remap = (path) => {
  if (!path) return path;
  const norm = String(path).replace(/\\\\/g, "/");
  const i = norm.toLowerCase().indexOf(marker);
  if (i < 0 || !cfg.readRoots[0]) return path;
  return join(cfg.readRoots[0], norm.slice(i + marker.length));
};
const inside = (path) => {
  if (!path) return false;
  const mapped = remap(path);
  const full = isAbsolute(mapped) ? resolve(mapped) : resolve(cfg.projectDir, mapped);
  return roots.some((root) => full === root || full.startsWith(root + sep));
};
const inProject = (path) => {
  if (!path) return false;
  const full = isAbsolute(path) ? resolve(path) : resolve(cfg.projectDir, path);
  const root = resolve(cfg.projectDir);
  return full === root || full.startsWith(root + sep);
};
let raw = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (c) => (raw += c));
process.stdin.on("end", () => {
  let event = {};
  try { event = JSON.parse(raw || "{}"); } catch { /* deny on bad input */ }
  const tool = String(event.tool_name ?? event.hook_event_name ?? "");
  const args = event.tool_input ?? event.arguments ?? event;
  const path = String(args.path ?? args.file_path ?? args.filePath ?? args.target_file ?? args.target_directory ?? "");
  const deny = (msg) => {
    process.stdout.write(JSON.stringify({ permission: "deny", user_message: msg }));
    process.exit(0);
  };
  if (/shell/i.test(tool) || event.hook_event_name === "beforeShellExecution") {
    deny("Shell commands are not available in this session. Highway skills read and write files only.");
  }
  if (/memory/i.test(tool)) deny("Memory is not available in this session.");
  if (/write|edit|delete|strreplace/i.test(tool) && path && !inProject(path)) {
    deny("Writes outside the project are not available in this session.");
  }
  if (/read|glob|grep|^ls$/i.test(tool) && path && !inside(path) && !inProject(path)) {
    deny("Reads are available inside the project and the installed plugin only.");
  }
  process.stdout.write(JSON.stringify({ permission: "allow" }));
});
`,
  );
  writeFileSync(
    join(agentHome, ".cursor", "hooks.json"),
    JSON.stringify(
      {
        version: 1,
        hooks: {
          beforeShellExecution: [{ command: script }],
          preToolUse: [{ command: script }],
        },
      },
      null,
      2,
    ),
  );
}

function baseTools(web: boolean): ToolName[] {
  const tools: ToolName[] = ["read", "edit", "grep", "glob", "ls", "delete", "updateTodos", "readTodos"];
  if (web) tools.push("webFetch", "webSearch");
  return tools;
}

function usageFrom(raw: unknown): Partial<Usage> {
  const num = (v: unknown): number => (typeof v === "number" && Number.isFinite(v) ? v : 0);
  if (!raw || typeof raw !== "object") return {};
  const u = raw as Record<string, unknown>;
  return {
    calls: 1,
    inputTokens: num(u.inputTokens ?? u.input_tokens ?? u.promptTokens),
    outputTokens: num(u.outputTokens ?? u.output_tokens ?? u.completionTokens),
    cacheReadTokens: num(u.cacheReadTokens ?? u.cache_read_tokens),
    cacheWriteTokens: num(u.cacheWriteTokens ?? u.cache_write_tokens),
    cost: num(u.cost ?? u.totalCost),
  };
}

function textFromAssistant(message: { content?: unknown }): string {
  const content = message.content;
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";
  return content
    .map((block) => {
      if (!block || typeof block !== "object") return "";
      const b = block as { type?: string; text?: string };
      return b.type === "text" && typeof b.text === "string" ? b.text : "";
    })
    .filter(Boolean)
    .join("");
}

export type CursorAgentApi = {
  create: typeof Agent.create;
  prompt: typeof Agent.prompt;
};

const defaultApi: CursorAgentApi = {
  create: (...args) => Agent.create(...args),
  prompt: (...args) => Agent.prompt(...args),
};

/** One-shot text ask with no tools, for judge / reply fallback (R8). */
export function cursorAsk(key: string, model: string, api: CursorAgentApi = defaultApi): Ask {
  return async (prompt) => {
    const home = mkdtempSync(join(tmpdir(), "harness-cursor-judge-"));
    try {
      return await withCursorHome(home, async () => {
        const result = await withRateLimit(
          () =>
            api.prompt(prompt, {
              apiKey: key,
              model: { id: model },
              tools: [],
              local: {
                cwd: home,
                settingSources: [],
                store: new JsonlLocalAgentStore(join(home, "store")),
              },
            }),
          classifyCursorError,
        );
        return result.result ?? "";
      });
    } finally {
      rmSync(home, { recursive: true, force: true });
    }
  };
}

class Timeout extends Error {}

/** Cursor local-runtime driver (Phase 7 / FR-004–FR-011). */
export function createCursorDriver(api: CursorAgentApi = defaultApi): Driver {
  return async (options) => {
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
    let effectsFatalMessage: string | undefined;

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

    const noteTool = (name: string, args: unknown, status: string): void => {
      const access = toolCallToAccessRequest(name, args);
      const readRoot = options.readRoots[0] ?? "";
      if ((access.kind === "read" || access.kind === "write") && access.path) {
        access.path = normalizeCursorPluginPath(access.path, readRoot);
      }
      const decision = permissionPolicy(access, projectDir, scenario.web, options.readRoots);
      if (decision.rejection) rejected.push(decision.rejection);
      if (decision.approved && access.kind === "read" && !outputSeen && !skillsBeforeOutput.includes(EXPERIENCE_SKILL)) {
        if (isExperienceSkillRead(access.path ?? "")) skillsBeforeOutput.push(EXPERIENCE_SKILL);
      }
      log({ turn, role: "permission", text: decision.summary });
      if (!decision.approved && decision.rejection?.fatal && status === "completed") {
        effectsFatalMessage = `storage invariant violated after tool ran: ${decision.rejection.kind}: ${decision.rejection.detail}`;
      }
      const skill =
        skillIdFromCursorTool(name, args) ??
        (access.path ? skillIdFromCursorTool(name, { path: access.path }) : undefined);
      if (skill) {
        skillsInvoked.push(skill);
        if (!outputSeen && !skillsBeforeOutput.includes(skill)) skillsBeforeOutput.push(skill);
        log({ turn, role: "skill", text: `invoked ${skill}` });
      }
    };

    try {
      return await withCursorHome(options.agentHome, async () => {
        writeCursorHooks(options.agentHome, projectDir, options.readRoots);
        const installed = await installPlugin(cursorPluginRpc(options.agentHome), options.plugin, projectDir);
        if (!installed.ok) {
          log({ turn, role: "system", text: installed.message });
          return result("error", { error: { kind: "plugin-install", message: installed.message } });
        }
        log({ turn, role: "system", text: [installed.summary, ...installed.notes].join("\n") });

        const storeDir = join(options.agentHome, "cursor-store");
        mkdirSync(storeDir, { recursive: true });
        const agent = await withRateLimit(
          () =>
            api.create({
              apiKey: options.key,
              model: { id: options.model },
              tools: baseTools(scenario.web),
              local: {
                cwd: projectDir,
                settingSources: ["plugins"],
                store: new JsonlLocalAgentStore(storeDir),
              },
            }),
          classifyCursorError,
          sleep,
        );

        try {
          const stuck = (): DriveResult => result(respent ? "repeated-question" : "unmatched-question");
          let message = scenario.open;
          while (true) {
            if (unmatched) return stuck();
            if (effectsFatalMessage) {
              return result("error", { error: { kind: "unclassified", message: effectsFatalMessage } });
            }
            if (turn >= options.maxTurns) return result("turn-limit");
            const remaining = deadline - Date.now();
            if (remaining <= 0) return result("timeout");
            turn++;
            turnMessages = [];
            answeredAt = 0;
            log({ turn, role: "user", text: message });

            let timer: NodeJS.Timeout | undefined;
            const timeout = new Promise<never>((_, fail) => {
              timer = setTimeout(() => fail(new Timeout("attempt time limit")), remaining);
            });
            try {
              const send = async (): Promise<void> => {
                const run = await withRateLimit(() => agent.send(message), classifyCursorError, sleep);
                for await (const event of run.stream()) {
                  raw(event);
                  if (!event || typeof event !== "object") continue;
                  const e = event as unknown as Record<string, unknown>;
                  switch (e.type) {
                    case "assistant": {
                      // Stream events may be token-sized; append into one buffer per turn.
                      // Do not set outputSeen here: Cursor often emits text tokens before
                      // tool_call events for the same turn, which falsely emptied
                      // skillsBeforeOutput (F29). Commit output after wait + agent log.
                      const text = textFromAssistant((e.message as { content?: unknown }) ?? {});
                      if (text) {
                        if (turnMessages.length === 0) turnMessages.push(text);
                        else turnMessages[turnMessages.length - 1] += text;
                      }
                      break;
                    }
                    case "tool_call": {
                      noteTool(String(e.name ?? "tool"), e.args, String(e.status ?? ""));
                      break;
                    }
                    case "usage": {
                      usage = addUsage(usage, usageFrom(e.usage));
                      break;
                    }
                    case "system":
                      if (typeof e.subtype === "string") log({ turn, role: "system", text: `system ${e.subtype}` });
                      break;
                    default:
                      break;
                  }
                }
                const finished = await run.wait();
                if (finished.usage) usage = addUsage(usage, usageFrom(finished.usage));
                if (finished.status === "error") {
                  throw new Error(finished.error?.message ?? "run status error");
                }
                // Prefer the completed run's final text over streamed chunks (avoids token-sized log bloat).
                if (typeof finished.result === "string" && finished.result.trim() !== "") {
                  turnMessages = [finished.result];
                }
              };
              const retried = retryServiceError(send, classifyCursorError, () => {
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

            const agentText = turnMessages.join("\n\n");
            log({ turn, role: "agent", text: agentText });
            // First person-visible output for experience-order (after this turn's tool_call mapping).
            if (agentText.trim()) outputSeen = true;
            if (effectsFatalMessage) {
              return result("error", { error: { kind: "unclassified", message: effectsFatalMessage } });
            }
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
        } finally {
          await agent[Symbol.asyncDispose]().catch(() => undefined);
        }
      });
    } catch (error) {
      if (error instanceof RunStop) throw error;
      const kind = classifyCursorError(error);
      if (kind === "no-access") throw new RunStop("no-access", errorText(error));
      return result("error", { error: { kind, message: errorText(error) } });
    }
  };
}

export const cursorDriver: Driver = createCursorDriver();

/** Test helper: install checks against a temp home (no live SDK). */
export async function installCursorPluginForTest(agentHome: string, plugin: PluginSource, projectDir: string) {
  return installPlugin(cursorPluginRpc(agentHome), plugin, projectDir);
}
