import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { CopilotClient } from "@github/copilot-sdk";
import { RunStop, withRateLimit, type FallbackPicker } from "./driver.ts";
import { keyText, normalize } from "./replies.ts";
import type { Cover, Scenario } from "./scenario.ts";

/** One prompt in a new session with no tools, returning the reply text. */
export type Ask = (prompt: string) => Promise<string>;

export function copilotAsk(token: string, model: string): Ask {
  return async (prompt) => {
    const home = mkdtempSync(join(tmpdir(), "harness-judge-"));
    const client = new CopilotClient({ baseDirectory: home, gitHubToken: token, useLoggedInUser: false, workingDirectory: home, logLevel: "error" });
    try {
      await withRateLimit(() => client.start());
      const session = await withRateLimit(() =>
        client.createSession({
          model,
          workingDirectory: home,
          clientName: "highway-harness-judge",
          enableConfigDiscovery: false,
          enableSessionStore: false,
          enableSessionTelemetry: false,
          enableSkills: false,
          onPermissionRequest: () => ({ kind: "reject", feedback: "No tools are available. Answer from the text you were given." }),
        }),
      );
      try {
        const reply = await withRateLimit(() => session.sendAndWait({ prompt }, 300_000));
        return reply?.data.content ?? "";
      } finally {
        await session.disconnect().catch(() => undefined);
      }
    } finally {
      await client.stop().catch(() => undefined);
      rmSync(home, { recursive: true, force: true });
    }
  };
}

// ---- Reply fallback (FR-009) ----

export function fallbackPrompt(message: string, scenario: Scenario, candidates: readonly number[]): string {
  const options = candidates.map((index, n) => `${n + 1}. Question: ${keyText(scenario.replies[index])}\n   Reply: ${scenario.replies[index].say}`);
  return [
    "An assistant sent the message below. Pick the reply that answers the question the message asks.",
    "Answer with the number of the fitting reply only, or the word none when no reply fits.",
    "",
    "Message:",
    "<<<",
    message,
    ">>>",
    "",
    "Replies:",
    ...options,
  ].join("\n");
}

export function parseFallback(answer: string, candidates: readonly number[]): number | undefined {
  const text = answer.trim().toLowerCase();
  if (/^\W*none\b/.test(text)) return undefined;
  const match = /\b(\d+)\b/.exec(text);
  if (!match) return undefined;
  const n = Number(match[1]);
  return n >= 1 && n <= candidates.length ? candidates[n - 1] : undefined;
}

export function makeFallbackPicker(ask: Ask, scenario: Scenario): FallbackPicker {
  return async (message, candidates) => parseFallback(await ask(fallbackPrompt(message, scenario, candidates)), candidates);
}

// ---- Advisory judge (FR-030) ----

export interface Verdict {
  hash: string;
  text: string;
  verdict: "met" | "not met";
  evidence: string;
  reason: string;
  note?: string;
}

export interface JudgeFile {
  path: string;
  content: string;
}

const FILE_CHARS = 8_000;
const TOTAL_FILE_CHARS = 60_000;
const TRANSCRIPT_CHARS = 80_000;

export function capFiles(files: readonly JudgeFile[]): JudgeFile[] {
  const out: JudgeFile[] = [];
  let total = 0;
  for (const file of files) {
    if (total >= TOTAL_FILE_CHARS) break;
    const room = Math.min(FILE_CHARS, TOTAL_FILE_CHARS - total);
    const content = file.content.length > room ? file.content.slice(0, room) + "\n… (cut)" : file.content;
    total += content.length;
    out.push({ path: file.path, content });
  }
  return out;
}

export function judgePrompt(transcript: string, files: readonly JudgeFile[], covers: readonly Cover[]): string {
  const t = transcript.length > TRANSCRIPT_CHARS ? "… (earlier turns cut)\n" + transcript.slice(-TRANSCRIPT_CHARS) : transcript;
  return [
    "You are reviewing a finished conversation between a person and an assistant, and the files it wrote.",
    "For each statement below, decide whether the conversation and files show it is met.",
    "Quote the exact words from the transcript or a file that show it. Without a quote, the verdict is not met.",
    'Answer with one JSON object per line and nothing else: {"hash":"<hash>","verdict":"met" or "not met","evidence":"<exact quote>","reason":"<one sentence>"}',
    "",
    "Statements:",
    ...covers.map((c) => `${c.hash} ${c.text}`),
    "",
    "Transcript:",
    "<<<",
    t,
    ">>>",
    "",
    "Files:",
    ...capFiles(files).flatMap((f) => [`--- ${f.path}`, f.content]),
  ].join("\n");
}

/** One verdict per covered bullet; a met verdict without a quote found in the sources is not met. */
export function parseVerdicts(answer: string, covers: readonly Cover[], sources: string): Verdict[] {
  const parsed = new Map<string, Record<string, unknown>>();
  for (const line of answer.split("\n")) {
    const start = line.indexOf("{");
    const end = line.lastIndexOf("}");
    if (start < 0 || end <= start) continue;
    try {
      const obj = JSON.parse(line.slice(start, end + 1)) as Record<string, unknown>;
      if (typeof obj.hash === "string") parsed.set(obj.hash, obj);
    } catch {
      // A line that is not JSON is ignored; its bullet is reported as not met below.
    }
  }
  const haystack = normalize(sources);
  return covers.map((cover) => {
    const obj = parsed.get(cover.hash);
    if (!obj) return { hash: cover.hash, text: cover.text, verdict: "not met", evidence: "", reason: "", note: "The judge returned no verdict for this bullet." };
    const evidence = typeof obj.evidence === "string" ? obj.evidence.trim() : "";
    const reason = typeof obj.reason === "string" ? obj.reason.trim() : "";
    const saidMet = String(obj.verdict).trim().toLowerCase() === "met";
    if (saidMet && evidence === "") return { hash: cover.hash, text: cover.text, verdict: "not met", evidence, reason, note: "Met without quoted evidence counts as not met." };
    if (saidMet && !haystack.includes(normalize(evidence))) {
      return { hash: cover.hash, text: cover.text, verdict: "not met", evidence, reason, note: "The quoted evidence is not in the transcript or files." };
    }
    return { hash: cover.hash, text: cover.text, verdict: saidMet ? "met" : "not met", evidence, reason };
  });
}

export interface JudgeResult {
  skipped: boolean;
  model?: string;
  verdicts: Verdict[];
  error?: string;
}

export async function runJudge(
  ask: Ask | undefined,
  model: string,
  transcript: string,
  files: readonly JudgeFile[],
  covers: readonly Cover[],
): Promise<JudgeResult> {
  if (!ask) return { skipped: true, verdicts: [] };
  if (covers.length === 0) return { skipped: false, model, verdicts: [] };
  try {
    const answer = await ask(judgePrompt(transcript, files, covers));
    const sources = [transcript, ...files.map((f) => f.content)].join("\n");
    return { skipped: false, model, verdicts: parseVerdicts(answer, covers, sources) };
  } catch (error) {
    if (error instanceof RunStop) throw error;
    return { skipped: false, model, verdicts: [], error: error instanceof Error ? error.message : String(error) };
  }
}
