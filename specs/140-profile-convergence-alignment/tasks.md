---

description: "Task list for Profile Convergence Alignment"
---

# Tasks: Profile Convergence Alignment

**Input**: Design documents from `/specs/140-profile-convergence-alignment/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Focused static document-contract validation is required by the feature specification and Constitution verification rules.

## Phase 1: Setup

**Purpose**: Establish the existing source, test, and generated-artifact boundaries.

- [X] T001 Confirm the Feature 140 source, test, adapter, and protected-artifact paths against `specs/140-profile-convergence-alignment/plan.md` and `.specify/feature.json`
- [X] T002 Record the passing pre-edit baseline with `.highway/tools/tests/run-all.sh`

## Phase 2: Foundational

**Purpose**: Add the focused validation surface before changing the Profile guidance.

- [X] T003 [P] Add the Feature 140 static Profile contract test in `.highway/tools/tests/feature-140-profile-convergence-alignment.test.sh`, declaring its instrument and artifact classes and asserting the required convergence, reciprocal-development, provisional-structure, domain-validation, ownership, and protected-path outcomes
- [X] T004 Run `.highway/tools/tests/feature-140-profile-convergence-alignment.test.sh` and record the expected pre-implementation failure for missing convergence-alignment wording

## Phase 3: User Story 1 - Separate Profile completeness from conversational convergence (Priority: P1) MVP

**Goal**: Make Profile domain completeness and shared conversational convergence explicit in the model, acquisition, enrichment, and final validation triggers.

**Independent Test**: The Feature 140 contract test identifies distinct completeness/convergence conditions in the Profile model, acquisition, enrichment, all four domains, and verification without changing acceptance wording or readiness behavior.

### Tests for User Story 1

- [X] T005 [US1] Extend `.highway/tools/tests/feature-140-profile-convergence-alignment.test.sh` with assertions for the model boundary, acquisition precedence, fallback behavior, enrichment boundary, and convergence-gated final validation

### Implementation for User Story 1

- [X] T006 [US1] Amend `.highway/skills/highway-profile/SKILL.md` from version 7.0.0 to the Constitution-compliant minor version and update the Profile model, acquisition, fallback, enrichment, shared validation-role, and provisional-structure guidance
- [X] T007 [US1] Update the Identity, Vision, Competitive Path, and Guiding Principles sections in `.highway/skills/highway-profile/SKILL.md` so final validation requires both domain completeness and shared conversational convergence while preserving existing acceptance wording and direct/mature-contribution paths

**Checkpoint**: The source Profile skill expresses the central completeness/convergence boundary and the focused contract passes for User Story 1.

## Phase 4: User Story 2 - Apply reciprocal domain-specific development (Priority: P1)

**Goal**: Allow useful Profile connections, possibilities, and substantive responses to be discussed and re-evaluated before provisional or final structure.

**Independent Test**: The focused contract test finds Profile-specific reciprocal-development guidance for Identity, Vision, Competitive Path, and Guiding Principles without a duplicate generic Experience Standard loop.

### Tests for User Story 2

- [X] T008 [US2] Add assertions to `.highway/tools/tests/feature-140-profile-convergence-alignment.test.sh` for conversational development, substantive response re-entry, advisory possibilities, strategic connections, principle refinement, and absence of duplicated generic mechanics

### Implementation for User Story 2

- [X] T009 [US2] Add Profile-specific conversational development and contextual re-evaluation guidance to `.highway/skills/highway-profile/SKILL.md` for Identity, Vision, Competitive Path, and Guiding Principles, including response-driven re-entry and advisory calibration
- [X] T010 [US2] Add broad-strategy versus downstream-implementation ownership guidance to `.highway/skills/highway-profile/SKILL.md` and preserve all existing downstream exclusions

**Checkpoint**: Each Profile domain supports reciprocal substantive development while the Experience Standard remains authoritative for generic mechanics.

## Phase 5: User Story 3 - Preserve Profile domain and ownership boundaries (Priority: P1)

**Goal**: Demonstrate that the alignment changes only Profile-specific guidance and preserves readiness, acquisition, persistence, mutation, retained structure, and owner boundaries.

**Independent Test**: The focused contract and existing Profile tests pass while protected files remain unchanged and all four readiness domains and persistence semantics remain intact.

### Tests for User Story 3

- [X] T011 [US3] Add protected-path, preserved-domain, readiness, persistence, acceptance-wording, and downstream-boundary assertions to `.highway/tools/tests/feature-140-profile-convergence-alignment.test.sh`

### Implementation for User Story 3

- [X] T012 [US3] Verify the amended `.highway/skills/highway-profile/SKILL.md` retains the four readiness domains, acquisition sources, canonical questions, ownership exclusions, mutation-before-dependent-output behavior, and retained template citation without modifying protected artifacts
- [X] T013 [US3] Regenerate `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, and `.agents/skills/highway-profile/SKILL.md` from the source using `.highway/tools/generate-agent-adapters.sh`

**Checkpoint**: Source and generated Profile artifacts are synchronized and preservation checks pass.

## Phase 6: User Story 4 - Keep canonical questions and verification actionable (Priority: P2)

**Goal**: Keep questions as fallbacks, make convergence-specific verification outcomes visible, and avoid manufacturing turns or duplicating shared rules.

**Independent Test**: The focused contract confirms canonical fallback conditions, no manufactured turns for mature direct contributions, Profile-specific verification outcomes, and no local copy of shared mechanics.

### Tests for User Story 4

- [X] T014 [US4] Add canonical-fallback, mature-contribution, no-manufactured-turn, Profile-specific verification, and generic-rule-duplication assertions to `.highway/tools/tests/feature-140-profile-convergence-alignment.test.sh`

### Implementation for User Story 4

- [X] T015 [US4] Extend the Verification section in `.highway/skills/highway-profile/SKILL.md` with the required Profile-specific convergence, re-entry, advisory, ownership, and no-manufactured-turn checks
- [X] T016 [US4] Re-run the focused Feature 140 contract test and inspect `.highway/skills/highway-profile/SKILL.md` for unresolved premature-convergence wording without changing shared Experience Standard mechanics

**Checkpoint**: Profile verification is actionable and remains a Profile-specific application of the shared standard.

## Phase 7: Polish & Cross-Cutting Validation

**Purpose**: Validate generated correspondence, protected paths, and the complete shipped tree.

- [X] T017 [P] Run `git diff --check` and verify all four generated Profile adapters are byte-identical to `.highway/skills/highway-profile/SKILL.md`
- [X] T018 Run `.highway/tools/tests/run-all.sh` and confirm zero failures
- [X] T019 Run the Feature 140 quickstart commands from `specs/140-profile-convergence-alignment/quickstart.md` and confirm no changes to `profile-record.md`, the Constitution, Experience Standard, Highway Identity, setup, Objectives, or downstream owner artifacts

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on the baseline task and blocks story implementation.
- **User Stories (Phases 3-6)**: Depend on the foundational contract test; execute in priority order because they amend one source skill and one focused test.
- **Polish (Phase 7)**: Depends on all story work and adapter regeneration.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Phase 2 and establishes the core completeness/convergence boundary.
- **User Story 2 (P1)**: Depends on User Story 1's boundary wording because reciprocal development must feed that distinction.
- **User Story 3 (P1)**: Depends on User Stories 1-2 and verifies that the alignment did not alter retained or downstream contracts.
- **User Story 4 (P2)**: Depends on User Stories 1-3 and completes Profile-specific verification and fallback coverage.

### Parallel Opportunities

- T003 can be prepared independently of source implementation.
- Within the test file, assertion additions for each story can be prepared as one sequential contract because they share the same fixture path.
- T017's adapter correspondence and whitespace checks can run in parallel with review of generated artifacts after T013.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete setup and baseline validation.
2. Add and observe the focused contract failure.
3. Implement the completeness/convergence boundary and convergence-gated validation.
4. Run the focused User Story 1 contract.

### Incremental Delivery

1. Add reciprocal domain-specific development guidance.
2. Verify ownership, readiness, persistence, and generated-artifact preservation.
3. Add actionable Profile-specific Verification checks.
4. Run the quickstart and full suite with zero failures.

## Notes

- Every task has a checkbox, sequential ID, and an exact repository path.
- `[P]` marks only work that can proceed independently without sharing an incomplete file.
- No contracts directory is required because Feature 140 exposes no external API or command schema.
