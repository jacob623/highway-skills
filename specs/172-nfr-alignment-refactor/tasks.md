---
description: "Task list for the NFR Alignment Refactor"
---

# Tasks: NFR Alignment Refactor

**Input**: Design documents from `/specs/172-nfr-alignment-refactor/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/nfr-interaction.md`, `quickstart.md`

**Organization**: Tasks are grouped by user story so each story can be implemented and validated as an independent increment.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the source-first implementation and test surfaces.

- [X] T001 Confirm the authoritative NFR skill, focused test scripts, generators, and generated adapter paths in `.highway/skills/highway-nfrs/SKILL.md`, `.highway/tools/tests/`, and `.highway/tools/generate-*.sh`
- [X] T002 [P] Capture the current NFR contract and generated-artifact baseline by running the focused checks from `specs/172-nfr-alignment-refactor/quickstart.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Align the NFR owner vocabulary and preserve the existing ownership and persistence boundaries before story-specific behavior is added.

- [X] T003 Map the existing NFR setup, readiness, persistence, relationship, duplicate, overlap, and destructive sections in `.highway/skills/highway-nfrs/SKILL.md` to the Feature 172 interaction contract
- [X] T004 [P] Compare the recommendation, queue, proposal, acceptance, portfolio, and continuation boundaries in `.highway/skills/highway-objectives/SKILL.md` and `.highway/skills/highway-controls/SKILL.md` with the NFR design artifacts
- [X] T005 [P] Identify assertions that intentionally change and assertions that must remain unchanged in `.highway/tools/tests/highway-nfr-onboarding.test.sh`, `.highway/tools/tests/nfr-management.test.sh`, `.highway/tools/tests/control-derived-nfr.test.sh`, and readiness/relationship checks

**Checkpoint**: The implementation surface and preservation constraints are explicit; no user story changes may introduce a persisted candidate state or alter the NFR record schema.

---

## Phase 3: User Story 1 - Explore grounded NFR recommendations (Priority: P1) 🎯 MVP

**Goal**: Present grounded, provisional NFR recommendations and support additional suggestions without requiring invention or creating records.

**Independent Test**: With accepted context, verify that setup presents recommendations first, additional suggestions remain provisional, coverage guidance stays internal, and exhausted recommendations do not manufacture an NFR.

### Tests for User Story 1

- [X] T006 [P] [US1] Update recommendation-first onboarding assertions in `.highway/tools/tests/highway-nfr-onboarding.test.sh` for Profile, Objective, Control, and NFR context
- [X] T007 [P] [US1] Add recommendation exhaustion, user-invention fallback, and hidden coverage-area assertions in `.highway/tools/tests/highway-nfr-onboarding.test.sh`

### Implementation for User Story 1

- [X] T008 [US1] Add NFR recommendation exploration, accepted-context sources, and Working Idea boundaries to `.highway/skills/highway-nfrs/SKILL.md`
- [X] T009 [US1] Add internal Reliability, Availability, Performance, Scalability, Security, Compliance, Maintainability, and Operability guidance without exposing or persisting coverage areas in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T010 [US1] Add additional-suggestion, meaningful-coverage-exhaustion, and no-manufactured-recommendation behavior to `.highway/skills/highway-nfrs/SKILL.md`

**Checkpoint**: Recommendation exploration is independently usable and cannot create an NFR record or candidate artifact.

---

## Phase 4: User Story 2 - Construct and process an NFR queue (Priority: P1)

**Goal**: Turn selected recommendations into an ordered transient queue and begin processing only on explicit intent or grounded exhaustion.

**Independent Test**: Select one, several, and later recommendations; verify ordering, append behavior, skip behavior, and the explicit processing boundary without capture.

### Tests for User Story 2

- [X] T011 [P] [US2] Add ordered queue-selection, select-all, append, skip, and no-capture assertions in `.highway/tools/tests/highway-nfr-onboarding.test.sh`
- [X] T012 [P] [US2] Add explicit queue-processing language and recommendation-exhaustion routing assertions in `.highway/tools/tests/governance-routing.test.sh`

### Implementation for User Story 2

- [X] T013 [US2] Add transient ordered NFR queue construction, selection order, append, and queue-membership boundaries to `.highway/skills/highway-nfrs/SKILL.md`
- [X] T014 [US2] Add explicit queue-processing intent recognition and exploration exit behavior for `Start with these`, `Process the queue`, `Capture the queue`, and review requests in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T015 [US2] Define recommendation-exhaustion routing to queue processing or a user-provided NFR without implicit capture in `.highway/skills/highway-nfrs/SKILL.md`

**Checkpoint**: Queue membership is distinct from proposal development, acceptance, capture, identifiers, catalog allocation, and persistence.

---

## Phase 5: User Story 3 - Develop and capture NFRs through a proposal lifecycle (Priority: P1)

**Goal**: Process queued and user-authored NFRs through converged proposal, explicit acceptance, capture, and next-item continuation.

**Independent Test**: Process a recommendation and a direct user NFR through proposal correction/replacement, rejection or abandonment, acceptance, capture, and sequential continuation; verify only accepted proposals persist.

### Tests for User Story 3

- [X] T016 [P] [US3] Add proposal-first, required title/statement/rationale, correction, replacement, rejection, abandonment, and acceptance assertions in `.highway/tools/tests/highway-nfr-onboarding.test.sh`
- [X] T017 [P] [US3] Add capture-boundary, identifier/catalog allocation, and next-queued-item continuation assertions in `.highway/tools/tests/nfr-management.test.sh`

### Implementation for User Story 3

- [X] T018 [US3] Add the converged NFR proposal contract and proposal-first development lifecycle to `.highway/skills/highway-nfrs/SKILL.md`
- [X] T019 [US3] Unify queued recommendations and user-provided NFRs under the same correction, replacement, rejection, cancellation, abandonment, acceptance, and capture flow in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T020 [US3] Add sequential queue processing and post-capture continuation while preserving existing NFR records, identifiers, catalog, and allocation behavior in `.highway/skills/highway-nfrs/SKILL.md`

**Checkpoint**: Every persisted NFR has crossed a presented converged proposal and explicit acceptance boundary.

---

## Phase 6: User Story 4 - Assess the NFR portfolio without blocking ownership (Priority: P2)

**Goal**: Provide concise advisory portfolio synthesis and continuation after capture without adding lifecycle stages or mutating accepted records.

**Independent Test**: With multiple accepted NFRs, verify advisory observations for coverage, overlap, duplication, dependencies, gaps, tensions, and operational implications, followed by continued collection.

### Tests for User Story 4

- [X] T021 [P] [US4] Add advisory portfolio synthesis and continuation assertions to `.highway/tools/tests/highway-nfr-onboarding.test.sh`
- [X] T022 [P] [US4] Add non-mutation and no-durable-portfolio-artifact assertions to `.highway/tools/tests/nfr-management.test.sh`

### Implementation for User Story 4

- [X] T023 [US4] Add advisory NFR portfolio assessment and queue-exhaustion synthesis to `.highway/skills/highway-nfrs/SKILL.md`
- [X] T024 [US4] Add post-assessment continuation for additional recommendations or another user-provided NFR without blocking, rejection, forced completion, or a new lifecycle stage in `.highway/skills/highway-nfrs/SKILL.md`

**Checkpoint**: Portfolio assessment informs the person while preserving NFR ownership and accepted baseline state.

---

## Phase 7: User Story 5 - Preserve NFR ownership and Control relationships (Priority: P1)

**Goal**: Remove Control-derived candidate-generation ownership while preserving NFR records, relationships, readiness, safeguards, and independent operation.

**Independent Test**: Run readiness, read-only, relationship, mutation, duplicate, overlap, destructive, generated-output, and routing checks with no pending candidate state.

### Tests for User Story 5

- [X] T025 [P] [US5] Update `.highway/tools/tests/control-derived-nfr.test.sh` to assert Controls are recommendation context only and no candidate state, artifact, lifecycle, or automatic persistence remains
- [X] T026 [P] [US5] Preserve `controls` relationship mapping and independent NFR ownership assertions in `.highway/tools/tests/nfr-management.test.sh` and `.highway/tools/tests/readiness-ownership.test.sh`
- [X] T027 [P] [US5] Validate readiness, read-only inspection, destructive safeguards, routing, output templates, and generated correspondence in `.highway/tools/tests/readiness-contract.test.sh`, `.highway/tools/tests/readiness-executable.test.sh`, `.highway/tools/tests/governance-routing.test.sh`, and `.highway/tools/tests/output-template.test.sh`

### Implementation for User Story 5

- [X] T028 [US5] Remove Control-derived NFR candidate-generation ownership and candidate-state assumptions from `.highway/skills/highway-nfrs/SKILL.md`
- [X] T029 [US5] Preserve NFR record fields, `controls` relationships, duplicate/overlap handling, readiness ownership, error handling, and destructive workflows while integrating the new interaction boundaries in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T030 [US5] Regenerate GitHub, Claude, Cursor, and Codex NFR adapters plus catalogs, manifests, and instructions with `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-instructions.sh`

**Checkpoint**: The authoritative NFR owner and every derived artifact contain no Control-derived candidate-state dependency, while existing records and accepted relationships remain unchanged.

---

## Phase 8: Polish & Cross-Cutting Validation

**Purpose**: Verify correspondence, requirement coverage, and regression safety across the repository.

- [X] T031 Run the complete focused validation set from `specs/172-nfr-alignment-refactor/quickstart.md` after implementation and regeneration
- [X] T032 Run `.highway/tools/tests/run-all.sh` and resolve only Feature 172 regressions in the affected NFR and generated surfaces
- [X] T033 Verify all Feature 172 requirements and success criteria against `.highway/skills/highway-nfrs/SKILL.md`, focused tests, generated artifacts, and `specs/172-nfr-alignment-refactor/quickstart.md`
- [X] T034 Run `git diff --check` and review repository status for unintended changes outside the Feature 172 source, tests, generated artifacts, and tasks/design records

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes baseline evidence.
- **Foundational (Phase 2)**: Depends on Setup and blocks user-story implementation.
- **User Stories (Phases 3-7)**: Depend on Foundational. US1, US2, US3, and US4 build the interaction model; US5 validates and preserves the ownership contract across all of them.
- **Polish (Phase 8)**: Depends on implementation, regeneration, and focused story checks.

### User Story Dependencies

- **US1**: Starts after Phase 2; defines recommendation exploration used by US2.
- **US2**: Starts after US1 recommendation boundaries are available; defines the queue used by US3.
- **US3**: Starts after US2 queue boundaries; defines capture and continuation used by US4.
- **US4**: Starts after US3 accepted portfolio state exists; remains advisory and does not change persistence.
- **US5**: Validation and preservation spans US1-US4 and must be completed before final regression validation.

### Parallel Opportunities

- T002, T004, and T005 can run in parallel after T001.
- T006-T007, T011-T012, T016-T017, T021-T022, and T025-T027 are parallel test updates when they touch independent assertion areas.
- T008-T010 can be split by recommendation behavior, internal coverage guidance, and exhaustion handling after T003-T005.
- T018-T020 can be split by proposal contract, lifecycle transitions, and continuation after the queue boundary is established.
- T030 must follow authoritative source edits but can run independently of final test review once all source changes are complete.

## Implementation Strategy

### MVP First

1. Complete Phase 1 and Phase 2.
2. Complete US1 recommendation exploration.
3. Validate US1 independently.
4. Continue through US2 and US3 for the minimum usable recommendation-to-capture workflow.

### Incremental Delivery

1. Add recommendation exploration and grounded exhaustion.
2. Add ordered queue construction and explicit processing.
3. Add proposal-first capture and continuation.
4. Add advisory portfolio assessment.
5. Complete ownership-preservation checks and regenerate every derived artifact.
6. Run focused and full regression validation.

### Final Validation Criteria

- Every task uses the required checkbox, sequential ID, optional `[P]` marker, story label where applicable, and an exact repository path.
- No task introduces a retained candidate field, candidate artifact, runtime dependency, or Control-owned NFR lifecycle.
- The authoritative NFR source, generated artifacts, focused tests, and full suite agree on the same recommendation, queue, proposal, acceptance, capture, relationship, readiness, and safeguard boundaries.