import { test } from "node:test";
import assert from "node:assert/strict";
import { parseArgs } from "../src/args.ts";
import { resolveConfig, type FileConfig } from "../src/config.ts";
import { RunStop } from "../src/driver.ts";
import { capFiles, judgePrompt, parseFallback, parseVerdicts, runJudge } from "../src/judge.ts";
import type { Cover } from "../src/scenario.ts";

const covers: Cover[] = [
  { hash: "aaaaaaaaaaaa", text: "The menu offers Review the plan and Continue to code the solution.", line: 1 },
  { hash: "bbbbbbbbbbbb", text: "Declining writes nothing.", line: 2 },
];
const sources = "Agent: The plan is complete for feature 001-send-alert. **Would you like to:**\n1. Review the plan?\n2. Continue to code the solution?";
const line = (hash: string, verdict: string, evidence: string) => JSON.stringify({ hash, verdict, evidence, reason: "Shown in the transcript." });
const fileConfig: FileConfig = { model: "claude-sonnet-4.5", parallel: 4, maxTurns: 40, timeoutMinutes: 20, transcripts: "harness/runs" };

test("a met verdict whose quote appears in the transcript stays met", () => {
  const answer = line("aaaaaaaaaaaa", "met", "1. Review the plan? 2. Continue to code the solution?");
  const [v] = parseVerdicts(answer, covers.slice(0, 1), sources);
  assert.equal(v.verdict, "met");
  assert.equal(v.note, undefined);
});

test("quotes match ignoring emphasis, case, and whitespace", () => {
  const answer = line("aaaaaaaaaaaa", "met", "would you like to:\n1. review THE plan?");
  assert.equal(parseVerdicts(answer, covers.slice(0, 1), sources)[0].verdict, "met");
});

test("a met verdict without a quote counts as not met", () => {
  const [v] = parseVerdicts(line("aaaaaaaaaaaa", "met", ""), covers.slice(0, 1), sources);
  assert.equal(v.verdict, "not met");
  assert.match(v.note ?? "", /without quoted evidence/);
});

test("a met verdict whose quote is not in the transcript or files counts as not met", () => {
  const [v] = parseVerdicts(line("aaaaaaaaaaaa", "met", "3. Deploy it now?"), covers.slice(0, 1), sources);
  assert.equal(v.verdict, "not met");
  assert.match(v.note ?? "", /not in the transcript or files/);
});

test("a bullet the judge skipped, or answered with broken JSON, is not met", () => {
  const answer = ["Here are my verdicts:", '{"hash":"aaaaaaaaaaaa","verdict":"met",', line("zzzzzzzzzzzz", "met", "Review")].join("\n");
  const verdicts = parseVerdicts(answer, covers, sources);
  assert.deepEqual(verdicts.map((v) => v.verdict), ["not met", "not met"]);
  assert.ok(verdicts.every((v) => /no verdict/.test(v.note ?? "")));
});

test("a not met verdict is kept as given, with its reason", () => {
  const [, v] = parseVerdicts(line("bbbbbbbbbbbb", "not met", ""), covers, sources);
  assert.equal(v.verdict, "not met");
  assert.equal(v.reason, "Shown in the transcript.");
});

test("verdicts follow the scenario's covers order, not the judge's answer order", () => {
  const answer = [line("bbbbbbbbbbbb", "not met", ""), line("aaaaaaaaaaaa", "met", "Review the plan?")].join("\n");
  assert.deepEqual(parseVerdicts(answer, covers, sources).map((v) => v.hash), ["aaaaaaaaaaaa", "bbbbbbbbbbbb"]);
});

test("the judge prompt lists every statement with its hash, the transcript, and each file", () => {
  const prompt = judgePrompt("TRANSCRIPT-TEXT", [{ path: "code/x/codify.md", content: "FILE-TEXT" }], covers);
  for (const c of covers) assert.ok(prompt.includes(`${c.hash} ${c.text}`));
  assert.ok(prompt.includes("TRANSCRIPT-TEXT"));
  assert.ok(prompt.includes("--- code/x/codify.md\nFILE-TEXT"));
  assert.match(prompt, /Without a quote, the verdict is not met/);
});

test("file content sent to the judge is capped per file and in total", () => {
  const big = "x".repeat(20_000);
  const capped = capFiles(Array.from({ length: 10 }, (_, i) => ({ path: `f${i}`, content: big })));
  assert.ok(capped.every((f) => f.content.length <= 8_000 + "\n… (cut)".length));
  assert.ok(capped.reduce((n, f) => n + f.content.length, 0) <= 60_000 + capped.length * "\n… (cut)".length);
  assert.ok(capped.length < 10);
});

test("--no-judge skips the judge: no ask is made and no verdict is recorded", async () => {
  const parsed = parseArgs(["--no-judge"]);
  assert.ok(parsed.ok);
  const config = resolveConfig(parsed.options, fileConfig, {});
  assert.equal(config.judge, false);
  const result = await runJudge(undefined, config.judgeModel, "transcript", [], covers);
  assert.deepEqual(result, { skipped: true, verdicts: [] });
});

test("the judge model defaults to the scenario model, and --judge-model overrides it", () => {
  const plain = parseArgs([]);
  assert.ok(plain.ok);
  assert.equal(resolveConfig(plain.options, fileConfig, {}).judgeModel, "claude-sonnet-4.5");
  const model = parseArgs(["--model", "gpt-5"]);
  assert.ok(model.ok);
  assert.equal(resolveConfig(model.options, fileConfig, {}).judgeModel, "gpt-5");
  const judge = parseArgs(["--model", "gpt-5", "--judge-model", "claude-opus-4"]);
  assert.ok(judge.ok);
  const config = resolveConfig(judge.options, fileConfig, {});
  assert.equal(config.model, "gpt-5");
  assert.equal(config.judgeModel, "claude-opus-4");
  assert.equal(config.judge, true);
});

test("the judge runs in its own ask with the judge model, and a scenario with no covers asks nothing", async () => {
  const prompts: string[] = [];
  const ask = async (p: string) => (prompts.push(p), line("aaaaaaaaaaaa", "met", "Review the plan?"));
  const none = await runJudge(ask, "judge-model", sources, [], []);
  assert.deepEqual(none, { skipped: false, model: "judge-model", verdicts: [] });
  assert.equal(prompts.length, 0);
  const ran = await runJudge(ask, "judge-model", sources, [], covers.slice(0, 1));
  assert.equal(prompts.length, 1);
  assert.equal(ran.model, "judge-model");
  assert.equal(ran.verdicts[0].verdict, "met");
});

test("a judge error is recorded on the result; a run stop is rethrown", async () => {
  const failed = await runJudge(async () => Promise.reject(new Error("model unavailable")), "m", sources, [], covers);
  assert.equal(failed.error, "model unavailable");
  assert.deepEqual(failed.verdicts, []);
  await assert.rejects(runJudge(async () => Promise.reject(new RunStop("allowance", "out of premium requests")), "m", sources, [], covers), RunStop);
});

test("the reply fallback reads a number, or none, from the answer", () => {
  const candidates = [4, 7, 9];
  assert.equal(parseFallback("2", candidates), 7);
  assert.equal(parseFallback("Reply 3 fits best.", candidates), 9);
  assert.equal(parseFallback("none", candidates), undefined);
  assert.equal(parseFallback("None of them.", candidates), undefined);
  assert.equal(parseFallback("4", candidates), undefined);
  assert.equal(parseFallback("I am not sure.", candidates), undefined);
});
