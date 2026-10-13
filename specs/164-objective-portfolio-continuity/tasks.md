# Tasks: Objective Portfolio Continuity

**Input**: Design documents from `specs/164-objective-portfolio-continuity/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Static contract tests are required by the measurable outcomes and adapter-preservation requirements.

## Phase 1: Setup

**Purpose**: Confirm the current source/adapters and establish the focused continuity test target.

- [X] T001 Verify the Feature 164 source, adapter, generator, and test paths in `.highway/skills/highway-objectives/SKILL.md`, `.github/skills/highway-objectives/SKILL.md`, `.claude/skills/highway-objectives/SKILL.md`, `.cursor/skills/highway-objectives/SKILL.md`, `.agents/skills/highway-objectives/SKILL.md`, and `.highway/tools/tests/`
- [X] T002 [P] Create the Feature 164 contract-test scaffold in `.highway/tools/tests/feature-164-objective-portfolio-continuity.test.sh` with instrument and artifact-class declarations

## Phase 2: Foundational

**Purpose**: Define focused assertions before changing the source guidance.

- [X] T003 Complete post-capture ordering, coverage, optionality, advisory-boundary, example, protected-contract, and adapter-identity assertions in `.highway/tools/tests/feature-164-objective-portfolio-continuity.test.sh`
- [X] T004 Run `bash .highway/tools/tests/feature-164-objective-portfolio-continuity.test.sh` and confirm the pre-implementation test detects missing continuity guidance

**Checkpoint**: The focused test distinguishes the current source from the desired queued, collection, and setup continuity behavior.

## Phase 3: User Story 1 - Continue queued Objective development with portfolio context (Priority: P1) 🎯 MVP

**Goal**: Add an optional post-capture synthesis before the next queued Objective activity without redefining lifecycle mechanics.

**Independent Test**: The focused contract finds coverage synthesis, newest-Objective fit, next-Objective cue, and queued example wording after capture, while finding no required second review or proposal.

- [X] T005 [US1] Add concise post-capture synthesis guidance to `## Objective Portfolio Assessment Guidance` in `.highway/skills/highway-objectives/SKILL.md`, including coverage, newest-Objective fit, brevity, and no-full-restatement boundaries
- [X] T006 [US1] Add the queued transition example and next-Objective cue to `.highway/skills/highway-objectives/SKILL.md` without repeating Objective lifecycle mechanics
- [X] T007 [US1] Add queued transition ordering and advisory-boundary assertions to `.highway/tools/tests/feature-164-objective-portfolio-continuity.test.sh`

**Checkpoint**: Queued Objective transitions acknowledge accepted coverage before the next activity and remain advisory.

## Phase 4: User Story 2 - Preserve continuity during active collection (Priority: P1)

**Goal**: Add an optional coverage synthesis before the active-collection continuation question while preserving reassurance and finish behavior.

**Independent Test**: The focused contract finds the collection example, additional-suggestions reassurance, continuation question, post-capture ordering, and no recommendation-set boundary violation.

- [X] T008 [US2] Update the existing collection continuation guidance in `.highway/skills/highway-objectives/SKILL.md` to permit a concise accepted-coverage synthesis before the continuation question
- [X] T009 [US2] Add the collection transition example and finish/recommendation boundary assertions to `.highway/tools/tests/feature-164-objective-portfolio-continuity.test.sh`

**Checkpoint**: Active collection remains user-controlled and understandable without creating a separate portfolio discussion.

## Phase 5: User Story 3 - Make setup transition acknowledge the accepted portfolio (Priority: P2)

**Goal**: Add an optional accepted-coverage acknowledgment before safeguards or the next setup activity.

**Independent Test**: The focused contract finds the setup-transition example and verifies no new lifecycle state, durable artifact, or mandatory discussion requirement.

- [X] T010 [US3] Update setup-transition guidance in `.highway/skills/highway-objectives/SKILL.md` with the accepted-coverage synthesis and safeguards transition example
- [X] T011 [US3] Add setup-transition and no-new-state assertions to `.highway/tools/tests/feature-164-objective-portfolio-continuity.test.sh`

**Checkpoint**: Setup transitions acknowledge established coverage without changing setup orchestration.

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Regenerate distribution artifacts and validate all protected behavior.

- [X] T012 Regenerate all agent adapters from `.highway/skills/highway-objectives/SKILL.md` using `.highway/tools/generate-agent-adapters.sh`
- [X] T013 Run `bash .highway/tools/tests/feature-164-objective-portfolio-continuity.test.sh` and verify all continuity and adapter checks pass
- [X] T014 Run `bash .highway/tools/tests/feature-159-objectives-advisory.test.sh`, `bash .highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh`, and `bash .highway/tools/tests/objective-management.test.sh`
- [X] T015 Run `bash .highway/tools/tests/run-all.sh` and verify the full repository suite passes
- [X] T016 Run `git diff --check` and verify no generated Objective adapter differs from the source
- [X] T017 Mark all completed tasks `[X]` in `specs/164-objective-portfolio-continuity/tasks.md` after validation

## Dependencies & Execution Order

### Phase Dependencies

- Setup must complete before Foundational.
- Foundational must complete before source edits.
- User Story 1 establishes the shared synthesis guidance before collection and setup examples.
- User Story 2 depends on the shared post-capture and advisory boundaries from User Story 1.
- User Story 3 depends on the shared post-capture and no-new-state boundaries.
- Polish depends on all story edits.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational and is the MVP.
- **User Story 2 (P1)**: Depends on User Story 1's synthesis boundaries; same source file requires sequential editing.
- **User Story 3 (P2)**: Depends on User Story 1's synthesis boundaries and follows User Story 2 in the source file.

### Parallel Opportunities

- T001 and T002 can run in parallel.
- T007, T009, and T011 can be prepared as separate assertion additions after their corresponding source wording is settled, but source-file edits remain sequential.
- T013 and T014 can run in parallel after adapter regeneration; T015 follows both.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 and validate queued continuity independently.
3. Complete collection and setup transitions, then run full regression validation.

### Incremental Delivery

Each story adds one independently testable post-capture transition while preserving the existing Objective lifecycle and portfolio assessment. Adapter regeneration and the full suite provide the final cross-cutting gate.
