# Tasks: Profile Runtime Architecture Alignment

**Input**: Design documents from `/specs/148-profile-runtime-alignment/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Included because the feature specification defines independent test criteria and the repository requires focused contract coverage for shipped skill changes.

## Phase 1: Setup

**Purpose**: Confirm the existing Profile contract and generated-artifact scope before implementation.

- [X] T001 Read `specs/148-profile-runtime-alignment/spec.md`, `plan.md`, `research.md`, and `data-model.md` and record the protected files and acceptance boundaries in the implementation notes
- [X] T002 [P] Inspect `.highway/tools/.adapter-manifest` and `.highway/tools/.instruction-manifest` to confirm every generated Profile output path before changing the source skill
- [X] T003 [P] Capture the baseline focused Profile test results from `.highway/tools/tests/profile-behavior.test.sh`, `.highway/tools/tests/profile-runtime-separation.test.sh`, and `.highway/tools/tests/profile-convergence-behavior.test.sh`

---

## Phase 2: Foundational

**Purpose**: Establish failing, focused contract coverage for the revised ownership boundaries before editing the shipped skill.

- [X] T004 [P] Add Feature 148 assertions for Profile version `9.0.0`, Highway Identity-only context, retired runtime dependency removal, and local failure ownership in `.highway/tools/tests/profile-runtime-separation.test.sh`
- [X] T005 [P] Add Feature 148 assertions for Experience Standard delegation, absence of a separate Profile convergence procedure, and acceptance-after-Converged-Proposal behavior in `.highway/tools/tests/profile-convergence-behavior.test.sh`
- [X] T006 [P] Add Feature 148 assertions for four-domain readiness, cross-domain evidence, optional retrieval, persistence gating, and exactly-once completion synthesis in `.highway/tools/tests/profile-behavior.test.sh`

**Checkpoint**: Focused tests express the revised contract and fail only for the unimplemented Profile behavior.

---

## Phase 3: User Story 1 - Profile-owned organizational meaning (Priority: P1) MVP

**Goal**: Preserve Profile ownership of the four domains, completeness, acceptance, readiness, and persistence while removing unrelated runtime dependencies.

**Independent Test**: Run the Profile behavior and runtime-separation tests with incomplete, bounded, complete, malformed, and accepted-mutation scenarios; verify readiness remains limited to the four Profile domains and only persisted state advances results.

### Tests for User Story 1

- [X] T007 [US1] Extend `.highway/tools/tests/profile-behavior.test.sh` with executable checks for the four domain meanings, readiness dimensions, accepted evidence, malformed-state blocking, and persistence-before-readiness behavior
- [X] T008 [US1] Extend `.highway/tools/tests/profile-runtime-separation.test.sh` with executable checks that Profile references Highway Identity only as non-normative context and omits Highway Vision, Highway Platform Objectives, and Constitution common failure model runtime dependencies

### Implementation for User Story 1

- [X] T009 [US1] Update Inputs, purpose, ownership boundaries, version metadata, and retained Profile domain semantics in `.highway/skills/highway-profile/SKILL.md`
- [X] T010 [US1] Rewrite Profile readiness, acceptance, mutation, and local failure wording in `.highway/skills/highway-profile/SKILL.md` so failed persistence cannot advance dependent results
- [X] T011 [US1] Remove retired Highway Vision, Highway Platform Objectives, and Constitution common failure model runtime references from `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 1 is independently testable and the source skill remains authoritative for Profile domain state and persistence.

---

## Phase 4: User Story 2 - Experience-governed collaboration (Priority: P1)

**Goal**: Make the Highway Experience Standard the sole owner of generic collaboration while Profile supplies only domain semantics and acceptance boundaries.

**Independent Test**: Run the convergence behavior test against mature direct input, ambiguity, substantive correction, useful grounded development, and non-converged proposals; verify no Profile convergence algorithm or duplicate generic interaction procedure remains.

### Tests for User Story 2

- [X] T012 [US2] Extend `.highway/tools/tests/profile-convergence-behavior.test.sh` with assertions for delegation of Working Ideas, advisory reasoning, clarification, Contribution Opportunities, re-evaluation, short paths, and conversational convergence
- [X] T013 [US2] Add negative assertions in `.highway/tools/tests/profile-runtime-separation.test.sh` for the removed `Semantic convergence decision` procedure and other duplicate generic interaction mechanics

### Implementation for User Story 2

- [X] T014 [US2] Remove the `Semantic convergence decision` procedure and transient clarification/convergence ownership from `.highway/skills/highway-profile/SKILL.md`
- [X] T015 [US2] Retain Profile-specific acceptance questions and domain completeness wording while explicitly requiring a Converged Proposal from the Highway Experience Standard in `.highway/skills/highway-profile/SKILL.md`
- [X] T016 [US2] Update Profile Operations and response behavior in `.highway/skills/highway-profile/SKILL.md` so generic presentation and collaboration are delegated without duplicating Setup-owned behavior

**Checkpoint**: User Story 2 is independently testable and Profile contains no competing generic convergence contract.

---

## Phase 5: User Story 3 - Contextual acquisition and cross-domain reasoning (Priority: P1)

**Goal**: Preserve Profile acquisition and cross-domain reasoning while treating Highway Identity as context and provisional discoveries as unaccepted proposals.

**Independent Test**: Run Profile behavior and convergence fixtures for identity context, supplied material, optional public-source retrieval, mature direct input, and cross-domain evidence; verify only supported accepted organizational information is retained.

### Tests for User Story 3

- [X] T017 [US3] Extend `.highway/tools/tests/profile-behavior.test.sh` with cross-domain, acquisition, optional-retrieval, and proposal-versus-accepted-evidence assertions
- [X] T018 [US3] Update `.highway/tools/tests/profile-convergence-behavior.test.sh` fixtures and assertions to prove model-originated Working Ideas and Highway context do not become retained Profile evidence

### Implementation for User Story 3

- [X] T019 [US3] Clarify Highway Identity contextual use, evidence boundaries, and non-persistence rules in `.highway/skills/highway-profile/SKILL.md`
- [X] T020 [US3] Preserve and clarify acquisition order, canonical-question fallback behavior, and cross-domain evaluation across unresolved Profile domains in `.highway/skills/highway-profile/SKILL.md`
- [X] T021 [US3] Preserve Profile completion synthesis ownership and remove any transient collaboration concepts from retained-output or evidence wording in `.highway/skills/highway-profile/SKILL.md`

**Checkpoint**: User Story 3 is independently testable and no provisional or Highway-owned material is promoted to Profile fact.

---

## Phase 6: User Story 4 - Safe persistence and completion handoff (Priority: P2)

**Goal**: Make local persistence failures explicit and ensure Profile emits one completion synthesis without Setup duplication.

**Independent Test**: Run malformed-state, mutation-failure, optional-retrieval-failure, final-persistence, and Setup handoff checks; verify blocked progression and exactly-once synthesis.

### Tests for User Story 4

- [X] T022 [US4] Add persistence-failure and completion-handoff assertions to `.highway/tools/tests/profile-behavior.test.sh`
- [X] T023 [US4] Add a regression assertion to `.highway/tools/tests/highway-setup.test.sh` only if the existing Setup contract lacks the no-duplication boundary; otherwise document that Setup remains unchanged and covered by its existing test

### Implementation for User Story 4

- [X] T024 [US4] Define actionable local handling for malformed retained Profiles, failed accepted mutations, unexpected persistence failures, and unavailable optional retrieval in `.highway/skills/highway-profile/SKILL.md`
- [X] T025 [US4] Ensure successful final persistence emits one concise user-relevant completion synthesis with no readiness/status mechanics or new question in `.highway/skills/highway-profile/SKILL.md`
- [X] T026 [US4] Verify Setup consumes Profile's completion synthesis without duplication and make no Setup source change unless the focused regression test identifies a concrete gap in `.highway/skills/highway-setup/SKILL.md`

**Checkpoint**: User Story 4 is independently testable and persistence/handoff claims are safe.

---

## Phase 7: Generated Artifacts and Polish

**Purpose**: Regenerate shipped outputs, validate correspondence, and run the repository-wide gates.

- [X] T027 Run `.highway/tools/generate-agent-adapters.sh` from the repository root to regenerate all four active Profile adapters
- [X] T028 Run `.highway/tools/generate-catalog.sh` and update only the derived `.highway/catalog/index.json` and `.highway/catalog/index.md` entries required by the Profile version change
- [X] T029 Run `bash .highway/tools/tests/profile-runtime-separation.test.sh`, `bash .highway/tools/tests/profile-behavior.test.sh`, and `bash .highway/tools/tests/profile-convergence-behavior.test.sh`
- [X] T030 Run `bash .highway/tools/tests/adapter-coverage.test.sh` and the Profile skill validation checks to confirm source/generated correspondence and content gates
- [X] T031 Run `bash .highway/tools/tests/run-all.sh` and `git diff --check`; audit that protected Highway Identity, Experience Standard, Profile template, Setup, and unrelated owner files remain unchanged

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No implementation dependency; establishes the artifact scope.
- **Foundational (Phase 2)**: Depends on Setup and must complete before story implementation.
- **User Story 1 (Phase 3)**: Depends on the Foundational tests and establishes the Profile ownership base.
- **User Story 2 (Phase 4)**: Depends on User Story 1's source ownership boundary; removes competing collaboration behavior.
- **User Story 3 (Phase 5)**: Depends on User Story 2's Experience delegation boundary; preserves acquisition and cross-domain behavior.
- **User Story 4 (Phase 6)**: Depends on User Story 1 persistence semantics and User Story 3 completion/acquisition behavior.
- **Generated Artifacts and Polish (Phase 7)**: Depends on all source and focused-test changes.

### Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- T004, T005, and T006 can run in parallel because they modify separate focused test concerns.
- Within each story, independent test assertion tasks can be prepared in parallel before the source edit; source edits to `SKILL.md` remain sequential to avoid conflicting contract rewrites.
- T027 and T028 are sequential because catalog generation must see the final source version and generated inputs.
- T029 and T030 can run in parallel after generation; T031 is the final repository-wide gate.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 and validate the four-domain ownership/readiness contract.
3. Continue with User Story 2 because the runtime boundary is incomplete until generic convergence is delegated.
4. Treat User Stories 3 and 4 as required before release; they protect acquisition, persistence, and Setup handoff.

### Completion Criteria

- Every task above is checked off.
- Focused Profile tests, adapter coverage, skill validation, and the full suite pass.
- Profile source and all generated outputs report the intended version and content.
- No protected runtime artifact is changed without a feature-specific reason.
