import { cap, type Redactor } from "./redact.ts";
import type { Cover } from "./scenario.ts";

export const FAILURE_KINDS = [
  "unmatched-question",
  "rejected-request",
  "outside-writes",
  "experience-order",
  "turn-limit",
  "timeout",
  "assertion",
  "fixture-blocked",
  "missing-token",
  "no-access",
  "build-failed",
  "rate-limit",
  "allowance",
  "chain-stage",
  "service-error",
  "unclassified",
] as const;
export type FailureKind = (typeof FAILURE_KINDS)[number];

/** Kinds that stop the run with exit 2 (FR-036, FR-036b). */
export const EXIT_2_KINDS: ReadonlySet<FailureKind> = new Set(["missing-token", "no-access", "build-failed", "rate-limit", "allowance"]);

const LIKELY_CAUSE: Record<FailureKind, string> = {
  "unmatched-question": "The skill's question changed, or the agent left the workflow at this step. Compare the question with the scenario's ask: lines.",
  "rejected-request": "The agent tried to run a shell command, use memory, or write outside the project, which the storage contract forbids.",
  "outside-writes": "The agent changed a file outside the scenario's writes: patterns. Check the skill's output paths.",
  "experience-order": "The agent showed output before activating highway-experience. Check that the skill's Procedure opens with the activation step.",
  "turn-limit": "The agent kept going past the turn limit.",
  timeout: "The attempt ran past its time limit; the agent stalled or the model was slow.",
  assertion: "A written file is missing a required part. If it is a template heading, the template changed after the fixture was promoted, or the skill skipped its template. For a shows check, the agent did not show the expected text.",
  "fixture-blocked": "The scenario's fixture no longer matches its template. Promote a fresh chain run or fix the fixture.",
  "missing-token": "No Copilot token was found. Set GITHUB_TOKEN in harness/.env.",
  "no-access": "The token has no Copilot access. Check the account's Copilot plan.",
  "build-failed": "The skill copy failed; its error follows.",
  "rate-limit": "Copilot kept rate limiting after 3 retries. Lower --parallel or wait.",
  allowance: "The premium-request allowance is used up. Wait for the reset or raise the limit.",
  "chain-stage": "A chain stage failed, so later stages and every scenario were skipped.",
  "service-error": "The Copilot service returned no response (code -32603). The turn was retried once and failed again; this is not a skill failure.",
  unclassified: "The raw error follows.",
};

export interface Failure {
  kind: FailureKind;
  scenario?: string;
  file?: string;
  attempt?: number;
  attempts?: number;
  stage?: number | null;
  turn?: number | null;
  step?: string | null;
  check?: string;
  path?: string;
  expected?: string;
  actual?: string;
  line?: number | null;
  covers?: Cover[];
  recent?: string[];
  rejected?: string[];
  detail?: string;
  repeated?: { question: string; count: number };
}

export function likelyCause(failure: Failure): string {
  if (failure.kind === "turn-limit" && failure.repeated && failure.repeated.count > 1) {
    return `The agent kept going past the turn limit; it repeated the question "${failure.repeated.question}" ${failure.repeated.count} times.`;
  }
  return LIKELY_CAUSE[failure.kind];
}

const RECENT_LINES = 20;
const LINE_CHARS = 200;
const INDENT = "         ";

function oneLine(text: string, max = LINE_CHARS): string {
  const flat = text.replace(/\s+/g, " ").trim();
  return flat.length > max ? flat.slice(0, max - 1) + "…" : flat;
}

export function failureJson(failure: Failure, run: string): Record<string, unknown> {
  return {
    run,
    scenario: failure.scenario ?? null,
    attempt: failure.attempt ?? null,
    kind: failure.kind,
    stage: failure.stage ?? null,
    turn: failure.turn ?? null,
    step: failure.step ?? null,
    check: failure.check ?? null,
    path: failure.path ?? null,
    expected: failure.expected ?? null,
    actual: failure.actual === undefined ? null : oneLine(failure.actual, 500),
    line: failure.line ?? null,
    covers: (failure.covers ?? []).map((c) => c.hash),
    rejected: failure.rejected ?? [],
    detail: failure.detail === undefined ? null : oneLine(failure.detail, 500),
    cause: likelyCause(failure),
  };
}

/** The stdout failure block and its HARNESS-FAILURE line, redacted and capped (FR-039b–f). */
export function formatFailure(failure: Failure, run: string, redact: Redactor): string {
  const dash = (v: unknown): string => (v === undefined || v === null || v === "" ? "-" : String(v));
  const title = failure.scenario
    ? `${failure.scenario}${failure.attempt ? ` (attempt ${failure.attempt} of ${failure.attempts ?? failure.attempt})` : ""}`
    : "run";
  const out: string[] = [`==== FAILURE ${title} ====`];
  out.push(`Where:   ${dash(failure.file)}; stage ${dash(failure.stage)}; turn ${dash(failure.turn)}; step ${dash(failure.step)}`);

  const what = [failure.check, failure.path].filter(Boolean).join(" ") || failure.kind;
  out.push(`What:    ${oneLine(what)}`);
  if (failure.expected !== undefined || failure.actual !== undefined) {
    out.push(`${INDENT}expected: ${oneLine(dash(failure.expected))}; actual: ${oneLine(dash(failure.actual), 400)}`);
  }
  if (failure.line) out.push(`${INDENT}declared at line ${failure.line}`);
  if (failure.detail) {
    for (const line of cap(failure.detail.trimEnd(), RECENT_LINES, LINE_CHARS).split("\n")) out.push(`${INDENT}${line}`);
  }

  const covers = failure.covers ?? [];
  if (covers.length === 0) out.push("Covers:  none");
  else covers.forEach((c, i) => out.push(`${i === 0 ? "Covers:  " : INDENT}${c.hash} ${oneLine(c.text)}`));

  const recent = failure.recent ?? [];
  if (recent.length === 0) out.push("Recent:  none");
  else {
    const capped = cap(recent.join("\n"), RECENT_LINES, LINE_CHARS).split("\n");
    capped.forEach((line, i) => out.push(`${i === 0 ? "Recent:  " : INDENT}${line}`));
  }

  const rejected = failure.rejected ?? [];
  out.push(`Rejected: ${rejected.length === 0 ? "none" : oneLine(rejected.join("; "), 400)}`);
  out.push(`Likely cause: ${likelyCause(failure)}`);
  out.push(`HARNESS-FAILURE ${JSON.stringify(failureJson(failure, run))}`);
  return out.map((line) => redact(line)).join("\n");
}

/** Classifies an SDK or runtime error by its message (R11). */
export function classifyError(error: unknown): FailureKind {
  const text = errorText(error).toLowerCase();
  if (/premium[- ]request|quota|allowance|usage limit/.test(text)) return "allowance";
  if (/\b429\b|rate[- ]?limit|too many requests/.test(text)) return "rate-limit";
  if (/\b(401|403)\b|unauthori[sz]ed|forbidden|not (?:enabled|entitled)|no copilot access|copilot.*(?:access|subscription)/.test(text)) return "no-access";
  if (/-32603|no response was returned/.test(text)) return "service-error";
  return "unclassified";
}

/** F8: runs the call again once when it fails with a service error; any other error, or a second failure, is thrown. */
export async function retryServiceError<T>(call: () => Promise<T>, onRetry: (error: unknown) => void): Promise<T> {
  try {
    return await call();
  } catch (error) {
    if (classifyError(error) !== "service-error") throw error;
    onRetry(error);
    return await call();
  }
}

export function errorText(error: unknown): string {
  if (error instanceof Error) {
    const code = (error as { code?: unknown }).code;
    return `${error.message}${code !== undefined ? ` (code ${String(code)})` : ""}`;
  }
  return String(error);
}
