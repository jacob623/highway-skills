---

description: "Task list for one coding rule per item, within eight words, with a consequence line"
---

# Tasks: Single Rule Shape

**Input**: Design documents from `/specs/221-single-rule-shape/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Pins and moved assertions are in research R4.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US4)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/221-single-rule-shape/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/single-rule-shape.test.sh (mode 644). It requires `rule shape` steps 1 through 5 per contracts/rule-shape.md in order, the heading order `standard rules`, `rule shape`, `standard proposal`, the changed `standard rules` steps 1, 3, 5, and 6, the proposal rule block with its blank line, the skeleton line, skill version 3.2.4, and template version 3.0.1. It rejects the lines the contract lists, and the banned words in `rule shape` and `standard rules`. It fails when `rule shape` or `standard rules` exceeds 250 words or `standard proposal` exceeds 400. The PASS line is `PASS: a coding rule is one must within eight words`
- [X] T003 Run the new test, observe it fail, and save its output to specs/221-single-rule-shape/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - One rule at a time (Priority: P1) 🎯 MVP

**Goal**: Each rule is one must, one condition, and one outcome in eight words or fewer. The model suggests at most fifteen rules

**Independent Test**: `rule shape` steps 1 and 2 and `standard rules` steps 1, 3, 5, and 6 match the contract

- [X] T004 [US1] In .highway/skills/highway-codify-config/SKILL.md, add `### rule shape` after `### standard rules` with steps 1, 2, and 5 per contracts/rule-shape.md
- [X] T005 [US1] In .highway/skills/highway-codify-config/SKILL.md, replace `standard rules` steps 1, 3, 5, and 6 per contracts/rule-shape.md

---

## Phase 4: User Story 2 - Why it matters under each rule (Priority: P1)

**Goal**: A blank line and one consequence sentence sit under each rule on the proposal, and the saved file keeps the rule only

**Independent Test**: `rule shape` step 4 and the proposal rule block match the contract. The skeleton keeps its no-Why-it-matters statement

- [X] T006 [US2] In .highway/skills/highway-codify-config/SKILL.md, add `rule shape` step 4 and replace the `**Coding Standards:**` block in `standard proposal` per contracts/rule-shape.md
- [X] T007 [P] [US2] In .highway/library/templates/output/coding-standard.md, replace the rules line per contracts/rule-shape.md and set the version to 3.0.1

---

## Phase 5: User Story 3 - A provided rule is rewritten before the proposal (Priority: P1)

**Goal**: A rule the person provides, or a saved rule, that does not conform is rewritten, and the opening sentence names the rewrite

**Independent Test**: `rule shape` step 3 matches the contract

- [X] T008 [US3] In .highway/skills/highway-codify-config/SKILL.md, add `rule shape` step 3 per contracts/rule-shape.md

---

## Phase 6: User Story 4 - Ordered steps (Priority: P1)

**Goal**: `rule shape` stands between `standard rules` and `standard proposal`, and the word limits hold

**Independent Test**: The heading order and word counts in the new test pass

- [X] T009 [US4] Confirm the heading order and run the word count on .highway/skills/highway-codify-config/SKILL.md. `rule shape` and `standard rules` are 250 words or fewer, and `standard proposal` is 400 or fewer

---

## Phase 7: Polish

- [X] T010 Add a Verification bullet for `rule shape` to .highway/skills/highway-codify-config/SKILL.md and set `metadata.version` to 3.2.4
- [X] T011 [P] Move the pins and assertions in research R4
- [X] T012 Run `validate-skill.sh` on highway-codify-config (D8.1)
- [X] T013 Regenerate with `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`
- [X] T014 Run the full suite and copy `Summary:` and `EXIT:` into specs/221-single-rule-shape/final.txt. Require 0 failed (D3.2)
- [X] T015 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004, T005, T006, T008, T009, and T010 edit the same file and run in order
- T007 edits the template and can run beside T006
- T011 edits tests only and follows T010
- Phase 7 depends on every story

## Parallel Example

```text
T007 template skeleton, beside T006 proposal block
T011 test pins, after T010
```

## Implementation Strategy

`rule shape` steps 1 and 2 with the fifteen-suggestion cap are the MVP. The consequence line, the rewrite, and the step order follow in the same file. The suite runs once at the start and once at the end.
