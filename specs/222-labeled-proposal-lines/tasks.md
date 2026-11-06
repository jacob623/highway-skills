---

description: "Task list for Recommendation and Evidence on their own bold line"
---

# Tasks: Labeled Proposal Lines

**Input**: Design documents from `/specs/222-labeled-proposal-lines/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Pins and the moved assertion are in research R2.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/222-labeled-proposal-lines/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/labeled-proposal-lines.test.sh (mode 644). It requires each shape in contracts/shapes.md as three consecutive lines inside its step: the conflict shape in `platform proposal` and `standard proposal`, the short conflict shape in `conflicts`, and the capability shape in `platform proposal`. It rejects the text the contract lists. It fails when `platform proposal` or `standard proposal` exceeds 400 words or `conflicts` exceeds 250. It requires version 3.2.5. The PASS line is `PASS: Recommendation and Evidence sit on their own bold line`
- [X] T003 Run the new test, observe it fail, and save its output to specs/222-labeled-proposal-lines/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - Recommendation on its own line (Priority: P1) 🎯 MVP

**Goal**: Each conflict shows a blank line, then an indented **Recommendation:** line, in both proposals and the `conflicts` list

**Independent Test**: The three conflict shapes in the new test pass

- [X] T004 [US1] In .highway/skills/highway-codify-config/SKILL.md, replace the conflict line in `platform proposal` and in `standard proposal` per contracts/shapes.md
- [X] T005 [US1] In .highway/skills/highway-codify-config/SKILL.md, replace the conflict line in `conflicts` per contracts/shapes.md

---

## Phase 4: User Story 2 - Evidence on its own line (Priority: P1)

**Goal**: Each new realized capability shows a blank line, then an indented **Evidence:** line

**Independent Test**: The capability shape in the new test passes

- [X] T006 [US2] In .highway/skills/highway-codify-config/SKILL.md, replace the capability line in `platform proposal` per contracts/shapes.md

---

## Phase 5: Polish

- [X] T007 Set `metadata.version` in .highway/skills/highway-codify-config/SKILL.md to 3.2.5
- [X] T008 [P] Move the pins and the assertion in research R2
- [X] T009 Run the word count and `validate-skill.sh` on highway-codify-config
- [X] T010 Regenerate with `generate-catalog.sh` and `generate-agent-adapters.sh`
- [X] T011 Run the full suite and copy `Summary:` and `EXIT:` into specs/222-labeled-proposal-lines/final.txt. Require 0 failed (D3.2)
- [X] T012 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 through T007 edit the same file and run in order
- T008 edits tests only and follows T007
- Phase 5 depends on both stories

## Parallel Example

```text
T008 test pins, after T007
```

## Implementation Strategy

The Recommendation lines are the MVP. The Evidence line follows in the same file. The suite runs once at the start and once at the end.
