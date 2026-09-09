---

description: "Task list for validating and correcting the canonical profile YAML"
---

# Tasks: Valid Profile YAML

**Input**: Design documents from `/specs/026-valid-profile-yaml/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Included because the feature specification explicitly requires parser validation and regression coverage.

**Organization**: Tasks are grouped by user story and ordered so the parser test fails before the profile syntax is corrected.

## Phase 1: Setup

**Purpose**: Establish the baseline and confirm the current failure.

- [X] T001 Run the existing structural validator and the standard YAML parser against `.highway/library/templates/output/profile.yaml`, recording the parser failure before implementation.

## Phase 2: Foundational

**Purpose**: Preserve the Feature 025 profile contract while preparing the focused check.

- [X] T002 [P] Confirm the required 11-section order, metadata defaults, and empty mappings in `.highway/library/templates/output/profile.yaml` and `specs/026-valid-profile-yaml/data-model.md`.

## Phase 3: User Story 1 - Consume the profile with a standard YAML parser (Priority: P1) 🎯 MVP

**Goal**: Make the canonical profile parse successfully without changing its established schema or values.

**Independent Test**: Run the parser-backed profile test and confirm it exits successfully for `.highway/library/templates/output/profile.yaml`.

### Tests for User Story 1

- [X] T003 [US1] Create `.highway/tools/tests/profile-yaml.test.sh` to parse `.highway/library/templates/output/profile.yaml` with the development host's standard YAML parser and fail with a non-zero result on syntax errors.

### Implementation for User Story 1

- [X] T004 [US1] Replace tab indentation with YAML-compatible spaces in `.highway/library/templates/output/profile.yaml` while preserving all existing keys, values, section order, and empty mappings.

**Checkpoint**: `.highway/tools/tests/profile-yaml.test.sh` passes and the canonical profile remains accepted by `.highway/tools/validate-profile.sh`.

## Phase 4: User Story 2 - Prevent regression of YAML validity (Priority: P2)

**Goal**: Ensure future invalid YAML edits are rejected by automated verification.

**Independent Test**: Run the focused profile YAML test and the full `.highway/tools/tests/run-all.sh` workflow.

### Tests for User Story 2

- [X] T005 [P] [US2] Add a deliberately malformed YAML fixture at `.highway/tools/tests/fixtures/profile-yaml/invalid-indentation.yaml` and extend `.highway/tools/tests/profile-yaml.test.sh` to assert that the parser rejects it.

### Implementation for User Story 2

- [X] T006 [US2] Verify `.highway/tools/tests/profile-yaml.test.sh` is discovered by the existing glob-based `.highway/tools/tests/run-all.sh` workflow without weakening any existing profile assertions.

**Checkpoint**: The focused test accepts the canonical profile, rejects the malformed fixture, and the complete suite remains passing.

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Validate the complete feature and keep the implementation record current.

- [X] T007 [P] Run `.highway/tools/validate-profile.sh .highway/library/templates/output/profile.yaml` and `.highway/tools/tests/profile-structure.test.sh`; confirm schema and fixture behavior remain unchanged.
- [X] T008 [P] Run `.highway/tools/tests/profile-yaml.test.sh` and `.highway/tools/tests/run-all.sh`; record the final results against `specs/026-valid-profile-yaml/quickstart.md`.
- [X] T009 Verify `.highway/tools/audit-profile-migration.sh` still passes and no `.highway/profile.yaml` or `highway-profile.md` artifact/reference is reintroduced.
- [X] T010 Run `git diff --check` and confirm Feature 024 and Feature 025 specification records remain unmodified by the implementation.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the failing baseline.
- **Foundational (Phase 2)**: Depends on Setup; confirms the contract to preserve.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the MVP parser-valid profile.
- **User Story 2 (Phase 4)**: Depends on User Story 1; adds explicit malformed-input regression coverage and workflow verification.
- **Polish (Phase 5)**: Depends on the completed user stories.

### User Story Dependencies

- **User Story 1 (P1)**: Independent after Phase 2; no dependency on User Story 2.
- **User Story 2 (P2)**: Depends on the focused test from User Story 1 because it extends the same parser test and workflow.

### Parallel Opportunities

- T002 can run independently after T001 because it only verifies the preserved contract.
- After User Story 1 is complete, T007, T008, and T009 can run in parallel because they are read-only validations over separate command surfaces.

## Parallel Example: Final Validation

```text
Task: Run .highway/tools/validate-profile.sh and profile-structure.test.sh
Task: Run profile-yaml.test.sh and run-all.sh
Task: Run audit-profile-migration.sh and scan for former profile paths
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Run T001 and T002 to establish the failing parser result and preserved schema.
2. Write T003 first and observe it fail against the tab-indented profile.
3. Complete T004 to replace tabs with spaces.
4. Run the User Story 1 checkpoint and stop when the canonical profile parses and remains structurally valid.

### Incremental Delivery

1. Complete User Story 1 for the parser-valid canonical profile.
2. Complete User Story 2 for malformed-fixture rejection and suite discovery.
3. Run the cross-cutting validation tasks and update the quickstart evidence.

## Notes

- `[P]` marks tasks that can run in parallel without editing the same file.
- The focused parser test is development tooling; it does not add a shipped runtime dependency.
- Existing Feature 025 schema and migration behavior remain authoritative.
