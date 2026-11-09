---

description: "Task list for codify plan review question"
---

# Tasks: Codify Plan Review Question

**Input**: Design documents from `/specs/231-codify-plan-review-question/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new test is written and observed failing before any source edit. Moved pins are in research R4.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/231-codify-plan-review-question/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/codify-plan-review.test.sh (mode 644) with the Instrument class, Artifact classes, and Seeded failure probe header lines. It requires, per contracts/wording.md: the order line `` `check`, `menu`, `review` when chosen, `tasks`, ``; the Classify line for `review`; `### review` after `### menu` and before `### tasks`; in `review`, the walkthrough sentence, `**What would you add, correct, or remove?**`, `If this is accurate, just say so.`, `Do not emit the menu with this question.`, and the five reply lines, with the question after the walkthrough sentence and before the reply lines; in `menu`, `` - `1`: go to `review`. ``, the unchanged emitted menu, stated-edit line, and `` `2`: go to `tasks`. ``; no review question in `menu` or `tasks`; the Verification bullet; and `version: 14.1.0`. It rejects `Answer, then emit this menu.` The PASS line is `PASS: a plan review asks what to add, correct, or remove before the menu`
- [X] T003 Run the new test, observe it fail, and save its output to specs/231-codify-plan-review-question/probe-fail.txt (D3.6)

**Checkpoint**: The test fails against the current skill.

---

## Phase 3: User Story 1 - A plan review ends by inviting changes (Priority: P1) 🎯 MVP

**Goal**: Choosing Review the plan walks the plan, then asks the review question before the menu.

**Independent Test**: `codify-plan-review.test.sh` passes its `review`, Classify, and order-line pins.

- [X] T004 [US1] In .highway/skills/highway-codify/SKILL.md, change the Procedure order line and add the Classify line for `review`, per contracts/wording.md
- [X] T005 [US1] In .highway/skills/highway-codify/SKILL.md, replace the menu's `1` line with `` - `1`: go to `review`. `` and add the `### review` step between `### menu` and `### tasks`, per contracts/wording.md

**Checkpoint**: The review question appears after the walkthrough and before the menu.

---

## Phase 4: User Story 2 - Continuing to code without reviewing is unchanged (Priority: P2)

**Goal**: The menu's wording, its stated-edit path, `2`, and resume at the menu stay as they are.

**Independent Test**: `codify-feature-wording.test.sh` and the menu pins in `codify-plan-review.test.sh` pass, and `tasks` holds no review question.

- [X] T006 [US2] In .highway/skills/highway-codify/SKILL.md, add the Verification bullet after the menu bullet and set `version: 14.1.0`, per contracts/wording.md

**Checkpoint**: The new test passes.

---

## Phase 5: Polish & Cross-Cutting Concerns

- [X] T007 Move the `version: 14.0.0` pins named in research R4 to `version: 14.1.0` across .highway/tools/tests/*.test.sh (D3.5)
- [X] T008 Run `bash .highway/tools/validate-skill.sh .highway/skills/highway-codify`
- [X] T009 Regenerate with `generate-catalog.sh` and `generate-agent-adapters.sh` (D4.5, D4.6)
- [X] T010 Run `bash .highway/tools/tests/run-all.sh` into specs/231-codify-plan-review-question/final.txt. Require 0 failed (D3.2)
- [X] T011 Confirm .highway/skills/highway-codify/SKILL.md references no `.specify/` or `specs/` (D1.1)

---

## Dependencies & Execution Order

- Setup (T001) before the failing test (T002, T003).
- T003 before any source edit.
- US1 (T004, T005) before US2 (T006): all edit the same file.
- Polish after both stories. T007 before T010. T009 before T010.

## Parallel Opportunities

- T007 edits only test files and can run alongside T004 through T006.
- T008 and T011 can run together.

## Implementation Strategy

US1 is the MVP: once T005 lands, a review ends with the question. US2 pins that nothing else moved. One full suite run closes the feature.
