---

description: "Task list for Profile Runtime Separation Cleanup"
---

# Tasks: Profile Runtime Separation Cleanup

**Input**: Design documents from `specs/143-profile-runtime-separation/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Focused static Profile contracts and the full repository suite are required by FR-026 and SC-009.

**Organization**: Tasks are grouped by user story and ordered around the shared source skill and generated adapters.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the source, generated paths, protected files, and baseline validation surface.

- [X] T001 [P] Record the Feature 143 source skill, generated adapter paths, protected artifacts, and validation commands in `specs/143-profile-runtime-separation/quickstart.md`.
- [X] T002 [P] Inspect current Profile guards and record stale historical wording or protected-path assumptions in `specs/143-profile-runtime-separation/research.md`.
- [X] T003 Run the existing Profile-focused contracts and `.highway/tools/tests/run-all.sh` to establish the pre-change baseline in `specs/143-profile-runtime-separation/quickstart.md`.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the focused contract and source-of-truth boundary before editing Profile guidance.

- [X] T004 Create `.highway/tools/tests/profile-runtime-separation.test.sh` with static assertions for current-state readiness, four domain ownership, acquisition evidence, mutation boundaries, shared-runtime references, and forbidden historical language.
- [X] T005 Run `.highway/tools/tests/profile-runtime-separation.test.sh` against the baseline and record expected failures in `specs/143-profile-runtime-separation/quickstart.md` before changing the Profile skill.
- [X] T006 Verify the focused contract uses Bash 3.2-compatible syntax and declares its artifact classes in `.highway/tools/tests/profile-runtime-separation.test.sh`.

**Checkpoint**: The focused contract fails only for Feature 143 behavior and protects the explicit protected-file scope.

## Phase 3: User Story 1 - Use only the current Profile model (Priority: P1) 🎯 MVP

**Goal**: Remove historical schema and obsolete-format branching while preserving current readiness, acquisition, and error behavior.

**Independent Test**: Run `.highway/tools/tests/profile-runtime-separation.test.sh`, `profile-behavior.test.sh`, `profile-structure.test.sh`, and `profile-lifecycle.test.sh` against absent, malformed, incomplete, bounded, and complete fixtures.

### Tests for User Story 1

- [X] T007 [P] [US1] Add readiness and obsolete-format assertions to `.highway/tools/tests/profile-runtime-separation.test.sh` for absent, malformed, incomplete, bounded, and complete retained Profiles.
- [X] T008 [P] [US1] Update directly invalidated current-state assertions in `.highway/tools/tests/feature-092-contract.test.sh` and `.highway/tools/tests/feature-138-visible-profile-structure.test.sh` without weakening retained-template or readiness coverage.

### Implementation for User Story 1

- [X] T009 [US1] Replace backward-compatibility exclusions in `When not to use` and the readiness classification in Outputs within `.highway/skills/highway-profile/SKILL.md`.
- [X] T010 [US1] Remove obsolete schema and YAML handling from Profile model and Error Handling in `.highway/skills/highway-profile/SKILL.md` while preserving malformed-artifact blocking.
- [X] T011 [US1] Update Profile model ownership, `bounded` semantics, and current supported structure references in `.highway/skills/highway-profile/SKILL.md`.
- [X] T012 [US1] Update the generated Profile adapters from `.highway/skills/highway-profile/SKILL.md` using `.highway/tools/generate-agent-adapters.sh`.

**Checkpoint**: Profile describes only the current retained model, and readiness/error behavior passes independently.

## Phase 4: User Story 2 - Keep Profile-specific domain meaning concise (Priority: P1)

**Goal**: Replace the long Enrichment section with concise Profile domain contracts, completeness, expression, presentation, and cross-domain reasoning.

**Independent Test**: Review and validate the Domain model, Domain completeness, Organizational expression, Identity, Vision, Competitive Path, Guiding Principles, and Cross-domain reasoning sections against `data-model.md`.

### Tests for User Story 2

- [X] T013 [P] [US2] Add assertions for the target headings, canonical questions, domain boundaries, expression rules, cross-domain dependencies, and absence of duplicated generic interaction loops in `.highway/tools/tests/profile-runtime-separation.test.sh`.
- [X] T014 [P] [US2] Review and update only stale Profile wording assertions in `.highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh` and `.highway/tools/tests/feature-140-profile-convergence-alignment.test.sh`.

### Implementation for User Story 2

- [X] T015 [US2] Rename `### Enrichment` to `### Domain model` and add concise optional enrichment, Organizational expression, and Domain completeness guidance in `.highway/skills/highway-profile/SKILL.md`.
- [X] T016 [US2] Replace generic interaction-heavy Identity, Vision, Competitive Path, and Guiding Principles prose with the Profile-specific domain contracts and validation questions in `.highway/skills/highway-profile/SKILL.md`.
- [X] T017 [US2] Add the single Cross-domain reasoning section and persisted clarification ownership sentence in `.highway/skills/highway-profile/SKILL.md`.
- [X] T018 [US2] Regenerate all declared Profile adapters from `.highway/skills/highway-profile/SKILL.md` and verify source/output correspondence with `.highway/tools/tests/adapter-coverage.test.sh`.

**Checkpoint**: Profile retains domain expertise and presentation behavior without copying shared runtime interaction mechanics.

## Phase 5: User Story 3 - Preserve acquisition, persistence, and readiness outcomes (Priority: P1)

**Goal**: Compress Acquisition and Operations while preserving setup, evidence, explicit boundaries, mutation ordering, failure handling, and guided completion.

**Independent Test**: Run the Profile lifecycle, behavior, context, participation, and focused runtime-separation contracts against setup, acquisition, acceptance, mutation success/failure, and completion scenarios.

### Tests for User Story 3

- [X] T019 [P] [US3] Add acquisition, `bounded`, Organization Name, URL Context, mutation ordering, failure stopping, and guided synthesis assertions to `.highway/tools/tests/profile-runtime-separation.test.sh`.
- [X] T020 [P] [US3] Run `.highway/tools/tests/profile-behavior.test.sh`, `.highway/tools/tests/profile-context-contract.test.sh`, `.highway/tools/tests/profile-lifecycle.test.sh`, and `.highway/tools/tests/profile-participation.test.sh` after the first Operations edit.

### Implementation for User Story 3

- [X] T021 [US3] Replace the Acquisition sequence and source-semantics paragraphs in `.highway/skills/highway-profile/SKILL.md` while preserving first-time setup, reusable material, URL Context, canonical questions, and cross-domain evidence evaluation.
- [X] T022 [US3] Replace Operations with Profile-owned persistence, mutation-before-dependent-output, failure, guided completion, and supported-operation guidance in `.highway/skills/highway-profile/SKILL.md`.
- [X] T023 [US3] Replace Verification and Error Handling with the Profile-specific current-state checks from the Feature 143 specification in `.highway/skills/highway-profile/SKILL.md`.
- [X] T024 [US3] Regenerate Profile adapters and verify the source skill and all declared copies remain aligned.

**Checkpoint**: Existing Profile user journeys and owner-controlled persistence boundaries remain intact after the cleanup.

## Phase 6: User Story 4 - Keep shared runtime ownership singular (Priority: P2)

**Goal**: Confirm Profile cites shared contracts without redefining them and protected runtime artifacts remain unchanged.

**Independent Test**: Compare the final Profile skill and generated adapters with the protected documents, run focused non-duplication assertions, and run the full suite.

### Tests for User Story 4

- [X] T025 [P] [US4] Add protected-path, shared-term, and no-duplicate-mechanics assertions to `.highway/tools/tests/profile-runtime-separation.test.sh`.
- [X] T026 [P] [US4] Run `.highway/tools/tests/profile-runtime-separation.test.sh` and `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh` against the completed source skill.

### Implementation for User Story 4

- [X] T027 [US4] Remove remaining obsolete shared-section references and duplicate generic interaction terminology from `.highway/skills/highway-profile/SKILL.md` while retaining Profile-specific references required by the spec.
- [X] T028 [US4] Apply the Constitution Skill Versioning Policy to the final Profile skill metadata in `.highway/skills/highway-profile/SKILL.md` without changing the retained Profile schema version.
- [X] T029 [US4] Regenerate declared adapters and confirm `profile-record.md`, `experience-standard.md`, `constitution.md`, and `highway-identity.md` remain unchanged.

**Checkpoint**: Shared runtime ownership is singular and the Profile skill is ready for repository-wide regression validation.

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Complete all validation, documentation, correspondence, and artifact integrity checks.

- [X] T030 Run `.highway/tools/tests/profile-runtime-separation.test.sh` and the focused Profile contracts listed in `specs/143-profile-runtime-separation/quickstart.md`.
- [X] T031 Run `.highway/tools/tests/run-all.sh` and record the exact pass/fail summary in `specs/143-profile-runtime-separation/quickstart.md`.
- [X] T032 Run `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/tests/adapter-coverage.test.sh`, and `git diff --check`.
- [X] T033 Verify no protected artifact changed, no obsolete schema/YAML compatibility language remains in the active Profile skill, and the Profile schema remains unchanged.
- [X] T034 Update `specs/143-profile-runtime-separation/quickstart.md` with final observed results and confirm all task markers in `specs/143-profile-runtime-separation/tasks.md` are `[X]`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001-T003 establish paths and baseline; T001 and T002 can run in parallel.
- **Foundational (Phase 2)**: T004-T006 depend on the baseline and block all user-story work.
- **User Story 1 (Phase 3)**: T007-T012 depend on the focused contract and establish the current-state model.
- **User Story 2 (Phase 4)**: T013-T018 depend on US1 because the domain model references the current-state boundary.
- **User Story 3 (Phase 5)**: T019-T024 depend on US1 and can overlap with late US2 work only if edits are isolated; normally follow US2.
- **User Story 4 (Phase 6)**: T025-T029 depend on US1-US3 and verify the final responsibility split.
- **Polish (Phase 7)**: T030-T034 depend on all user stories.

### User Story Dependencies

- **US1 (P1)**: Foundational phase only; MVP for current Profile model and readiness.
- **US2 (P1)**: Depends on US1's current-state wording; independently validates domain semantics.
- **US3 (P1)**: Depends on US1; preserves acquisition and persistence outcomes while integrating US2's domain structure.
- **US4 (P2)**: Depends on the completed source refactor and validates shared ownership and protected scope.

### Parallel Opportunities

- T001 and T002 can run in parallel.
- T007 and T008 can run in parallel before US1 implementation.
- T013 and T014 can run in parallel before US2 implementation.
- T019 and T020 can run in parallel before US3 implementation.
- T025 and T026 can run in parallel before US4 implementation.
- Adapter regeneration and focused contract updates can proceed in separate work windows when the source edit is stable.

## Implementation Strategy

1. Establish and fail the focused contract against the baseline.
2. Complete US1 as the MVP by removing obsolete current-state branches.
3. Replace the domain-heavy Enrichment section and then compress Acquisition and Operations.
4. Regenerate adapters only from the source skill after stable source edits.
5. Run focused contracts after each story, then the full suite and final protected-file checks.
