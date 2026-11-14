import { test } from "node:test";
import assert from "node:assert/strict";
import { existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, realpathSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { Agent } from "../src/agents.ts";
import { emptyUsage, permissionPolicy, RunStop, type AccessRequest, type DriveOptions, type DriveResult, type Driver, type Rejection } from "../src/driver.ts";
import { main, type RunnerDeps } from "../src/runner.ts";

const TOKEN = "ghp_" + "t".repeat(36);
const PLUGIN = { dir: "/repo/highway-agent-plugin", name: "highway", skills: 16 };
const PROGRESS = /^\[\s*\d+\/\d+\] (start|PASS|FAIL) /;

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

function fakeAgent(id: string, driver: Driver, extra: Partial<Agent> = {}): Agent {
  return {
    id,
    service: id === "copilot" ? "Copilot" : "Fake",
    keys: id === "copilot" ? ["COPILOT_GITHUB_TOKEN", "GITHUB_TOKEN"] : ["FAKE_API_KEY"],
    driver,
    ask: () => async () => "none",
    classify: () => "unclassified",
    readRoots: (home) => [join(home, id === "copilot" ? "installed-plugins" : "fake-plugins")],
    versions: () => ({ sdk: "1.0.30", runtime: "1.0.108" }),
    ...extra,
  };
}

interface Captured {
  dir: string;
  transcripts: string;
  out: string[];
  err: string[];
}

type Overrides = Partial<RunnerDeps> & { driver?: Driver; ask?: Agent["ask"] };

function deps(overrides: Overrides, cap: Pick<Captured, "out" | "err">): RunnerDeps {
  const { driver = writingDriver, ask, ...rest } = overrides;
  return {
    agents: new Map([["copilot", fakeAgent("copilot", driver, ask ? { ask } : {})]]),
    build: (workRoot) => {
      const dir = join(workRoot, "base");
      mkdirSync(dir, { recursive: true });
      return { ok: true, dir, plugin: PLUGIN };
    },
    fixtureCheck: () => new Map(),
    out: (line) => cap.out.push(line),
    err: (line) => cap.err.push(line),
    now: () => new Date(Date.UTC(2026, 10, 10, 12, 0, 0)),
    commit: () => "abcdef1234567",
    env: () => ({ GITHUB_TOKEN: TOKEN }),
    ...rest,
  };
}

function setup(files: Record<string, string>): Captured {
  return { dir: scenarioDir(files), transcripts: mkdtempSync(join(tmpdir(), "harness-runs-")), out: [], err: [] };
}

async function run(argv: string[], overrides: Overrides, cap: Captured): Promise<number> {
  return main(argv, { ...deps(overrides, cap), scenariosDir: cap.dir });
}

function clean(cap: Captured): void {
  rmSync(cap.dir, { recursive: true, force: true });
  rmSync(cap.transcripts, { recursive: true, force: true });
}

const text = (cap: Captured): string => cap.out.join("\n");

test("help exits 0 and an unknown switch exits 2 with a pointer to --help", async () => {
  const cap = { out: [] as string[], err: [] as string[] };
  assert.equal(await main(["--help"], deps({}, cap)), 0);
  assert.match(cap.out.join("\n"), /Selection:/);
  cap.out.length = 0;
  assert.equal(await main(["--bogus"], deps({}, cap)), 2);
  assert.deepEqual(cap.out, ["Unknown switch: --bogus", "Run with --help for usage."]);
  cap.out.length = 0;
  assert.equal(await main(["--transcripts"], deps({}, cap)), 2);
  assert.deepEqual(cap.out, ["--transcripts needs <dir>", "Run with --help for usage."]);
});

test("an unregistered agent exits 2 before the header, naming the registered agents", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  assert.equal(await run(["--smoke", "--agent", "cursor"], {}, cap), 2);
  assert.deepEqual(cap.out, ['Configuration error: unknown agent "cursor"; registered agents: copilot', "Run with --help for usage."]);
  clean(cap);
});

test("a passing smoke scenario with --transcripts prints the header, the block, and the table, writes the attempt files, and redacts the token", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const code = await run(["--smoke", "--transcripts", cap.transcripts, "--no-judge"], {}, cap);
  assert.equal(code, 0, text(cap));
  assert.match(
    cap.out[0],
    /^HARNESS run=20261110-120000Z-smoke-abcdef1 commit=abcdef1234567 type=smoke agent=copilot model=\S+ judge=off fallback=copilot\/\S+ sdk=1\.0\.30 runtime=1\.0\.108 started=2026-11-10T12:00:00\.000Z$/,
  );
  const blockStart = cap.out.indexOf("== help-smoke (highway-help) attempt 1 ==");
  assert.ok(blockStart > 0, text(cap));
  assert.deepEqual(cap.out.slice(blockStart + 1, blockStart + 4), ["agent: token [REDACTED]", "files: out/answer.md (created)", "result: pass"]);
  assert.ok(cap.out.includes("| help-smoke | highway-help | pass | 1 | 1 | - |"));
  assert.ok(cap.out.includes("Exit code: 0"));
  const folder = join(cap.transcripts, "20261110-120000Z-smoke-abcdef1");
  assert.equal(cap.out.at(-1), `Run folder: ${folder}`);
  assert.ok(cap.err.some((l) => /^\[1\/1\] PASS help-smoke \(attempt 1, 1 turns, /.test(l)));
  assert.deepEqual(readdirSync(join(folder, "help-smoke")).sort(), ["attempt-1.jsonl", "attempt-1.raw.jsonl", "attempt-1.result.json"]);
  for (const name of ["report.md", "report.json", "junit.xml", "selection.txt"]) readFileSync(join(folder, name));
  assert.ok(!readFileSync(join(folder, "help-smoke", "attempt-1.jsonl"), "utf8").includes(TOKEN));
  assert.ok(!text(cap).includes(TOKEN));
  clean(cap);
});

test("a run without --transcripts writes no run folder and names none", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const code = await run(["--smoke", "--no-judge"], {}, cap);
  assert.equal(code, 0, text(cap));
  assert.deepEqual(readdirSync(cap.transcripts), []);
  assert.ok(!cap.out.some((l) => l.startsWith("Run folder:")));
  assert.equal(cap.out.at(-1), "Exit code: 0");
  clean(cap);
});

test("standard output holds no progress note, and standard error holds nothing else", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  let calls = 0;
  await run(["--smoke", "--no-judge"], { driver: async (o) => (++calls === 1 ? ended(o) : writingDriver(o)) }, cap);
  assert.ok(!cap.out.some((l) => PROGRESS.test(l)), text(cap));
  assert.ok(cap.err.length >= 4);
  for (const line of cap.err) assert.match(line, PROGRESS);
  clean(cap);
});

test("a missing token exits 2 with a run block naming the key variables and the cause", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const code = await run(["--smoke"], { env: () => ({}) }, cap);
  assert.equal(code, 2);
  const run_ = cap.out.indexOf("== run ==");
  assert.ok(run_ > 0, text(cap));
  assert.deepEqual(cap.out.slice(run_ + 1, run_ + 3), [
    "fail: missing-token token: expected COPILOT_GITHUB_TOKEN or GITHUB_TOKEN; actual neither is set in the environment or harness/.env",
    "cause: No Copilot token was found. Set GITHUB_TOKEN in harness/.env.",
  ]);
  assert.ok(cap.out.includes("| help-smoke | highway-help | not run | 0 | - | run stopped |"));
  assert.ok(cap.out.includes("Exit code: 2"));
  clean(cap);
});

test("a failed build exits 2 before any session", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  let sessions = 0;
  const code = await run(["--smoke"], { build: () => ({ ok: false, tail: "ERROR: manifest invalid" }), driver: async (o) => (sessions++, ended(o)) }, cap);
  assert.equal(code, 2);
  assert.equal(sessions, 0);
  assert.ok(cap.out.includes("fail: build-failed plugin"), text(cap));
  assert.ok(cap.out.includes("  ERROR: manifest invalid"));
  clean(cap);
});

test("a failing assertion retries once, prints a block per attempt, and exits 1", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  let calls = 0;
  const code = await run(["--smoke", "--no-judge"], { driver: async (o) => (calls++, ended(o)) }, cap);
  assert.equal(code, 1);
  assert.equal(calls, 2);
  const t = text(cap);
  assert.ok(cap.out.indexOf("== help-smoke (highway-help) attempt 1 ==") < cap.out.indexOf("== help-smoke (highway-help) attempt 2 =="));
  assert.equal(cap.out.filter((l) => /^fail: assertion exists out\/answer\.md: expected .+; actual .+ \(scenario line 7\)$/.test(l)).length, 2, t);
  assert.ok(cap.out.includes("| help-smoke | highway-help | fail | 2 | 1, 1 | assertion exists |"), t);
  clean(cap);
});

test("a shows line the agent did not show fails as an assertion with check shows", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke", "shows: Run /highway-setup to get started.\n") });
  const code = await run(["--smoke", "--no-judge"], {}, cap);
  assert.equal(code, 1);
  assert.ok(cap.out.includes('fail: assertion shows -: expected text "Run /highway-setup to get started."; actual the agent did not show it'), text(cap));
  clean(cap);
});

test("a shows line the agent showed passes", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke", "shows: Run /highway-setup to get started.\n") });
  const showingDriver: Driver = async (o) => {
    o.log({ turn: 1, role: "agent", text: "Highway needs setup. Run /highway-setup to get started." });
    return writingDriver(o);
  };
  const code = await run(["--smoke", "--no-judge"], { driver: showingDriver }, cap);
  assert.equal(code, 0, text(cap));
  clean(cap);
});

test("a pass on the retry counts as a pass with a flaky warning", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  let calls = 0;
  const code = await run(["--smoke", "--no-judge"], { driver: async (o) => (++calls === 1 ? ended(o) : writingDriver(o)) }, cap);
  assert.equal(code, 0);
  assert.ok(cap.out.includes("| help-smoke | highway-help | pass (flaky) | 2 | 1, 1 | - |"), text(cap));
  assert.ok(cap.out.includes("Passed 1, failed 0, flaky 1, blocked 0, not run 0, skipped 0"));
  clean(cap);
});

test("a file outside writes and a rejected shell request fail the storage invariant", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const strayDriver: Driver = async (o) => {
    await writingDriver(o);
    writeFileSync(join(o.projectDir, "stray.md"), "x");
    return { ...ended(o), rejected: [{ kind: "shell", detail: "ls", fatal: true }] };
  };
  const code = await run(["--smoke", "--no-judge"], { driver: strayDriver }, cap);
  assert.equal(code, 1);
  assert.ok(cap.out.some((l) => /^fail: outside-writes storage out\/\*\*: .*actual stray\.md/.test(l)), text(cap));
  assert.ok(cap.out.includes("fail: rejected-request storage: expected no shell, memory, or outside-write request; actual shell: ls"));
  clean(cap);
});

test("output before highway-experience is activated fails the experience invariant", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const lateDriver: Driver = async (o) => ({ ...(await writingDriver(o)), skillsInvoked: ["highway-help", "highway-experience"], skillsBeforeOutput: ["highway-help"] });
  const code = await run(["--smoke", "--no-judge"], { driver: lateDriver }, cap);
  assert.equal(code, 1);
  assert.ok(cap.out.some((l) => /^fail: experience-order .*: expected highway-experience activated before the first output; actual highway-help$/.test(l)), text(cap));
  assert.ok(cap.out.some((l) => /\| fail \| 2 \| 1, 1 \| experience-order /.test(l)));
  clean(cap);
});

test("a persistent rate limit marks unstarted scenarios not run and exits 2", async () => {
  const files: Record<string, string> = {};
  for (const id of ["a", "b", "c"]) files[`highway-help/${id}.scenario`] = SCENARIO(id).replace("smoke: yes", "smoke: no");
  const cap = setup(files);
  const code = await run(["--skills", "highway-help", "--parallel", "1", "--no-judge"], { driver: async () => { throw new RunStop("rate-limit", "429 Too Many Requests"); } }, cap);
  assert.equal(code, 2);
  assert.ok(cap.out.includes("fail: rate-limit copilot: actual 429 Too Many Requests"), text(cap));
  assert.ok(cap.out.includes("cause: Copilot kept rate limiting after 3 retries. Lower --parallel or wait."));
  assert.ok(cap.out.some((l) => /not run 3/.test(l)));
  clean(cap);
});

test("a key the service refuses stops the run, naming the key variable and service", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const code = await run(["--smoke", "--no-judge"], { driver: async () => { throw new RunStop("no-access", "401 Unauthorized"); } }, cap);
  assert.equal(code, 2);
  assert.ok(cap.out.includes("cause: The GITHUB_TOKEN key has no Copilot access. Check the account's Copilot plan."), text(cap));
  clean(cap);
});

test("a fixture that fails validation blocks its scenario", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke").replace("fixture: empty", "fixture: setup") });
  const code = await run(["--smoke", "--no-judge"], { fixtureCheck: () => new Map([["setup", ["library/knowledge/profile.md: missing heading: ## Who We Are (profile-record.md)"]]]) }, cap);
  assert.equal(code, 1);
  const start = cap.out.indexOf("== help-smoke (highway-help) blocked ==");
  assert.ok(start > 0, text(cap));
  assert.deepEqual(cap.out.slice(start + 1, start + 3), ["fail: fixture-blocked fixture setup", "  library/knowledge/profile.md: missing heading: ## Who We Are (profile-record.md)"]);
  assert.ok(cap.out.includes("| help-smoke | highway-help | blocked | 0 | - | fixture-blocked |"));
  clean(cap);
});

test("a scenario whose last attempt fails only with service errors is blocked", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const serviceDriver: Driver = async (o) => ({
    ...(await writingDriver(o)),
    outcome: "error",
    error: { kind: "service-error", message: "No response was returned. Send your message again to retry. (code -32603)" },
  });
  const code = await run(["--smoke", "--no-judge"], { driver: serviceDriver }, cap);
  assert.equal(code, 1);
  assert.ok(cap.out.includes("fail: service-error session: actual No response was returned. Send your message again to retry. (code -32603)"), text(cap));
  assert.ok(cap.out.includes("| help-smoke | highway-help | blocked | 2 | 1, 1 | service-error |"));
  clean(cap);
});

test("each attempt gets the run's plugin, and a failed install fails the scenario without stopping the run", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const seen: unknown[] = [];
  const installDriver: Driver = async (o) => {
    seen.push(o.plugin);
    o.log({ turn: 0, role: "system", text: "plugin highway: 15 of 16 skills installed" });
    return { ...ended(o, 0), outcome: "error", skillsInvoked: [], skillsBeforeOutput: [], error: { kind: "plugin-install", message: "plugin highway: 15 of 16 skills installed" } };
  };
  const code = await run(["--smoke", "--no-judge"], { driver: installDriver }, cap);
  assert.equal(code, 1);
  assert.deepEqual(seen, [PLUGIN, PLUGIN]);
  assert.ok(cap.out.includes("system: plugin highway: 15 of 16 skills installed"), text(cap));
  assert.ok(cap.out.includes("fail: plugin-install session: actual plugin highway: 15 of 16 skills installed"));
  assert.ok(!cap.out.some((l) => l.startsWith("fail: experience-order")));
  clean(cap);
});

test("a question asked again after its reply was spent fails as repeated-question, naming both", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const repeatingDriver: Driver = async (o) => ({
    ...(await writingDriver(o)),
    outcome: "repeated-question",
    unmatched: "Which Discovery would you like to decide?",
    respent: { question: "Which Discovery would you like to decide?", reply: "Yes, go ahead." },
  });
  const code = await run(["--smoke", "--no-judge"], { driver: repeatingDriver }, cap);
  assert.equal(code, 1);
  assert.ok(
    cap.out.includes('fail: repeated-question reply: expected a different question after the reply was spent; actual "Which Discovery would you like to decide?" asked again after the reply "Yes, go ahead."'),
    text(cap),
  );
  clean(cap);
});

test("a targeted run that selects nothing exits 0 and says so", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const code = await run(["--paths", "tests/run-all.sh"], {}, cap);
  assert.equal(code, 0);
  assert.match(text(cap), /Nothing selected; no scenario runs\./);
  clean(cap);
});

test("a fake second agent runs a scenario end to end through the registry, with its own key, model, read roots, and folder name", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const seen: DriveOptions[] = [];
  type Native = { type: "fs.read"; file: string } | { type: "fs.write"; file: string };
  const toAccess = (n: Native): AccessRequest => (n.type === "fs.read" ? { kind: "read", path: n.file } : { kind: "write", path: n.file });
  const fakeDriver: Driver = async (o) => {
    seen.push(o);
    assert.ok(existsSync(o.agentHome));
    const rejected: Rejection[] = [];
    o.log({ turn: 0, role: "system", text: "installed plugin highway (16 skills)" });
    o.log({ turn: 1, role: "user", text: o.scenario.open });
    const requests: Native[] = [
      { type: "fs.read", file: join(o.readRoots[0], "highway", "skills", "highway-help", "SKILL.md") },
      { type: "fs.read", file: join(o.agentHome, "secret.txt") },
      { type: "fs.write", file: join(o.projectDir, "out", "answer.md") },
    ];
    for (const n of requests) {
      const decision = permissionPolicy(toAccess(n), o.projectDir, o.scenario.web, o.readRoots);
      if (decision.rejection) rejected.push(decision.rejection);
      o.log({ turn: 1, role: "permission", text: decision.summary });
    }
    mkdirSync(join(o.projectDir, "out"), { recursive: true });
    writeFileSync(join(o.projectDir, "out", "answer.md"), "# Answer\n");
    o.log({ turn: 1, role: "agent", text: "Done." });
    return { ...ended(o), rejected };
  };
  const agents = new Map([
    ["copilot", fakeAgent("copilot", writingDriver)],
    ["fake", fakeAgent("fake", fakeDriver, { versions: () => ({ sdk: "9.9.9", runtime: "unknown" }) })],
  ]);
  const code = await run(["--smoke", "--agent", "fake", "--model", "fake-model", "--transcripts", cap.transcripts], { agents, env: () => ({ GITHUB_TOKEN: TOKEN, FAKE_API_KEY: "fake-key-value" }) }, cap);
  assert.equal(code, 0, text(cap));
  assert.equal(seen.length, 1);
  assert.equal(seen[0].key, "fake-key-value");
  assert.equal(seen[0].model, "fake-model");
  assert.deepEqual(seen[0].readRoots, [join(seen[0].agentHome, "fake-plugins")]);
  assert.ok(!existsSync(seen[0].agentHome));
  assert.match(cap.out[0], / agent=fake model=fake-model judge=copilot\/\S+ fallback=copilot\/\S+ sdk=9\.9\.9 runtime=unknown /);
  assert.ok(existsSync(join(cap.transcripts, "20261110-120000Z-smoke-fake-abcdef1", "help-smoke", "attempt-1.jsonl")));
  assert.ok(cap.out.includes("denied: read <home>/secret.txt"), text(cap));
  assert.ok(!cap.out.some((l) => l.startsWith("approved:")));
  clean(cap);
});

test("paths in the log are relative to the project or start with <home>, and --verbose adds approvals and usage", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const pathDriver: Driver = async (o) => {
    for (const request of [{ kind: "read", path: join(o.projectDir, "out", "answer.md") }, { kind: "read", path: join(o.agentHome, "config.json") }] as AccessRequest[]) {
      o.log({ turn: 1, role: "permission", text: permissionPolicy(request, o.projectDir, false, o.readRoots).summary });
    }
    mkdirSync(join(o.projectDir, "out"), { recursive: true });
    writeFileSync(join(o.projectDir, "out", "answer.md"), "# Answer\n");
    o.log({ turn: 1, role: "agent", text: `Wrote ${join(o.projectDir, "out", "answer.md")} in ${o.projectDir}.` });
    return ended(o);
  };
  const code = await run(["--smoke", "--no-judge", "--verbose"], { driver: pathDriver }, cap);
  assert.equal(code, 0, text(cap));
  assert.ok(cap.out.includes("approved: read out/answer.md"), text(cap));
  assert.ok(cap.out.includes("denied: read <home>/config.json"));
  assert.ok(cap.out.includes("agent: Wrote out/answer.md in .."));
  assert.ok(cap.out.includes("usage: 1 calls, 0 input tokens, 0 output tokens"));
  for (const root of [tmpdir(), realpathSync(tmpdir())]) assert.ok(!text(cap).includes(root), `a temporary path leaked: ${root}`);
  clean(cap);
});

test("blocks print in selection order when a later scenario finishes first", async () => {
  const files: Record<string, string> = {};
  for (const id of ["a-slow", "b-fast"]) files[`highway-help/${id}.scenario`] = SCENARIO(id).replace("smoke: yes", "smoke: no");
  const cap = setup(files);
  const ordered: Driver = async (o) => {
    if (o.scenario.id === "a-slow") await new Promise((done) => setTimeout(done, 100));
    return writingDriver(o);
  };
  const code = await run(["--skills", "highway-help", "--parallel", "2", "--no-judge"], { driver: ordered }, cap);
  assert.equal(code, 0, text(cap));
  assert.ok(cap.err.findIndex((l) => / PASS b-fast /.test(l)) < cap.err.findIndex((l) => / PASS a-slow /.test(l)));
  const a = cap.out.indexOf("== a-slow (highway-help) attempt 1 ==");
  const b = cap.out.indexOf("== b-fast (highway-help) attempt 1 ==");
  assert.ok(a > 0 && b > a, text(cap));
  clean(cap);
});

test("two runs with the same turns print the same log", async () => {
  const first = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const second = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  await run(["--smoke", "--no-judge"], {}, first);
  await run(["--smoke", "--no-judge"], {}, second);
  assert.deepEqual(first.out.slice(1), second.out.slice(1));
  clean(first);
  clean(second);
});

test("bullets the judge marks not met close the block with their reason, and the table counts met verdicts", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke", "covers: aaaaaaaaaaaa The answer file exists.\ncovers: bbbbbbbbbbbb The close names setup.\n") });
  const answer = [
    JSON.stringify({ hash: "aaaaaaaaaaaa", verdict: "met", evidence: "Answer", reason: "The file is there." }),
    JSON.stringify({ hash: "bbbbbbbbbbbb", verdict: "not met", evidence: "", reason: "Setup is never named." }),
  ].join("\n");
  const code = await run(["--smoke"], { ask: () => async () => answer }, cap);
  assert.equal(code, 0, text(cap));
  assert.ok(cap.out.includes("not met: The close names setup. - Setup is never named."), text(cap));
  assert.ok(!cap.out.some((l) => l.startsWith("not met: The answer file exists.")));
  assert.ok(cap.out.includes("| help-smoke | highway-help | pass | 1 | 1 | judge 1/2 met |"));
  clean(cap);
});

test("a judge agent whose key is absent turns the fallback off under --no-judge, and the header says so", async () => {
  const cap = setup({ "highway-help/help-smoke.scenario": SCENARIO("help-smoke") });
  const agents = new Map([
    ["copilot", fakeAgent("copilot", writingDriver)],
    ["fake", fakeAgent("fake", writingDriver)],
  ]);
  const code = await run(["--smoke", "--no-judge", "--judge-agent", "fake"], { agents }, cap);
  assert.equal(code, 0, text(cap));
  assert.match(cap.out[0], / judge=off fallback=off /);
  clean(cap);
});

const CHAIN = (n: number): string => SCENARIO(`stage-${n}`).replace("smoke: yes", `smoke: no\nchain: ${n}`).replace("writes: out/**", "writes: **");

test("a full run whose chain passes without --transcripts says how to save candidate snapshots; with it, the candidates are saved", async () => {
  const files: Record<string, string> = {};
  for (let n = 1; n <= 6; n++) files[`highway-help/stage-${n}.scenario`] = CHAIN(n);
  const plain = setup(files);
  assert.equal(await run(["--no-judge"], {}, plain), 0, text(plain));
  assert.equal(plain.out.at(-1), "Candidate snapshots were not saved; rerun with --transcripts <dir> to save them for --promote.");
  assert.deepEqual(readdirSync(plain.transcripts), []);
  clean(plain);

  const saved = setup(files);
  assert.equal(await run(["--no-judge", "--transcripts", saved.transcripts], {}, saved), 0, text(saved));
  const folder = join(saved.transcripts, "20261110-120000Z-full-abcdef1");
  assert.deepEqual(readdirSync(join(folder, "candidates")).sort(), ["architecture", "discovery", "implementation", "request", "setup"]);
  assert.equal(saved.out.at(-1), `Run folder: ${folder}`);
  clean(saved);
});
