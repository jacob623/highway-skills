---

description: "Implementation tasks for Recommendation Exploration Simplification Pass"
---

# Tasks: Recommendation Exploration Simplification Pass

**Input**: Design documents from `/specs/174-recommendation-exploration-simplification/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Focused contract tests are included because the specification requires measurable contract validation and preservation of existing behavior.

**Organization**: Tasks are grouped by user story. The three owner source files can be implemented independently after the shared failing contract test is in place.

## Phase 1: Setup

**Purpose**: Establish the focused validation surface without changing shipped behavior.

- [X] T001 Add the Feature 174 contract test harness in `.highway/tools/tests/feature-174-recommendation-exploration-simplification.test.sh` with assertions for all three owner sources, generated-surface wording, Creation Workflow ownership, and prohibited user-facing queue commands.
- [X] T002 Run the new Feature 174 contract test before implementation and record its expected failures in `specs/174-recommendation-exploration-simplification/quickstart.md` or the implementation notes.

---

## Phase 2: Foundational

**Purpose**: Confirm the source-first edit boundary and preserve existing validation assumptions before owner-specific edits.

- [X] T003 [P] [US1] Review the Objective contract and map FR-001, FR-002, FR-006, FR-007, FR-009, FR-011, and FR-015 to `.highway/skills/highway-objectives/SKILL.md` and its focused tests.
- [X] T004 [P] [US2] Review the Control contract and map FR-001, FR-003, FR-006, FR-007, FR-009, FR-011, and FR-015 to `.highway/skills/highway-controls/SKILL.md` and its focused tests.
- [X] T005 [P] [US3] Review the NFR contract and map FR-001, FR-004, FR-006, FR-007, FR-009, FR-011, and FR-015 to `.highway/skills/highway-nfrs/SKILL.md` and its focused tests.

**Checkpoint**: The focused contract test exists and fails for the pre-change wording; all owner-specific edit surfaces are identified.

---

## Phase 3: User Story 1 - Explore Objective Recommendations Without Competing Paths (Priority: P1) 🎯 MVP

**Goal**: Make Objective Recommendation Presentation, Recommendation Exploration, Objective Development Lifecycle, and Objective Queue and Acceptance Boundaries the primary behavioral owners while Creation Workflow becomes orchestration-only.

**Independent Test**: Run `.highway/tools/tests/feature-174-recommendation-exploration-simplification.test.sh` and the existing Objective advisory/lifecycle tests; confirm review-of-selected-Objectives language, continued exploration, no direct capture, and no duplicated Creation Workflow rules.

### Implementation for User Story 1

- [X] T006 [US1] Replace the Objective Recommendation Exploration and queue-processing user-facing examples with the selected-Objective review boundary in `.highway/skills/highway-objectives/SKILL.md`, preserving internal queue mechanics and Working Idea semantics.
- [X] T007 [US1] Reduce the Objective Creation Workflow to orchestration-only routing in `.highway/skills/highway-objectives/SKILL.md`, retaining the canonical no-recommendation question, lifecycle handoff, continuation, and explicit-finish behavior without duplicated owner rules.
- [X] T008 [US1] Update Objective-focused contract assertions in `.highway/tools/tests/feature-159-objectives-advisory.test.sh` and `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` only where their expected wording reflects the superseded queue-processing path.

**Checkpoint**: Objective setup follows one review-oriented exploration path and the MVP contract tests pass for Objectives.

---

## Phase 4: User Story 2 - Explore Control Recommendations Without Competing Paths (Priority: P1)

**Goal**: Align Control recommendation exploration and Creation Workflow ownership with the Objective contract while preserving Control-specific proposal, acceptance, persistence, and capture behavior.

**Independent Test**: Run the Feature 174 contract test and `.highway/tools/tests/highway-controls-onboarding.test.sh`; confirm selected Controls are reviewed only after exhaustion or explicit review intent and are never captured directly from selection.

### Implementation for User Story 2

- [X] T009 [US2] Replace the Control Recommendation Exploration and queue-processing user-facing examples with the selected-Control review boundary in `.highway/skills/highway-controls/SKILL.md`, preserving internal queue mechanics and Control Queue and Acceptance Boundaries.
- [X] T010 [US2] Reduce the Control Creation Workflow to orchestration-only routing in `.highway/skills/highway-controls/SKILL.md`, retaining the canonical no-recommendation question, Control Development Lifecycle handoff, continuation, and explicit-finish behavior.
- [X] T011 [US2] Update Control-focused contract assertions in `.highway/tools/tests/highway-controls-onboarding.test.sh` only where expected wording reflects the superseded queue-processing path, without weakening acceptance or capture assertions.

**Checkpoint**: Control setup follows the shared review-oriented exploration path and preserves Control ownership and acceptance boundaries.

---

## Phase 5: User Story 3 - Explore NFR Recommendations Without Competing Paths (Priority: P1)

**Goal**: Make the NFR contract the aligned reference implementation for review-oriented recommendation exploration and thin Creation Workflow orchestration.

**Independent Test**: Run the Feature 174 contract test and `.highway/tools/tests/highway-nfr-onboarding.test.sh`; confirm selected NFRs remain Working Ideas until review and proceed through the unchanged NFR lifecycle afterward.

### Implementation for User Story 3

- [X] T012 [US3] Align NFR Recommendation Exploration, Queue and Acceptance Boundaries, and user-facing examples with the selected-NFR review boundary in `.highway/skills/highway-nfrs/SKILL.md` while retaining internal queue concepts.
- [X] T013 [US3] Reduce the NFR Creation Workflow to orchestration-only routing in `.highway/skills/highway-nfrs/SKILL.md`, retaining the canonical no-recommendation path and existing lifecycle continuation behavior.
- [X] T014 [US3] Update NFR-focused contract assertions in `.highway/tools/tests/highway-nfr-onboarding.test.sh` only where expected wording reflects the superseded queue-processing path, without weakening NFR lifecycle or persistence assertions.

**Checkpoint**: All three owner contracts now use the same review-oriented exploration boundary.

---

## Phase 6: User Story 4 - Preserve Existing Ownership and Lifecycle Boundaries (Priority: P2)

**Goal**: Prove the simplification changes orchestration and user-facing language without changing domain ownership, lifecycle, persistence, or explicit-finish behavior.

**Independent Test**: Run the full repository suite and inspect the focused contract assertions for direct user-authored artifacts, no-recommendation paths, selection-before-review, correction, acceptance, capture, continuation, and explicit finish.

### Implementation for User Story 4

- [X] T015 [US4] Extend `.highway/tools/tests/feature-174-recommendation-exploration-simplification.test.sh` with edge-case assertions for no useful recommendation, explicit early review, repeated additional suggestions, user-authored artifacts, and selection without capture.
- [X] T016 [US4] Review `.highway/tools/tests/feature-174-recommendation-exploration-simplification.test.sh`, existing Objective/Control/NFR tests, and the three contract documents under `specs/174-recommendation-exploration-simplification/contracts/` to confirm each requirement remains mapped without weakening prior assertions.

**Checkpoint**: The changed contracts preserve existing ownership and lifecycle semantics across all three owners.

---

## Phase 7: Polish & Cross-Cutting Validation

**Purpose**: Regenerate every derived surface and complete repository-wide validation.

- [X] T017 Run `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-instructions.sh` after authoritative source edits; verify generated adapters and catalogs are synchronized.
- [X] T018 Run `.highway/tools/tests/adapter-coverage.test.sh` and all focused owner tests, recording separate requirement coverage and check results in the implementation report.
- [X] T019 Run `.highway/tools/tests/run-all.sh` and `git diff --check`, then resolve any Feature 174 regressions without changing unrelated behavior.
- [X] T020 Mark all completed tasks `[X]` in `specs/174-recommendation-exploration-simplification/tasks.md` and verify the final implementation against `spec.md`, `plan.md`, and `quickstart.md`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; create and run the focused contract test before source edits.
- **Foundational (Phase 2)**: Depends on Setup; maps each owner surface and confirms the expected failing baseline.
- **User Story 1 (Phase 3)**: Depends on Foundational; MVP can be validated independently for Objectives.
- **User Story 2 (Phase 4)**: Depends on Foundational; can run in parallel with US1 after T001-T005, but shared test updates should be coordinated.
- **User Story 3 (Phase 5)**: Depends on Foundational; can run in parallel with US1 and US2 after T001-T005.
- **User Story 4 (Phase 6)**: Depends on US1, US2, and US3 because it validates the aligned cross-owner result.
- **Polish (Phase 7)**: Depends on all user stories.

### User Story Dependencies

- **US1 (P1)**: No dependency on other stories after foundational mapping; MVP scope.
- **US2 (P1)**: No dependency on other stories after foundational mapping; shares only the common contract behavior.
- **US3 (P1)**: No dependency on other stories after foundational mapping; establishes the reference terminology alignment.
- **US4 (P2)**: Depends on all three owner changes to validate cross-owner preservation.

### Parallel Opportunities

- T003, T004, and T005 can run in parallel because they inspect different owner files.
- T006/T007, T009/T010, and T012/T013 can be developed in parallel across their distinct authoritative skill files, subject to test coordination.
- T008, T011, and T014 can be updated in parallel because they target separate existing test files.
- T017 and T018 are sequential with respect to source regeneration and generated-output validation.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 for Objectives.
3. Run the focused Feature 174 and Objective tests independently.
4. Continue to Controls and NFRs only after the Objective contract is passing.

### Incremental Delivery

1. Align Objective exploration and orchestration.
2. Align Control exploration and orchestration.
3. Align NFR exploration and orchestration.
4. Validate cross-owner lifecycle preservation.
5. Regenerate all derived surfaces and run the complete suite.

## Notes

- Every task includes an exact repository path.
- `[P]` marks only tasks that operate on different files without an incomplete prerequisite.
- Generated adapters and catalogs must not be hand-edited.
- No runtime dependency, persisted entity, lifecycle stage, ownership model, or external API is introduced.
