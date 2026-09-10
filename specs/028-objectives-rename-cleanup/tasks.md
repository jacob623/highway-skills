---

description: "Task list for renaming the Business Objective skill to highway-objectives"
---

# Tasks: Objectives Skill Rename

**Input**: Design documents from `/specs/028-objectives-rename-cleanup/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/rename-workflow.md`, and `quickstart.md`

**Scope**: This task list implements only the skill rename and repository cleanup. Other quality improvements belong to a future specification.

## Phase 1: Setup

**Purpose**: Establish the migration inventory and protect user-owned data before changing paths.

- [X] T001 Run `git status --short` for `.specify/feature.json` and record the current worktree state in the implementation session before touching Feature 028 paths.
- [X] T002 [P] Capture an exact-token and path inventory for the singular skill identity across the repository, including `.highway/`, agent adapters, `specs/027-highway-objective/`, and tracked prompt artifacts.
- [X] T003 [P] Snapshot hashes and existence state for root-level `library/objectives/` and `library/governance/objectives.md` without creating either path.
- [X] T004 [P] Verify the singular and plural source, adapter, catalog, manifest, and test paths expected by `contracts/rename-workflow.md` and record missing or stale artifacts.

## Phase 2: Foundational Rename Preparation

**Purpose**: Establish the canonical plural source identity and remove references that would regenerate the old name.

- [X] T005 Rename `.highway/skills/highway-objective/SKILL.md` to `.highway/skills/highway-objectives/SKILL.md` while preserving the skill body and metadata until identity edits are applied.
- [X] T006 Update `.highway/skills/highway-objectives/SKILL.md` frontmatter, heading, command examples, catalog paths, and user-facing references from singular to plural identity.
- [X] T007 Update `.highway/tools/tests/objective-management.test.sh` and `.highway/tools/tests/output-template.test.sh` to use plural skill and test references without expanding the existing test scope.
- [X] T008 Update tracked Feature 027 references under `specs/027-highway-objective/` and tracked prompt artifacts to the plural command and paths; remove or rewrite every exact singular token outside the active Feature 028 planning directory.
- [X] T009 Update `.highway/tools/.distribution-manifest` and `.highway/tools/.adapter-manifest` source/adapter rows to plural paths, preserving all unrelated manifest rows and generated hashes until regeneration.

**Checkpoint**: The canonical source and all tracked hand-authored references use `highway-objectives`; no user-owned root-level objective data has been written.

## Phase 3: User Story 1 - Rename the skill and eliminate legacy references (Priority: P1) 🎯 MVP

**Goal**: Make `highway-objectives` the only source, command, adapter, catalog, manifest, test, and documentation identity.

**Independent Test**: Run the generators and packaging checks, then perform an exact-token scan and stale-path scan; verify plural artifacts exist, singular artifacts do not, and root-level user-owned objective bytes are unchanged.

### Tests for User Story 1

- [X] T010 [US1] Run the exact-token and stale-path migration scans from `specs/028-objectives-rename-cleanup/quickstart.md`, excluding only the active Feature 028 specification directory from explanatory planning text.
- [X] T011 [US1] Run `.highway/tools/tests/adapter-coverage.test.sh` and verify source, adapter, catalog, manifest, and distribution correspondence for the plural identity.
- [X] T012 [US1] Snapshot and verify root-level user-data existence and hashes around validation and packaging without writing live objective paths.

### Implementation for User Story 1

- [X] T013 [US1] Remove stale singular adapter directories/files under `.github/skills/`, `.claude/skills/`, and `.cursor/rules/`, retaining only generated plural targets.
- [X] T014 [US1] Update `.highway/catalog/index.json` and `.highway/catalog/index.md` through the catalog generator so the skill ID, command, and source path are plural.
- [X] T015 [US1] Regenerate `.github/skills/highway-objectives/SKILL.md`, `.claude/skills/highway-objectives/SKILL.md`, and `.cursor/rules/highway-objectives.mdc` with the adapter generator and verify manifest hashes.
- [X] T016 [US1] Regenerate `.highway/catalog/library-index.json` and `.highway/catalog/library-index.md` and confirm the objective record template remains cataloged once.
- [X] T017 [US1] Update any remaining repository-tracked source, generated, test, manifest, distribution, Feature 027, or prompt reference under `.highway/`, `.github/`, `.claude/`, `.cursor/`, `specs/027-highway-objective/`, or the tracked prompt artifact to the plural identity and remove old singular paths.

**Checkpoint**: The plural source and generated surfaces are present, singular surfaces are absent, and all tracked references resolve to the plural identity.

## Phase 4: Polish & Cross-Cutting Validation

**Purpose**: Prove generated correspondence, packaging integrity, zero-reference cleanup, and user-data protection.

- [X] T018 [P] Run `bash .highway/tools/validate-skill.sh .highway/skills/highway-objectives` and `bash .highway/tools/validate-library.sh .highway/library/templates/output/objective-record.md`.
- [X] T019 [P] Run `bash .highway/tools/generate-catalog.sh`, `bash .highway/tools/generate-library-catalog.sh`, and `bash .highway/tools/generate-agent-adapters.sh`; confirm generated files are current and no singular path is recreated.
- [X] T020 [P] Run `bash .highway/tools/tests/adapter-coverage.test.sh` and `bash .highway/tools/tests/distribution-packaging.test.sh`; confirm plural paths are packaged and singular orphans fail correspondence checks.
- [X] T021 Run the exact-token scan and stale-path scan from `specs/028-objectives-rename-cleanup/quickstart.md`, excluding only the active planning directory if required by the scan contract.
- [X] T022 Run `.highway/tools/tests/run-all.sh` and confirm the full suite passes with zero failures after the rename.
- [X] T023 Compare the post-validation hashes and existence state for root-level `library/objectives/` and `library/governance/objectives.md` with T003.
- [X] T024 Run `git diff --check`, verify no files under `specs/024-highway-profile/`, `specs/025-profile-path-migration/`, or `specs/026-valid-profile-yaml/` changed, and confirm `specs/027-highway-objective/` remains a separate directory with only intended reference updates.
- [X] T025 Confirm every FR-001 through FR-009 and SC-001 through SC-005 in `specs/028-objectives-rename-cleanup/spec.md` maps to a completed task and validation artifact.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; inventory and user-data protection must precede edits.
- **Foundational (Phase 2)**: Depends on Setup; source identity and hand-authored references must be plural before generation.
- **User Story 1 (Phase 3)**: Depends on Foundational; completes source rename, stale artifact removal, regeneration, and correspondence assertions.
- **Polish (Phase 4)**: Depends on User Story 1; validates all generated, packaged, and tracked surfaces.

### User Story Dependencies

- **User Story 1 (P1)**: The only story; independently testable after the foundational rename preparation.

### Parallel Opportunities

- T002, T003, and T004 can run in parallel because they are read-only inventory checks over distinct concerns.
- T018, T019, and T020 can run in parallel after the rename because they validate separate command surfaces.
- T010, T011, and T012 are logically parallel but edits to the same test files must be merged sequentially.

## Parallel Example: Final Validation

```text
Task: Validate the plural skill and objective record template
Task: Regenerate catalogs and adapters from canonical source
Task: Run adapter correspondence, packaging, and full-suite checks
```

## Implementation Strategy

### MVP First

1. Complete inventory and user-data snapshot tasks.
2. Rename the source and update hand-authored references.
3. Remove stale singular generated artifacts and regenerate plural outputs.
4. Run exact-token, stale-path, adapter, and packaging checks.

### Incremental Delivery

1. Establish the canonical plural source identity.
2. Bring generated adapters, catalogs, manifests, tests, and documentation into correspondence.
3. Prove no stale singular identity remains and no user-owned objective data changed.
4. Run the complete suite and final diff/spec-record checks.

## Notes

- `[P]` marks tasks that can be prepared independently; edits to the same file must still be merged sequentially.
- The active Feature 028 planning directory is excluded only from its own explanatory scan; the implementation must not add an allowlisted old-name reference elsewhere.
- Do not create or regenerate root-level user-owned objective records as part of this rename.
- Keep this feature limited to the skill rename, reference cleanup, generated-artifact refresh, and validation described above.
