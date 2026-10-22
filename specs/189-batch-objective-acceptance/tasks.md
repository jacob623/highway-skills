---
description: "Task list for accepting every queued objective in one review"
---

# Tasks: Batch Objective Acceptance

**Input**: Design documents from `/specs/189-batch-objective-acceptance/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work. The plan adds one contract check because the behavior change must amend a test. No current test asserts the one-at-a-time capture.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before the objectives conversation changes

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/189-batch-objective-acceptance/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Name the conversation text this change removes

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Record the removed one-at-a-time heading, the coverage bridge, and "Next we'll develop" from `specs/189-batch-objective-acceptance/contracts/batch-review.md` in `specs/189-batch-objective-acceptance/retirements.md`

**Checkpoint**: The retirement note names the per-objective capture and the bridge

---

## Phase 3: User Story 1 - Review the whole queue at once (Priority: P1) 🎯 MVP

**Goal**: Asking to review the queue shows every queued objective in one message, in the shape in `specs/189-batch-objective-acceptance/contracts/batch-review.md`

**Independent Test**: `.highway/skills/highway-objectives/SKILL.md` shows the plural captured-objectives heading, **Success looks like:** on its own line, **Why it matters:**, and a horizontal rule only between objectives. It does not send the queue to the first objective alone

### Implementation for User Story 1

- [X] T003 [US1] In `.highway/skills/highway-objectives/SKILL.md`, replace `capture` so it emits every queued objective in queue order: bold title and one sentence, **Success looks like:** with at least one measure, a blank line, then **Why it matters:** and one rationale line. Put `---` only between objectives. Open with **Here's what I've captured as your objectives:** and close with one **What would you add, correct, or remove?** plus the accuracy reassurance
- [X] T004 [US1] In `.highway/skills/highway-objectives/SKILL.md`, change every `review-now` path in `recommend`, `more`, and `queue` so it opens that whole-queue review instead of the first queued objective

**Checkpoint**: A queue of three objectives is one review with two separators and one question

---

## Phase 4: User Story 2 - Accept once, then store the set (Priority: P2)

**Goal**: One acceptance stores every remaining objective. The stored statement, success measures, and rationale are the review text. The person is not shown the stored records

**Independent Test**: Acceptance in `.highway/skills/highway-objectives/SKILL.md` holds the whole remaining set and goes to `write`. The bridge is absent. `write` copies the review text into the current record sections and emits nothing else

### Implementation for User Story 2

- [X] T005 [US2] In `.highway/skills/highway-objectives/SKILL.md`, accept the whole remaining set and go to `identifier` then `write`. Redraw the whole set for an edit, an added outcome, or a removal. Drop the whole set on decline. Redraw the same set for a question or an unclear reply. Delete the bridge. When no objective remains, do not show an empty review
- [X] T006 [US2] In `.highway/skills/highway-objectives/SKILL.md`, store the one sentence as the statement, the shown measures as the success measures, and the rationale line as the rationale. Leave `.highway/library/templates/output/objective-record.md` and the existing-catalog `review` section unchanged. On a successful write, emit no stored record and no closing line. Update the Verification bullets that describe capture and write
- [X] T007 [US2] Add `.highway/tools/tests/objective-batch-acceptance.test.sh` with instrument-class and artifact-class comments. Require the plural heading, **Success looks like:**, **Why it matters:**, and the between-objectives separator. Fail if the singular capture heading or "Next we'll develop" remains in `.highway/skills/highway-objectives/SKILL.md`

**Checkpoint**: One acceptance stores the set, and the written fields match the review

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Publish the edited skill and prove the suite is green

- [X] T008 Bump the version in `.highway/skills/highway-objectives/SKILL.md` from `5.1.0` to `6.0.0`
- [X] T009 Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-objectives`. Repair only reported authoring-rule failures
- [X] T010 Run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` so the catalog and published copies match the edited source
- [X] T011 Run `.highway/tools/tests/run-all.sh` and require exit 0
- [X] T012 Execute the checks in `specs/189-batch-objective-acceptance/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Story 1 (Phase 3)**: Depends on Foundational
- **User Story 2 (Phase 4)**: Depends on User Story 1 because both edit `.highway/skills/highway-objectives/SKILL.md`
- **Polish (Phase 5)**: Depends on User Stories 1 and 2

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. MVP is the single queue review
- **User Story 2 (P2)**: Starts after User Story 1. T007 can be written after T005 and T006 because it checks the finished skill text

### Within Each User Story

- T003 before T004, both in the same skill file
- T005 before T006, both in the same skill file
- T007 after the skill text it checks
- Version bump before validation, regeneration, and the suite

### Parallel Opportunities

- No task is marked [P]. User Story 1 and User Story 2 edit the same skill file
- T007 uses a different file, and it still waits until the skill text is finished

---

## Parallel Example: User Story 1

```text
No parallel tasks. T003 and T004 both edit .highway/skills/highway-objectives/SKILL.md.
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm a queue appears as one review

### Incremental Delivery

1. Setup and Foundational name the removed capture
2. User Story 1 delivers the single review
3. User Story 2 delivers the single acceptance and the matching stored text
4. Polish publishes the skill and requires a green suite

### Sequential Story Strategy

One person edits the objectives skill from the review outward to the write. The stored-objective review and the record template stay untouched.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- The record template is cited and not edited
- Recommendation and queue building stay as they are, except the handoff into review
- Commit after each task or logical group
- Stop at any checkpoint to validate that story on its own
