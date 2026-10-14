# Tasks: Unified Recommendation Exploration Refactor

**Input**: Design documents from `/specs/173-unified-recommendation-exploration-refactor/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/recommendation-exploration-interaction.md, quickstart.md

**Tests**: Contract tests are included because the specification requires corresponding Objective and Control contract validation.

**Organization**: Tasks are grouped by user story and ordered so test assertions precede the source changes they validate.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the source-first contract and existing validation surfaces.

- [x] T001 Review the Feature 173 contract, source map, and validation commands in `specs/173-unified-recommendation-exploration-refactor/plan.md` and `quickstart.md`
- [x] T002 [P] Verify the authoritative Objective and Control source paths and generated adapter manifest in `.highway/tools/.adapter-manifest`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish test expectations for the shared exploration and queue contract before modifying owner sources.

- [x] T003 [P] Add Objective recommendation-lineage, exploration, queue-membership, exhaustion, and continuation assertions to `.highway/tools/tests/feature-159-objectives-advisory.test.sh`
- [x] T004 [P] Add Control recommendation-lineage, exploration, queue-membership, exhaustion, and continuation assertions to `.highway/tools/tests/highway-controls-onboarding.test.sh`
- [x] T005 [P] Add explicit queue-start, exploration-freeze, and proposal-boundary assertions to `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh`
- [x] T006 [P] Add multi-set `Collection Result: Continue` and post-capture continuation assertions to `.highway/tools/tests/feature-164-objective-portfolio-continuity.test.sh`

**Checkpoint**: Contract assertions describe the requested behavior and fail until the two authoritative owner sources are aligned.

## Phase 3: User Story 1 - Explore and Queue Objective Recommendations (Priority: P1) 🎯 MVP

**Goal**: Align the Objective owner with Profile-informed lineage and the shared exploration, queue construction, exhaustion, and continuation model.

**Independent Test**: Run the Objective advisory, lifecycle, and continuity contract tests after updating the source; selected recommendations must expand the active Objective queue while exploration remains active and processing is not started.

### Implementation for User Story 1

- [x] T007 [US1] Add Profile-Informed Recommendations and the shared Recommendation Exploration contract to `.highway/skills/highway-objectives/SKILL.md`, preserving existing Objective ownership and proposal-first boundaries
- [x] T008 [US1] Update the Objective queue and acceptance boundaries and setup/configure workflow in `.highway/skills/highway-objectives/SKILL.md` to preserve transient queue membership, explicit queue start, continuation, and capture rules

**Checkpoint**: Objective recommendation selection, exploration, queue construction, processing entry, proposal development, acceptance, and capture are independently testable.

## Phase 4: User Story 2 - Explore and Queue Control Recommendations (Priority: P1)

**Goal**: Align the Control owner with Objective-informed lineage and the same exploration and queue contract without transferring ownership or creating Controls automatically.

**Independent Test**: Run the Control onboarding and Control/NFR relationship tests; selected recommendations must enter the active Control queue without direct capture or automatic downstream record creation.

### Implementation for User Story 2

- [x] T009 [US2] Add Objective-Informed Recommendations and the shared Recommendation Exploration contract to `.highway/skills/highway-controls/SKILL.md`, preserving independent Control ownership and recommendation-source boundaries
- [x] T010 [US2] Update the Control queue and acceptance boundaries and setup/configure workflow in `.highway/skills/highway-controls/SKILL.md` to preserve transient queue membership, explicit queue start, continuation, and capture rules

**Checkpoint**: Control recommendation selection, exploration, queue construction, processing entry, proposal development, acceptance, and capture are independently testable.

## Phase 5: User Story 3 - Start Processing Only at the Defined Boundary (Priority: P1)

**Goal**: Ensure both owners use one explicit queue-processing start rule and freeze recommendation exploration during processing.

**Independent Test**: Verify exhaustion and explicit-start examples in both owner contracts, then run the focused lifecycle and onboarding tests to confirm processing does not begin from selection alone.

### Implementation for User Story 3

- [x] T011 [US3] Reconcile the Objective and Control lifecycle wording and continuation examples with `specs/173-unified-recommendation-exploration-refactor/contracts/recommendation-exploration-interaction.md`, keeping Recommendation Exploration as the canonical queue-start owner
- [x] T012 [US3] Add any remaining cross-owner assertions for exhaustion, explicit queue start, exploration freeze, and no candidate lifecycle to `.highway/tools/tests/highway-controls-onboarding.test.sh` and `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh`

**Checkpoint**: Both owners reject selection-only processing and remain closed to new recommendation generation during queue processing.

## Phase 6: User Story 4 - Continue Collection Across Recommendation Sets (Priority: P2)

**Goal**: Preserve setup continuation while allowing multiple recommendation sets before processing begins.

**Independent Test**: Return `Collection Result: Continue` after one recommendation set, provide another set, and verify that exploration continues without queue processing.

### Implementation for User Story 4

- [x] T013 [US4] Align Objective and Control continuation examples and collection-result wording with the multi-set scenarios in `.highway/skills/highway-objectives/SKILL.md` and `.highway/skills/highway-controls/SKILL.md`

**Checkpoint**: Setup/configure continuation remains separate from queue processing and completion evaluation.

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Synchronize generated surfaces and prove the complete contract.

- [x] T014 [P] Regenerate all Objective and Control adapters and catalogs with `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-instructions.sh`
- [x] T015 Run focused Objective and Control validation from `specs/173-unified-recommendation-exploration-refactor/quickstart.md`
- [x] T016 Run `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/generate-agent-adapters.test.sh` to verify generated correspondence
- [x] T017 Run `.highway/tools/tests/run-all.sh` and `git diff --check`, then review requirement coverage against `spec.md`

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the source and validation map.
- **Foundational (Phase 2)**: Depends on Setup; test assertions must be in place before owner source edits.
- **User Stories 1-2 (Phases 3-4)**: Depend on Foundational; Objective and Control source work can proceed in parallel if separate owners edit separate files.
- **User Story 3 (Phase 5)**: Depends on both owner source updates because it reconciles shared lifecycle language.
- **User Story 4 (Phase 6)**: Depends on the owner source updates and validates continuation across both owners.
- **Polish (Phase 7)**: Depends on all owner source and focused test changes.

### User Story Dependencies

- **User Story 1 (P1)**: Can begin after Phase 2; MVP Objective alignment.
- **User Story 2 (P1)**: Can begin after Phase 2; independently testable Control alignment.
- **User Story 3 (P1)**: Depends on User Stories 1 and 2 so both owners share the same trigger and freeze semantics.
- **User Story 4 (P2)**: Depends on User Stories 1 and 2; validates setup continuation across both owners.

### Parallel Opportunities

- T002 can run in parallel with T001.
- T003-T006 can be prepared in parallel because they touch separate test files.
- T007-T008 can be executed sequentially on the Objective source while T009-T010 run sequentially on the Control source.
- T014 can run after all source edits and is independent of the final test execution tasks.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Complete Objective source alignment in User Story 1.
3. Run the Objective advisory, lifecycle, and continuity tests.
4. Validate that Objective exploration and queue construction work independently.

### Incremental Delivery

1. Align Objectives and validate the MVP.
2. Align Controls and validate independent Control behavior.
3. Reconcile shared queue-start and exploration-freeze semantics.
4. Validate multi-set continuation.
5. Regenerate all derived surfaces and run the full suite.

## Notes

- Every task uses the required checklist format with a sequential ID and an exact file path.
- No runtime dependency, API, new persisted entity, candidate state, or ownership transfer is introduced.
- Generated adapters and catalogs are never hand-edited; source changes flow through the declared generators.
