# Contract: Harness Behavior

Each behavior has a unit test in `harness/test/`, observed failing first.

## Fallback (FR-011)

- `nextUnused(replies, used)` returns `[i]` for the lowest unused index `i`, or `[]`.
- `decide(message, replies, used)` with a question and no matching key returns
  `{ type: "fallback", candidates: nextUnused(...) }`.
- The driver's in-turn fallback uses the same candidates.
- With replies `a`, `b`, and `c`, none used, the fallback candidates are `[0]`.

## repeated-question (FR-011)

- `FAILURE_KINDS` includes `repeated-question`, with a fixed likely cause.
- `spentReply(question, answered)` returns the `say` given earlier to the same question, compared
  with `normalize`, or `undefined`.
- `DriveOutcome` includes `repeated-question`. `DriveResult.respent` holds
  `{ question, reply }`.
- The runner reports the outcome as kind `repeated-question`, check `reply`, expected
  `a different question after the reply was spent`, actual
  `"[question]" asked again after the reply "[reply]"`.

## End-of-turn text (FR-010)

- `textAfterAnswers(messages, answeredAt)` joins `messages.slice(answeredAt)` with a blank line.
- The driver sets `answeredAt` to the number of agent messages in the turn when it answers an
  input-tool question. It resets it at the start of each turn and on a service retry. It decides
  the end-of-turn reply from `textAfterAnswers`.
- The transcript's `agent` entry and `lastMessage` still hold the whole turn.

## contains-any (FR-012)

- `ASSERTIONS` includes `contains-any`, which needs an argument.
- `runExpectation` passes when any matching file holds the text. It fails with check
  `contains-any`, expected `text "[text]" in at least one file`, actual
  `no file among [matches] contains it`. With no matching file, it fails as every assertion does.
- `contains` is unchanged: every matching file must hold the text.
- `tests/harness-scenarios.test.sh` lists `contains-any`.

## README (FR-013)

`harness/README.md` gains:
- a `contains-any` row in the assertion table;
- a `repeated-question` row in the failure kinds table;
- a sentence under the reply rules saying that the fallback is offered only the earliest unused
  reply, and that the end of a turn is judged only after the last in-turn answer.
