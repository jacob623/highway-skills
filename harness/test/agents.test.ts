import { test } from "node:test";
import assert from "node:assert/strict";
import { AGENTS, agentIds, keyOf } from "../src/agents.ts";

test("the registry holds Copilot with its keys, service, read roots, ask, and versions", () => {
  assert.deepEqual([...AGENTS.keys()], ["copilot", "cursor", "codex"]);
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
  assert.equal(agentIds(AGENTS), "copilot, cursor, codex");
});

test("the registry holds Cursor with CURSOR_API_KEY, local read roots, ask, and versions", () => {
  const cursor = AGENTS.get("cursor")!;
  assert.equal(cursor.service, "Cursor");
  assert.deepEqual(cursor.keys, ["CURSOR_API_KEY"]);
  assert.deepEqual(cursor.readRoots("/work/homes/x"), ["/work/homes/x/.cursor/plugins/local/highway"]);
  assert.equal(typeof cursor.ask, "function");
  assert.equal(cursor.versions().runtime, "local");
  assert.equal(cursor.classify(new Error("HTTP 429 Too Many Requests")), "rate-limit");
});

test("the registry holds Codex with API keys, plugin read roots, ask, and versions", () => {
  const codex = AGENTS.get("codex")!;
  assert.equal(codex.service, "Codex");
  assert.deepEqual(codex.keys, ["OPENAI_API_KEY", "CODEX_API_KEY"]);
  assert.deepEqual(codex.readRoots("/work/homes/x"), [
    "/work/homes/x",
    "/work/homes/x/plugins/highway",
    "/work/homes/x/plugins/cache/highway-local/highway",
  ]);
  assert.equal(typeof codex.ask, "function");
  assert.equal(codex.versions().runtime, "cli");
  assert.equal(codex.classify(new Error("HTTP 429 Too Many Requests")), "rate-limit");
});

test("a key is read from the agent's variables in order, ignoring empty values", () => {
  const copilot = AGENTS.get("copilot")!;
  assert.deepEqual(keyOf(copilot, { GITHUB_TOKEN: "b", COPILOT_GITHUB_TOKEN: "a" }), { name: "COPILOT_GITHUB_TOKEN", value: "a" });
  assert.deepEqual(keyOf(copilot, { GITHUB_TOKEN: "b", COPILOT_GITHUB_TOKEN: "" }), { name: "GITHUB_TOKEN", value: "b" });
  assert.equal(keyOf(copilot, {}), undefined);
});
