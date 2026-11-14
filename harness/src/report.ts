import { mkdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { addUsage, emptyUsage, type Usage, type Warning } from "./driver.ts";
import { EXIT_2_KINDS, likelyCause, type Failure } from "./failure.ts";
import type { Verdict } from "./judge.ts";
import type { Redactor } from "./redact.ts";

export type RunType = "full" | "smoke" | "targeted";
export type Status = "pass" | "fail" | "blocked" | "not-run" | "skipped";

export interface AttemptResult {
  scenario: string;
  attempt: number;
  agent: string;
  model: string;
  judgeAgent: string | null;
  judgeModel: string | null;
  judge: "ran" | "skipped" | "not-run";
  status: "pass" | "fail";
  failures: Failure[];
  warnings: Warning[];
  usage: Usage;
  judgeVerdicts: Verdict[];
  turns: number;
  durationMs: number;
  stage: number | null;
  skillsInvoked: string[];
  repliesUsed: { line: number; kind?: string }[];
}

export interface ScenarioOutcome {
  scenario: string;
  file: string;
  skill: string;
  status: Status;
  reasons: string[];
  attempts: AttemptResult[];
  warnings: Warning[];
  failure?: Failure;
}

export interface Selection {
  scenario: string;
  file: string;
  reasons: string[];
}

export interface Run {
  id: string;
  type: RunType;
  commit: string;
  agent: string;
  model: string;
  /** Null when the judge is off (--no-judge). */
  judgeAgent: string | null;
  judgeModel: string | null;
  /** The reply fallback's `<agent>/<model>`, or `off` when the judge agent's key is absent. */
  fallback: string;
  sdkVersion: string;
  runtimeVersion: string;
  startedAt: string;
  /** Set only with --transcripts. */
  folder?: string;
  outcomes: ScenarioOutcome[];
  runFailures: Failure[];
  coverage?: string;
  candidates?: string[];
}

/** `<UTC start>-<type>-<short commit>` for Copilot; any other agent's id follows the type (FR-020). */
export function runId(start: Date, type: RunType, commit: string, agent: string): string {
  const p = (n: number): string => String(n).padStart(2, "0");
  const stamp = `${start.getUTCFullYear()}${p(start.getUTCMonth() + 1)}${p(start.getUTCDate())}-${p(start.getUTCHours())}${p(start.getUTCMinutes())}${p(start.getUTCSeconds())}Z`;
  const tag = agent === "copilot" ? "" : `${agent}-`;
  return `${stamp}-${type}-${tag}${commit.slice(0, 7) || "nocommit"}`;
}

export function isFlaky(outcome: ScenarioOutcome): boolean {
  return outcome.warnings.some((w) => w.kind === "flaky");
}

export function totalUsage(run: Run): Usage {
  let total = emptyUsage();
  for (const o of run.outcomes) for (const a of o.attempts) total = addUsage(total, a.usage);
  return total;
}

export function exitCode(run: Run): 0 | 1 | 2 {
  if (run.runFailures.some((f) => EXIT_2_KINDS.has(f.kind))) return 2;
  if (run.runFailures.length > 0) return 1;
  if (run.outcomes.some((o) => o.status === "fail" || o.status === "blocked")) return 1;
  return 0;
}

export function counts(run: Run): Record<"passed" | "failed" | "flaky" | "blocked" | "notRun" | "skipped", number> {
  const of = (s: Status): number => run.outcomes.filter((o) => o.status === s).length;
  return {
    passed: of("pass"),
    failed: of("fail"),
    flaky: run.outcomes.filter(isFlaky).length,
    blocked: of("blocked"),
    notRun: of("not-run"),
    skipped: of("skipped"),
  };
}

function escapeXml(text: string): string {
  return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

export function renderJunit(run: Run): string {
  const c = counts(run);
  const cases = run.outcomes.map((o) => {
    const seconds = (o.attempts.reduce((sum, a) => sum + a.durationMs, 0) / 1000).toFixed(1);
    const open = `    <testcase classname="${escapeXml(o.skill)}" name="${escapeXml(o.scenario)}" time="${seconds}">`;
    let body = "";
    if (o.status === "fail" || o.status === "blocked") {
      const f = o.failure;
      const message = f ? `${f.kind}: ${likelyCause(f)}` : o.status;
      body = `\n      <failure message="${escapeXml(message)}">${escapeXml(f ? JSON.stringify(f) : "")}</failure>\n    `;
    } else if (o.status === "skipped" || o.status === "not-run") {
      body = `\n      <skipped message="${escapeXml(o.status === "skipped" ? "skipped by a failed chain stage" : "not run")}"/>\n    `;
    }
    return `${open}${body}</testcase>`;
  });
  return [
    `<?xml version="1.0" encoding="UTF-8"?>`,
    `<testsuites name="highway-harness" tests="${run.outcomes.length}" failures="${c.failed + c.blocked}" skipped="${c.skipped + c.notRun}">`,
    `  <testsuite name="${escapeXml(run.id)}" tests="${run.outcomes.length}" failures="${c.failed + c.blocked}" skipped="${c.skipped + c.notRun}">`,
    ...cases,
    `  </testsuite>`,
    `</testsuites>`,
    "",
  ].join("\n");
}

export function renderSelection(selection: readonly Selection[]): string {
  if (selection.length === 0) return "Nothing selected.\n";
  return selection.map((s) => `${s.scenario}\t${s.reasons.join("; ")}`).join("\n") + "\n";
}

export function renderReportMd(run: Run): string {
  const c = counts(run);
  const usage = totalUsage(run);
  const lines = [
    `# Harness run ${run.id}`,
    "",
    `- Type: ${run.type}`,
    `- Commit: ${run.commit}`,
    `- Agent: ${run.agent}`,
    `- Model: ${run.model}`,
    `- Judge: ${run.judgeAgent && run.judgeModel ? `${run.judgeAgent}/${run.judgeModel}` : "skipped (--no-judge)"}`,
    `- Reply fallback: ${run.fallback}`,
    `- SDK ${run.sdkVersion}, runtime ${run.runtimeVersion}`,
    `- Started: ${run.startedAt}`,
    `- Exit code: ${exitCode(run)}`,
    "",
    `Passed ${c.passed}, failed ${c.failed}, flaky ${c.flaky}, blocked ${c.blocked}, not run ${c.notRun}, skipped ${c.skipped}.`,
    "",
    `Usage: ${usage.calls} model calls, ${usage.inputTokens} input tokens, ${usage.outputTokens} output tokens, ${usage.cacheReadTokens} cache read tokens, cost ${usage.cost}.`,
    "",
  ];
  if (run.runFailures.length > 0) {
    lines.push("## Run failures", "");
    for (const f of run.runFailures) lines.push(`- ${f.kind}: ${likelyCause(f)}${f.detail ? ` (${f.detail.split("\n").pop()})` : ""}`);
    lines.push("");
  }
  lines.push("## Scenarios", "", "| Scenario | Skill | Status | Attempts | Turns | Selected because |", "|---|---|---|---|---|---|");
  for (const o of run.outcomes) {
    const status = isFlaky(o) ? "pass (flaky)" : o.status;
    const turns = o.attempts.map((a) => a.turns).join(", ") || "-";
    lines.push(`| ${o.scenario} | ${o.skill} | ${status} | ${o.attempts.length} | ${turns} | ${o.reasons.join("; ").replace(/\|/g, "\\|")} |`);
  }
  lines.push("");

  const failing = run.outcomes.filter((o) => o.failure);
  if (failing.length > 0) {
    lines.push("## Failures", "");
    for (const o of failing) {
      const f = o.failure!;
      lines.push(`### ${o.scenario}`, "", `- Kind: ${f.kind}`, `- Likely cause: ${likelyCause(f)}`);
      if (f.check) lines.push(`- Check: ${f.check} ${f.path ?? ""}`);
      if (f.expected !== undefined) lines.push(`- Expected: ${f.expected}`);
      if (f.actual !== undefined) lines.push(`- Actual: ${f.actual}`);
      if (f.line) lines.push(`- Declared at line ${f.line}`);
      lines.push("");
    }
  }

  const warned = run.outcomes.filter((o) => o.warnings.length > 0);
  if (warned.length > 0) {
    lines.push("## Warnings", "");
    for (const o of warned) for (const w of o.warnings) lines.push(`- ${o.scenario}: ${w.kind} - ${w.message}`);
    lines.push("");
  }

  lines.push("## Judge", "");
  if (!run.judgeModel) lines.push("The judge was skipped (--no-judge).", "");
  else {
    const verdicts = run.outcomes.flatMap((o) => (o.attempts.at(-1)?.judgeVerdicts ?? []).map((v) => ({ o, v })));
    if (verdicts.length === 0) lines.push("No covered bullet was judged.", "");
    else {
      lines.push("| Scenario | Bullet | Verdict | Evidence | Reason |", "|---|---|---|---|---|");
      for (const { o, v } of verdicts) {
        const cell = (s: string): string => s.replace(/\|/g, "\\|").replace(/\n/g, " ").slice(0, 160);
        lines.push(`| ${o.scenario} | ${v.hash} ${cell(v.text)} | ${v.verdict} | ${cell(v.evidence)} | ${cell(v.note ?? v.reason)} |`);
      }
      lines.push("");
    }
  }

  if (run.candidates && run.candidates.length > 0) {
    lines.push("## Candidate snapshots", "", ...run.candidates.map((c) => `- ${c}`), "", `Promote them with \`node harness/src/cli.ts --promote ${run.folder}\`.`, "");
  }
  if (run.coverage) lines.push(run.coverage, "");
  return lines.join("\n");
}

export function renderJson(run: Run): string {
  return JSON.stringify({ ...run, exitCode: exitCode(run), counts: counts(run), usage: totalUsage(run) }, null, 2) + "\n";
}

/** Writes report.md, report.json, junit.xml, and selection.txt, redacted, into the run folder (FR-020). */
export function writeRunReports(run: Run, selection: readonly Selection[], redact: Redactor): void {
  if (!run.folder) return;
  mkdirSync(run.folder, { recursive: true });
  writeFileSync(join(run.folder, "report.md"), redact(renderReportMd(run)));
  writeFileSync(join(run.folder, "report.json"), redact(renderJson(run)));
  writeFileSync(join(run.folder, "junit.xml"), redact(renderJunit(run)));
  writeFileSync(join(run.folder, "selection.txt"), redact(renderSelection(selection)));
}
