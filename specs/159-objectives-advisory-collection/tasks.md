---
description: "Task list for Objectives Advisory Collection"
---

# Tasks: Objectives Advisory Collection

**Input**: Design documents from `specs/159-objectives-advisory-collection/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

## Phase 1: Setup

**Purpose**: Confirm the existing source, generated adapter, and test surfaces.

- [X] T001 Verify the Feature 159 design artifacts and existing Objective source/test paths in `specs/159-objectives-advisory-collection/plan.md`, `.highway/skills/highway-objectives/SKILL.md`, and `.highway/tools/tests/`
- [X] T002 Verify the adapter generator and registered Objective adapter paths using `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/.adapter-manifest`

## Phase 2: Foundational

**Purpose**: Establish the focused contract probe before changing the authored behavior.

- [X] T003 [P] Add the Feature 159 static Objective advisory contract test in `.highway/tools/tests/feature-159-objectives-advisory.test.sh`

**Checkpoint**: The focused probe exists and fails only for the not-yet-implemented Feature 159 contract.

## Phase 3: User Story 1 - Consistent Response Support (Priority: P1)

**Goal**: Centralize correction-oriented validation and context-specific reassurance while preserving the user-authored path.

**Independent Test**: The Feature 159 contract test finds the reusable Response Support Text section, required wording, replacement review prompt, and context selection rules without the legacy review prompt.

- [X] T004 [US1] Add the Objective-owned Response Support Text section and correction-oriented review contract in `.highway/skills/highway-objectives/SKILL.md`
- [X] T005 [US1] Replace legacy recommendation, review, and continuation wording with explicit acceptance, discovery, combined, recommendation, and additional-suggestion behavior in `.highway/skills/highway-objectives/SKILL.md`

**Checkpoint**: User Story 1 support wording and review behavior pass independently.

## Phase 4: User Story 2 - Grounded Advisory and Portfolio Assessment (Priority: P1)

**Goal**: Allow one grounded Objective observation and concise advisory portfolio assessment without changing Objective authority.

**Independent Test**: The focused contract test verifies accepted Profile/Objective grounding, one-observation guidance, portfolio assessment examples, advisory limits, and no manufactured insight.

- [X] T006 [US2] Add concise Objective Contribution Guidance and Objective Portfolio Assessment Guidance to `.highway/skills/highway-objectives/SKILL.md`
- [X] T007 [US2] Add grounded advisory, portfolio authority, and missing-context assertions to `.highway/tools/tests/feature-159-objectives-advisory.test.sh`

**Checkpoint**: User Story 2 advisory behavior remains provisional and non-mutating.

## Phase 5: User Story 3 - Sequential Recommendation Development (Priority: P1)

**Goal**: Process several selected recommendations as an ordered transient queue with required Success Measure handling before capture.

**Independent Test**: The focused contract test verifies queue creation, user-selected order, per-item statement/Success/rationale/review/capture sequence, derived measures, unresolved Success blocking, and non-adoption explanation handling.

- [X] T008 [US3] Replace direct multi-select capture with ordered Active Objective Queue and per-recommendation Success Measure gating in `.highway/skills/highway-objectives/SKILL.md`
- [X] T009 [US3] Add sequential queue, Success Measure, modification, and non-adoption assertions to `.highway/tools/tests/feature-159-objectives-advisory.test.sh`

**Checkpoint**: User Story 3 cannot capture a queued Objective before required Success Measures are established.

## Phase 6: User Story 4 - Recommendation Lifecycle and Exhaustion (Priority: P2)

**Goal**: Make one/several/all selection, modification, exhaustion, continuation, and future suggestion availability explicit.

**Independent Test**: The focused contract test verifies lifecycle choices, grounded exhaustion explanations, explicit continuation, future suggestion availability, and explicit finish precedence.

- [X] T010 [US4] Add recommendation lifecycle, exhaustion, future-suggestion, and explicit-finish guidance to `.highway/skills/highway-objectives/SKILL.md`
- [X] T011 [US4] Add lifecycle and exhaustion assertions to `.highway/tools/tests/feature-159-objectives-advisory.test.sh`

**Checkpoint**: User Story 4 lifecycle behavior is explicit without manufacturing recommendations.

## Phase 7: Polish and Cross-Cutting Validation

**Purpose**: Synchronize generated artifacts and prove preserved Objective contracts.

- [X] T012 Regenerate all registered Objective adapters with `.highway/tools/generate-agent-adapters.sh`
- [X] T013 Run `.highway/tools/tests/objective-management.test.sh` and confirm existing owner, persistence, catalog, identifier, duplicate, overlap, and non-write contracts remain passing
- [X] T014 Run `.highway/tools/tests/run-all.sh` and resolve any Feature 159 adapter or regression failures
- [X] T015 Run the validation scenarios in `specs/159-objectives-advisory-collection/quickstart.md` and confirm all tasks are complete

## Dependencies and Execution Order

- Phase 1 has no dependencies.
- Phase 2 depends on Phase 1 and blocks story work.
- User Stories 1 through 4 depend on Phase 2; because they modify the same authored skill and focused test, execute them sequentially in priority order.
- Phase 7 depends on all story work; adapter generation must follow the final authored source.

## Parallel Opportunities

- T003 can begin after T001 and T002 complete.
- T007, T009, and T011 are logically story-scoped but share one test file, so they must be applied sequentially in task order.
- No source story tasks are parallelizable because they all modify `.highway/skills/highway-objectives/SKILL.md`.

## Implementation Strategy

1. Establish the focused contract probe.
2. Deliver User Story 1 as the MVP and validate it.
3. Add grounded advisory and portfolio behavior.
4. Add sequential recommendation processing and Success gating.
5. Add lifecycle and exhaustion behavior.
6. Regenerate adapters and run focused, Objective, and full-suite validation.
