---
description: "Task list for Profile conversational enrichment"
---

# Tasks: Profile Conversational Enrichment

**Input**: Design documents from `specs/119-profile-conversational-enrichment/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [quickstart.md](quickstart.md)

**Tests**: Required. Feature 119 explicitly requests Profile-specific verification. Test tasks precede the corresponding skill edits and must establish a focused failing assertion where the behavior is new.

**Organization**: Tasks are grouped by the four prioritized user stories. The implementation remains limited to the Profile skill, Profile-specific contracts, generated Profile dependents, and Feature 119 records. The shared Profile template is read-only.

## Phase 1: Setup

**Purpose**: Establish the baseline and inspect current Profile wording and contract coverage.

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and record the baseline result in `specs/119-profile-conversational-enrichment/quickstart.md`.
- [X] T002 [P] Run `.highway/tools/validate-skill.sh .highway/skills/highway-profile` and record the baseline result in `specs/119-profile-conversational-enrichment/quickstart.md`.
- [X] T003 [P] Inventory current transactional validation wording, Profile enrichment wording, and focused assertions in `.highway/skills/highway-profile/SKILL.md` and `.highway/tools/tests/profile-behavior.test.sh`.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared test helpers and protected-scope checks before story-specific changes.

**Checkpoint**: Baseline is recorded, the current Profile contract is inventoried, and the shared template boundary is explicit.

- [X] T004 [P] Add disposable Profile recommendation fixtures for Identity, Vision, Competitive Path, and Guiding Principles validation under `.highway/tools/tests/fixtures/profile-092/`.
- [X] T005 [P] Add a protected-template assertion and Profile-version assertion to `.highway/tools/tests/profile-structure.test.sh` without changing `.highway/library/templates/output/profile-record.md`.
- [X] T006 [P] Add a focused transient-commentary and single-question validation fixture under `.highway/tools/tests/fixtures/profile-092/`.

## Phase 3: User Story 1 - Validate Organizational Understanding (Priority: P1) MVP

**Goal**: Replace transactional Profile confirmation language with accuracy-oriented domain validation and explicit correction/replacement paths.

**Independent Test**: Run the Profile behavior contract and verify all four domain prompts, alternatives, affirmative acceptance, clarification non-acceptance, and no second confirmation.

### Tests for User Story 1

- [X] T007 [P] [US1] Add exact Identity, Vision, Competitive Path, and Guiding Principles validation prompt assertions to `.highway/tools/tests/profile-behavior.test.sh`.
- [X] T008 [P] [US1] Add assertions for accepted Organization Name interpolation, explicit correction/replacement paths, clarification non-acceptance, and no second confirmation to `.highway/tools/tests/profile-behavior.test.sh`.

### Implementation for User Story 1

- [X] T009 [US1] Replace transactional Profile validation wording with the four accuracy-oriented prompts and quiet alternatives in `.highway/skills/highway-profile/SKILL.md` while preserving the existing Experience Standard acceptance boundary.
- [X] T010 [US1] Run `bash .highway/tools/tests/profile-behavior.test.sh` and `.highway/tools/validate-skill.sh .highway/skills/highway-profile`, then record User Story 1 evidence in `specs/119-profile-conversational-enrichment/quickstart.md`.

**Checkpoint**: Profile validates understanding rather than asking for transactional approval, and each recommendation retains a correction/replacement path.

## Phase 4: User Story 2 - Receive Useful Conversational Enrichment (Priority: P1)

**Goal**: Compose synthesized recommendations around optional acknowledgment, optional grounded advisory contribution, cohesive recommendation, and one validation question without exposing the conceptual labels.

**Independent Test**: Run the Profile behavior and UX contracts against grounded and insufficient-grounding cases; verify commentary is optional, grounded, transient, and followed by exactly one validation question.

### Tests for User Story 2

- [X] T011 [P] [US2] Add assertions for the acknowledge/build/recommend/validate composition model, hidden conceptual labels, and concise-depth boundary to `.highway/tools/tests/profile-behavior.test.sh`.
- [X] T012 [P] [US2] Add assertions for optional grounded implication/opportunity/tradeoff/concern, omission when no useful contribution exists, no manufactured agreement, and respectful user ownership to `.highway/tools/tests/highway-ux-alignment.test.sh`.
- [X] T013 [P] [US2] Add grounded and insufficient-grounding recommendation fixtures under `.highway/tools/tests/fixtures/profile-092/`.

### Implementation for User Story 2

- [X] T014 [US2] Add the Profile-specific conversational composition contract to the Enrichment section of `.highway/skills/highway-profile/SKILL.md`, keeping Acknowledge and Build optional and transient.
- [X] T015 [US2] Update the Vision, Competitive Path, and Guiding Principles recommendation guidance in `.highway/skills/highway-profile/SKILL.md` to require accepted-evidence grounding, optional advisory contribution, and one validation question without adding generic Experience Standard rules.
- [X] T016 [US2] Run the focused Profile behavior, UX alignment, and Feature 092 contract checks and record User Story 2 evidence in `specs/119-profile-conversational-enrichment/quickstart.md`.

**Checkpoint**: A synthesized turn can be more useful without becoming verbose by default, exposing internal stages, or manufacturing commentary.

## Phase 5: User Story 3 - Preserve Accepted Evidence and Domain Ownership (Priority: P1)

**Goal**: Ensure only accepted cohesive narrative becomes retained evidence, accepted recommendations establish `discussed`, and persistence remains before dependent results.

**Independent Test**: Exercise affirmative acceptance, correction, replacement, explanation request, declined commentary, and persistence failure; verify retained content and readiness boundaries.

### Tests for User Story 3

- [X] T017 [P] [US3] Add lifecycle assertions that acknowledgment/advisory commentary is not persisted unless explicitly incorporated into an accepted alternative in `.highway/tools/tests/profile-lifecycle.test.sh`.
- [X] T018 [P] [US3] Add lifecycle assertions for accepted recommendation -> `discussed`, no repeated canonical question, optional enrichment readiness stability, and save-before-owner-result ordering in `.highway/tools/tests/profile-lifecycle.test.sh`.
- [X] T019 [P] [US3] Add structure assertions that internal enrichment categories remain hidden and transient in `.highway/tools/tests/profile-structure.test.sh`.

### Implementation for User Story 3

- [X] T020 [US3] Refine the Operations and Verification sections of `.highway/skills/highway-profile/SKILL.md` to state that only accepted cohesive domain narrative is retained and unadopted commentary remains transient.
- [X] T021 [US3] Refine Profile domain-state wording in `.highway/skills/highway-profile/SKILL.md` so accepted validation establishes `discussed`, prevents the fallback canonical question, and optional enrichment does not affect readiness.
- [X] T022 [US3] Run Profile lifecycle, structure, behavior, and migration contracts and record User Story 3 evidence in `specs/119-profile-conversational-enrichment/quickstart.md`.

**Checkpoint**: Conversational enrichment cannot silently mutate retained Profile evidence or readiness.

## Phase 6: User Story 4 - Preserve Existing Profile Boundaries (Priority: P2)

**Goal**: Preserve recommendation-first acquisition, four-domain readiness, brownfield scope, completion synthesis, Experience Standard delegation, version 5.1.0, and the shared template.

**Independent Test**: Run Profile validation, correspondence, template, migration, UX, and full-suite checks; inspect the diff for protected boundaries.

### Tests for User Story 4

- [X] T023 [P] [US4] Add assertions for unchanged recommendation-first order, brownfield exclusion, completion synthesis, machine-result ownership, and exact Experience sentence to `.highway/tools/tests/feature-092-contract.test.sh`.
- [X] T024 [P] [US4] Add assertions for version `5.1.0`, schema `3.0.0`, four readiness domains, and unchanged `profile-record.md` to `.highway/tools/tests/profile-structure.test.sh`.

### Implementation for User Story 4

- [X] T025 [US4] Review `.highway/skills/highway-profile/SKILL.md` for accidental duplication of generic Experience Standard rules and preserve `User-visible interaction follows the Highway Experience Standard.` exactly.
- [X] T026 [US4] Review `.highway/library/templates/output/profile-record.md` and record a no-change result in `specs/119-profile-conversational-enrichment/quickstart.md`; do not edit the template.
- [X] T027 [US4] Regenerate declared Profile adapters and catalog outputs with `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-library-catalog.sh`, then run `.highway/tools/tests/feature-092-correspondence.test.sh`.
- [X] T028 [US4] Run `.highway/tools/validate-skill.sh .highway/skills/highway-profile` and all Profile-focused contracts, recording the User Story 4 result in `specs/119-profile-conversational-enrichment/quickstart.md`.

**Checkpoint**: Profile presentation is refined without changing retained schema, shared ownership, generated correspondence, or existing lifecycle boundaries.

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Validate the complete Feature 119 implementation and requirement coverage.

- [X] T029 [P] Run `git diff --check` and record the result in `specs/119-profile-conversational-enrichment/quickstart.md`.
- [X] T030 [P] Run `bash .highway/tools/tests/run-all.sh` and record the final result in `specs/119-profile-conversational-enrichment/quickstart.md`.
- [X] T031 Review the final diff for changes outside Feature 119 records, Profile-specific source/tests, generated Profile dependents, and the active pointer; record the scope result in `specs/119-profile-conversational-enrichment/quickstart.md`.
- [X] T032 Confirm FR-001 through FR-032 and SC-001 through SC-010 have implementation or verification evidence in `specs/119-profile-conversational-enrichment/quickstart.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup**: T001-T003 establish baseline and current contract inventory.
- **Foundational**: T004-T006 establish fixtures and protected-scope checks; depends on Setup.
- **US1**: T007-T010; depends on Foundational and is the MVP.
- **US2**: T011-T016; depends on US1 because composition surrounds the validation prompts.
- **US3**: T017-T022; depends on US2 because persistence applies to the composed turn.
- **US4**: T023-T028; depends on US3 and owns final compatibility/correspondence validation.
- **Polish**: T029-T032; depends on all story checkpoints.

### Parallel Opportunities

- T002-T003 can run in parallel after T001.
- T004-T006 can run in parallel because they use separate fixture or test surfaces.
- T007-T008 can run in parallel before the sequential skill edit.
- T011-T013 can run in parallel before T014-T015.
- T017-T019 can run in parallel before T020-T021.
- T023-T024 can run in parallel before T025.
- T029-T030 can run in parallel after correspondence validation.

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 with exact accuracy-oriented prompts and alternatives.
3. Verify the MVP independently before adding optional conversational enrichment.

### Incremental Delivery

1. Establish the baseline and focused fixture surface.
2. Replace transactional validation wording.
3. Add optional acknowledge/build/recommend/validate composition.
4. Lock transient versus accepted persistence and domain-state transitions.
5. Recheck existing readiness, brownfield, completion, Experience Standard, schema, and generated correspondence boundaries.
6. Run the full suite and map final evidence to all Feature 119 requirements and success criteria.
