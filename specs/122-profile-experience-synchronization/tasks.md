---
description: "Task list for Profile Experience Synchronization"
---

# Tasks: Profile Experience Synchronization

**Input**: Design documents from `specs/122-profile-experience-synchronization/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Included because the specification explicitly requires focused contract verification and preservation of existing Profile behavior.

## Phase 1: Setup

- [X] T001 Record the current `highway-profile` version, Profile schema version, four readiness domains, shared Experience sentence, and protected paths in `specs/122-profile-experience-synchronization/quickstart.md`.
- [X] T002 [P] Review the current Enrichment, domain grounding, Operations, Verification, and Experience sections in `.highway/skills/highway-profile/SKILL.md` against `specs/122-profile-experience-synchronization/research.md`.
- [X] T003 [P] Confirm the active Profile contracts and preserved artifacts in `.highway/tools/tests/`, `.highway/library/templates/output/profile-record.md`, and `.highway/library/knowledge/profile.md` before editing.

## Phase 2: Foundational

- [X] T004 Add Feature 122 protected-scope assertions for the Profile template, retained Profile, Highway Identity, Experience Standard, other skills, and unrelated governance artifacts in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.
- [X] T005 [P] Add failing assertions for the removed optional-acknowledgment wording, decision-only advisory restriction, stale contextualization wording, local brevity quotas, and duplicated generic interaction rules in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.
- [X] T006 [P] Add failing preservation assertions for the four domains, schema 3.0.0, accuracy-oriented validation prompts, canonical fallback, website scope, persistence ordering, completion synthesis, and shared Experience sentence in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.
- [X] T007 Run the new Feature 122 contract before source changes and record the expected test-first failures in `specs/122-profile-experience-synchronization/quickstart.md`.

## Phase 3: User Story 1 - Continue Naturally After Accepted Evidence (Priority: P1) 🎯 MVP

**Goal**: Remove local Profile wording that suppresses shared X2.8 acknowledgment, Conversational Presence, and useful grounded advisory behavior.

**Independent Test**: The Feature 122 contract finds one rationalized Enrichment model, X2.8 applicability without copied rule text, natural conversational depth without quotas, and optional advisory contribution without decision-only wording.

### Tests for User Story 1

- [X] T008 [P] [US1] Add assertions for X2.8 applicability, natural conversational response, optional useful perspective, and no local question requirement in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.
- [X] T009 [P] [US1] Add assertions rejecting duplicated Acknowledge/Build/Recommend/Validate composition and local sentence, paragraph, or minimum-response quotas in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.

### Implementation for User Story 1

- [X] T010 [US1] Collapse the duplicated `## Enrichment` composition guidance into one Profile-specific model in `.highway/skills/highway-profile/SKILL.md`.
- [X] T011 [US1] Replace optional acknowledgment wording with X2.8 applicability without duplicating the full X2.8 rule in `.highway/skills/highway-profile/SKILL.md`.
- [X] T012 [US1] Remove local brevity, sentence-count, paragraph-count, and minimal-response constraints while preserving the shared Experience Standard delegation in `.highway/skills/highway-profile/SKILL.md`.
- [X] T013 [US1] Broaden Profile-specific advisory contribution to grounded implications, opportunities, connections, tradeoffs, tensions, concerns, and sharpening observations without requiring contribution on every turn in `.highway/skills/highway-profile/SKILL.md`.

**Checkpoint**: User Story 1 focused assertions pass and Profile allows shared conversational presence without becoming a second Experience Standard.

## Phase 4: User Story 2 - Ground Each Domain From Accepted Profile Evidence (Priority: P1)

**Goal**: Make Profile responsible for accepted-evidence grounding and domain-specific validation while removing generic conversational prescriptions.

**Independent Test**: Vision, Competitive Path, and Guiding Principles each name accepted grounding and cohesive recommendation behavior; Identity and all validation/fallback wording remain compatible.

### Tests for User Story 2

- [X] T014 [P] [US2] Add assertions for Vision, Competitive Path, and Guiding Principles grounding sources and cohesive recommendation wording in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.
- [X] T015 [P] [US2] Add assertions preserving Identity, Vision, Competitive Path, and Guiding Principles accuracy-oriented validation and correction/replacement wording in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.
- [X] T016 [P] [US2] Add assertions rejecting fixed recommendation lead-ins and preserving canonical fallback prompts in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.

### Implementation for User Story 2

- [X] T017 [US2] Update Vision grounding and recommendation guidance to use accepted Identity, accepted website-derived organizational evidence, accepted Vision evidence, and accepted Profile context in `.highway/skills/highway-profile/SKILL.md`.
- [X] T018 [US2] Update Competitive Path grounding and recommendation guidance to use accepted Vision and accumulated accepted Profile evidence in `.highway/skills/highway-profile/SKILL.md`.
- [X] T019 [US2] Update Guiding Principles grounding and recommendation guidance to use accepted Competitive Path and accumulated accepted Profile evidence in `.highway/skills/highway-profile/SKILL.md`.
- [X] T020 [US2] Preserve all four accuracy-oriented validation prompts and correction/replacement paths while removing local acknowledgment, bridge, and recommendation lead-in prescriptions in `.highway/skills/highway-profile/SKILL.md`.

**Checkpoint**: User Story 2 domain-grounding and validation assertions pass without exposing internal category names or changing canonical fallback behavior.

## Phase 5: User Story 3 - Preserve Accepted Versus Transient Context (Priority: P1)

**Goal**: Keep conversational context transient unless explicitly adopted while preserving acquisition, persistence, readiness, and completion contracts.

**Independent Test**: Existing Profile lifecycle and structure contracts pass, and the Feature 122 contract confirms no new acknowledgment, conversation, or advisory state is persisted.

### Tests for User Story 3

- [X] T021 [P] [US3] Add assertions for transient acknowledgments, reflections, advisory observations, implications, tradeoffs, concerns, alternatives, explanations, and internal categories in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.
- [X] T022 [P] [US3] Add assertions for recommendation-first acquisition, persistence-before-dependent-result behavior, readiness preservation, completion synthesis, and canonical fallback in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.
- [X] T023 [P] [US3] Add assertions for first-time introduction behavior, website-derived proposed evidence, accepted Organization URL context, and brownfield technology-discovery exclusion in `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.

### Implementation for User Story 3

- [X] T024 [US3] Update Profile Operations guidance to preserve accepted-only retention and persistence-before-result ordering while allowing transient conversational context in `.highway/skills/highway-profile/SKILL.md`.
- [X] T025 [US3] Update Profile Verification guidance to replace stale acknowledgment and decision-value checks with Profile-specific X2.8, grounding, transient-retention, and shared-presence checks in `.highway/skills/highway-profile/SKILL.md`.
- [X] T026 [US3] Update completion synthesis wording to connect accepted Profile understanding to later Highway guidance without prescribing third-person or literal wording in `.highway/skills/highway-profile/SKILL.md`.
- [X] T027 [US3] Preserve the exact shared Experience sentence and remove all duplicated generic interaction rules from `.highway/skills/highway-profile/SKILL.md`.

**Checkpoint**: User Story 3 preserved Profile lifecycle, schema, readiness, website, completion, and transient-context contracts pass.

## Phase 6: User Story 4 - Keep Profile Scope and Compatibility Stable (Priority: P2)

**Goal**: Confirm the final implementation is Profile-only, schema-neutral, and compatible with shared governance and generated distribution boundaries.

**Independent Test**: The scope contract and existing repository contracts identify no protected-path changes and all preserved Profile behavior remains green.

### Tests for User Story 4

- [X] T028 [P] [US4] Add final version, schema, protected-scope, and shared-governance assertions to `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`.
- [X] T029 [P] [US4] Add correspondence coverage for the Feature 122 contract in `.highway/tools/tests/feature-092-correspondence.test.sh` only if the repository's contract inventory requires it.

### Implementation for User Story 4

- [X] T030 [US4] Preserve `highway-profile` version 5.1.0 and document the no-version-bump decision in `specs/122-profile-experience-synchronization/quickstart.md`.
- [X] T031 [US4] Review the final Profile skill against Highway Identity, Experience Standard 7.1.0, the Profile template, and the data model for duplicate or conflicting ownership in `.highway/skills/highway-profile/SKILL.md` and `specs/122-profile-experience-synchronization/data-model.md`.

**Checkpoint**: User Story 4 scope and compatibility checks pass with no protected artifact or unrelated skill changes.

## Phase 7: Polish & Cross-Cutting Validation

- [X] T032 Run the Feature 122 focused contract and all preserved Profile contracts from `specs/122-profile-experience-synchronization/quickstart.md`.
- [X] T033 Run `.highway/tools/tests/run-all.sh` and record the result in `specs/122-profile-experience-synchronization/quickstart.md`.
- [X] T034 Run `git diff --check` and review the final changed-path list against the protected scope in `specs/122-profile-experience-synchronization/quickstart.md`.
- [X] T035 Confirm FR-001 through FR-033 and SC-001 through SC-010 have implementation or verification evidence in `specs/122-profile-experience-synchronization/quickstart.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup and blocks story work.
- **User Stories (Phases 3-6)**: Depend on Foundational; US1, US2, and US3 share `.highway/skills/highway-profile/SKILL.md` and should be implemented sequentially. US4 follows the content changes.
- **Polish (Phase 7)**: Depends on all user stories.

### User Story Dependencies

- **US1 (P1)**: Establishes the single Enrichment model and shared conversational boundary.
- **US2 (P1)**: Depends on US1 terminology and updates domain grounding and validation.
- **US3 (P1)**: Depends on US1 and US2, then preserves operations, verification, and lifecycle boundaries.
- **US4 (P2)**: Depends on US1-US3 and performs final scope/version review.

### Parallel Opportunities

- T002 and T003 can run in parallel.
- T005 and T006 can run in parallel before source edits.
- T008 and T009 can run in parallel within US1.
- T014, T015, and T016 can run in parallel within US2.
- T021, T022, and T023 can run in parallel within US3.
- T028 and T029 can run in parallel within US4.
- Source edits to `.highway/skills/highway-profile/SKILL.md` remain sequential because they share one file.

## Parallel Example: User Story 1

```text
Task: Add X2.8 applicability and natural-response assertions in .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh
Task: Add anti-duplication and no-local-quota assertions in .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh
```

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete US1 to rationalize Enrichment and remove local conversational suppression.
3. Run the Feature 122 contract and preserved Profile checks.
4. Continue through US2-US4 because grounding, persistence, and protected scope are part of the shippable Profile contract.

### Incremental Delivery

1. Rationalize Enrichment and shared conversational delegation.
2. Update domain grounding and validation wording.
3. Preserve transient-versus-retained, lifecycle, readiness, website, and completion behavior.
4. Validate version, scope, correspondence, focused contracts, and full suite.
