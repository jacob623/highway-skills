---
description: "Task list for Profile Verification cleanup"
---

# Tasks: Profile Verification Cleanup

**Input**: Design documents from `specs/129-profile-verification-cleanup/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Included because the specification requires focused Profile validation, correspondence,
behavioral testing, and Grow Creative setup before Profile is frozen.

**Organization**: Tasks are grouped by user story; the three stories share one source file and one
protected-boundary inventory, so execution is sequential where the source contract overlaps.

## Phase 1: Setup

**Purpose**: Establish the cleanup baseline and protected-file inventory.

- [X] T001 Read `specs/129-profile-verification-cleanup/spec.md`, `plan.md`, `research.md`, `data-model.md`, and `quickstart.md`; record the protected Profile paths and cleanup-only scope in `specs/129-profile-verification-cleanup/quickstart.md`.
- [X] T002 [P] Capture the baseline of `.highway/skills/highway-profile/SKILL.md`, `.highway/library/templates/output/profile-record.md`, shared governance authorities, and generated Profile correspondence with `git diff` and repository hashes.
- [X] T003 [P] Inventory the stale Verification assertions and duplicate final Experience section in `.highway/skills/highway-profile/SKILL.md` and the directly affected Profile contract tests under `.highway/tools/tests/`.

## Phase 2: Foundational

**Purpose**: Confirm the shared collaborative vocabulary and protected boundaries before editing Verification.

- [X] T004 Verify the authoritative Working Idea, Converged Proposal, Active Reasoning Context, contextual re-evaluation, and acceptance-boundary wording in `.highway/governance/experience-standard.md`, `.highway/governance/constitution.md`, and `.highway/library/knowledge/highway-identity.md`.
- [X] T005 [P] Verify `schema_version: 3.0.0`, the four retained domains, the three readiness states, and the optional context structure in `.highway/library/templates/output/profile-record.md` without modifying it.
- [X] T006 [P] Run `bash .highway/tools/tests/profile-structure.test.sh`, `bash .highway/tools/tests/profile-markdown-contract.test.sh`, and `bash .highway/tools/tests/output-template.test.sh` to establish protected-record coverage before the Verification cleanup.

**Checkpoint**: Protected Profile semantics and shared collaborative authorities are confirmed.

## Phase 3: User Story 1 - Verify Collaborative Profile Lifecycle (Priority: P1) MVP

**Goal**: Replace stale Verification language with checks for Working Ideas, Converged Proposals, adaptive convergence, acceptance boundaries, and contextual re-evaluation.

**Independent Test**: Inspect `.highway/skills/highway-profile/SKILL.md` and run the focused Profile behavior and lifecycle contracts; stale paragraph-only, acknowledgment-stage, and one-observation checks are absent while the new lifecycle checks are present.

### Tests for User Story 1

- [X] T007 [P] [US1] Update stale Verification assertions in `.highway/tools/tests/profile-behavior.test.sh` to require Working Idea, Converged Proposal, active reasoning, adaptive convergence, contextual re-evaluation, and readability wording.
- [X] T008 [P] [US1] Update lifecycle assertions in `.highway/tools/tests/profile-lifecycle.test.sh` to distinguish Working Idea agreement from Converged Proposal acceptance and preserve acceptance-before-persistence ordering.
- [X] T009 [P] [US1] Update structure assertions in `.highway/tools/tests/profile-structure.test.sh` to confirm transient Working Ideas do not establish `discussed`, `bounded`, or a new readiness state.

### Implementation for User Story 1

- [X] T010 [US1] Replace the nine stale Verification assertions in `.highway/skills/highway-profile/SKILL.md` with the specified Working Idea, Converged Proposal, contextual re-evaluation, validation-boundary, fallback, and readability checks.
- [X] T011 [US1] Replace the one-observation Verification limit in `.highway/skills/highway-profile/SKILL.md` with unrestricted grounded advisory contribution governed by the shared Experience Standard.
- [X] T012 [US1] Remove the duplicate final `### Experience` section from `.highway/skills/highway-profile/SKILL.md` while preserving the existing Experience reference in the interaction model.

**Checkpoint**: User Story 1 is independently testable; Verification describes the intended collaborative lifecycle without changing Profile behavior.

## Phase 4: User Story 2 - Preserve Profile Ownership and Boundaries (Priority: P1)

**Goal**: Prove the Verification cleanup did not change Profile schema, readiness, website scope, persistence ordering, or brownfield boundaries.

**Independent Test**: Compare the cleaned source and protected template, run ownership/context/UX contracts, and confirm no shared governance or retained-record files changed.

### Tests for User Story 2

- [X] T013 [P] [US2] Update `.highway/tools/tests/feature-092-contract.test.sh` to preserve Profile schema, readiness, website, category, and ownership assertions while removing only obsolete Verification wording.
- [X] T014 [P] [US2] Update `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh` to assert contextual re-evaluation and transient accepted-evidence boundaries without a required acknowledgment stage.
- [X] T015 [P] [US2] Review `.highway/tools/tests/highway-ux-alignment.test.sh` for Profile-specific stale wording and preserve all shared UX coverage.

### Implementation for User Story 2

- [X] T016 [US2] Confirm `.highway/skills/highway-profile/SKILL.md` retains Acquisition, Enrichment, Operations, readiness, persistence, completion synthesis, error handling, canonical questions, subject headings, and website scope unchanged outside Verification.
- [X] T017 [US2] Confirm `.highway/library/templates/output/profile-record.md`, `.highway/governance/constitution.md`, `.highway/governance/experience-standard.md`, and `.highway/library/knowledge/highway-identity.md` remain unchanged by the cleanup.

**Checkpoint**: User Story 2 is independently testable; protected Profile ownership and data semantics remain intact.

## Phase 5: User Story 3 - Prepare Profile for Behavioral Testing (Priority: P1)

**Goal**: Regenerate correspondence, run focused behavioral checks and Grow Creative setup, and freeze Profile for the iteration.

**Independent Test**: Run focused Profile contracts, correspondence checks, Grow Creative setup, and the full repository suite; then confirm no unresolved stale Verification language remains.

### Tests for User Story 3

- [X] T018 [P] [US3] Run the focused Profile checks from `specs/129-profile-verification-cleanup/quickstart.md` and repair only cleanup-caused regressions.
- [X] T019 [P] [US3] Run the repository-owned generators `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-library-catalog.sh` after the source skill changes.
- [X] T020 [P] [US3] Run `.highway/tools/tests/feature-092-correspondence.test.sh`, `.highway/tools/tests/adapter-coverage.test.sh`, and `.highway/tools/tests/path-integrity.test.sh` to verify generated correspondence.

### Implementation for User Story 3

- [X] T021 [US3] Run the Grow Creative setup workflow and record whether partial ideas, mature convergence, Converged Proposal acceptance, contextual re-evaluation, and natural transitions behave as specified in `specs/129-profile-verification-cleanup/quickstart.md`.
- [X] T022 [US3] Run `bash .highway/tools/tests/run-all.sh` and record the complete result in `specs/129-profile-verification-cleanup/quickstart.md`.
- [X] T023 [US3] Review the final Profile source, focused tests, generated adapters, catalogs, and manifests against `spec.md` and `plan.md`; confirm Profile is frozen and the next work can move to Objectives.

**Checkpoint**: User Story 3 is independently testable; Profile Verification is clean, behaviorally validated, correspondent, and frozen.

## Phase 6: Polish & Cross-Cutting Validation

**Purpose**: Confirm final scope, task completion, protected boundaries, and artifact quality.

- [X] T024 Run `git diff --check` over `.highway/skills/highway-profile/SKILL.md`, directly affected tests, generated Profile correspondence, and `specs/129-profile-verification-cleanup/`; confirm no unresolved placeholders remain.
- [X] T025 Verify the protected Profile template hash is unchanged and no retained Working Idea, Active Reasoning Context, collaboration, maturity, or evolution fields were introduced.
- [X] T026 Mark all completed tasks in `specs/129-profile-verification-cleanup/tasks.md` and record final validation results in `specs/129-profile-verification-cleanup/quickstart.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the cleanup baseline.
- **Foundational (Phase 2)**: Depends on Setup and blocks source edits.
- **User Story 1 (Phase 3)**: Depends on Foundational; recommended MVP.
- **User Story 2 (Phase 4)**: Depends on User Story 1 because it verifies the cleaned source against protected boundaries.
- **User Story 3 (Phase 5)**: Depends on User Stories 1 and 2 because generators and behavioral testing require the stabilized source contract.
- **Polish (Phase 6)**: Depends on all three user stories and final validation.

### User Story Dependencies

- **User Story 1 (P1)**: Independent after Foundational; delivers the Verification cleanup MVP.
- **User Story 2 (P1)**: Follows US1 to validate preservation but does not add a persisted data model.
- **User Story 3 (P1)**: Follows US1 and US2 to validate correspondence and behavioral readiness.

### Parallel Opportunities

- T002 and T003 can run in parallel during Setup.
- T005 and T006 can run in parallel during Foundational work.
- T007-T009 can run in parallel because they update separate focused test contracts.
- T013-T015 can run in parallel because they update separate contract surfaces.
- T018-T020 can run in parallel after the source stabilizes.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Update Verification assertions and remove the duplicate final Experience section.
3. Run User Story 1 focused checks.
4. Stop and validate the collaborative lifecycle before preservation and correspondence work.

### Incremental Delivery

1. Establish the protected baseline and shared vocabulary.
2. Deliver the Verification cleanup as the MVP.
3. Prove schema, readiness, ownership, and shared UX preservation.
4. Regenerate correspondence and run behavioral testing/Grow Creative setup.
5. Run the full suite, freeze Profile, and move to Objectives.

## Notes

- All tasks use exact repository paths and are intentionally limited to Verification cleanup and validation.
- Generated artifacts must be changed only through declared repository generators.
- No task introduces Profile schema fields, readiness states, persisted reasoning context, or a new external contract.
