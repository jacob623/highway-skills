import { realpathSync } from "node:fs";
import { basename, dirname, relative, resolve } from "node:path";
import type { TranscriptEntry, Usage, Warning } from "./driver.ts";
import { likelyCause, type Failure } from "./failure.ts";
import type { Verdict } from "./judge.ts";
import { counts, exitCode, isFlaky, totalUsage, type Run, type ScenarioOutcome } from "./report.ts";

/** The project files one turn changed, printed after the `agent` entry at `afterIndex`. */
export interface TurnFiles {
  afterIndex: number;
  created: string[];
  changed: string[];
  deleted: string[];
}

export interface AttemptBlock {
  scenario: string;
  skill: string;
  attempt: number;
  transcript: readonly TranscriptEntry[];
  files: readonly TurnFiles[];
  failures: readonly Failure[];
  verdicts: readonly Verdict[];
  warnings: readonly Warning[];
  usage: Usage;
  verbose: boolean;
}

const FAIL_CHARS = 400;
const DETAIL_LINES = 20;

/** `label: first line`, then each further non-blank line indented two spaces. */
function labeled(label: string, text: string): string[] {
  const lines = text
    .split("\n")
    .map((l) => l.trimEnd())
    .filter((l) => l.trim() !== "");
  if (lines.length === 0) return [`${label}:`];
  return [`${label}: ${lines[0]}`, ...lines.slice(1).map((l) => `  ${l}`)];
}

function flat(text: string): string {
  return text.replace(/\s+/g, " ").trim();
}

function capped(line: string, max = FAIL_CHARS): string {
  return line.length > max ? line.slice(0, max - 1) + "…" : line;
}

/** `fail: <kind> <check>[ <path>]: expected <e>; actual <a>`, each part left out when empty, then the detail. */
export function failLines(f: Failure): string[] {
  const head = ["fail:", f.kind, f.check, f.path].filter((p) => p !== undefined && p !== "").join(" ");
  const parts: string[] = [];
  if (f.expected !== undefined && f.expected !== "") parts.push(`expected ${flat(f.expected)}`);
  if (f.actual !== undefined && f.actual !== "") parts.push(`actual ${flat(f.actual)}`);
  let line = parts.length > 0 ? `${head}: ${parts.join("; ")}` : head;
  if (f.line) line += ` (scenario line ${f.line})`;
  const detail = (f.detail ?? "")
    .split("\n")
    .map((l) => l.trimEnd())
    .filter((l) => l.trim() !== "");
  const shown = detail.slice(-DETAIL_LINES).map((l) => capped(`  ${l}`, 200));
  if (detail.length > DETAIL_LINES) shown.unshift(`  … ${detail.length - DETAIL_LINES} earlier lines cut`);
  return [capped(line), ...shown];
}

function filesLine(t: TurnFiles): string | undefined {
  const parts = [...t.created.map((p) => `${p} (created)`), ...t.changed.map((p) => `${p} (changed)`), ...t.deleted.map((p) => `${p} (deleted)`)];
  return parts.length > 0 ? `files: ${parts.join(", ")}` : undefined;
}

function entryLines(e: TranscriptEntry, verbose: boolean): string[] {
  switch (e.role) {
    case "skill":
      return labeled("skill", e.text.replace(/^invoked /, ""));
    case "permission": {
      const match = /^(approved|rejected) ([^:]+): ([\s\S]*)$/.exec(e.text);
      if (!match) return labeled("system", e.text);
      if (match[1] === "approved") return verbose ? labeled("approved", `${match[2]} ${match[3]}`) : [];
      return labeled("denied", `${match[2]} ${match[3]}`);
    }
    default:
      return labeled(e.role, e.text);
  }
}

/** FR-024 and FR-027: one attempt as a plain conversation, closed by its result. */
export function renderBlock(b: AttemptBlock): string[] {
  const out = ["", `== ${b.scenario} (${b.skill}) attempt ${b.attempt} ==`];
  const filesAfter = new Map(b.files.map((t) => [t.afterIndex, t]));
  b.transcript.forEach((e, i) => {
    out.push(...entryLines(e, b.verbose));
    const files = filesAfter.get(i);
    const line = files && filesLine(files);
    if (line) out.push(line);
  });
  if (b.verbose) out.push(`usage: ${b.usage.calls} calls, ${b.usage.inputTokens} input tokens, ${b.usage.outputTokens} output tokens`);
  for (const w of b.warnings) if (w.kind === "paraphrased-question") out.push(...labeled("warning", w.message));
  if (b.failures.length === 0) out.push("result: pass");
  for (const f of b.failures) out.push(...failLines(f));
  for (const v of b.verdicts) {
    if (v.verdict !== "not met") continue;
    const why = flat(v.note ?? v.reason) || "no reason given";
    out.push(`not met: ${flat(v.text)} - ${why}`);
  }
  return out;
}

/** A failure that belongs to the run, not to one attempt. */
export function renderRunBlock(f: Failure): string[] {
  return ["", "== run ==", ...failLines(f), `cause: ${likelyCause(f)}`];
}

/** A scenario that did not run because its fixture failed validation. */
export function renderBlockedBlock(scenario: string, skill: string, f: Failure): string[] {
  return ["", `== ${scenario} (${skill}) blocked ==`, ...failLines(f)];
}

function statusOf(o: ScenarioOutcome): string {
  if (o.status === "pass") return isFlaky(o) ? "pass (flaky)" : "pass";
  return o.status === "not-run" ? "not run" : o.status;
}

function summaryOf(o: ScenarioOutcome): string {
  switch (o.status) {
    case "fail":
      return o.failure ? [o.failure.kind, o.failure.check].filter(Boolean).join(" ") : "-";
    case "blocked":
      return o.failure?.kind ?? "-";
    case "skipped":
      return o.failure?.stage ? `chain stage ${o.failure.stage} failed` : "chain stage failed";
    case "not-run":
      return "run stopped";
    default: {
      const last = o.attempts.at(-1);
      if (!last || last.judge !== "ran" || last.judgeVerdicts.length === 0) return "-";
      const met = last.judgeVerdicts.filter((v) => v.verdict === "met").length;
      return `judge ${met}/${last.judgeVerdicts.length} met`;
    }
  }
}

const cell = (s: string): string => s.replace(/\|/g, "\\|");

/** FR-026: the closing table, counts, usage, exit code, and the run folder when one was written. */
export function renderSummary(run: Run, opts: { cwd: string; missingSnapshots: boolean }): string[] {
  const out = ["", "== summary ==", "| Scenario | Skill | Status | Attempts | Turns | Summary |", "|---|---|---|---|---|---|"];
  for (const o of run.outcomes) {
    const turns = o.attempts.map((a) => a.turns).join(", ") || "-";
    out.push(`| ${cell(o.scenario)} | ${cell(o.skill)} | ${statusOf(o)} | ${o.attempts.length} | ${turns} | ${cell(summaryOf(o))} |`);
  }
  const c = counts(run);
  out.push(`Passed ${c.passed}, failed ${c.failed}, flaky ${c.flaky}, blocked ${c.blocked}, not run ${c.notRun}, skipped ${c.skipped}`);
  const usage = totalUsage(run);
  out.push(`Usage: ${usage.calls} model calls, ${usage.inputTokens} input tokens, ${usage.outputTokens} output tokens`);
  out.push(`Exit code: ${exitCode(run)}`);
  if (run.folder) {
    const shown = relative(opts.cwd, run.folder);
    out.push(`Run folder: ${shown === "" || shown.startsWith("..") ? run.folder : shown}`);
  } else if (opts.missingSnapshots) {
    out.push("Candidate snapshots were not saved; rerun with --transcripts <dir> to save them for --promote.");
  }
  return out;
}

function variants(path: string): string[] {
  const out = [resolve(path)];
  try {
    const real = realpathSync(path);
    if (!out.includes(real)) out.push(real);
  } catch {
    // A folder already removed keeps its plain path only.
  }
  return out;
}

const escape = (s: string): string => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

/**
 * FR-025: the project becomes relative (`.` when named alone), the agent home `<home>`, the work
 * root `<work>`, and any other path under the temporary folder `<tmp>`. Build it while the folders
 * exist, so their real paths are known. A root matches only as a whole path segment.
 */
export function pathRewriter(paths: { project?: string; home?: string; work?: string; tmp?: string }): (text: string) => string {
  const pairs: [string, string][] = [];
  if (paths.project) for (const p of variants(paths.project)) pairs.push([p + "/", ""], [p, "."]);
  if (paths.home) for (const h of variants(paths.home)) pairs.push([h, "<home>"]);
  if (paths.work) for (const w of variants(paths.work)) pairs.push([w, "<work>"]);
  if (paths.tmp) {
    for (const t of variants(paths.tmp)) pairs.push([t, "<tmp>"]);
    // macOS keeps the temporary folder at /var/folders/<a>/<b>/T, and agents drop the T.
    if (basename(paths.tmp) === "T") for (const t of variants(dirname(paths.tmp))) pairs.push([t, "<tmp>"]);
  }
  pairs.sort((a, b) => b[0].length - a[0].length);
  const rules = pairs.map(([from, to]): [RegExp, string] => [
    new RegExp(`(?<![\\w.~/-])${escape(from)}${from.endsWith("/") ? "" : "(?![\\w~-]|\\.\\w)"}`, "g"),
    to,
  ]);
  return (text) => rules.reduce((out, [re, to]) => out.replace(re, () => to), text);
}

/**
 * FR-023: one slot per selected scenario. A block prints whole as soon as every earlier scenario
 * has finished, so the log reads in selection order, then attempt order.
 */
export class OrderedLog {
  private readonly slots: { blocks: string[][]; done: boolean }[];
  private head = 0;
  private readonly print: (lines: readonly string[]) => void;

  constructor(size: number, print: (lines: readonly string[]) => void) {
    this.slots = Array.from({ length: size }, () => ({ blocks: [], done: false }));
    this.print = print;
  }

  add(index: number, lines: readonly string[]): void {
    this.slots[index].blocks.push([...lines]);
    this.flush();
  }

  close(index: number): void {
    this.slots[index].done = true;
    this.flush();
  }

  finish(): void {
    for (const slot of this.slots) slot.done = true;
    this.flush();
    for (const slot of this.slots) for (const block of slot.blocks.splice(0)) this.print(block);
  }

  private flush(): void {
    while (this.head < this.slots.length) {
      const slot = this.slots[this.head];
      for (const block of slot.blocks.splice(0)) this.print(block);
      if (!slot.done) return;
      this.head++;
    }
    for (const slot of this.slots) for (const block of slot.blocks.splice(0)) this.print(block);
  }
}
