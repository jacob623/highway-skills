---
description: "Task list for accepting every queued Control and NFR in one review"
---

# Tasks: Batch Control and NFR Review

**Input**: Design documents from `/specs/190-batch-control-nfr-review/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work. The plan amends the Controls heading check and adds one contract check because the behavior change must amend a test.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before the Controls and NFR conversations change

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/190-batch-control-nfr-review/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Name the conversation text this change removes

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Record the singular Control and NFR headings, both coverage bridges, and "Next we'll develop" from `specs/190-batch-control-nfr-review/contracts/batch-review.md` in `specs/190-batch-control-nfr-review/retirements.md`

**Checkpoint**: The retirement note names the per-item capture and the bridges

---

## Phase 3: User Story 1 - Review the whole queue at once (Priority: P1) 🎯 MVP

**Goal**: Asking to review a Control queue or an NFR queue shows every queued item in one message, in the shape in `specs/190-batch-control-nfr-review/contracts/batch-review.md`

**Independent Test**: `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-nfrs/SKILL.md` each show the plural captured heading, **[Title]:** [Statement], and **Why it matters:** [Rationale], with `---` only between items. Neither shows **Success looks like:**

### Implementation for User Story 1

- [X] T003 [P] [US1] In `.highway/skills/highway-controls/SKILL.md`, replace `capture` so it emits every queued Control in queue order using the Controls message in `specs/190-batch-control-nfr-review/contracts/batch-review.md`. Change every `review-now` path so it opens that whole-queue review instead of the first queued Control
- [X] T004 [P] [US1] In `.highway/skills/highway-nfrs/SKILL.md`, replace `capture` so it emits every queued NFR in queue order using the NFRs message in `specs/190-batch-control-nfr-review/contracts/batch-review.md`. Change every `review-now` path so it opens that whole-queue review instead of the first queued NFR. Keep a measurable bound only when accepted evidence supports it
- [X] T005 [US1] In `.highway/tools/tests/output-template.test.sh`, require **Here's what I've captured as your controls:** and **Why it matters:**. Stop requiring **Here's what I've captured as your Control:** and a separate `Statement:` label. Name that superseded heading in `specs/190-batch-control-nfr-review/retirements.md`

**Checkpoint**: A queue of three Controls, and a queue of three NFRs, is each one review with two separators and one question

---

## Phase 4: User Story 2 - Accept once, then store the set (Priority: P2)

**Goal**: One acceptance stores every remaining Control, or every remaining NFR. The stored statement and rationale are the review text. The person is not shown the stored records

**Independent Test**: Acceptance in each skill holds the whole remaining set and goes to `write`. The bridge is absent. `write` copies the review text into the current statement and rationale sections and emits nothing else

### Implementation for User Story 2

- [X] T006 [P] [US2] In `.highway/skills/highway-controls/SKILL.md`, accept the whole remaining set and go to `identifier`, then `write`. Redraw the whole set for an edit, an added Control, or a removal. Drop the whole set on decline. Redraw the same set for a question or an unclear reply. Delete the bridge. When no Control remains, do not show an empty review. Store the statement shown with the title and the rationale line. On a successful write, emit no stored record and no closing line. Update the Verification bullets that describe capture and write
- [X] T007 [P] [US2] In `.highway/skills/highway-nfrs/SKILL.md`, accept the whole remaining set and go to `identifier`, then `write`. Redraw the whole set for an edit, an added NFR, or a removal. Drop the whole set on decline. Redraw the same set for a question or an unclear reply. Delete the bridge. When no NFR remains, do not show an empty review. Store the statement shown with the title and the rationale line. On a successful write, emit no stored record and no closing line. Update the Verification bullets that describe capture and write

**Checkpoint**: One acceptance stores the set, and the written fields match the review

---

## Phase 5: User Story 3 - Reopen stored records in the same shape (Priority: P3)

**Goal**: Opening stored active Controls, or stored active NFRs, shows the same card as the queue review

**Independent Test**: The stored-record `review` in each skill uses **[Title]:** [Statement], **Why it matters:** [Rationale], and `---` only between active records, then one correction question

### Implementation for User Story 3

- [X] T008 [P] [US3] In `.highway/skills/highway-controls/SKILL.md`, change the stored-record `review` to the Controls card in `specs/190-batch-control-nfr-review/contracts/batch-review.md`. Keep removed rows omitted and keep the current empty message
- [X] T009 [P] [US3] In `.highway/skills/highway-nfrs/SKILL.md`, change the stored-record `review` to the NFRs card in `specs/190-batch-control-nfr-review/contracts/batch-review.md`. Keep removed rows omitted and keep the current empty message

**Checkpoint**: Two stored active Controls, and two stored active NFRs, each appear as one review with one separator

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Publish the edited skills and prove the suite is green

- [X] T010 Add `.highway/tools/tests/control-nfr-batch-acceptance.test.sh` with instrument-class and artifact-class comments. Require the plural headings, **[Title]:** [Statement], **Why it matters:**, and the between-item separator in both `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-nfrs/SKILL.md`. Fail if either skill still has its singular capture heading, "Next we'll develop", or **Success looks like:**
- [X] T011 Bump the version in `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-nfrs/SKILL.md` from `5.1.0` to `6.0.0`
- [X] T012 Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-controls` and `.highway/skills/highway-nfrs`. Repair only reported authoring-rule failures
- [X] T013 Run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` so the catalog and published copies match the edited sources
- [X] T014 Run `.highway/tools/tests/run-all.sh` and require exit 0
- [X] T015 Execute the checks in `specs/190-batch-control-nfr-review/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Story 1 (Phase 3)**: Depends on Foundational
- **User Story 2 (Phase 4)**: Depends on User Story 1 because both edit the same skill files
- **User Story 3 (Phase 5)**: Depends on User Story 2 because both edit the same skill files
- **Polish (Phase 6)**: Depends on User Stories 1, 2, and 3

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. MVP is the single queue review in both skills. T005 waits until T003 has changed the Controls heading
- **User Story 2 (P2)**: Starts after User Story 1. Controls and NFRs can be edited together
- **User Story 3 (P3)**: Starts after User Story 2. Controls and NFRs can be edited together

### Within Each User Story

- T003 and T004 edit different skills and can run together
- T006 and T007 edit different skills and can run together
- T008 and T009 edit different skills and can run together
- T010 waits until both stored reviews and both queue reviews are written
- Version bumps before validation, regeneration, and the suite

### Parallel Opportunities

- T003 with T004
- T006 with T007
- T008 with T009
- A Controls task and its NFR pair never share a file

---

## Parallel Example: User Story 1

```text
Task: "Replace capture and review-now in .highway/skills/highway-controls/SKILL.md"
Task: "Replace capture and review-now in .highway/skills/highway-nfrs/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm each queue appears as one review

### Incremental Delivery

1. Setup and Foundational name the removed capture
2. User Story 1 delivers the single review for both queues
3. User Story 2 delivers the single acceptance and the matching stored text
4. User Story 3 delivers the same card for records already stored
5. Polish publishes both skills and requires a green suite

### Parallel Story Strategy

One person can edit Controls while another edits NFRs inside the same story. The next story waits until both skill files from the current story are finished. Objectives and the record templates stay untouched.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- The record templates are cited and not edited
- Recommendation and queue building stay as they are, except the handoff into review
- Commit after each task or logical group
- Stop at any checkpoint to validate that story on its own
