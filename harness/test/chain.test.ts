import { test } from "node:test";
import assert from "node:assert/strict";
import { cpSync, existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { chainOf, promote, runChain, saveCandidate, type StageRunner } from "../src/chain.ts";
import type { ScenarioOutcome } from "../src/report.ts";
import type { Scenario } from "../src/scenario.ts";

const STAGE_FILES = ["library/knowledge/profile.md", "requests/requests.md", "discoveries/discoveries.md", "architectures/architectures.md", "implementations/implementations.md", "code/code.md"];

function scenario(chain: number): Scenario {
  return { file: `/x/${chain}.scenario`, id: `stage-${chain}`, skill: "highway-setup", through: [], fixture: "empty", chain, smoke: false, web: false, open: "/x", replies: [], writes: [], expects: [], covers: [], reaches: [] };
}

function outcome(s: Scenario, status: ScenarioOutcome["status"]): ScenarioOutcome {
  return { scenario: s.id, file: s.file, skill: s.skill, status, reasons: [], attempts: [], warnings: [] };
}

function dist(): string {
  const dir = mkdtempSync(join(tmpdir(), "harness-dist-"));
  mkdirSync(join(dir, ".highway"), { recursive: true });
  writeFileSync(join(dir, ".highway", "README.md"), "dist");
  return dir;
}

/** Each stage copies the previous output (or the distribution) and adds its own file. */
function fakeStages(distDir: string, failAt?: number): { runner: StageRunner; sources: string[] } {
  const sources: string[] = [];
  const runner: StageRunner = async (s, source, stage) => {
    sources.push(source.fromDir ? "previous" : source.fixture ?? "?");
    if (stage === failAt) return { outcome: outcome(s, "fail") };
    const dir = mkdtempSync(join(tmpdir(), `harness-stage-${stage}-`));
    cpSync(source.fromDir ?? distDir, dir, { recursive: true });
    const file = join(dir, STAGE_FILES[stage - 1]);
    mkdirSync(join(file, ".."), { recursive: true });
    writeFileSync(file, `stage ${stage}`);
    return { outcome: outcome(s, "pass"), projectDir: dir };
  };
  return { runner, sources };
}

test("chainOf orders positions and requires each of 1 to 6 once", () => {
  const all = [4, 2, 6, 1, 3, 5].map(scenario);
  assert.deepEqual(chainOf(all).map((s) => s.chain), [1, 2, 3, 4, 5, 6]);
  assert.throws(() => chainOf(all.slice(1)), /position/);
});

test("stage 1 starts empty, later stages start from the previous output, and candidates hold only project files", async () => {
  const distDir = dist();
  const folder = mkdtempSync(join(tmpdir(), "harness-run-"));
  const { runner, sources } = fakeStages(distDir);
  const result = await runChain([1, 2, 3, 4, 5, 6].map(scenario), runner, distDir, join(folder, "candidates"));
  assert.equal(result.failedStage, undefined);
  assert.deepEqual(sources, ["empty", "previous", "previous", "previous", "previous", "previous"]);
  assert.deepEqual(readdirSync(join(folder, "candidates")).sort(), ["architecture", "discovery", "implementation", "request", "setup"]);
  assert.ok(existsSync(join(folder, "candidates", "implementation", "implementations", "implementations.md")));
  assert.ok(existsSync(join(folder, "candidates", "implementation", "library", "knowledge", "profile.md")));
  assert.ok(!existsSync(join(folder, "candidates", "setup", ".highway")));
  assert.ok(!existsSync(join(folder, "candidates", "implementation", "code")));
  rmSync(distDir, { recursive: true });
  rmSync(folder, { recursive: true });
});

test("a failed stage stops the chain and saves no candidate", async () => {
  const distDir = dist();
  const folder = mkdtempSync(join(tmpdir(), "harness-run-"));
  const { runner, sources } = fakeStages(distDir, 3);
  const result = await runChain([1, 2, 3, 4, 5, 6].map(scenario), runner, distDir, join(folder, "candidates"));
  assert.equal(result.failedStage, 3);
  assert.equal(result.outcomes.length, 3);
  assert.equal(sources.length, 3);
  assert.deepEqual(result.candidates, []);
  assert.ok(!existsSync(join(folder, "candidates")));
  rmSync(distDir, { recursive: true });
  rmSync(folder, { recursive: true });
});

test("promote replaces exactly the five stage fixtures and leaves overlays alone", () => {
  const run = mkdtempSync(join(tmpdir(), "harness-run-"));
  const fixtures = mkdtempSync(join(tmpdir(), "harness-fixtures-"));
  for (const stage of ["setup", "request", "discovery", "architecture", "implementation"]) {
    mkdirSync(join(run, "candidates", stage), { recursive: true });
    writeFileSync(join(run, "candidates", stage, "new.md"), stage);
    mkdirSync(join(fixtures, "stages", stage), { recursive: true });
    writeFileSync(join(fixtures, "stages", stage, "old.md"), "old");
  }
  mkdirSync(join(fixtures, "overlays", "code-project"), { recursive: true });
  writeFileSync(join(fixtures, "overlays", "code-project", "overlay.txt"), "stage: implementation\n");
  const replaced = promote(run, fixtures);
  assert.equal(replaced.length, 5);
  assert.deepEqual(readdirSync(join(fixtures, "stages", "setup")), ["new.md"]);
  assert.equal(readFileSync(join(fixtures, "stages", "implementation", "new.md"), "utf8"), "implementation");
  assert.ok(existsSync(join(fixtures, "overlays", "code-project", "overlay.txt")));
  rmSync(run, { recursive: true });
  rmSync(fixtures, { recursive: true });
});

test("promote refuses a run folder without all five candidates and changes nothing", () => {
  const run = mkdtempSync(join(tmpdir(), "harness-run-"));
  const fixtures = mkdtempSync(join(tmpdir(), "harness-fixtures-"));
  mkdirSync(join(run, "candidates", "setup"), { recursive: true });
  mkdirSync(join(fixtures, "stages", "setup"), { recursive: true });
  writeFileSync(join(fixtures, "stages", "setup", "old.md"), "old");
  assert.throws(() => promote(run, fixtures), /no candidate snapshot for request/);
  assert.deepEqual(readdirSync(join(fixtures, "stages", "setup")), ["old.md"]);
  rmSync(run, { recursive: true });
  rmSync(fixtures, { recursive: true });
});

test("saveCandidate skips distribution files", () => {
  const distDir = dist();
  const project = mkdtempSync(join(tmpdir(), "harness-project-"));
  cpSync(distDir, project, { recursive: true });
  mkdirSync(join(project, "requests"));
  writeFileSync(join(project, "requests", "requests.md"), "r");
  const dest = join(project, "..", `cand-${Date.now()}`);
  assert.equal(saveCandidate(project, distDir, dest), 1);
  rmSync(dest, { recursive: true });
  rmSync(project, { recursive: true });
  rmSync(distDir, { recursive: true });
});
