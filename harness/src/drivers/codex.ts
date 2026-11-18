import { cpSync, existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { isAbsolute, join, resolve, sep } from "node:path";
import { Codex, type CodexOptions, type ThreadEvent, type ThreadOptions } from "@openai/codex-sdk";
import { EXPERIENCE_SKILL, isExperienceSkillRead } from "../checks.ts";
import { HARNESS_DIR } from "../config.ts";
import {
  addUsage,
  emptyUsage,
  insideProject,
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
const MARKETPLACE_NAME = "highway-local";

export function classifyCodexError(error: unknown): FailureKind {
  const text = errorText(error).toLowerCase();
  if (/premium[- ]request|quota|allowance|usage limit/.test(text)) return "allowance";
  if (/\b429\b|rate[- ]?limit|too many requests/.test(text)) return "rate-limit";
  if (/\b(401|403)\b|unauthori[sz]ed|forbidden|invalid api key|authentication|api key/.test(text)) return "no-access";
  if (/no response|service unavailable|econnreset|etimedout|network/.test(text)) return "service-error";
  return "unclassified";
}

export function codexVersions(): { sdk: string; runtime: string } {
  try {
    const pkg = JSON.parse(readFileSync(join(HARNESS_DIR, "node_modules", "@openai", "codex-sdk", "package.json"), "utf8")) as {
      version: string;
    };
    return { sdk: pkg.version, runtime: "cli" };
  } catch {
    return { sdk: "unknown", runtime: "cli" };
  }
}

function readPluginName(pluginDir: string, fallback: string): string {
  for (const rel of [".codex-plugin/plugin.json", "plugin.json"]) {
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

/** Remap collapsed plugin paths onto the attempt install read root. */
export function normalizeCodexPluginPath(path: string, readRoot: string): string {
  if (!path || !readRoot) return path;
  const normalized = path.replace(/\\/g, "/");
  const idx = normalized.toLowerCase().indexOf(PLUGIN_MARKER);
  if (idx < 0) return path;
  const suffix = normalized.slice(idx + PLUGIN_MARKER.length);
  return join(readRoot, suffix);
}

export function skillIdFromCodexPath(path: string): string | undefined {
  const fromPath = /(?:^|\/)skills\/(highway-[a-z0-9-]+)(?:\/|$)/i.exec(path.replace(/\\/g, "/"));
  return fromPath ? fromPath[1].toLowerCase() : undefined;
}

const INTERPRETER_PATHS = new Set([
  "/bin/sh",
  "/bin/bash",
  "/bin/zsh",
  "/usr/bin/sh",
  "/usr/bin/bash",
  "/usr/bin/zsh",
  "/usr/bin/env",
  "/bin/dash",
]);

/**
 * Prefer the script body of `/bin/zsh -lc '…'` / `bash -c "…"` so path and git checks see the
 * real command, not the interpreter absolute path (which is outside the project).
 */
export function unwrapShellScript(command: string): string {
  const m = command.match(/^\s*(?:\/(?:usr\/)?bin\/(?:env\s+)?(?:ba|z|da)?sh|[ba]?sh|zsh)\s+(?:-[a-zA-Z]*c[a-zA-Z]*|--command)\s+(.*)$/s);
  if (!m) return command;
  let body = m[1].trim();
  if ((body.startsWith("'") && body.endsWith("'")) || (body.startsWith('"') && body.endsWith('"'))) {
    body = body.slice(1, -1);
  }
  return body || command;
}

/** Extract likely path tokens from a shell command for outside-project checks. */
export function pathsInCommand(command: string): string[] {
  const out: string[] = [];
  const re = /(?:^|[\s="'])(\/[^\s"'`;|&]+|\.\.?\/[^\s"'`;|&]+|[A-Za-z]:\\[^\s"'`;|&]+)/g;
  let m: RegExpExecArray | null;
  while ((m = re.exec(command)) !== null) {
    const p = m[1];
    if (INTERPRETER_PATHS.has(p)) continue;
    out.push(p);
  }
  return out;
}

function isGitCommand(command: string): boolean {
  const body = unwrapShellScript(command);
  return /(^|[;&|]\s*|\/)git(?:\s|$)/i.test(body.trim()) || /\bgit\s+(status|add|commit|push|pull|clone|checkout|init|diff|log)\b/i.test(body);
}

function isNetworkInstall(command: string): boolean {
  if (/\b(curl|wget)\b/i.test(command) && /\bhttps?:\/\//i.test(command)) return true;
  if (/\bnpm\s+(install|i|add|update)\b/i.test(command) && !/--offline\b|--cache\b|file:/i.test(command)) return true;
  if (/\bpip(?:3)?\s+install\b/i.test(command) && !/--no-index\b|--find-links\b/i.test(command)) return true;
  if (/\byarn\s+add\b|\bpnpm\s+add\b|\bbun\s+add\b/i.test(command)) return true;
  return false;
}

function isBuildOrTest(command: string): boolean {
  return /\b(npm|npx|node|tsc|python(?:3)?|pytest|cargo|go|make|mvn|gradle|jest|vitest)\b/i.test(command);
}

/**
 * Effects-based Codex shell classification (FR-001 / FR-008).
 * Allow in-project R/W effects, reads under install read roots, and in-project build/test;
 * fail git, outside paths, network installs.
 */
export function classifyCodexShell(
  command: string,
  projectDir: string,
  readRoots: readonly string[] = [],
): AccessDecisionLite {
  const raw = command.trim();
  if (!raw) {
    return {
      approved: false,
      rejection: { kind: "shell", detail: command, fatal: true },
      summary: "rejected shell: empty",
    };
  }
  const cmd = unwrapShellScript(raw);
  if (isGitCommand(raw) || isGitCommand(cmd)) {
    return {
      approved: false,
      rejection: { kind: "shell", detail: raw, fatal: true },
      summary: `rejected shell (git): ${raw}`,
    };
  }
  if (isNetworkInstall(cmd) || isNetworkInstall(raw)) {
    return {
      approved: false,
      rejection: { kind: "shell", detail: raw, fatal: true },
      summary: `rejected shell (network-install): ${raw}`,
    };
  }
  for (const p of pathsInCommand(cmd)) {
    if (p === "/" || p === "//" || p === "." || p === "..") continue;
    const inProject = insideProject(projectDir, p);
    const inRoot = readRoots.some((root) => insideProject(root, p));
    if (!inProject && !inRoot) {
      return {
        approved: false,
        rejection: { kind: "outside-write", detail: p, fatal: true },
        summary: `rejected shell (outside path): ${p}`,
      };
    }
  }
  // In-project cat/head/cp/mv/sed/echo redirects and build/test interpreters are allowed.
  if (isBuildOrTest(cmd) || /\b(cat|head|tail|cp|mv|mkdir|rm|touch|sed|awk|printf|echo|ls|find|rg|grep|diff|tee|pwd|printf)\b/i.test(cmd)) {
    return { approved: true, summary: `approved shell: ${raw}` };
  }
  // Remaining shell: allow only when no absolute outside path was found (workspace-relative).
  return { approved: true, summary: `approved shell: ${raw}` };
}

type AccessDecisionLite = {
  approved: boolean;
  rejection?: Rejection;
  summary: string;
};

/** Map a Codex item to AccessRequest(s) for logging; shell uses classifyCodexShell separately. */
export function itemToAccessRequests(item: { type: string; command?: string; changes?: { path: string; kind: string }[]; query?: string }): AccessRequest[] {
  if (item.type === "command_execution") return [{ kind: "shell", command: item.command ?? "command" }];
  if (item.type === "file_change" && Array.isArray(item.changes)) {
    return item.changes.map((c) => ({
      kind: c.kind === "delete" || c.kind === "add" || c.kind === "update" ? ("write" as const) : ("write" as const),
      path: c.path,
    }));
  }
  if (item.type === "web_search") return [{ kind: "url", url: item.query ?? "search" }];
  return [];
}

export function pluginDirUnderHome(agentHome: string, name = "highway"): string {
  return join(agentHome, "plugins", name);
}

/** Filesystem PluginRpc: stage Highway under throwaway CODEX_HOME and register a local marketplace. */
export function codexPluginRpc(agentHome: string): PluginRpc {
  const dest = pluginDirUnderHome(agentHome);
  return {
    async install(params) {
      mkdirSync(join(agentHome, "plugins"), { recursive: true });
      const name = readPluginName(params.source, "highway");
      const target = pluginDirUnderHome(agentHome, name);
      rmSync(target, { recursive: true, force: true });
      cpSync(params.source, target, { recursive: true });
      const marketDir = join(agentHome, ".agents", "plugins");
      mkdirSync(marketDir, { recursive: true });
      writeFileSync(
        join(marketDir, "marketplace.json"),
        JSON.stringify(
          {
            name: MARKETPLACE_NAME,
            interface: { displayName: "Highway local" },
            plugins: [
              {
                name,
                source: { source: "local", path: `../../plugins/${name}` },
                policy: { installation: "INSTALLED_BY_DEFAULT", authentication: "ON_INSTALL" },
                category: "Developer Tools",
              },
            ],
          },
          null,
          2,
        ),
      );
      // Prefer features.plugins on so skills load; path is relative to CODEX_HOME.
      writeFileSync(
        join(agentHome, "config.toml"),
        [
          "[features]",
          "plugins = true",
          "",
          `[plugins."${name}@${MARKETPLACE_NAME}"]`,
          "enabled = true",
          "",
        ].join("\n"),
      );
      return {
        plugin: { name, enabled: true },
        skillsInstalled: countSkills(target),
      };
    },
    async enable(params) {
      for (const name of params.names) {
        if (!existsSync(pluginDirUnderHome(agentHome, name))) throw new Error(`plugin ${name} is not installed`);
      }
    },
    async list() {
      if (!existsSync(join(agentHome, "plugins"))) return { plugins: [] };
      const plugins = readdirSync(join(agentHome, "plugins"), { withFileTypes: true })
        .filter((e) => e.isDirectory() && e.name !== "cache")
        .map((e) => ({ name: e.name, enabled: true }));
      return { plugins };
    },
  };
}

function usageFrom(raw: unknown): Partial<Usage> {
  const num = (v: unknown): number => (typeof v === "number" && Number.isFinite(v) ? v : 0);
  if (!raw || typeof raw !== "object") return {};
  const u = raw as Record<string, unknown>;
  return {
    calls: 1,
    inputTokens: num(u.input_tokens ?? u.inputTokens),
    outputTokens: num(u.output_tokens ?? u.outputTokens),
    cacheReadTokens: num(u.cached_input_tokens ?? u.cacheReadTokens),
    cacheWriteTokens: num(u.cache_write_input_tokens ?? u.cacheWriteTokens),
  };
}

function controlledEnv(agentHome: string, key: string): Record<string, string> {
  const path = process.env.PATH ?? "/usr/bin:/bin";
  return {
    HOME: agentHome,
    CODEX_HOME: agentHome,
    PATH: path,
    OPENAI_API_KEY: key,
    CODEX_API_KEY: key,
    // Keep locale/timezone minimal; do not inherit personal CODEX_* or AGENTS.md homes.
    LANG: process.env.LANG ?? "en_US.UTF-8",
  };
}

export type CodexClient = {
  startThread: (options?: ThreadOptions) => {
    runStreamed: (input: string) => Promise<{ events: AsyncGenerator<ThreadEvent> }>;
    run?: (input: string) => Promise<{ finalResponse: string; items: unknown[]; usage: unknown }>;
  };
};

export type CodexApi = {
  create: (options?: CodexOptions) => CodexClient;
};

const defaultApi: CodexApi = {
  create: (options) => new Codex(options) as unknown as CodexClient,
};

/** One-shot text ask with no plugin, for judge / reply fallback (R9). */
export function codexAsk(key: string, model: string, api: CodexApi = defaultApi): Ask {
  return async (prompt) => {
    const home = mkdtempSync(join(tmpdir(), "hcj-"));
    try {
      const client = api.create({
        apiKey: key,
        env: controlledEnv(home, key),
        config: {
          features: { plugins: false },
        },
      });
      const thread = client.startThread({
        model,
        workingDirectory: home,
        skipGitRepoCheck: true,
        sandboxMode: "read-only",
        networkAccessEnabled: false,
        approvalPolicy: "never",
        webSearchMode: "disabled",
      });
      const streamed = await withRateLimit(() => thread.runStreamed(prompt), classifyCodexError);
      let text = "";
      for await (const event of streamed.events) {
        if (event.type === "item.completed" && event.item.type === "agent_message") text = event.item.text;
      }
      return text;
    } finally {
      rmSync(home, { recursive: true, force: true });
    }
  };
}

class Timeout extends Error {}

function threadOptions(projectDir: string, model: string, web: boolean): ThreadOptions {
  return {
    model,
    workingDirectory: projectDir,
    skipGitRepoCheck: true,
    sandboxMode: "workspace-write",
    networkAccessEnabled: false,
    approvalPolicy: "never",
    webSearchMode: web ? "live" : "disabled",
    webSearchEnabled: web,
  };
}

/** Codex CLI driver (Phase 9 / FR-005–FR-010). */
export function createCodexDriver(api: CodexApi = defaultApi): Driver {
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

    const noteAccess = (access: AccessRequest, status: string): void => {
      const readRoot = options.readRoots[0] ?? "";
      if ((access.kind === "read" || access.kind === "write") && access.path) {
        access.path = normalizeCodexPluginPath(access.path, readRoot);
      }
      let decision: AccessDecisionLite;
      if (access.kind === "shell") {
        decision = classifyCodexShell(access.command ?? "", projectDir, options.readRoots);
      } else {
        const full = permissionPolicy(access, projectDir, scenario.web, options.readRoots);
        decision = { approved: full.approved, rejection: full.rejection, summary: full.summary };
      }
      if (decision.rejection) rejected.push(decision.rejection);
      if (decision.approved && access.kind === "read" && !outputSeen && !skillsBeforeOutput.includes(EXPERIENCE_SKILL)) {
        if (isExperienceSkillRead(access.path ?? "")) skillsBeforeOutput.push(EXPERIENCE_SKILL);
      }
      if (decision.approved && access.kind === "write" && access.path && !outputSeen) {
        const skill = skillIdFromCodexPath(access.path);
        // writes to SKILL.md still count as path-based skill reads for experience order when reading
      }
      log({ turn, role: "permission", text: decision.summary });
      if (!decision.approved && decision.rejection?.fatal && (status === "completed" || status === "failed" || status === "")) {
        effectsFatalMessage = `storage invariant violated after tool ran: ${decision.rejection.kind}: ${decision.rejection.detail}`;
      }
      const skillPath = access.path ?? access.command ?? "";
      const skill = skillIdFromCodexPath(skillPath);
      if (skill) {
        skillsInvoked.push(skill);
        if (!outputSeen && !skillsBeforeOutput.includes(skill)) skillsBeforeOutput.push(skill);
        log({ turn, role: "skill", text: `invoked ${skill}` });
      } else if (access.kind === "shell" && /SKILL\.md/i.test(access.command ?? "")) {
        const fromCmd = skillIdFromCodexPath(access.command ?? "");
        if (fromCmd) {
          skillsInvoked.push(fromCmd);
          if (!outputSeen && !skillsBeforeOutput.includes(fromCmd)) skillsBeforeOutput.push(fromCmd);
          log({ turn, role: "skill", text: `invoked ${fromCmd}` });
          if (fromCmd === EXPERIENCE_SKILL && !outputSeen && !skillsBeforeOutput.includes(EXPERIENCE_SKILL)) {
            skillsBeforeOutput.push(EXPERIENCE_SKILL);
          }
        }
      }
      if (access.kind === "read" && access.path && isExperienceSkillRead(access.path) && !outputSeen) {
        if (!skillsBeforeOutput.includes(EXPERIENCE_SKILL)) skillsBeforeOutput.push(EXPERIENCE_SKILL);
      }
    };

    try {
      const installed = await installPlugin(codexPluginRpc(options.agentHome), options.plugin, projectDir);
      if (!installed.ok) {
        log({ turn, role: "system", text: installed.message });
        return result("error", { error: { kind: "plugin-install", message: installed.message } });
      }
      log({ turn, role: "system", text: [installed.summary, ...installed.notes].join("\n") });

      const client = api.create({
        apiKey: options.key,
        env: controlledEnv(options.agentHome, options.key),
        config: {
          features: { plugins: true },
          sandbox_workspace_write: { network_access: false },
        },
      });
      const thread = client.startThread(threadOptions(projectDir, options.model, scenario.web));

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
            const streamed = await withRateLimit(() => thread.runStreamed(message), classifyCodexError, sleep);
            for await (const event of streamed.events) {
              raw(event);
              if (!event || typeof event !== "object") continue;
              switch (event.type) {
                case "item.completed":
                case "item.started":
                case "item.updated": {
                  const item = event.item;
                  if (item.type === "agent_message") {
                    if (event.type === "item.completed") turnMessages = [item.text];
                    else if (item.text) {
                      if (turnMessages.length === 0) turnMessages.push(item.text);
                      else turnMessages[turnMessages.length - 1] = item.text;
                    }
                  } else if (item.type === "command_execution") {
                    const status = item.status === "in_progress" ? "running" : item.status;
                    noteAccess({ kind: "shell", command: item.command }, status);
                    // Shell that cats SKILL.md: also treat as read for experience order.
                    for (const p of pathsInCommand(item.command)) {
                      const mapped = normalizeCodexPluginPath(p, options.readRoots[0] ?? "");
                      if (isExperienceSkillRead(mapped) || skillIdFromCodexPath(mapped)) {
                        noteAccess({ kind: "read", path: mapped }, status);
                      }
                    }
                  } else if (item.type === "file_change") {
                    for (const change of item.changes) {
                      const mapped = normalizeCodexPluginPath(change.path, options.readRoots[0] ?? "");
                      const underRoot = options.readRoots.some((root) => insideProject(root, mapped));
                      // Plugin-tree touches are skill reads for experience-order; project patches stay writes.
                      noteAccess(
                        underRoot ? { kind: "read", path: mapped } : { kind: "write", path: change.path },
                        item.status,
                      );
                    }
                  } else if (item.type === "web_search") {
                    noteAccess({ kind: "url", url: item.query }, "completed");
                  } else if (item.type === "error") {
                    log({ turn, role: "system", text: item.message });
                  }
                  break;
                }
                case "turn.completed": {
                  if (event.usage) usage = addUsage(usage, usageFrom(event.usage));
                  break;
                }
                case "turn.failed": {
                  throw new Error(event.error.message);
                }
                case "error": {
                  throw new Error(event.message);
                }
                default:
                  break;
              }
            }
          };
          const retried = retryServiceError(send, classifyCodexError, () => {
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
      const kind = classifyCodexError(error);
      if (kind === "no-access") throw new RunStop("no-access", errorText(error));
      return result("error", { error: { kind, message: errorText(error) } });
    }
  };
}

export const codexDriver: Driver = createCodexDriver();

/** Test helper: install checks against a temp home (no live SDK). */
export async function installCodexPluginForTest(agentHome: string, plugin: PluginSource, projectDir: string) {
  return installPlugin(codexPluginRpc(agentHome), plugin, projectDir);
}

/** Path helpers used by tests. */
export function resolveUnderProject(projectDir: string, path: string): string {
  return isAbsolute(path) ? resolve(path) : resolve(projectDir, path);
}

export function pathIsInside(projectDir: string, path: string): boolean {
  const full = resolveUnderProject(projectDir, path);
  const root = resolve(projectDir);
  return full === root || full.startsWith(root + sep);
}
