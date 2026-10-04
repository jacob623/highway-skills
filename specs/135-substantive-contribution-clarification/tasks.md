---

description: "Task list for substantive-contribution re-evaluation and conversational clarification"
---

# Tasks: Substantive Contribution Re-evaluation and Conversational Clarification

**Input**: Design documents from `/specs/135-substantive-contribution-clarification/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Focused static contract coverage is required by the feature specification; existing UX, rule, and full-suite checks remain regression validation.

**Organization**: Tasks are grouped by user story and ordered so the shared Experience Standard source changes are validated before completion.

## Phase 1: Setup

**Purpose**: Establish the baseline and protected scope.

- [X] T001 Run `bash .highway/tools/tests/experience-standard-amendment.test.sh`, `bash .highway/tools/tests/highway-ux-alignment.test.sh`, and `bash .highway/tools/tests/rule-checks.test.sh` and record the Feature 135 baseline.
- [X] T002 [P] Verify the amendment scope is limited to `.highway/governance/experience-standard.md` plus directly affected Experience Standard contract expectations; protect `.highway/skills/highway-clarify/SKILL.md`, `.highway/skills/highway-profile/SKILL.md`, `.highway/governance/constitution.md`, and `.highway/library/templates/output/profile-record.md` from changes.

## Phase 2: Foundational

**Purpose**: Add test-first coverage for the new definitions, rules, shared guidance, and forbidden artifact mechanics.

- [X] T003 Add failing Feature 135 assertions to `.highway/tools/tests/experience-standard-amendment.test.sh` for Substantive Contribution, Conversational Clarification, X2.38-X2.40, preserved X2.37, the updated interaction guidance, and the five new interaction scenarios.
- [X] T004 Run `bash .highway/tools/tests/experience-standard-amendment.test.sh` before modifying the Experience Standard and record the expected failures.
- [X] T005 [P] Add protected-path and forbidden-clarify-mechanics assertions to `.highway/tools/tests/experience-standard-amendment.test.sh` without changing shared test helpers or owner contracts.

## Phase 3: User Story 1 - Reconsider substantive contributions (Priority: P1) 🎯 MVP

**Goal**: Make re-evaluation after substantive contributions explicit before next behavior selection.

**Independent Test**: Focused amendment contract passes definitions, X2.38, acceptance-plus-new-information guidance, and the updated Interaction model.

### Implementation for User Story 1

- [X] T006 [US1] Add the Substantive Contribution and Conversational Clarification definitions immediately after Working Idea in `.highway/governance/experience-standard.md`.
- [X] T007 [US1] Add X2.38 in `.highway/governance/experience-standard.md` with the re-evaluation rule, Observable, and `[agent-checkable]` tier without renumbering existing X rules.
- [X] T008 [US1] Add acceptance-only versus acceptance-plus-new-information guidance after the X2.38 row in `.highway/governance/experience-standard.md`.
- [X] T009 [US1] Replace the Interaction model response step and add direct re-evaluation, selective clarification, and responsible-interpretation bullets in `.highway/governance/experience-standard.md`.
- [X] T010 [US1] Expand Collaborative Development guidance in `.highway/governance/experience-standard.md` to describe contribution-aware reasoning, new reasoning material, and universal re-evaluation with selective visible clarification.
- [X] T011 [US1] Run `bash .highway/tools/tests/experience-standard-amendment.test.sh` and `bash .highway/tools/tests/highway-ux-alignment.test.sh` for the User Story 1 checkpoint.

**Checkpoint**: Every Substantive Contribution is reconsidered before the next behavior, without requiring a clarification question when a responsible interpretation is available.

## Phase 4: User Story 2 - Resolve consequential uncertainty selectively (Priority: P1)

**Goal**: Add focused clarification behavior while preventing ceremonial questioning.

**Independent Test**: Focused assertions verify X2.39, X2.40, one-question discipline, natural examples, and no imported clarification-record mechanics.

### Implementation for User Story 2

- [X] T012 [US2] Add X2.39 and X2.40 in `.highway/governance/experience-standard.md` with their Observables and `[agent-checkable]` tiers.
- [X] T013 [US2] Add the `Conversational Clarification (Non-Normative Guidance)` section in `.highway/governance/experience-standard.md` with uncertainty categories, selective-question guidance, and natural examples.
- [X] T014 [US2] Add clarification-versus-Contribution Opportunity and clarification-versus-acceptance guidance in `.highway/governance/experience-standard.md`, preserving X2.37 and the existing one-question constraint.
- [X] T015 [US2] Add the five required non-compliant/compliant interaction examples to `#### Interaction Examples (Non-Normative)` in `.highway/governance/experience-standard.md`.
- [X] T016 [US2] Run the focused amendment contract and `bash .highway/tools/tests/rule-checks.test.sh` for the User Story 2 checkpoint.

**Checkpoint**: Consequential ambiguity is addressed before advancing, while clear contributions continue without interrogation.

## Phase 5: User Story 3 - Preserve collaborative-development boundaries (Priority: P1)

**Goal**: Extend re-evaluation through contextual lifecycle guidance without changing acceptance, persistence, or owner authority.

**Independent Test**: Existing acceptance, Contribution Opportunity, transience, and UX alignment anchors remain present alongside the two-loop lifecycle.

### Implementation for User Story 3

- [X] T017 [US3] Replace the Contextual Re-evaluation opening and add pre-acceptance and post-acceptance re-evaluation guidance in `.highway/governance/experience-standard.md`.
- [X] T018 [US3] Replace the explanatory re-evaluation lifecycle in `.highway/governance/experience-standard.md` with the Substantive Contribution and Accepted Knowledge loops.
- [X] T019 [US3] Strengthen Conversational Presence and Constructive Advisory guidance in `.highway/governance/experience-standard.md` with changed-understanding continuity and selective clarification.
- [X] T020 [US3] Preserve and verify X1.7, X2.2, X2.4, X2.8, X2.13, X2.18, X2.19, X2.21, X2.22, X2.37, adaptive depth, Active Reasoning Context, transience, and owner authority in `.highway/governance/experience-standard.md`.
- [X] T021 [US3] Run the focused amendment contract, UX alignment contract, and rule checks for the User Story 3 checkpoint.

**Checkpoint**: Clarification remains transient and selective; existing Contribution Opportunity, proposal, acceptance, and persistence boundaries remain intact.

## Phase 6: User Story 4 - Keep the shared standard scoped and versioned (Priority: P1)

**Goal**: Complete the amendment record, version increment, and protected-scope validation.

**Independent Test**: The standard reports version 8.2.0, 44 total rules, X2.38-X2.40, and no protected owner or clarify artifact changes.

### Implementation for User Story 4

- [X] T022 [US4] Update the Experience Standard Sync Impact Report and version footer in `.highway/governance/experience-standard.md` from 8.1.0 to 8.2.0 with the amendment rationale and preserved boundaries.
- [X] T023 [US4] Update `.highway/tools/tests/experience-standard-amendment.test.sh` rule-count and anchor expectations for 44 total rules, X2.38-X2.40, version 8.2.0, and the new interaction guidance.
- [X] T024 [US4] Run the focused amendment contract, UX alignment contract, and rule checks after all source and test changes.

**Checkpoint**: The shared Experience Standard is complete, versioned, and protected owner boundaries remain unchanged.

## Phase 7: Polish and Cross-Cutting Validation

**Purpose**: Validate the full feature and complete the implementation record.

- [X] T025 [P] Verify `git diff --name-only` contains only the Experience Standard source, directly affected Experience Standard test, and Feature 135 design artifacts; confirm protected owner paths are absent.
- [X] T026 [P] Run `git diff --check` and all commands in `specs/135-substantive-contribution-clarification/quickstart.md` that do not mutate source artifacts.
- [X] T027 Run `bash .highway/tools/tests/run-all.sh` and require zero failures after the final edit.
- [X] T028 Mark all completed tasks `[X]` in `specs/135-substantive-contribution-clarification/tasks.md` only after final validation succeeds.

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Must complete before source or test edits.
- **Foundational (Phase 2)**: Depends on the baseline and blocks implementation.
- **User Stories (Phases 3-6)**: Execute sequentially because they edit the same Experience Standard source and focused test.
- **Polish (Phase 7)**: Depends on all source and test changes.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Phase 2 and establishes the re-evaluation foundation.
- **User Story 2 (P1)**: Depends on User Story 1's definitions and interaction model.
- **User Story 3 (P1)**: Depends on User Story 2's clarification distinction and preserves lifecycle boundaries.
- **User Story 4 (P1)**: Depends on all preceding guidance and completes version and contract synchronization.

### Parallel Opportunities

- T002 and read-only portions of T005 can run in parallel after the baseline.
- T025 and T026 can run in parallel after source and test changes stabilize.
- No user-story source tasks are parallelized because they share the same governance document.

## Implementation Strategy

### MVP First

1. Complete the baseline and failing focused assertions.
2. Implement User Story 1 definitions, X2.38, and Interaction model behavior.
3. Run the focused contract and UX alignment checkpoint.
4. Continue with selective clarification, lifecycle guidance, versioning, and full validation before completion.

### Completion Standard

The feature is complete only when all 28 tasks are checked, the Experience Standard contract passes, X2.38-X2.40 are present with 44 total rules, protected paths are unchanged, and the full repository suite exits with zero failures.
