import { test } from "node:test";
import assert from "node:assert/strict";
import { globToRegExp, matchesAny, parseScenario, ScenarioError } from "../src/scenario.ts";

const EXAMPLE = `# comment
id: codify-plan-review
skill: highway-codify
through: highway-implementation
fixture: implementation
smoke: no
open: /highway-codify Northwind Order Service
ask: What would you add, correct, or remove?
say: [accept] Looks good.
ask-pattern: ^Would you like
say: 1
writes: code/**
expect: exists code/code.md
expect: heading code/*/plan.md :: ## User Stories
covers: 0123456789ab Reviewing the plan reads every section.
reaches: review
`;

test("parses every key with line numbers", () => {
  const s = parseScenario(EXAMPLE, "x.scenario");
  assert.equal(s.id, "codify-plan-review");
  assert.deepEqual(s.through, ["highway-implementation"]);
  assert.equal(s.smoke, false);
  assert.equal(s.replies.length, 2);
  assert.deepEqual(s.replies[0], { key: { type: "text", text: "What would you add, correct, or remove?" }, say: "Looks good.", kind: "accept", line: 8 });
  assert.equal(s.replies[1].kind, undefined);
  assert.deepEqual(s.expects[1], { assertion: "heading", path: "code/*/plan.md", argument: "## User Stories", line: 14 });
  assert.equal(s.covers[0].hash, "0123456789ab");
  assert.deepEqual(s.reaches, ["review"]);
});

test("rejects a say with no key, an unknown key, and a bad chain", () => {
  assert.throws(() => parseScenario("say: hi\n", "x"), ScenarioError);
  assert.throws(() => parseScenario(EXAMPLE + "bogus: 1\n", "x"), /unknown key/);
  assert.throws(() => parseScenario(EXAMPLE + "chain: 7\n", "x"), /chain/);
  assert.throws(() => parseScenario(EXAMPLE + "expect: heading code/x.md\n", "x"), /needs an argument/);
  assert.throws(() => parseScenario(EXAMPLE + "ask: dangling\n", "x"), /no "say"/);
});

test("globs: * stays in a folder, ** crosses folders", () => {
  assert.ok(globToRegExp("code/*/plan.md").test("code/a/plan.md"));
  assert.ok(!globToRegExp("code/*/plan.md").test("code/a/b/plan.md"));
  assert.ok(globToRegExp("code/**").test("code/a/b/plan.md"));
  assert.ok(globToRegExp("code/**/plan.md").test("code/plan.md"));
  assert.ok(matchesAny("code/a.md", ["x/**", "code/*.md"]));
  assert.ok(!matchesAny("codex/a.md", ["code/**"]));
});
