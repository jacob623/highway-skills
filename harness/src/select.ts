import { spawnSync } from "node:child_process";
import { existsSync, readdirSync } from "node:fs";
import { join, relative } from "node:path";
import { HARNESS_DIR, REPO_ROOT } from "./config.ts";
import { isStage, resolveFixture } from "./project.ts";
import type { Selection } from "./report.ts";
import { readScenario, ScenarioError, type Scenario } from "./scenario.ts";

export const SCENARIOS_DIR = join(HARNESS_DIR, "scenarios");

export interface Loaded {
  scenarios: Scenario[];
  errors: string[];
}

export function loadScenarios(dir = SCENARIOS_DIR): Loaded {
  const scenarios: Scenario[] = [];
  const errors: string[] = [];
  if (!existsSync(dir)) return { scenarios, errors };
  const files: string[] = [];
  for (const skill of readdirSync(dir, { withFileTypes: true })) {
    if (!skill.isDirectory()) continue;
    for (const f of readdirSync(join(dir, skill.name))) if (f.endsWith(".scenario")) files.push(join(dir, skill.name, f));
  }
  for (const file of files.sort()) {
    try {
      scenarios.push(readScenario(file));
    } catch (error) {
      errors.push(error instanceof ScenarioError ? error.message : String(error));
    }
  }
  return { scenarios, errors };
}

export interface MapLine {
  path: string;
  kind: "skill" | "smoke" | "scenario" | "fixture" | "none";
  target: string;
  reason: string;
}

export type PathMapper = (paths: readonly string[]) => MapLine[];

export const runPathMap: PathMapper = (paths) => {
  if (paths.length === 0) return [];
  const args = [join(HARNESS_DIR, "bin", "path-map.sh"), ...paths];
  const result = spawnSync("bash", args, { encoding: "utf8", cwd: REPO_ROOT });
  if (result.status !== 0) throw new Error(`path-map.sh failed: ${result.stderr}`);
  return result.stdout
    .split("\n")
    .filter(Boolean)
    .map((line) => {
      const [path, kind, target, reason] = line.split("\t");
      return { path, kind: kind as MapLine["kind"], target, reason };
    });
};

export interface ChangedFiles {
  present: string[];
  deleted: string[];
}

function git(args: string[]): string {
  const result = spawnSync("git", args, { encoding: "utf8", cwd: REPO_ROOT });
  if (result.status !== 0) throw new Error(`git ${args.join(" ")} failed: ${result.stderr.trim()}`);
  return result.stdout;
}

/** Files changed between <ref> and the working tree, including untracked files; renames split. */
export function changedSince(ref: string): ChangedFiles {
  const present = new Set<string>();
  const deleted = new Set<string>();
  for (const line of git(["diff", "--name-status", "--no-renames", ref]).split("\n").filter(Boolean)) {
    const [status, path] = line.split("\t");
    if (status.startsWith("D")) deleted.add(path);
    else present.add(path);
  }
  for (const path of git(["ls-files", "--others", "--exclude-standard"]).split("\n").filter(Boolean)) present.add(path);
  return { present: [...present].sort(), deleted: [...deleted].sort() };
}

function fixtureStage(name: string): string | undefined {
  if (isStage(name)) return name;
  try {
    return resolveFixture(name).stage;
  } catch {
    return undefined;
  }
}

export function scenariosForLine(line: MapLine, scenarios: readonly Scenario[]): Scenario[] {
  switch (line.kind) {
    case "skill":
      return scenarios.filter((s) => s.skill === line.target || s.through.includes(line.target));
    case "smoke":
      return scenarios.filter((s) => s.smoke);
    case "scenario":
      return scenarios.filter((s) => s.id === line.target);
    case "fixture":
      return scenarios.filter((s) => s.fixture === line.target || (isStage(line.target) && fixtureStage(s.fixture) === line.target));
    default:
      return [];
  }
}

export interface TargetedInput {
  paths: readonly string[];
  skills: readonly string[];
  changedSince?: string;
}

export interface TargetedResult {
  selection: Selection[];
  notes: string[];
}

export interface SelectDeps {
  mapper: PathMapper;
  changed: (ref: string) => ChangedFiles;
}

const defaultDeps: SelectDeps = { mapper: runPathMap, changed: changedSince };

/** FR-023: the union of --changed-since, --paths, and --skills, keeping every reason. */
export function selectTargeted(scenarios: readonly Scenario[], input: TargetedInput, deps: SelectDeps = defaultDeps): TargetedResult {
  const reasons = new Map<string, string[]>();
  const notes: string[] = [];
  const add = (s: Scenario, reason: string): void => {
    const list = reasons.get(s.id) ?? [];
    if (!list.includes(reason)) list.push(reason);
    reasons.set(s.id, list);
  };
  const apply = (lines: MapLine[], source: string): void => {
    for (const line of lines) {
      const hits = scenariosForLine(line, scenarios);
      if (line.kind === "none") notes.push(`${source}: ${line.path} selects nothing (${line.reason})`);
      else if (hits.length === 0) notes.push(`${source}: ${line.path} selects ${line.kind} ${line.target}, which has no scenario`);
      for (const s of hits) add(s, `${source}: ${line.reason}`);
    }
  };

  for (const skill of input.skills) {
    const hits = scenarios.filter((s) => s.skill === skill || s.through.includes(skill));
    if (hits.length === 0) notes.push(`--skills: ${skill} has no scenario`);
    for (const s of hits) add(s, `--skills ${skill}`);
  }
  if (input.paths.length > 0) {
    const present = input.paths.filter((p) => existsSync(join(REPO_ROOT, p)));
    const missing = input.paths.filter((p) => !present.includes(p));
    apply(deps.mapper(present), "--paths");
    if (missing.length > 0) apply(deps.mapper(missing), "--paths (not in the working tree)");
  }
  if (input.changedSince) {
    const ref = input.changedSince;
    const changed = deps.changed(ref);
    apply(deps.mapper(changed.present), `changed since ${ref}`);
    if (changed.deleted.length > 0) apply(deps.mapper(changed.deleted), `deleted since ${ref}`);
  }

  const selection = scenarios.filter((s) => reasons.has(s.id)).map((s) => ({ scenario: s.id, file: relative(REPO_ROOT, s.file), reasons: reasons.get(s.id)! }));
  return { selection, notes };
}

export function selectAll(scenarios: readonly Scenario[]): Selection[] {
  return scenarios.map((s) => ({ scenario: s.id, file: relative(REPO_ROOT, s.file), reasons: ["full run"] }));
}

export function selectSmoke(scenarios: readonly Scenario[]): Selection[] {
  return scenarios.filter((s) => s.smoke).map((s) => ({ scenario: s.id, file: relative(REPO_ROOT, s.file), reasons: ["smoke set"] }));
}
