---
description: "Task list for Profile Contribution-First Synchronization"
---

# Tasks: Profile Contribution-First Synchronization

**Input**: Design documents from `specs/131-profile-contribution-precedence/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Included because the specification requires Profile contract verification and a clean full repository suite.

**Organization**: Tasks are grouped by user story; shipped implementation remains limited to `highway-profile/SKILL.md`.

## Phase 1: Setup

**Purpose**: Establish the protected Profile baseline and identify directly affected assertions.

- [x] T[0-9][0-9][0-9] Read `specs/131-profile-contribution-precedence/spec.md`, `plan.md`, `research.md`, `data-model.md`, and `quickstart.md`; record the exact scope and protected files.
- [x] T[0-9][0-9][0-9] [P] Capture baseline hashes for `.highway/skills/highway-profile/SKILL.md`, `.highway/library/templates/output/profile-record.md`, and `.highway/governance/experience-standard.md`.
- [x] T[0-9][0-9][0-9] [P] Inventory Acquisition, Enrichment, Verification, schema, readiness, persistence, and canonical-question wording in `.highway/skills/highway-profile/SKILL.md` and related Profile contracts.

## Phase 2: Foundational

**Purpose**: Confirm governance constraints and passing baseline before Profile guidance changes.

- [x] T[0-9][0-9][0-9] Verify applicable constitution gates and the security-triggered P4.5/P4.6 boundary in `.highway/governance/constitution.md`.
- [x] T[0-9][0-9][0-9] [P] Verify `.highway/library/templates/output/profile-record.md` and `.highway/governance/experience-standard.md` are protected unchanged dependencies.
- [x] T[0-9][0-9][0-9] [P] Run `bash .highway/tools/tests/feature-092-contract.test.sh`, `bash .highway/tools/tests/highway-ux-alignment.test.sh`, and `bash .highway/tools/tests/run-all.sh`; record the baseline results in `specs/131-profile-contribution-precedence/quickstart.md`.

**Checkpoint**: Profile scope, protected boundaries, and baseline validation are confirmed.

## Phase 3: User Story 1 - Apply Shared Precedence During Profile Acquisition (Priority: P1) MVP

**Goal**: Make Acquisition consume the shared Converged Proposal -> useful Working Idea -> focused question precedence.

**Independent Test**: The Profile Acquisition and Verification guidance explicitly selects the shared order and uses the canonical question only after both contribution forms are unavailable or user knowledge is genuinely required.

### Tests for User Story 1

- [x] T[0-9][0-9][0-9] [P] [US1] Update stale Acquisition assertions in `.highway/tools/tests/feature-092-contract.test.sh` to require the shared contribution-precedence sentence.
- [x] T[0-9][0-9][0-9] [P] [US1] Add or update Profile-specific assertions in `.highway/tools/tests/feature-092-contract.test.sh` for incomplete proposal grounding, useful Working Idea fallback, and focused canonical-question fallback.

### Implementation for User Story 1

- [x] T[0-9][0-9][0-9] [US1] Replace the Acquisition ordering sentence in `.highway/skills/highway-profile/SKILL.md` with the shared contribution precedence.
- [x] T[0-9][0-9][0-9] [US1] Add the Profile-specific clarification after the canonical-question paragraph in `.highway/skills/highway-profile/SKILL.md`.
- [x] T[0-9][0-9][0-9] [US1] Replace the canonical-question Verification check in `.highway/skills/highway-profile/SKILL.md` with the ordered Converged Proposal, Working Idea, focused-question check.
- [x] T[0-9][0-9][0-9] [US1] Add the Profile-specific Working Idea Verification check in `.highway/skills/highway-profile/SKILL.md`.

**Checkpoint**: Acquisition no longer treats incomplete proposal grounding as automatic question fallback.

## Phase 4: User Story 2 - Enrich Profile Domains Through Accumulated Context (Priority: P1)

**Goal**: Apply the shared precedence independently to Vision, Competitive Path, and Guiding Principles using accumulated accepted Profile context.

**Independent Test**: Each domain’s guidance and Verification checks evaluate a complete candidate, then a useful domain-specific Working Idea, before its canonical question.

### Tests for User Story 2

- [x] T[0-9][0-9][0-9] [P] [US2] Add or update Vision precedence assertions in `.highway/tools/tests/feature-092-contract.test.sh`.
- [x] T[0-9][0-9][0-9] [P] [US2] Add or update Competitive Path and Guiding Principles accumulated-context assertions in `.highway/tools/tests/feature-092-contract.test.sh`.

### Implementation for User Story 2

- [x] T[0-9][0-9][0-9] [US2] Replace the first two Vision enrichment sentences in `.highway/skills/highway-profile/SKILL.md` with the shared precedence wording while preserving the validation sentence.
- [x] T[0-9][0-9][0-9] [US2] Add the Vision Working Idea collaboration sentence immediately after the Vision bullet in `.highway/skills/highway-profile/SKILL.md`.
- [x] T[0-9][0-9][0-9] [US2] Add shared-precedence guidance to the Competitive Path bullet in `.highway/skills/highway-profile/SKILL.md`.
- [x] T[0-9][0-9][0-9] [US2] Add shared-precedence guidance to the Guiding Principles bullet in `.highway/skills/highway-profile/SKILL.md`.
- [x] T[0-9][0-9][0-9] [US2] Add the Vision, Competitive Path, and Guiding Principles accumulated-context Verification checks in `.highway/skills/highway-profile/SKILL.md`.

**Checkpoint**: All later Profile domains compound accepted context before canonical fallback.

## Phase 5: User Story 3 - Preserve Profile Ownership and Existing Boundaries (Priority: P1)

**Goal**: Replace the generic recommendation fallback with the precise two-contribution fallback while preserving all Profile ownership and persistence boundaries.

**Independent Test**: The Profile skill retains transient Working Ideas, existing acceptance and mutation ordering, schema/readiness semantics, website scope, and all protected Profile behavior.

### Tests for User Story 3

- [x] T[0-9][0-9][0-9] [P] [US3] Add assertions for the precise generic fallback wording and preserved Working Idea/Converged Proposal boundary in `.highway/tools/tests/feature-092-contract.test.sh`.
- [x] T[0-9][0-9][0-9] [P] [US3] Add scope assertions ensuring `.highway/library/templates/output/profile-record.md`, other skills, and `.highway/governance/experience-standard.md` remain unchanged in `.highway/tools/tests/feature-092-contract.test.sh` or the focused Profile contract.

### Implementation for User Story 3

- [x] T[0-9][0-9][0-9] [US3] Replace the generic recommendation fallback sentence in `.highway/skills/highway-profile/SKILL.md` with the precise Converged Proposal/Working Idea/user-knowledge fallback.
- [x] T[0-9][0-9][0-9] [US3] Review `.highway/skills/highway-profile/SKILL.md` to ensure no new Profile-local X2.13 rule, persisted Working Idea state, schema change, readiness change, or persistence change was introduced.

**Checkpoint**: Profile consumes shared interaction behavior without duplicating the Experience Standard or changing retained Profile semantics.

## Phase 6: Polish & Cross-Cutting Validation

**Purpose**: Validate exact scope, contracts, artifacts, and final repository health.

- [x] T[0-9][0-9][0-9] Run `bash .highway/tools/tests/feature-092-contract.test.sh`, `bash .highway/tools/tests/highway-ux-alignment.test.sh`, and `bash .highway/tools/tests/run-all.sh`; record final results in `specs/131-profile-contribution-precedence/quickstart.md`.
- [x] T[0-9][0-9][0-9] Run `git diff --check`, verify only `highway-profile/SKILL.md` and directly affected Profile contract assertions changed, and confirm protected template/governance/other-skill paths are unchanged.
- [x] T[0-9][0-9][0-9] Mark all completed tasks in `specs/131-profile-contribution-precedence/tasks.md` and record the final validation result and deferred follow-up boundaries in `quickstart.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the baseline.
- **Foundational (Phase 2)**: Depends on Setup and blocks user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the Acquisition MVP.
- **User Story 2 (Phase 4)**: Depends on Foundational and User Story 1; applies precedence to later domains.
- **User Story 3 (Phase 5)**: Depends on Foundational and User Story 1; preserves ownership and fallback boundaries.
- **Polish (Phase 6)**: Depends on all user stories.

### User Story Dependencies

- **User Story 1 (P1)**: Independent after Foundational; establishes the core fallback order.
- **User Story 2 (P1)**: Builds on the shared order from US1 and compounds accepted Profile context.
- **User Story 3 (P1)**: Builds on US1 while protecting existing Profile semantics; can be reviewed alongside US2 after the core edit.

### Parallel Opportunities

- T002 and T003 can run in parallel during Setup.
- T005 and T006 can run in parallel during Foundational work.
- T007-T008 can run in parallel before US1 implementation.
- T013-T014 can run in parallel before US2 implementation.
- T020-T021 can run in parallel before US3 implementation.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Implement Acquisition precedence and canonical fallback clarification.
3. Run the focused Profile contract and verify the central failure mode is corrected.

### Incremental Delivery

1. Synchronize Acquisition.
2. Synchronize Vision, Competitive Path, and Guiding Principles.
3. Replace the generic fallback and recheck ownership/schema boundaries.
4. Run focused contracts and the full suite.
5. Leave Profile-specific behavioral expansion, if any, to later work; do not redesign Profile.

## Notes

- The shipped implementation target is `.highway/skills/highway-profile/SKILL.md`.
- Directly affected Profile contract assertions may be updated to prevent stale literal expectations.
- `profile-record.md`, other skills, `.highway/governance/experience-standard.md`, generated artifacts, schema, readiness, and persistence remain out of scope.
