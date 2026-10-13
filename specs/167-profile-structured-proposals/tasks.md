---

description: "Implementation tasks for Profile Structured Proposals"
---

# Tasks: Profile Structured Proposals

**Input**: Design documents from `/specs/167-profile-structured-proposals/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Focused static contract coverage is required by the specification and runs through the existing Bash test harness.

**Organization**: Tasks are grouped by user story while preserving ordering for the shared Profile source and focused contract test.

## Phase 1: Setup

**Purpose**: Establish the existing source, adapter, and test surfaces for the feature.

- [X] T001 Inspect the current Vision, Competitive Path, Guiding Principles, Interpretation Confidence, and Contribution in Practice sections in `.highway/skills/highway-profile/SKILL.md` and record the existing headings and acceptance boundaries in the implementation notes
- [X] T002 Confirm the four generated Profile adapter paths and the auto-discovered test convention in `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, `.agents/skills/highway-profile/SKILL.md`, and `.highway/tools/tests/run-all.sh`

## Phase 2: Foundational

**Purpose**: Create the focused contract surface that all domain-specific changes will satisfy.

- [X] T003 Add the Feature 167 static contract test at `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh` with fixture-free assertions for adapter equality, required existing proposal headings, shared correction wording, provisional boundaries, and no-new-lifecycle/readiness constraints
- [X] T004 Run `bash .highway/tools/tests/feature-167-profile-structured-proposals.test.sh` against the unchanged source and document the expected failing assertions before implementation in `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh`

## Phase 3: User Story 1 - Review a proposed Vision starting point (Priority: P1) 🎯 MVP

**Goal**: Present an evidence-grounded, structured Vision starting point before exploratory questions when accepted context supports one, while retaining the focused-question fallback.

**Independent Test**: The focused contract test verifies the Vision opportunity heading, evidence condition, structured bullets, reaction invitation, ordering before the Vision question, and insufficient-evidence fallback.

### Tests for User Story 1

- [X] T005 [US1] Extend `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh` with Vision-specific assertions for accepted-context grounding, proposal-first ordering, structured bullet presentation, and the add/correct/remove invitation

### Implementation for User Story 1

- [X] T006 [US1] Add the Vision Discovery Contribution Opportunity and structured starting-point guidance to the Vision section of `.highway/skills/highway-profile/SKILL.md`, preserving the existing Vision question, proposal heading, domain continuity, and acceptance boundary
- [X] T007 [US1] Add the Vision insufficient-evidence fallback and substantive-reaction refinement guidance to `.highway/skills/highway-profile/SKILL.md` without creating a new lifecycle state or persisted artifact
- [X] T001 Inspect the current Vision, Competitive Path, Guiding Principles, Interpretation Confidence, and Contribution in Practice sections in `.highway/skills/highway-profile/SKILL.md` and record the existing headings and acceptance boundaries in the implementation notes
- [X] T002 Confirm the four generated Profile adapter paths and the auto-discovered test convention in `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, `.agents/skills/highway-profile/SKILL.md`, and `.highway/tools/tests/run-all.sh`

## Phase 4: User Story 2 - Review a proposed Competitive Path starting point (Priority: P1)

**Goal**: Present a structured Competitive Path interpretation grounded in accepted Identity, Vision, and Profile evidence before exploratory questions when responsible.

- [X] T003 Add the Feature 167 static contract test at `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh` with fixture-free assertions for adapter equality, required existing proposal headings, shared correction wording, provisional boundaries, and no-new-lifecycle/readiness constraints
- [X] T004 Run `bash .highway/tools/tests/feature-167-profile-structured-proposals.test.sh` against the unchanged source and document the expected failing assertions before implementation in `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh`
### Tests for User Story 2

- [X] T008 [US2] Extend `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh` with Competitive Path assertions for accepted-context grounding, structured presentation, domain exclusions, reaction handling, and question fallback

### Implementation for User Story 2

- [X] T009 [US2] Add the Competitive Path Discovery Contribution Opportunity and structured starting-point guidance to the Competitive Path section of `.highway/skills/highway-profile/SKILL.md`, preserving the existing Vision continuity and Competitive Path proposal and acceptance boundaries
- [X] T010 [US2] Add Competitive Path correction, refinement, and insufficient-evidence fallback guidance to `.highway/skills/highway-profile/SKILL.md` without turning the starting point into Controls, NFRs, architecture, implementation requirements, or plans


## Phase 5: User Story 3 - Review proposed Guiding Principles individually (Priority: P1)

- [X] T005 [US1] Extend `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh` with Vision-specific assertions for accepted-context grounding, proposal-first ordering, structured bullet presentation, and the add/correct/remove invitation
- [X] T006 [US1] Add the Vision Discovery Contribution Opportunity and structured starting-point guidance to the Vision section of `.highway/skills/highway-profile/SKILL.md`, preserving the existing Vision question, proposal heading, domain continuity, and acceptance boundary
- [X] T007 [US1] Add the Vision insufficient-evidence fallback and substantive-reaction refinement guidance to `.highway/skills/highway-profile/SKILL.md` without creating a new lifecycle state or persisted artifact
**Independent Test**: The focused contract test verifies the Guiding Principles opportunity heading, individual-item presentation, reaction invitation, ordering before its question, and fallback behavior.

### Tests for User Story 3

- [X] T011 [US3] Extend `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh` with Guiding Principles assertions for individually visible values, accepted-context grounding, reaction handling, and question fallback

### Implementation for User Story 3

- [X] T012 [US3] Add the Guiding Principles Discovery Contribution Opportunity and individually visible structured-item guidance to the Guiding Principles section of `.highway/skills/highway-profile/SKILL.md`, preserving the existing Controls boundary and proposal acceptance behavior

**Checkpoint**: Guiding Principles has an independently reviewable structured starting point, reaction path, and question fallback.

- [X] T008 [US2] Extend `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh` with Competitive Path assertions for accepted-context grounding, structured presentation, domain exclusions, reaction handling, and question fallback
- [X] T009 [US2] Add the Competitive Path Discovery Contribution Opportunity and structured starting-point guidance to the Competitive Path section of `.highway/skills/highway-profile/SKILL.md`, preserving the existing Vision continuity and Competitive Path proposal and acceptance boundaries
- [X] T010 [US2] Add Competitive Path correction, refinement, and insufficient-evidence fallback guidance to `.highway/skills/highway-profile/SKILL.md` without turning the starting point into Controls, NFRs, architecture, implementation requirements, or plans
**Goal**: Ensure all three starting points remain Contribution Opportunities and flow into the existing convergence, proposal, acceptance, persistence, readiness, ownership, and attribution behavior.

**Independent Test**: The focused contract test verifies that each starting point is provisional, is not a Converged Proposal or acceptance request, requires substantive reaction before convergence, and preserves existing domain proposal headings and boundaries.

### Tests for User Story 4

- [X] T014 [US4] Extend `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh` with shared convergence, acceptance, persistence, readiness, ownership, attribution, no-new-field, and no-synthesis-only assertions across Vision, Competitive Path, and Guiding Principles

### Implementation for User Story 4
- [X] T015 [US4] Add the shared proposal-first interpretation clarification near Interpretation Confidence or Contribution in Practice in `.highway/skills/highway-profile/SKILL.md`, stating that structured starting points are preferred when accepted evidence supports them and questions remain available otherwise
- [X] T016 [US4] Align the three domain sections in `.highway/skills/highway-profile/SKILL.md` with the existing Identity Contribution Opportunity pattern, including correction-oriented reaction, re-evaluation after substantive contribution, and transition to normal convergence only after refinement stabilizes

- [X] T011 [US3] Extend `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh` with Guiding Principles assertions for individually visible values, accepted-context grounding, reaction handling, and question fallback
- [X] T012 [US3] Add the Guiding Principles Discovery Contribution Opportunity and individually visible structured-item guidance to the Guiding Principles section of `.highway/skills/highway-profile/SKILL.md`, preserving the existing Controls boundary and proposal acceptance behavior
- [X] T013 [US3] Add Guiding Principles correction, refinement, attribution, and insufficient-evidence fallback guidance to `.highway/skills/highway-profile/SKILL.md` without inventing accepted values or adding a new persistence path
## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate distributed artifacts and complete repository verification.

- [X] T017 Regenerate the four Profile adapters from `.highway/skills/highway-profile/SKILL.md` with `bash .highway/tools/generate-agent-adapters.sh`
- [X] T018 Regenerate catalog artifacts with `bash .highway/tools/generate-catalog.sh` after the source Profile skill change
- [X] T019 Run `bash .highway/tools/validate-skill.sh .highway/skills/highway-profile` and `bash .highway/tools/tests/feature-167-profile-structured-proposals.test.sh`, then repair any focused contract failures in the owning Profile source or test files
- [X] T020 Run `bash .highway/tools/tests/run-all.sh` and confirm the full repository suite passes, then run `git diff --check`


### Phase Dependencies

- [X] T014 [US4] Extend `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh` with shared convergence, acceptance, persistence, readiness, ownership, attribution, no-new-field, and no-synthesis-only assertions across Vision, Competitive Path, and Guiding Principles
- [X] T015 [US4] Add the shared proposal-first interpretation clarification near Interpretation Confidence or Contribution in Practice in `.highway/skills/highway-profile/SKILL.md`, stating that structured starting points are preferred when accepted evidence supports them and questions remain available otherwise
- [X] T016 [US4] Align the three domain sections in `.highway/skills/highway-profile/SKILL.md` with the existing Identity Contribution Opportunity pattern, including correction-oriented reaction, re-evaluation after substantive contribution, and transition to normal convergence only after refinement stabilizes
- **User Stories (Phases 3-6)**: Depend on Foundational; remain ordered because they edit the same source and test files.
- **Polish (Phase 7)**: Depends on all user-story changes; regenerates adapters/catalog and runs full verification.

### User Story Dependencies

- [X] T017 Regenerate the four Profile adapters from `.highway/skills/highway-profile/SKILL.md` with `bash .highway/tools/generate-agent-adapters.sh`
- [X] T018 Regenerate catalog artifacts with `bash .highway/tools/generate-catalog.sh` after the source Profile skill change
- [X] T019 Run `bash .highway/tools/validate-skill.sh .highway/skills/highway-profile` and `bash .highway/tools/tests/feature-167-profile-structured-proposals.test.sh`, then repair any focused contract failures in the owning Profile source or test files
- **User Story 4 (P1)**: Applies shared lifecycle preservation after the three domain opportunities are present.

### Parallel Opportunities

- No implementation tasks are marked `[P]` because the three user stories and their contract assertions share `.highway/skills/highway-profile/SKILL.md` and `.highway/tools/tests/feature-167-profile-structured-proposals.test.sh`.
- After T017 and T018, validation commands in T019 can be run together only if their output directories and manifest updates do not conflict; run them sequentially for deterministic diagnostics.

## Parallel Example: User Story 1

```bash
# The source and focused test share ordering-sensitive contract content, so keep these tasks sequential.
Task: "Extend .highway/tools/tests/feature-167-profile-structured-proposals.test.sh with Vision assertions"
Task: "Add Vision starting-point guidance to .highway/skills/highway-profile/SKILL.md"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement the Vision starting point and fallback.
3. Validate the focused Vision assertions independently.
4. Continue through the remaining stories before regeneration because all stories share one shipped skill.

### Incremental Delivery

1. Establish the focused contract.
2. Add Vision, then Competitive Path, then Guiding Principles guidance.
3. Add shared convergence and acceptance protections.
4. Regenerate adapters and catalog artifacts.
5. Run focused validation and the full repository suite.

## Notes

- `[P]` tasks would indicate independent file work; none are used because the implementation surface is shared.
- `[US1]` through `[US4]` map directly to the four user stories in `spec.md`.
- The implementation must preserve existing Profile behavior and must not create a new runtime service or persisted data model.
