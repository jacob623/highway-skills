---

description: "Task list for codify write refactor"
---

# Tasks: Codify Write Refactor

**Input**: Design documents from `/specs/209-codify-write-refactor/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Four version pins move, with D3.5 reasons in research R6.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US4)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` in the background with all permissions, wait for it, and copy the `Summary:` and `EXIT:` lines into specs/209-codify-write-refactor/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/codify-write-refactor.test.sh (mode 644, static-document-contract header). It extracts the `### write`, `### codified`, and `## Verification` sections of .highway/skills/highway-codify/SKILL.md with `awk`, then:
  - requires `codify-tasks.md` and `Write none of them until all are valid.` in `write`, and rejects the five rule strings in contracts/write-step.md;
  - requires `write` to be at most 250 words;
  - requires `### codified` after `### suggest`, with `same words, in the same order`, `Automation Path`, and `Do not open that record.`;
  - requires `Each action grounded in this implementation is already codified.` in the skill;
  - requires `Tests: required` and `No coding standard applies.` in Verification, and rejects `The task list holds one group of lines per proposal task`;
  - requires `version: 9.0.0`.
- [X] T003 Run the new test, observe it fail, and save its output to specs/209-codify-write-refactor/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - One statement of how a task list is written (Priority: P1) 🎯 MVP

**Goal**: `write` names the template and states none of its line rules

**Independent Test**: `write` contains none of the five rule strings and is at most 250 words

- [X] T004 [US1] In .highway/skills/highway-codify/SKILL.md `write`, remove the five bullets under "The task list follows". Keep everything else in `write` (research R2)

---

## Phase 4: User Story 2 - The task list the person receives does not change (Priority: P1)

**Goal**: The list stays the one `codify-tasks.md` 4.0.0 requires

**Independent Test**: `codify-tasks.md` is byte-identical to before. `layout`, `propose`, and `code` are unchanged

- [X] T005 [US2] Confirm with `git diff` that .highway/library/templates/output/codify-tasks.md is unchanged, and that only `suggest`, `write`, the new `codified` section, the Procedure order, Verification, and the version changed in .highway/skills/highway-codify/SKILL.md

---

## Phase 5: User Story 4 - Recommend only automations that are not yet codified (Priority: P1)

**Goal**: Suggestions this implementation already accepted are left out

**Independent Test**: `codified` exists after `suggest` and states the word-for-word, meaning, and record rules from contracts/codified-check.md

- [X] T006 [US4] Add `### codified` directly after `### suggest` in .highway/skills/highway-codify/SKILL.md, following contracts/codified-check.md
- [X] T007 [US4] In `suggest`, leave out what `codified` removes before keeping five, and add the already-codified sentence for the empty case. Note `codified` in the Procedure order

---

## Phase 6: User Story 3 - Verification checks the list once (Priority: P2)

**Goal**: Verification stops repeating the line rules

- [X] T008 [US3] In Verification of .highway/skills/highway-codify/SKILL.md, replace the task-list bullet per research R7, and add one bullet for `codified`. Bump the version to 9.0.0

---

## Phase 7: Polish

- [X] T009 Check every section of highway-codify is at most 400 words and `write` is at most 250, then run `validate-skill.sh` on it
- [X] T010 [P] Move the `highway-codify` version pin to 9.0.0 in codify-file-layout.test.sh, codify-config-skill.test.sh, codify-platform-catalog.test.sh, and codify-closing-guide.test.sh (research R6)
- [X] T011 Run the new test and the codify tests, all passing
- [X] T012 Regenerate with `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`
- [X] T013 Run the full suite in the background, copy `Summary:` and `EXIT:` into specs/209-codify-write-refactor/final.txt, and require 0 failed (D3.2)
- [X] T014 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004, T006, T007, and T008 edit the same file, so they run in order
- T005 runs after T004 through T008
- Phase 7 depends on all stories

## Parallel Example

```text
T010 version pins in four test files, alongside T009 validation
```

## Implementation Strategy

The MVP is US1: `write` names the template and drops the duplicate rules. US4 adds the catalog check to recommendations. US3 shortens Verification. US2 confirms the task list is unchanged. The suite runs once at the start and once at the end.
