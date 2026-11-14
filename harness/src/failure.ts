import type { Cover } from "./scenario.ts";

export const FAILURE_KINDS = [
  "unmatched-question",
  "repeated-question",
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
  "plugin-install",
  "unclassified",
] as const;
export type FailureKind = (typeof FAILURE_KINDS)[number];

/** Kinds that stop the run with exit 2 (FR-036, FR-036b). */
export const EXIT_2_KINDS: ReadonlySet<FailureKind> = new Set(["missing-token", "no-access", "build-failed", "rate-limit", "allowance"]);

const LIKELY_CAUSE: Record<FailureKind, string> = {
  "unmatched-question": "The skill's question changed, or the agent left the workflow at this step. Compare the question with the scenario's ask: lines.",
  "repeated-question": "The agent asked again a question whose reply was already spent: the skill re-asks after that reply's class. Key a reply the skill accepts, or find why the answer did not move it on.",
  "rejected-request": "The agent tried to run a shell command, use memory, or write outside the project, which the storage contract forbids.",
  "outside-writes": "The agent changed a file outside the scenario's writes: patterns. Check the skill's output paths.",
  "experience-order": "The agent showed output before activating highway-experience. Check that the skill's Procedure opens with the activation step.",
  "turn-limit": "The agent kept going past the turn limit.",
  timeout: "The attempt ran past its time limit; the agent stalled or the model was slow.",
  assertion: "A written file is missing a required part. If it is a template heading, the template changed after the fixture was promoted, or the skill skipped its template. For a shows check, the agent did not show the expected text.",
  "fixture-blocked": "The scenario's fixture no longer matches its template. Promote a fresh chain run or fix the fixture.",
  "missing-token": "No key was found for the agent under test. Set its key in harness/.env.",
  "no-access": "The key has no access to the agent's service. Check the account's plan.",
  "build-failed": "highway-agent-plugin/ is missing or differs from its sources, or the base project could not be made; the output follows. Run framework/generate-agent-plugin.sh.",
  "rate-limit": "Copilot kept rate limiting after 3 retries. Lower --parallel or wait.",
  allowance: "The premium-request allowance is used up. Wait for the reset or raise the limit.",
  "chain-stage": "A chain stage failed, so later stages and every scenario were skipped.",
  "service-error": "The Copilot service returned no response (code -32603). The turn was retried once and failed again; this is not a skill failure.",
  "plugin-install": "The plugin did not install or load from highway-agent-plugin/. The attempt's transcript names what the install reported.",
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
  /** For missing-token and no-access: the agent's service and the key variable a person sets. */
  service?: string;
  key?: string;
}

export function likelyCause(failure: Failure): string {
  if (failure.kind === "turn-limit" && failure.repeated && failure.repeated.count > 1) {
    return `The agent kept going past the turn limit; it repeated the question "${failure.repeated.question}" ${failure.repeated.count} times.`;
  }
  if (failure.service && failure.key) {
    if (failure.kind === "missing-token") return `No ${failure.service} token was found. Set ${failure.key} in harness/.env.`;
    if (failure.kind === "no-access") return `The ${failure.key} key has no ${failure.service} access. Check the account's ${failure.service} plan.`;
  }
  return LIKELY_CAUSE[failure.kind];
}

/** F8: runs the call again once when it fails with a service error; any other error, or a second failure, is thrown. */
export async function retryServiceError<T>(call: () => Promise<T>, classify: (error: unknown) => FailureKind, onRetry: (error: unknown) => void): Promise<T> {
  try {
    return await call();
  } catch (error) {
    if (classify(error) !== "service-error") throw error;
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
