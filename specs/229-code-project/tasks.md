---

description: "Task list for code project"
---

# Tasks: Code Project

**Input**: Design documents from `/specs/229-code-project/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Moved pins are in research R8.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US4)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/229-code-project/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/code-project.test.sh (mode 644). It requires every new line in contracts/wording.md in its section of .highway/skills/highway-codify/SKILL.md, .highway/skills/highway-implementation/SKILL.md, .highway/skills/highway-onboarding/SKILL.md, and the two templates. It rejects `### platforms needed`, the one-run sentences, and the onboarding `provider` return. It checks `record check`, `code project`, and `provider` are 250 words or fewer, `code tasks` and `delivery platforms` 400 or fewer, with no banned word, and requires the new versions. The PASS line is `PASS: a complete record leads codify, and a Language makes a code project`
- [X] T003 Run the new test, observe it fail, and save its output to specs/229-code-project/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - Codify works only on a complete record (Priority: P1) 🎯 MVP

**Goal**: Selection checks the record and hands an incomplete one to highway-implementation

**Independent Test**: The `record check`, `delivery platforms`, `delivery decline`, and onboarding pins of code-project.test.sh pass

- [X] T004 [US1] In .highway/skills/highway-codify/SKILL.md, replace Entry step 8 and the `choose` selection sentence, add `### record check` after `### choose`, replace the `provider` steps, and remove `### platforms needed`, per contracts/wording.md
- [X] T005 [P] [US1] In .highway/skills/highway-implementation/SKILL.md, change the Procedure clause, `delivery platforms` step 3, its view, and its `accept` and `decline` replies, and add `### delivery decline`, per contracts/wording.md
- [X] T006 [P] [US1] In .highway/skills/highway-onboarding/SKILL.md, set `Language: Needed`, remove the `provider` return sentence, and replace the Verification bullet
- [X] T007 [P] [US1] In .highway/library/templates/output/implementation-record.md, allow `Needed` for Language and set `version: 2.3.0`

---

## Phase 4: User Story 2 - Establish starts the code project (Priority: P1)

**Goal**: A Language makes a code project whose only suggestion is Establish until it is recorded

**Independent Test**: The `code project` steps 1 and 2 and `code tasks` steps 1, 3, and 4 pins pass

- [X] T008 [US2] In .highway/skills/highway-codify/SKILL.md, add `### code project` after `### codified`, and change the last sentence of `codified`, per contracts/wording.md

---

## Phase 5: User Story 3 - Later suggestions change the product code (Priority: P1)

**Goal**: After Establish, suggestions come from the record, at most five

**Independent Test**: The `code project` steps 3 to 6 pins pass

- [X] T009 [US3] Confirm `code project` steps 3 to 6 in .highway/skills/highway-codify/SKILL.md match contracts/wording.md, and the Procedure order names `record check`, `code project`, and `code tasks`

---

## Phase 6: User Story 4 - Code project proposal shape (Priority: P2)

**Goal**: Code tasks show Language, follow the Language standard, and the product is the implementation

**Independent Test**: The `code tasks` and pointer pins pass

- [X] T010 [US4] In .highway/skills/highway-codify/SKILL.md, add `### code tasks` after `### draft`, the pointer sentences in `draft`, `standards`, `join`, `folder`, `layout`, `propose`, `code`, and `close`, and the `revise` accept clause
- [X] T011 [P] [US4] In .highway/library/templates/output/codify-record.md, add the three code project sentences and set `version: 9.1.0`
- [X] T012 [US4] Replace the Purpose and Verification bullets in .highway/skills/highway-codify/SKILL.md and .highway/skills/highway-implementation/SKILL.md, and set `version: 13.0.0`, `7.8.0`, and `10.6.0`

---

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T013 Move the pins in research R8 across .highway/tools/tests/*.test.sh (D3.5)
- [X] T014 Run the quickstart tests and `bash .highway/tools/validate-skill.sh` for .highway/skills/highway-codify, .highway/skills/highway-implementation, and .highway/skills/highway-onboarding
- [X] T015 Regenerate with `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh` (D4.5 through D4.7)
- [X] T016 Run `bash .highway/tools/tests/run-all.sh` into specs/229-code-project/final.txt. Require 0 failed (D3.2)
- [X] T017 Confirm no shipped file under .highway/ references `.specify/` or `specs/` (D1.1)

---

## Dependencies & Execution Order

- T001 → T002 → T003 → US1 (T004, then T005 to T007 in parallel) → T008 → T009 → T010 → T011 → T012 → T013 → T014 → T015 → T016 → T017.
- T008 and T010 edit the same file as T004 and run after it.

## Parallel Example

- T005, T006, and T007 edit different files.

## Implementation Strategy

US1 is the MVP: codify stops on an incomplete record and the person completes it. US2 and US3 add the code project suggestions. US4 shapes the code project proposal.
