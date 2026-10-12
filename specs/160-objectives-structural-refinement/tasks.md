# Tasks: Objectives Structural Refinement

**Input**: Design documents from `/specs/160-objectives-structural-refinement/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [quickstart.md](quickstart.md)

**Tests**: Focused static contract checks are included because the feature's success criteria require section placement, exemplar, size-budget, and protected-contract validation.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel when it touches a different file and has no dependency on incomplete work.
- **[Story]**: User story label for story-phase tasks.

## Dependencies

- Setup and foundational tasks must complete before story work.
- User Story 1 establishes the peer-section structure before User Stories 2 and 3 add or relocate the dedicated guidance.
- User Story 4 validates the preserved workflow contracts after the source refinement is complete.
- Polish regenerates adapters and runs the repository-wide verification after all story work.

## Phase 1: Setup

**Purpose**: Establish the focused validation surface for the documentation-only change.

- [X] T001 Record the pre-change authored Objective skill structure and focused suite baseline in `specs/160-objectives-structural-refinement/quickstart.md`.
- [X] T002 [P] Create the Feature 160 static contract test harness at `.highway/tools/tests/feature-160-objectives-structural-refinement.test.sh`.

## Phase 2: Foundational

**Purpose**: Define the shared assertions and protected contract inventory before story edits.

- [X] T003 Add shared test assertions for the six required peer headings, Creation Workflow boundaries, the clarified prose budget, and generated-adapter correspondence in `.highway/tools/tests/feature-160-objectives-structural-refinement.test.sh`.
- [X] T004 [P] Document the protected Objective ownership, queue, continuation, portfolio, identifier, catalog, persistence, setup, and Repository Context phrases used by regression checks in `specs/160-objectives-structural-refinement/data-model.md`.

**Checkpoint**: The focused test surface and protected contract inventory are ready; no source behavior has changed.

## Phase 3: User Story 1 - Discover Objective collaboration guidance (Priority: P1) 🎯 MVP

**Goal**: Make the six collaboration behaviors visible as peer sections while keeping Creation Workflow focused on workflow sequencing and boundaries.

**Independent Test**: The Feature 160 contract test finds the six headings in the specified order outside Creation Workflow and confirms the workflow still contains its required responsibilities.

### Implementation

- [X] T005 [US1] Refactor the authored section hierarchy in `.highway/skills/highway-objectives/SKILL.md` so Response Support Text, Recommendation Development, Interpretation Confidence, Objective Contribution Guidance, Objective Portfolio Assessment Guidance, and Objective Recommendation Presentation are peer sections in the specified order.
- [X] T006 [US1] Keep sequencing, discovery dimensions, review triggers, continuation behavior, and persistence boundaries in the Creation Workflow while removing duplicated advisory presentation guidance from `.highway/skills/highway-objectives/SKILL.md`.

**Checkpoint**: User Story 1 is independently testable through the focused structural contract test.

## Phase 4: User Story 2 - Prefer grounded Objective interpretation (Priority: P1)

**Goal**: Make grounded interpretation and recommendation development easy to discover without changing authority or acceptance boundaries.

**Independent Test**: The focused contract test finds Interpretation Confidence and Recommendation Development guidance that favors accepted Profile evidence, preserves correction, avoids permission-only questions, and avoids manufactured insight.

### Implementation

- [X] T007 [US2] Move and consolidate grounded-interpretation rules into the Interpretation Confidence section in `.highway/skills/highway-objectives/SKILL.md`, preserving Working Idea and user-authority boundaries.
- [X] T008 [US2] Move and consolidate accepted-Profile recommendation rules into the Recommendation Development section in `.highway/skills/highway-objectives/SKILL.md`, preserving the user-authored path and advisory status.

**Checkpoint**: User Story 2 is independently testable through the focused interpretation and recommendation assertions.

## Phase 5: User Story 3 - Compare and select grounded recommendations (Priority: P1)

**Goal**: Make recommendation sets immediately scannable and comparable while retaining all explicit response paths.

**Independent Test**: The focused contract test finds bullet presentation, concise titles, short outcome descriptions, three distinct exemplar outcomes, one/several/all selection, modification, user-authored, and additional-suggestion paths.

### Implementation

- [X] T009 [US3] Add Objective Recommendation Presentation guidance to `.highway/skills/highway-objectives/SKILL.md` using concise bullets, outcome-oriented descriptions, and explicit distinctions without adding duplicate behavioral prose.
- [X] T010 [US3] Add one concise illustrative three-outcome recommendation exemplar and explicit response-path wording to `.highway/skills/highway-objectives/SKILL.md`.

**Checkpoint**: User Story 3 is independently testable through the focused presentation and exemplar assertions.

## Phase 6: User Story 4 - Preserve Objective workflow contracts (Priority: P2)

**Goal**: Demonstrate that structural refinement does not change Objective ownership, workflow state, persistence, or orchestration contracts.

**Independent Test**: Focused regression assertions pass for protected source phrases and existing Objective management behavior remains unchanged.

### Implementation

- [X] T011 [US4] Extend `.highway/tools/tests/feature-160-objectives-structural-refinement.test.sh` with protected-contract assertions covering ownership, Success, Highway Relevance, queue processing, adoption, continuation, portfolio assessment, identifiers, catalog, atomic persistence, setup, and Repository Context.
- [X] T012 [US4] Verify `.highway/skills/highway-objectives/SKILL.md` retains existing readiness, mutation output, non-write, duplicate, overlap, and acceptance contracts after the structural refactor.

**Checkpoint**: User Story 4 is independently testable through focused regression checks and existing Objective management tests.

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T013 Regenerate all declared Objective adapters from `.highway/skills/highway-objectives/SKILL.md` using `.highway/tools/generate-agent-adapters.sh`.
- [X] T014 Run `bash .highway/tools/tests/feature-160-objectives-structural-refinement.test.sh` and repair any local contract-test failures in `.highway/tools/tests/feature-160-objectives-structural-refinement.test.sh` or `.highway/skills/highway-objectives/SKILL.md`.
- [X] T015 Run `bash .highway/tools/tests/feature-159-objectives-advisory.test.sh` and `bash .highway/tools/tests/objective-management.test.sh` to verify Feature 159 behavior and Objective management remain green.
- [X] T016 Run `bash .highway/tools/tests/run-all.sh` and resolve only Feature 160 regressions in the affected source, generated adapters, or focused tests.
- [X] T017 Review `git diff --check` and the authored skill against the size budget, then record final validation evidence in `specs/160-objectives-structural-refinement/quickstart.md`.

## Parallel Execution Examples

- After T001, T002 can proceed in parallel with T004 because they touch different files.
- T007 and T008 must remain sequential with T005/T006 because they edit the same authored skill.
- T011 can be prepared while T009/T010 are being reviewed, but it must run after the final source structure exists.
- T013 and T014 are sequential because the focused test must inspect regenerated artifacts when correspondence is asserted.

## Implementation Strategy

1. Deliver the peer-section structure as the MVP (User Story 1).
2. Consolidate grounded interpretation and recommendation development (User Story 2).
3. Add the bounded presentation exemplar (User Story 3).
4. Verify protected Objective contracts, regenerate adapters, and run the full suite (User Story 4 and Polish).
5. Do not introduce new runtime state, persisted records, interfaces, or unrelated refactoring.
