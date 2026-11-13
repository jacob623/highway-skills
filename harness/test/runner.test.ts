import { test } from "node:test";
import assert from "node:assert/strict";
import { mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { emptyUsage, RunStop, type DriveOptions, type DriveResult, type Driver } from "../src/driver.ts";
import { main, type RunnerDeps } from "../src/runner.ts";

const TOKEN = "ghp_" + "t".repeat(36);
const PLUGIN = { dir: "/repo/highway-agent-plugin", name: "highway", skills: 16 };

function scenarioDir(files: Record<string, string>): string {
  const dir = mkdtempSync(join(tmpdir(), "harness-scenarios-"));
  for (const [rel, content] of Object.entries(files)) {
    mkdirSync(join(dir, rel, ".."), { recursive: true });
    writeFileSync(join(dir, rel), content);
  }
  return dir;
}

const SCENARIO = (id: string, extra = ""): string => `id: ${id}
skill: highway-help
fixture: empty
smoke: yes
open: /highway-help
writes: out/**
expect: exists out/answer.md
${extra}`;

function ended(options: DriveOptions, turns = 1): DriveResult {
  return {
    outcome: "ended",
    turns,
    rejected: [],
    warnings: [],
    usage: { ...emptyUsage(), calls: 1 },
    usedReplies: [],
    skillsInvoked: ["highway-experience", "highway-help"],
    skillsBeforeOutput: ["highway-experience", "highway-help"],
    lastMessage: "done",
  };
}

/** Writes out/answer.md so the scenario's expectation passes. */
const writingDriver: Driver = async (options) => {
  mkdirSync(join(options.projectDir, "out"), { recursive: true });
  writeFileSync(join(options.projectDir, "out", "answer.md"), "# Answer\n");
  options.log({ turn: 1, role: "agent", text: `token ${TOKEN}` });
  return ended(options);
};

function deps(overrides: Partial<RunnerDeps>, lines: string[], transcripts: string): RunnerDeps {
  return {
    driver: writingDriver,
    makeAsk: () => async () => "none",
    build: (workRoot) => {
      const dir = join(workRoot, "base");
      mkdirSync(dir, { recursive: true });
      return { ok: true, dir, plugin: PLUGIN };
    },
    fixtureCheck: () => new Map(),
    out: (line) => lines.push(line),
    now: () => new Date(Date.UTC(2026, 10, 10, 12, 0, 0)),
    commit: () => "abcdef1234567",
    versions: () => ({ sdk: "1.0.30", cli: "1.0.108" }),
    env: () => ({ GITHUB_TOKEN: TOKEN, HARNESS_TRANSCRIPTS: transcripts }),
    ...overrides,
  };
}

function setup(files: Record<string, string>): { dir: string; transcripts: string; lines: string[] } {
  return { dir: scenarioDir(files), transcripts: mkdtempSync(join(tmpdir(), "harness-runs-")), lines: [] };
}

test("help exits 0 and an unknown switch exits 2 with a pointer to --help", async () => {
  const lines: string[] = [];
  assert.equal(await main(["--help"], deps({}, lines, "/tmp")), 0);
  assert.match(lines.join("\n"), /Selection:/);
  lines.length = 0;
  assert.equal(await main(["--bogus"], deps({}, lines, "/tmp")), 2);
  assert.deepEqual(lines, ["Unknown switch: --bogus", "Run with --help for usage."]);
});

test("a passing smoke scenario exits 0, writes the attempt files, and redacts the token", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], { ...deps({}, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 0, lines.join("\n"));
  assert.match(lines[0], /^HARNESS run=20261110-120000Z-smoke-abcdef1 commit=abcdef1234567 type=smoke model=\S+ judge=off sdk=1\.0\.30 cli=1\.0\.108$/);
  assert.ok(lines.some((l) => /^\[1\/1\] PASS help-smoke \(attempt 1, 1 turns, /.test(l)));
  const folder = join(transcripts, "20261110-120000Z-smoke-abcdef1");
  assert.deepEqual(readdirSync(join(folder, "help-smoke")).sort(), ["attempt-1.jsonl", "attempt-1.raw.jsonl", "attempt-1.result.json"]);
  for (const name of ["report.md", "report.json", "junit.xml", "selection.txt"]) readFileSync(join(folder, name));
  assert.ok(!readFileSync(join(folder, "help-smoke", "attempt-1.jsonl"), "utf8").includes(TOKEN));
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a missing token exits 2 with a missing-token block", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const code = await main(["--smoke", "--transcripts", transcripts], { ...deps({ env: () => ({}) }, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 2);
  const text = lines.join("\n");
  assert.match(text, /==== FAILURE run ====/);
  assert.match(text, /HARNESS-FAILURE \{.*"kind":"missing-token"/);
  assert.match(text, /Likely cause: No Copilot token was found/);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a failed build exits 2 before any session", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  let sessions = 0;
  const code = await main(["--smoke", "--transcripts", transcripts], {
    ...deps({ build: () => ({ ok: false, tail: "ERROR: manifest invalid" }), driver: async (o) => (sessions++, ended(o)) }, lines, transcripts),
    scenariosDir: dir,
  });
  assert.equal(code, 2);
  assert.equal(sessions, 0);
  assert.match(lines.join("\n"), /ERROR: manifest invalid/);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a failing assertion retries once, prints a block per attempt, and exits 1", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  let calls = 0;
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], { ...deps({ driver: async (o) => (calls++, ended(o)) }, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 1);
  assert.equal(calls, 2);
  const text = lines.join("\n");
  assert.match(text, /==== FAILURE help-smoke \(attempt 1 of 2\) ====/);
  assert.match(text, /==== FAILURE help-smoke \(attempt 2 of 2\) ====/);
  assert.match(text, /What: {4}exists out\/answer\.md/);
  assert.match(text, /declared at line 7/);
  assert.match(text, /^FAIL help-smoke: assertion - /m);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a shows line the agent did not show fails as an assertion with check shows", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke", "shows: Run /highway-setup to get started.\n") });
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], { ...deps({}, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 1);
  const text = lines.join("\n");
  assert.match(text, /What: {4}shows -/);
  assert.match(text, /expected: text "Run \/highway-setup to get started\."; actual: the agent did not show it/);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a shows line the agent showed passes", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke", "shows: Run /highway-setup to get started.\n") });
  const showingDriver: Driver = async (o) => {
    o.log({ turn: 1, role: "agent", text: "Highway needs setup. Run /highway-setup to get started." });
    return writingDriver(o);
  };
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], { ...deps({ driver: showingDriver }, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 0, lines.join("\n"));
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a pass on the retry counts as a pass with a flaky warning", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  let calls = 0;
  const flakyDriver: Driver = async (o) => (++calls === 1 ? ended(o) : writingDriver(o));
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], { ...deps({ driver: flakyDriver }, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 0);
  assert.match(lines.join("\n"), /Passed 1, failed 0, flaky 1/);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a file outside writes and a rejected shell request fail the storage invariant", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const strayDriver: Driver = async (o) => {
    await writingDriver(o);
    writeFileSync(join(o.projectDir, "stray.md"), "x");
    return { ...ended(o), rejected: [{ kind: "shell", detail: "ls", fatal: true }] };
  };
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], { ...deps({ driver: strayDriver }, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 1);
  const text = lines.join("\n");
  assert.match(text, /"kind":"outside-writes"/);
  assert.match(text, /actual: stray\.md/);
  assert.match(text, /"kind":"rejected-request"/);
  assert.match(text, /^Rejected: shell: ls$/m);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("output before highway-experience is activated fails the experience invariant", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const lateDriver: Driver = async (o) => ({ ...(await writingDriver(o)), skillsInvoked: ["highway-help", "highway-experience"], skillsBeforeOutput: ["highway-help"] });
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], { ...deps({ driver: lateDriver }, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 1);
  const text = lines.join("\n");
  assert.match(text, /"kind":"experience-order"/);
  assert.match(text, /expected: highway-experience activated before the first output; actual: highway-help/);
  assert.match(text, /Likely cause: The agent showed output before activating highway-experience/);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a persistent rate limit marks unstarted scenarios not run and exits 2", async () => {
  const files: Record<string, string> = {};
  for (const id of ["a", "b", "c"]) files[`highway-help/${id}.scenario`] = SCENARIO(id).replace("smoke: yes", "smoke: no");
  const { dir, transcripts, lines } = setup(files);
  const code = await main(["--skills", "highway-help", "--parallel", "1", "--transcripts", transcripts, "--no-judge"], {
    ...deps({ driver: async () => { throw new RunStop("rate-limit", "429 Too Many Requests"); } }, lines, transcripts),
    scenariosDir: dir,
  });
  assert.equal(code, 2);
  const text = lines.join("\n");
  assert.match(text, /"kind":"rate-limit"/);
  assert.match(text, /not run 3/);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a fixture that fails validation blocks its scenario", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke").replace("fixture: empty", "fixture: setup") });
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], {
    ...deps({ fixtureCheck: () => new Map([["setup", ["library/knowledge/profile.md: missing heading: ## Who We Are (profile-record.md)"]]]) }, lines, transcripts),
    scenariosDir: dir,
  });
  assert.equal(code, 1);
  assert.match(lines.join("\n"), /"kind":"fixture-blocked"/);
  assert.match(lines.join("\n"), /blocked 1/);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a scenario whose last attempt fails only with service errors is blocked", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const serviceDriver: Driver = async (o) => ({
    ...(await writingDriver(o)),
    outcome: "error",
    error: { kind: "service-error", message: "No response was returned. Send your message again to retry. (code -32603)" },
  });
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], { ...deps({ driver: serviceDriver }, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 1);
  const text = lines.join("\n");
  assert.match(text, /"kind":"service-error"/);
  assert.match(text, /blocked 1/);
  assert.doesNotMatch(text, /^FAIL help-smoke: /m);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("each attempt gets the run's plugin, and a failed install fails the scenario without stopping the run", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const seen: unknown[] = [];
  const installDriver: Driver = async (o) => {
    seen.push(o.plugin);
    return {
      ...ended(o, 0),
      outcome: "error",
      skillsInvoked: [],
      skillsBeforeOutput: [],
      error: { kind: "plugin-install", message: "plugin highway: 15 of 16 skills installed" },
    };
  };
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], { ...deps({ driver: installDriver }, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 1);
  assert.deepEqual(seen, [PLUGIN, PLUGIN]);
  const text = lines.join("\n");
  assert.match(text, /"kind":"plugin-install"/);
  assert.match(text, /15 of 16 skills installed/);
  assert.match(text, /Likely cause: The plugin did not install or load from highway-agent-plugin\//);
  assert.doesNotMatch(text, /"kind":"experience-order"/);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a question asked again after its reply was spent fails as repeated-question, naming both", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const repeatingDriver: Driver = async (o) => ({
    ...(await writingDriver(o)),
    outcome: "repeated-question",
    unmatched: "Which Discovery would you like to decide?",
    respent: { question: "Which Discovery would you like to decide?", reply: "Yes, go ahead." },
  });
  const code = await main(["--smoke", "--transcripts", transcripts, "--no-judge"], { ...deps({ driver: repeatingDriver }, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 1);
  const text = lines.join("\n");
  assert.match(text, /"kind":"repeated-question"/);
  assert.match(text, /"Which Discovery would you like to decide\?" asked again after the reply "Yes, go ahead\."/);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});

test("a targeted run that selects nothing exits 0 and says so", async () => {
  const { dir, transcripts, lines } = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const code = await main(["--paths", "tests/run-all.sh"], { ...deps({}, lines, transcripts), scenariosDir: dir });
  assert.equal(code, 0);
  assert.match(lines.join("\n"), /Nothing selected; no scenario runs\./);
  rmSync(dir, { recursive: true });
  rmSync(transcripts, { recursive: true });
});
