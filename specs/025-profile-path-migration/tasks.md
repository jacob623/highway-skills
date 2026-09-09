# Tasks: Highway Profile Path Migration

**Input**: Design documents from `specs/025-profile-path-migration/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/profile-migration.md`, `quickstart.md`

**Tests**: Included because the specification requires independent migration, audit, schema, version, and packaging verification.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the migration inventory and disposable validation surfaces without changing Feature 024.

- [X] T001 Record the former and canonical profile paths, affected source/generated surfaces, and user-edited files in `specs/025-profile-path-migration/plan.md` and `specs/025-profile-path-migration/research.md`.
- [X] T002 [P] Add the Feature 025 migration contract assertions to `specs/025-profile-path-migration/contracts/profile-migration.md`, covering canonical path, pure-YAML schema, audit outcomes, and version policy.
- [X] T003 [P] Create disposable migration fixtures for former-path files, stale references, and canonical default content under `.highway/tools/tests/fixtures/profile-migration/`.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the canonical artifact and shared structural/version primitives before story implementation.

- [X] T004 Create `.highway/library/templates/output/profile.yaml` with the exact pure-YAML schema, metadata, empty organization fields, empty mappings, and top-level ordering from FR-007 and FR-008.
- [X] T005 Remove the obsolete `.highway/profile.yaml` artifact and confirm the change is limited to relocating the profile content under the canonical path.
- [X] T006 Rewrite `.highway/tools/validate-profile.sh` to validate pure YAML, reject frontmatter, enforce exact key ordering and required mappings, and validate version/description defaults without judging user-owned values.
- [X] T007 Update `.highway/tools/lib/profile.sh` to use the canonical path, preserve user values/order, and expose transactional version calculation for confirmed writes.
- [X] T008 [P] Add canonical-path and exact-schema assertions to `.highway/tools/tests/profile-structure.test.sh`, including absence of `.highway/profile.yaml` and no frontmatter.
- [X] T009 [P] Add version transition fixtures and assertions to `.highway/tools/tests/profile-behavior.test.sh` for PATCH, MINOR, MAJOR, and no-change-on-decline/error behavior.
- [X] T010 [P] Add a migration audit test skeleton at `.highway/tools/tests/profile-migration.test.sh` with failure reporting for former-path files and references.

**Checkpoint**: Canonical artifact, structural validator, profile helper, and focused test fixtures are ready for story implementation.

## Phase 3: User Story 1 - Migrate the Profile Artifact (Priority: P1) 🎯 MVP

**Goal**: Move the profile to one authoritative canonical location while preserving its exact schema and user-owned values.

**Independent Test**: Validate the canonical profile, confirm the former path is absent, regenerate affected artifacts, and package the profile exactly once at the canonical path.

### Tests for User Story 1

- [X] T011 [P] [US1] Add contract checks for canonical profile existence, former-path absence, exact schema order, and pure-YAML parsing in `.highway/tools/tests/profile-migration.test.sh`.
- [X] T012 [P] [US1] Add a value-preservation migration fixture and byte-comparison assertions to `.highway/tools/tests/profile-migration.test.sh` for user wording, capitalization, grouping, and value order.

### Implementation for User Story 1

- [X] T013 [US1] Update `.highway/skills/highway-profile/SKILL.md` so all file-emitting, read-only, setup, and mutation instructions reference `.highway/library/templates/output/profile.yaml` and the complete pure-YAML output contract.
- [X] T014 [US1] Update `.highway/tools/tests/profile-structure.test.sh` and `.highway/tools/tests/profile-behavior.test.sh` fixtures and expectations from `.highway/profile.yaml` to the canonical path without removing user-owned value-preservation coverage.
- [X] T015 [US1] Remove or replace `.highway/library/templates/output/highway-profile.md` so no stale Markdown profile skeleton competes with the pure-YAML canonical artifact.
- [X] T016 [US1] Update `.highway/tools/.distribution-manifest` and `.highway/tools/.adapter-manifest` to include the canonical profile exactly once and remove former-path or stale profile-template rows while preserving unrelated user edits.
- [X] T017 [US1] Update `.highway/tools/generate-library-catalog.sh` or its dedicated YAML artifact handling so the canonical profile is cataloged/validated without applying Markdown-frontmatter rules.

**Checkpoint**: User Story 1 is independently testable: one canonical profile exists, its schema is exact, values are preserved, and no obsolete template/path is authoritative.

## Phase 4: User Story 2 - Verify a Clean Repository Migration (Priority: P1)

**Goal**: Make orphan detection repeatable across source, tests, fixtures, generated outputs, manifests, and distribution metadata.

**Independent Test**: Run the migration audit against the repository, then inject one temporary former-path artifact and confirm the audit fails with its location before removing the fixture.

### Tests for User Story 2

- [X] T018 [P] [US2] Implement the positive clean-migration audit in `.highway/tools/tests/profile-migration.test.sh`, checking former-path files and references across `.highway/`, generated adapter trees, tests, fixtures, catalogs, and manifests.
- [X] T019 [P] [US2] Implement negative audit cases in `.highway/tools/tests/profile-migration.test.sh` for an orphan file, stale test/fixture reference, stale catalog/adapter reference, and stale distribution-manifest row.
- [X] T020 [P] [US2] Add exact-once packaging assertions for the canonical profile and former-path exclusion to `.highway/tools/tests/distribution-packaging.test.sh` or the narrowest existing packaging test.

### Implementation for User Story 2

- [X] T021 [US2] Complete the migration audit implementation in `.highway/tools/tests/profile-migration.test.sh` with deterministic output, actionable offending-path reporting, and no writes to the working tree.
- [X] T022 [US2] Regenerate `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` from updated source inputs using `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`.
- [X] T023 [US2] Regenerate distribution outputs with `.highway/tools/generate-distribution.sh` and verify the generated distribution contains the canonical profile exactly once and no former-path artifact.
- [X] T024 [US2] Add the migration audit to `.highway/tools/tests/run-all.sh` and document its invocation and expected failure mode in `specs/025-profile-path-migration/quickstart.md`.

**Checkpoint**: User Story 2 is independently testable: the repository reports zero orphaned former-path artifacts and fails clearly when any stale reference is introduced.

## Phase 5: User Story 3 - Maintain Profile Version Integrity (Priority: P1)

**Goal**: Apply the semantic-version policy only when a confirmed profile write succeeds.

**Independent Test**: Exercise confirmed and declined add/update/remove/reset operations and verify PATCH/MINOR/no-change behavior, with a schema-breaking release covered by a MAJOR assertion.

### Tests for User Story 3

- [X] T025 [P] [US3] Add confirmed `add`, `update`, and `remove` PATCH assertions to `.highway/tools/tests/profile-behavior.test.sh`.
- [X] T026 [P] [US3] Add confirmed `reset` MINOR and schema-breaking MAJOR assertions to `.highway/tools/tests/profile-behavior.test.sh`.
- [X] T027 [P] [US3] Add declined, malformed, ambiguous, and aborted-operation byte-preservation assertions to `.highway/tools/tests/profile-behavior.test.sh`.

### Implementation for User Story 3

- [X] T028 [US3] Implement transactional version calculation and post-write application in `.highway/tools/lib/profile.sh`, ensuring version changes occur only after confirmed content serialization and successful write.
- [X] T029 [US3] Update `.highway/skills/highway-profile/SKILL.md` mutation outputs to document version effects and unchanged-version behavior for declined or failed operations.
- [X] T030 [US3] Update `.highway/tools/validate-profile.sh` and profile behavior fixtures to reject invalid semantic versions and preserve `metadata.version` on no-write paths.

**Checkpoint**: User Story 3 is independently testable: every confirmed operation receives the prescribed version increment and every declined/failed operation preserves bytes and version.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate all correspondence surfaces, validate governance boundaries, and close requirement coverage.

- [X] T031 [P] Run `.highway/tools/validate-skill.sh .highway/skills/highway-profile` and `.highway/tools/validate-profile.sh .highway/library/templates/output/profile.yaml`; fix only migration-related failures.
- [X] T032 [P] Run `.highway/tools/tests/profile-structure.test.sh`, `.highway/tools/tests/profile-behavior.test.sh`, `.highway/tools/tests/profile-migration.test.sh`, and the focused packaging/correspondence tests; record results in the implementation coverage record.
- [X] T033 Run `.highway/tools/tests/run-all.sh` and resolve migration-related failures without changing Feature 024 files.
- [X] T034 [P] Audit the repository for `.highway/profile.yaml` references and orphaned profile files, tests, fixtures, catalogs, adapters, adapter-manifest rows, distribution-manifest rows, or other distribution metadata; record zero-orphan evidence in `specs/025-profile-path-migration/quickstart.md` or the implementation coverage record.
- [X] T035 [P] Verify generated catalog, adapter, library, and distribution outputs are current after source changes and preserve unrelated user edits in `.highway/tools/tests/output-template.test.sh` and `.highway/tools/.distribution-manifest`.
- [X] T036 Update `specs/025-profile-path-migration/data-model.md`, `quickstart.md`, and `contracts/profile-migration.md` if implementation details alter the validated contract, then run `git diff --check`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the migration inventory and fixtures.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user stories because the canonical artifact and structural primitives must exist first.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the minimum viable canonical profile move.
- **User Story 2 (Phase 4)**: Depends on User Story 1 because the audit needs the final canonical path and generated inputs.
- **User Story 3 (Phase 5)**: Depends on Foundational and can run in parallel with User Story 2 after the profile helper is available; final integration depends on both.
- **Polish (Phase 6)**: Depends on all three user stories.

### User Story Dependencies

- **US1 (P1)**: Foundational only; MVP.
- **US2 (P1)**: Foundational plus the canonical path changes from US1.
- **US3 (P1)**: Foundational; profile behavior/version tests may proceed in parallel with US2, but shared helper edits must be coordinated.

### Parallel Opportunities

- T002-T003 can run in parallel during Setup.
- T008-T010 can run in parallel after the canonical artifact and helper interfaces are agreed.
- T011-T012 can run in parallel with each other.
- T018-T020 can run in parallel because they touch separate test concerns.
- T025-T027 can run in parallel within version-test fixtures.
- T031-T032 and T034-T035 can run in parallel after implementation and regeneration.

## Parallel Execution Examples

### User Story 1

```text
Task: T011 [US1] Add canonical-path and schema contract checks in .highway/tools/tests/profile-migration.test.sh
Task: T012 [US1] Add user-value preservation fixtures in .highway/tools/tests/profile-migration.test.sh
Task: T013 [US1] Update .highway/skills/highway-profile/SKILL.md for the canonical pure-YAML contract
```

### User Story 2

```text
Task: T018 [US2] Implement the positive clean-migration audit in .highway/tools/tests/profile-migration.test.sh
Task: T019 [US2] Implement negative orphan cases in .highway/tools/tests/profile-migration.test.sh
Task: T020 [US2] Add exact-once packaging assertions in .highway/tools/tests/distribution-packaging.test.sh
```

### User Story 3

```text
Task: T025 [US3] Add PATCH assertions for confirmed add/update/remove in .highway/tools/tests/profile-behavior.test.sh
Task: T026 [US3] Add MINOR reset and MAJOR schema assertions in .highway/tools/tests/profile-behavior.test.sh
Task: T027 [US3] Add no-write version-preservation assertions in .highway/tools/tests/profile-behavior.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Complete User Story 1: canonical artifact, source skill, validators, manifests, and generated correspondence.
3. Run the independent US1 checks and stop for review before adding audit and version behavior.

### Incremental Delivery

1. Deliver US1 as the one-authoritative-path migration.
2. Add US2 to make zero-orphan verification repeatable.
3. Add US3 to enforce version integrity across confirmed and declined operations.
4. Complete polish and full-suite validation.

### Parallel Team Strategy

1. Complete Setup and Foundational together.
2. Assign US1 source/artifact work, US2 audit/packaging work, and US3 version behavior work after shared helper interfaces are stable.
3. Integrate through regeneration and the full test suite.

## Notes

- Every task uses the required `- [ ] T###` format and includes a concrete repository path.
- `[P]` marks tasks that can proceed in parallel without incomplete-task dependencies.
- Feature 024 remains a historical, unchanged specification; do not edit its spec or checklist as part of this feature.
