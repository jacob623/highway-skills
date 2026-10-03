---

description: "Implementation tasks for Contribution Opportunity before convergence"
---

# Tasks: Contribution Opportunity Before Convergence

**Input**: Design documents from `/specs/133-contribution-opportunity/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Organization**: Tasks are grouped by user story. The shared Experience Standard is the only shipped implementation surface; the existing amendment contract is updated only where its rule inventory expectation must track X2.37.

## Phase 1: Setup

**Purpose**: Establish the baseline and protected boundaries before editing.

- [X] T001 Run `bash .highway/tools/tests/experience-standard-amendment.test.sh`, `bash .highway/tools/tests/highway-ux-alignment.test.sh`, and `bash .highway/tools/tests/rule-checks.test.sh` to record the Feature 133 baseline.
- [X] T002 [P] Verify `.highway/skills/highway-profile/SKILL.md`, `.highway/library/templates/output/profile-record.md`, `.highway/governance/constitution.md`, and owner skills remain protected dependencies and identify their existing authority-boundary anchors.

## Phase 2: Foundational

**Purpose**: Establish the shared rule and terminology before story-specific guidance.

- [X] T003 Add the `Contribution Opportunity` definition immediately after `Working Idea` in `.highway/governance/experience-standard.md`, explicitly keeping it transient and distinct from acceptance, persistence, and workflow state.
- [X] T004 Add X2.37 after X2.20 in `.highway/governance/experience-standard.md` without renumbering existing X2 rules; require the opportunity when Highway materially shaped a Working Idea and no prior opportunity occurred.
- [X] T005 Preserve and verify X2.2, X2.13, X2.18, X2.21, X2.22, X2.25, and X2.36 wording and existing authority boundaries in `.highway/governance/experience-standard.md`.

**Checkpoint**: Shared terminology and the new agent-checkable rule exist without changing acceptance or persistence semantics.

## Phase 3: User Story 1 - Give the Person a Substantive Contribution Opportunity (Priority: P1)

**Goal**: Ensure a materially Highway-shaped Working Idea gives the person a substantive opportunity before convergence.

**Independent Test**: Inspect the Interaction model and collaborative-development guidance, then run the Experience Standard amendment contract.

### Implementation for User Story 1

- [X] T006 [US1] Replace the existing inner development-loop sentence in `#### Interaction model` of `.highway/governance/experience-standard.md` with the four-step guidance for applicable Contribution Opportunity, incorporation and re-evaluation, mature-contribution exemption, and one-time Converged Proposal synthesis.
- [X] T007 [US1] Extend `##### Collaborative Development (Non-Normative Guidance)` in `.highway/governance/experience-standard.md` to distinguish Highway understanding the shape of an idea from the person's opportunity to contribute to that shape.
- [X] T008 [US1] Add `##### Contribution Opportunity (Non-Normative Guidance)` in `.highway/governance/experience-standard.md` with provisional substance, substantive-completeness versus final-representation distinction, non-prescriptive language examples, and explicit separation from X2.21 acceptance.
- [X] T009 [US1] Add Contribution Opportunity response handling and applicability guidance in `.highway/governance/experience-standard.md`, including incorporation/re-evaluation, nothing-else responses, useful Highway-shaped cases, and skip conditions.

**Checkpoint**: Highway-shaped Working Ideas offer substantive participation before convergence without creating a new acceptance state.

## Phase 4: User Story 2 - Keep Substance and Final Representation Distinct (Priority: P1)

**Goal**: Prevent duplicate final-form prose and preserve the existing Converged Proposal review boundary.

**Independent Test**: Review the interaction guidance and examples for provisional substance, one-time synthesis, and unchanged X2.21.

### Implementation for User Story 2

- [X] T010 [US2] Add the substance-versus-representation distinction to `##### Contribution Opportunity (Non-Normative Guidance)` in `.highway/governance/experience-standard.md`, including the two purposes and the prohibition on substantially identical final-form review twice.
- [X] T011 [US2] Add interaction examples under `#### Interaction Examples (Non-Normative)` in `.highway/governance/experience-standard.md` for Contribution Opportunity before convergence and avoiding duplicate final prose.
- [X] T012 [US2] Update the existing `Working Idea versus Converged Proposal` example in `.highway/governance/experience-standard.md` to show optional Contribution Opportunity after Highway materially shapes the substance and before final synthesis.
- [X] T013 [US2] Extend `#### Recommendation sets (Non-Normative)` in `.highway/governance/experience-standard.md` to cover positive reactions, substantial later synthesis, optional Contribution Opportunity, and unchanged X2.18/X2.25 behavior.

**Checkpoint**: The person completes substantive meaning once, then reviews the final artifact representation once.

## Phase 5: User Story 3 - Preserve Adaptive Depth and One-Question Discipline (Priority: P1)

**Goal**: Apply the shared boundary only when it adds value and never combine it with artifact acceptance.

**Independent Test**: Review mature-contribution, prior-opportunity, selected-proposal, explicit-proceed, and one-question paths in the standard.

### Implementation for User Story 3

- [X] T014 [US3] Add the mature/direct contribution exemption and non-ceremonial guidance to `.highway/governance/experience-standard.md` without changing X2.22.
- [X] T015 [US3] Add one-question discipline to `.highway/governance/experience-standard.md`, requiring Contribution Opportunity to be the response-demanding question for its interaction and forbidding a same-block artifact-acceptance question.
- [X] T016 [US3] Add the `Contribution Opportunity not needed` interaction example to `.highway/governance/experience-standard.md` and preserve adaptive-depth language.

**Checkpoint**: No mandatory "anything else?" turn is introduced for mature or already-complete contributions.

## Phase 6: User Story 4 - Preserve Existing Authority and Owner Boundaries (Priority: P1)

**Goal**: Keep Contribution Opportunity transient and shared while preserving all existing owner and acceptance boundaries.

**Independent Test**: Run protected-path checks and confirm no owner skill, template, Constitution, or retained artifact changes.

### Implementation for User Story 4

- [X] T017 [US4] Add explicit non-persistence, non-Setup-specific, and owner-responsibility guidance to `.highway/governance/experience-standard.md`.
- [X] T018 [US4] Add the full shared lifecycle and acceptance-criteria distinctions to `.highway/governance/experience-standard.md` without altering contribution-first precedence or existing acceptance semantics.
- [X] T019 [US4] Apply the current Experience Standard versioning policy in `.highway/governance/experience-standard.md`, add the X2.37 amendment record, and leave existing X identifiers unchanged.
- [X] T020 [US4] Update only the directly affected rule-count/anchor expectations in `.highway/tools/tests/experience-standard-amendment.test.sh` so the contract validates X2.37 and the preserved boundaries.

**Checkpoint**: The shared amendment does not add persisted state or modify owner-specific workflows.

## Phase 7: Polish and Validation

**Purpose**: Validate the finished standard, scope, and repository.

- [X] T021 Run `bash .highway/tools/tests/experience-standard-amendment.test.sh`, `bash .highway/tools/tests/highway-ux-alignment.test.sh`, and `bash .highway/tools/tests/rule-checks.test.sh` after implementation.
- [X] T022 [P] Verify protected paths remain unchanged with `git diff --name-only` checks for Profile, Objectives, Controls, NFRs, Setup, Constitution, templates, and retained artifact structures.
- [X] T023 Run `bash .highway/tools/tests/run-all.sh` and require zero failures.
- [X] T024 Run `git diff --check` and the Feature 133 quickstart assertions, then mark all completed tasks `[X]` in `specs/133-contribution-opportunity/tasks.md`.

## Dependencies and Execution Order

- Phase 1 precedes all other phases.
- Phase 2 precedes User Stories 1-4 because X2.37 and the definition establish the shared vocabulary.
- User Story 1 precedes User Story 2 because substance participation must be defined before representation guidance.
- User Story 2 and User Story 3 can be implemented in parallel after User Story 1's guidance exists.
- User Story 4 follows the substantive guidance and governs final boundary/version synchronization.
- Phase 7 follows all source and contract edits.

## Parallel Opportunities

- T002 can run in parallel with baseline T001.
- T010-T013 can be prepared in parallel after T008.
- T014-T016 can be prepared in parallel with User Story 2 after T009.
- T021 and T022 can run in parallel after all implementation edits.

## MVP Strategy

The MVP is User Story 1 plus User Story 2: define the boundary, provide substantive participation before convergence, and prevent duplicate final-form review. User Stories 3 and 4 are required for the complete amendment because adaptive depth and authority preservation are non-negotiable shared constraints.
