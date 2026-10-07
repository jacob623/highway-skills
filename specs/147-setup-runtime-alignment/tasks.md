# Tasks: Setup Runtime Architecture Alignment

**Input**: Design documents from `/specs/147-setup-runtime-alignment/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Focused Setup contract tests and the full repository suite are required because this feature changes a shipped runtime skill contract.

## Phase 1: Setup

**Purpose**: Establish the existing Setup contract and validation baseline.

- [X] T001 Inspect `.highway/skills/highway-setup/SKILL.md` and record its current frontmatter, owner sequence, result contracts, transitions, resume behavior, and runtime Constitution reference.
- [X] T002 [P] Inspect `.highway/tools/tests/highway-setup.test.sh`, `.highway/tools/tests/setup-owner-loop-contract.test.sh`, `.highway/tools/tests/readiness-owner-states.test.sh`, `.highway/tools/tests/readiness-ownership.test.sh`, and `.highway/tools/tests/highway-setup-executable.test.sh` for assertions affected by Feature 147.
- [X] T003 Run the focused Setup validators and record the pre-implementation failures for the revised runtime contract.

## Phase 2: Foundational

**Purpose**: Establish the document and test expectations before story-specific edits.

- [X] T004 Add assertions for valid Setup frontmatter, one `# Purpose` section, owner order, and absence of runtime Constitution dependency in `.highway/tools/tests/highway-setup.test.sh`.
- [X] T005 [P] Add explicit malformed, blocked, declined, aborted, unsupported-action, and unexpected-failure expectations to `.highway/tools/tests/setup-owner-loop-contract.test.sh`.
- [X] T006 [P] Add Setup-specific transition, horizontal-rule, final-block, synthesis, welcome, resume, and completion assertions to the appropriate existing Setup test files under `.highway/tools/tests/`.
- [X] T007 Run the focused Setup validators and confirm the revised expectations fail against the unmodified Setup skill.

**Checkpoint**: Runtime and Setup-specific validation expectations are explicit before implementation.

## Phase 3: User Story 1 - Thin owner orchestrator and explicit failures (Priority: P1) [MVP]

**Goal**: Keep Setup as a thin owner orchestrator with explicit stop behavior and no runtime Constitution dependency.

**Independent Test**: Run the Setup owner-loop and executable validators with each owner result state and confirm correct delegation, continuation, stopping, and no false completion.

### Tests for User Story 1

- [X] T008 [P] [US1] Add a fixture for malformed or unsupported owner results stopping before later-owner invocation in `.highway/tools/tests/setup-owner-loop-contract.test.sh`.
- [X] T009 [P] [US1] Add fixtures for Blocked, Declined, Aborted, unsupported Next Action, and unexpected orchestration failure in `.highway/tools/tests/setup-owner-loop-contract.test.sh`.

### Implementation for User Story 1

- [X] T010 [US1] Correct frontmatter metadata and preserve exactly one `# Purpose` section in `.highway/skills/highway-setup/SKILL.md`.
- [X] T011 [US1] Remove the Constitution common failure model reference and define Setup's effective runtime failure behavior in the Error Handling section of `.highway/skills/highway-setup/SKILL.md`.
- [X] T012 [US1] Preserve Profile → Objectives → Controls → NFR owner order, readiness requests, owner-supplied action delegation, owner-specific results, continued owner interaction, fresh readiness, and advancement rules in `.highway/skills/highway-setup/SKILL.md`.
- [X] T013 [US1] Run the focused owner-loop and executable Setup validators and repair any failures in the same implementation slice.

**Checkpoint**: Setup has a self-contained runtime failure contract and remains a thin owner orchestrator.

## Phase 4: User Story 2 - Setup-owned presentation boundaries (Priority: P1)

**Goal**: Preserve Setup-specific transitions and closure without duplicating or competing with owner interactions.

**Independent Test**: Exercise active, terminal, continuing, and completed owners and verify welcome, transitions, separation, final-block demand, synthesis, and conclusion behavior.

### Tests for User Story 2

- [X] T014 [P] [US2] Add assertions for one-time active-domain transitions, skipped terminal owners, repeated same-owner continuation, and owner-opening non-duplication in `.highway/tools/tests/highway-setup.test.sh`.
- [X] T015 [P] [US2] Add assertions for `---` separation, at-most-one Setup-owned final response demand, and non-duplicated completed-domain synthesis in the relevant Setup contract test under `.highway/tools/tests/`.

### Implementation for User Story 2

- [X] T016 [US2] Preserve Setup-owned domain transition wording and constrain transitions to first entry into an active domain in `.highway/skills/highway-setup/SKILL.md`.
- [X] T017 [US2] Preserve horizontal-rule separation and concise completed-domain synthesis without machine result fields or duplicate owner synthesis in `.highway/skills/highway-setup/SKILL.md`.
- [X] T018 [US2] Add the Setup-owned final interaction-block response-demand boundary without interfering with the owner's Experience-governed interaction in `.highway/skills/highway-setup/SKILL.md`.
- [X] T019 [US2] Run the focused Setup presentation validators and repair any failures in the same implementation slice.

**Checkpoint**: Setup presentation is concise, one-time where required, and distinct from owner interaction content.

## Phase 5: User Story 3 - Generic Experience dependency and machine-result boundaries (Priority: P1)

**Goal**: Keep generic interaction behavior delegated to the Experience Standard and hide orchestration-only result fields.

**Independent Test**: Audit the Setup skill and run its validators to confirm the Experience Standard remains the generic interaction dependency while Setup does not implement advisory, clarification, convergence, acceptance, or persistence mechanics.

### Tests for User Story 3

- [X] T020 [P] [US3] Add assertions that Setup retains the Experience Standard input and user-visible interaction statement in `.highway/tools/tests/highway-setup.test.sh`.
- [X] T021 [P] [US3] Add assertions that machine readiness/action/collection/status fields are not rendered and generic Experience behavior is not restated in the Setup contract tests under `.highway/tools/tests/`.

### Implementation for User Story 3

- [X] T022 [US3] Preserve the Experience Standard input and user-visible interaction dependency while removing duplicated generic interaction rules from `.highway/skills/highway-setup/SKILL.md`.
- [X] T023 [US3] State that Setup consumes orchestration fields internally and exposes only user-relevant owner blocking context when needed in `.highway/skills/highway-setup/SKILL.md`.
- [X] T024 [US3] Keep Setup out of owner discovery, interpretation, recommendations, advisory reasoning, clarification, convergence, artifact acceptance, and persistence in `.highway/skills/highway-setup/SKILL.md`.
- [X] T025 [US3] Run focused runtime-boundary and Setup contract validators and repair any failures in the same implementation slice.

**Checkpoint**: Setup delegates generic interaction and owner semantics while hiding machine-only orchestration state.

## Phase 6: User Story 4 - Fresh resume and completion semantics (Priority: P2)

**Goal**: Preserve stateless resume behavior and claim completion only after all owners permit advancement.

**Independent Test**: Start fresh and resumed Setup scenarios and verify fresh readiness, no reconstructed state, one welcome policy, and one final conclusion only after complete owner advancement.

### Tests for User Story 4

- [X] T026 [P] [US4] Add assertions for fresh readiness, no checkpoint restoration, resumed welcome omission, and final conclusion gating in `.highway/tools/tests/highway-setup-executable.test.sh`.

### Implementation for User Story 4

- [X] T027 [US4] Preserve fresh owner readiness in Setup order and the no-checkpoint/no-owner-state resume contract in `.highway/skills/highway-setup/SKILL.md`.
- [X] T028 [US4] Preserve exactly-once initial welcome behavior and final conclusion gating after all four owners permit advancement in `.highway/skills/highway-setup/SKILL.md`.
- [X] T029 [US4] Run the executable Setup and readiness validators for fresh, resumed, incomplete, and fully completed flows.

**Checkpoint**: Setup resume and completion behavior remains owner-driven and stateless.

## Phase 7: Polish & Cross-Cutting Validation

**Purpose**: Verify traceability, protected-file boundaries, and repository health.

- [X] T030 [P] Audit `.highway/skills/highway-setup/SKILL.md` for runtime Constitution references, retired Experience rule IDs, generic Experience mechanics, machine-result leakage, duplicate Purpose headings, and invalid frontmatter.
- [X] T031 [P] Verify that owner skills, `.highway/governance/experience-standard.md`, shared templates, and unrelated runtime artifacts are unchanged by Feature 147.
- [X] T032 Run all focused Setup validators and `.highway/tools/tests/run-all.sh`.
- [X] T033 Run `git diff --check`, verify all tasks and requirements are covered, and record the final validation result.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001-T003 establish the baseline.
- **Foundational (Phase 2)**: T004-T007 define and validate the revised contract before implementation.
- **User Stories (Phases 3-6)**: Execute sequentially because they edit the same Setup skill and related validators.
- **Polish (Phase 7)**: Depends on all user stories and focused validation completing.

### User Story Dependencies

- **User Story 1 (P1)**: MVP; establishes the owner boundary and failure behavior.
- **User Story 2 (P1)**: Depends on the owner boundary from US1; adds Setup-specific presentation.
- **User Story 3 (P1)**: Depends on US1 and US2; verifies generic Experience delegation and machine-result hiding.
- **User Story 4 (P2)**: Depends on the orchestration and presentation contracts; verifies fresh resume and completion semantics.

### Parallel Opportunities

- T004-T006 can run in parallel because they touch separate test concerns.
- T008-T009 can run in parallel within the same test file only if their edits are coordinated before application.
- T014-T015 and T020-T021 can run in parallel when assigned to separate test files.
- T030-T031 can run in parallel after implementation.

### Independent Test Criteria

- **US1**: Owner-loop and executable tests prove delegation, continuation, stop conditions, and no false completion.
- **US2**: Presentation tests prove active-domain transitions, separation, synthesis, final-block behavior, and non-duplication.
- **US3**: Runtime-boundary tests prove Experience dependency and absence of machine-result or generic interaction leakage.
- **US4**: Executable and readiness tests prove fresh resume, welcome timing, and final completion gating.

## Implementation Strategy

### MVP First

1. Complete setup and foundational validation tasks.
2. Complete US1 to remove the runtime Constitution dependency and make owner failure behavior explicit.
3. Run the US1 focused tests and stop for an independently validated MVP.

### Incremental Delivery

1. Add Setup-owned presentation boundaries in US2.
2. Verify generic Experience delegation and machine-result hiding in US3.
3. Verify fresh resume and completion semantics in US4.
4. Run the full focused and repository suites.

## Notes

- No contracts directory is required because this feature changes an internal Markdown skill contract and exposes no external API.
- Do not modify the owner skills or the Experience Standard in this feature.
- Every task names the affected repository path and is ordered for direct execution.
