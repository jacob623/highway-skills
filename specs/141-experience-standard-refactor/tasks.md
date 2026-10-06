---

description: "Task list for the Experience Standard runtime contract refactor"
---

# Tasks: Experience Standard Runtime Contract Refactor

**Input**: Design documents from `specs/141-experience-standard-refactor/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Focused contract validation is required by the feature specification; full repository validation is required before completion.

## Phase 1: Setup

**Purpose**: Capture the protected baseline and establish focused validation inputs.

- [X] T001 Record the pre-refactor line count and current X-rule inventory from `.highway/governance/experience-standard.md`
- [X] T002 [P] Record protected-file hashes for `.highway/library/knowledge/highway-identity.md`, `.specify/memory/constitution.md`, and `.highway/skills/highway-profile/SKILL.md`

## Phase 2: Foundational

**Purpose**: Define executable checks before changing the shared runtime document.

- [X] T003 Add the Feature 141 focused contract test at `.highway/tools/tests/feature-141-experience-standard-refactor.test.sh`
- [X] T004 Run `.highway/tools/tests/feature-141-experience-standard-refactor.test.sh` against the unchanged baseline and record the expected baseline result

**Checkpoint**: Baseline and focused validation are ready before the runtime document changes.

## Phase 3: User Story 1 - Preserve the normative interaction contract (Priority: P1) MVP

**Goal**: Preserve every stable X-rule ID, Observable, convergence boundary, ownership boundary, and current supported behavior.

**Independent Test**: The focused contract test passes its complete X-rule, Observable, convergence, acceptance, and ownership assertions.

- [X] T005 [US1] Refactor `.highway/governance/experience-standard.md` to retain every current X-rule ID and Observable while removing redundant explanatory prose
- [X] T006 [US1] Preserve the distinction between domain completeness and conversational convergence in the definitions and X2.13/X2.41 guidance in `.highway/governance/experience-standard.md`
- [X] T007 [US1] Preserve artifact acceptance, user ownership, persistence, mature-contribution, and pure acceptance or selection boundaries in `.highway/governance/experience-standard.md`
- [X] T008 [US1] Run `bash .highway/tools/tests/feature-141-experience-standard-refactor.test.sh` and repair any local contract failure in `.highway/governance/experience-standard.md`

**Checkpoint**: The normative contract is preserved and independently validated.

## Phase 4: User Story 2 - Use one compact interaction model (Priority: P1)

**Goal**: Make one Interaction Model the sole full prose representation of the adaptive collaboration loop.

**Independent Test**: Focused checks confirm one Interaction Model covers context reuse, contribution, re-evaluation, clarification, Contribution Opportunity, convergence, acceptance, and hidden mechanics.

- [X] T009 [US2] Consolidate the adaptive collaboration loop into one Interaction Model in `.highway/governance/experience-standard.md`
- [X] T010 [US2] Retain concise Conversational Clarification and Contribution Opportunity guidance with mature-contribution and post-response re-evaluation boundaries in `.highway/governance/experience-standard.md`
- [X] T011 [US2] Run the focused contract test and verify no duplicate long-form interaction loop remains in `.highway/governance/experience-standard.md`

**Checkpoint**: The interaction model is compact, adaptive, and independently validated.

## Phase 5: User Story 3 - Keep targeted guidance and minimal boundary examples (Priority: P1)

**Goal**: Retain only the guidance and five examples needed to prevent likely misapplication across owning skills.

**Independent Test**: Focused checks confirm advisory, evolution, contextual, recommendation, ownership, and exactly-five-example boundaries remain answerable.

- [X] T012 [US3] Retain concise Constructive Advisory, Evolution-Aware, Contextual, Recommendation Sets, and ownership guidance in `.highway/governance/experience-standard.md`
- [X] T013 [US3] Retain exactly five minimal interaction boundary examples in `.highway/governance/experience-standard.md`
- [X] T014 [US3] Remove runtime history, abandoned designs, compatibility prose, candidate governance, and standalone duplicated guidance from `.highway/governance/experience-standard.md`
- [X] T015 [US3] Update version metadata, Last Amended metadata, and the self-application review in `.highway/governance/experience-standard.md`
- [X] T016 [US3] Run the focused contract test and verify the document is at least 25% shorter than the T001 baseline

**Checkpoint**: The retained guidance is complete, minimal, current, and independently validated.

## Phase 6: User Story 4 - Remove runtime history and verify self-application (Priority: P2)

**Goal**: Confirm protected artifacts remain unchanged and the full repository remains healthy.

**Independent Test**: Protected-file comparisons, diff checks, and the full repository suite pass with zero failures.

- [X] T017 [US4] Verify `.highway/library/knowledge/highway-identity.md`, `.specify/memory/constitution.md`, `.highway/skills/highway-profile/SKILL.md`, and every other skill are unchanged by Feature 141
- [X] T018 [US4] Run `git diff --check` and `.highway/tools/tests/run-all.sh`
- [X] T019 [US4] Update completed task markers and record final validation evidence in `specs/141-experience-standard-refactor/tasks.md`

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Confirm the implementation matches the specification and quickstart.

- [X] T020 [P] Run every command in `specs/141-experience-standard-refactor/quickstart.md` and confirm expected outcomes
- [X] T021 Review `.highway/governance/experience-standard.md` against all Feature 141 requirements and success criteria

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup and blocks all user stories.
- **User Stories (Phases 3-6)**: Depend on Foundational; execute sequentially because they modify or validate the same runtime document.
- **Polish (Phase 7)**: Depends on all user stories.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational and establishes normative preservation.
- **User Story 2 (P1)**: Depends on User Story 1 because the Interaction Model consolidates the preserved rules.
- **User Story 3 (P1)**: Depends on User Story 2 because targeted guidance and examples are retained after loop consolidation.
- **User Story 4 (P2)**: Depends on User Story 3 because final protected-path and full-suite validation applies to the complete refactor.

### Parallel Opportunities

- T002 can run in parallel with T001.
- The focused contract test and protected-file checks can be reviewed independently, but runtime document edits remain sequential.
- T020 can run independently after implementation while T021 performs the final specification review.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 and validate the preserved contract.
3. Complete User Stories 2 and 3 to deliver the compact runtime document.
4. Complete User Story 4 and run the full suite.

### Incremental Delivery

Each user story has an independent validation checkpoint, but the shared document edits are intentionally sequential to avoid conflicting changes to the same contract.

## Notes

- Every task includes an exact repository-relative file path.
- No external contracts directory is required.
- No generated adapters or unrelated skills may be modified.
