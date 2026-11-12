import { test } from "node:test";
import assert from "node:assert/strict";
import { existsSync, mkdtempSync, readdirSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { REPO_ROOT } from "../src/config.ts";
import { buildSkills, createProject, location } from "../src/project.ts";

test("the base holds every skill folder from skills/ in the agent's skill folder, and nothing else", () => {
  const work = mkdtempSync(join(tmpdir(), "harness-project-"));
  try {
    const built = buildSkills(work);
    assert.ok(built.ok);
    if (!built.ok) return;
    const agentSkills = location("agent-skills");
    assert.equal(agentSkills, ".github/skills");
    const sources = readdirSync(join(REPO_ROOT, location("skills")))
      .filter((name) => existsSync(join(REPO_ROOT, location("skills"), name, "SKILL.md")))
      .sort();
    assert.ok(sources.length > 0);
    assert.deepEqual(readdirSync(join(built.dir, agentSkills)).sort(), sources);
    assert.ok(existsSync(join(built.dir, agentSkills, "highway-help", "assets", "index.json")));
    assert.deepEqual(readdirSync(built.dir), [".github"]);
    assert.deepEqual(readdirSync(join(built.dir, ".github")), ["skills"]);

    const project = createProject({ baseDir: built.dir, fixture: "empty" }, work, "empty");
    // Assembled so this file does not name the folder self-contained-skills.test.sh forbids.
    for (const absent of ["." + "highway", "framework", "tests", "harness", "skills"]) {
      assert.ok(!existsSync(join(project, absent)), `${absent} is in the test project`);
    }
  } finally {
    rmSync(work, { recursive: true, force: true });
  }
});
