# Tasks: Migration Contract Enforcement

**Input**: Design documents from `/specs/029-migration-contract-enforcement/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/migration-contract.md, quickstart.md

**Tests**: Required by the feature specification. Focused tests must cover clean behavior, negative policy/reference cases, cleanup, provenance, traceability, and user-data preservation.

**Organization**: Tasks are grouped by user story so each contract can be implemented and validated independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the disposable fixture surface and baseline paths used by the focused contract checks.

- [X] T001 [P] Create the objective-rename fixture directory at `.highway/tools/tests/fixtures/objective-rename/` for disposable negative-test probes.
- [X] T002 [P] Record the baseline ownership inputs and root-level objective-data state in the focused test design at `.highway/tools/tests/objective-rename-contract.test.sh` without creating or modifying user-owned objective paths.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define the shared policy boundaries before user-story checks are implemented.

- [X] T003 Define the explicit scan boundary for `specs/029-migration-contract-enforcement/` and the prohibited path classes in `.highway/tools/audit-objective-rename.sh`.
- [X] T004 Define the newline-delimited empty-allowlist syntax, comment handling, duplicate detection, and repository-relative path validation in `.highway/tools/audit-objective-rename.sh`.

**Checkpoint**: The audit boundary and policy rules are explicit; user-story checks can now be implemented independently.

---

## Phase 3: User Story 1 - Make distribution metadata provenance explicit (Priority: P1) 🎯 MVP

**Goal**: Make `.highway/tools/.distribution-manifest` a single, documented canonical maintained declaration and verify that packaging and Feature 028 documentation agree.

**Independent Test**: Run the provenance correspondence portion of `.highway/tools/tests/objective-rename-contract.test.sh`; it must identify the manifest as maintained input, confirm `.highway/tools/generate-distribution.sh` reads without writing it, and reject contradictory Feature 028 wording.

### Tests for User Story 1

- [X] T005 [P] [US1] Add provenance correspondence assertions for `.highway/tools/.distribution-manifest`, `.highway/tools/generate-distribution.sh`, and `specs/028-objectives-rename-cleanup/plan.md` in `.highway/tools/tests/objective-rename-contract.test.sh`.
- [X] T006 [P] [US1] Add a temporary contradiction probe and cleanup assertion for generated-manifest wording in `.highway/tools/tests/objective-rename-contract.test.sh`.

### Implementation for User Story 1

- [X] T007 [US1] Correct Feature 028's manifest ownership and regeneration language in `specs/028-objectives-rename-cleanup/spec.md` so generated catalogs/adapters remain distinct from the maintained `.distribution-manifest`.
- [X] T008 [US1] Correct the corresponding manifest ownership and regeneration language in `specs/028-objectives-rename-cleanup/plan.md` without reopening Feature 028's rename implementation.
- [X] T009 [US1] Implement the provenance correspondence check and actionable contradiction reporting in `.highway/tools/audit-objective-rename.sh`.
- [X] T010 [US1] Run the focused provenance test from `.highway/tools/tests/objective-rename-contract.test.sh` and confirm `.highway/tools/.distribution-manifest` remains unchanged.

**Checkpoint**: Manifest provenance is singular and verifiable; the packaging generator remains a consumer, not a manifest generator.

---

## Phase 4: User Story 2 - Enforce an empty migration allowlist (Priority: P1)

**Goal**: Add a tracked empty allowlist and an audit that rejects every non-comment exception, stale singular reference, malformed entry, prohibited path, and user-data mutation.

**Independent Test**: Run `.highway/tools/tests/objective-rename-contract.test.sh`; it must pass on the clean repository, fail for each temporary allowlist/reference violation, report deterministic offending paths, and remove all probes afterward.

### Tests for User Story 2

- [X] T011 [P] [US2] Add clean-migration assertions for the empty allowlist, explicit planning boundary, zero prohibited references, root-level user-data preservation, and absent-data preservation in `.highway/tools/tests/objective-rename-contract.test.sh`.
- [X] T012 [P] [US2] Add negative temporary-probe cases for missing, malformed, duplicate, non-empty, absolute, parent-traversal, and prohibited-path allowlist entries in `.highway/tools/tests/objective-rename-contract.test.sh`.
- [X] T013 [P] [US2] Add negative stale-token and stale-path probes covering source, adapter, catalog, manifest, fixture, test, and live-documentation surfaces in `.highway/tools/tests/objective-rename-contract.test.sh`.
- [X] T014 [P] [US2] Add cleanup-trap assertions that restore `.highway/tools/.objective-rename-allowlist`, remove `.highway/tools/tests/fixtures/objective-rename/` probes, and leave the worktree and root-level objective paths unchanged in `.highway/tools/tests/objective-rename-contract.test.sh`.

### Implementation for User Story 2

- [X] T015 [US2] Add the tracked empty allowlist with documented comment/blank-line syntax at `.highway/tools/.objective-rename-allowlist`.
- [X] T016 [US2] Implement allowlist parsing, exact singular-token/path scanning, deterministic reporting, planning-boundary exclusion, and root-level user-data snapshots in `.highway/tools/audit-objective-rename.sh`.
- [X] T017 [US2] Implement temporary negative-case execution and cleanup handling in `.highway/tools/tests/objective-rename-contract.test.sh` using `.highway/tools/tests/fixtures/objective-rename/` only.
- [X] T018 [US2] Run the complete focused migration contract test at `.highway/tools/tests/objective-rename-contract.test.sh` and verify no temporary probe remains in the working tree.

**Checkpoint**: The clean migration has an explicit empty policy, and every attempted exception or stale reference is rejected without touching user-owned objective data.

---

## Phase 5: User Story 3 - Restore Feature 028 traceability (Priority: P2)

**Goal**: Correct the Feature 028 test-path typo and verify that named plan/task paths resolve while Feature 028 remains a separate historical record.

**Independent Test**: Run the traceability portion of `.highway/tools/tests/objective-rename-contract.test.sh`; it must resolve `.highway/tools/tests/objective-management.test.sh`, reject the plural typo, and preserve `specs/028-objectives-rename-cleanup/` as a separate directory.

### Tests for User Story 3

- [X] T019 [P] [US3] Add Feature 028 plan/task path-resolution assertions for `.highway/tools/tests/objective-management.test.sh` and the separate `specs/028-objectives-rename-cleanup/` record in `.highway/tools/tests/objective-rename-contract.test.sh`.
- [X] T020 [P] [US3] Add a temporary typo probe for `objectives-management.test.sh` and assert actionable failure and cleanup in `.highway/tools/tests/objective-rename-contract.test.sh`.

### Implementation for User Story 3

- [X] T021 [US3] Replace `objectives-management.test.sh` with `.highway/tools/tests/objective-management.test.sh` in `specs/028-objectives-rename-cleanup/plan.md`.
- [X] T022 [US3] Add Feature 028 traceability and stale-typo detection to `.highway/tools/audit-objective-rename.sh` without modifying Feature 028 behavior or deterministic-output scope.
- [X] T023 [US3] Run the Feature 028 traceability checks in `.highway/tools/tests/objective-rename-contract.test.sh` and confirm the corrected path resolves.

**Checkpoint**: Feature 028's named test path is real and auditable, with no unrelated historical records or behavior changed.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validate the complete contract against the existing repository gates and preserve user data.

- [X] T024 [P] Run the focused migration contract test `.highway/tools/tests/objective-rename-contract.test.sh` and record clean output in `specs/029-migration-contract-enforcement/quickstart.md` if the documented command needs correction.
- [X] T025 [P] Run `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/distribution-packaging.test.sh` after the manifest and allowlist changes.
- [X] T026 [P] Run `.highway/tools/validate-skill.sh .highway/skills/highway-objectives` and `.highway/tools/validate-library.sh .highway/library/templates/output/objective-record.md`.
- [X] T027 Run the full repository suite with `.highway/tools/tests/run-all.sh` and verify `git diff --check` passes without root-level objective data changes.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001-T002 can start immediately and establish the disposable test surface and baseline.
- **Foundational (Phase 2)**: T003-T004 depend on the setup baseline and block story implementation.
- **User Story 1 (Phase 3)**: Depends on Phase 2; provenance tests precede provenance implementation.
- **User Story 2 (Phase 4)**: Depends on Phase 2 and can proceed independently of US1 after the shared boundary is defined.
- **User Story 3 (Phase 5)**: Depends on Phase 2 and can proceed independently of US1/US2; its final audit integration uses the same focused test.
- **Polish (Phase 6)**: Depends on all three stories so the full suite validates the combined contract.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on other stories after Phase 2.
- **User Story 2 (P1)**: No dependency on US1; shares only the audit boundary and focused harness.
- **User Story 3 (P2)**: No behavioral dependency on US1/US2; its path correction is independently testable.

## Parallel Opportunities

- T001-T002 can run in parallel.
- T005-T006 can run in parallel before US1 implementation; T007-T008 can run in parallel before T009.
- T011-T014 can run in parallel because they add separate focused test cases.
- T015 can run in parallel with T019-T020 after the foundational policy is defined.
- T019-T020 can run in parallel with T011-T014; T021 can proceed once the target path is confirmed.
- T025-T026 can run in parallel after the focused audit is green.

## Parallel Example: User Story 2

```text
Task T011: Clean allowlist, boundary, and user-data assertions in .highway/tools/tests/objective-rename-contract.test.sh
Task T012: Allowlist syntax and policy negative cases in .highway/tools/tests/objective-rename-contract.test.sh
Task T013: Stale-reference negative cases in .highway/tools/tests/objective-rename-contract.test.sh
Task T014: Cleanup and worktree-restoration assertions in .highway/tools/tests/objective-rename-contract.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete User Story 1 to make manifest provenance explicit and testable.
3. Stop and validate the provenance correspondence independently.

### Incremental Delivery

1. Add User Story 2 to enforce the empty migration policy and stale-reference audit.
2. Add User Story 3 to repair Feature 028 traceability.
3. Run the existing adapter, packaging, validator, and full-suite gates.

### Scope Guard

Do not rename or reimplement Feature 028 behavior, objective workflows, or deterministic-output improvements. Preserve root-level user-owned objective files byte-for-byte or preserve their absent state.

## Notes

- Every task uses the required checkbox, sequential ID, optional `[P]` marker, story label where applicable, and an exact repository path.
- Tests are written before the implementation tasks within each user story and must fail for the injected negative cases before the corresponding audit behavior is complete.