---

description: "Task list for delivery platform handoff"
---

# Tasks: Delivery Platform Handoff

**Input**: Design documents from `/specs/227-delivery-platform-handoff/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Moved pins are in research R5.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/227-delivery-platform-handoff/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/delivery-platform-handoff.test.sh (mode 644). It requires every new line in contracts/wording.md in its skill, rejects `[Field] is needed. Name it on the implementation.`, checks `### delivery platforms` is 250 words or fewer with no banned word, and requires versions 12.3.0, 7.6.0, and 10.5.0. The PASS line is `PASS: an empty delivery platform hands off to highway-implementation and back`
- [X] T003 Run the new test, observe it fail, and save its output to specs/227-delivery-platform-handoff/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - An empty delivery platform stops the proposal (Priority: P1) 🎯 MVP

**Goal**: `provider` shows the person's message and no proposal, and onboarding stores empty platforms

**Independent Test**: The message and onboarding lines in the new test pass

- [X] T004 [US1] In .highway/skills/highway-codify/SKILL.md, replace `provider` step 2 with the new steps 2 and 3 and the message per contracts/wording.md, and renumber the remaining steps
- [X] T005 [P] [US1] In .highway/skills/highway-onboarding/SKILL.md, add the Execution sentence to the implementation paragraph and the `provider` return rule per contracts/wording.md

---

## Phase 4: User Story 2 - Setting the platforms updates the implementation (Priority: P1)

**Goal**: A yes hands off to `delivery platforms`, which writes the Execution lines and hands back

**Independent Test**: The hand-off lines and the `delivery platforms` step in the new test pass

- [X] T006 [US2] In .highway/skills/highway-codify/SKILL.md, add the yes reply to `provider` per contracts/wording.md
- [X] T007 [P] [US2] In .highway/skills/highway-implementation/SKILL.md, add Entry step 2, the `### delivery platforms` section after `### add capabilities`, and the Purpose, When to use, Outputs, Procedure, and Verification lines per contracts/wording.md

---

## Phase 5: User Story 3 - A named platform lasts for one run (Priority: P1)

**Goal**: A named platform or coding standard is held for this run and never written

**Independent Test**: The this-run reply lines in the new test pass

- [X] T008 [US3] In .highway/skills/highway-codify/SKILL.md, add the remaining `provider` replies and the held-value lines, and the Verification lines per contracts/wording.md

---

## Phase 6: Polish

- [X] T009 Set versions to 12.3.0, 7.6.0, and 10.5.0 in the three SKILL.md files
- [X] T010 Move the pins listed in specs/227-delivery-platform-handoff/research.md R5
- [X] T011 Run `validate-skill.sh` on the three skills and the quickstart checks
- [X] T012 Regenerate with `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`
- [X] T013 Run the full suite and copy `Summary:` and `EXIT:` into specs/227-delivery-platform-handoff/final.txt. Require 0 failed (D3.2)
- [X] T014 Confirm no shipped file of this change references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004, T006, and T008 edit highway-codify and run in order. T005 and T007 edit other files and can run beside them
- T009 through T014 follow every story

## Parallel Example

```text
T004 codify provider, T005 onboarding, T007 implementation
```

## Implementation Strategy

MVP is User Story 1: the stop says why Codify cannot propose. User Stories 2 and 3 add the two ways forward and land in the same suite run.
