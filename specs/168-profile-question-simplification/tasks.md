---

# Tasks: Profile Question-Bias Simplification

**Input**: Design documents from `/specs/168-profile-question-simplification/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/profile-question-simplification.md, quickstart.md

**Tests**: Focused static contract validation is required by the implementation plan and quickstart.

## Phase 1: Setup

**Purpose**: Confirm the existing source-first Profile structure and validation entry points.

- [X] T001 Inspect the authoritative Profile guidance and existing Profile test conventions in `.highway/skills/highway-profile/SKILL.md` and `.highway/tools/tests/`

## Phase 2: Foundational

**Purpose**: Establish the focused static contract before changing guidance.

- [X] T002 [P] Create the Feature 168 static contract in `.highway/tools/tests/feature-168-profile-question-simplification.test.sh`, covering replacement wording, removed examples, preserved fallback and reaction boundaries, lifecycle limits, and generated adapter correspondence

## Phase 3: User Story 1 - Review grounded reasoning inside a starting point (Priority: P1) MVP

**Goal**: Route grounded advisory reasoning into an active structured starting point and preserve the existing reaction flow.

**Independent Test**: The focused contract and Profile validator confirm that the guidance directs responsible reasoning into structured starting points while retaining the shared reaction invitation and canonical fallback.

### Implementation

- [X] T003 [US1] Update advisory question scaffolding in `.highway/skills/highway-profile/SKILL.md` so active Discovery Contribution Opportunities incorporate grounded reasoning into structured starting points and retain questions for missing evidence or consequential ambiguity
- [X] T004 [US1] Add the proposal-first interpretation preference to the Interpretation Confidence guidance in `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 1 is complete when grounded reasoning, structured starting points, reaction, and fallback behavior are all represented in the authoritative guidance.

## Phase 4: User Story 2 - Receive only necessary clarification (Priority: P1)

**Goal**: Keep advisory questions focused on result-changing ambiguity or information the evidence cannot responsibly supply.

**Independent Test**: The focused contract verifies that the removed question bias does not remove direct consequential-ambiguity clarification or canonical fallback questions.

### Implementation

- [X] T005 [US2] Revise structure-revealing contribution guidance in `.highway/skills/highway-profile/SKILL.md` to express implications, tradeoffs, and possibilities inside an active proposed starting point and allow reaction through the active opportunity without an extra closing question

**Checkpoint**: User Story 2 is complete when sufficient evidence does not require a permission-seeking exploratory question, while consequential ambiguity and insufficient evidence still do.

## Phase 5: User Story 3 - Learn from proposal-shaped examples (Priority: P2)

**Goal**: Remove contradictory question-centric teaching examples while preserving useful boundaries and the unsupported-reasoning counter-example.

**Independent Test**: Inspect the focused contract and source guidance for removal of all three question-centric worked examples, retention of the counter-example, and proposal-first structure guidance.

### Implementation

- [X] T006 [US3] Remove the three question-centric worked examples and update the remaining Contribution in practice guidance in `.highway/skills/highway-profile/SKILL.md`, preserving the unsupported-reasoning counter-example

**Checkpoint**: User Story 3 is complete when the source teaches reasoning, structured starting point, and reaction without a competing default question closure.

## Phase 6: Polish & Cross-Cutting Validation

**Purpose**: Regenerate distributed artifacts and validate the complete repository change.

- [X] T007 Regenerate Profile adapters, catalog artifacts, and adapter manifest with `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-catalog.sh`
- [X] T008 Run `.highway/tools/validate-skill.sh .highway/skills/highway-profile`, `.highway/tools/tests/feature-168-profile-question-simplification.test.sh`, `.highway/tools/tests/run-all.sh`, and `git diff --check`
- [X] T009 Update this task list and review the final source, generated correspondence, and feature diff for complete FR-001 through FR-011 coverage

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 has no dependency.
- **Foundational (Phase 2)**: T002 depends on T001 and blocks implementation validation.
- **User Stories (Phase 3+)**: T003 and T004 depend on T002. T005 depends on the updated source from T003. T006 depends on the same source review and can follow T003-T005.
- **Polish (Phase 6)**: T007 depends on T003-T006. T008 depends on T007. T009 depends on T008.

### Parallel Opportunities

- T002 can be prepared independently after T001.
- T003 and T004 touch the same authoritative file and should be executed sequentially despite covering separate requirements.
- T007's two generator commands are independent after source implementation, subject to the repository's generator conventions.

## Implementation Strategy

### MVP First

1. Complete T001-T002.
2. Implement T003-T004 for User Story 1.
3. Run the focused contract and Profile validator.

### Incremental Delivery

1. Complete User Story 1 and validate the proposal-first starting point.
2. Complete User Story 2 and validate clarification boundaries.
3. Complete User Story 3 and validate example teaching material.
4. Regenerate adapters and catalog artifacts.
5. Run the full suite and final diff review.

## Notes

- No new runtime service, lifecycle state, persisted artifact, readiness dimension, or schema field is permitted.
- The authoritative source remains `.highway/skills/highway-profile/SKILL.md`; generated Profile delivery surfaces must remain byte-identical after regeneration.
