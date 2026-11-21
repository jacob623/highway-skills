import { spawnSync } from "node:child_process";
import { cpSync, existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync } from "node:fs";
import { join, normalize, resolve, sep } from "node:path";
import { HARNESS_DIR, REPO_ROOT } from "./config.ts";

export const STAGES = ["setup", "request", "discovery", "architecture", "implementation"] as const;
export type Stage = (typeof STAGES)[number];

export const FIXTURES_DIR = join(HARNESS_DIR, "fixtures");

/** The Agent Plugins build every attempt installs, and what a complete install holds. */
export interface PluginSource {
  dir: string;
  name: string;
  skills: number;
}

export type BuildResult = { ok: true; dir: string; plugin: PluginSource } | { ok: false; tail: string };

export const PUBLIC_PLUGIN_REMOTE = "https://github.com/highway-systems/agent-plugin.git";

export interface BuildPluginOptions {
  source?: "local" | "public";
  ref?: string;
}

/** A repository-relative location from the paths helper, read through `path-map.sh --location`. */
export function location(name: "skills" | "framework" | "plugin"): string {
  const result = spawnSync("bash", [join(HARNESS_DIR, "bin", "path-map.sh"), "--location", name], {
    encoding: "utf8",
    cwd: REPO_ROOT,
  });
  if (result.status !== 0) throw new Error(`path-map.sh --location ${name} failed: ${result.stderr}`);
  return result.stdout.trim();
}

function pluginFromDir(pluginDir: string): PluginSource {
  const { name } = JSON.parse(readFileSync(join(pluginDir, "plugin.json"), "utf8")) as { name: string };
  const skillsDir = join(pluginDir, "skills");
  const skills = readdirSync(skillsDir).filter((id) => existsSync(join(skillsDir, id, "SKILL.md"))).length;
  return { dir: pluginDir, name, skills };
}

/**
 * Clones the public plugin repository at a pinned tag or commit into <workRoot>/public-plugin.
 */
export function clonePublicPlugin(workRoot: string, ref: string, remote = PUBLIC_PLUGIN_REMOTE): BuildResult {
  const dest = join(workRoot, "public-plugin");
  mkdirSync(workRoot, { recursive: true });
  rmSync(dest, { recursive: true, force: true });
  const clone = spawnSync("git", ["clone", "--depth", "1", "--branch", ref, remote, dest], { encoding: "utf8" });
  if (clone.status !== 0) {
    // Tag/branch shallow clone failed; try full fetch + checkout (commit SHAs need this).
    const init = spawnSync("git", ["clone", remote, dest], { encoding: "utf8" });
    if (init.status !== 0) {
      return { ok: false, tail: `${clone.stderr}${init.stderr}`.trim() || `git clone ${remote} failed` };
    }
    const checkout = spawnSync("git", ["-C", dest, "checkout", "--detach", ref], { encoding: "utf8" });
    if (checkout.status !== 0) {
      return { ok: false, tail: `${checkout.stderr}`.trim() || `git checkout ${ref} failed` };
    }
  }
  try {
    return { ok: true, dir: join(workRoot, "base"), plugin: pluginFromDir(dest) };
  } catch (err) {
    return { ok: false, tail: String(err) };
  }
}

/**
 * Prepares a run once: refuses a missing or stale plugin build (local), or clones a pinned public
 * ref, then makes <workRoot>/base, an empty project. Each attempt installs the plugin into its own
 * agent home, so no test project holds a skill folder.
 */
export function buildPlugin(workRoot: string, repoRoot = REPO_ROOT, opts: BuildPluginOptions = {}): BuildResult {
  const source = opts.source ?? "local";
  if (source === "public") {
    if (!opts.ref) return { ok: false, tail: "--plugin-source public requires --plugin-ref <tag|sha>" };
    const cloned = clonePublicPlugin(workRoot, opts.ref);
    if (!cloned.ok) return cloned;
    try {
      mkdirSync(cloned.dir, { recursive: true });
      return cloned;
    } catch (err) {
      return { ok: false, tail: String(err) };
    }
  }
  const check = spawnSync("bash", [join(repoRoot, location("framework"), "generate-agent-plugin.sh"), "--check"], {
    encoding: "utf8",
    cwd: repoRoot,
  });
  if (check.status !== 0) {
    return { ok: false, tail: `${check.stdout}${check.stderr}`.trim() || `generate-agent-plugin.sh --check exited ${check.status}` };
  }
  const dir = join(workRoot, "base");
  try {
    mkdirSync(dir, { recursive: true });
    const pluginDir = join(repoRoot, location("plugin"));
    return { ok: true, dir, plugin: pluginFromDir(pluginDir) };
  } catch (err) {
    return { ok: false, tail: String(err) };
  }
}

export interface ResolvedFixture {
  name: string;
  stage?: Stage;
  stageDir?: string;
  overlayDir?: string;
  deletes: string[];
}

export function isStage(name: string): name is Stage {
  return (STAGES as readonly string[]).includes(name);
}

/** Resolves `empty`, a stage name, or an overlay name to its directories. */
export function resolveFixture(name: string, fixturesDir = FIXTURES_DIR): ResolvedFixture {
  if (name === "empty") return { name, deletes: [] };
  if (isStage(name)) {
    const stageDir = join(fixturesDir, "stages", name);
    if (!existsSync(stageDir)) throw new Error(`stage fixture ${name} is missing at ${stageDir}`);
    return { name, stage: name, stageDir, deletes: [] };
  }
  const overlayDir = join(fixturesDir, "overlays", name);
  const meta = join(overlayDir, "overlay.txt");
  if (!existsSync(meta)) throw new Error(`fixture ${name} is not empty, a stage, or an overlay with overlay.txt`);
  const stageLine = /^stage:\s*(\S+)\s*$/m.exec(readFileSync(meta, "utf8"));
  const stage = stageLine?.[1] ?? "";
  if (!isStage(stage)) throw new Error(`overlay ${name} names no known stage in overlay.txt`);
  const deleteFile = join(overlayDir, ".delete");
  const deletes = existsSync(deleteFile)
    ? readFileSync(deleteFile, "utf8")
        .split(/\r?\n/)
        .map((l) => l.trim())
        .filter((l) => l !== "" && !l.startsWith("#"))
    : [];
  return { name, stage, stageDir: join(fixturesDir, "stages", stage), overlayDir, deletes };
}

function insideRoot(root: string, rel: string): string {
  const full = resolve(root, normalize(rel));
  if (full !== root && !full.startsWith(root + sep)) throw new Error(`path ${rel} leaves the project`);
  return full;
}

export interface ProjectSource {
  baseDir: string;
  /** A fixture name, or a directory holding a previous chain stage's output. */
  fixture?: string;
  fromDir?: string;
}

/** A new temporary project per attempt: the base, then the fixture or previous stage (FR-005). */
export function createProject(source: ProjectSource, workRoot: string, label: string): string {
  mkdirSync(join(workRoot, "p"), { recursive: true });
  const dir = mkdtempSync(join(workRoot, "p", `${label}-`));
  cpSync(source.baseDir, dir, { recursive: true });
  if (source.fromDir) {
    cpSync(source.fromDir, dir, { recursive: true });
    return dir;
  }
  const fixture = resolveFixture(source.fixture ?? "empty");
  if (fixture.stageDir) cpSync(fixture.stageDir, dir, { recursive: true });
  if (fixture.overlayDir) {
    cpSync(fixture.overlayDir, dir, {
      recursive: true,
      filter: (src) => !/[\\/](overlay\.txt|\.delete)$/.test(src),
    });
  }
  for (const rel of fixture.deletes) rmSync(insideRoot(dir, rel), { recursive: true, force: true });
  return dir;
}

export function removeProject(dir: string): void {
  rmSync(dir, { recursive: true, force: true });
}
