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

/** A repository-relative location from the paths helper, read through `path-map.sh --location`. */
export function location(name: "skills" | "framework" | "plugin"): string {
  const result = spawnSync("bash", [join(HARNESS_DIR, "bin", "path-map.sh"), "--location", name], {
    encoding: "utf8",
    cwd: REPO_ROOT,
  });
  if (result.status !== 0) throw new Error(`path-map.sh --location ${name} failed: ${result.stderr}`);
  return result.stdout.trim();
}

/**
 * Prepares a run once: refuses a missing or stale plugin build, then makes <workRoot>/base, an
 * empty project. Each attempt installs the plugin into its own agent home, so no test project
 * holds a skill folder.
 */
export function buildPlugin(workRoot: string, repoRoot = REPO_ROOT): BuildResult {
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
    const { name } = JSON.parse(readFileSync(join(pluginDir, "plugin.json"), "utf8")) as { name: string };
    const skillsDir = join(pluginDir, "skills");
    const skills = readdirSync(skillsDir).filter((id) => existsSync(join(skillsDir, id, "SKILL.md"))).length;
    return { ok: true, dir, plugin: { dir: pluginDir, name, skills } };
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
  mkdirSync(join(workRoot, "projects"), { recursive: true });
  const dir = mkdtempSync(join(workRoot, "projects", `${label}-`));
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
