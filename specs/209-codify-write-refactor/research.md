# Research: Codify Write Refactor

## R1. Rules only `write` states

- **Decision**: None. Each of the five `write` bullets is already stated by `codify-tasks.md` 4.0.0:
  - Feature grouping in proposal order, lines from the accepted Files: "Each proposal task is one feature... A feature's lines sit together... taken from the accepted Files of that proposal task."
  - Executor lines: "They hold files the Provider needs that no feature writes, and they come before every feature."
  - Files and Standards on a line, including which list an `[Executor]` line uses: the `Standards:` paragraph.
  - The test line: "When a feature's first standard says `Tests: required`, the feature's first line is its test."
  - No line for an undelivered path, README last: "A path no feature delivers has no line." and "The README task is last."
- **Rationale**: FR-002 adds a rule to the template only when the template lacks it. The template stays `4.0.0`.

## R2. What `write` keeps

- **Decision**: Keep the opening paragraph (the three files written together, nothing partial, no README or task file), the record bullets, the sentence naming the task list template, the catalog bullets, and "On success, go to `code` without asking a question."
- **Rationale**: FR-003 and FR-007. Removing the five bullets alone brings `write` from 395 to 247 words, which meets FR-005 without touching the record or catalog text.

## R3. Where the catalog check lives

- **Decision**: A new `### codified` section directly after `### suggest`. `suggest` leaves out what `codified` removes before keeping five, and words the empty case.
- **Rationale**: `suggest` is at 364 words. The check needs about 120 words. A separate step keeps both under 400 (P7.5), matching how `layout` was split from `propose`.
- **Alternatives considered**: Inline in `suggest`. Rejected because it exceeds 400 words.

## R4. Match rules

- **Decision**:
  1. Read accepted rows of `code/code.md` whose Implementation ID is the selected implementation.
  2. Same words in the same order as an Automation Title, ignoring case: leave the suggestion out. Do not open the record.
  3. Otherwise, when a row's title means the suggestion may already be implemented: read `codify.md` at its Automation Path. Leave the suggestion out when the record's title, summary, or description is that action. Keep it when the record is a different action or the file is absent.
  4. Removed rows, rows for other implementations, and a missing catalog leave nothing out.
- **Rationale**: Clarifications Q1 and Q2. The record is opened only when meaning suggests a match.

## R5. Empty list wording

- **Decision**: When every grounded suggestion was left out by `codified`, say: `Each action grounded in this implementation is already codified.` Then emit the invitation line. When nothing is grounded, keep the existing sentence.
- **Rationale**: FR-011. The two empty cases say different things.

## R6. Replaced assertions (D3.5)

- `codify-file-layout.test.sh`, `codify-config-skill.test.sh`, `codify-platform-catalog.test.sh`, `codify-closing-guide.test.sh`: the `highway-codify` pin moves from `version: 8.0.0` to `version: 9.0.0`. Reason: MAJOR bump only. No other assertion changes.

## R7. Verification

- **Decision**: Replace the task-list Verification bullet with: "The task list follows `codify-tasks.md`. A feature's test line comes first only when its first standard says `Tests: required`." Add one bullet for `codified`. `No coding standard applies.` remains in other bullets.
- **Rationale**: FR-006.
