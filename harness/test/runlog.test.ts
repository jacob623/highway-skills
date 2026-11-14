import { test } from "node:test";
import assert from "node:assert/strict";
import { mkdirSync, mkdtempSync, realpathSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { emptyUsage, type TranscriptEntry } from "../src/driver.ts";
import type { AttemptResult, Run, ScenarioOutcome } from "../src/report.ts";
import { OrderedLog, pathRewriter, renderBlock, renderBlockedBlock, renderRunBlock, renderSummary, type AttemptBlock } from "../src/runlog.ts";

const entry = (turn: number, role: TranscriptEntry["role"], text: string): TranscriptEntry => ({ turn, role, text });

function block(overrides: Partial<AttemptBlock> = {}): AttemptBlock {
  return {
    scenario: "help-smoke",
    skill: "highway-help",
    attempt: 1,
    transcript: [
      entry(0, "system", "installed plugin highway (16 skills)\nDirect plugin installs are deprecated."),
      entry(1, "user", "/highway-help"),
      entry(1, "skill", "invoked highway-experience"),
      entry(1, "permission", "approved read: skills/highway-help/SKILL.md"),
      entry(1, "permission", "rejected read: <home>/config.json"),
      entry(1, "question", "Which record?\n1. First\n\n2. Second"),
      entry(1, "answer", "1"),
      entry(1, "agent", "Highway needs setup.\n\nRun /highway-setup to get started."),
      entry(2, "user", "Thanks."),
      entry(2, "agent", "Done."),
    ],
    files: [{ afterIndex: 7, created: ["out/answer.md"], changed: ["notes.md"], deleted: ["old.md"] }],
    failures: [],
    verdicts: [],
    warnings: [],
    usage: { ...emptyUsage(), calls: 3, inputTokens: 1200, outputTokens: 80 },
    verbose: false,
    ...overrides,
  };
}

test("a block reads as a labeled conversation with indented continuation lines and files after the turn's reply", () => {
  assert.deepEqual(renderBlock(block()), [
    "",
    "== help-smoke (highway-help) attempt 1 ==",
    "system: installed plugin highway (16 skills)",
    "  Direct plugin installs are deprecated.",
    "user: /highway-help",
    "skill: highway-experience",
    "denied: read <home>/config.json",
    "question: Which record?",
    "  1. First",
    "  2. Second",
    "answer: 1",
    "agent: Highway needs setup.",
    "  Run /highway-setup to get started.",
    "files: out/answer.md (created), notes.md (changed), old.md (deleted)",
    "user: Thanks.",
    "agent: Done.",
    "result: pass",
  ]);
});

test("a turn that changed nothing has no files line", () => {
  const lines = renderBlock(block({ files: [] }));
  assert.ok(!lines.some((l) => l.startsWith("files:")));
});

test("--verbose adds approved requests and usage, and changes nothing else", () => {
  const plain = renderBlock(block());
  const verbose = renderBlock(block({ verbose: true }));
  assert.ok(verbose.includes("approved: read skills/highway-help/SKILL.md"));
  assert.ok(verbose.includes("usage: 3 calls, 1200 input tokens, 80 output tokens"));
  assert.deepEqual(verbose.filter((l) => !l.startsWith("approved:") && !l.startsWith("usage:")), plain);
});

test("failures, paraphrase warnings, and not met verdicts close the block; met verdicts and evidence do not show", () => {
  const lines = renderBlock(
    block({
      failures: [
        { kind: "assertion", check: "exists", path: "out/answer.md", expected: "a matching file", actual: "none", line: 7 },
        { kind: "rejected-request", check: "storage", expected: "no shell, memory, or outside-write request", actual: "shell: ls\n-la" },
      ],
      warnings: [
        { kind: "paraphrased-question", message: 'Paraphrased question at turn 2: expected "a", got "b"' },
        { kind: "flaky", message: "failed attempt 1, passed attempt 2" },
      ],
      verdicts: [
        { hash: "aaaaaaaaaaaa", text: "The menu offers two options.", verdict: "met", evidence: "QUOTED", reason: "Shown." },
        { hash: "bbbbbbbbbbbb", text: "Declining writes nothing.", verdict: "not met", evidence: "QUOTED", reason: "A file was written." },
        { hash: "cccccccccccc", text: "The close names the next skill.", verdict: "not met", evidence: "", reason: "", note: "The judge returned no verdict for this bullet." },
      ],
    }),
  );
  const tail = lines.slice(lines.indexOf("agent: Done.") + 1);
  assert.deepEqual(tail, [
    'warning: Paraphrased question at turn 2: expected "a", got "b"',
    "fail: assertion exists out/answer.md: expected a matching file; actual none (scenario line 7)",
    "fail: rejected-request storage: expected no shell, memory, or outside-write request; actual shell: ls -la",
    "not met: Declining writes nothing. - A file was written.",
    "not met: The close names the next skill. - The judge returned no verdict for this bullet.",
  ]);
  assert.ok(!lines.join("\n").includes("QUOTED"));
});

test("a fail line leaves out empty parts and is capped", () => {
  const [line] = renderBlock(block({ failures: [{ kind: "service-error", check: "session", actual: "x".repeat(1000) }] })).filter((l) => l.startsWith("fail:"));
  assert.match(line, /^fail: service-error session: actual x+…$/);
  assert.ok(line.length <= 400);
});

test("a run block names the failure, its detail, and its likely cause", () => {
  assert.deepEqual(
    renderRunBlock({ kind: "missing-token", check: "token", expected: "COPILOT_GITHUB_TOKEN or GITHUB_TOKEN", actual: "neither is set", service: "Copilot", key: "GITHUB_TOKEN" }),
    ["", "== run ==", "fail: missing-token token: expected COPILOT_GITHUB_TOKEN or GITHUB_TOKEN; actual neither is set", "cause: No Copilot token was found. Set GITHUB_TOKEN in harness/.env."],
  );
  const build = renderRunBlock({ kind: "build-failed", check: "plugin", detail: "DRIFT a\nDRIFT b" });
  assert.deepEqual(build.slice(2, 5), ["fail: build-failed plugin", "  DRIFT a", "  DRIFT b"]);
});

test("a blocked scenario prints a block with its fixture problems", () => {
  assert.deepEqual(renderBlockedBlock("help-smoke", "highway-help", { kind: "fixture-blocked", check: "fixture", path: "setup", detail: "profile.md: missing heading" }), [
    "",
    "== help-smoke (highway-help) blocked ==",
    "fail: fixture-blocked fixture setup",
    "  profile.md: missing heading",
  ]);
});

test("project paths become relative, the agent home becomes <home>, and the work root becomes <work>, through real paths too", () => {
  const work = mkdtempSync(join(tmpdir(), "harness-runlog-"));
  try {
    const project = join(work, "projects", "p-1");
    const home = join(work, "homes", "h-1");
    mkdirSync(project, { recursive: true });
    mkdirSync(home, { recursive: true });
    const rewrite = pathRewriter({ project, home, work });
    assert.equal(rewrite(`read ${project}/out/a.md`), "read out/a.md");
    assert.equal(rewrite(`cwd ${project}`), "cwd .");
    assert.equal(rewrite(`read ${home}/config.json`), "read <home>/config.json");
    assert.equal(rewrite(`base ${work}/base`), "base <work>/base");
    const real = realpathSync(project);
    assert.equal(rewrite(`read ${real}/b.md`), "read b.md");
  } finally {
    rmSync(work, { recursive: true, force: true });
  }
});

test("a path the agent made up under the temporary folder becomes <tmp>, the more specific roots first", () => {
  const rewrite = pathRewriter({ project: "/tmp-root/T/w/projects/p-1", work: "/tmp-root/T/w", tmp: "/tmp-root/T" });
  assert.equal(rewrite("read /tmp-root/T/other/a.md"), "read <tmp>/other/a.md");
  assert.equal(rewrite("read /tmp-root/T/w/base"), "read <work>/base");
  assert.equal(rewrite("read /tmp-root/T/w/projects/p-1/a.md"), "read a.md");
});

test("on macOS the per-user folder above T becomes <tmp> too, for a path that drops T", () => {
  const rewrite = pathRewriter({ tmp: "/var/folders/8c/abc123/T" });
  assert.equal(
    rewrite("read /var/folders/8c/abc123/projects/implementation-smoke-1-x/implementations/capabilities.md"),
    "read <tmp>/projects/implementation-smoke-1-x/implementations/capabilities.md",
  );
  assert.equal(rewrite("read /var/folders/8c/abc123/T/x"), "read <tmp>/x");
  assert.equal(pathRewriter({ tmp: "/tmp" })("read /x/tmp/y and /tmp.bak"), "read /x/tmp/y and /tmp.bak");
});

function attempt(n: number, status: "pass" | "fail", turns = 3, verdicts: AttemptResult["judgeVerdicts"] = []): AttemptResult {
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
    judgeVerdicts: verdicts,
    turns,
    durationMs: 1000,
    stage: null,
    skillsInvoked: [],
    repliesUsed: [],
  };
}

const outcome = (scenario: string, status: ScenarioOutcome["status"], extra: Partial<ScenarioOutcome> = {}): ScenarioOutcome => ({
  scenario,
  file: "f",
  skill: "highway-help",
  status,
  reasons: [],
  attempts: [],
  warnings: [],
  ...extra,
});

function run(outcomes: ScenarioOutcome[], extra: Partial<Run> = {}): Run {
  return {
    id: "r",
    type: "smoke",
    commit: "abc",
    agent: "copilot",
    model: "m",
    judgeAgent: "copilot",
    judgeModel: "m",
    fallback: "copilot/m",
    sdkVersion: "1",
    runtimeVersion: "2",
    startedAt: "t",
    outcomes,
    runFailures: [],
    ...extra,
  };
}

const met = (verdict: "met" | "not met") => ({ hash: "h", text: "t", verdict, evidence: "", reason: "" });

test("the closing table has one row per scenario, then counts, usage, and the exit code", () => {
  const lines = renderSummary(
    run([
      outcome("pass-a", "pass", { attempts: [attempt(1, "pass", 3, [met("met"), met("met"), met("not met")])] }),
      outcome("flaky-b", "pass", { attempts: [attempt(1, "fail", 3), attempt(2, "pass", 4)], warnings: [{ kind: "flaky", message: "" }] }),
      outcome("fail-c", "fail", { attempts: [attempt(1, "fail"), attempt(2, "fail")], failure: { kind: "assertion", check: "exists" } }),
      outcome("blocked-d", "blocked", { failure: { kind: "fixture-blocked", check: "fixture" } }),
      outcome("skipped-e", "skipped", { failure: { kind: "chain-stage", stage: 2 } }),
      outcome("notrun-f", "not-run"),
    ]),
    { cwd: "/repo", missingSnapshots: false },
  );
  assert.deepEqual(lines, [
    "",
    "== summary ==",
    "| Scenario | Skill | Status | Attempts | Turns | Summary |",
    "|---|---|---|---|---|---|",
    "| pass-a | highway-help | pass | 1 | 3 | judge 2/3 met |",
    "| flaky-b | highway-help | pass (flaky) | 2 | 3, 4 | - |",
    "| fail-c | highway-help | fail | 2 | 3, 3 | assertion exists |",
    "| blocked-d | highway-help | blocked | 0 | - | fixture-blocked |",
    "| skipped-e | highway-help | skipped | 0 | - | chain stage 2 failed |",
    "| notrun-f | highway-help | not run | 0 | - | run stopped |",
    "Passed 2, failed 1, flaky 1, blocked 1, not run 1, skipped 1",
    "Usage: 10 model calls, 500 input tokens, 50 output tokens",
    "Exit code: 1",
  ]);
});

test("the run folder follows the exit code only when one was written, and a passing chain without one says how to save snapshots", () => {
  const withFolder = renderSummary(run([outcome("a", "pass")], { folder: "/repo/out/r" }), { cwd: "/repo", missingSnapshots: false });
  assert.equal(withFolder.at(-1), "Run folder: out/r");
  const outside = renderSummary(run([outcome("a", "pass")], { folder: "/tmp/runs/r" }), { cwd: "/repo", missingSnapshots: false });
  assert.equal(outside.at(-1), "Run folder: /tmp/runs/r");
  const none = renderSummary(run([outcome("a", "pass")]), { cwd: "/repo", missingSnapshots: true });
  assert.ok(!none.some((l) => l.startsWith("Run folder:")));
  assert.equal(none.at(-1), "Candidate snapshots were not saved; rerun with --transcripts <dir> to save them for --promote.");
});

test("the judge column shows - when the judge is off", () => {
  const lines = renderSummary(run([outcome("a", "pass", { attempts: [{ ...attempt(1, "pass"), judge: "skipped" }] })], { judgeAgent: null, judgeModel: null }), { cwd: "/", missingSnapshots: false });
  assert.ok(lines.includes("| a | highway-help | pass | 1 | 3 | - |"));
});

test("blocks print in selection order whatever order they finish in, each attempt whole", () => {
  const printed: string[][] = [];
  const log = new OrderedLog(3, (lines) => printed.push([...lines]));
  log.add(2, ["c1"]);
  log.add(1, ["b1"]);
  assert.deepEqual(printed, []);
  log.add(0, ["a1"]);
  assert.deepEqual(printed, [["a1"]]);
  log.add(0, ["a2"]);
  log.close(0);
  assert.deepEqual(printed, [["a1"], ["a2"], ["b1"]]);
  log.close(2);
  assert.deepEqual(printed.length, 3);
  log.close(1);
  assert.deepEqual(printed, [["a1"], ["a2"], ["b1"], ["c1"]]);
  log.add(1, ["late"]);
  log.finish();
  assert.deepEqual(printed.at(-1), ["late"]);
});
