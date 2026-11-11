import { test } from "node:test";
import assert from "node:assert/strict";
import type { Scenario } from "../src/scenario.ts";
import { runPathMap, selectAll, selectSmoke, selectTargeted, type SelectDeps } from "../src/select.ts";

function scenario(id: string, skill: string, extra: Partial<Scenario> = {}): Scenario {
  return { file: `/repo/harness/scenarios/${skill}/${id}.scenario`, id, skill, through: [], fixture: "implementation", smoke: false, web: false, open: "/x", replies: [], writes: [], expects: [], covers: [], reaches: [], ...extra };
}

const scenarios = [
  scenario("codify-plan-review", "highway-codify"),
  scenario("codify-smoke", "highway-codify", { smoke: true }),
  scenario("impl-smoke", "highway-implementation", { smoke: true, fixture: "architecture" }),
  scenario("onboarding-through", "highway-onboarding", { through: ["highway-codify"], fixture: "setup" }),
  scenario("adr-smoke", "highway-adr", { smoke: true, fixture: "discovery" }),
];

const fakeDeps = (changed: { present: string[]; deleted: string[] }): SelectDeps => ({
  mapper: runPathMap,
  changed: () => changed,
  skillsAt: () => "/nonexistent",
});

test("a template selects every scenario of the skill naming it, including pass-through scenarios", () => {
  const r = selectTargeted(scenarios, { paths: [".highway/library/templates/output/codify-plan.md"], skills: [] });
  assert.deepEqual(r.selection.map((s) => s.scenario), ["codify-plan-review", "codify-smoke", "onboarding-through"]);
  assert.match(r.selection[0].reasons[0], /^--paths: highway-codify names \.highway\/library\/templates\/output\/codify-plan\.md$/);
});

test("--skills and --paths combine as a union and keep both reasons", () => {
  const r = selectTargeted(scenarios, { paths: [".highway/library/templates/output/adr-record.md"], skills: ["highway-codify"] });
  const ids = r.selection.map((s) => s.scenario);
  assert.ok(ids.includes("adr-smoke"));
  assert.ok(ids.includes("codify-plan-review"));
  const both = r.selection.find((s) => s.scenario === "codify-plan-review")!;
  assert.equal(both.reasons[0], "--skills highway-codify");
});

test("a shared file selects the smoke set", () => {
  const r = selectTargeted(scenarios, { paths: [".highway/governance/storage.md"], skills: [] });
  assert.deepEqual(r.selection.map((s) => s.scenario), ["codify-smoke", "impl-smoke", "adr-smoke"]);
});

test("specs and tests select nothing and the run says so", () => {
  const r = selectTargeted(scenarios, { paths: [".highway/tools/tests/run-all.sh"], skills: [] });
  assert.deepEqual(r.selection, []);
  assert.match(r.notes[0], /selects nothing/);
});

test("a stage fixture selects scenarios starting from it", () => {
  const r = selectTargeted(scenarios, { paths: ["harness/fixtures/stages/architecture/architectures/architectures.md"], skills: [] });
  assert.deepEqual(r.selection.map((s) => s.scenario), ["impl-smoke"]);
});

test("--changed-since maps present and deleted files", () => {
  const r = selectTargeted(scenarios, { paths: [], skills: [], changedSince: "main" }, fakeDeps({ present: [".highway/skills/highway-adr/SKILL.md"], deleted: [] }));
  assert.deepEqual(r.selection.map((s) => s.scenario), ["adr-smoke"]);
  assert.match(r.selection[0].reasons[0], /^changed since main: /);
});

test("full and smoke selections", () => {
  assert.equal(selectAll(scenarios).length, 5);
  assert.deepEqual(selectSmoke(scenarios).map((s) => s.scenario), ["codify-smoke", "impl-smoke", "adr-smoke"]);
});
