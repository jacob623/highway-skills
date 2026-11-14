import { test } from "node:test";
import assert from "node:assert/strict";
import { mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { Agent, Registry } from "../src/agents.ts";
import { parseArgs } from "../src/args.ts";
import { readFileConfig, resolveConfig, type FileConfig } from "../src/config.ts";
import { emptyUsage } from "../src/driver.ts";

function agent(id: string, keys: string[], ask = true): Agent {
  return {
    id,
    service: id === "copilot" ? "Copilot" : "Other",
    keys,
    driver: async () => ({ outcome: "ended", turns: 0, rejected: [], warnings: [], usage: emptyUsage(), usedReplies: [], skillsInvoked: [], skillsBeforeOutput: [], lastMessage: "" }),
    ask: ask ? () => async () => "" : undefined,
    classify: () => "unclassified",
    readRoots: (home) => [join(home, "plugins")],
    versions: () => ({ sdk: "1", runtime: "2" }),
  };
}

const AGENTS: Registry = new Map([
  ["copilot", agent("copilot", ["COPILOT_GITHUB_TOKEN", "GITHUB_TOKEN"])],
  ["other", agent("other", ["OTHER_API_KEY"])],
  ["mute", agent("mute", ["MUTE_API_KEY"], false)],
]);

const FILE: FileConfig = {
  agent: "copilot",
  models: { copilot: "gpt-5.6-luna", other: "other-1" },
  judge: { agent: "copilot", model: "judge-1" },
  parallel: 4,
  maxTurns: 40,
  timeoutMinutes: 20,
};
const ENV = { GITHUB_TOKEN: "ghp_" + "a".repeat(36), OTHER_API_KEY: "other-key-value" };

function resolve(argv: string[], file: FileConfig = FILE, env: Record<string, string | undefined> = ENV) {
  const parsed = parseArgs(argv);
  assert.ok(parsed.ok, parsed.ok ? "" : parsed.error);
  return resolveConfig(parsed.options, file, env, AGENTS);
}

function fileWith(content: unknown): string {
  const dir = mkdtempSync(join(tmpdir(), "harness-config-"));
  const file = join(dir, "harness.config.json");
  writeFileSync(file, JSON.stringify(content));
  return file;
}

test("the configured agent and its model are the default; switches override both", () => {
  const plain = resolve([]);
  assert.equal(plain.agent, "copilot");
  assert.equal(plain.model, "gpt-5.6-luna");
  assert.equal(plain.key, ENV.GITHUB_TOKEN);
  assert.equal(plain.keyName, "GITHUB_TOKEN");
  const other = resolve(["--agent", "other"]);
  assert.equal(other.agent, "other");
  assert.equal(other.model, "other-1");
  assert.equal(other.key, "other-key-value");
  assert.equal(resolve(["--agent", "other", "--model", "other-2"]).model, "other-2");
});

test("COPILOT_GITHUB_TOKEN is read before GITHUB_TOKEN", () => {
  const config = resolve([], FILE, { ...ENV, COPILOT_GITHUB_TOKEN: "first-token-value" });
  assert.equal(config.key, "first-token-value");
  assert.equal(config.keyName, "COPILOT_GITHUB_TOKEN");
});

test("an unregistered agent names the registered agents", () => {
  assert.throws(() => resolve(["--agent", "cursor"]), /unknown agent "cursor"; registered agents: copilot, other, mute/);
});

test("an agent with no models entry and no --model names the missing entry", () => {
  assert.throws(() => resolve(["--agent", "mute"]), /models\.mute/);
  assert.equal(resolve(["--agent", "mute", "--model", "m", "--no-judge"]).model, "m");
});

test("a missing or empty agent is named", () => {
  assert.throws(() => resolve([], { ...FILE, agent: "" }), /"agent"/);
  assert.throws(() => resolve([], { ...FILE, agent: undefined }), /"agent"/);
});

test("the old model and transcripts fields, and a malformed models map, are refused", () => {
  const base = { agent: "copilot", models: { copilot: "m" }, judge: { agent: "copilot", model: "m" } };
  const files = [fileWith({ ...base, model: "m" }), fileWith({ ...base, transcripts: "out" }), fileWith({ ...base, models: "m" })];
  try {
    assert.throws(() => readFileConfig(files[0]), /"model" is replaced by "models"/);
    assert.throws(() => readFileConfig(files[1]), /"transcripts" is removed; pass --transcripts <dir>/);
    assert.throws(() => readFileConfig(files[2]), /"models"/);
  } finally {
    for (const f of files) rmSync(join(f, ".."), { recursive: true, force: true });
  }
});

test("the shipped configuration reads, with agent, models, and judge", () => {
  const file = readFileConfig();
  assert.equal(file.agent, "copilot");
  assert.equal(typeof file.models.copilot, "string");
  assert.equal(file.judge?.agent, "copilot");
  assert.equal(file.judge?.model, file.models.copilot);
});

test("the judge comes from the judge block, and each switch overrides its field", () => {
  const plain = resolve([]);
  assert.equal(plain.judgeAgent, "copilot");
  assert.equal(plain.judgeModel, "judge-1");
  assert.equal(plain.judge, true);
  assert.equal(resolve(["--model", "x"]).judgeModel, "judge-1");
  assert.equal(resolve(["--judge-model", "judge-2"]).judgeModel, "judge-2");
  const other = resolve(["--judge-agent", "other", "--judge-model", "other-j"]);
  assert.equal(other.judgeAgent, "other");
  assert.equal(other.judgeModel, "other-j");
  assert.equal(other.judgeKey, "other-key-value");
});

test("a missing judge block, or an empty judge field, is named", () => {
  assert.throws(() => resolve([], { ...FILE, judge: undefined }), /"judge"/);
  assert.throws(() => resolve([], { ...FILE, judge: { agent: "", model: "j" } }), /"judge\.agent"/);
  assert.throws(() => resolve([], { ...FILE, judge: { agent: "copilot", model: "" } }), /"judge\.model"/);
  assert.equal(resolve(["--judge-agent", "copilot", "--judge-model", "j"], { ...FILE, judge: undefined }).judgeModel, "j");
});

test("an unregistered judge agent, or one with no one-shot question, is refused", () => {
  assert.throws(() => resolve(["--judge-agent", "cursor"]), /unknown judge agent "cursor"; registered agents: copilot, other, mute/);
  assert.throws(() => resolve(["--judge-agent", "mute"]), /judge agent "mute" offers no one-shot question/);
});

test("a missing judge key is named, --no-judge skips the check, and a judge on the agent under test needs one key", () => {
  assert.throws(() => resolve(["--judge-agent", "other"], FILE, { GITHUB_TOKEN: ENV.GITHUB_TOKEN }), /OTHER_API_KEY/);
  const off = resolve(["--judge-agent", "other", "--no-judge"], FILE, { GITHUB_TOKEN: ENV.GITHUB_TOKEN });
  assert.equal(off.judge, false);
  assert.equal(off.judgeKey, undefined);
  const same = resolve([], FILE, {});
  assert.equal(same.key, undefined);
  assert.equal(same.judge, true);
});

test("--transcripts is the only way to a run folder, and --verbose is off by default", () => {
  assert.equal(resolve([]).transcripts, undefined);
  assert.equal(resolve([]).verbose, false);
  assert.equal(resolve(["--transcripts", "/tmp/runs"]).transcripts, "/tmp/runs");
  assert.equal(resolve(["--verbose"]).verbose, true);
});
