---

description: "Task list for Profile Collaboration Convergence"
---

# Tasks: Profile Collaboration Convergence

**Input**: Design documents from `specs/144-profile-collaboration-convergence/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/profile-behavioral-evaluation.md, quickstart.md

**Tests**: Behavioral fixture validation is explicitly required by the feature specification. Existing Profile regression contracts must remain green.

**Organization**: Tasks are grouped by user story. Story phases are ordered by dependency and each checkpoint is independently testable.

## Phase 1: Setup

**Purpose**: Establish the development-only fixture surface and capture the passing baseline.

- [x] T001 Record the pre-change full-suite result and current `highway-profile` version in `specs/144-profile-collaboration-convergence/quickstart.md` validation notes.
- [x] T002 [P] Create the development-only fixture directory and placeholder index at `.highway/tools/tests/fixtures/profile-convergence/README.md` without adding any shipped-skill dependency.
- [x] T003 [P] Add the focused test entrypoint skeleton at `.highway/tools/tests/profile-convergence-behavior.test.sh` following the repository's Bash 3.2 and artifact-class conventions.

---

## Phase 2: Foundational

**Purpose**: Define the shared fixture and evaluation contract before story-specific implementation.

- [x] T004 Convert `specs/144-profile-collaboration-convergence/contracts/profile-behavioral-evaluation.md` into the authoritative fixture field and rubric-dimension reference used by the development validator.
- [x] T005 [P] Add shared fixture parsing and required-field validation helpers in `.highway/tools/tests/profile-convergence-behavior.test.sh` for fixture identifiers, contexts, stimuli, outcomes, dimensions, governance references, and hard failures.
- [x] T006 [P] Add runtime-boundary checks in `.highway/tools/tests/profile-convergence-behavior.test.sh` proving fixture paths are outside shipped Profile Inputs and that no retained schema or readiness field is introduced.
- [x] T007 Run the new focused validator against intentionally incomplete fixture probes and record the observed non-zero failures before marking the foundational checkpoint complete.

**Checkpoint**: The fixture contract is executable, rejects incomplete records, and remains development-only.

---

## Phase 3: User Story 1 - Develop Meaningful Profile Understanding (Priority: P1) 🎯 MVP

**Goal**: Add the Profile semantic convergence decision and preserve the distinction between domain completeness and conversational convergence.

**Independent Test**: Existing Profile contract tests plus a focused source-contract check verify the ordered decision, semantic trigger boundary, mature short path, and no new persisted fields.

### Tests for User Story 1

- [x] T008 [P] [US1] Add failing-first assertions for the ordered semantic convergence decision and mature direct-contribution path in `.highway/tools/tests/profile-convergence-behavior.test.sh`.
- [x] T009 [P] [US1] Add failing-first assertions that new nouns or activities do not automatically trigger another turn and unsupported relationships do not become accepted facts in `.highway/tools/tests/profile-convergence-behavior.test.sh`.

### Implementation for User Story 1

- [x] T010 [US1] Add the ordered Profile semantic convergence decision near Domain completeness in `.highway/skills/highway-profile/SKILL.md`, referencing the Experience Standard for generic clarification, Working Idea, Contribution Opportunity, and convergence ownership.
- [x] T011 [US1] Add Profile-specific reasoning affordances and semantic examples for mature input, newly related evidence, changed roles, cross-domain implications, and model-originated interpretations in `.highway/skills/highway-profile/SKILL.md` without adding workflow stages or persisted fields.
- [x] T012 [US1] Extend the Profile `### Verification` section in `.highway/skills/highway-profile/SKILL.md` with convergence-independence, useful-re-evaluation, mature-short-path, unchanged-schema/readiness, and transient-Working-Idea checks.
- [x] T013 [US1] Increment `metadata.version` in `.highway/skills/highway-profile/SKILL.md` from `8.0.0` to `8.1.0` according to the Skill Versioning Policy.

**Checkpoint**: Profile source expresses the semantic decision, preserves Experience Standard ownership, and passes the focused Profile contract without runtime schema changes.

---

## Phase 4: User Story 2 - Preserve User Authority During Development (Priority: P1)

**Goal**: Cover provisional Working Ideas, meaningful Contribution Opportunities, corrections, and cross-domain evidence reuse.

**Independent Test**: Transcript fixtures and focused assertions demonstrate that model-shaped material remains provisional, user changes are reflected, and cross-domain evidence is reused without forced misclassification or repetition.

### Tests for User Story 2

- [x] T014 [P] [US2] Add transcript fixtures for changed activity relationships, materially model-shaped Working Ideas, and useful cross-domain connections under `.highway/tools/tests/fixtures/profile-convergence/`.
- [x] T015 [P] [US2] Add fixture assertions for provisional authority, meaningful Contribution Opportunity, correction propagation, and cross-domain reuse in `.highway/tools/tests/profile-convergence-behavior.test.sh`.

### Implementation for User Story 2

- [x] T016 [US2] Add the Profile semantic-decision transcript records for Fixtures B, D, and F with varied synthetic organizations and complete fixture metadata under `.highway/tools/tests/fixtures/profile-convergence/`.
- [x] T017 [US2] Add hard-failure checks preventing unsupported model-originated material from being treated as accepted Profile evidence in `.highway/tools/tests/profile-convergence-behavior.test.sh`.
- [x] T018 [US2] Add cross-domain and retained-schema boundary checks to `.highway/tools/tests/profile-convergence-behavior.test.sh`, preserving the existing `.highway/library/templates/output/profile-record.md` contract.

**Checkpoint**: Authority and cross-domain behavior are represented by varied transcript fixtures and fail on silent acceptance or forced repetition.

---

## Phase 5: User Story 3 - Resolve Ambiguity Without Ritualized Questions (Priority: P1)

**Goal**: Validate direct handling of clear input, focused clarification for consequential ambiguity, and non-manufactured collaboration.

**Independent Test**: Fixture E passes for clear input without ceremonial clarification and for materially different interpretations with one focused user-owned clarification; Fixture G avoids unsupported connections.

### Tests for User Story 3

- [x] T019 [P] [US3] Add clear-input and consequential-ambiguity transcript fixtures, plus unsupported-connection coverage, under `.highway/tools/tests/fixtures/profile-convergence/`.
- [x] T020 [P] [US3] Add assertions for one focused clarification, no repeated accepted evidence, and no speculative relationship generation in `.highway/tools/tests/profile-convergence-behavior.test.sh`.

### Implementation for User Story 3

- [x] T021 [US3] Add semantic fixture records for Fixture E variants and Fixture G with explicit pass/fail behavior, applicable rubric dimensions, and governance references under `.highway/tools/tests/fixtures/profile-convergence/`.
- [x] T022 [US3] Add hard-failure evaluation for silent consequential ambiguity resolution, multiple unresolved questions, ceremonial clarification, and unsupported relationship invention in `.highway/tools/tests/profile-convergence-behavior.test.sh`.

**Checkpoint**: Clarification discipline and non-manufactured collaboration are validated without adding turn-count or mandatory-question rules.

---

## Phase 6: User Story 4 - Evaluate Collaborative Behavior Across Varied Transcripts (Priority: P2)

**Goal**: Run all eight synthetic behavioral fixture categories through the development validation workflow using the reusable semantic rubric.

**Independent Test**: The focused behavioral test discovers all eight categories, validates their required fields, applies every marked rubric dimension, and exits non-zero for seeded hard failures.

### Tests for User Story 4

- [x] T023 [P] [US4] Add Fixtures A, C, and H for new Identity evidence, mature direct contribution, and hidden internal mechanics under `.highway/tools/tests/fixtures/profile-convergence/`.
- [x] T024 [P] [US4] Add seeded negative probes for missing fixture metadata, premature acceptance, missing Contribution Opportunity, and internal-mechanics leakage in `.highway/tools/tests/profile-convergence-behavior.test.sh`.

### Implementation for User Story 4

- [x] T025 [US4] Add the remaining fixture records with varied industries, structures, activities, audiences, strategies, and Profile domains under `.highway/tools/tests/fixtures/profile-convergence/`.
- [x] T026 [US4] Implement rubric-dimension dispatch and hard-failure aggregation in `.highway/tools/tests/profile-convergence-behavior.test.sh`, ensuring every applicable dimension must pass and no violation is averaged away.
- [x] T027 [US4] Register the focused validator through the existing `*.test.sh` discovery convention and document its expected output in `specs/144-profile-collaboration-convergence/quickstart.md`.

**Checkpoint**: All eight fixture categories run automatically through development validation, while Profile save behavior remains unchanged.

---

## Phase 7: User Story 5 - Preserve Existing Profile Contracts (Priority: P1)

**Goal**: Keep persistence, readiness, acceptance, schema, generated adapters, runtime boundaries, and existing validation behavior unchanged except for the intended capability version increment.

**Independent Test**: Existing Profile, adapter, migration, readiness, runtime-separation, and full-suite checks pass after implementation and generation.

### Tests for User Story 5

- [x] T028 [P] [US5] Add regression assertions for unchanged retained schema, readiness dimensions, mutation ordering, and hidden orchestration mechanics in `.highway/tools/tests/profile-convergence-behavior.test.sh`.

### Implementation for User Story 5

- [x] T029 [US5] Update affected historical Profile contract assertions under `.highway/tools/tests/` only where they conflict with the new semantic convergence behavior, preserving every unrelated assertion.
- [x] T030 [US5] Regenerate `.agents/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, `.github/skills/highway-profile/SKILL.md`, catalog entries, and adapter manifests from the updated source.
- [x] T031 [US5] Run focused Profile contracts and verify generated adapters are byte-identical to `.highway/skills/highway-profile/SKILL.md`.

**Checkpoint**: Existing Profile contracts remain green and all generated artifacts correspond to the source skill.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Complete validation, documentation, and repository integrity checks.

- [x] T032 [P] Update `specs/144-profile-collaboration-convergence/quickstart.md` with final commands, expected results, and the resulting `highway-profile` version.
- [x] T033 Run `.highway/tools/tests/run-all.sh` and record the zero-failure result for the feature completion report.
- [x] T034 Run `git diff --check`, schema/version checks, historical-branch scans, protected-file checks, and generated-artifact correspondence checks.

---

## Dependencies & Execution Order

### Dependency Graph

```text
T001 -> T002, T003 -> T004-T007
T007 -> T008-T013
T010-T013 -> T014-T018
T014-T018 -> T019-T022
T019-T022 -> T023-T027
T023-T027 -> T028-T031
T031 -> T032-T034
```

### Story Completion Order

1. **US1** semantic convergence decision (MVP)
2. **US2** authority and cross-domain development
3. **US3** clarification discipline and non-manufactured collaboration
4. **US4** all-eight fixture execution and rubric aggregation
5. **US5** regression preservation and generated artifacts

### Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- T005 and T006 can run in parallel after T004.
- T008 and T009 can run in parallel before T010.
- T014 and T015 can run in parallel after the fixture validator contract exists.
- T019 and T020 can run in parallel after US2 fixture conventions are established.
- T023 and T024 can run in parallel after the validator exists.
- T028 can run in parallel with final fixture additions before T030.

## Implementation Strategy

Deliver the MVP as US1: add the semantic convergence decision, verification coverage, and version
increment while keeping all existing Profile contracts intact. Then add authority/cross-domain
fixtures, ambiguity/non-manufactured-collaboration fixtures, and finally the full eight-fixture
runner and rubric. Finish by regenerating adapters, running focused contracts, running the full suite,
and checking schema, protected files, and historical-branch hygiene.
