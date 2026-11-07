---

description: "Task list for execution fields, the executor, and platform-standard entries"
---

# Tasks: Establish From Record

**Input**: Design documents from `/specs/223-establish-from-record/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Moved pins are in research R6.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/223-establish-from-record/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/establish-from-record.test.sh (mode 644). It requires the lines in contracts/execution.md, contracts/proposal.md, and contracts/platform-entries.md. It rejects `Every task names that same Provider` and `this implementation's row, then the first row` inside `provider`. It requires versions 7.3.0, 12.1.0, 3.3.0, 10.2.0, template 2.1.0, and record 2.2.0. The PASS line is `PASS: establish reads the record and a platform standard has two entries`
- [X] T003 Run the new test, observe it fail, and save its output to specs/223-establish-from-record/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - Execution fields (Priority: P1) 🎯 MVP

**Goal**: The implementation proposal shows Deployed by, Managed by, and Language, and the record stores them

**Independent Test**: The execution lines and the record section in the new test pass

- [X] T004 [US1] Add Kind to .highway/library/templates/output/codify-platforms.md and set its version to 2.1.0 per contracts/execution.md
- [X] T005 [US1] Add Execution to .highway/library/templates/output/implementation-record.md and set its version to 2.2.0 per contracts/execution.md
- [X] T006 [US1] Add `execution` and the three proposal lines to .highway/skills/highway-implementation/SKILL.md per contracts/execution.md

---

## Phase 4: User Story 2 - Add or onboard a named platform (Priority: P1)

**Goal**: A platform that is not a row pauses the proposal and returns after the row exists

**Independent Test**: The replacement lines in the new test pass

- [X] T007 [US2] In .highway/skills/highway-implementation/SKILL.md, send a missing row to `highway-codify-config` or `highway-onboarding` and return to `execution` per contracts/execution.md
- [X] T008 [US2] In .highway/skills/highway-onboarding/SKILL.md, honor a named return step after the platform row exists

---

## Phase 5: User Story 5 - Platform-standard entries (Priority: P1)

**Goal**: A platform standard proposes only `[Platform] is used` and `[Platform] is not used`, and configuration saves Kind

**Independent Test**: The platform-entries shape and the Kind line in the new test pass

- [X] T009 [US5] Add `kind` and `platform entries` to .highway/skills/highway-codify-config/SKILL.md per contracts/execution.md and contracts/platform-entries.md

---

## Phase 6: User Story 3 - Executor and task platforms (Priority: P1)

**Goal**: Establish uses Deployed by as the executor and leaves each task its own platform

**Independent Test**: The executor lines in the new test pass, and the old same-Provider sentence is absent

- [X] T010 [US3] In .highway/skills/highway-codify/SKILL.md, replace the shared Provider in `draft`, `provider`, `propose`, and `revise` per contracts/proposal.md

---

## Phase 7: User Story 4 - Day-2 executor (Priority: P2)

**Goal**: A run, change, or recover action uses Managed by as the executor

**Independent Test**: `provider` selects Managed by when the action title does not contain establish

- [X] T011 [US4] In .highway/skills/highway-codify/SKILL.md `provider` and `standards`, keep Language and the task's platform standard per contracts/proposal.md

---

## Phase 8: Polish

- [X] T012 Set versions to 7.3.0, 12.1.0, 3.3.0, and 10.2.0 in the four SKILL.md files
- [X] T013 Move the pins listed in specs/223-establish-from-record/research.md R6
- [X] T014 Run the word count and `validate-skill.sh` on the four skills
- [X] T015 Regenerate with `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`
- [X] T016 Run the full suite and copy `Summary:` and `EXIT:` into specs/223-establish-from-record/final.txt. Require 0 failed (D3.2)
- [X] T017 Confirm no shipped file of this change references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 and T005 are different templates and can run together
- T006 depends on T005. T007 depends on T006. T008 depends on T007
- T009 edits `highway-codify-config` only and can follow T003
- T010 and T011 edit `highway-codify` in that order
- T012 through T017 follow every story

## Parallel Example

```text
T004 platforms template and T005 implementation record, after T003
T009 config skill, after T003, beside the implementation edits
```

## Implementation Strategy

MVP is User Story 1: the three fields on the proposal and the record. User Story 3 is the codify reader. User Story 5 is independent and ships with the same suite run. No migration.
