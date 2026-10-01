---
description: "Task list for Profile advisory enrichment"
---

# Tasks: Profile Advisory Enrichment

**Input**: Design documents from `specs/118-profile-advisory-enrichment/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [quickstart.md](quickstart.md)

**Tests**: Required. The specification calls for Profile-specific verification and the development Constitution requires behavioral changes to add or amend focused tests. Test assertions must be observed failing for the changed contract before the corresponding skill edit is marked complete.

**Organization**: Tasks are grouped by user story. Shared Profile state and test inventory are established before story-specific edits. The shared `profile-record.md` template is read-only for this feature.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel because it uses different files and has no dependency on incomplete tasks.
- **[Story]**: Required for user-story tasks and maps to the feature specification.
- Every task names an exact repository-relative file path.

## Phase 1: Setup

**Purpose**: Establish a passing baseline and identify the current Profile contract surface.

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` from the repository root and record the baseline result in `specs/118-profile-advisory-enrichment/quickstart.md` before implementation.
- [X] T002 [P] Run `.highway/tools/validate-skill.sh .highway/skills/highway-profile` and record the baseline result in `specs/118-profile-advisory-enrichment/quickstart.md`.
- [X] T003 [P] Inventory current Profile assertions and generated dependents in `specs/118-profile-advisory-enrichment/quickstart.md`, covering `.highway/tools/tests/feature-092-contract.test.sh`, `profile-behavior.test.sh`, `profile-lifecycle.test.sh`, `profile-structure.test.sh`, `highway-ux-alignment.test.sh`, `output-template.test.sh`, and declared agent adapters.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish test fixtures and governance traceability before changing Profile behavior.

**Checkpoint**: Baseline is recorded, the Profile source/test surface is inventoried, and no shared template edit is planned.

- [X] T004 [P] Add or extend Profile interaction fixtures for first-time setup, resumed setup, accepted evidence, proposed website evidence, grounded recommendations, and completion closure under `.highway/tools/tests/fixtures/profile-092/`.
- [X] T005 [P] Add a Feature 118 rule inventory mapping applicable Constitution IDs and Experience Standard IDs to assertions in `.highway/tools/tests/fixtures/profile-092/`.
- [X] T006 Update `.highway/tools/tests/README.md` only if required to register the focused Feature 118 test naming or fixture convention, preserving existing dispatch behavior.

## Phase 3: User Story 1 - Understand Profile Setup Before Providing Context (Priority: P1) 🎯 MVP

**Goal**: Preserve the one-time Profile introduction and exact Repository Name opening without duplicating Setup's welcome or repeating during configure/resume.

**Independent Test**: Run the Profile contract fixture and `feature-092-contract.test.sh` against first-time, configure, and resumed interaction cases; verify introduction ordering and single emission.

### Tests for User Story 1

- [X] T007 [P] [US1] Add assertions for the one-time introduction, exact heading, explanatory sentence, Repository Name question, and company-or-organization hint in `.highway/tools/tests/profile-behavior.test.sh`.
- [X] T008 [P] [US1] Add first-time, configure, resumed, and Setup-welcome separation cases to `.highway/tools/tests/fixtures/profile-092/interaction/profile-introduction/`.

### Implementation for User Story 1

- [X] T009 [US1] Update the first-time setup and Repository Name acquisition wording in `.highway/skills/highway-profile/SKILL.md` so the introduction is emitted once before the exact Repository Name question and is not repeated on configure or resume.
- [X] T010 [US1] Run `bash .highway/tools/tests/profile-behavior.test.sh` and `bash .highway/tools/tests/feature-092-contract.test.sh`, then record the User Story 1 result in `specs/118-profile-advisory-enrichment/quickstart.md`.

**Checkpoint**: Profile opens consistently and independently testably, with no schema or template change.

## Phase 4: User Story 2 - Build Organizational Understanding From Accepted Evidence (Priority: P1)

**Goal**: Preserve website-assisted acquisition, proposed-versus-accepted evidence, cross-domain re-evaluation, and recommendation-before-question behavior.

**Independent Test**: Run website-present, website-unavailable, accepted-URL, unaccepted-discovery, correction, and cross-domain evidence fixtures and verify the next interaction is grounded before a canonical question.

### Tests for User Story 2

- [X] T011 [P] [US2] Add assertions for accepted Organization URL, proposed website-derived facts, unavailable retrieval continuation, accepted-evidence reuse, and all-four-domain re-evaluation in `.highway/tools/tests/profile-behavior.test.sh`.
- [X] T012 [P] [US2] Add present, unavailable, proposed, accepted, corrected, and validated discovery cases under `.highway/tools/tests/fixtures/profile-092/repository-context/`.

### Implementation for User Story 2

- [X] T013 [US2] Refine Acquisition and Profile model wording in `.highway/skills/highway-profile/SKILL.md` so accepted evidence is persisted and re-evaluated across all four domains before each unresolved canonical question, while website-derived facts remain proposed until acceptance.
- [X] T014 [US2] Add or amend `.highway/tools/tests/feature-092-contract.test.sh` assertions for the recommendation pivot, canonical-question fallback, and technology/brownfield discovery exclusion.
- [X] T015 [US2] Run the focused Profile behavior, contract, and structure tests and record the User Story 2 result in `specs/118-profile-advisory-enrichment/quickstart.md`.

**Checkpoint**: Accepted evidence compounds through acquisition, and unsupported technology discovery remains outside Profile.

## Phase 5: User Story 3 - Receive Cohesive, Grounded Profile Recommendations (Priority: P1)

**Goal**: Offer one cohesive, grounded paragraph for Vision, Competitive Path, and Guiding Principles when evidence supports it, without exposing or persisting internal categories.

**Independent Test**: Seed accepted evidence for each domain, inspect the recommendation form, accept it, and verify the domain becomes `discussed`; verify insufficient grounding falls back to the canonical question.

### Tests for User Story 3

- [X] T016 [P] [US3] Add assertions for the three Profile-specific paragraph forms, accepted-evidence-only claims, user-authored alternative availability, hidden enrichment categories, and canonical-question fallback in `.highway/tools/tests/profile-behavior.test.sh`.
- [X] T017 [P] [US3] Add Vision, Competitive Path, Guiding Principles, insufficient-grounding, and unsupported-detail fixtures under `.highway/tools/tests/fixtures/profile-092/enrichment/`.

### Implementation for User Story 3

- [X] T018 [US3] Refine the Enrichment section in `.highway/skills/highway-profile/SKILL.md` to present one cohesive paragraph per supported domain, retain the internal category lists as hidden reasoning guidance, and preserve optional non-blocking readiness.
- [X] T019 [US3] Remove or rewrite any Profile-specific wording in `.highway/tools/tests/highway-ux-alignment.test.sh` that duplicates generic recommendation acceptance, choice-count, or Decision Context rules while retaining Profile-specific assertions.
- [X] T020 [US3] Run the enrichment fixtures and focused contract tests and record the User Story 3 result in `specs/118-profile-advisory-enrichment/quickstart.md`.

**Checkpoint**: Grounded recommendations are cohesive and reviewable, while the retained record remains unchanged.

## Phase 6: User Story 4 - Preserve Profile State and Completion Ownership (Priority: P1)

**Goal**: Preserve save-before-result mutation ordering, machine-result suppression in orchestration, direct readiness availability, and one concise completion synthesis before Setup resumes.

**Independent Test**: Exercise accepted direct, discovered, recommended, corrected, and replacement evidence, including persistence failure and final completion, and verify the visible and owner-result boundaries.

### Tests for User Story 4

- [X] T021 [P] [US4] Add assertions for persistence-before-result, failed-persistence non-success, one completion synthesis, accepted Organization Name use, no new completion question, and no machine fields in normal orchestration in `.highway/tools/tests/profile-lifecycle.test.sh`.
- [X] T022 [P] [US4] Add completion, persistence failure, direct readiness, and orchestrated-result fixtures under `.highway/tools/tests/fixtures/profile-092/completion/`.

### Implementation for User Story 4

- [X] T023 [US4] Refine Operations and Verification in `.highway/skills/highway-profile/SKILL.md` to preserve save-before-result, omit post-write persistence verification, retain direct readiness result availability, and suppress machine-only fields from normal orchestration.
- [X] T024 [US4] Refine the guided completion synthesis wording in `.highway/skills/highway-profile/SKILL.md` to emit one concise user-relevant synthesis before Setup resumes without status, next action, blocking reason, owner-result mechanics, or a new question.
- [X] T025 [US4] Run Profile lifecycle, behavior, UX, and full focused contract tests and record the User Story 4 result in `specs/118-profile-advisory-enrichment/quickstart.md`.

**Checkpoint**: Accepted state, owner results, and user-visible completion closure have distinct correct boundaries.

## Phase 7: User Story 5 - Keep Profile Boundaries and Schema Stable (Priority: P2)

**Goal**: Verify the unchanged four-domain schema, shared template boundary, error behavior, minimal Experience section, and Profile version compatibility.

**Independent Test**: Run Profile structure, template, migration, lifecycle, hygiene, and skill validation checks; inspect the diff to confirm `profile-record.md` is unchanged and Profile stays at 5.1.0.

### Tests for User Story 5

- [X] T026 [P] [US5] Add assertions for unchanged schema `3.0.0`, four domain keys, three domain states, unchanged `profile-record.md`, minimal Experience section, and 5.1.0 version handling in `.highway/tools/tests/profile-structure.test.sh`.
- [X] T027 [P] [US5] Add runtime-scope assertions for no brownfield technology discovery, no development identifiers, and no duplicated generic Experience rules in `.highway/tools/tests/feature-092-contract.test.sh`.

### Implementation for User Story 5

- [X] T028 [US5] Update only Profile-specific Verification and Error Handling wording in `.highway/skills/highway-profile/SKILL.md` to preserve unsupported-schema, obsolete-YAML, malformed-record, readiness, and template-reference behavior.
- [X] T029 [US5] Review `.highway/library/templates/output/profile-record.md` and record a no-change result in `specs/118-profile-advisory-enrichment/quickstart.md`; do not edit the template.
- [X] T030 [US5] Regenerate declared skill adapters and catalog outputs with `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-library-catalog.sh`, then run the corresponding correspondence checks.
- [X] T031 [US5] Run `.highway/tools/validate-skill.sh .highway/skills/highway-profile` and the Profile structure, template, migration, lifecycle, behavior, and UX checks; record results in `specs/118-profile-advisory-enrichment/quickstart.md`.

**Checkpoint**: Profile boundaries and shared schema remain compatible, generated dependents are current, and all story-level checks pass.

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Validate the complete implementation against the plan, specification, and repository governance.

- [X] T032 [P] Run `git diff --check` and record the result in `specs/118-profile-advisory-enrichment/quickstart.md`.
- [X] T033 [P] Run `bash .highway/tools/tests/run-all.sh` and record the final suite result in `specs/118-profile-advisory-enrichment/quickstart.md`.
- [X] T034 Review the final diff for changes outside `highway-profile`, Profile-specific tests, generated dependents, and Feature 118 design records; record the scope result in `specs/118-profile-advisory-enrichment/quickstart.md`.
- [X] T035 Confirm every FR-001 through FR-034 and SC-001 through SC-012 has implementation or test evidence in `specs/118-profile-advisory-enrichment/quickstart.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup**: T001-T003 establish the baseline and inventory; no story work begins before T001 passes.
- **Foundational**: T004-T006 establish fixtures and traceability; depends on Setup.
- **US1**: T007-T010; depends on Foundational and is the MVP.
- **US2**: T011-T015; depends on US1 because it refines the same Profile acquisition contract and behavior test.
- **US3**: T016-T020; depends on US2 because recommendations consume the accepted-evidence pivot.
- **US4**: T021-T025; depends on US3 because completion consumes accepted recommendations and evidence.
- **US5**: T026-T031; depends on US4 and owns final compatibility and correspondence validation.
- **Polish**: T032-T035; depends on all story checkpoints.

### Parallel Opportunities

- T002-T003 can run in parallel after T001.
- T004-T005 can run in parallel; T006 follows only if registration is needed.
- Within each story, fixture/test tasks marked `[P]` can run in parallel before the sequential skill edit.
- T026-T027 can run in parallel; T028 follows their failing assertions.
- T032-T033 can run in parallel after generated correspondence is complete.

## Parallel Execution Examples

### User Story 1

```text
T007 .highway/tools/tests/profile-behavior.test.sh
T008 .highway/tools/tests/fixtures/profile-092/interaction/profile-introduction/
```

### User Story 3

```text
T016 .highway/tools/tests/profile-behavior.test.sh
T017 .highway/tools/tests/fixtures/profile-092/enrichment/
```

### User Story 4

```text
T021 .highway/tools/tests/profile-lifecycle.test.sh
T022 .highway/tools/tests/fixtures/profile-092/completion/
```

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 and its focused test checkpoint.
3. Verify the first-time Profile interaction independently before proceeding to recommendation and completion behavior.

### Incremental Delivery

1. Establish baseline and fixtures.
2. Lock first-time Profile introduction behavior.
3. Lock accepted-evidence and website-assisted acquisition.
4. Lock cohesive paragraph recommendations and hidden enrichment categories.
5. Lock persistence and completion boundaries.
6. Recheck schema, Experience citation, version, and generated correspondence.
7. Run the full suite and map final evidence to all requirements.
