import { realpathSync } from "node:fs";
import { isAbsolute, resolve, sep } from "node:path";
import { errorText, type FailureKind } from "./failure.ts";
import type { PluginSource } from "./project.ts";
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
  /** The attempt's own agent configuration home, removed when the attempt ends. */
  agentHome: string;
  /** The folders under the agent home where the installed plugin sits. */
  readRoots: string[];
  plugin: PluginSource;
  key: string;
  model: string;
  maxTurns: number;
  timeoutMs: number;
  pickFallback: FallbackPicker;
  raw: (event: unknown) => void;
  log: (entry: TranscriptEntry) => void;
  sleep?: (ms: number) => Promise<void>;
}

export type Driver = (options: DriveOptions) => Promise<DriveResult>;

export type Classifier = (error: unknown) => FailureKind;

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

/** A driver's native permission request, mapped to the shape the policy decides (FR-007). */
export interface AccessRequest {
  kind: "read" | "write" | "shell" | "memory" | "url" | "other";
  path?: string;
  command?: string;
  url?: string;
  detail?: string;
  /** For `other`: the native kind, which names the rejection. */
  tool?: string;
}

export interface AccessDecision {
  approved: boolean;
  feedback?: string;
  rejection?: Rejection;
  summary: string;
}

const SHELL_FEEDBACK = "Shell commands are not available in this session. Highway skills read and write files only.";

/**
 * FR-008: reads and writes inside the project; URLs only with `web: yes`; everything else rejected.
 * Reads are also approved inside each read root, where the installed plugin's skills sit; a write
 * there is an outside write.
 */
export function permissionPolicy(request: AccessRequest, projectDir: string, web: boolean, readRoots: readonly string[] = []): AccessDecision {
  const reject = (kind: string, detail: string, fatal: boolean, feedback: string): AccessDecision => ({
    approved: false,
    feedback,
    rejection: { kind, detail, fatal },
    summary: `rejected ${kind}: ${detail}`,
  });
  switch (request.kind) {
    case "read": {
      const path = request.path ?? "";
      if (insideProject(projectDir, path) || readRoots.some((root) => insideProject(root, path))) {
        return { approved: true, summary: `approved read: ${path}` };
      }
      const feedback =
        readRoots.length > 0
          ? "Reads are available inside the project and the installed plugin only. Check that the path was copied exactly."
          : "Reads outside the project are not available in this session.";
      return reject("read", path, false, feedback);
    }
    case "write": {
      const path = request.path ?? "";
      if (insideProject(projectDir, path)) return { approved: true, summary: `approved write: ${path}` };
      return reject("outside-write", path, true, "Writes outside the project are not available in this session.");
    }
    case "shell":
      return reject("shell", request.command ?? "command", true, SHELL_FEEDBACK);
    case "memory":
      return reject("memory", request.detail ?? "memory", true, "Memory is not available in this session.");
    case "url": {
      const url = request.url ?? "url";
      if (web) return { approved: true, summary: `approved url: ${url}` };
      return reject("url", url, false, "Web access is not available in this session.");
    }
    default: {
      const tool = request.tool ?? "other";
      return reject(tool, request.detail ?? tool, false, "This tool is not available in this session.");
    }
  }
}

/** The part of an agent's plugin interface an install uses; each driver adapts its own to it. */
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
 * FR-010: installs the plugin into the attempt's agent home through the driver's plugin install.
 * A throw, a warning, a skill count short of the build's, or a plugin left disabled fails the
 * attempt. A deprecation warning is only noted: every local-path install carries one.
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

export const realSleep = (ms: number): Promise<void> => new Promise((done) => setTimeout(done, ms));

/** R11 and FR-036b: retry a rate-limited call after 5, 20, and 60 seconds; then stop the run. */
export async function withRateLimit<T>(call: () => Promise<T>, classify: Classifier, sleep: (ms: number) => Promise<void> = realSleep, onWait?: (ms: number) => void): Promise<T> {
  for (let attempt = 0; ; attempt++) {
    try {
      return await call();
    } catch (error) {
      const kind = classify(error);
      if (kind === "allowance") throw new RunStop("allowance", errorText(error));
      if (kind !== "rate-limit") throw error;
      if (attempt >= RATE_LIMIT_WAITS_MS.length) throw new RunStop("rate-limit", errorText(error));
      onWait?.(RATE_LIMIT_WAITS_MS[attempt]);
      await sleep(RATE_LIMIT_WAITS_MS[attempt]);
    }
  }
}
