---
description: "Task list for Highway Setup UX Simplification and Welcome Flow"
---

# Tasks: Highway Setup UX Simplification and Welcome Flow

**Input**: Design documents from `/specs/085-highway-setup-ux-simplification/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/setup-output.md`, `quickstart.md`

**Organization**: Tasks are grouped by user story. All three stories are P1 and together form the feature MVP.

## Phase 1: Setup

**Purpose**: Confirm the existing source and focused test surfaces before implementation.

- [X] T001 Record the existing `highway-setup` skill version, output sections, and focused test entry points in `specs/085-highway-setup-ux-simplification/research.md`.
- [X] T002 [P] Run `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh` before implementation, recording the baseline result in the implementation notes.

## Phase 2: Foundational

**Purpose**: Establish the shared presentation and outcome rules that all user stories depend on.

- [X] T003 Add the Feature 085 ordered conversational output contract to `.highway/skills/highway-setup/SKILL.md`, preserving owner-provided question wording and the existing completion dashboard.
- [X] T004 [P] Add static assertions for welcome ordering, suppressed narration, outcome visibility, resume behavior, and prohibited phrases in `.highway/tools/tests/highway-setup.test.sh`.
- [X] T005 [P] Add executable fixture coverage for input-required, resume, blocked, declined, aborted, explicit-status, and completion output behavior in `.highway/tools/tests/highway-setup-executable.test.sh`.

## Phase 3: User Story 1 - Start Setup With a Human Welcome (Priority: P1) MVP

**Goal**: Make input-required setup begin with a welcome or resume greeting, owner introduction, and one unresolved owner question.

**Independent Test**: Run the focused setup tests and verify that Profile input and resumed input use the required order and wait for one response without internal routing narration.

### Tests for User Story 1

- [X] T006 [P] [US1] Add a failing static contract assertion for the welcome, owner introduction, and owner question order in `.highway/tools/tests/highway-setup.test.sh`.
- [X] T007 [P] [US1] Add a failing executable fixture for new and resumed input-required collection in `.highway/tools/tests/highway-setup-executable.test.sh`.

### Implementation for User Story 1

- [X] T008 [US1] Update the opening and resume sections of `.highway/skills/highway-setup/SKILL.md` to define the welcome/resume greeting, active owner introduction, one unresolved question, and wait-for-response sequence.
- [X] T009 [US1] Preserve the canonical Profile organization question and owner-supplied wording while removing progress prerequisites from the opening in `.highway/skills/highway-setup/SKILL.md`.

**Checkpoint**: User Story 1 is independently testable with the two focused setup tests.

## Phase 4: User Story 2 - Collect Information Without Workflow-Engine Noise (Priority: P1)

**Goal**: Keep ordinary collection focused on the active owner and question while retaining actionable outcome and explicit-status information.

**Independent Test**: Exercise active collection, blocked, declined, aborted, and explicit-status fixtures and verify routine progress and orchestration narration are absent while actionable context remains available.

### Tests for User Story 2

- [X] T010 [P] [US2] Add failing static assertions for active-collection suppression and blocked/declined/aborted/status diagnostic allowances in `.highway/tools/tests/highway-setup.test.sh`.
- [X] T011 [P] [US2] Add failing executable assertions for dashboard visibility and prohibited collection narration in `.highway/tools/tests/highway-setup-executable.test.sh`.

### Implementation for User Story 2

- [X] T012 [US2] Replace routine Guided Setup progress output with the ordered conversational collection contract in `.highway/skills/highway-setup/SKILL.md`.
- [X] T013 [US2] Define dashboard visibility for complete, blocked, declined, aborted, and explicit-status responses while retaining `Owner Workflow`, `Blocking Reason`, and `Next Action` diagnostics in `.highway/skills/highway-setup/SKILL.md`.
- [X] T014 [US2] Add the five explicit prohibited narration phrases and their normal-collection verification rule to `.highway/skills/highway-setup/SKILL.md`.

**Checkpoint**: User Story 2 is independently testable without changing owner routing or the completion dashboard.

## Phase 5: User Story 3 - Preserve Owner Workflow Semantics While Simplifying Output (Priority: P1)

**Goal**: Confirm that presentation changes do not alter ownership, readiness order, terminality, safe stops, or artifact non-mutation.

**Independent Test**: Run the full focused setup and repository test suite, then inspect the owner-routing and completion fixtures for unchanged semantics.

### Tests for User Story 3

- [X] T015 [P] [US3] Add failing assertions for preserved Profile, Objectives, Controls, and NFR ordering and terminality in `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T016 [P] [US3] Add failing static assertions for unchanged completion dashboard, owner authority, no persistence, and Experience Standard alignment in `.highway/tools/tests/highway-setup.test.sh`.

### Implementation for User Story 3

- [X] T017 [US3] Retain the existing readiness order, terminality tables, User Exit and Owner Outcome classifications, safe-stop behavior, and no-write boundaries while revising `.highway/skills/highway-setup/SKILL.md`.
- [X] T018 [US3] Increment `metadata.version` in `.highway/skills/highway-setup/SKILL.md` from `2.0.0` to `3.0.0` for the output-contract breaking change.

**Checkpoint**: All three P1 stories pass independently and together.

## Phase 6: Polish and Cross-Cutting Validation

- [X] T019 [P] Update `specs/085-highway-setup-ux-simplification/quickstart.md` if any validation command or expected output changes during implementation.
- [X] T020 Run `.highway/tools/tests/run-all.sh` and resolve only Feature 085 regressions.
- [X] T021 Run `git diff --check` and verify the final requirement-to-test coverage against FR-001 through FR-020 and SC-001 through SC-008.

## Dependencies and Execution Order

### Phase Dependencies

- Phase 1 precedes all implementation work.
- Phase 2 establishes the shared skill and test contract before story work.
- User Stories 1, 2, and 3 depend on Phase 2 and may be implemented sequentially in priority order.
- Phase 6 depends on all three user-story checkpoints.

### User Story Dependencies

- **US1**: Depends on Phase 2; MVP starting point.
- **US2**: Depends on Phase 2; can be implemented after or alongside US1 because it changes adjacent output sections and tests.
- **US3**: Depends on Phase 2; final semantic-preservation pass covers the shared routing behavior.

### Parallel Opportunities

- T004 and T005 can proceed in parallel after the baseline.
- T006 and T007 can proceed in parallel as test-first probes.
- T010 and T011 can proceed in parallel as test-first probes.
- T015 and T016 can proceed in parallel as test-first probes.
- T019 and T021 can proceed in parallel after implementation; T020 follows their local checks.

## Implementation Strategy

1. Establish the baseline and shared contract.
2. Deliver US1 as the MVP and validate the opening sequence.
3. Add US2 visibility suppression and outcome diagnostics.
4. Complete US3 semantic-preservation checks and version the skill.
5. Run the focused tests, full suite, diff check, and quickstart validation.

## Notes

- Every task includes a concrete repository path.
- No new runtime dependency, persistence mechanism, owner artifact, or alternate setup authority is planned.
- Test changes must preserve existing assertions unless a superseded progress contract is explicitly replaced by Feature 085 behavior.
