import { test } from "node:test";
import assert from "node:assert/strict";
import { cap, createRedactor, REDACTED, secretValues } from "../src/redact.ts";

test("environment values named TOKEN, KEY, or SECRET are redacted", () => {
  const redact = createRedactor({ GITHUB_TOKEN: "abcdefgh12345678", API_KEY: "zzzzzzzzzz", HOME: "/Users/me" });
  assert.equal(redact("token abcdefgh12345678 key zzzzzzzzzz home /Users/me"), `token ${REDACTED} key ${REDACTED} home /Users/me`);
});

test("short values are not treated as secrets", () => {
  assert.deepEqual(secretValues({ SOME_KEY: "abc" }), []);
});

test("GitHub and OpenAI-style token patterns are redacted without an environment value", () => {
  const redact = createRedactor({});
  const gh = "ghp_" + "a".repeat(36);
  const pat = "github_pat_" + "B".repeat(30);
  const sk = "sk-" + "c".repeat(24);
  assert.equal(redact(`${gh} ${pat} ${sk}`), `${REDACTED} ${REDACTED} ${REDACTED}`);
});

test("cap keeps the last lines and shortens long ones", () => {
  const text = ["one", "two", "three", "x".repeat(50)].join("\n");
  const out = cap(text, 2, 10);
  assert.equal(out.split("\n").length, 3);
  assert.match(out, /2 earlier lines cut/);
  assert.match(out, /^x{9}…$/m);
});
