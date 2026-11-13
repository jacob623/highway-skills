import { test } from "node:test";
import assert from "node:assert/strict";
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { diffSnapshots, experienceInvariant, isExperienceSkillRead, runExpectation, showsFailures, snapshot, storageInvariant, writesNothing } from "../src/checks.ts";
import type { Expectation } from "../src/scenario.ts";

function project(files: Record<string, string>): string {
  const dir = mkdtempSync(join(tmpdir(), "harness-checks-"));
  for (const [rel, content] of Object.entries(files)) {
    mkdirSync(join(dir, rel, ".."), { recursive: true });
    writeFileSync(join(dir, rel), content);
  }
  return dir;
}

const exp = (assertion: Expectation["assertion"], path: string, argument?: string): Expectation => ({ assertion, path, argument, line: 7 });

const PLAN = `---
product: CDY1a2b3c4d
---

# Restart the worker

**Status:** Open
- **Owner:** Platform

## Stories

| Story | Test |
|-------|------|
| Restart on failure | Kill the worker |
`;

test("exists and absent", () => {
  const dir = project({ "code/w/plan.md": PLAN });
  const files = snapshot(dir).keys();
  assert.equal(runExpectation(dir, files, exp("exists", "code/*/plan.md")), undefined);
  const absent = runExpectation(dir, snapshot(dir).keys(), exp("absent", "code/*/plan.md"));
  assert.equal(absent?.check, "absent");
  assert.equal(absent?.line, 7);
  assert.equal(runExpectation(dir, snapshot(dir).keys(), exp("exists", "code/*/tasks.md"))?.actual, "no file");
  rmSync(dir, { recursive: true });
});

test("heading, field, row, and contains are structural", () => {
  const dir = project({ "code/w/plan.md": PLAN });
  const files = [...snapshot(dir).keys()];
  assert.equal(runExpectation(dir, files, exp("heading", "code/*/plan.md", "## Stories")), undefined);
  assert.ok(runExpectation(dir, files, exp("heading", "code/*/plan.md", "## Data")));
  assert.equal(runExpectation(dir, files, exp("field", "code/*/plan.md", "Status=Open")), undefined);
  assert.equal(runExpectation(dir, files, exp("field", "code/*/plan.md", "Owner=platform")), undefined);
  assert.equal(runExpectation(dir, files, exp("field", "code/*/plan.md", "product=CDY1a2b3c4d")), undefined);
  assert.ok(runExpectation(dir, files, exp("field", "code/*/plan.md", "Status=Done")));
  assert.equal(runExpectation(dir, files, exp("row", "code/*/plan.md", "Restart on failure")), undefined);
  assert.ok(runExpectation(dir, files, exp("row", "code/*/plan.md", "Restart the worker")));
  assert.equal(runExpectation(dir, files, exp("contains", "code/*/plan.md", "Kill the worker")), undefined);
  rmSync(dir, { recursive: true });
});

test("template uses the structural template check", () => {
  const good = `---\nproduct: CDY1\n---\n\n# T\n\n## Stories\n\n## Edge Cases\n\n## Functional Requirements\n\n## Decisions\n`;
  const dir = project({ "code/w/plan.md": good, "code/x/plan.md": PLAN });
  const files = [...snapshot(dir).keys()];
  assert.equal(runExpectation(dir, files, exp("template", "code/w/plan.md", "codify-plan.md")), undefined);
  const bad = runExpectation(dir, files, exp("template", "code/x/plan.md", "codify-plan.md"));
  assert.ok(bad);
  assert.match(bad!.actual, /missing heading: ## Edge Cases/);
  rmSync(dir, { recursive: true });
});

test("the storage invariant names every file outside the writes patterns", () => {
  const dir = project({ "code/a.md": "a", "keep.md": "k" });
  const before = snapshot(dir);
  writeFileSync(join(dir, "code/b.md"), "b");
  writeFileSync(join(dir, "keep.md"), "changed");
  writeFileSync(join(dir, "stray.md"), "s");
  const diff = diffSnapshots(before, snapshot(dir));
  assert.deepEqual(diff.created, ["code/b.md", "stray.md"]);
  assert.deepEqual(diff.changed, ["keep.md"]);
  const failures = storageInvariant(diff, ["code/**"]);
  assert.equal(failures.length, 1);
  assert.equal(failures[0].actual, "keep.md, stray.md");
  assert.deepEqual(storageInvariant(diff, ["**"]), []);
  assert.equal(writesNothing(diff).length, 1);
  rmSync(dir, { recursive: true });
});

test("the experience invariant requires highway-experience before the first output", () => {
  assert.deepEqual(experienceInvariant(["highway-experience", "highway-setup"]), []);
  assert.deepEqual(experienceInvariant(["highway-setup", "highway-experience"]), []);
  const late = experienceInvariant(["highway-setup"]);
  assert.equal(late.length, 1);
  assert.equal(late[0].check, "experience");
  assert.equal(late[0].actual, "highway-setup");
  assert.equal(experienceInvariant([])[0].actual, "no skill");
});

test("shows requires each text in the agent's messages, whitespace collapsed", () => {
  const said = "**Oops... we need to setup your repository.**\n\nHighway needs to gather your organizational preferences and set up\nyour repository.";
  assert.deepEqual(showsFailures(said, ["**Oops... we need to setup your repository.**", "set up your repository."]), []);
  const missing = showsFailures(said, ["Run /highway-setup to get started."]);
  assert.equal(missing.length, 1);
  assert.equal(missing[0].check, "shows");
  assert.equal(missing[0].expected, 'text "Run /highway-setup to get started."');
  assert.equal(missing[0].actual, "the agent did not show it");
});

test("shows does not compare emphasis, and keeps underscores inside words", () => {
  const said = "Oops... we need to *setup* your repository. Use __snake_case__ names.";
  assert.deepEqual(showsFailures(said, ["**Oops... we need to setup your repository.**", "Use snake_case names."]), []);
  assert.equal(showsFailures("Use snakecase names.", ["Use snake_case names."]).length, 1);
});

test("a read of highway-experience/SKILL.md is an experience activation", () => {
  assert.ok(isExperienceSkillRead("/tmp/p/.github/skills/highway-experience/SKILL.md"));
  assert.ok(isExperienceSkillRead("highway-experience/SKILL.md"));
  assert.ok(!isExperienceSkillRead("/tmp/p/.github/skills/highway-experience/references/storage-contract.md"));
  assert.ok(!isExperienceSkillRead("/tmp/p/.github/skills/not-highway-experience/SKILL.md"));
});
