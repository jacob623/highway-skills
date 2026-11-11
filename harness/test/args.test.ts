import { test } from "node:test";
import assert from "node:assert/strict";
import { helpText, parseArgs } from "../src/args.ts";
import { SWITCHES } from "../src/switches.ts";

test("no switch is a full run", () => {
  const r = parseArgs([]);
  assert.ok(r.ok);
  assert.equal(r.options.smoke, false);
  assert.deepEqual(r.options.paths, []);
});

test("targeted switches combine and lists split on commas", () => {
  const r = parseArgs(["--skills", "highway-codify,highway-adr", "--paths=a.md,b.md", "--changed-since", "main"]);
  assert.ok(r.ok);
  assert.deepEqual(r.options.skills, ["highway-codify", "highway-adr"]);
  assert.deepEqual(r.options.paths, ["a.md", "b.md"]);
  assert.equal(r.options.changedSince, "main");
});

test("--smoke with a targeted switch is a conflict", () => {
  const r = parseArgs(["--smoke", "--skills", "highway-codify"]);
  assert.equal(r.ok, false);
  if (!r.ok) assert.match(r.error, /--smoke cannot be used with --skills/);
});

test("--promote with --smoke is a conflict", () => {
  const r = parseArgs(["--promote", "harness/runs/x", "--smoke"]);
  assert.equal(r.ok, false);
});

test("unknown switches, missing values, and non-positive numbers are errors", () => {
  assert.equal(parseArgs(["--bogus"]).ok, false);
  assert.equal(parseArgs(["--model"]).ok, false);
  assert.equal(parseArgs(["--model", "--smoke"]).ok, false);
  assert.equal(parseArgs(["--parallel", "0"]).ok, false);
  assert.equal(parseArgs(["--timeout", "1.5"]).ok, false);
  assert.equal(parseArgs(["--smoke=yes"]).ok, false);
});

test("numbers parse", () => {
  const r = parseArgs(["--parallel", "2", "--max-turns", "10", "--timeout", "5"]);
  assert.ok(r.ok);
  assert.equal(r.options.parallel, 2);
  assert.equal(r.options.maxTurns, 10);
  assert.equal(r.options.timeout, 5);
});

test("-h is help", () => {
  const r = parseArgs(["-h"]);
  assert.ok(r.ok && r.options.help);
});

test("help lists every switch with its usage and the examples", () => {
  const help = helpText();
  for (const s of SWITCHES) {
    assert.ok(help.includes(s.name), `help is missing ${s.name}`);
    assert.ok(s.usage.length > 0, `${s.name} has no usage`);
    assert.ok(help.includes(s.usage), `help is missing the usage of ${s.name}`);
  }
  assert.match(help, /node harness\/src\/cli\.ts --smoke/);
  assert.match(help, /^Selection:$/m);
});
