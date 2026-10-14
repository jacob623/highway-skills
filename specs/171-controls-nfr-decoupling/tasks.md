---

description: "Implementation tasks for Controls NFR Decoupling"
---

# Tasks: Controls NFR Decoupling

**Input**: Design documents from `specs/171-controls-nfr-decoupling/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Scope**: Remove Control-derived NFR candidate generation and state. Direct NFR recommendation and development remain follow-on work.

## Phase 1: Setup

**Purpose**: Establish the baseline and identify every active candidate-state dependency before source edits.

- [X] T001 Run the current repository suite and record the baseline result in the implementation notes using `.highway/tools/tests/run-all.sh`
- [X] T002 [P] Audit candidate-generation and candidate-state references across `.highway/skills/`, `.highway/catalog/`, `.highway/tools/tests/`, `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/` with `rg`
- [X] T003 [P] Verify `specs/171-controls-nfr-decoupling/checklists/requirements.md` remains 16/16 complete and review `specs/171-controls-nfr-decoupling/quickstart.md`

## Phase 2: Foundational

**Purpose**: Establish the ownership and preservation rules required by every story.

- [X] T004 Document the retained Control/NFR record and relationship boundaries in `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-nfrs/SKILL.md` without changing accepted records
- [X] T005 [P] Compare `.highway/skills/highway-controls/SKILL.md` with the Objectives contract and identify the proposal-first lifecycle that must remain
- [X] T006 [P] Identify generator entry points and derived outputs affected by source changes in `.highway/tools/`, `.highway/catalog/`, `.github/`, `.claude/`, `.cursor/`, and `.agents/`

## Phase 3: User Story 1 - Controls own only Control governance (Priority: P1) - MVP

**Goal**: Controls completes recommendation, development, acceptance, capture, persistence, readiness, and continuation without invoking or reporting NFR candidate generation.

**Independent Test**: Exercise Control recommendation, proposal, acceptance, capture, continuation, readiness, and failure paths while verifying that no NFR candidate action, result, lifecycle, blocking reason, or recovery state is required.

### Tests for User Story 1

- [X] T007 [P] [US1] Update Control-derived behavior assertions in `.highway/tools/tests/control-derived-nfr.test.sh` to prove Control capture succeeds without candidate generation
- [X] T008 [P] [US1] Update Control onboarding and readiness assertions in `.highway/tools/tests/highway-controls-onboarding.test.sh` to prove outputs contain only Control collection/readiness state
- [X] T009 [US1] Add explicit Control candidate-state absence checks in `.highway/tools/tests/control-derived-nfr.test.sh` for success, continuation, and failure paths

### Implementation for User Story 1

- [X] T010 [US1] Remove Control-derived NFR candidate-generation inputs, invocation, result handling, blocking, recovery, and completion language from `.highway/skills/highway-controls/SKILL.md`
- [X] T011 [US1] Preserve the Objectives-aligned recommendation-first Control lifecycle, selection/acceptance boundary, user-authored alternative, persistence, and continuation behavior in `.highway/skills/highway-controls/SKILL.md`
- [X] T012 [US1] Remove obsolete Control-to-NFR candidate-generation references from `.highway/skills/highway-controls/SKILL.md` while retaining accepted Control/NFR relationship semantics

**Checkpoint**: Control workflows are independently coherent and no longer depend on candidate generation.

## Phase 4: User Story 2 - NFRs remain independent of Control candidate state (Priority: P1)

**Goal**: NFR workflow, readiness, verification, and errors remain independently invocable without Control-originated candidate state.

**Independent Test**: Invoke NFR behavior with no candidate artifact, pending candidates, candidate recovery, or originating Control input and verify readiness/workflow remains coherent.

### Tests for User Story 2

- [X] T013 [P] [US2] Replace candidate-state assumptions with independent NFR readiness and workflow assertions in `.highway/tools/tests/nfr-management.test.sh`
- [X] T014 [P] [US2] Update Setup/NFR routing assertions in `.highway/tools/tests/highway-setup-onboarding.test.sh` and `.highway/tools/tests/governance-routing.test.sh` to prove no candidate prerequisite exists
- [X] T015 [US2] Add a retained-record regression check in `.highway/tools/tests/nfr-management.test.sh` proving existing NFR and Control relationships are not silently rewritten

### Implementation for User Story 2

- [X] T016 [US2] Remove candidate-state inputs, ownership, durable recovery, pending review, candidate readiness, and candidate-specific errors from `.highway/skills/highway-nfrs/SKILL.md`
- [X] T017 [US2] Remove candidate-generation routing, completion, blocking, and readiness dependencies from `.highway/skills/highway-setup/SKILL.md`
- [X] T018 [US2] Remove `.highway/catalog/nfr-candidate-state.md` and update all authoritative catalog/library references that require its presence
- [X] T019 [US2] Preserve independent NFR persistence, readiness, validation, relationship, and user-authored behavior in `.highway/skills/highway-nfrs/SKILL.md` without adding direct NFR recommendation scope

**Checkpoint**: NFR and Setup behavior remains coherent with the candidate artifact absent.

## Phase 5: User Story 3 - Controls align structurally with Objectives (Priority: P2)

**Goal**: Controls retain a predictable recommendation-first lifecycle parallel to Objectives while preserving Control-specific semantics.

**Independent Test**: Compare representative Objectives and Controls flows and verify recommendation, development, acceptance, capture, user-authored alternatives, and continuation remain separate steps.

### Tests for User Story 3

- [X] T020 [P] [US3] Update proposal-first Controls interaction assertions in `.highway/tools/tests/highway-controls-onboarding.test.sh` to cover recommendation, proposal, acceptance, capture, and continuation
- [X] T021 [US3] Add or update cross-owner lifecycle comparison assertions in `.highway/tools/tests/governance-routing.test.sh` for Objectives-to-Controls structural alignment

### Implementation for User Story 3

- [X] T022 [US3] Reconcile Controls lifecycle wording and output boundaries with the Objectives interaction model in `.highway/skills/highway-controls/SKILL.md`
- [X] T023 [US3] Ensure Control selection remains distinct from explicit acceptance and capture in `.highway/skills/highway-controls/SKILL.md`
- [X] T024 [US3] Ensure Control continuation and user-authored safeguard paths remain available after capture in `.highway/skills/highway-controls/SKILL.md`

**Checkpoint**: Controls and Objectives expose equivalent lifecycle boundaries without conflating domain semantics.

## Phase 6: User Story 4 - Repository artifacts remain coherent after removal (Priority: P2)

**Goal**: Source, tests, catalogs, manifests, adapters, and distributed instructions agree that candidate generation no longer exists.

**Independent Test**: Scan governed ownership surfaces, regenerate derived outputs, verify the candidate-state artifact is absent, and run the complete suite.

### Tests for User Story 4

- [X] T025 [P] [US4] Add candidate-generation absence and orphan detection checks to the relevant `.highway/tools/tests/` correspondence and catalog tests
- [X] T026 [P] [US4] Update generated artifact expectations in `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/generate-catalog.test.sh`, and related tests for candidate-state removal
- [X] T027 [US4] Run repository-wide candidate reference scans across `.highway/`, `.github/`, `.claude/`, `.cursor/`, and `.agents/` and make the scan pass with no active stale references

### Implementation for User Story 4

- [X] T028 [US4] Remove orphaned candidate-state entries from authoritative catalogs, manifests, and shared library indexes under `.highway/`
- [X] T029 [US4] Regenerate distributed skill adapters with `.highway/tools/generate-agent-adapters.sh` from authoritative `.highway/skills/` sources
- [X] T030 [US4] Regenerate catalogs and manifests with the repository's existing `.highway/tools/generate-*.sh` entry points
- [X] T031 [US4] Verify generated `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, `.agents/skills/`, `.highway/catalog/`, and instruction artifacts contain no stale candidate-generation ownership references

**Checkpoint**: Source-first correspondence is restored and no generated artifact advertises the removed lifecycle.

## Phase 7: Polish and Cross-Cutting Validation

- [X] T032 [P] Run `git diff --check` and review the Feature 171 diff for unrelated changes
- [X] T033 [P] Revalidate `specs/171-controls-nfr-decoupling/checklists/requirements.md` and map FR-001 through FR-014 to completed implementation evidence
- [X] T034 Run `.highway/tools/tests/run-all.sh` and record the final zero-failure result
- [X] T035 Run the scenarios in `specs/171-controls-nfr-decoupling/quickstart.md` and confirm the candidate-state artifact is absent
- [X] T036 Mark all completed tasks in `specs/171-controls-nfr-decoupling/tasks.md` and report requirement coverage separately from test results

## Dependencies and Execution Order

- Phase 1 precedes all implementation work.
- Phase 2 establishes preservation and generator boundaries before User Stories 1-4.
- User Stories 1 and 2 are both P1; they may proceed in parallel after Phase 2, but shared reference scans and regeneration should wait until both source slices are complete.
- User Story 3 depends on the Controls contract changes in User Story 1.
- User Story 4 depends on the source and test changes from User Stories 1-3 before regeneration.
- Phase 7 follows all story checkpoints.

## Parallel Execution Examples

- After Phase 2: T007/T008, T013/T014, and T020/T021 can run in parallel when they touch separate test files.
- After the corresponding tests are scoped: T010/T016/T017 can proceed in parallel because they own separate authoritative skill files.
- During artifact work: T025/T026 can proceed in parallel before T029/T030.

## Implementation Strategy

1. Establish the baseline and ownership boundaries.
2. Deliver the MVP by decoupling Controls and proving Control-only behavior.
3. Decouple NFRs and Setup, then verify independent readiness and retained-record behavior.
4. Reconfirm Controls/Objectives structural alignment.
5. Remove the artifact, regenerate every derived surface, and run focused plus full validation.
