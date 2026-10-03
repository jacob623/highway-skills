---

description: "Task list for proving Contribution Opportunity in highway-profile"
---

# Tasks: Profile Contribution Opportunity

**Input**: Design documents from `/specs/134-profile-contribution-opportunity/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Focused contract coverage is required by the feature specification and constitution; existing repository contracts remain regression checks.

**Organization**: Tasks are grouped by user story and ordered to keep the shared Profile skill source changes sequential.

## Phase 1: Setup

**Purpose**: Establish the baseline and confirm the narrow protected scope.

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` from the repository root and record a passing baseline before editing Feature 134 files.
- [X] T002 [P] Verify `.highway/governance/experience-standard.md`, `.highway/governance/constitution.md`, `.highway/library/templates/output/profile-record.md`, `.highway/skills/highway-setup/SKILL.md`, `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, and `.highway/skills/highway-nfrs/SKILL.md` are protected from Feature 134 changes.

## Phase 2: Foundational

**Purpose**: Add the focused contract scaffold and establish the source/generated artifact relationship before story work.

- [X] T003 Add `.highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh` with Bash 3.2-compatible helpers, declared artifact classes, protected-path checks, and failing assertions for the required Profile Contribution Opportunity anchors.
- [X] T004 Run the new focused contract before the Profile implementation and record its expected failure under the test-first verification requirement.
- [X] T005 [P] Confirm the generator inputs and dependent outputs for `.highway/skills/highway-profile/SKILL.md` using the existing adapter, catalog, library-catalog, and instruction generator paths documented in `specs/134-profile-contribution-opportunity/plan.md`.

## Phase 3: User Story 1 - Offer substantive contribution before convergence (Priority: P1) 🎯 MVP

**Goal**: Make Profile apply the shared Contribution Opportunity when it materially shaped a Vision, Competitive Path, or Guiding Principles Working Idea.

**Independent Test**: Run the Feature 134 contract and inspect the three domain paths for provisional substantive content before the Converged Proposal.

### Implementation for User Story 1

- [X] T006 [US1] Update the Profile model and Working Idea/Converged Proposal guidance in `.highway/skills/highway-profile/SKILL.md` to consume X2.37 without creating a Profile-local rule or acceptance boundary.
- [X] T007 [US1] Add shared Enrichment guidance in `.highway/skills/highway-profile/SKILL.md` for provisional substantive pieces, material Profile shaping, direct convergence exemptions, and substance-versus-representation behavior.
- [X] T008 [US1] Update Vision, Competitive Path, and Guiding Principles guidance in `.highway/skills/highway-profile/SKILL.md` so each applicable domain offers a Contribution Opportunity before synthesizing its cohesive Converged Proposal.
- [X] T009 [US1] Add domain-specific Contribution Opportunity substance patterns in `.highway/skills/highway-profile/SKILL.md` while keeping internal enrichment category names hidden and existing subject transitions unchanged.
- [X] T010 [US1] Run `bash .highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh` and the adjacent Profile contracts after the source changes; repair only local failures before proceeding.

**Checkpoint**: Profile offers substantive participation for materially Profile-shaped Vision, Competitive Path, and Guiding Principles Working Ideas without changing final acceptance.

## Phase 4: User Story 2 - Preserve adaptive depth and Identity accuracy (Priority: P1)

**Goal**: Skip ceremonial opportunities for mature or already-complete contributions and preserve complete Identity validation behavior.

**Independent Test**: Run focused scenarios for domain-complete user contributions, prior equivalent opportunities, explicit finished-contributing intent, and complete discovered Identity.

### Implementation for User Story 2

- [X] T011 [US2] Add mature/direct contribution, prior-opportunity, explicit-proceed, and complete Identity skip guidance to `.highway/skills/highway-profile/SKILL.md` without changing existing domain completeness or X2.22 behavior.
- [X] T012 [US2] Add focused assertions for adaptive-depth exemptions and complete Identity accuracy validation to `.highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh`.
- [X] T013 [US2] Run the focused contract and `bash .highway/tools/tests/profile-behavior.test.sh` to verify the exemption paths and preserved Profile behavior.

**Checkpoint**: Profile does not manufacture an "anything else?" turn for mature, complete, or already-opportunity-covered input.

## Phase 5: User Story 3 - Keep contribution, convergence, and acceptance distinct (Priority: P1)

**Goal**: Preserve transient Working Idea handling, one-question discipline, separate Converged Proposal acceptance, and existing persistence ownership.

**Independent Test**: Verify additive and "nothing else" responses update or complete the transient opportunity, then require a separate domain acceptance decision before persistence.

### Implementation for User Story 3

- [X] T014 [US3] Add response handling, transient-state, no-persistence, no-duplicate-prose, and one-question guidance to `.highway/skills/highway-profile/SKILL.md`.
- [X] T015 [US3] Add focused assertions for additive responses, completion-intent responses, separate acceptance, no duplicate final-form prose, and no combined unresolved question to `.highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh`.
- [X] T016 [US3] Run `bash .highway/tools/tests/profile-lifecycle.test.sh`, `bash .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`, and the Feature 134 contract to verify preserved lifecycle and acceptance boundaries.

**Checkpoint**: Contribution Opportunity responses remain transient and never authorize persistence without the existing Converged Proposal acceptance.

## Phase 6: User Story 4 - Preserve owner boundaries and generated artifacts (Priority: P1)

**Goal**: Keep Profile ownership, readiness/schema/persistence boundaries, protected dependencies, and generated outputs intact.

**Independent Test**: Regenerate declared outputs, run protected-path assertions, and verify the Profile skill version and verification section document the complete behavior.

### Implementation for User Story 4

- [X] T017 [US4] Add Profile Verification bullets for applicability, exemptions, substance versus representation, response semantics, Vision/Competitive Path/Guiding Principles coverage, Identity accuracy, and one-question discipline in `.highway/skills/highway-profile/SKILL.md`.
- [X] T018 [US4] Update the Profile skill version in `.highway/skills/highway-profile/SKILL.md` according to the Skill Versioning Policy and preserve all existing owner, readiness, schema, and persistence language.
- [X] T019 [P] [US4] Regenerate Profile-dependent adapters, catalogs, and instructions using `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-instructions.sh` as applicable.
- [X] T020 [US4] Run `bash .highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh`, `bash .highway/tools/tests/highway-ux-alignment.test.sh`, and generator correspondence checks after regeneration.

**Checkpoint**: The shipped Profile skill and all generated dependents agree, while protected owner and shared artifacts remain unchanged.

## Phase 7: Polish and Cross-Cutting Validation

**Purpose**: Validate the complete implementation against the plan, specification, and repository contracts.

- [X] T021 [P] Verify `git diff --name-only` contains only the Feature 134 Profile source, focused contract, required generated dependents, and Feature 134 artifacts; confirm protected paths are absent.
- [X] T022 [P] Run `git diff --check` and inspect the Feature 134 quickstart assertions in `specs/134-profile-contribution-opportunity/quickstart.md`.
- [X] T023 Run `bash .highway/tools/tests/run-all.sh` and require zero failures after the final edit.
- [X] T024 Mark all completed tasks `[X]` in `specs/134-profile-contribution-opportunity/tasks.md` only after the final validation succeeds.

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Must complete before any source or test edit.
- **Foundational (Phase 2)**: Depends on the baseline and blocks user-story implementation.
- **User Stories (Phases 3-6)**: Execute sequentially because they update the same Profile skill and focused contract; each checkpoint must pass before the next story.
- **Polish (Phase 7)**: Depends on all source, test, and generated-artifact edits.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Phase 2 and is the MVP; establishes the shared Profile behavior.
- **User Story 2 (P1)**: Depends on User Story 1's applicable path and adds exemptions.
- **User Story 3 (P1)**: Depends on User Story 1 and User Story 2 guidance; preserves response and acceptance boundaries.
- **User Story 4 (P1)**: Depends on all prior story guidance; completes verification, versioning, and generated-output synchronization.

### Parallel Opportunities

- T002 and T005 can run in parallel during setup/foundation because they are read-only scope checks.
- T019 can run in parallel with independent inspection work after the Profile source is stable, but generated outputs must be treated as one regeneration group.
- T021 and T022 can run in parallel after all implementation and regeneration tasks complete.

## Implementation Strategy

### MVP First

1. Complete baseline and focused contract scaffold.
2. Implement User Story 1 for Vision, Competitive Path, and Guiding Principles.
3. Run the focused contract and adjacent Profile checks.
4. Continue with exemptions, acceptance boundaries, verification, and generation before declaring the feature complete.

### Completion Standard

The feature is complete only when all 24 tasks are checked, the focused contract passes, generated artifacts are synchronized, protected paths are unchanged, and the full repository suite exits with zero failures.
