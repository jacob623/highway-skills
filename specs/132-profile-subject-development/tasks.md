---

description: "Implementation tasks for Profile subject transition and Working-Idea development"
---

# Tasks: Profile Subject Transition and Working-Idea Development

**Input**: Design documents from `/specs/132-profile-subject-development/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Organization**: Tasks are grouped by user story. The shipped source remains the Profile skill; generated adapters are synchronized after source changes.

## Phase 1: Setup

**Purpose**: Establish the baseline and confirm the protected boundaries before editing.

- [X] T001 Record the current Feature 132 baseline by running `bash .highway/tools/tests/feature-092-contract.test.sh`, `bash .highway/tools/tests/profile-behavior.test.sh`, `bash .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`, and `bash .highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T002 [P] Verify `.highway/library/templates/output/profile-record.md` and `.highway/governance/experience-standard.md` are unchanged dependencies and identify their existing Profile schema, readiness, and shared-precedence anchors.

## Phase 2: Foundational

**Purpose**: Define the source/test correspondence needed by every subject-development story.

- [X] T003 Add Feature 132 contract assertions in `.highway/tools/tests/feature-092-contract.test.sh` for the three visible subject headings, heading-before-content ordering, contextual re-evaluation separation, and focused-question precedence.
- [X] T004 [P] Add or update focused wording assertions in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`, `.highway/tools/tests/profile-behavior.test.sh`, and `.highway/tools/tests/highway-ux-alignment.test.sh` so shared Experience Standard ownership and the existing fallback remain covered.

**Checkpoint**: The focused contracts describe the Feature 132 behavior and fail only for the not-yet-updated Profile source.

## Phase 3: User Story 1 - See the Next Profile Subject Open Clearly (Priority: P1)

**Goal**: Make every unresolved subject visibly open with its domain heading before contribution or question content.

**Independent Test**: Run the Feature 092 Profile contract and confirm Vision, Competitive Path, and Guiding Principles headings precede their new content while accepted-subject re-evaluation remains separate.

### Implementation for User Story 1

- [X] T005 [US1] Update `.highway/skills/highway-profile/SKILL.md` subject-transition guidance so `### Where you're going`, `### How you'll get there`, and `### What will guide your decisions` visibly open their unresolved subjects before a Working Idea, Converged Proposal, or focused question.
- [X] T006 [US1] Update `.highway/skills/highway-profile/SKILL.md` contextual re-evaluation guidance so useful implications of the accepted subject remain distinguishable from the newly opened subject and internal workflow-state narration stays suppressed.
- [X] T007 [US1] Run `bash .highway/tools/tests/feature-092-contract.test.sh` and repair only the Profile source or directly affected Feature 132 assertions until the User Story 1 contract passes.

**Checkpoint**: Subject transitions are visibly separated and independently contract-tested.

## Phase 4: User Story 2 - Develop a Vision Working Idea with Focused Input (Priority: P1)

**Goal**: Continue a useful incomplete Vision Working Idea with one focused question instead of restarting the broad canonical question.

**Independent Test**: Run the Profile behavior and Feature 122 contracts and confirm complete evidence still converges directly, useful incomplete evidence yields a focused question, and insufficient evidence retains the canonical fallback.

### Implementation for User Story 2

- [X] T008 [US2] Update `.highway/skills/highway-profile/SKILL.md` Vision guidance to require a concrete grounded Working Idea when evidence can advance Vision without completing it.
- [X] T009 [US2] Update `.highway/skills/highway-profile/SKILL.md` Vision guidance to target the unresolved choice, distinction, priority, boundary, or organizational fact of an existing Working Idea and prohibit broad canonical-question fallback while useful progress exists.
- [X] T010 [US2] Preserve and explicitly align `.highway/skills/highway-profile/SKILL.md` complete-candidate precedence, canonical fallback, one-question constraint, and optional same-turn Working Idea plus focused question with the shared Experience Standard.
- [X] T011 [US2] Run `bash .highway/tools/tests/profile-behavior.test.sh` and `bash .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`; repair local wording or assertions until both pass.

**Checkpoint**: Vision develops grounded incomplete ideas without discarding prior progress.

## Phase 5: User Story 3 - Develop Later Subjects from Grounded Ideas (Priority: P1)

**Goal**: Apply focused Working-Idea development consistently to Competitive Path and Guiding Principles.

**Independent Test**: Run the Feature 092 contract and inspect both later-domain guidance paths for focused questions, complete-candidate precedence, and canonical fallback.

### Implementation for User Story 3

- [X] T012 [US3] Update `.highway/skills/highway-profile/SKILL.md` Competitive Path guidance so an incomplete Working Idea receives a focused question about its unresolved choice, tradeoff, capability, approach, or organizational fact rather than the broad canonical question.
- [X] T013 [US3] Update `.highway/skills/highway-profile/SKILL.md` Guiding Principles guidance so an incomplete Working Idea receives a focused question about its unresolved principle, decision boundary, tension, or priority rather than the broad canonical question.
- [X] T014 [US3] Preserve existing validation wording and direct Converged Proposal behavior for complete Competitive Path and Guiding Principles candidates in `.highway/skills/highway-profile/SKILL.md`.
- [X] T015 [US3] Re-run `bash .highway/tools/tests/feature-092-contract.test.sh` and confirm all three subject transitions and later-domain focused paths pass together.

**Checkpoint**: All unresolved Profile subjects use the same grounded development precedence.

## Phase 6: User Story 4 - Preserve Grounding and Profile Ownership (Priority: P1)

**Goal**: Allow grounded alternatives and advisory perspective while keeping Working Ideas transient and the existing acceptance boundary authoritative.

**Independent Test**: Run the Profile and UX contracts, inspect the retained template, and verify no schema, readiness, persistence, or shared Standard files changed.

### Implementation for User Story 4

- [X] T016 [US4] Update `.highway/skills/highway-profile/SKILL.md` Working-Idea guidance to permit only materially distinct, accepted-evidence-grounded alternatives, preserve the user-authored path, and keep alternatives transient.
- [X] T017 [US4] Update `.highway/skills/highway-profile/SKILL.md` guidance to permit a grounded advisory preference without presenting it as accepted organizational truth, and keep generic examples subordinate to grounded contributions.
- [X] T018 [US4] Verify `.highway/skills/highway-profile/SKILL.md` preserves schema `3.0.0`, the four retained domains, the three readiness states, acceptance/persistence ordering, Active Reasoning Context ownership, completion synthesis, and error handling.
- [X] T019 [US4] Run `bash .highway/tools/tests/highway-ux-alignment.test.sh` and verify protected-file scope with `git diff --name-only -- .highway/library/templates/output/profile-record.md .highway/governance/experience-standard.md`.

**Checkpoint**: Richer development remains grounded, transient, and owned by the existing Profile acceptance boundary.

## Phase 7: Polish and Correspondence

**Purpose**: Synchronize generated artifacts and complete repository validation.

- [X] T020 Regenerate the declared Profile adapters and manifest with `.highway/tools/generate-agent-adapters.sh` after `.highway/skills/highway-profile/SKILL.md` is final.
- [X] T021 [P] Verify `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, `.agents/skills/highway-profile/SKILL.md`, and `.highway/tools/.adapter-manifest` correspond to the source.
- [X] T022 Run `bash .highway/tools/tests/run-all.sh` and require zero failures.
- [X] T023 Run `git diff --check` and the Feature 132 quickstart validation, then mark all completed tasks `[X]` in `specs/132-profile-subject-development/tasks.md`.

## Dependencies and Execution Order

- Phase 1 precedes all other phases.
- Phase 2 precedes User Stories 1-4 because their focused assertions define the behavior under test.
- User Story 1 precedes User Story 2 because Vision's focused development follows the visible subject transition.
- User Story 2 precedes User Story 3 because later-domain development extends the same precedence established for Vision.
- User Story 4 may be implemented alongside User Story 3 after the foundational assertions exist, but final validation waits for all stories.
- Phase 7 follows all source and contract edits; adapter regeneration follows the final source wording.

## Parallel Opportunities

- T002 and T004 can run in parallel after T001.
- Within User Story 1, T005 and T006 are the same source slice and should be applied together; T007 follows them.
- Within User Story 3, T012 and T013 are independent guidance sections and can be prepared in parallel, with T014 and T015 following.
- T016 and T017 are independent grounding rules in the same source skill and can be prepared together; T018 and T019 follow.
- T021 can run after T020 while focused tests are prepared for the final suite.

## MVP Strategy

The MVP is User Story 1 plus User Story 2: visible subject openings and focused Vision Working-Idea development. User Stories 3 and 4 are required for the complete Feature 132 acceptance because later subjects and ownership boundaries must not regress.
