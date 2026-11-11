import { cpSync, existsSync, mkdirSync, readdirSync, rmSync, statSync } from "node:fs";
import { dirname, join, relative, sep } from "node:path";
import { FIXTURES_DIR, STAGES } from "./project.ts";
import type { ScenarioOutcome } from "./report.ts";
import type { Scenario } from "./scenario.ts";

export const CHAIN_LENGTH = 6;

/** The six chain scenarios in position order; throws unless positions 1 to 6 appear once each. */
export function chainOf(scenarios: readonly Scenario[]): Scenario[] {
  const chain = scenarios.filter((s) => s.chain !== undefined).sort((a, b) => a.chain! - b.chain!);
  const positions = chain.map((s) => s.chain);
  for (let p = 1; p <= CHAIN_LENGTH; p++) {
    const n = positions.filter((x) => x === p).length;
    if (n !== 1) throw new Error(`chain position ${p} is used by ${n} scenarios; exactly one is required`);
  }
  return chain;
}

export interface ProjectSourceSpec {
  fixture?: string;
  fromDir?: string;
}

export interface StageRun {
  outcome: ScenarioOutcome;
  /** The passing attempt's project, kept until the chain ends. */
  projectDir?: string;
}

export type StageRunner = (scenario: Scenario, source: ProjectSourceSpec, stage: number) => Promise<StageRun>;

export interface ChainResult {
  outcomes: ScenarioOutcome[];
  failedStage?: number;
  candidates: string[];
}

function filesUnder(root: string): string[] {
  const out: string[] = [];
  const walk = (dir: string): void => {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const full = join(dir, entry.name);
      if (entry.isDirectory()) walk(full);
      else out.push(relative(root, full).split(sep).join("/"));
    }
  };
  walk(root);
  return out.sort();
}

/** A candidate snapshot holds the project files the distribution does not supply. */
export function saveCandidate(projectDir: string, distDir: string, dest: string): number {
  rmSync(dest, { recursive: true, force: true });
  mkdirSync(dest, { recursive: true });
  let n = 0;
  for (const rel of filesUnder(projectDir)) {
    if (existsSync(join(distDir, rel))) continue;
    mkdirSync(dirname(join(dest, rel)), { recursive: true });
    cpSync(join(projectDir, rel), join(dest, rel));
    n++;
  }
  return n;
}

/**
 * FR-021 and FR-027: stage 1 from an empty project, each later stage from the previous stage's
 * output, one at a time. A failed stage stops the chain. Candidates are saved only when all pass.
 */
export async function runChain(chain: readonly Scenario[], runStage: StageRunner, distDir: string, candidatesDir: string): Promise<ChainResult> {
  const outcomes: ScenarioOutcome[] = [];
  const kept: string[] = [];
  try {
    let fromDir: string | undefined;
    for (const scenario of chain) {
      const stage = scenario.chain!;
      const source: ProjectSourceSpec = stage === 1 ? { fixture: "empty" } : { fromDir };
      const run = await runStage(scenario, source, stage);
      outcomes.push(run.outcome);
      if (run.outcome.status !== "pass" || !run.projectDir) return { outcomes, failedStage: stage, candidates: [] };
      kept.push(run.projectDir);
      fromDir = run.projectDir;
    }
    const candidates: string[] = [];
    STAGES.forEach((name, i) => {
      const dest = join(candidatesDir, name);
      saveCandidate(kept[i], distDir, dest);
      candidates.push(dest);
    });
    return { outcomes, candidates };
  } finally {
    for (const dir of kept) rmSync(dir, { recursive: true, force: true });
  }
}

/** `--promote <run folder>`: replace the five stage fixtures with the run's candidates. */
export function promote(runFolder: string, fixturesDir = FIXTURES_DIR): string[] {
  const candidatesDir = join(runFolder, "candidates");
  const missing = STAGES.filter((s) => !existsSync(join(candidatesDir, s)) || !statSync(join(candidatesDir, s)).isDirectory());
  if (missing.length > 0) throw new Error(`${runFolder} has no candidate snapshot for ${missing.join(", ")}; only a passing full run saves candidates`);
  const replaced: string[] = [];
  for (const stage of STAGES) {
    const dest = join(fixturesDir, "stages", stage);
    rmSync(dest, { recursive: true, force: true });
    mkdirSync(dest, { recursive: true });
    cpSync(join(candidatesDir, stage), dest, { recursive: true });
    replaced.push(dest);
  }
  return replaced;
}
