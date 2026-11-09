---

description: "Task list for delivery platform proposal"
---

# Tasks: Delivery Platform Proposal

**Input**: Design documents from `/specs/228-delivery-platform-proposal/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Moved pins are in research R4.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/228-delivery-platform-proposal/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/delivery-platform-proposal.test.sh (mode 644). It requires every new line in contracts/wording.md in its section of .highway/skills/highway-implementation/SKILL.md, rejects ``5. Return to `start`.`` in `### execution`, checks `### execution` and `### delivery platforms` are each 250 words or fewer with no banned word, and requires `version: 7.7.0`. The PASS line is `PASS: delivery platforms proposes each unset field from execution`
- [X] T003 Run the new test, observe it fail, and save its output to specs/228-delivery-platform-proposal/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - Setting the platforms starts from a proposal (Priority: P1) 🎯 MVP

**Goal**: The delivery platforms view shows the `execution` value for each unset field

**Independent Test**: `bash .highway/tools/tests/delivery-platform-proposal.test.sh` passes

- [X] T004 [US1] In `### execution` of .highway/skills/highway-implementation/SKILL.md, add "This implementation's row is not a candidate." and replace step 5 with "5. Return to the step that named this one."
- [X] T005 [US1] In `### delivery platforms` of .highway/skills/highway-implementation/SKILL.md, add the new step 3, renumber Emit to step 4, and change the `accept` sentence per contracts/wording.md
- [X] T006 [US1] Add the Verification bullet and set `version: 7.7.0` in .highway/skills/highway-implementation/SKILL.md

---

## Phase 4: Polish & Cross-Cutting Concerns

- [X] T007 Move the pins in research R4 across .highway/tools/tests/*.test.sh (D3.5)
- [X] T008 Run the quickstart tests and `bash .highway/tools/validate-skill.sh .highway/skills/highway-implementation`
- [X] T009 Regenerate with `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh` (D4.5 through D4.7)
- [X] T010 Run `bash .highway/tools/tests/run-all.sh` into specs/228-delivery-platform-proposal/final.txt. Require 0 failed (D3.2)
- [X] T011 Confirm no shipped file under .highway/ references `.specify/` or `specs/` (D1.1)

---

## Dependencies & Execution Order

- T001 → T002 → T003 → T004 → T005 → T006 → T007 → T008 → T009 → T010 → T011.
- T004 through T006 edit one file and run in order.

## Parallel Example

- None. Every edit after T003 touches .highway/skills/highway-implementation/SKILL.md or depends on it.

## Implementation Strategy

- MVP is User Story 1, the only story. Finish T001 through T006, then polish.
