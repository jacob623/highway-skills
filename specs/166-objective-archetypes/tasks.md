---
description: "Task list for Objective Archetypes"
---

# Tasks: Objective Archetypes

**Input**: Design documents from `specs/166-objective-archetypes/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Static document-contract tests are required by the feature specification and run under the existing Bash test harness.

**Organization**: Tasks are grouped by user story. The source skill and focused test are shared files, so tasks touching either file are ordered sequentially.

## Phase 1: Setup

**Purpose**: Confirm the existing source-first and validation surfaces.

- [X] T001 Review `specs/166-objective-archetypes/plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md` to confirm implementation scope and protected boundaries.
- [X] T002 Run `bash .highway/tools/tests/run-all.sh` from the repository root and record the pre-change baseline for Feature 166 implementation.

## Phase 2: Foundational

**Purpose**: Establish the focused contract-test surface before changing the shipped skill.

- [X] T003 [P] Create `.highway/tools/tests/feature-166-objective-archetypes.test.sh` with failing assertions for section placement, Profile-first ordering, four archetype families, hidden internal terminology, lifecycle boundaries, recommendation limits, and source-to-adapter equality.
- [X] T004 Run `bash .highway/tools/tests/feature-166-objective-archetypes.test.sh` and record the expected failure against the current Objective skill before implementation.

**Checkpoint**: The focused contract test exists, fails for the missing Feature 166 behavior, and is ready to drive the source edit.

## Phase 3: User Story 1 - Receive broader grounded Objective recommendations (Priority: P1) 🎯 MVP

**Goal**: Add Profile-first recommendation generation with conditional archetype coverage supplementation and unified presentation.

**Independent Test**: The Feature 166 contract test finds the Objective Archetypes section, Profile-first generation guidance, meaningful coverage-gap evaluation, four families, and unified recommendation boundaries without exposing internal categories.

### Implementation for User Story 1

- [X] T005 [US1] Add the `## Objective Archetypes` section immediately after `## Recommendation Development` and before `### Objective Development Lifecycle` in `.highway/skills/highway-objectives/SKILL.md`.
- [X] T006 [US1] Document the Coverage Principle and Growth, Operations, Customer, and Capability families with representative Objective examples in `.highway/skills/highway-objectives/SKILL.md`.
- [X] T007 [US1] Document Profile-first recommendation generation, meaningful coverage-gap evaluation, conditional archetype-derived recommendations, unified presentation, and the existing five-choice limit in `.highway/skills/highway-objectives/SKILL.md`.

**Checkpoint**: User Story 1 guidance is complete in the source skill and the focused contract test passes its recommendation-generation assertions.

## Phase 4: User Story 2 - Preserve the meaning and boundaries of Objective Archetypes (Priority: P1)

**Goal**: Keep archetypes internal guidance only and preserve Working Idea, user-authority, lifecycle, and persistence boundaries.

**Independent Test**: The focused contract test confirms no archetype family, source, or coverage mechanic is exposed and no new acceptance, lifecycle, readiness, persistence, or ownership behavior is introduced.

### Implementation for User Story 2

- [X] T008 [US2] Add recommendation presentation and boundary guidance that hides archetype names, sources, and coverage evaluation while preserving the user-authored alternative in `.highway/skills/highway-objectives/SKILL.md`.
- [X] T009 [US2] Add explicit Working Idea, acceptance, ownership, lifecycle, readiness, persistence, and no-new-artifact boundaries for Objective Archetypes in `.highway/skills/highway-objectives/SKILL.md`.
- [X] T010 [US2] Extend `.highway/tools/tests/feature-166-objective-archetypes.test.sh` with boundary assertions and run it to verify User Story 2 independently.

**Checkpoint**: User Stories 1 and 2 preserve the existing Objective lifecycle and pass the focused contract test.

## Phase 5: User Story 3 - Receive relevant additional suggestions over time (Priority: P2)

**Goal**: Extend additional-suggestion guidance to use accepted Profile evidence and accepted Objective portfolio coverage gaps without manufacturing recommendations.

**Independent Test**: The focused contract test verifies additional suggestions evaluate both accepted sources, may surface a useful non-duplicate gap, and stop when no grounded option remains.

### Implementation for User Story 3

- [X] T011 [US3] Add Additional Suggestions guidance that evaluates accepted Profile evidence, accepted Objective portfolio coverage, uncovered areas, and meaningful archetype gaps in `.highway/skills/highway-objectives/SKILL.md`.
- [X] T012 [US3] Add the additional-suggestion example and no-manufactured-recommendation boundary in `.highway/skills/highway-objectives/SKILL.md`.
- [X] T013 [US3] Extend `.highway/tools/tests/feature-166-objective-archetypes.test.sh` with additional-suggestion assertions and run it to verify User Story 3 independently.

**Checkpoint**: All user stories are represented in the source contract and the focused test passes.

## Phase 6: Polish & Cross-Cutting Validation

**Purpose**: Regenerate shipped adapters and run all repository verification.

- [X] T014 Regenerate `.github/skills/highway-objectives/SKILL.md`, `.claude/skills/highway-objectives/SKILL.md`, `.cursor/skills/highway-objectives/SKILL.md`, and `.agents/skills/highway-objectives/SKILL.md` with `bash .highway/tools/generate-agent-adapters.sh`.
- [X] T015 Run `bash .highway/tools/validate-skill.sh .highway/skills/highway-objectives` and confirm the source skill passes governance and experience validation.
- [X] T016 Run `bash .highway/tools/tests/feature-166-objective-archetypes.test.sh` and confirm the complete Feature 166 contract passes.
- [X] T017 Run `bash .highway/tools/tests/run-all.sh` and confirm the full repository suite passes.
- [X] T018 Run `git diff --check` and review `git diff --stat` for unintended changes.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the baseline.
- **Foundational (Phase 2)**: Depends on Setup; the focused test must fail before source implementation.
- **User Story 1 (Phase 3)**: Depends on Foundational and is the MVP.
- **User Story 2 (Phase 4)**: Depends on User Story 1 because it extends the same source/test contract.
- **User Story 3 (Phase 5)**: Depends on User Story 2 because it extends the same source/test contract.
- **Polish (Phase 6)**: Depends on all user story work; regeneration precedes adapter and full-suite validation.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational; no dependency on another story.
- **User Story 2 (P1)**: Depends on User Story 1's Objective Archetypes section and unified recommendation guidance.
- **User Story 3 (P2)**: Depends on User Story 2's internal-boundary guidance and uses the accepted Objective portfolio context already defined by the skill.

### Parallel Opportunities

- T003 can run in parallel with no other implementation task after the design review, but T004 must follow it.
- No source-edit tasks are parallel because all three user stories modify the same authoritative skill.
- T015 and T016 can run in parallel after T014; T017 follows them for full regression validation.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement User Story 1 in the source skill.
3. Regenerate adapters.
4. Run the focused Feature 166 contract test and the skill validator.
5. Continue to User Stories 2 and 3 because the requested feature requires their boundary and additional-suggestion behavior.

### Incremental Delivery

1. Establish the failing contract test.
2. Add Profile-first archetype coverage guidance and verify it.
3. Add internal-boundary and lifecycle protections and verify them.
4. Add additional-suggestion guidance and verify it.
5. Regenerate adapters and run the full suite.

## Completion Criteria

- All tasks are marked `[X]`.
- The source Objective skill contains the requested section and boundaries.
- All four generated Objective adapters match the source.
- Focused and full repository tests pass.
- `git diff --check` passes.
