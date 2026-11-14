import { test } from "node:test";
import assert from "node:assert/strict";
import { AGENTS, agentIds, keyOf } from "../src/agents.ts";

test("the registry holds Copilot with its keys, service, read roots, ask, and versions", () => {
  assert.deepEqual([...AGENTS.keys()], ["copilot"]);
  const copilot = AGENTS.get("copilot")!;
  assert.equal(copilot.id, "copilot");
  assert.equal(copilot.service, "Copilot");
  assert.deepEqual(copilot.keys, ["COPILOT_GITHUB_TOKEN", "GITHUB_TOKEN"]);
  assert.deepEqual(copilot.readRoots("/work/homes/x"), ["/work/homes/x/installed-plugins"]);
  assert.equal(typeof copilot.ask, "function");
  const versions = copilot.versions();
  assert.match(versions.sdk, /^\d+\.\d+\.\d+|unknown$/);
  assert.match(versions.runtime, /^\d+\.\d+\.\d+|unknown$/);
  assert.equal(copilot.classify(new Error("HTTP 429 Too Many Requests")), "rate-limit");
  assert.equal(agentIds(AGENTS), "copilot");
});

test("a key is read from the agent's variables in order, ignoring empty values", () => {
  const copilot = AGENTS.get("copilot")!;
  assert.deepEqual(keyOf(copilot, { GITHUB_TOKEN: "b", COPILOT_GITHUB_TOKEN: "a" }), { name: "COPILOT_GITHUB_TOKEN", value: "a" });
  assert.deepEqual(keyOf(copilot, { GITHUB_TOKEN: "b", COPILOT_GITHUB_TOKEN: "" }), { name: "GITHUB_TOKEN", value: "b" });
  assert.equal(keyOf(copilot, {}), undefined);
});
