# Tasks: Highway Organizational Profile

**Input**: Design documents from `specs/024-highway-profile/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Included because the feature specification defines independent behavioral tests and the repository constitution requires tests for behavioral changes.

## Phase 1: Setup

**Purpose**: Establish the feature's source and test surfaces without changing generated artifacts by hand.

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing baseline before implementation
- [X] T002 [P] Add the Feature 024 profile artifact path and source-skill path to the implementation change set in `.highway/tools/.distribution-manifest` and `.highway/skills/highway-profile/SKILL.md`
- [X] T003 [P] Create focused profile test scaffolding in `.highway/tools/tests/profile-structure.test.sh` and `.highway/tools/tests/profile-behavior.test.sh`, covering absent, default, populated, malformed, declined, and confirmed fixtures
- [X] T004 [P] Add a complete retained-output skeleton for the YAML profile under `.highway/library/templates/output/highway-profile.md`

## Phase 2: Foundational

**Purpose**: Implement the shared profile representation, safe file handling, structural validation boundary, and test helpers required by every user story.

**Blocking rule**: User-story work begins only after this phase's parser, serializer, validator, and fixture checks are available.

- [X] T005 [P] Add the distributed default profile with metadata-first ordering, version `1.0.0`, the specified description, and no seeded optional sections in `.highway/profile.yaml`
- [X] T006 Add profile parsing, path resolution helpers, and malformed-input detection to `.highway/tools/lib/profile.sh`
- [X] T007 Document deterministic profile serialization and preservation invariants in `.highway/skills/highway-profile/SKILL.md` and `.highway/library/templates/output/highway-profile.md`
- [X] T008 Add structural profile validation for required metadata, top-level ordering, future-section compatibility, deterministic-value restrictions, and user-value semantic exemption in `.highway/tools/validate-profile.sh`
- [X] T009 [P] Add valid, malformed, empty-section, future-section, and generated-value fixtures under `.highway/tools/tests/fixtures/profile/`
- [X] T010 [P] Add profile validator assertions and fixture coverage to `.highway/tools/tests/profile-structure.test.sh`, including the observed-failure check required before enabling the new validator
- [X] T011 Confirm `.highway/tools/tests/run-all.sh` discovers `.highway/tools/tests/profile-structure.test.sh` automatically and verify the foundational validation passes

**Checkpoint**: Profile parsing/serialization is deterministic, malformed input is non-destructive, the default artifact is structurally valid, and focused foundational tests pass.

## Phase 3: User Story 1 - Discover and Inspect Profile Context (Priority: P1) MVP

**Goal**: Provide help and equivalent read-only inspection actions without creating or modifying the profile.

**Independent Test**: Invoke `/highway-profile`, `view`, `show`, and `describe` against absent, default, and populated profiles; confirm the expected status/content is shown and the profile bytes remain unchanged.

### Tests for User Story 1

- [X] T012 [P] [US1] Add read-only help/view/show/describe assertions, absent-profile setup guidance, and before/after byte checks to `.highway/tools/tests/profile-behavior.test.sh`

### Implementation for User Story 1

- [X] T013 [US1] Create the source skill frontmatter, purpose, ownership boundary, supported actions, usage examples, setup guidance, and current-status help contract in `.highway/skills/highway-profile/SKILL.md`
- [X] T014 [US1] Document equivalent `view`, `show`, and `describe` read-only behavior and missing/malformed profile handling in `.highway/skills/highway-profile/SKILL.md`
- [X] T015 [US1] Document the read-only response fields, contextual-not-governance boundary, and routing of NFR/Control requests in `.highway/skills/highway-profile/SKILL.md`
- [X] T016 [US1] Run `.highway/tools/tests/profile-behavior.test.sh` and `.highway/tools/validate-skill.sh .highway/skills/highway-profile` to verify the MVP behavior and source skill structure

**Checkpoint**: User Story 1 is independently usable and safe to demonstrate as the MVP.

## Phase 4: User Story 2 - Configure an Initial Profile (Priority: P1)

**Goal**: Collect the fourteen requested context answers, show a deterministic proposed profile, and write only after explicit confirmation.

**Independent Test**: Run `setup` and `configure` with representative answers, decline once and confirm unchanged/absent output, then confirm once and verify the metadata-first profile.

### Tests for User Story 2

- [X] T017 [P] [US2] Add questionnaire-count, proposal-content, confirmation-order, decline-no-write, and confirmed-write assertions to `.highway/tools/tests/profile-behavior.test.sh`

### Implementation for User Story 2

- [X] T018 [US2] Document equivalent `setup` and `configure` questionnaires for organization, deployment, cloud, compliance, residency, platform, database, infrastructure-as-code, CI/CD, container, and technology restrictions in `.highway/skills/highway-profile/SKILL.md`
- [X] T019 [US2] Document proposal construction from supplied answers only, omission of empty sections, metadata requirements, and deterministic output in `.highway/skills/highway-profile/SKILL.md`
- [X] T020 [US2] Document the confirmation-gated setup transaction, including preview-before-prompt, declined no-write behavior, and confirmed creation/update of `.highway/profile.yaml` in `.highway/skills/highway-profile/SKILL.md`
- [X] T021 [US2] Run the focused setup contract checks and validate the resulting artifact with `.highway/tools/validate-profile.sh .highway/profile.yaml`

**Checkpoint**: User Story 2 can create an initial profile without inferring unprovided facts or writing before confirmation.

## Phase 5: User Story 3 - Make Confirmed Profile Changes (Priority: P1)

**Goal**: Support add, update, remove, and reset with resolvable paths, complete previews, explicit confirmation, and transactional writes.

**Independent Test**: Against a populated fixture, exercise each mutation, decline each once, then confirm each once; verify only the targeted node changes and declined operations preserve bytes exactly.

### Tests for User Story 3

- [X] T022 [P] [US3] Add add/update/remove/reset mutation assertions for inferred paths, current/proposed state, ramifications, required response fields, confirmation order, and byte-for-byte declined outcomes to `.highway/tools/tests/profile-behavior.test.sh`
- [X] T023 [P] [US3] Add ambiguous action/category/value, malformed profile, missing node, and NFR/Control routing assertions to `.highway/tools/tests/profile-behavior.test.sh`

### Implementation for User Story 3

- [X] T024 [US3] Document profile-node resolution and append-preferred `add` behavior, including insertion location preview, in `.highway/skills/highway-profile/SKILL.md`
- [X] T025 [US3] Document `update` and `remove` previews with exact current/proposed values, affected entries, ramifications, and confirmation status in `.highway/skills/highway-profile/SKILL.md`
- [X] T026 [US3] Document `reset` preview behavior, complete affected-value listing, selected-node clearing, and confirmation requirement in `.highway/skills/highway-profile/SKILL.md`
- [X] T027 [US3] Document the common mutation response contract with `Action`, `File`, `Summary`, `Affected Entries`, and `Confirmation Status` in `.highway/skills/highway-profile/SKILL.md`
- [X] T028 [US3] Document safe abort behavior for ambiguous, malformed, missing, and unresolvable inputs and ensure no proposal can overwrite the original profile in `.highway/skills/highway-profile/SKILL.md`
- [X] T029 [US3] Run focused mutation contract scenarios from `.highway/tools/tests/profile-behavior.test.sh` and validate that each confirmed operation changes only its intended profile node

**Checkpoint**: User Story 3 supports all four confirmed mutations while preserving user-owned content and transaction safety.

## Phase 6: User Story 4 - Preserve Profile Structure and Distribution Semantics (Priority: P2)

**Goal**: Preserve deterministic schema compatibility and ensure source, profile, catalogs, adapters, manifests, and distribution remain correspondingly validated.

**Independent Test**: Validate the shipped default and source skill, rewrite an unchanged populated profile twice, compare bytes and ordering, add future sections, and run correspondence/distribution checks.

### Tests for User Story 4

- [X] T030 [P] [US4] Add byte-identical rewrite, metadata ordering, empty-section omission, timestamp/random-value exclusion, and future-section compatibility assertions to `.highway/tools/tests/profile-structure.test.sh`
- [X] T031 [P] [US4] Run source/profile/catalog/adapter/manifest correspondence assertions with `.highway/tools/tests/adapter-coverage.test.sh`
- [X] T032 [P] [US4] Run distributed-tree validation for `.highway/profile.yaml`, profile output-template references, and absence of development-only paths with `.highway/tools/tests/distribution-packaging.test.sh`

### Implementation for User Story 4

- [X] T033 [US4] Extend the declared distribution path and profile validation flow through `.highway/tools/.distribution-manifest` and `.highway/tools/validate-profile.sh`
- [X] T034 [US4] Verify profile-specific library/catalog containment through `.highway/tools/generate-library-catalog.sh` and `.highway/tools/tests/output-template.test.sh` without applying semantic governance checks to user values
- [X] T035 [US4] Regenerate `.highway/catalog/index.json`, `.highway/catalog/index.md`, `.highway/catalog/library-index.json`, and `.highway/catalog/library-index.md` using the repository generators
- [X] T036 [US4] Regenerate `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, and `.cursor/rules/highway-profile.mdc` with `.highway/tools/generate-agent-adapters.sh`
- [X] T037 [US4] Regenerate and verify `.highway/tools/.adapter-manifest` and `.highway/tools/.distribution-manifest` through the repository's supported generators and correspondence checks
- [X] T038 [US4] Review the complete emitted profile structure against P9.1/X1.5 in `.highway/library/templates/output/highway-profile.md` and `.highway/skills/highway-profile/SKILL.md`
- [X] T039 [US4] Run `.highway/tools/tests/profile-structure.test.sh`, `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/library-containment.test.sh`, and `.highway/tools/tests/distribution-packaging.test.sh`

**Checkpoint**: The profile is structurally deterministic, future-section compatible, and fully represented across all generated/distributed surfaces.

## Phase 7: Polish and Cross-Cutting Validation

**Purpose**: Complete traceability, validate the quickstart, and finish with the repository-wide quality gates.

- [X] T040 [P] Add Feature 024 requirement-to-artifact coverage in `specs/024-highway-profile/coverage.md`, mapping FR-001 through FR-019 exactly once
- [X] T041 [P] Review `.highway/tools/tests/constitution-inventory.test.sh` coverage for the new validator and tests; no constitution enforcement-map change is required
- [X] T042 Run `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`; confirm no generated diff remains
- [X] T043 Run the non-interactive validation commands from `specs/024-highway-profile/quickstart.md` and record the observed results in `specs/024-highway-profile/coverage.md`
- [X] T044 Run `.highway/tools/tests/run-all.sh` after the final edit and confirm the complete suite passes with zero failures
- [X] T045 Run `git diff --check` and review the final Feature 024 diff for unrelated changes, unresolved placeholders, hand-edited generated artifacts, and retained ownership/governance wording

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No implementation dependency; establish paths, fixtures, and the retained-output decision.
- **Foundational (Phase 2)**: Depends on Setup; blocks every user story because all stories use the profile representation and validator.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the MVP read-only surface.
- **User Story 2 (Phase 4)**: Depends on Foundational and the read-only profile/status contract from US1.
- **User Story 3 (Phase 5)**: Depends on Foundational and the profile representation established by US1/US2; can begin after the shared representation is stable.
- **User Story 4 (Phase 6)**: Depends on the source skill/profile behavior from US1-US3 before regenerating and validating all correspondence surfaces.
- **Polish (Phase 7)**: Depends on all desired user stories and generated artifacts being complete.

### User Story Completion Order

1. US1 (P1 MVP)
2. US2 (P1 setup)
3. US3 (P1 mutations)
4. US4 (P2 structure/distribution)

US2 and US3 may be parallelized after Foundational if the shared profile representation and US1 contract are complete, but they should be validated together before US4 regeneration.

### Parallel Opportunities

- Setup tasks T002-T004 can run in parallel after T001.
- Foundational fixture/test work T005, T009, and T010 can run in parallel after the profile path decision; parser/serializer work T006-T007 and validator wiring T008 remain ordered.
- US1 test authoring T012 can run in parallel with the initial source skill draft T013, then T014-T016 depend on the combined contract.
- US2 test authoring T017 can run in parallel with US2 documentation tasks T018-T020.
- US3 test authoring T022-T023 can run in parallel with documentation tasks T024-T028.
- US4 test authoring T030-T032 can run in parallel, while T035-T037 can run in parallel only after source inputs and generators are stable.
- Polish documentation/inventory updates T040-T041 can run in parallel before final validation T042-T045.

## Parallel Example: User Story 1

```text
Task T012: Add read-only behavior assertions in .highway/tools/tests/profile-behavior.test.sh
Task T013: Create source help/action contract in .highway/skills/highway-profile/SKILL.md
```

## Parallel Example: User Story 3

```text
Task T022: Add confirmed/declined mutation tests in .highway/tools/tests/profile-behavior.test.sh
Task T023: Add malformed/ambiguous/routing tests in .highway/tools/tests/profile-behavior.test.sh
Task T024: Document add and profile-node resolution in .highway/skills/highway-profile/SKILL.md
Task T025: Document update/remove previews in .highway/skills/highway-profile/SKILL.md
```

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Implement and validate User Story 1.
3. Stop at the US1 checkpoint for an independently testable read-only skill and profile artifact.

### Incremental Delivery

1. Add US2 questionnaire/setup confirmation and validate it independently.
2. Add US3 transactional mutations and validate declined/confirmed paths independently.
3. Complete US4 structure/distribution correspondence and generated outputs.
4. Run the quickstart and full suite before completion reporting.

### Traceability

Every functional requirement is addressed by at least one story implementation task and one focused or cross-cutting validation task. Completion reporting must distinguish requirement coverage from executable check results.

## Notes

- Every task uses the required checklist format with a sequential ID and an explicit path.
- `[P]` marks tasks that can operate on different files without depending on incomplete work.
- Generated catalogs, adapters, and manifests are regenerated through repository tooling rather than hand-edited.
- Profile values remain user-owned; structural validation must not evaluate them as governance rules, NFRs, or Controls.
