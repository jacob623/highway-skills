# Tasks: Highway ADR Decision Workflow

**Input**: Design documents from `specs/075-highway-adr/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`

**Organization**: Tasks are grouped by user story. Each story has an independent implementation and validation checkpoint.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish canonical ADR contract surfaces and test fixtures without adding runtime dependencies.

- [X] T001 Confirm the active Feature 075 paths and existing Discovery, Clarification, governance, catalog, validator, generator, and test conventions in `.highway/` and `specs/075-highway-adr/`
- [X] T002 [P] Add the canonical ADR record skeleton with required frontmatter, section order, conditional sections, status fields, and supersession placeholders in `.highway/library/templates/output/adr-record.md`
- [X] T003 [P] Add the canonical ADR catalog skeleton with `Next ID` and ADR index structure in `.highway/library/templates/output/adr-catalog.md`
- [X] T004 [P] Add the initial ADR output-template assertions for frontmatter, required sections, status values, handoff fields, and catalog structure in `.highway/tools/tests/output-template.test.sh`
- [X] T005 [P] Create the ADR focused test harness with declared source-document, generated-artifact, and disposable-fixture scopes in `.highway/tools/tests/highway-adr.test.sh`

**Checkpoint**: Canonical ADR templates and the focused test harness exist; no generated adapters or catalogs are hand-edited.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define shared parsing, validation, transaction, and correspondence foundations required by every user story.

- [X] T006 [P] Add static contract assertions that `highway-adr` cites the complete ADR record and catalog templates in `.highway/tools/tests/highway-adr.test.sh`
- [X] T007 [P] Add identifier, Discovery catalog, and duplicate-ADR fixture helpers for exact six-digit Discovery, option, and ADR identifier validation in `.highway/tools/tests/highway-adr.test.sh`
- [X] T008 [P] Add Clarification status and source-preservation fixture helpers for `CLAR-REQ######` and `CLAR-DISC######` inputs in `.highway/tools/tests/highway-adr.test.sh`
- [X] T009 [P] Add governance baseline fixture helpers for Profile, Objective, Control, and NFR inputs in `.highway/tools/tests/highway-adr.test.sh`
- [X] T010 [P] Add deterministic-output, catalog-conflict, and no-partial-write fixture helpers in `.highway/tools/tests/highway-adr.test.sh`
- [X] T011 Record the expected seeded failures for new ADR contract checks before enabling them, including missing template citations, malformed Discovery, duplicate identifiers, and incomplete handoff fixtures in `.highway/tools/tests/highway-adr.test.sh`
- [X] T012 Define the shared ADR input-resolution, in-memory validation, catalog allocation, three-retry conflict, and ordered-commit boundaries in `.highway/skills/highway-adr/SKILL.md`

**Checkpoint**: The foundational contract and fixture boundaries are ready; User Story 1 can implement the smallest useful ADR decision path.

## Phase 3: User Story 1 - Decide From One Discovery Artifact (Priority: P1) MVP

**Goal**: Consume exactly one valid Discovery handoff, select exactly one existing option, record all alternatives and rationale, and preserve Discovery bytes.

**Independent Test**: Provide one valid Discovery fixture with multiple options and comparison evidence; verify one selected existing option, every non-selected option recorded, deterministic tie-break behavior, and unchanged Discovery bytes.

### Tests for User Story 1

- [X] T013 [P] [US1] Add valid Discovery-to-ADR acceptance fixtures covering one identifier, candidate options, comparison matrix, recommendation, and Reference Architecture matches in `.highway/tools/tests/highway-adr.test.sh`
- [X] T014 [P] [US1] Add failure fixtures for missing, duplicate, lowercase, malformed, ambiguous, and nonexistent Discovery identifiers with byte-preservation assertions in `.highway/tools/tests/highway-adr.test.sh`
- [X] T015 [P] [US1] Add option-integrity fixtures proving selected and evaluated options must exist in Discovery and no candidate definition is changed in `.highway/tools/tests/highway-adr.test.sh`
- [X] T016 [P] [US1] Add tie-break fixtures for recommendation, higher score, Reference Architecture match count, and numeric `OPT` suffix order in `.highway/tools/tests/highway-adr.test.sh`
- [X] T017 [US1] Run the User Story 1 fixtures and capture the expected failing result before implementing the Discovery decision path in `.highway/tools/tests/highway-adr.test.sh`

### Implementation for User Story 1

- [X] T018 [US1] Create the canonical `highway-adr` skill frontmatter, purpose, invocation, and ownership boundary in `.highway/skills/highway-adr/SKILL.md`
- [X] T019 [US1] Implement exact single-Discovery identifier resolution and valid Discovery catalog/artifact validation in `.highway/skills/highway-adr/SKILL.md`
- [X] T020 [US1] Implement Discovery-only option evaluation, deterministic tie-break selection, and one-selected-option validation in `.highway/skills/highway-adr/SKILL.md`
- [X] T021 [US1] Implement alternatives recording, decision statement, decision authority, rationale, consequences, and Reference Architecture authorization fields in `.highway/skills/highway-adr/SKILL.md`
- [X] T022 [US1] Implement Discovery source-byte preservation, no-candidate-generation rules, and pre-write verification in `.highway/skills/highway-adr/SKILL.md`
- [X] T023 [US1] Render the required Discovery Reference, Context, Decision, Alternatives Considered, Assumptions, Risks, Consequences, and Constraints sections in `.highway/library/templates/output/adr-record.md`
- [X] T024 [US1] Run `.highway/tools/tests/highway-adr.test.sh` and repair the User Story 1 implementation until all Discovery decision fixtures pass in `.highway/skills/highway-adr/SKILL.md`

**Checkpoint**: User Story 1 independently produces one deterministic ADR decision from one Discovery artifact without mutating Discovery.

## Phase 4: User Story 2 - Consume Clarification and Governance Evidence (Priority: P1)

**Goal**: Consume resolved and open Clarification evidence plus optional governance context without mutating source artifacts or transferring decision ownership.

**Independent Test**: Run fixtures for every Clarification status and optional governance baseline combination; verify evidence precedence, advisory-only treatment, conflict/open-finding visibility, and unchanged source bytes.

### Tests for User Story 2

- [X] T025 [P] [US2] Add Clarification status fixtures for missing, `not-started`, `in-progress`, `complete`, `blocked`, and malformed records in `.highway/tools/tests/highway-adr.test.sh`
- [X] T026 [P] [US2] Add resolved-finding and response fixtures proving contributions appear in ADR context, rationale, constraints, alternatives, or consequences in `.highway/tools/tests/highway-adr.test.sh`
- [X] T027 [P] [US2] Add open-finding, conflict-guidance, and `CLAR-ADR######` exclusion fixtures in `.highway/tools/tests/highway-adr.test.sh`
- [X] T028 [P] [US2] Add Profile, Objective, Control, and NFR relationship fixtures with identifier-type, numeric-suffix, and title ordering assertions in `.highway/tools/tests/highway-adr.test.sh`
- [X] T029 [US2] Run the User Story 2 fixtures and capture the expected failing result before implementing Clarification and governance consumption in `.highway/tools/tests/highway-adr.test.sh`

### Implementation for User Story 2

- [X] T030 [US2] Implement start-of-run read-only resolution of `CLAR-REQ######` and `CLAR-DISC######` and exclusion of `CLAR-ADR######` in `.highway/skills/highway-adr/SKILL.md`
- [X] T031 [US2] Implement Clarification status handling, malformed fallback, resolved evidence precedence, and source-byte preservation in `.highway/skills/highway-adr/SKILL.md`
- [X] T032 [US2] Implement open finding references, conflict recording in Risks and Decision Rationale, and advisory-only restrictions in `.highway/skills/highway-adr/SKILL.md`
- [X] T033 [US2] Implement read-only Profile, Objective, Control, and NFR consumption with deterministic relationship ordering in `.highway/skills/highway-adr/SKILL.md`
- [X] T034 [US2] Add Clarification Inputs, Open Clarification Findings, Decision Rationale, Objective Relationships, Control Relationships, and NFR Relationships sections to `.highway/library/templates/output/adr-record.md`
- [X] T035 [US2] Run `.highway/tools/tests/highway-adr.test.sh` and repair the User Story 2 implementation until all Clarification and governance fixtures pass in `.highway/skills/highway-adr/SKILL.md`

**Checkpoint**: User Stories 1 and 2 work independently; ADR consumes advisory evidence while all upstream artifacts remain unchanged.

## Phase 5: User Story 3 - Publish a Deterministic ADR Handoff (Priority: P1)

**Goal**: Publish a complete accepted ADR and one catalog entry with deterministic output, complete handoff, lifecycle placeholders, and no-write failure behavior.

**Independent Test**: Generate from identical valid inputs twice and compare ADR/catalog bytes; verify required sections, accepted status, complete handoff, one catalog advance, duplicate rejection, and conflict retry limits.

### Tests for User Story 3

- [X] T036 [P] [US3] Add required-section, Decision Confidence, status, supersession, and complete-handoff fixtures in `.highway/tools/tests/highway-adr.test.sh`
- [X] T037 [P] [US3] Add Recommendation Override placement and non-selected-option wording fixtures in `.highway/tools/tests/highway-adr.test.sh`
- [X] T038 [P] [US3] Add duplicate-Discovery ADR, catalog allocation conflict, three-retry limit, and pre-operation byte-preservation fixtures in `.highway/tools/tests/highway-adr.test.sh`
- [X] T039 [P] [US3] Add repeated-run byte identity and volatile-metadata exclusion fixtures in `.highway/tools/tests/highway-adr.test.sh`
- [X] T040 [US3] Run the User Story 3 fixtures and capture the expected failing result before implementing catalog publication and deterministic handoff behavior in `.highway/tools/tests/highway-adr.test.sh`

### Implementation for User Story 3

- [X] T041 [US3] Add mandatory Decision Confidence, Reference Architecture Handoff, and initial supersession fields to `.highway/library/templates/output/adr-record.md`
- [X] T042 [US3] Implement Discovery match, confidence, and reason projection without recomputation and explicit `None` values for permitted empty handoff fields in `.highway/skills/highway-adr/SKILL.md`
- [X] T043 [US3] Implement accepted-only initial status, Discovery-based uniqueness rejection, catalog allocation, one-time catalog advance, and three-retry conflict handling in `.highway/skills/highway-adr/SKILL.md`
- [X] T044 [US3] Implement byte-identical rendering, stable options/relationships/handoff ordering, volatile-metadata exclusions, and final verification in `.highway/skills/highway-adr/SKILL.md`
- [X] T045 [US3] Add the ADR catalog index, direct ADR path, and one-entry-per-success contract in `.highway/library/templates/output/adr-catalog.md`
- [X] T046 [US3] Run `.highway/tools/tests/highway-adr.test.sh` and `.highway/tools/tests/output-template.test.sh` and repair the User Story 3 implementation until publication fixtures pass in `.highway/skills/highway-adr/SKILL.md`

**Checkpoint**: All three P1 stories independently produce and validate the authoritative ADR handoff.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate distributed artifacts, validate dependent contracts, and complete repository-wide verification.

- [X] T047 [P] Regenerate the skill catalog and distribution metadata from canonical inputs with `.highway/tools/generate-catalog.sh`
- [X] T048 [P] Regenerate the shared library catalog from canonical ADR templates with `.highway/tools/generate-library-catalog.sh`
- [X] T049 [P] Regenerate agent adapters from `.highway/skills/highway-adr/SKILL.md` with `.highway/tools/generate-agent-adapters.sh`
- [X] T050 [P] Extend adapter and distribution correspondence assertions for `highway-adr` in `.highway/tools/tests/adapter-coverage.test.sh`
- [X] T051 [P] Revalidate every existing skill that cites a changed shared output template with `.highway/tools/validate-skill.sh` and `.highway/tools/validate-library.sh`
- [X] T052 Run all focused validators, generator tests, and `.highway/tools/tests/highway-adr.test.sh` according to `specs/075-highway-adr/quickstart.md`
- [X] T053 Run `.highway/tools/tests/run-all.sh` and record the complete suite result separately from requirement coverage in the implementation completion record
- [X] T054 Run `git diff --check` and verify generated artifacts have no drift from canonical inputs in `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, and `.cursor/rules/`
- [X] T055 Update live documentation references that describe available skills or output templates in `README.md` and `.highway/README.md` if the implementation changes their current behavior

**Checkpoint**: Canonical inputs, generated outputs, focused tests, validators, documentation, and full-suite evidence are synchronized.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T002-T005 can run in parallel after T001 confirms paths.
- **Foundational (Phase 2)**: Depends on Setup; T006-T010 can run in parallel, then T011-T012 establish executable contract boundaries.
- **User Story 1 (Phase 3)**: Depends on Foundational; T013-T016 can run in parallel, T017 precedes T018-T023, and T024 is the story checkpoint.
- **User Story 2 (Phase 4)**: Depends on Foundational and the ADR decision surface from User Story 1; T025-T028 can run in parallel, T029 precedes T030-T034, and T035 is the story checkpoint.
- **User Story 3 (Phase 5)**: Depends on User Stories 1 and 2 because publication validates their complete rendered content; T036-T039 can run in parallel, T040 precedes T041-T045, and T046 is the story checkpoint.
- **Polish (Phase 6)**: Depends on all three user-story checkpoints; T047-T051 can run in parallel, then T052-T055 run as final verification/documentation work.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational only; this is the MVP increment.
- **User Story 2 (P1)**: Depends on Foundational and the User Story 1 decision model; its fixtures must remain independently runnable against the completed ADR skill.
- **User Story 3 (P1)**: Depends on User Stories 1 and 2 because deterministic publication includes their decision and evidence sections.

### Parallel Opportunities

- Setup template, test harness, and initial template assertions can be developed in parallel after path confirmation.
- Foundational fixture helpers for identifiers, Clarification, governance, and publication can be developed in parallel.
- User Story 1 acceptance, failure, option-integrity, and tie-break fixtures can be developed in parallel.
- User Story 2 status, resolved evidence, open/conflict, and relationship fixtures can be developed in parallel.
- User Story 3 required-section, override, failure-transaction, and determinism fixtures can be developed in parallel.
- Polish regeneration and correspondence checks can be run in parallel after canonical inputs stabilize.

## Parallel Example: User Story 1

```text
Task: T013 Add valid Discovery-to-ADR acceptance fixtures in .highway/tools/tests/highway-adr.test.sh
Task: T014 Add invalid and ambiguous Discovery fixtures in .highway/tools/tests/highway-adr.test.sh
Task: T015 Add option-integrity fixtures in .highway/tools/tests/highway-adr.test.sh
Task: T016 Add deterministic tie-break fixtures in .highway/tools/tests/highway-adr.test.sh
```

These test tasks target one fixture file and should be coordinated as one test-authoring stream if
performed by one person; they are listed as parallel opportunities for separate contributors only
when their edits are merged without overwriting adjacent fixture changes.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Write and observe failing User Story 1 fixtures.
3. Implement Discovery-only selection and ADR decision rendering.
4. Run the User Story 1 checkpoint and validate source immutability.
5. Stop for an independently testable MVP before adding Clarification, governance, or publication extensions.

### Incremental Delivery

1. Complete Setup + Foundational to establish canonical contracts and fixture helpers.
2. Add User Story 1 for Discovery-to-ADR decisioning and validate independently.
3. Add User Story 2 for advisory Clarification and governance evidence and validate independently.
4. Add User Story 3 for deterministic publication, catalog allocation, and complete handoff.
5. Regenerate artifacts and run cross-cutting validation and full-suite checks.

### Parallel Team Strategy

1. Complete Setup and Foundational together because all stories share the same canonical skill and focused test harness.
2. After the foundation, assign User Story 1 decision fixtures/logic, User Story 2 evidence fixtures/logic, and User Story 3 publication fixtures/logic in dependency order; shared `.highway/skills/highway-adr/SKILL.md` edits require coordination.
3. Finish with one owner for regeneration, dependent validation, and full-suite evidence.

## Notes

- Every task uses the required `- [ ] T###` checklist format and names an exact repository path.
- `[P]` marks work that can be performed independently when file ownership is coordinated.
- `[US1]`, `[US2]`, and `[US3]` map directly to the three P1 stories in `spec.md`.
- Tests are included because the specification defines independent tests, acceptance scenarios, measurable outcomes, and byte-preservation requirements.
- No runtime service, package installation, migration, or external dependency is introduced.
