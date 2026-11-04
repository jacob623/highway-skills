---

description: "Task list for propose edit lines"
---

# Tasks: Propose Edit Lines

**Input**: Design documents from `/specs/210-propose-edit-lines/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Five version pins move, with D3.5 reasons in research R3.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` in the background with all permissions, wait for it, and copy the `Summary:` and `EXIT:` lines into specs/210-propose-edit-lines/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/propose-edit-lines.test.sh (mode 644, static-document-contract header). It reads the `### propose` section of .highway/skills/highway-codify/SKILL.md and:
  - requires each clause in contracts/edit-lines.md;
  - rejects a line longer than 240 characters inside the edit handling;
  - requires the step to be at most 400 words;
  - requires `version: 9.0.1` in the skill.
- [X] T003 Run the new test, observe it fail, and save its output to specs/210-propose-edit-lines/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - Each edit has its own line (Priority: P1) 🎯 MVP

**Goal**: The edit handling is one line per kind of edit

**Independent Test**: No edit line exceeds 240 characters, and `propose` stays one step

- [X] T004 [US1] Replace the `edit` line in .highway/skills/highway-codify/SKILL.md with the lines in contracts/edit-lines.md. Change no other line in `propose`

---

## Phase 4: User Story 2 - An edit still does what it does today (Priority: P1)

**Goal**: Every current consequence remains

**Independent Test**: Each clause from the old line is still present, and the proposal block is unchanged

- [X] T005 [US2] Confirm with `git diff` that .highway/skills/highway-codify/SKILL.md changes only the `edit` line and `metadata.version`. Set the version to 9.0.1

---

## Phase 5: Polish

- [X] T006 Check `propose` is at most 400 words, then run `validate-skill.sh` on highway-codify
- [X] T007 [P] Move the `highway-codify` version pin from 9.0.0 to 9.0.1 in codify-file-layout.test.sh, codify-config-skill.test.sh, codify-platform-catalog.test.sh, codify-closing-guide.test.sh, and codify-write-refactor.test.sh. Leave the onboarding pin in codify-platform-catalog.test.sh (research R3)
- [X] T008 Regenerate with `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`
- [X] T009 Run the full suite in the background, copy `Summary:` and `EXIT:` into specs/210-propose-edit-lines/final.txt, and require 0 failed (D3.2)
- [X] T010 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 and T005 edit the same file, so T005 follows T004
- T007 follows T005, because the pins name the new version
- Phase 5 depends on both stories

## Parallel Example

```text
T007 version pins in five test files, alongside T006 validation
```

## Implementation Strategy

The MVP is US1: the edit line becomes one line per kind of edit. US2 confirms the clauses and the proposal block are unchanged. The suite runs once at the start and once at the end.
