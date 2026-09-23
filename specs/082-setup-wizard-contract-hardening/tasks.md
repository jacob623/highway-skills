---

description: "Task list for Setup Wizard contract hardening"
---

# Tasks: Setup Wizard Contract Hardening

**Input**: Design documents from `/specs/082-setup-wizard-contract-hardening/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/setup-wizard.md`, and `quickstart.md`

**Tests**: Required by FR-010 and the repository's verification rules; static and executable evidence remain separate.

**Organization**: Tasks are grouped by user story and ordered so tests fail before the corresponding contract edits.

## Phase 1: Setup

**Purpose**: Confirm the Feature 081 source and validation surfaces before changing the contract.

- [X] T001 Inspect `.highway/skills/highway-setup/SKILL.md`, `.highway/tools/tests/highway-setup.test.sh`, and `.highway/tools/tests/highway-setup-executable.test.sh` for the existing Setup contract and focused test entry points.
- [X] T002 Record the passing baseline from `bash .highway/tools/tests/highway-setup.test.sh` and `bash .highway/tools/tests/highway-setup-executable.test.sh` before Feature 082 edits.

## Phase 2: Foundational

**Purpose**: Establish shared Feature 082 vocabulary and test fixtures before story-specific edits.

- [X] T003 [P] Add shared User Exit and Owner Outcome fixture values to `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T004 [P] Add shared static assertions for `Step` omission at completion, owner output ordering, outcome classification, expanded ownership scope, and Guided Setup entry to `.highway/tools/tests/highway-setup.test.sh`.
- [X] T005 Validate the new foundational assertions in `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh` fail against the unmodified Feature 081 Setup contract and record the expected red checkpoint.

**Checkpoint**: Shared vocabulary and test probes are ready; story implementation can begin.

## Phase 3: User Story 1 - Define Terminal Progress (Priority: P1) MVP

**Goal**: Make automatic advancement and completion-step visibility deterministic.

**Independent Test**: Run static and executable progress fixtures and verify fixed stage order, Guided Setup entry, and no numeric Step at completion.

### Tests for User Story 1

- [X] T006 [P] [US1] Add executable completion and first-incomplete-owner routing cases to `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T007 [P] [US1] Add static assertions for corrected automatic-advancement wording, `Current Stage: Complete`, and absent completion `Step` in `.highway/tools/tests/highway-setup.test.sh`.
- [X] T008 [US1] Run `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh` and confirm the US1 assertions fail before implementation changes.

### Implementation for User Story 1

- [X] T009 [US1] Correct automatic-advancement wording and completion-step semantics in `.highway/skills/highway-setup/SKILL.md`.
- [X] T010 [US1] Replace legacy readiness stop wording with Guided Setup entry language in the ordered readiness rules of `.highway/skills/highway-setup/SKILL.md`.
- [X] T011 [US1] Run `bash .highway/tools/tests/highway-setup.test.sh` and `bash .highway/tools/tests/highway-setup-executable.test.sh` and confirm US1 passes.

**Checkpoint**: Terminal progress and first-incomplete-owner behavior are independently testable.

## Phase 4: User Story 2 - Preserve Owner Meaning and Authority (Priority: P1)

**Goal**: Make owner output ordering, classification, and mutation ownership directly verifiable.

**Independent Test**: Feed multi-message owner responses and every User Exit/Owner Outcome class, then verify byte/order preservation and no Setup-owned mutation.

### Tests for User Story 2

- [X] T012 [P] [US2] Add executable multi-message output-order and byte-preservation fixtures to `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T013 [P] [US2] Add executable User Exit/Owner Outcome classification cases and downstream short-circuit checks to `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T014 [P] [US2] Add static verification assertions for identifiers, catalogs, owner artifacts, candidate state, relationship state, and owning-workflow mutation authority to `.highway/tools/tests/highway-setup.test.sh`.
- [X] T015 [US2] Run `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh` and confirm the US2 assertions fail before implementation changes.

### Implementation for User Story 2

- [X] T016 [US2] Add explicit multi-message ordering verification and deterministic User Exit/Owner Outcome classification language to `.highway/skills/highway-setup/SKILL.md`.
- [X] T017 [US2] Expand ownership verification language to cover identifiers, catalogs, owner artifacts, candidates, relationships, and owner-originated mutations in `.highway/skills/highway-setup/SKILL.md`.
- [X] T018 [US2] Run `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh` and confirm US2 passes with static and executable evidence separated.

**Checkpoint**: Owner content and mutation authority are independently testable.

## Phase 5: User Story 3 - Resume Without Hidden State (Priority: P1)

**Goal**: Make user exits, owner outcomes, and readiness-based resume boundaries explicit and testable.

**Independent Test**: Interrupt collection at each stage, inspect fixture state, invoke Setup again, and verify the first incomplete owner is selected without wizard persistence.

### Tests for User Story 3

- [X] T019 [P] [US3] Add executable pause, cancel, stop-responding, and resume fixtures to `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T020 [P] [US3] Add static assertions for absent owner collection state, unanswered questions, drafts, cancellation markers, and wizard checkpoints to `.highway/tools/tests/highway-setup.test.sh`.
- [X] T021 [US3] Run `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh` and confirm the US3 assertions fail before implementation changes.

### Implementation for User Story 3

- [X] T022 [US3] Add explicit transient-state, user-exit terminology, and readiness-based resume contract language to `.highway/skills/highway-setup/SKILL.md`.
- [X] T023 [US3] Run `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh` and confirm US3 passes without changing owner artifact authority.

**Checkpoint**: All three user stories are independently testable.

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Reconcile documentation, regenerate derived outputs, and validate the complete repository.

- [X] T024 [P] Update `specs/082-setup-wizard-contract-hardening/contracts/setup-wizard.md`, `data-model.md`, and `quickstart.md` if the final source wording requires reconciliation.
- [X] T025 Regenerate `.highway/catalog/` and generated Setup adapters with `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh`.
- [X] T026 Run `bash .highway/tools/tests/adapter-coverage.test.sh` and verify generated outputs are current.
- [X] T027 Run `.highway/tools/tests/run-all.sh`, focused Setup tests, and `git diff --check`; record requirement coverage separately from check results.
- [X] T028 Verify `.highway/tools/.distribution-manifest` is unchanged and shipped files contain no `.specify/` or `specs/` references.
- [X] T029 Mark all completed tasks `[X]` in `specs/082-setup-wizard-contract-hardening/tasks.md` and report final validation results.

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the baseline.
- **Foundational (Phase 2)**: Depends on Setup and blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational; MVP progress contract.
- **User Story 2 (Phase 4)**: Depends on Foundational; can proceed after US1's test harness is available.
- **User Story 3 (Phase 5)**: Depends on Foundational and the active Setup contract; follows US1/US2 for coherent resume semantics.
- **Polish (Phase 6)**: Depends on all user stories.

### User Story Dependencies

- **US1**: No story dependency after Foundational.
- **US2**: Uses the shared owner-response fixtures and active routing established by Foundational/US1.
- **US3**: Uses the active routing and owner-boundary vocabulary established by US1/US2.

### Parallel Opportunities

- T003 and T004 can run in parallel because they edit different focused test files.
- T006 and T007 can run in parallel because they edit different focused test files.
- T012, T013, and T014 can run in parallel only when coordinated carefully; T012 and T013 share one file and must be serialized with each other.
- T019 and T020 can run in parallel because they edit different focused test files.
- T024 and T025 can run in parallel only after source wording is final; generated outputs must follow source reconciliation.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete US1 progress contract and validate it independently.
3. Stop at the US1 checkpoint for reviewable MVP evidence.

### Incremental Delivery

1. Add US2 owner-output and ownership evidence.
2. Add US3 transient-state and resume evidence.
3. Reconcile design docs, regenerate adapters/catalogs, and run the full suite.
4. Report test results separately from requirement coverage.
