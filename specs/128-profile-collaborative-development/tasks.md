# Tasks: Profile Collaborative Development

**Input**: Design documents from `specs/128-profile-collaborative-development/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Included because the specification explicitly requires Profile-specific verification and preservation of existing contract coverage.

**Organization**: Tasks are grouped by user story; all three stories are P1 and share the foundational contract inventory.

## Phase 1: Setup

**Purpose**: Establish the implementation baseline and affected contract inventory.

- [X] T001 Read `specs/128-profile-collaborative-development/spec.md`, `plan.md`, `research.md`, `data-model.md`, and `quickstart.md`; record the protected Profile paths in the implementation notes at `specs/128-profile-collaborative-development/quickstart.md`.
- [X] T002 [P] Capture the baseline of `.highway/skills/highway-profile/SKILL.md`, `.highway/library/templates/output/profile-record.md`, and generated Profile adapters/catalog entries with `git diff` and existing repository checks.
- [X] T003 [P] Inventory Profile-specific assertions in `.highway/tools/tests/profile-*.test.sh`, `.highway/tools/tests/feature-092-contract.test.sh`, `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh`, and `.highway/tools/tests/highway-ux-alignment.test.sh`.

## Phase 2: Foundational

**Purpose**: Establish the shared lifecycle vocabulary and protected boundaries before domain-specific edits.

- [X] T004 Add a Profile-specific collaborative lifecycle section to `.highway/skills/highway-profile/SKILL.md` defining Working Idea, Converged Proposal, convergence, contextual re-evaluation, and the existing acceptance-to-persistence ordering without duplicating the full Experience Standard.
- [X] T005 [P] Preserve and verify `schema_version: 3.0.0`, the four retained domains, readiness states, and optional context ownership in `.highway/library/templates/output/profile-record.md` and `.highway/tools/tests/profile-structure.test.sh`.
- [X] T006 [P] Run `bash .highway/tools/tests/profile-structure.test.sh`, `bash .highway/tools/tests/profile-markdown-contract.test.sh`, and `bash .highway/tools/tests/output-template.test.sh` to establish protected-record coverage before domain edits.

## Phase 3: User Story 1 - Develop Profile domains collaboratively (Priority: P1) 🎯 MVP

**Goal**: Replace immediate recommendation acceptance with transient Working Ideas and complete Converged Proposals while preserving domain validation and persistence boundaries.

**Independent Test**: Run Profile behavior and lifecycle contracts with partial, mature, corrected, and casually accepted contributions; verify readiness changes only after an accepted Converged Proposal.

### Tests for User Story 1

- [X] T007 [P] [US1] Update stale immediate-acceptance and recommendation-rhythm assertions in `.highway/tools/tests/profile-behavior.test.sh` to require Working Idea and Converged Proposal semantics while preserving schema, evidence, and validation coverage.
- [X] T008 [P] [US1] Add or update lifecycle assertions in `.highway/tools/tests/profile-lifecycle.test.sh` for transient Working Ideas, acceptance-before-persistence, and natural acceptance of an explicitly presented Converged Proposal.
- [X] T009 [P] [US1] Add or update Profile structure/readiness assertions in `.highway/tools/tests/profile-structure.test.sh` proving Working Ideas do not create `discussed`, `bounded`, or a new readiness state.

### Implementation for User Story 1

- [X] T010 [US1] Replace the `Introduce -> Suggest -> Validate` and acknowledgment bridge guidance in `.highway/skills/highway-profile/SKILL.md` with the collaborative Profile lifecycle and transient Working Idea boundary.
- [X] T011 [US1] Add convergence guidance to `.highway/skills/highway-profile/SKILL.md` defining complete-enough domain narratives, mature-contribution immediate convergence, user correction/refinement, and no manufactured collaboration.
- [X] T012 [US1] Update Identity, Vision, Competitive Path, and Guiding Principles guidance in `.highway/skills/highway-profile/SKILL.md` so validation questions apply only to complete Converged Proposals and existing canonical wording remains intact.
- [X] T013 [US1] Update `.highway/skills/highway-profile/SKILL.md` persistence and operations guidance so only accepted organizational narrative crosses the existing mutation boundary and transient reasoning artifacts are never persisted.

**Checkpoint**: User Story 1 is independently testable; partial ideas remain transient, complete proposals can be accepted, and the Profile record contract remains unchanged.

## Phase 4: User Story 2 - Carry accepted understanding across Profile subjects (Priority: P1)

**Goal**: Make transitions between Profile subjects use contextual re-evaluation and accumulated accepted Profile context without a required acknowledgment stage.

**Independent Test**: Accept Identity, Vision, and Competitive Path in sequence and verify that later subjects use newly visible implications when present, while transitions remain natural when no useful contribution exists.

### Tests for User Story 2

- [X] T014 [P] [US2] Update `.highway/tools/tests/profile-context-contract.test.sh` to assert contextual re-evaluation, accumulated Profile grounding, subject anchoring, and absence of a prescribed acknowledgment bridge.
- [X] T015 [P] [US2] Update `.highway/tools/tests/profile-participation.test.sh` to assert constructive interpretation, sharpening, user correction, and transient related threads without cross-domain interruption.
- [X] T016 [P] [US2] Update `.highway/tools/tests/highway-ux-alignment.test.sh` only where Profile-specific expectations still require superseded acknowledgment or immediate-acceptance wording; preserve shared UX coverage.

### Implementation for User Story 2

- [X] T017 [US2] Replace acceptance-followed-by-acknowledgment wording in `.highway/skills/highway-profile/SKILL.md` with post-persistence contextual re-evaluation and useful contribution when available.
- [X] T018 [US2] Update Vision guidance in `.highway/skills/highway-profile/SKILL.md` to seed a Working Idea or present a Converged Proposal from accepted Identity, website evidence, existing Vision evidence, and accumulated Profile context.
- [X] T019 [US2] Update Competitive Path guidance in `.highway/skills/highway-profile/SKILL.md` to re-evaluate accepted Vision and explain how the organization could pursue it rather than merely summarize Vision.
- [X] T020 [US2] Update Guiding Principles guidance in `.highway/skills/highway-profile/SKILL.md` to derive and sharpen principles from accumulated Profile direction rather than generate generic virtues.
- [X] T021 [US2] Preserve the active-subject anchor, internal enrichment categories, canonical fallback questions, evolution-aware reasoning, and readable short-paragraph guidance in `.highway/skills/highway-profile/SKILL.md`.

**Checkpoint**: User Story 2 is independently testable; each subject transition compounds accepted context without requiring acknowledgment formulas or schema-shaped questioning.

## Phase 5: User Story 3 - Preserve Profile ownership and data semantics (Priority: P1)

**Goal**: Prove the collaborative behavior remains transient and does not alter Profile schema, readiness, website boundaries, or owner-controlled completion.

**Independent Test**: Compare the final implementation and generated outputs against the protected template and run the full Profile, packaging, correspondence, and suite checks.

### Tests for User Story 3

- [X] T022 [P] [US3] Update `.highway/tools/tests/feature-092-contract.test.sh` and `.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh` to preserve schema, readiness, website, validation, and owner-result ordering while removing only superseded assertions.
- [X] T023 [P] [US3] Add scope assertions in `.highway/tools/tests/profile-behavior.test.sh` or the directly affected Profile contract to reject Working Idea fields, reasoning logs, new readiness states, technology-platform discovery, and persistence narration.
- [X] T024 [P] [US3] Verify generated Profile adapters, catalog entries, manifests, and distribution correspondence with the repository generators after `.highway/skills/highway-profile/SKILL.md` changes.

### Implementation for User Story 3

- [X] T025 [US3] Preserve first-time Profile introduction, website acquisition scope, unsupported/malformed/obsolete artifact handling, explicit operations, completion synthesis, and minimal Experience section in `.highway/skills/highway-profile/SKILL.md`.
- [X] T026 [US3] Review `.highway/skills/highway-profile/SKILL.md` against the Highway Skills Constitution and Experience Standard, removing stale Profile-local acknowledgment, immediate-acceptance, workflow-narration, and one-paragraph requirements without copying shared guidance.

**Checkpoint**: User Story 3 is independently testable; protected data semantics and generated correspondence remain valid.

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Regenerate affected outputs, run focused checks, and prove the repository remains clean.

- [X] T027 Run the directly affected focused checks from `specs/128-profile-collaborative-development/quickstart.md` and repair only regressions caused by the new Profile contract.
- [X] T028 Run `bash .highway/tools/tests/run-all.sh` and record the complete result in `specs/128-profile-collaborative-development/quickstart.md`.
- [X] T029 Review `git diff -- .highway/skills/highway-profile/SKILL.md .highway/tools/tests .github/skills/highway-profile .claude/skills/highway-profile .cursor/rules/highway-profile.mdc .codex/skills/highway-profile .highway/catalog .highway/tools/.adapter-manifest` against the spec and plan; confirm protected files remain unchanged.
- [X] T030 Run `git diff --check` over all Feature 128 implementation and generated correspondence paths and confirm no unresolved placeholders remain in `specs/128-profile-collaborative-development/`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the baseline.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user-story work.
- **User Story 1 (Phase 3)**: Depends on Foundational; MVP and acceptance-boundary basis.
- **User Story 2 (Phase 4)**: Depends on Foundational and the lifecycle vocabulary from US1; may begin in parallel at the file level only after the shared lifecycle wording is settled.
- **User Story 3 (Phase 5)**: Depends on Foundational and the behavior changes in US1/US2; validates preservation and correspondence.
- **Polish (Phase 6)**: Depends on all desired user stories.

### User Story Dependencies

- **US1 (P1)**: Independent after Foundational; recommended MVP.
- **US2 (P1)**: Uses the lifecycle boundary established by US1; independently testable after the shared Profile lifecycle is present.
- **US3 (P1)**: Cross-cutting preservation validation depends on US1 and US2 edits but does not add a new persisted data model.

### Parallel Opportunities

- T002 and T003 can run in parallel during Setup.
- T005 and T006 can run in parallel during Foundational work.
- T007–T009 can run in parallel because they touch separate or independently scoped test assertions.
- T014–T016 can run in parallel after the shared lifecycle wording is established.
- T022–T024 can run in parallel after the implementation source stabilizes.
- T027 and T030 can run in parallel after the final source/generated diff is ready.

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Setup and Foundational phases.
2. Implement the Working Idea / Converged Proposal boundary and preserve the existing mutation path.
3. Run the focused US1 contracts.
4. Continue to US2 and US3 only after the acceptance boundary is stable.

### Incremental Delivery

1. Establish and validate the lifecycle vocabulary.
2. Deliver US1 as the minimum viable collaborative Profile behavior.
3. Add contextual re-evaluation and domain-specific transitions through US2.
4. Complete preservation, correspondence, and full-suite validation through US3 and Polish.

## Notes

- Every task has a checkbox, sequential ID, applicable parallel marker, story label for story phases, and an exact repository path.
- Generated artifacts must be changed only through their declared generators.
- No task introduces Profile schema fields, readiness states, Working Idea files, reasoning logs, or a new external contract.
