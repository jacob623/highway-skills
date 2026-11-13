import { test } from "node:test";
import assert from "node:assert/strict";
import { decide, findReply, lastQuestion, nextUnused, normalize, spentReply, textAfterAnswers } from "../src/replies.ts";
import type { Reply } from "../src/scenario.ts";

const text = (t: string, say: string, line = 1): Reply => ({ key: { type: "text", text: t }, say, line });
const pattern = (p: string, say: string, line = 1): Reply => ({ key: { type: "pattern", pattern: p }, say, line });

test("normalization ignores emphasis, case, and whitespace", () => {
  assert.equal(normalize("**What  would you\nADD**?"), "what would you add?");
});

test("replies are consumed in file order, so one question can get different replies", () => {
  const replies = [text("What would you add, correct, or remove?", "first"), text("What would you add, correct, or remove?", "second")];
  const used = new Set<number>();
  const message = "Here it is.\n\n**What would you add, correct, or remove?**";
  const a = findReply(message, replies, used);
  assert.equal(a, 0);
  used.add(a!);
  assert.equal(findReply(message, replies, used), 1);
  used.add(1);
  assert.equal(findReply(message, replies, used), undefined);
});

test("patterns match questions the skill does not spell out", () => {
  const replies = [pattern("^Would you like", "1")];
  assert.equal(findReply("Plan ready.\nWould you like to:\n1. Review", replies, new Set()), 0);
});

test("a later reply matches when an earlier one does not", () => {
  const replies = [text("Which title?", "a"), text("Proceed?", "b")];
  assert.equal(findReply("Proceed?", replies, new Set()), 1);
});

test("no key and a question goes to the fallback with unused replies only", () => {
  const replies = [text("Which title?", "a"), text("Proceed?", "b")];
  assert.deepEqual(decide("Shall I continue?", replies, new Set([0])), { type: "fallback", candidates: [1] });
});

test("the fallback is offered only the earliest unused reply", () => {
  const replies = [text("Which option?", "a"), text("Proceed?", "b"), text("Anything else?", "c")];
  assert.deepEqual(decide("Which Discovery would you like to decide?", replies, new Set()), { type: "fallback", candidates: [0] });
  assert.deepEqual(nextUnused(replies, new Set([0, 2])), [1]);
  assert.deepEqual(nextUnused(replies, new Set([0, 1, 2])), []);
});

test("spentReply names the reply already given to the same question", () => {
  const answered = new Map([[normalize("**Which Discovery would you like to decide?**"), "Yes, go ahead."]]);
  assert.equal(spentReply("Which  discovery would you like to decide?", answered), "Yes, go ahead.");
  assert.equal(spentReply("Which option would you like to select?", answered), undefined);
});

test("the end of a turn is judged after the last in-turn answer", () => {
  const messages = ["**Which objectives?**", "Understood."];
  assert.equal(textAfterAnswers(messages, 0), "**Which objectives?**\n\nUnderstood.");
  assert.equal(textAfterAnswers(messages, 1), "Understood.");
  assert.equal(textAfterAnswers(messages, 2), "");
});

test("no key and no question ends the conversation", () => {
  assert.deepEqual(decide("The codify stage is complete.", [text("Proceed?", "b")], new Set()), { type: "end" });
});

test("lastQuestion picks the last line with a question mark", () => {
  assert.equal(lastQuestion("Intro?\nmore\nFinal question here?\nThanks."), "Final question here?");
});
