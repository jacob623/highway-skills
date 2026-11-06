---

description: "Task list for grouping new realized capabilities by the automation"
---

# Tasks: Group Realized Capabilities

**Input**: Design documents from `/specs/220-group-realized-capabilities/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Pins and moved assertions are in research R3.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US4)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/220-group-realized-capabilities/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/group-realized-capabilities.test.sh (mode 644). It requires `current` steps 1 through 9 per contracts/current-steps.md in order, the Verification bullet, and version 3.2.3. It rejects the lines the contract lists, and the banned words in `current`. It fails when `current` exceeds 400 words. The PASS line is `PASS: current groups realized capabilities by the automation`
- [X] T003 Run the new test, observe it fail, and save its output to specs/220-group-realized-capabilities/probe-fail.txt (D3.6)

---

## Phase 3: User Stories 1, 2, and 4 - Group by the automation as ordered steps (Priority: P1) 🎯 MVP

**Goal**: One capability per automation, titled in five words or fewer, with the product and the handoff in the evidence, and different work kept separate

**Independent Test**: `current` steps 4 and 5 match the contract and stand after step 3

- [X] T004 [US1] [US2] [US4] In .highway/skills/highway-codify-config/SKILL.md, insert `current` steps 4 and 5 and renumber steps 7 through 9 per contracts/current-steps.md

---

## Phase 4: User Story 3 - Match existing capabilities by meaning (Priority: P2)

**Goal**: An automation the implementation already means is not proposed again

**Independent Test**: `current` step 6 matches the contract

- [X] T005 [US3] In .highway/skills/highway-codify-config/SKILL.md, write `current` step 6 per contracts/current-steps.md

---

## Phase 5: Polish

- [X] T006 Update the `current` Verification bullet per contracts/current-steps.md
- [X] T007 Set `metadata.version` to 3.2.3
- [X] T008 [P] Move the pins and assertions in research R3
- [X] T009 Run the word count and `validate-skill.sh` on the skill (D8.1)
- [X] T010 Regenerate with `generate-catalog.sh` and `generate-agent-adapters.sh`
- [X] T011 Run the full suite and copy `Summary:` and `EXIT:` into specs/220-group-realized-capabilities/final.txt. Require 0 failed (D3.2)
- [X] T012 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 through T007 edit the same file and run in order
- T008 edits tests only and follows T007
- Phase 5 depends on every story

## Parallel Example

```text
T008 test pins, beside T006 Verification, after T007
```

## Implementation Strategy

Grouping and titling are the MVP the request named. Matching by meaning keeps an update from repeating a capability. The suite runs once at the start and once at the end.
