import { test } from "node:test";
import assert from "node:assert/strict";
import { existsSync, mkdtempSync, readdirSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { emptyUsage } from "../src/driver.ts";
import { createRedactor } from "../src/redact.ts";
import { exitCode, renderJunit, renderReportMd, runId, writeRunReports, type AttemptResult, type Run, type ScenarioOutcome } from "../src/report.ts";

function attempt(n: number, status: "pass" | "fail"): AttemptResult {
  return {
    scenario: "s",
    attempt: n,
    agent: "copilot",
    model: "m",
    judgeAgent: "copilot",
    judgeModel: "m",
    judge: "ran",
    status,
    failures: [],
    warnings: [],
    usage: { ...emptyUsage(), calls: 2, inputTokens: 100, outputTokens: 10 },
    judgeVerdicts: [],
    turns: 3,
    durationMs: 1000,
    stage: null,
    skillsInvoked: [],
    repliesUsed: [],
  };
}

function run(outcomes: ScenarioOutcome[], folder: string | undefined = "/tmp/x"): Run {
  return {
    id: "r",
    type: "targeted",
    commit: "abc1234",
    agent: "copilot",
    model: "m",
    judgeAgent: "copilot",
    judgeModel: "m",
    fallback: "copilot/m",
    sdkVersion: "1",
    runtimeVersion: "1",
    startedAt: "t",
    folder,
    outcomes,
    runFailures: [],
  };
}

const pass: ScenarioOutcome = { scenario: "a", file: "f", skill: "highway-codify", status: "pass", reasons: ["--skills highway-codify"], attempts: [attempt(1, "pass")], warnings: [] };
const flaky: ScenarioOutcome = {
  ...pass,
  scenario: "b",
  attempts: [attempt(1, "fail"), attempt(2, "pass")],
  warnings: [{ kind: "flaky", message: "failed attempt 1, passed attempt 2" }],
};
const fail: ScenarioOutcome = { ...pass, scenario: "c", status: "fail", attempts: [attempt(1, "fail"), attempt(2, "fail")], failure: { kind: "assertion", check: "exists", path: "code/code.md" } };

test("run ids use UTC start, type, and short commit", () => {
  assert.equal(runId(new Date(Date.UTC(2026, 10, 10, 15, 35, 12)), "targeted", "a1b2c3d4e5", "copilot"), "20261110-153512Z-targeted-a1b2c3d");
});

test("a run id carries the agent after the type for any agent but Copilot", () => {
  const start = new Date(Date.UTC(2026, 10, 10, 15, 35, 12));
  assert.equal(runId(start, "smoke", "a1b2c3d4e5", "copilot"), "20261110-153512Z-smoke-a1b2c3d");
  assert.equal(runId(start, "smoke", "a1b2c3d4e5", "cursor"), "20261110-153512Z-smoke-cursor-a1b2c3d");
});

test("the report names the agent, its SDK and runtime versions, the judge agent, and the fallback", () => {
  const md = renderReportMd({ ...run([pass]), agent: "copilot", judgeAgent: "copilot", judgeModel: "j", fallback: "copilot/j", sdkVersion: "1.0.30", runtimeVersion: "1.0.108" });
  assert.match(md, /^- Agent: copilot$/m);
  assert.match(md, /^- Judge: copilot\/j$/m);
  assert.match(md, /^- Reply fallback: copilot\/j$/m);
  assert.match(md, /^- SDK 1\.0\.30, runtime 1\.0\.108$/m);
  assert.doesNotMatch(md, /Copilot SDK/);
  const off = renderReportMd({ ...run([pass]), judgeAgent: null, judgeModel: null, fallback: "off" });
  assert.match(off, /^- Judge: skipped \(--no-judge\)$/m);
  assert.match(off, /^- Reply fallback: off$/m);
});

test("exit codes: 0 pass, 1 failure, 2 wins over 1", () => {
  assert.equal(exitCode(run([pass, flaky])), 0);
  assert.equal(exitCode(run([pass, fail])), 1);
  assert.equal(exitCode({ ...run([fail]), runFailures: [{ kind: "rate-limit" }] }), 2);
  assert.equal(exitCode({ ...run([]), runFailures: [{ kind: "chain-stage" }] }), 1);
});

test("junit marks failures and skips", () => {
  const xml = renderJunit(run([pass, fail, { ...pass, scenario: "d", status: "skipped", attempts: [] }]));
  assert.match(xml, /<testsuites name="highway-harness" tests="3" failures="1" skipped="1">/);
  assert.match(xml, /<failure message="assertion: /);
  assert.match(xml, /<skipped message="skipped by a failed chain stage"\/>/);
});

test("reports are written and redacted", () => {
  const folder = mkdtempSync(join(tmpdir(), "harness-report-"));
  const secret = "ghp_" + "z".repeat(36);
  const r = run([{ ...fail, failure: { kind: "assertion", actual: secret } }], folder);
  writeRunReports(r, [{ scenario: "c", file: "f", reasons: ["--paths x"] }], createRedactor({}));
  for (const name of ["report.md", "report.json", "junit.xml", "selection.txt"]) {
    const content = readFileSync(join(folder, name), "utf8");
    assert.ok(!content.includes(secret), `${name} leaks the token`);
  }
  assert.match(readFileSync(join(folder, "selection.txt"), "utf8"), /^c\t--paths x$/m);
  assert.match(readFileSync(join(folder, "report.md"), "utf8"), /## Judge/);
  rmSync(folder, { recursive: true });
});

test("a run without a folder writes no report", () => {
  const parent = mkdtempSync(join(tmpdir(), "harness-report-"));
  writeRunReports(run([pass], undefined), [], createRedactor({}));
  assert.deepEqual(readdirSync(parent), []);
  assert.ok(!existsSync(join(parent, "report.md")));
  rmSync(parent, { recursive: true });
});
