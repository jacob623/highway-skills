# Tasks: Feature Completeness and Behavioral Evidence Enforcement

**Input**: Design documents from `/specs/032-feature-completeness-enforcement/`
**Prerequisites**: plan.md, research.md, data-model.md, contracts/behavioral-evidence.md, quickstart.md

## Phase 1: Setup

- [X] T001 Record the passing pre-change suite result and repository status in `specs/032-feature-completeness-enforcement/test-evidence.md`
- [X] T002 [P] Record the Feature 032 requirement-to-artifact scope and evidence categories in `specs/032-feature-completeness-enforcement/contracts/behavioral-evidence.md`
- [X] T003 [P] Add the Feature 032 fixture and disposable-tree conventions to `specs/032-feature-completeness-enforcement/data-model.md`

## Phase 2: Foundational

- [X] T004 Define the coverage-row grammar, evidence statuses, and deferred-outcome rules in `specs/032-feature-completeness-enforcement/data-model.md`
- [X] T005 Define the atomic operation snapshot, failure-injection, cleanup, duplicate, and impact contracts in `specs/032-feature-completeness-enforcement/contracts/behavioral-evidence.md`
- [X] T006 Add shared disposable-tree setup, snapshot, byte-comparison, and cleanup helpers to `.highway/tools/tests/feature-completeness-common.sh`
- [X] T007 Add representative valid, invalid, asymmetric, orphaned, duplicate, direct-NFR, and preservation fixture records under `.highway/tools/tests/fixtures/feature-completeness/`
- [X] T008 Observe the current static-test limitation and record the failing behavioral assertions before implementation in `specs/032-feature-completeness-enforcement/test-evidence.md`

## Phase 3: User Story 1 - Record Complete Requirement Coverage (Priority: P1)

**Goal**: Restore exact, honest requirement coverage for Features 030 and 031.

**Independent Test**: Run `.highway/tools/tests/completion-coverage.test.sh` and verify that every historical functional requirement has exactly one coverage row with accurate evidence status.

- [X] T009 [US1] Create the 16-row Feature 030 coverage mapping in `specs/030-control-derived-nfr-generation/coverage.md`
- [X] T010 [US1] Create the 20-row Feature 031 coverage mapping in `specs/031-relationship-reconciliation-integrity/coverage.md`
- [X] T011 [US1] Validate coverage outcomes and explicit deferred evidence with `.highway/tools/tests/completion-coverage.test.sh`
- [X] T012 [US1] Exercise the existing missing-row, duplicate-row, unknown-row, and documentation-only coverage fixtures in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T013 [US1] Run the focused coverage test and record the restored no-missing-coverage result in `specs/032-feature-completeness-enforcement/test-evidence.md`

## Phase 4: User Story 2 - Verify Control-derived NFR Behavior (Priority: P1)

**Goal**: Replace Feature 030 phrase checks with executable candidate, review, allocation, relationship, preservation, and failure validation.

**Independent Test**: Run `.highway/tools/tests/control-derived-nfr.test.sh` against disposable baselines and verify deterministic proposals, all review decisions, accepted reciprocal writes, and zero-write failure paths.

- [X] T014 [P] [US2] Use deterministic candidate-generation baselines and expected proposal outputs from `.highway/tools/tests/fixtures/control-derived-nfr/`
- [X] T015 [P] [US2] Exercise accepted, rejected, cancelled, no-candidate, and invalid-baseline decision cases in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T016 [US2] Implement disposable-tree candidate generation and proposal-order assertions in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T017 [US2] Implement Accept, Modify, Replace, Reject, and Cancel execution cases with explicit write-set assertions in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T018 [US2] Implement accepted NFR allocation and two-sided identifier-only relationship assertions in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T019 [US2] Implement direct-NFR `controls: []`, no-candidate, invalid-baseline, and unrelated-byte preservation cases in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T020 [US2] Implement allocation and commit failure injection with exact record/catalog restoration assertions in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T021 [US2] Add repeated-run byte-identical proposal and approved-output assertions in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T022 [US2] Run the focused Feature 030 test and record red-to-green evidence plus cleanup results in `specs/032-feature-completeness-enforcement/test-evidence.md`

## Phase 5: User Story 3 - Verify Relationship Integrity Behavior (Priority: P1)

**Goal**: Replace Feature 031 phrase checks with executable inspection, repair, impact, determinism, and atomicity validation.

**Independent Test**: Run `.highway/tools/tests/relationship-integrity.test.sh` against disposable graph baselines and verify classifications, proposals, decisions, impact output, and exact rollback.

- [X] T023 [P] [US3] Use valid, asymmetric, orphaned, malformed, duplicate, blocked, and direct-NFR graph fixtures from `.highway/tools/tests/fixtures/relationship-integrity/`
- [X] T024 [P] [US3] Use removal and explicit proposed-baseline replacement fixtures from `.highway/tools/tests/fixtures/relationship-integrity/`
- [X] T025 [US3] Implement graph parsing and deterministic classification assertions in `.highway/tools/tests/relationship-integrity.test.sh`
- [X] T026 [US3] Implement repair proposal shape assertions for artifact, current state, proposed state, reason, and impact in `.highway/tools/tests/relationship-integrity.test.sh`
- [X] T027 [US3] Implement read-only, approve, reject, cancel, incomplete, and independent-subset decision cases in `.highway/tools/tests/relationship-integrity.test.sh`
- [X] T028 [US3] Implement reciprocal-add, orphan-remove, duplicate-normalization, direct-NFR, and non-relationship preservation assertions in `.highway/tools/tests/relationship-integrity.test.sh`
- [X] T029 [US3] Implement validation, staging, and commit failure injection with exact record/catalog restoration assertions in `.highway/tools/tests/relationship-integrity.test.sh`
- [X] T030 [US3] Implement removal and baseline-replacement impact analysis assertions for individually listed IDs, titles, edges, empty impact, and declined confirmation in `.highway/tools/tests/relationship-integrity.test.sh`
- [X] T031 [US3] Add repeated-run byte-identical report, proposal, ordering, and approved-output assertions in `.highway/tools/tests/relationship-integrity.test.sh`
- [X] T032 [US3] Run the focused Feature 031 test and record red-to-green evidence plus cleanup results in `specs/032-feature-completeness-enforcement/test-evidence.md`

## Phase 6: User Story 4 - Align Completion Claims and Contracts (Priority: P2)

**Goal**: Make status, task checkboxes, coverage outcomes, and test evidence agree.

**Independent Test**: Review Features 030 and 031 after behavioral validation and run completion coverage; no feature may claim complete behavior without passing evidence.

- [X] T033 [US4] Verify Feature 030 status and completion wording against its coverage and behavioral evidence in `specs/030-control-derived-nfr-generation/spec.md`
- [X] T034 [US4] Verify Feature 031 status and completion wording against its coverage and behavioral evidence in `specs/031-relationship-reconciliation-integrity/spec.md`
- [X] T035 [US4] Verify Feature 030 task completion claims name the executable artifacts and evidence in `specs/030-control-derived-nfr-generation/tasks.md`
- [X] T036 [US4] Verify Feature 031 task completion claims name the executable artifacts and evidence in `specs/031-relationship-reconciliation-integrity/tasks.md`
- [X] T037 [US4] Verify Feature 030 and 031 coverage records distinguish behavioral, structural, documentation-only, and deferred outcomes in `specs/030-control-derived-nfr-generation/coverage.md` and `specs/031-relationship-reconciliation-integrity/coverage.md`
- [X] T038 [US4] Record the final lifecycle consistency assessment and requirement coverage summary in `specs/032-feature-completeness-enforcement/test-evidence.md`

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T039 [P] Verify the runnable validation steps and expected outcomes in `specs/032-feature-completeness-enforcement/quickstart.md`
- [X] T040 [P] Verify requirement-to-task traceability notes for all Feature 032 FRs in `specs/032-feature-completeness-enforcement/data-model.md`
- [X] T041 Run the focused Feature 030, Feature 031, and completion-coverage tests using the documented commands in `specs/032-feature-completeness-enforcement/quickstart.md`
- [X] T042 Run the full repository suite with `.highway/tools/tests/run-all.sh` and record the result in `specs/032-feature-completeness-enforcement/test-evidence.md`
- [X] T043 Verify no temporary probes remain and unrelated user-owned records/catalogs are byte-identical in `.highway/tools/tests/feature-completeness-common.sh`
- [X] T044 Run `git diff --check` and perform a final D7.1-D7.3 review against `specs/032-feature-completeness-enforcement/plan.md`

## Dependencies & Execution Order

### Phase Dependencies

1. Setup (Phase 1) precedes all other phases.
2. Foundational (Phase 2) depends on Setup and blocks all user stories.
3. User Story 1 can begin after T004; it is independent of the behavioral workflow stories.
4. User Story 2 depends on T005-T008 and its own Feature 030 fixtures.
5. User Story 3 depends on T005-T008 and its own Feature 031 fixtures; it can proceed in parallel with User Story 2.
6. User Story 4 depends on User Stories 1-3 because status and task claims must reflect observed evidence.
7. Polish depends on User Story 4 and the completion of all focused behavioral checks.

### User Story Completion Order

```text
Setup -> Foundational -> {US1, US2, US3} -> US4 -> Polish
```

### Parallel Opportunities

1. T002 and T003 can run in parallel after T001.
2. T009 and T010 can run in parallel after T004.
3. T014 and T015 can run in parallel; T023 and T024 can run in parallel.
4. User Story 2 and User Story 3 can be implemented and tested in parallel after foundational work.
5. T039 and T040 can run in parallel after User Story 4.

## Implementation Strategy

### MVP Scope

Complete User Story 1 first: add the two coverage records and make completion coverage report no missing
requirements. This removes the immediate D7.2 gap while preserving honest behavioral limitations.

### Incremental Delivery

1. Establish baseline and shared evidence contracts.
2. Restore exact coverage records.
3. Implement and validate Feature 030 behavior.
4. Implement and validate Feature 031 behavior.
5. Reconcile lifecycle/task language and run the complete validation surface.

Every phase ends with its independent test and evidence update before the next dependent phase begins.
