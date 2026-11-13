import { test } from "node:test";
import assert from "node:assert/strict";
import { cpSync, existsSync, mkdtempSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { REPO_ROOT } from "../src/config.ts";
import { buildPlugin, createProject, location } from "../src/project.ts";

test("the run uses the current plugin build, and the base project is empty", () => {
  const work = mkdtempSync(join(tmpdir(), "harness-project-"));
  try {
    const built = buildPlugin(work);
    assert.ok(built.ok, built.ok ? "" : built.tail);
    if (!built.ok) return;
    assert.equal(location("plugin"), "highway-agent-plugin");
    assert.equal(built.plugin.dir, join(REPO_ROOT, location("plugin")));
    assert.equal(built.plugin.name, "highway");
    const sources = readdirSync(join(REPO_ROOT, location("skills"))).filter((name) =>
      existsSync(join(REPO_ROOT, location("skills"), name, "SKILL.md")),
    );
    assert.ok(sources.length > 0);
    assert.equal(built.plugin.skills, sources.length);
    assert.deepEqual(readdirSync(built.dir), []);

    const project = createProject({ baseDir: built.dir, fixture: "empty" }, work, "empty");
    // Assembled so this file does not name the folder self-contained-skills.test.sh forbids.
    for (const absent of ["." + "highway", ".github", "framework", "tests", "harness", "skills", location("plugin")]) {
      assert.ok(!existsSync(join(project, absent)), `${absent} is in the test project`);
    }
  } finally {
    rmSync(work, { recursive: true, force: true });
  }
});

test("a stale plugin stops the run with the DRIFT lines", () => {
  const work = mkdtempSync(join(tmpdir(), "harness-project-"));
  try {
    const repo = join(work, "repo");
    for (const name of [location("skills"), location("framework"), location("plugin")]) {
      cpSync(join(REPO_ROOT, name), join(repo, name), { recursive: true });
    }
    writeFileSync(join(repo, location("plugin"), "NOTES.md"), "stale\n");
    const built = buildPlugin(join(work, "run"), repo);
    assert.equal(built.ok, false);
    if (built.ok) return;
    assert.match(built.tail, /^DRIFT\textra\tNOTES\.md$/m);
    assert.match(built.tail, /Run framework\/generate-agent-plugin\.sh/);
    assert.ok(!existsSync(join(work, "run", "base")));
  } finally {
    rmSync(work, { recursive: true, force: true });
  }
});
