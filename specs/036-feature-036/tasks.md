# Tasks: Strengthen Feature 035 Behavioral Evidence

**Input**: Design documents from `/specs/036-feature-036/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Included because this feature explicitly requires executable behavioral evidence and independent verification for each user story.

## Phase 1: Setup

**Purpose**: Establish the baseline and shared fixture locations before changing Feature 035 evidence.

- [X] T001 Record the current repository baseline and focused Feature 035 commands in `specs/036-feature-036/quickstart.md`
- [X] T002 [P] Inspect existing Profile, Setup, helper, and Feature 035 fixture surfaces and record their implementation paths in `specs/036-feature-036/research.md`
- [X] T003 [P] Add the Feature 036 evidence categories and requirement traceability outline to `specs/036-feature-036/quickstart.md`

## Phase 2: Foundational

**Purpose**: Provide reusable assertions, temporary-file cleanup, and candidate-result inputs for all user stories.

- [X] T004 Extend deterministic byte, status, no-write, and no-artifact assertions in `.highway/tools/tests/test-helpers.sh`
- [X] T005 [P] Define isolated Profile fixture records and observed evidence fields in `.highway/tools/tests/fixtures/feature-035/README.md`
- [X] T006 [P] Define candidate-result fixture inputs without expected-status labels in `.highway/tools/tests/highway-setup.test.sh`
- [X] T007 Add failing-before-passing execution notes and the shared fixture cleanup contract to `specs/036-feature-036/quickstart.md`

**Checkpoint**: Shared assertions and fixture inputs are available; each user story can now be implemented and validated independently.

## Phase 3: User Story 1 - Prove Profile behavior with executable fixtures (Priority: P1) 🎯 MVP

**Goal**: Replace Profile contract-text confidence with executable absent, empty, whitespace-only, valid, declined, malformed, and repeated-input behavior evidence.

**Independent Test**: Run `.highway/tools/tests/profile-behavior.test.sh` and the focused Profile validators; verify observed status, write/no-write behavior, byte preservation, supplied identity content, and three-run determinism.

### Tests for User Story 1

- [X] T008 [P] [US1] Add executable fixture setup for absent, empty, whitespace-only, valid, declined, and malformed Profile inputs in `.highway/tools/tests/profile-behavior.test.sh`
- [X] T009 [P] [US1] Add assertions for observed readiness status, write/no-write behavior, and before/after bytes in `.highway/tools/tests/profile-behavior.test.sh`
- [X] T010 [US1] Add three repeated valid-input runs and compare resulting Profile bytes and status in `.highway/tools/tests/profile-behavior.test.sh`
- [X] T011 [US1] Add assertions that valid output contains the supplied organization name without inferred values in `.highway/tools/tests/profile-behavior.test.sh`

### Implementation for User Story 1

- [X] T012 [US1] Implement the fixture execution path against isolated temporary Profile artifacts in `.highway/tools/tests/profile-behavior.test.sh`
- [X] T013 [US1] Preserve static contract assertions as a separately reported evidence category in `.highway/tools/tests/profile-structure.test.sh`
- [X] T014 [US1] Document Profile executable results, static checks, and remaining limitations in `specs/036-feature-036/quickstart.md`

**Checkpoint**: User Story 1 independently proves all seven Profile fixture categories and deterministic valid-input behavior.

## Phase 4: User Story 2 - Prove Setup rejects invalid workflow variants (Priority: P1)

**Goal**: Validate the canonical Setup workflow and temporary missing, duplicate, non-sequential, and dangling-reference variants without mutating canonical bytes.

**Independent Test**: Run `.highway/tools/tests/highway-setup.test.sh`; verify the canonical ten-step workflow passes, every malformed variant fails with a concrete defect, and the canonical hash is unchanged.

### Tests for User Story 2

- [X] T015 [P] [US2] Parameterize workflow extraction and structural validation to accept a supplied temporary workflow path in `.highway/tools/tests/highway-setup.test.sh`
- [X] T016 [P] [US2] Add temporary missing-step and duplicate-step workflow variants in `.highway/tools/tests/highway-setup.test.sh`
- [X] T017 [P] [US2] Add temporary non-sequential-step and dangling-reference variants in `.highway/tools/tests/highway-setup.test.sh`
- [X] T018 [US2] Assert canonical workflow byte preservation after all malformed variant checks in `.highway/tools/tests/highway-setup.test.sh`

### Implementation for User Story 2

- [X] T019 [US2] Make each workflow variant report the invalid step or reference while returning failure in `.highway/tools/tests/highway-setup.test.sh`
- [X] T020 [US2] Confirm numbered workflow and reference expectations remain documented in `.highway/skills/highway-setup/SKILL.md`
- [X] T021 [US2] Record canonical and malformed workflow evidence separately from static Setup contract checks in `specs/036-feature-036/quickstart.md`

**Checkpoint**: User Story 2 independently proves canonical success, four malformed failures, and canonical artifact preservation.

## Phase 5: User Story 3 - Drive NFR outcomes from candidate results (Priority: P1)

**Goal**: Derive NFR and Setup outcomes from candidate-result data, including terminal zero-candidate completion and blocked unavailable/malformed paths.

**Independent Test**: Run the candidate-result matrix in `.highway/tools/tests/highway-setup.test.sh`; verify six defined categories, no fabricated artifacts, and three-run repeatability.

### Tests for User Story 3

- [X] T022 [P] [US3] Implement one candidate-result decision function that consumes generation state, count, proposal state, and accepted artifacts in `.highway/tools/tests/highway-setup.test.sh`
- [X] T023 [P] [US3] Add zero-candidate, available-pending, and accepted candidate-result fixtures in `.highway/tools/tests/highway-setup.test.sh`
- [X] T024 [P] [US3] Add unavailable, malformed, and contradictory candidate-result fixtures in `.highway/tools/tests/highway-setup.test.sh`
- [X] T025 [US3] Assert `NFRs: Not Applicable`, terminal Setup completion, and zero artifacts for repeated zero-candidate runs in `.highway/tools/tests/highway-setup.test.sh`
- [X] T026 [US3] Assert blocked outcomes, no fabricated artifacts, pending routing, and accepted completion from candidate-result data in `.highway/tools/tests/highway-setup.test.sh`

### Implementation for User Story 3

- [X] T027 [US3] Remove direct fixture-label-to-status assignments and route all NFR assertions through the candidate-result decision function in `.highway/tools/tests/highway-setup.test.sh`
- [X] T028 [US3] Reject contradictory zero-count results containing candidate entries as malformed in `.highway/tools/tests/highway-setup.test.sh`
- [X] T029 [US3] Record candidate-result evidence, repeatability, and remaining routing limitations in `specs/036-feature-036/quickstart.md`

**Checkpoint**: User Story 3 independently proves all six candidate-result categories and zero-artifact repeatability.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Correct Feature 035 development records, validate generated artifacts, and report evidence by type.

- [X] T030 [P] Update the Feature 035 source/test/fixture tree in `specs/035-profile-setup-readiness/plan.md`
- [X] T031 [P] Update the Feature 035 generator instructions with a disposable target-directory argument in `specs/035-profile-setup-readiness/quickstart.md`
- [X] T032 [P] Add the executable generator command and target-directory guidance to `specs/036-feature-036/quickstart.md`
- [X] T033 Run the distribution generator against a disposable target and record the result without modifying `.highway/tools/.distribution-manifest` in `specs/036-feature-036/quickstart.md`
- [X] T034 [P] Run Profile and Setup validators and focused tests, recording executable versus static results in `specs/036-feature-036/quickstart.md`
- [X] T035 Run adapter correspondence, generated-artifact integrity, and the full suite, recording separate results in `specs/036-feature-036/quickstart.md`
- [X] T036 Verify requirement and success-criteria coverage exactly once and run `git diff --check` for Feature 036 records in `specs/036-feature-036/quickstart.md`

## Dependencies

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes baseline and evidence scope.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user stories because shared helpers and fixture records are required.
- **User Stories (Phases 3-5)**: Depend on Foundational completion and can proceed in parallel after shared helpers exist.
- **Polish (Phase 6)**: Depends on all three user stories passing their independent tests.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Phase 2; no dependency on other stories.
- **User Story 2 (P1)**: Starts after Phase 2; uses the shared helper but tests the Setup workflow independently.
- **User Story 3 (P1)**: Starts after Phase 2; uses the Setup test surface but derives outcomes independently from candidate-result inputs.

### Dependency Graph

```text
Phase 1 -> Phase 2
Phase 2 -> US1
Phase 2 -> US2
Phase 2 -> US3
US1 -> Phase 6
US2 -> Phase 6
US3 -> Phase 6
```

## Parallel Opportunities

### Setup and Foundation

```text
T002 || T003
T005 || T006
```

### User Story 1

```text
T008 || T009
T010 || T011
T012 -> T014
```

### User Story 2

```text
T015 || T016 || T017
T018 -> T019 -> T021
```

### User Story 3

```text
T022 || T023 || T024
T025 || T026
T027 -> T028 -> T029
```

### Polish

```text
T030 || T031 || T032 || T034
T033 -> T035 -> T036
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement executable Profile fixtures and observed evidence.
3. Run the User Story 1 independent test and record the result.
4. Stop at the MVP checkpoint before extending Setup workflow and NFR routing coverage.

### Incremental Delivery

1. Complete Setup plus Foundational to establish the evidence harness.
2. Deliver User Story 1 and validate it independently.
3. Deliver User Story 2 and validate canonical and malformed workflow variants.
4. Deliver User Story 3 and validate candidate-result-driven NFR routing.
5. Complete documentation, distribution, generated-artifact, and full-suite validation.

## Traceability Summary

- FR-001 through FR-003: T008-T014
- FR-004 through FR-006: T015-T021
- FR-007 through FR-011: T022-T029
- FR-012 through FR-014: T030-T036
- SC-001: T008-T014
- SC-002: T015-T021
- SC-003 and SC-004: T022-T029
- SC-005 through SC-007: T030-T036
