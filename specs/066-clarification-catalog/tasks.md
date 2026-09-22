# Tasks: Clarification Catalog (Phase 1)

**Input**: Design documents from `/specs/066-clarification-catalog/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/clarification-catalog-contract.md, quickstart.md

## Implementation Strategy

Deliver the catalog as an MVP in User Story 1: establish the shared template, catalog file shape, stable identity mapping, and deterministic ordering. Add status synchronization in User Story 2, then integrity and failure-path enforcement in User Story 3. Finish by regenerating derived adapters and running the complete validation suite. Tests are included because the specification requires focused verification for deterministic ordering, synchronization, duplicate rejection, and no-write failure behavior.

## Dependencies

- Phase 1 Setup tasks precede all other work.
- Phase 2 Foundational tasks precede all user stories.
- User Story 1 is the MVP and must complete before User Stories 2 and 3.
- User Story 2 and User Story 3 depend on the catalog structure and row identity established by User Story 1; they can otherwise be implemented in parallel after US1.
- Phase 7 Polish depends on all three user stories.

## Phase 1: Setup

- [X] T001 Confirm the Feature 066 source, design, contract, and validation paths in `specs/066-clarification-catalog/plan.md`
- [X] T002 [P] Record the existing Clarify output and catalog conventions in `specs/066-clarification-catalog/research.md`
- [X] T003 [P] Confirm the disposable-fixture and Bash 3.2.57 testing conventions in `.highway/tools/tests/highway-clarify.test.sh`

## Phase 2: Foundational

- [X] T004 Define the complete Clarification catalog template skeleton in `.highway/library/templates/output/clarification-catalog.md`
- [X] T005 Define catalog row fields, relationships, lifecycle, and invariants in `specs/066-clarification-catalog/data-model.md`
- [X] T006 [P] Add the catalog input/output and transaction contract to `.highway/skills/highway-clarify/SKILL.md`
- [X] T007 [P] Add catalog command behavior and validation cases to `specs/066-clarification-catalog/contracts/clarification-catalog-contract.md`
- [X] T008 Add the Clarification catalog template and existing catalog artifact to the `Inputs` section of `.highway/skills/highway-clarify/SKILL.md`
- [X] T009 Add the maintained catalog, ownership boundaries, and no-write failure guarantees to the `Outputs` and `Error Handling` sections of `.highway/skills/highway-clarify/SKILL.md`

## Phase 3: User Story 1 - Discover Clarifications by Stable Identifier (Priority: P1)

**Goal**: Create or update `clarifications/clarifications.md` with exactly one deterministic row for each valid clarification.

**Independent Test Criteria**: Generate a valid clarification in a disposable repository with no catalog, then verify catalog creation, `CLAR-<ARTIFACT-ID>` identity, required columns, and deterministic ordering across multiple artifact types.

- [ ] T010 [P] [US1] Add a focused fixture for first-catalog creation and single-entry generation in `.highway/tools/tests/fixtures/highway-clarify/catalog-first-entry/`
- [ ] T011 [P] [US1] Add a focused fixture set for `REQ`, `DISC`, `ADR`, and `RA` catalog rows in `.highway/tools/tests/fixtures/highway-clarify/catalog-ordering/`
- [ ] T012 [US1] Add focused assertions for catalog creation, required columns, stable `CLAR-<ARTIFACT-ID>` identity, and row replacement in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T013 [US1] Implement catalog row creation and replacement for successful Generate operations in `.highway/skills/highway-clarify/SKILL.md`
- [X] T014 [US1] Implement deterministic Artifact Type then Artifact ID ordering for catalog rendering in `.highway/skills/highway-clarify/SKILL.md`
- [ ] T015 [US1] Add catalog creation and ordering verification to `.highway/tools/tests/highway-clarify.test.sh`
- [ ] T016 [US1] Verify the generated catalog matches `.highway/library/templates/output/clarification-catalog.md` in `.highway/tools/tests/output-template.test.sh`

## Phase 4: User Story 2 - Keep Catalog State Synchronized (Priority: P1)

**Goal**: Keep the catalog status identical to the clarification artifact after successful Generate and Update operations.

**Independent Test Criteria**: Update a disposable clarification from `in-progress` to `complete` and `blocked`, then verify both clarification and catalog status, including no catalog mutation on failed update.

- [ ] T017 [P] [US2] Add successful status-transition fixtures for `complete` and `blocked` in `.highway/tools/tests/fixtures/highway-clarify/catalog-status/`
- [ ] T018 [P] [US2] Add failed-update and revision-conflict fixtures in `.highway/tools/tests/fixtures/highway-clarify/catalog-status-failures/`
- [ ] T019 [US2] Add assertions that successful Update changes the matching catalog status exactly once in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T020 [US2] Implement status mirroring for Generate and Update catalog rows in `.highway/skills/highway-clarify/SKILL.md`
- [X] T021 [US2] Preserve existing Clarify revision conflict, retry, and no-write behavior while updating the catalog in `.highway/skills/highway-clarify/SKILL.md`
- [ ] T022 [US2] Add assertions that failed Generate and Update operations leave clarification and catalog bytes unchanged in `.highway/tools/tests/highway-clarify.test.sh`

## Phase 5: User Story 3 - Protect Catalog Integrity (Priority: P2)

**Goal**: Reject malformed, duplicate, unsupported, or unresolvable catalog state without partial writes.

**Independent Test Criteria**: Apply malformed, duplicate, unsupported-value, missing-reference, mismatched-status, and write-failure fixtures and verify abort behavior plus byte preservation.

- [ ] T023 [P] [US3] Add malformed catalog fixtures with missing headers and invalid rows in `.highway/tools/tests/fixtures/highway-clarify/catalog-invalid/`
- [ ] T024 [P] [US3] Add duplicate ID and duplicate artifact-mapping fixtures in `.highway/tools/tests/fixtures/highway-clarify/catalog-duplicates/`
- [ ] T025 [P] [US3] Add unsupported artifact-type, unsupported-status, missing-artifact, and status-mismatch fixtures in `.highway/tools/tests/fixtures/highway-clarify/catalog-references/`
- [ ] T026 [US3] Add assertions for duplicate rejection, reference completeness, status agreement, and malformed-catalog byte preservation in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T027 [US3] Implement complete catalog validation before rendering or writing in `.highway/skills/highway-clarify/SKILL.md`
- [X] T028 [US3] Implement catalog and clarification write-failure handling that preserves pre-operation bytes in `.highway/skills/highway-clarify/SKILL.md`
- [ ] T029 [US3] Add repeated-input byte determinism checks to `.highway/tools/tests/highway-clarify.test.sh`
- [X] T030 [US3] Add catalog structure, duplicate, reference, status, and determinism checks to the `Verification` section of `.highway/skills/highway-clarify/SKILL.md`

## Phase 6: Generated Artifacts and Cross-Cutting Validation

- [X] T031 Regenerate all derived `highway-clarify` adapters with `.highway/tools/generate-agent-adapters.sh`
- [X] T032 [P] Validate the canonical Clarify skill and catalog template with `.highway/tools/validate-skill.sh` and `.highway/tools/validate-library.sh`
- [X] T033 [P] Validate generated adapter correspondence with `.highway/tools/tests/adapter-coverage.test.sh`
- [X] T034 Run the focused Clarify and output-template tests with `.highway/tools/tests/highway-clarify.test.sh` and `.highway/tools/tests/output-template.test.sh`
- [ ] T035 Run the complete repository validation suite with `.highway/tools/tests/run-all.sh` using a 200-second timeout; ensure no other test command is running or started concurrently

## Phase 7: Polish and Cross-Cutting Concerns

- [X] T036 Confirm `highway-clarify` does not change Discovery, ADR, findings, analysis ordering, or scoring in `.highway/skills/highway-clarify/SKILL.md`
- [X] T037 [P] Update the validation run guide with final commands and observed outcomes in `specs/066-clarification-catalog/quickstart.md`
- [X] T038 [P] Review all changed skill and template references for resolvable paths under `.highway/skills/highway-clarify/SKILL.md` and `.highway/library/templates/output/clarification-catalog.md`
- [X] T039 Record final requirement coverage and validation results in `specs/066-clarification-catalog/plan.md`

## Parallel Execution Examples

### User Story 1

```text
# After T004-T009 complete
T010, T011, and T016 can run in parallel.
T012 and T013 can run in parallel after fixtures are defined.
T014 follows T013; T015 follows T012-T014.
```

### User Story 2

```text
# After User Story 1 is complete
T017, T018, and T019 can run in parallel.
T020 and T021 can run in parallel after the fixtures are available.
T022 follows T020-T021.
```

### User Story 3

```text
# After User Story 1 is complete; can run in parallel with User Story 2
T023, T024, and T025 can run in parallel.
T026 and T027 can run in parallel after the fixtures are available.
T028 follows T027; T029 follows T027-T028; T030 follows T026-T029.
```

## MVP Scope

The MVP is User Story 1: the shared catalog template, first catalog creation, stable identifier mapping, row replacement, and deterministic Artifact Type then Artifact ID ordering. User Stories 2 and 3 complete status synchronization and integrity guarantees before the feature is considered complete.
