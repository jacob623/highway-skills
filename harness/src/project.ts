import { spawnSync } from "node:child_process";
import { cpSync, existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync } from "node:fs";
import { join, normalize, resolve, sep } from "node:path";
import { HARNESS_DIR, REPO_ROOT } from "./config.ts";

export const STAGES = ["setup", "request", "discovery", "architecture", "implementation"] as const;
export type Stage = (typeof STAGES)[number];

export const FIXTURES_DIR = join(HARNESS_DIR, "fixtures");

export type BuildResult = { ok: true; dir: string } | { ok: false; tail: string };

/** A repository-relative location from the paths helper, read through `path-map.sh --location`. */
export function location(name: "skills" | "framework" | "agent-skills"): string {
  const result = spawnSync("bash", [join(HARNESS_DIR, "bin", "path-map.sh"), "--location", name], {
    encoding: "utf8",
    cwd: REPO_ROOT,
  });
  if (result.status !== 0) throw new Error(`path-map.sh --location ${name} failed: ${result.stderr}`);
  return result.stdout.trim();
}

/**
 * Builds the base project once per run into <workRoot>/base: a copy of every skill folder in
 * skills/, in the folder the agent discovers skills in, and nothing else (FR-014).
 */
export function buildSkills(workRoot: string): BuildResult {
  const dir = join(workRoot, "base");
  try {
    const source = join(REPO_ROOT, location("skills"));
    const target = join(dir, location("agent-skills"));
    mkdirSync(target, { recursive: true });
    for (const name of readdirSync(source).sort()) {
      if (!existsSync(join(source, name, "SKILL.md"))) continue;
      cpSync(join(source, name), join(target, name), { recursive: true, filter: (src) => !/[\\/]\.[^\\/]*$/.test(src) });
    }
    return { ok: true, dir };
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

/** A new temporary project per attempt: the base skills, then the fixture or previous stage (FR-005). */
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
