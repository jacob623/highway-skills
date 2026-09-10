---

description: "Task list for the highway-objectives skill and Business Objective workflow"
---

# Tasks: Highway Objective

**Input**: Design documents from `/specs/027-highway-objective/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/objective-workflow.md`, and `quickstart.md`

**Tests**: Included because the feature specification explicitly requires independent verification of read-only, mutation, determinism, identifier, versioning, and no-write behavior.

**Organization**: Tasks are grouped by user story. All tests use temporary repositories or fixtures and must not mutate a real user-owned `library/` baseline.

## Phase 1: Setup

**Purpose**: Establish source artifacts, test fixtures, and the shared output contract.

- [X] T001 Run `.highway/tools/tests/run-all.sh` and record the passing baseline before implementation.
- [X] T002 [P] Create `.highway/library/templates/output/objective-record.md` with frontmatter for `id`, `title`, `status`, and `capabilities: []`, plus body placeholders for statement, success measures, and rationale.
- [X] T003 [P] Create temporary-repository fixture inputs under `.highway/tools/tests/fixtures/objective-management/` covering an empty baseline, a valid multi-objective baseline, a duplicate identifier, an invalid `next_id`, and a missing catalog target.
- [X] T004 [P] Create `.highway/tools/tests/objective-management.test.sh` with fixture isolation, byte snapshots, assertion helpers, and cleanup traps for user-owned objective/catalog paths.

## Phase 2: Foundational

**Purpose**: Define the shared implementation contract before story-specific behavior.

- [X] T005 Add the supported action set, artifact paths, ownership boundary, output fields, and error/no-write rules to `.highway/skills/highway-objectives/SKILL.md` using `specs/027-highway-objective/contracts/objective-workflow.md`.
- [X] T006 Add objective record, baseline, catalog, mutation report, identifier, and validation invariants to `.highway/skills/highway-objectives/SKILL.md` and cite `.highway/library/templates/output/objective-record.md` as the complete retained-record contract.
- [X] T007 Add the source skill and template paths to `.highway/tools/.distribution-manifest`, preserving existing user edits and excluding root-level user-owned `library/objectives/` and `library/governance/objectives.md` from the shipped distribution.

**Checkpoint**: The source contract and shared template are present, user-owned output paths are explicit, and isolated test fixtures are ready.

## Phase 3: User Story 1 - Inspect the objective baseline (Priority: P1) 🎯 MVP

**Goal**: Provide exact read-only action routing and status output without mutating user-owned files.

**Independent Test**: Run `.highway/tools/tests/objective-management.test.sh` against an empty and populated temporary baseline; verify no-action, `view`, `show`, and `describe` produce the required status and identical file snapshots.

### Tests for User Story 1

- [X] T008 [US1] Add read-only assertions to `.highway/tools/tests/objective-management.test.sh` for no action, `view`, `show`, and `describe`, including version, count, identifiers, titles, statuses, and absent-baseline output.
- [X] T009 [US1] Add unsupported and ambiguous action assertions to `.highway/tools/tests/objective-management.test.sh` and verify the response asks for clarification without changing objective or catalog bytes.

### Implementation for User Story 1

- [X] T010 [US1] Document exact action selection and read-only behavior in `.highway/skills/highway-objectives/SKILL.md`, including the absence response and the prohibition on inferred actions.
- [X] T011 [US1] Document the baseline status response and deterministic ordering of objective identifiers, titles, and statuses in `.highway/skills/highway-objectives/SKILL.md`.

**Checkpoint**: Read-only actions and unsupported-action handling are independently testable and perform no writes.

## Phase 4: User Story 2 - Create and maintain user-owned objectives (Priority: P1)

**Goal**: Support guided creation, rationale approval, permanent IDs, updates, deterministic catalog regeneration, and mutation reports.

**Independent Test**: Run isolated add/new/setup and update scenarios; confirm records are created under `library/objectives/`, catalog output is deterministic, IDs remain stable, and one confirmed action causes exactly one version increment.

### Tests for User Story 2

- [X] T012 [P] [US2] Add three-prompt interview assertions to `.highway/tools/tests/objective-management.test.sh` for exact prompt separation, rationale accept/edit/replace behavior, title proposal, active default status, and repeat-objective choice.
- [X] T013 [P] [US2] Add creation/update fixture assertions to `.highway/tools/tests/objective-management.test.sh` for `OBJ` six-digit allocation, `capabilities: []`, catalog fields, mutation report fields, stable IDs, and catalog byte determinism.
- [X] T014 [P] [US2] Add version assertions to `.highway/tools/tests/objective-management.test.sh` for MINOR add/new, PATCH update, one increment per action, and preservation of version on declined or failed writes.

### Implementation for User Story 2

- [X] T015 [US2] Document the three-prompt setup/configure/add/new interview and rationale proposal workflow in `.highway/skills/highway-objectives/SKILL.md`.
- [X] T016 [US2] Document catalog-authoritative `next_id` allocation, permanent non-reused identifiers, objective record structure, and update field preservation in `.highway/skills/highway-objectives/SKILL.md`.
- [X] T017 [US2] Document deterministic `library/governance/objectives.md` regeneration, ownership/direct-edit warnings, mutation report fields, and add/update version increments in `.highway/skills/highway-objectives/SKILL.md`.

**Checkpoint**: A confirmed creation or update produces a complete user-owned record, deterministic catalog, stable identifier, correct version, and complete report.

## Phase 5: User Story 3 - Safely remove or reset objectives (Priority: P1)

**Goal**: Make destructive operations reviewable and transactional, with exact impact previews and byte preservation on non-confirmation.

**Independent Test**: Run remove and reset against a populated temporary baseline, decline confirmation and compare all bytes, then confirm and verify affected records, catalog, and MAJOR version changes.

### Tests for User Story 3

- [X] T018 [P] [US3] Add remove assertions to `.highway/tools/tests/objective-management.test.sh` for identifier/title preview, declined confirmation, successful deletion, non-reused IDs, catalog regeneration, and MAJOR version increment.
- [X] T019 [P] [US3] Add reset assertions to `.highway/tools/tests/objective-management.test.sh` for listing every affected identifier/title, declined confirmation, successful baseline replacement, and MAJOR version increment.
- [X] T020 [P] [US3] Add malformed-baseline and aborted-operation assertions to `.highway/tools/tests/objective-management.test.sh` for duplicate IDs, missing catalog targets, invalid `next_id`, out-of-place records, and byte-for-byte no-write behavior.

### Implementation for User Story 3

- [X] T021 [US3] Document remove and reset impact previews, explicit confirmation requirements, and exact no-write outcomes in `.highway/skills/highway-objectives/SKILL.md`.
- [X] T022 [US3] Document complete-baseline validation, staged transaction ordering, catalog consistency checks, and remove/reset MAJOR version behavior in `.highway/skills/highway-objectives/SKILL.md`.

**Checkpoint**: Declined, ambiguous, malformed, and aborted destructive operations preserve all affected bytes; confirmed operations update records/catalog exactly once.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validate the shipped skill, generated outputs, shared template correspondence, and complete requirement coverage.

- [X] T023 [P] Run `.highway/tools/validate-skill.sh .highway/skills/highway-objectives` and `.highway/tools/validate-library.sh .highway/library/templates/output/objective-record.md`; repair only Feature 027 contract failures.
- [X] T024 [P] Run `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`; verify source, library catalog, adapters, manifests, and distribution metadata are current.
- [X] T025 [P] Run `.highway/tools/tests/objective-management.test.sh`, `.highway/tools/tests/adapter-coverage.test.sh`, and `.highway/tools/tests/distribution-packaging.test.sh`; record outcomes in `specs/027-highway-objective/quickstart.md`.
- [X] T026 Run `.highway/tools/tests/run-all.sh`, resolve Feature 027 failures, and confirm no objective record is created beneath `.highway/`.
- [X] T027 Run `git diff --check` and confirm completed Feature 024, 025, and 026 spec records remain unchanged.
- [X] T028 Confirm every requirement ID in `specs/027-highway-objective/spec.md` maps to a satisfying task and implementation artifact before marking the feature complete.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establish the passing baseline, shared template, isolated fixtures, and test harness.
- **Foundational (Phase 2)**: Depends on Setup; defines the shipped skill contract and distribution classification.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the MVP read-only workflow.
- **User Story 2 (Phase 4)**: Depends on Foundational and the shared test harness; extends the same skill and fixture contract.
- **User Story 3 (Phase 5)**: Depends on the baseline and mutation staging established by User Story 2.
- **Polish (Phase 6)**: Depends on all three user stories and includes generated-artifact correspondence checks.

### User Story Dependencies

- **User Story 1 (P1)**: Can begin after Phase 2 and is independently testable.
- **User Story 2 (P1)**: Can begin after Phase 2, but shares the skill/test surfaces with US1 and should follow US1 sequentially.
- **User Story 3 (P1)**: Depends on US2's record allocation, catalog, and transaction model.

### Parallel Opportunities

- T002, T003, and T004 can run in parallel after T001 because they touch separate files/directories.
- T008 and T009 can run in parallel because they add distinct assertions to the same test file only if merged sequentially; otherwise assign one owner to the file.
- T012, T013, and T014 are logically parallel test-design tasks but must be applied serially to `.highway/tools/tests/objective-management.test.sh`.
- T018, T019, and T020 are logically parallel test-design tasks but must be applied serially to the same test file.
- T023, T024, and T025 can run in parallel after implementation because they validate separate command surfaces.

## Parallel Example: Final Validation

```text
Task: Validate highway-objectives and objective-record.md
Task: Regenerate catalogs, adapters, and manifests
Task: Run objective-management, adapter-coverage, and distribution-packaging tests
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Add and run the read-only and unsupported-action tests.
3. Document the read-only behavior in `SKILL.md`.
4. Stop and validate the inspection workflow independently.

### Incremental Delivery

1. Add User Story 1 for safe baseline inspection.
2. Add User Story 2 for confirmed creation and update with deterministic cataloging.
3. Add User Story 3 for safe destructive operations.
4. Regenerate shipped artifacts and run the complete suite.

## Notes

- `[P]` marks tasks that can be prepared independently; edits to the same file must still be merged sequentially.
- User-owned `library/` output is tested in temporary repositories and is not added to the shipped distribution.
- The shared objective record template is a shipped authoring contract; generated library and agent outputs must be regenerated after it changes.
