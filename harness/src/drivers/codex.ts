import { spawnSync } from "node:child_process";
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
/** Cache installs live under `/plugins/cache/<marketplace>/highway/<version>/`. */
const PLUGIN_CACHE_MARKER = `/plugins/cache/highway-local/highway/`;
const MARKETPLACE_NAME = "highway-local";

/** Codex Starlark rules: forbid `git` before run (FR-002 primary lever). */
export const CODEX_GIT_FORBIDDEN_RULES = `# Highway harness Local mode — forbid git before it runs.
prefix_rule(
    pattern = ["git"],
    decision = "forbidden",
    justification = "Local mode: the person owns every git step; do not run git.",
    match = [
        "git status",
        "git status --short",
        "git add .",
        "git commit -m msg",
    ],
    not_match = [
        "npm test",
        "cat README.md",
    ],
)
`;

/** Short Local-mode guidance for the throwaway home only (not the operator's personal AGENTS.md). */
export const CODEX_LOCAL_AGENTS_MD = `# Highway harness — Local mode

- Do not run \`git\` (the person owns every git step).
- Stay inside the project root; do not read or write outside it.
- Do not network-install packages (\`npm install\` from the registry, \`curl\`/\`wget\` installs).
- In-project file reads/writes and in-project build/test through the shell are allowed.
- Load and follow Highway skills; activate \`highway-experience\` before person-visible output when the scenario requires it.
`;

/**
 * Write Codex rules + Local-mode AGENTS.md into a throwaway agent home.
 * Must not copy from the operator's personal ~/.codex or AGENTS.md.
 */
export function prepareCodexAgentHome(agentHome: string): void {
  mkdirSync(join(agentHome, "rules"), { recursive: true });
  writeFileSync(join(agentHome, "rules", "default.rules"), CODEX_GIT_FORBIDDEN_RULES);
  writeFileSync(join(agentHome, "AGENTS.md"), CODEX_LOCAL_AGENTS_MD);
}

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

/** Remap collapsed plugin paths onto the attempt install read root (staged or cache). */
export function normalizeCodexPluginPath(path: string, readRoot: string): string {
  if (!path || !readRoot) return path;
  const normalized = path.replace(/\\/g, "/");
  const lower = normalized.toLowerCase();
  let idx = lower.indexOf(PLUGIN_CACHE_MARKER);
  if (idx >= 0) {
    const after = normalized.slice(idx + PLUGIN_CACHE_MARKER.length);
    const slash = after.indexOf("/");
    const suffix = slash >= 0 ? after.slice(slash + 1) : after;
    return join(readRoot, suffix);
  }
  idx = lower.indexOf(PLUGIN_MARKER);
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
    // Default non-fatal (pre-refuse); applyCodexShellStatus upgrades when status is completed.
    return {
      approved: false,
      rejection: { kind: "shell", detail: raw, fatal: false },
      summary: `denied shell (git, pre-refuse): ${raw}`,
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
    if (isCodexPluginTreePath(p)) continue;
    const resolved = resolve(p);
    if (isCodexPluginTreePath(resolved)) continue;
    const inProject = insideProject(projectDir, p) || insideProject(projectDir, resolved);
    const inRoot = readRoots.some((root) => insideProject(root, p) || insideProject(root, resolved));
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

/**
 * Finalize shell classification using the command_execution status.
 * Git: fatal only when status is `completed` (effects backup); otherwise logged pre-refuse.
 * Other forbidden shells keep their classifyCodexShell fatal flag.
 */
export function applyCodexShellStatus(decision: AccessDecisionLite, status: string): AccessDecisionLite {
  if (decision.approved || !decision.rejection) return decision;
  if (decision.rejection.kind !== "shell") return decision;
  if (!isGitCommand(decision.rejection.detail)) return decision;
  const completed = status === "completed";
  return {
    approved: false,
    rejection: { ...decision.rejection, fatal: completed },
    summary: completed
      ? `rejected shell (git, completed): ${decision.rejection.detail}`
      : `denied shell (git, pre-refuse): ${decision.rejection.detail}`,
  };
}

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

/** Installed Codex plugin cache root: `$CODEX_HOME/plugins/cache/<marketplace>/<name>/<version>`. */
export function pluginCacheVersions(agentHome: string, name = "highway"): string[] {
  const root = join(agentHome, "plugins", "cache", MARKETPLACE_NAME, name);
  if (!existsSync(root)) return [];
  return readdirSync(root, { withFileTypes: true })
    .filter((e) => e.isDirectory())
    .map((e) => join(root, e.name));
}

/**
 * Read roots for Codex: the throwaway home (skills runtime under `$CODEX_HOME/skills/…`),
 * staged plugin, cache dirs, and installed versions.
 */
export function codexReadRoots(agentHome: string): string[] {
  const cacheName = join(agentHome, "plugins", "cache", MARKETPLACE_NAME, "highway");
  return [agentHome, pluginDirUnderHome(agentHome), cacheName, ...pluginCacheVersions(agentHome)];
}

/** True when a path is inside a Highway Codex plugin tree (staged, cache, or CLI pristine unpack). */
export function isCodexPluginTreePath(path: string): boolean {
  const n = path.replace(/\\/g, "/").toLowerCase();
  if (n.includes(`${PLUGIN_MARKER}skills/`) || n.includes(PLUGIN_CACHE_MARKER)) return true;
  // Codex may unpack skills under a temp `pristine/skills/highway-*` tree outside the agent home.
  if (/\/pristine\/skills\/highway-[a-z0-9-]+\//i.test(n)) return true;
  // Runtime skill layout: `$CODEX_HOME/skills/r1/highway-experience/SKILL.md`
  if (/\/skills\/(?:r\d+\/)?highway-[a-z0-9-]+\//i.test(n)) return true;
  return false;
}

/** Resolve the Codex CLI: PATH first, then the SDK-vendored binary under harness/node_modules. */
export function resolveCodexCli(): string | undefined {
  const which = spawnSync("which", ["codex"], { encoding: "utf8", timeout: 5_000 });
  if (which.status === 0 && which.stdout.trim()) return which.stdout.trim();
  const candidates = [
    join(HARNESS_DIR, "node_modules", "@openai", "codex-darwin-arm64", "vendor", "aarch64-apple-darwin", "bin", "codex"),
    join(HARNESS_DIR, "node_modules", "@openai", "codex-linux-x64", "vendor", "x86_64-unknown-linux-gnu", "bin", "codex"),
    join(HARNESS_DIR, "node_modules", "@openai", "codex", "bin", "codex.js"),
  ];
  for (const c of candidates) {
    if (existsSync(c)) return c;
  }
  return undefined;
}

/**
 * Best-effort Codex CLI registration under the throwaway home so skills activate mid-attempt
 * (FR-003). Filesystem staging remains the source of truth for skill counts. Skipped when
 * no CLI is found or when `HIGHWAY_CODEX_SKIP_PLUGIN_CLI=1` (unit tests).
 */
export function registerCodexPluginCli(agentHome: string, pluginName: string): string {
  if (process.env.HIGHWAY_CODEX_SKIP_PLUGIN_CLI === "1") {
    return "codex plugin CLI skipped (HIGHWAY_CODEX_SKIP_PLUGIN_CLI=1)";
  }
  const codexBin = resolveCodexCli();
  if (!codexBin) {
    return "codex CLI not found (PATH or harness node_modules); filesystem staging only";
  }
  const env: NodeJS.ProcessEnv = {
    ...process.env,
    HOME: agentHome,
    CODEX_HOME: agentHome,
  };
  // Marketplace root is the throwaway home (contains `.agents/plugins/marketplace.json` + `plugins/`).
  const steps: string[] = [];
  const run = (args: string[]): void => {
    const result = spawnSync(codexBin, args, { env, encoding: "utf8", timeout: 20_000 });
    const out = [result.stdout, result.stderr].filter(Boolean).join(" ").trim();
    if (result.error) {
      steps.push(`codex ${args.join(" ")}: ${result.error.message}`);
      return;
    }
    if (result.status !== 0) {
      steps.push(`codex ${args.join(" ")} exit ${result.status}${out ? `: ${out.slice(0, 240)}` : ""}`);
      return;
    }
    steps.push(`codex ${args.join(" ")}: ok`);
  };
  run(["plugin", "marketplace", "add", agentHome]);
  run(["plugin", "add", `${pluginName}@${MARKETPLACE_NAME}`]);
  return steps.join("; ");
}

/** Filesystem PluginRpc: stage Highway under throwaway CODEX_HOME and register a local marketplace. */
export function codexPluginRpc(agentHome: string): PluginRpc {
  return {
    async install(params) {
      mkdirSync(join(agentHome, "plugins"), { recursive: true });
      const name = readPluginName(params.source, "highway");
      const target = pluginDirUnderHome(agentHome, name);
      rmSync(target, { recursive: true, force: true });
      cpSync(params.source, target, { recursive: true });
      const marketDir = join(agentHome, ".agents", "plugins");
      mkdirSync(marketDir, { recursive: true });
      // Path is relative to the marketplace root (agent home), must be `./`-prefixed.
      writeFileSync(
        join(marketDir, "marketplace.json"),
        JSON.stringify(
          {
            name: MARKETPLACE_NAME,
            interface: { displayName: "Highway local" },
            plugins: [
              {
                name,
                source: { source: "local", path: `./plugins/${name}` },
                policy: { installation: "AVAILABLE", authentication: "ON_INSTALL" },
                category: "Developer Tools",
              },
            ],
          },
          null,
          2,
        ),
      );
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
      // Re-assert rules/guidance if install runs before prepare (tests) or after a wipe.
      prepareCodexAgentHome(agentHome);
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
        if (isCodexPluginTreePath(access.path)) {
          // Skill-tree touches are reads for experience-order, even when Codex reports a write.
          access = { kind: "read", path: normalizeCodexPluginPath(access.path, readRoot) };
        } else {
          access.path = normalizeCodexPluginPath(access.path, readRoot);
        }
      }
      let decision: AccessDecisionLite;
      if (access.kind === "shell") {
        decision = applyCodexShellStatus(
          classifyCodexShell(access.command ?? "", projectDir, options.readRoots),
          status === "running" ? "in_progress" : status,
        );
      } else if (
        (access.kind === "read" || access.kind === "write") &&
        access.path &&
        isCodexPluginTreePath(access.path)
      ) {
        decision = { approved: true, summary: `approved read: ${access.path}` };
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
      // Effects backup: fatal only after a forbidden tool actually finishes (git: completed only).
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
      prepareCodexAgentHome(options.agentHome);
      const installed = await installPlugin(codexPluginRpc(options.agentHome), options.plugin, projectDir);
      if (!installed.ok) {
        log({ turn, role: "system", text: installed.message });
        return result("error", { error: { kind: "plugin-install", message: installed.message } });
      }
      const cliNote = registerCodexPluginCli(options.agentHome, options.plugin.name);
      log({ turn, role: "system", text: [installed.summary, ...installed.notes, cliNote].filter(Boolean).join("\n") });

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
