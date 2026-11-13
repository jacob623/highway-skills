import { test } from "node:test";
import assert from "node:assert/strict";
import { classifyError, FAILURE_KINDS, formatFailure, likelyCause, retryServiceError, type Failure } from "../src/failure.ts";
import { createRedactor, REDACTED } from "../src/redact.ts";

const redact = createRedactor({ GITHUB_TOKEN: "ghp_secretsecretsecretsecretsecret1234" });

test("every failure kind has a fixed likely cause, and the same failure prints the same cause", () => {
  for (const kind of FAILURE_KINDS) {
    const cause = likelyCause({ kind });
    assert.ok(cause.length > 10, `${kind} has no cause`);
    assert.equal(likelyCause({ kind }), cause);
  }
});

test("repeated-question is a failure kind with its own cause", () => {
  assert.ok((FAILURE_KINDS as readonly string[]).includes("repeated-question"));
  assert.match(likelyCause({ kind: "repeated-question" }), /already spent/);
});

test("turn-limit names a repeated question", () => {
  assert.match(likelyCause({ kind: "turn-limit", repeated: { question: "Proceed?", count: 4 } }), /repeated the question "Proceed\?" 4 times/);
});

test("the block holds where, what, covers, recent, rejected, cause, and a parseable HARNESS-FAILURE line", () => {
  const failure: Failure = {
    kind: "assertion",
    scenario: "codify-decline",
    file: "harness/scenarios/highway-codify/codify-decline.scenario",
    attempt: 2,
    attempts: 2,
    stage: null,
    turn: 6,
    step: "revise",
    check: "absent",
    path: "code/*/.highway/features/*/codify.md",
    expected: "no file",
    actual: "code/worker/.highway/features/001-restart-the-worker/codify.md",
    line: 18,
    covers: [{ hash: "4f2a91c0d3e1", text: "Declining a proposal writes nothing.", line: 20 }],
    recent: ["agent: Here is a proposal", "harness: Stop here."],
    rejected: ["shell: rm -rf /"],
  };
  const block = formatFailure(failure, "20261110-153512Z-targeted-a1b2c3d", redact);
  const lines = block.split("\n");
  assert.equal(lines[0], "==== FAILURE codify-decline (attempt 2 of 2) ====");
  assert.match(block, /^Where: {3}harness\/scenarios\/highway-codify\/codify-decline\.scenario; stage -; turn 6; step revise$/m);
  assert.match(block, /^What: {4}absent code\/\*\/\.highway\/features\/\*\/codify\.md$/m);
  assert.match(block, /expected: no file; actual: code\/worker/);
  assert.match(block, /declared at line 18/);
  assert.match(block, /^Covers: {2}4f2a91c0d3e1 Declining a proposal writes nothing\.$/m);
  assert.match(block, /^Rejected: shell: rm -rf \/$/m);
  assert.match(block, /^Likely cause: A written file is missing a required part/m);
  const json = JSON.parse(lines[lines.length - 1].replace(/^HARNESS-FAILURE /, ""));
  assert.equal(json.kind, "assertion");
  assert.equal(json.line, 18);
  assert.deepEqual(json.covers, ["4f2a91c0d3e1"]);
  assert.equal(json.cause, likelyCause(failure));
});

test("a run-level failure has no scenario and prints its detail", () => {
  const block = formatFailure({ kind: "build-failed", detail: "line 1\nline 2\nerror: boom" }, "r", redact);
  assert.match(block, /^==== FAILURE run ====$/m);
  assert.match(block, /error: boom/);
});

test("the block is redacted and recent turns are capped", () => {
  const recent = Array.from({ length: 50 }, (_, i) => `turn ${i} ghp_secretsecretsecretsecretsecret1234 ${"x".repeat(300)}`);
  const block = formatFailure({ kind: "timeout", scenario: "s", recent }, "r", redact);
  assert.ok(!block.includes("ghp_secret"));
  assert.ok(block.includes(REDACTED));
  for (const line of block.split("\n")) if (!line.startsWith("HARNESS-FAILURE")) assert.ok(line.length <= 220, `long line: ${line.length}`);
  const recentLines = block.split("\n").filter((l) => /turn \d+/.test(l));
  assert.ok(recentLines.length <= 20);
});

test("errors are classified by message", () => {
  assert.equal(classifyError(new Error("HTTP 429 Too Many Requests")), "rate-limit");
  assert.equal(classifyError(new Error("You have exceeded your premium request allowance")), "allowance");
  assert.equal(classifyError(new Error("401 Unauthorized")), "no-access");
  assert.equal(classifyError(new Error("socket hang up")), "unclassified");
});

test("a Copilot -32603 error is a service error with its own cause", () => {
  const error = Object.assign(new Error("No response was returned. Send your message again to retry."), { code: -32603 });
  assert.equal(classifyError(error), "service-error");
  assert.equal(classifyError(new Error("Request failed (code -32603)")), "service-error");
  assert.ok(FAILURE_KINDS.includes("service-error"));
  assert.match(likelyCause({ kind: "service-error" }), /Copilot service/);
  assert.match(likelyCause({ kind: "service-error" }), /retried once/);
});

test("a service error is retried once; any other error is rethrown", async () => {
  const serviceError = new Error("No response was returned. Send your message again to retry. (code -32603)");
  let calls = 0;
  const retries: unknown[] = [];
  const value = await retryServiceError(async () => {
    calls += 1;
    if (calls === 1) throw serviceError;
    return "ok";
  }, (e) => retries.push(e));
  assert.equal(value, "ok");
  assert.equal(calls, 2);
  assert.deepEqual(retries, [serviceError]);

  calls = 0;
  await assert.rejects(retryServiceError(async () => { calls += 1; throw serviceError; }, () => {}), serviceError);
  assert.equal(calls, 2);

  calls = 0;
  const other = new Error("socket hang up");
  await assert.rejects(retryServiceError(async () => { calls += 1; throw other; }, () => assert.fail("no retry")), other);
  assert.equal(calls, 1);
});
