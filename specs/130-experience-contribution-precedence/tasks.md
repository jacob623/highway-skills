---
description: "Task list for Experience Contribution Precedence"
---

# Tasks: Experience Contribution Precedence

**Input**: Design documents from `specs/130-experience-contribution-precedence/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Included because the specification requires document-contract validation, protected-boundary checks, and the full repository suite.

**Organization**: Tasks are grouped by user story. All implementation work targets the single shared Experience Standard document.

## Phase 1: Setup

**Purpose**: Establish the amendment baseline and confirm the protected shared-standard scope.

- [X] T001 Read `specs/130-experience-contribution-precedence/spec.md`, `plan.md`, `research.md`, `data-model.md`, and `quickstart.md`; record the sole implementation target and protected rules.
- [X] T002 [P] Capture the baseline hash and diff state of `.highway/governance/experience-standard.md`, individual skills, retained templates, and constitution authorities.
- [X] T003 [P] Inventory current X2.2, X2.13, X2.25, Interaction model, Collaborative Development, Context Awareness, Interaction Examples, and Recommendation sets wording in `.highway/governance/experience-standard.md`.

## Phase 2: Foundational

**Purpose**: Confirm governance constraints and the validation boundary before editing the shared standard.

- [X] T004 Verify the applicable Packaging, Documentation Currency, and Verification Before and After gates in `.specify/memory/constitution.md`.
- [X] T005 [P] Verify protected X2.18, X2.19, X2.21, X2.22, X2.25, X2.7, X2.11, X2.24, X2.29, X2.30, X2.36, Constitution P11.3, and Constitution P11.4 references remain present before implementation.
- [X] T006 [P] Run `bash .highway/tools/tests/run-all.sh` before the first implementation edit and record the baseline result in `specs/130-experience-contribution-precedence/quickstart.md`.

**Checkpoint**: The shared-standard scope, protected boundaries, and passing baseline are confirmed.

## Phase 3: User Story 1 - Contribute Before Asking (Priority: P1) MVP

**Goal**: Make the Converged Proposal -> useful Working Idea -> focused question precedence explicit in normative interaction rules.

**Independent Test**: Inspect `.highway/governance/experience-standard.md` and verify X2.2, X2.13, and the Interaction model select the strongest grounded contribution before a question.

### Tests for User Story 1

- [X] T007 [P] [US1] Run the repository-owned document-contract assertions for X2.2 and X2.13 precedence in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T008 [P] [US1] Validate complete-candidate, useful-Working-Idea, and focused-question wording through the repository-owned focused Experience Standard contract.

### Implementation for User Story 1

- [X] T009 [US1] Replace the X2.2 Observable in `.highway/governance/experience-standard.md` with evaluation for a useful Working Idea or Converged Proposal before questioning.
- [X] T010 [US1] Replace the X2.13 rule and Observable in `.highway/governance/experience-standard.md` with explicit Converged Proposal -> useful Working Idea -> focused unresolved question precedence.
- [X] T011 [US1] Replace the two Interaction model bullets in `.highway/governance/experience-standard.md` with strongest-contribution and post-evaluation questioning language.

**Checkpoint**: The normative standard distinguishes complete convergence, useful incomplete contribution, and focused-question fallback.

## Phase 4: User Story 2 - Preserve Ownership and Acceptance Boundaries (Priority: P1)

**Goal**: Preserve grounding, user ownership, artifact acceptance, and workflow-narration boundaries while adding contribution-first guidance.

**Independent Test**: Review the amended standard and protected-rule assertions; no Working Idea is accepted as organizational truth and no X2.36 duplicate is introduced.

### Tests for User Story 2

- [X] T012 [P] [US2] Run protected-rule assertions for X2.18, X2.19, X2.21, X2.22, and X2.25 in `.highway/tools/tests/experience-standard-amendment.test.sh`.
- [X] T013 [P] [US2] Run grounding and ownership assertions for X2.7, X2.11, X2.24, X2.29, X2.30, X2.36, Constitution P11.3, and Constitution P11.4 through the repository-owned contract.

### Implementation for User Story 2

- [X] T014 [US2] Add the insufficient-Converged-Proposal versus useful-Working-Idea distinction, fallback conditions, and contribution precedence guidance under Collaborative Development in `.highway/governance/experience-standard.md`.
- [X] T015 [US2] Add useful Working Idea qualification and appropriate-question guidance in `.highway/governance/experience-standard.md` without exposing category labels as normal conversation requirements.
- [X] T016 [US2] Confirm `.highway/governance/experience-standard.md` does not duplicate X2.36 and that individual skills, retained templates, and governing Constitution files remain unchanged.

**Checkpoint**: Contribution-first behavior helps thinking without weakening ownership, grounding, or acceptance boundaries.

## Phase 5: User Story 3 - Keep Collaboration Adaptive and Natural (Priority: P1)

**Goal**: Add non-normative examples and recommendation guidance while preserving immediate convergence, natural conclusions, and adaptive depth.

**Independent Test**: Review the examples and Recommendation sets guidance for Working-Idea-first, useful-contribution-then-question, immediate-convergence, Context Awareness, and no-forced-verbosity cases.

### Tests for User Story 3

- [X] T017 [P] [US3] Validate the three requested contribution examples and Context Awareness wording through the focused Experience Standard contract and direct document checks.
- [X] T018 [P] [US3] Validate Recommendation sets guidance and preserved adaptive-depth language through direct document checks and the full suite.

### Implementation for User Story 3

- [X] T019 [US3] Add the three non-normative contribution examples to Interaction Examples in `.highway/governance/experience-standard.md`.
- [X] T020 [US3] Replace the Context Awareness context-aware example and add the Recommendation sets Working-Idea-before-question guidance in `.highway/governance/experience-standard.md`.
- [X] T021 [US3] Review `.highway/governance/experience-standard.md` for adaptive depth, immediate convergence, natural conclusion, and no mandatory verbosity; correct only amendment-caused contradictions.

**Checkpoint**: The shared standard demonstrates the precedence without forcing extra turns or recommendations.

## Phase 6: Polish & Cross-Cutting Validation

**Purpose**: Confirm final scope, correspondence, protected boundaries, and completion evidence.

- [X] T022 Run the focused Experience Standard contract and the full `bash .highway/tools/tests/run-all.sh` suite; record results in `specs/130-experience-contribution-precedence/quickstart.md`.
- [X] T023 Run `git diff --check` over `.highway/governance/experience-standard.md` and `specs/130-experience-contribution-precedence/`; scan for placeholders and unresolved clarification markers.
- [X] T024 Verify only `.highway/governance/experience-standard.md` changed in the implementation slice and no individual skill or retained schema changed.
- [X] T025 Mark completed tasks in `specs/130-experience-contribution-precedence/tasks.md` and record the final version, validation result, and deferred Profile synchronization boundary in `quickstart.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the baseline.
- **Foundational (Phase 2)**: Depends on Setup and blocks implementation.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the normative precedence MVP.
- **User Story 2 (Phase 4)**: Depends on User Story 1; protects ownership and acceptance boundaries.
- **User Story 3 (Phase 5)**: Depends on User Story 1 and User Story 2; completes guidance and examples.
- **Polish (Phase 6)**: Depends on all user stories and final validation.

### User Story Dependencies

- **User Story 1 (P1)**: Independent after Foundational; establishes the core precedence.
- **User Story 2 (P1)**: Follows US1 to verify protected boundaries.
- **User Story 3 (P1)**: Follows US1 and US2 to add adaptive guidance and examples.

### Parallel Opportunities

- T002 and T003 can run in parallel during Setup.
- T005 and T006 can run in parallel during Foundational work.
- T007-T008 can run in parallel because they cover separate normative assertions.
- T012-T013 can run in parallel because they cover separate protected-boundary groups.
- T017-T018 can run in parallel because they cover separate guidance assertions.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Implement User Story 1's X2.2, X2.13, and Interaction model changes.
3. Run the focused contract and validate the precedence independently.

### Incremental Delivery

1. Add the normative precedence.
2. Prove ownership and acceptance boundaries remain intact.
3. Add adaptive guidance and non-normative examples.
4. Run focused and full validation.
5. Freeze the shared standard and defer individual-skill synchronization.

## Notes

- The implementation target is exactly `.highway/governance/experience-standard.md`.
- No contracts directory is required because this feature exposes no external API or command interface.
- Generated adapters and catalogs are not inputs to this amendment and must not be changed.
