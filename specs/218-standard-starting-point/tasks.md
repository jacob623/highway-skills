---

description: "Task list for standard starting point and ordered config steps"
---

# Tasks: Standard Starting Point

**Input**: Design documents from `/specs/218-standard-starting-point/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Pins and moved assertions are in research R6.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US7)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/218-standard-starting-point/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/standard-starting-point.test.sh (mode 644). It requires every sentence in contracts/config-steps.md in its step, the heading order in data-model.md, the starting-point line between the consequence sentence and `**Standard Title:**`, and version 3.2.1. It rejects the lines the contract lists, and the banned words in each changed step. It fails when `standard rules` exceeds 250 words, or `Classify`, `platform proposal`, `standard proposal`, `conflicts`, or `resolve` exceeds 400. The PASS line is `PASS: config steps are ordered, numbered, and open each standard proposal as a starting point`
- [X] T003 Run the new test, observe it fail, and save its output to specs/218-standard-starting-point/probe-fail.txt (D3.6)

---

## Phase 3: User Stories 1 and 2 - Starting-point line (Priority: P1, P2) 🎯 MVP

**Goal**: The line opens an unedited add or update standard proposal only

**Independent Test**: The shape carries the bracketed line after the consequence sentence and before `**Standard Title:**`. The `edit` branch re-emits without it. A remove follows step 3

- [X] T004 [US1] [US2] In .highway/skills/highway-codify-config/SKILL.md, add the bracketed starting-point line to the `standard proposal` shape and the `edit` wording per contracts/config-steps.md

---

## Phase 4: User Story 3 - standard rules (Priority: P1)

**Goal**: Rule building is its own numbered step and `standard proposal` stays within 400 words

**Independent Test**: `### standard rules` holds nine steps after `standards`. `standard proposal` opens with steps 1 through 4 and closes with steps 5 through 7

- [X] T005 [US3] In .highway/skills/highway-codify-config/SKILL.md, replace the two `standard proposal` paragraphs with `### standard rules` after `standards` and the `standard proposal` steps per contracts/config-steps.md

---

## Phase 5: User Story 4 - Yes or no asks (Priority: P1)

**Goal**: Each ask states `question`, `unknown`, and `decline`

**Independent Test**: The onboard question, both `platform written` asks, and `standard write` step 3 carry the contract sentences

- [X] T006 [US4] In .highway/skills/highway-codify-config/SKILL.md, add the reply sentences to the onboard question, `platform written`, and `standard write` step 3

---

## Phase 6: User Story 5 - Named platform (Priority: P1)

**Goal**: A name carried from Entry opens its proposal or the onboard question without the list

**Independent Test**: `platforms` steps 1 and 2 match the contract

- [X] T007 [US5] In .highway/skills/highway-codify-config/SKILL.md, replace the `platforms` opening with steps 1 and 2

---

## Phase 7: User Story 6 - Remaining prose to steps (Priority: P1)

**Goal**: `Classify`, `conflicts`, `resolve`, and the `platform proposal` close are numbered steps

**Independent Test**: Each step matches the contract and the rejected lines are absent

- [X] T008 [US6] In .highway/skills/highway-codify-config/SKILL.md, rewrite `Classify`, `conflicts`, `resolve`, and the `platform proposal` steps 3 through 6 per contracts/config-steps.md

---

## Phase 8: User Story 7 - Step order (Priority: P1)

**Goal**: Headings follow the flow

**Independent Test**: The heading order matches data-model.md

- [X] T009 [US7] In .highway/skills/highway-codify-config/SKILL.md, move `### use entries` after `current`

---

## Phase 9: Polish

- [X] T010 Update Verification for the standard starting-point line, `standard rules`, the class order, the named platform, and the asks
- [X] T011 Set `metadata.version` to 3.2.1
- [X] T012 [P] Move the pins and assertions in research R6
- [X] T013 Run the word count and `validate-skill.sh` on the skill (D8.1)
- [X] T014 Regenerate with `generate-catalog.sh` and `generate-agent-adapters.sh`
- [X] T015 Run the full suite and copy `Summary:` and `EXIT:` into specs/218-standard-starting-point/final.txt. Require 0 failed (D3.2)
- [X] T016 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 through T009 edit the same file and run in order
- T012 edits tests only and follows T011
- Phase 9 depends on every story

## Parallel Example

```text
T012 test pins, beside T010 Verification, after T011
```

## Implementation Strategy

The starting-point line is the MVP the request named. `standard rules` makes room for it. The asks, the named platform, and the remaining prose follow. The move of `use entries` comes last, since it changes no text. The suite runs once at the start and once at the end.
