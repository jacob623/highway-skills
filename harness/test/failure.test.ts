import { test } from "node:test";
import assert from "node:assert/strict";
import { classifyCopilotError } from "../src/drivers/copilot.ts";
import { EXIT_2_KINDS, FAILURE_KINDS, likelyCause, retryServiceError } from "../src/failure.ts";

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

test("missing-token and no-access name the agent's service and key variable", () => {
  assert.equal(likelyCause({ kind: "missing-token", service: "Copilot", key: "GITHUB_TOKEN" }), "No Copilot token was found. Set GITHUB_TOKEN in harness/.env.");
  assert.equal(likelyCause({ kind: "no-access", service: "Copilot", key: "GITHUB_TOKEN" }), "The GITHUB_TOKEN key has no Copilot access. Check the account's Copilot plan.");
  assert.equal(likelyCause({ kind: "missing-token", service: "Cursor", key: "CURSOR_API_KEY" }), "No Cursor token was found. Set CURSOR_API_KEY in harness/.env.");
});

test("Copilot errors are classified by message", () => {
  assert.equal(classifyCopilotError(new Error("HTTP 429 Too Many Requests")), "rate-limit");
  assert.equal(classifyCopilotError(new Error("You have exceeded your premium request allowance")), "allowance");
  assert.equal(classifyCopilotError(new Error("401 Unauthorized")), "no-access");
  assert.equal(classifyCopilotError(new Error("socket hang up")), "unclassified");
});

test("a Copilot -32603 error is a service error with its own cause", () => {
  const error = Object.assign(new Error("No response was returned. Send your message again to retry."), { code: -32603 });
  assert.equal(classifyCopilotError(error), "service-error");
  assert.equal(classifyCopilotError(new Error("Request failed (code -32603)")), "service-error");
  assert.ok(FAILURE_KINDS.includes("service-error"));
  assert.match(likelyCause({ kind: "service-error" }), /Copilot service/);
  assert.match(likelyCause({ kind: "service-error" }), /retried once/);
});

test("a failed plugin install fails the scenario and does not stop the run", () => {
  assert.ok(FAILURE_KINDS.includes("plugin-install"));
  assert.ok(!EXIT_2_KINDS.has("plugin-install"));
  assert.match(likelyCause({ kind: "plugin-install" }), /did not install or load from highway-agent-plugin\//);
});

test("a service error, by the driver's classifier, is retried once; any other error is rethrown", async () => {
  const serviceError = new Error("No response was returned. Send your message again to retry. (code -32603)");
  let calls = 0;
  const retries: unknown[] = [];
  const value = await retryServiceError(
    async () => {
      calls += 1;
      if (calls === 1) throw serviceError;
      return "ok";
    },
    classifyCopilotError,
    (e) => retries.push(e),
  );
  assert.equal(value, "ok");
  assert.equal(calls, 2);
  assert.deepEqual(retries, [serviceError]);

  calls = 0;
  await assert.rejects(retryServiceError(async () => { calls += 1; throw serviceError; }, classifyCopilotError, () => {}), serviceError);
  assert.equal(calls, 2);

  calls = 0;
  const other = new Error("socket hang up");
  await assert.rejects(retryServiceError(async () => { calls += 1; throw other; }, classifyCopilotError, () => assert.fail("no retry")), other);
  assert.equal(calls, 1);

  calls = 0;
  await assert.rejects(retryServiceError(async () => { calls += 1; throw serviceError; }, () => "unclassified", () => assert.fail("no retry")), serviceError);
  assert.equal(calls, 1);
});
