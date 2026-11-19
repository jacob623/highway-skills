import { cpSync, existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join, resolve, sep, isAbsolute } from "node:path";
import { query as sdkQuery, type Options as SdkOptions, type SDKMessage } from "@anthropic-ai/claude-agent-sdk";
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

const PLUGIN_MARKER = "/plugins/highway/";

/** Short Local-mode guidance for the throwaway home only (not the operator's personal CLAUDE.md). */
export const CLAUDE_LOCAL_GUIDANCE = `# Highway harness — Local mode

- Prefer Read, Write, Edit, Glob, and Grep for in-project listing and file work.
- Do not use Bash for exploration or file I/O; the harness refuses every Bash request and the attempt fails.
- Stay inside the project root; do not read or write outside it; do not use memory.
- Load and follow Highway skills; activate \`highway-experience\` before person-visible output when the scenario requires it.
`;

/** Optional Bash deny text naming file tools (does not soften the refuse). */
export const CLAUDE_BASH_DENY_MESSAGE =
  "Bash is not available in this session. Use Read, Write, Edit, Glob, or Grep for in-project file work instead.";

/**
 * Write Local-mode / no-Bash CLAUDE.md into a throwaway agent home.
 * Must not copy from the operator's personal ~/.claude.
 */
export function prepareClaudeAgentHome(agentHome: string): void {
  const dir = join(agentHome, ".claude");
  mkdirSync(dir, { recursive: true });
  writeFileSync(join(dir, "CLAUDE.md"), CLAUDE_LOCAL_GUIDANCE);
}

export function classifyClaudeError(error: unknown): FailureKind {
  const text = errorText(error).toLowerCase();
  if (/premium[- ]request|quota|allowance|usage limit|billing|credit/.test(text)) return "allowance";
  if (/\b429\b|rate[- ]?limit|too many requests|overload|overloaded/.test(text)) return "rate-limit";
  if (/\b(401|403)\b|unauthori[sz]ed|forbidden|invalid api key|authentication|api.?key/.test(text)) return "no-access";
  if (/no response|service unavailable|econnreset|etimedout|network/.test(text)) return "service-error";
  return "unclassified";
}

function pathFromInput(input: Record<string, unknown>): string {
  for (const key of ["file_path", "filePath", "path", "target", "filename", "fileName", "uri", "target_directory", "targetDirectory"]) {
    if (typeof input[key] === "string" && input[key]) return String(input[key]);
  }
  if (typeof input.pattern === "string" && input.pattern) return ".";
  return "";
}

function commandFromInput(input: Record<string, unknown>): string {
  if (typeof input.command === "string") return input.command;
  if (typeof input.cmd === "string") return input.cmd;
  return "command";
}

/** Maps a Claude Code tool name/input to the shared AccessRequest (FR-007 / R3). */
export function toolToAccessRequest(toolName: string, input: Record<string, unknown> = {}): AccessRequest {
  const n = toolName.toLowerCase();
  if (n === "bash" || n.includes("bash")) return { kind: "shell", command: commandFromInput(input) };
  if (n === "read") return { kind: "read", path: pathFromInput(input) };
  if (n === "glob" || n === "grep") return { kind: "read", path: pathFromInput(input) || "." };
  if (n === "write" || n === "edit" || n === "notebookedit") return { kind: "write", path: pathFromInput(input) };
  if (n.includes("memory")) return { kind: "memory", detail: String(input.fact ?? toolName) };
  if (n === "webfetch" || n === "websearch") {
    return { kind: "url", url: String(input.url ?? input.query ?? toolName) };
  }
  if (n === "askuserquestion") return { kind: "other", tool: toolName, detail: "AskUserQuestion" };
  if (n === "skill") return { kind: "other", tool: toolName, detail: String(input.skill ?? input.name ?? "Skill") };
  return { kind: "other", tool: toolName, detail: toolName };
}

/**
 * Skill id from a Claude tool use. Prefer Skill tool args; also `/highway:id`, `highway:id`,
 * and `skills/highway-…/` paths.
 */
export function skillIdFromClaudeTool(toolName: string, input: Record<string, unknown> = {}): string | undefined {
  for (const key of ["skill", "skillName", "skillId", "skill_id", "name", "command"]) {
    const v = input[key];
    if (typeof v === "string") {
      const m = /(?:^|\/|:)(highway-[a-z0-9-]+)$/i.exec(v.trim());
      if (m) return m[1].toLowerCase();
      if (/^highway-[a-z0-9-]+$/i.test(v)) return v.toLowerCase();
    }
  }
  if (/^highway-[a-z0-9-]+$/i.test(toolName)) return toolName.toLowerCase();
  const path = pathFromInput(input);
  const fromPath = /(?:^|\/)skills\/(highway-[a-z0-9-]+)(?:\/|$)/i.exec(path.replace(/\\/g, "/"));
  if (fromPath) return fromPath[1].toLowerCase();
  return undefined;
}

/** Remap workspace-rooted plugin paths onto the attempt install read root (R2). */
export function normalizeClaudePluginPath(path: string, readRoot: string): string {
  if (!path || !readRoot) return path;
  const normalized = path.replace(/\\/g, "/");
  const idx = normalized.toLowerCase().indexOf(PLUGIN_MARKER);
  if (idx < 0) return path;
  const suffix = normalized.slice(idx + PLUGIN_MARKER.length);
  return join(readRoot, suffix);
}

export function claudeVersions(): { sdk: string; runtime: string } {
  try {
    const pkg = JSON.parse(
      readFileSync(join(HARNESS_DIR, "node_modules", "@anthropic-ai", "claude-agent-sdk", "package.json"), "utf8"),
    ) as { version: string };
    return { sdk: pkg.version, runtime: "cli" };
  } catch {
    return { sdk: "unknown", runtime: "cli" };
  }
}

export function claudeReadRoots(agentHome: string): string[] {
  return [join(agentHome, "plugins", "highway")];
}

function readPluginName(pluginDir: string, fallback: string): string {
  for (const rel of [".claude-plugin/plugin.json", "plugin.json"]) {
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

/** Filesystem PluginRpc: copy into plugins/highway under the throwaway home (R2). */
export function claudePluginRpc(agentHome: string): PluginRpc {
  const dest = join(agentHome, "plugins", "highway");
  return {
    async install(params) {
      mkdirSync(join(agentHome, "plugins"), { recursive: true });
      const name = readPluginName(params.source, "highway");
      rmSync(dest, { recursive: true, force: true });
      cpSync(params.source, dest, { recursive: true });
      return {
        plugin: { name, enabled: true },
        skillsInstalled: countSkills(dest),
      };
    },
    async enable(params) {
      for (const name of params.names) {
        const path = join(agentHome, "plugins", name);
        if (!existsSync(path)) throw new Error(`plugin ${name} is not installed`);
      }
    },
    async list() {
      if (!existsSync(dest)) return { plugins: [] };
      return { plugins: [{ name: readPluginName(dest, "highway"), enabled: true }] };
    },
  };
}

export function controlledClaudeEnv(agentHome: string, key: string): Record<string, string> {
  const configDir = join(agentHome, "claude-config");
  mkdirSync(configDir, { recursive: true });
  const env: Record<string, string> = {};
  for (const [k, v] of Object.entries(process.env)) {
    if (typeof v === "string") env[k] = v;
  }
  env.HOME = agentHome;
  env.CLAUDE_CONFIG_DIR = configDir;
  env.ANTHROPIC_API_KEY = key;
  env.CLAUDE_CODE_DISABLE_AUTO_MEMORY = "1";
  env.ENABLE_CLAUDEAI_MCP_SERVERS = "false";
  return env;
}

function usageFrom(raw: unknown): Partial<Usage> {
  const num = (v: unknown): number => (typeof v === "number" && Number.isFinite(v) ? v : 0);
  if (!raw || typeof raw !== "object") return {};
  const u = raw as Record<string, unknown>;
  return {
    calls: 1,
    inputTokens: num(u.input_tokens ?? u.inputTokens),
    outputTokens: num(u.output_tokens ?? u.outputTokens),
    cacheReadTokens: num(u.cache_read_input_tokens ?? u.cacheReadTokens),
    cacheWriteTokens: num(u.cache_creation_input_tokens ?? u.cacheWriteTokens),
    cost: num(u.total_cost_usd ?? u.cost),
  };
}

function textFromAssistantMessage(message: { content?: unknown }): string {
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

export type ClaudeStreamMessage = {
  type: string;
  subtype?: string;
  session_id?: string;
  message?: { content?: unknown; usage?: unknown };
  result?: string;
  usage?: unknown;
  total_cost_usd?: number;
  is_error?: boolean;
  errors?: string[];
  [key: string]: unknown;
};

export type ClaudeQueryHandle = AsyncIterable<ClaudeStreamMessage> & { close?: () => void };

export type ClaudeApi = {
  query: (params: { prompt: string; options?: SdkOptions }) => ClaudeQueryHandle;
};

const defaultApi: ClaudeApi = {
  query: (params) => sdkQuery(params) as unknown as ClaudeQueryHandle,
};

/** One-shot text ask with no tools / no plugin, for judge / reply fallback (R11). */
export function claudeAsk(key: string, model: string, api: ClaudeApi = defaultApi): Ask {
  return async (prompt) => {
    const home = mkdtempSync(join(tmpdir(), "hcj-"));
    try {
      const handle = await withRateLimit(
        async () =>
          api.query({
            prompt,
            options: {
              model,
              cwd: home,
              settingSources: [],
              tools: [],
              env: controlledClaudeEnv(home, key),
              permissionMode: "dontAsk",
            },
          }),
        classifyClaudeError,
      );
      let text = "";
      try {
        for await (const msg of handle) {
          if (msg.type === "assistant" && msg.message) text = textFromAssistantMessage(msg.message);
          if (msg.type === "result" && typeof msg.result === "string" && msg.result.trim()) text = msg.result;
        }
      } finally {
        handle.close?.();
      }
      return text;
    } finally {
      rmSync(home, { recursive: true, force: true });
    }
  };
}

class Timeout extends Error {}

type QuestionItem = {
  question?: string;
  header?: string;
  options?: { label?: string; description?: string }[];
  multiSelect?: boolean;
};

/**
 * Fill AskUserQuestion answers from unused scenario replies when keys match the question text.
 * Returns updatedInput with answers, or undefined if nothing matched.
 */
export function answerAskUserQuestion(
  input: Record<string, unknown>,
  replies: readonly { key: { type: string; text?: string; pattern?: string }; say: string }[],
  used: Set<number>,
): { updatedInput: Record<string, unknown>; answered: { question: string; replyIndex: number; say: string }[] } | undefined {
  const questions = Array.isArray(input.questions) ? (input.questions as QuestionItem[]) : [];
  if (questions.length === 0) return undefined;
  const answers: Record<string, string> = {};
  const answered: { question: string; replyIndex: number; say: string }[] = [];
  for (const q of questions) {
    const text = typeof q.question === "string" ? q.question : "";
    if (!text) continue;
    const decision = decide(text, replies as never, used);
    if (decision.type !== "reply") continue;
    const say = replies[decision.index].say;
    used.add(decision.index);
    const opts = q.options ?? [];
    const match = opts.find((o) => typeof o.label === "string" && normalize(o.label) === normalize(say));
    answers[text] = match?.label ?? say;
    answered.push({ question: text, replyIndex: decision.index, say });
  }
  if (answered.length === 0) return undefined;
  return {
    updatedInput: { ...input, questions: input.questions, answers },
    answered,
  };
}

/** Claude Code driver (Phase 8 / FR-004–FR-011). */
export function createClaudeDriver(api: ClaudeApi = defaultApi): Driver {
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
    let sessionId: string | undefined;
    const pluginPath = join(options.agentHome, "plugins", "highway");
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

    const noteSkill = (toolName: string, input: Record<string, unknown>, path?: string): void => {
      const skill =
        skillIdFromClaudeTool(toolName, input) ?? (path ? skillIdFromClaudeTool("Read", { path }) : undefined);
      if (skill) {
        skillsInvoked.push(skill);
        if (!outputSeen && !skillsBeforeOutput.includes(skill)) skillsBeforeOutput.push(skill);
        log({ turn, role: "skill", text: `invoked ${skill}` });
      }
      if (path && isExperienceSkillRead(path) && !outputSeen && !skillsBeforeOutput.includes(EXPERIENCE_SKILL)) {
        skillsBeforeOutput.push(EXPERIENCE_SKILL);
      }
    };

    const noteAccess = (
      access: AccessRequest,
      status: string,
      toolName?: string,
      input?: Record<string, unknown>,
    ): ReturnType<typeof permissionPolicy> => {
      const readRoot = options.readRoots[0] ?? pluginPath;
      if ((access.kind === "read" || access.kind === "write") && access.path) {
        access = { ...access, path: normalizeClaudePluginPath(access.path, readRoot) };
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
      noteSkill(toolName ?? access.tool ?? "", input ?? {}, access.path);
      return decision;
    };

    const canUseTool: NonNullable<SdkOptions["canUseTool"]> = async (toolName, input) => {
      raw({ type: "canUseTool", toolName, input });
      if (toolName === "AskUserQuestion" || toolName.toLowerCase() === "askuserquestion") {
        const filled = answerAskUserQuestion(input, scenario.replies, used);
        if (filled) {
          for (const item of filled.answered) {
            log({ turn, role: "question", text: item.question });
            askedCount.set(item.question, (askedCount.get(item.question) ?? 0) + 1);
            log({ turn, role: "answer", text: item.say });
            answered.set(normalize(item.question), item.say);
          }
          answeredAt = turnMessages.length;
          return { behavior: "allow", updatedInput: filled.updatedInput };
        }
        return {
          behavior: "deny",
          message: "No scripted reply matched this AskUserQuestion; the harness will answer on the next turn if needed.",
        };
      }
      const decision = noteAccess(toolToAccessRequest(toolName, input), "prompt", toolName, input);
      if (decision.approved) return { behavior: "allow", updatedInput: input };
      const n = toolName.toLowerCase();
      if (n === "bash" || n.includes("bash")) {
        return { behavior: "deny", message: CLAUDE_BASH_DENY_MESSAGE };
      }
      return { behavior: "deny", message: decision.feedback ?? decision.summary };
    };

    try {
      prepareClaudeAgentHome(options.agentHome);
      const installed = await installPlugin(claudePluginRpc(options.agentHome), options.plugin, projectDir);
      if (!installed.ok) {
        log({ turn, role: "system", text: installed.message });
        return result("error", { error: { kind: "plugin-install", message: installed.message } });
      }
      log({ turn, role: "system", text: [installed.summary, ...installed.notes].join("\n") });

      const baseOptions = (): SdkOptions => ({
        model: options.model,
        cwd: projectDir,
        settingSources: [],
        systemPrompt: { type: "preset", preset: "claude_code", append: CLAUDE_LOCAL_GUIDANCE },
        plugins: [{ type: "local", path: pluginPath }],
        env: controlledClaudeEnv(options.agentHome, options.key),
        canUseTool,
        permissionMode: "default",
        strictMcpConfig: true,
        additionalDirectories: options.readRoots,
      });

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
            const opts: SdkOptions = { ...baseOptions() };
            if (sessionId) opts.resume = sessionId;
            const handle = await withRateLimit(async () => api.query({ prompt: message, options: opts }), classifyClaudeError, sleep);
            try {
              for await (const msg of handle as AsyncIterable<ClaudeStreamMessage | SDKMessage>) {
                raw(msg);
                const m = msg as ClaudeStreamMessage;
                if (typeof m.session_id === "string" && m.session_id) sessionId = m.session_id;
                switch (m.type) {
                  case "assistant": {
                    const text = textFromAssistantMessage((m.message as { content?: unknown }) ?? {});
                    if (text) {
                      if (turnMessages.length === 0) turnMessages.push(text);
                      else turnMessages[turnMessages.length - 1] += text;
                    }
                    const content = (m.message as { content?: unknown } | undefined)?.content;
                    if (Array.isArray(content)) {
                      for (const block of content) {
                        if (!block || typeof block !== "object") continue;
                        const b = block as { type?: string; name?: string; input?: Record<string, unknown> };
                        if (b.type === "tool_use" && typeof b.name === "string") {
                          const access = toolToAccessRequest(b.name, b.input ?? {});
                          // Shell/memory permissions are decided in canUseTool. The assistant
                          // tool_use block often arrives before that callback; treating it as
                          // "completed" falsely trips effects backup after a deny.
                          if (access.kind === "shell" || access.kind === "memory") {
                            continue;
                          }
                          const readRoot = options.readRoots[0] ?? pluginPath;
                          const path =
                            access.path !== undefined ? normalizeClaudePluginPath(access.path, readRoot) : undefined;
                          noteSkill(b.name, b.input ?? {}, path);
                        }
                      }
                    }
                    break;
                  }
                  case "result": {
                    if (m.usage) usage = addUsage(usage, usageFrom(m.usage));
                    if (typeof m.total_cost_usd === "number") usage = addUsage(usage, { cost: m.total_cost_usd });
                    if (typeof m.result === "string" && m.result.trim() && turnMessages.length === 0) {
                      turnMessages = [m.result];
                    }
                    if (m.is_error || (m.subtype && String(m.subtype).startsWith("error"))) {
                      const errText = Array.isArray(m.errors) ? m.errors.join("; ") : String(m.result ?? m.subtype ?? "claude result error");
                      throw new Error(errText);
                    }
                    break;
                  }
                  case "system":
                    if (typeof m.subtype === "string") log({ turn, role: "system", text: `system ${m.subtype}` });
                    break;
                  default:
                    break;
                }
              }
            } finally {
              handle.close?.();
            }
          };
          const retried = retryServiceError(send, classifyClaudeError, () => {
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
    } catch (error) {
      if (error instanceof RunStop) throw error;
      const kind = classifyClaudeError(error);
      if (kind === "no-access") throw new RunStop("no-access", errorText(error));
      return result("error", { error: { kind, message: errorText(error) } });
    }
  };
}

export const claudeDriver: Driver = createClaudeDriver();

/** Test helper: install checks against a temp home (no live SDK). */
export async function installClaudePluginForTest(agentHome: string, plugin: PluginSource, projectDir: string) {
  return installPlugin(claudePluginRpc(agentHome), plugin, projectDir);
}

export function resolveUnderProject(projectDir: string, path: string): string {
  return isAbsolute(path) ? resolve(path) : resolve(projectDir, path);
}

export function pathIsInside(projectDir: string, path: string): boolean {
  const full = resolveUnderProject(projectDir, path);
  const root = resolve(projectDir);
  return full === root || full.startsWith(root + sep);
}
