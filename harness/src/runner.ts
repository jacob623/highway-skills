import { spawnSync } from "node:child_process";
import { appendFileSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join, relative } from "node:path";
import { helpText, parseArgs, USAGE_POINTER, type Options } from "./args.ts";
import { chainOf, promote, runChain, type ProjectSourceSpec, type StageRun } from "./chain.ts";
import { changedPaths, diffSnapshots, experienceInvariant, runExpectation, showsFailures, snapshot, storageInvariant } from "./checks.ts";
import { HARNESS_DIR, loadEnv, readFileConfig, REPO_ROOT, resolveConfig, type Config } from "./config.ts";
import { coverageSection, readInventory, readTreatments } from "./coverage.ts";
import { copilotDriver, RunStop, type DriveResult, type Driver, type TranscriptEntry, type Warning } from "./driver.ts";
import { errorText, formatFailure, type Failure, type FailureKind } from "./failure.ts";
import { copilotAsk, makeFallbackPicker, runJudge, type Ask, type JudgeFile } from "./judge.ts";
import { buildDistribution, createProject, removeProject, type BuildResult } from "./project.ts";
import { createRedactor, type Redactor } from "./redact.ts";
import { keyText } from "./replies.ts";
import { exitCode, runId, summaryText, writeRunReports, type AttemptResult, type Run, type RunType, type ScenarioOutcome, type Selection } from "./report.ts";
import type { Scenario } from "./scenario.ts";
import { loadScenarios, selectAll, selectSmoke, selectTargeted } from "./select.ts";

export interface RunnerDeps {
  driver: Driver;
  makeAsk: (token: string, model: string) => Ask;
  build: (workRoot: string) => BuildResult;
  fixtureCheck: (fixtures: readonly string[]) => Map<string, string[]>;
  out: (line: string) => void;
  now: () => Date;
  commit: () => string;
  versions: () => { sdk: string; cli: string };
  env: () => Record<string, string | undefined>;
  scenariosDir?: string;
}

export function gitCommit(): string {
  const result = spawnSync("git", ["rev-parse", "HEAD"], { encoding: "utf8", cwd: REPO_ROOT });
  return result.status === 0 ? result.stdout.trim() : "unknown";
}

export function sdkVersions(): { sdk: string; cli: string } {
  const base = join(HARNESS_DIR, "node_modules", "@github", "copilot-sdk");
  let sdk = "unknown";
  let cli = "unknown";
  try {
    sdk = (JSON.parse(readFileSync(join(base, "package.json"), "utf8")) as { version: string }).version;
  } catch {
    // Reported as unknown; the run continues and the header says so.
  }
  try {
    cli = /COPILOT_CLI_VERSION\s*=\s*"([^"]+)"/.exec(readFileSync(join(base, "dist", "cliVersion.js"), "utf8"))?.[1] ?? "unknown";
  } catch {
    // Reported as unknown, as above.
  }
  return { sdk, cli };
}

/** Runs harness/bin/fixture-check.sh; returns the problems of each fixture that has any. */
export function fixtureCheck(fixtures: readonly string[]): Map<string, string[]> {
  const problems = new Map<string, string[]>();
  if (fixtures.length === 0) return problems;
  const result = spawnSync("bash", [join(HARNESS_DIR, "bin", "fixture-check.sh"), ...fixtures], { encoding: "utf8" });
  for (const line of result.stdout.split("\n").filter(Boolean)) {
    const [fixture, path, problem] = line.split("\t");
    problems.set(fixture, [...(problems.get(fixture) ?? []), `${path}: ${problem}`]);
  }
  if (result.status !== 0 && problems.size === 0) {
    for (const f of fixtures) problems.set(f, [`fixture-check.sh exited ${result.status}: ${result.stderr.trim()}`]);
  }
  return problems;
}

export const defaultDeps: RunnerDeps = {
  driver: copilotDriver,
  makeAsk: copilotAsk,
  build: buildDistribution,
  fixtureCheck,
  out: (line) => process.stdout.write(line + "\n"),
  now: () => new Date(),
  commit: gitCommit,
  versions: sdkVersions,
  env: () => loadEnv(),
};

function duration(ms: number): string {
  const s = Math.round(ms / 1000);
  return `${Math.floor(s / 60)}m${String(s % 60).padStart(2, "0")}s`;
}

function entryLine(e: TranscriptEntry): string {
  return `turn ${e.turn} ${e.role}: ${e.text.replace(/\s+/g, " ").trim()}`;
}

interface Context {
  run: Run;
  config: Config;
  deps: RunnerDeps;
  redact: Redactor;
  distDir: string;
  workRoot: string;
  total: number;
  ask?: Ask;
  fallbackAsk: Ask;
  stop?: RunStop;
}

function print(ctx: Pick<Context, "deps" | "redact">, text: string): void {
  for (const line of text.split("\n")) ctx.deps.out(ctx.redact(line));
}

function printFailure(ctx: Context, failure: Failure): void {
  print(ctx, formatFailure(failure, ctx.run.id, ctx.redact));
}

interface AttemptOutput {
  result: AttemptResult;
  projectDir?: string;
}

function driveFailures(drive: DriveResult): { kind: FailureKind; check: string; expected?: string; actual?: string }[] {
  switch (drive.outcome) {
    case "unmatched-question":
      return [{ kind: "unmatched-question", check: "reply", expected: "a keyed reply for the question", actual: drive.unmatched ?? drive.lastMessage.slice(-200) }];
    case "turn-limit":
      return [{ kind: "turn-limit", check: "turns", expected: "the conversation ends within the turn limit", actual: `${drive.turns} turns` }];
    case "timeout":
      return [{ kind: "timeout", check: "time", expected: "the attempt ends within the time limit", actual: `stopped at turn ${drive.turns}` }];
    case "error":
      return [{ kind: drive.error?.kind ?? "unclassified", check: "session", actual: drive.error?.message ?? "unknown error" }];
    default:
      return [];
  }
}

async function runAttempt(ctx: Context, scenario: Scenario, attempt: number, attempts: number, source: ProjectSourceSpec, stage: number | null, keep: boolean): Promise<AttemptOutput> {
  const started = Date.now();
  const folder = join(ctx.run.folder, scenario.id);
  mkdirSync(folder, { recursive: true });
  const rawFile = join(folder, `attempt-${attempt}.raw.jsonl`);
  const logFile = join(folder, `attempt-${attempt}.jsonl`);
  writeFileSync(rawFile, "");
  writeFileSync(logFile, "");
  const transcript: TranscriptEntry[] = [];

  const projectDir = createProject({ distDir: ctx.distDir, fixture: source.fixture ?? scenario.fixture, fromDir: source.fromDir }, ctx.workRoot, `${scenario.id}-${attempt}`);
  mkdirSync(join(ctx.workRoot, "homes"), { recursive: true });
  const copilotHome = mkdtempSync(join(ctx.workRoot, "homes", `${scenario.id}-${attempt}-`));
  const before = snapshot(projectDir);
  let keepProject = false;

  try {
    let drive: DriveResult;
    try {
      drive = await ctx.deps.driver({
        scenario,
        projectDir,
        copilotHome,
        token: ctx.config.token!,
        model: ctx.config.model,
        maxTurns: ctx.config.maxTurns,
        timeoutMs: ctx.config.timeoutMs,
        pickFallback: makeFallbackPicker(ctx.fallbackAsk, scenario),
        raw: (event) => appendFileSync(rawFile, ctx.redact(JSON.stringify(event)) + "\n"),
        log: (entry) => {
          transcript.push(entry);
          appendFileSync(logFile, ctx.redact(JSON.stringify(entry)) + "\n");
        },
      });
    } catch (error) {
      if (error instanceof RunStop) throw error;
      drive = {
        outcome: "error",
        turns: 0,
        rejected: [],
        warnings: [],
        usage: { calls: 0, inputTokens: 0, outputTokens: 0, cacheReadTokens: 0, cacheWriteTokens: 0, cost: 0 },
        usedReplies: [],
        skillsInvoked: [],
        skillsBeforeOutput: [],
        lastMessage: "",
        error: { kind: "unclassified", message: errorText(error) },
      };
    }

    const after = snapshot(projectDir);
    const diff = diffSnapshots(before, after);
    const lastReply = drive.usedReplies.length > 0 ? scenario.replies[drive.usedReplies[drive.usedReplies.length - 1]] : undefined;
    const where = {
      scenario: scenario.id,
      file: relative(REPO_ROOT, scenario.file),
      attempt,
      attempts,
      stage,
      turn: drive.turns || null,
      step: lastReply ? `after "${keyText(lastReply)}" (line ${lastReply.line})` : "opening message",
      covers: scenario.covers,
      recent: transcript.slice(-12).map(entryLine),
      rejected: drive.rejected.map((r) => `${r.kind}: ${r.detail}`),
      repeated: drive.repeated,
    };

    const failures: Failure[] = [];
    for (const f of driveFailures(drive)) failures.push({ ...where, ...f });
    const fatal = drive.rejected.filter((r) => r.fatal);
    if (fatal.length > 0) {
      failures.push({ ...where, kind: "rejected-request", check: "storage", expected: "no shell, memory, or outside-write request", actual: fatal.map((r) => `${r.kind}: ${r.detail}`).join("; ") });
    }
    for (const f of storageInvariant(diff, scenario.writes)) failures.push({ ...where, kind: "outside-writes", ...f });
    if (drive.outcome !== "error") {
      for (const f of experienceInvariant(drive.skillsBeforeOutput)) failures.push({ ...where, kind: "experience-order", ...f });
    }
    if (drive.outcome === "ended") {
      for (const exp of scenario.expects) {
        const f = runExpectation(projectDir, after.keys(), exp);
        if (f) failures.push({ ...where, kind: "assertion", ...f, line: f.line ?? null });
      }
      const agentText = transcript.filter((e) => e.role === "agent").map((e) => e.text).join("\n");
      for (const f of showsFailures(agentText, scenario.shows)) failures.push({ ...where, kind: "assertion", ...f, line: null });
    }
    for (const f of failures) printFailure(ctx, f);

    const status = failures.length === 0 ? "pass" : "fail";
    const final = status === "pass" || attempt === attempts;
    let judge: AttemptResult["judge"] = ctx.ask ? "not-run" : "skipped";
    let verdicts: AttemptResult["judgeVerdicts"] = [];
    if (final) {
      const files: JudgeFile[] = changedPaths(diff)
        .filter((p) => after.has(p))
        .map((p) => ({ path: p, content: readFileSync(join(projectDir, p), "utf8") }));
      const text = transcript.map(entryLine).join("\n");
      const judged = await runJudge(ctx.ask, ctx.config.judgeModel, ctx.redact(text), files.map((f) => ({ path: f.path, content: ctx.redact(f.content) })), scenario.covers);
      judge = judged.skipped ? "skipped" : "ran";
      verdicts = judged.verdicts;
    }

    const result: AttemptResult = {
      scenario: scenario.id,
      attempt,
      model: ctx.config.model,
      judgeModel: ctx.config.judge ? ctx.config.judgeModel : null,
      judge,
      status,
      failures,
      warnings: drive.warnings,
      usage: drive.usage,
      judgeVerdicts: verdicts,
      turns: drive.turns,
      durationMs: Date.now() - started,
      stage,
      skillsInvoked: drive.skillsInvoked,
      repliesUsed: drive.usedReplies.map((i) => ({ line: scenario.replies[i].line, kind: scenario.replies[i].kind })),
    };
    writeFileSync(join(folder, `attempt-${attempt}.result.json`), ctx.redact(JSON.stringify(result, null, 2)) + "\n");
    keepProject = keep && status === "pass";
    return { result, projectDir: keepProject ? projectDir : undefined };
  } finally {
    rmSync(copilotHome, { recursive: true, force: true });
    if (!keepProject) removeProject(projectDir);
  }
}

/** FR-036a: one retry in a new project; a passing retry is a pass with a flaky warning. */
async function runScenario(ctx: Context, scenario: Scenario, index: number, reasons: string[], source: ProjectSourceSpec, stage: number | null, keep: boolean): Promise<StageRun> {
  const attempts: AttemptResult[] = [];
  const warnings: Warning[] = [];
  const label = `[${String(index + 1).padStart(String(ctx.total).length)}/${ctx.total}]`;
  const outcome = (status: ScenarioOutcome["status"], failure?: Failure): ScenarioOutcome => ({
    scenario: scenario.id,
    file: relative(REPO_ROOT, scenario.file),
    skill: scenario.skill,
    status,
    reasons,
    attempts,
    warnings,
    failure,
  });

  for (let attempt = 1; attempt <= 2; attempt++) {
    const out = await runAttempt(ctx, scenario, attempt, 2, source, stage, keep);
    attempts.push(out.result);
    warnings.push(...out.result.warnings);
    if (out.result.status === "pass") {
      print(ctx, `${label} PASS ${scenario.id} (attempt ${attempt}, ${out.result.turns} turns, ${duration(out.result.durationMs)})`);
      if (attempt === 2) {
        const flaky: Warning = { kind: "flaky", message: "failed attempt 1, passed attempt 2" };
        warnings.push(flaky);
        out.result.warnings.push(flaky);
        writeFileSync(join(ctx.run.folder, scenario.id, `attempt-2.result.json`), ctx.redact(JSON.stringify(out.result, null, 2)) + "\n");
      }
      for (const w of warnings.filter((w) => w.kind === "paraphrased-question")) print(ctx, `${label} WARN ${scenario.id}: ${w.message}`);
      return { outcome: outcome("pass"), projectDir: out.projectDir };
    }
    print(ctx, `${label} FAIL ${scenario.id} (attempt ${attempt}) -> ${out.result.failures[0]?.kind ?? "unclassified"}`);
  }
  const last = attempts[attempts.length - 1];
  return { outcome: outcome("fail", last.failures[0]) };
}

async function pool<T>(items: readonly T[], size: number, stopped: () => boolean, work: (item: T, index: number) => Promise<void>): Promise<void> {
  let next = 0;
  const worker = async (): Promise<void> => {
    while (next < items.length && !stopped()) {
      const i = next++;
      await work(items[i], i);
    }
  };
  await Promise.all(Array.from({ length: Math.min(size, items.length) }, worker));
}

function runTypeOf(options: Options): RunType {
  if (options.smoke) return "smoke";
  if (options.changedSince || options.paths.length > 0 || options.skills.length > 0) return "targeted";
  return "full";
}

export async function main(argv: readonly string[], deps: RunnerDeps = defaultDeps): Promise<number> {
  const parsed = parseArgs(argv);
  if (!parsed.ok) {
    deps.out(parsed.error);
    deps.out(USAGE_POINTER);
    return 2;
  }
  const options = parsed.options;
  if (options.help) {
    deps.out(helpText());
    return 0;
  }

  const env = deps.env();
  const redact = createRedactor(env);
  const out = { deps, redact };

  if (options.promote) {
    try {
      const replaced = promote(options.promote);
      print(out, `Promoted ${replaced.length} stage fixtures from ${options.promote}:`);
      for (const r of replaced) print(out, `  ${relative(REPO_ROOT, r)}`);
      return 0;
    } catch (error) {
      print(out, `Promote failed: ${errorText(error)}`);
      return 2;
    }
  }

  let config: Config;
  try {
    config = resolveConfig(options, readFileConfig(), env);
  } catch (error) {
    print(out, `Configuration error: ${errorText(error)}`);
    return 2;
  }

  const loaded = loadScenarios(deps.scenariosDir);
  if (loaded.errors.length > 0) {
    for (const e of loaded.errors) print(out, `Scenario error: ${e}`);
    return 2;
  }

  const type = runTypeOf(options);
  let selection: Selection[];
  let chain: Scenario[] = [];
  try {
    if (type === "full") {
      chain = chainOf(loaded.scenarios);
      selection = selectAll(loaded.scenarios);
    } else if (type === "smoke") {
      selection = selectSmoke(loaded.scenarios);
    } else {
      const targeted = selectTargeted(loaded.scenarios, { paths: options.paths, skills: options.skills, changedSince: options.changedSince });
      for (const note of targeted.notes) print(out, note);
      selection = targeted.selection;
    }
  } catch (error) {
    print(out, `Selection error: ${errorText(error)}`);
    return 2;
  }
  if (selection.length === 0) {
    print(out, "Nothing selected; no scenario runs.");
    return 0;
  }

  const start = deps.now();
  const commit = deps.commit();
  const versions = deps.versions();
  const id = runId(start, type, commit);
  const run: Run = {
    id,
    type,
    commit,
    model: config.model,
    judgeModel: config.judge ? config.judgeModel : null,
    sdkVersion: versions.sdk,
    cliVersion: versions.cli,
    startedAt: start.toISOString(),
    folder: join(config.transcripts, id),
    outcomes: [],
    runFailures: [],
  };
  print(out, `HARNESS run=${id} commit=${commit} type=${type} model=${config.model} judge=${config.judge ? config.judgeModel : "off"} sdk=${versions.sdk} cli=${versions.cli}`);
  print(out, `Selected ${selection.length} scenario(s):`);
  for (const s of selection) print(out, `  ${s.scenario}: ${s.reasons.join("; ")}`);

  const finish = (): number => {
    try {
      run.coverage = coverageSection(readInventory(), loaded.scenarios, readTreatments());
    } catch (error) {
      run.coverage = `## Coverage\n\nThe coverage section could not be built: ${errorText(error)}`;
    }
    writeRunReports(run, selection, redact);
    print(out, summaryText(run));
    return exitCode(run);
  };
  const runFailure = (failure: Failure): number => {
    run.runFailures.push(failure);
    print(out, formatFailure(failure, id, redact));
    return finish();
  };

  if (!config.token) return runFailure({ kind: "missing-token", check: "token", expected: "GITHUB_TOKEN or COPILOT_GITHUB_TOKEN", actual: "neither is set in the environment or harness/.env" });

  const workRoot = mkdtempSync(join(tmpdir(), "highway-harness-"));
  try {
    const built = deps.build(workRoot);
    if (!built.ok) return runFailure({ kind: "build-failed", check: "distribution", detail: built.tail });

    const ctx: Context = {
      run,
      config,
      deps,
      redact,
      distDir: built.dir,
      workRoot,
      total: selection.length,
      ask: config.judge ? deps.makeAsk(config.token, config.judgeModel) : undefined,
      fallbackAsk: deps.makeAsk(config.token, config.judgeModel),
    };
    const byId = new Map(loaded.scenarios.map((s) => [s.id, s]));
    const indexOf = new Map(selection.map((s, i) => [s.scenario, i]));
    const outcomes = new Map<string, ScenarioOutcome>();
    const reasonsOf = (sid: string): string[] => selection.find((s) => s.scenario === sid)?.reasons ?? [];
    const placeholder = (s: Scenario, status: ScenarioOutcome["status"], failure?: Failure): ScenarioOutcome => ({
      scenario: s.id,
      file: relative(REPO_ROOT, s.file),
      skill: s.skill,
      status,
      reasons: reasonsOf(s.id),
      attempts: [],
      warnings: [],
      failure,
    });

    const stopWith = (error: RunStop): void => {
      if (ctx.stop) return;
      ctx.stop = error;
      const failure: Failure = { kind: error.kind, check: "copilot", actual: error.message };
      run.runFailures.push(failure);
      print(out, formatFailure(failure, id, redact));
    };

    // Chain first, one stage at a time (FR-021, FR-037).
    const chainIds = new Set(chain.map((s) => s.id));
    if (chain.length > 0) {
      print(out, `Chain: ${chain.map((s) => `${s.chain}:${s.id}`).join(" -> ")}`);
      try {
        const result = await runChain(
          chain,
          (s, source, stage) => runScenario(ctx, s, indexOf.get(s.id) ?? 0, reasonsOf(s.id), source, stage, true),
          built.dir,
          join(run.folder, "candidates"),
        );
        for (const o of result.outcomes) outcomes.set(o.scenario, o);
        if (result.failedStage !== undefined) {
          const failed = chain[result.failedStage - 1];
          const failure: Failure = { kind: "chain-stage", stage: result.failedStage, scenario: failed.id, file: relative(REPO_ROOT, failed.file), check: "chain", actual: `stage ${result.failedStage} (${failed.id}) failed after its retry` };
          run.runFailures.push(failure);
          print(out, formatFailure(failure, id, redact));
          for (const s of selection) {
            if (outcomes.has(s.scenario)) continue;
            outcomes.set(s.scenario, placeholder(byId.get(s.scenario)!, "skipped", { kind: "chain-stage", stage: result.failedStage }));
          }
        } else {
          run.candidates = result.candidates.map((c) => relative(REPO_ROOT, c));
        }
      } catch (error) {
        if (!(error instanceof RunStop)) throw error;
        stopWith(error);
      }
    }

    // Fixture validation (FR-014): a scenario whose fixture fails is blocked.
    const pending = selection.filter((s) => !outcomes.has(s.scenario) && !chainIds.has(s.scenario)).map((s) => byId.get(s.scenario)!);
    const fixtures = [...new Set(pending.map((s) => s.fixture).filter((f) => f !== "empty"))];
    const problems = ctx.stop ? new Map<string, string[]>() : deps.fixtureCheck(fixtures);
    const runnable: Scenario[] = [];
    for (const s of pending) {
      const p = problems.get(s.fixture);
      if (!p) {
        runnable.push(s);
        continue;
      }
      const failure: Failure = { kind: "fixture-blocked", scenario: s.id, file: relative(REPO_ROOT, s.file), check: "fixture", path: s.fixture, detail: p.join("\n"), covers: s.covers };
      printFailure(ctx, failure);
      outcomes.set(s.id, placeholder(s, "blocked", failure));
    }

    await pool(runnable, config.parallel, () => ctx.stop !== undefined, async (s) => {
      try {
        const r = await runScenario(ctx, s, indexOf.get(s.id) ?? 0, reasonsOf(s.id), {}, null, false);
        outcomes.set(s.id, r.outcome);
      } catch (error) {
        if (!(error instanceof RunStop)) throw error;
        stopWith(error);
        outcomes.set(s.id, placeholder(s, "not-run"));
      }
    });

    for (const s of selection) {
      if (!outcomes.has(s.scenario)) outcomes.set(s.scenario, placeholder(byId.get(s.scenario)!, "not-run"));
    }
    run.outcomes = selection.map((s) => outcomes.get(s.scenario)!);
    return finish();
  } finally {
    rmSync(workRoot, { recursive: true, force: true });
  }
}