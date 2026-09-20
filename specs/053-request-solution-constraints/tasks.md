# Tasks: Request Solution Constraints

**Input**: Design documents from `specs/053-request-solution-constraints/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Organization**: Tasks are grouped by user story to enable independent implementation and validation.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the existing Request implementation surfaces and prepare the Feature 053 validation scope.

- [X] T001 Review `specs/053-request-solution-constraints/plan.md`, `spec.md`, `data-model.md`, `research.md`, `quickstart.md`, and both files under `specs/053-request-solution-constraints/contracts/` to confirm the implementation scope and ownership boundaries.
- [X] T002 [P] Inventory the authoritative Request surfaces in `.highway/skills/highway-new/SKILL.md`, `.highway/library/templates/output/request-record.md`, and `.highway/tools/tests/highway-new.test.sh` without modifying generated adapters.
- [X] T003 [P] Record the pre-change focused validation baseline for `.highway/tools/tests/highway-new.test.sh`, `.highway/tools/validate-skill.sh .highway/skills/highway-new`, and `.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md` in the implementation notes for this feature.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the shared seven-domain field order and contract vocabulary before story-specific behavior is changed.

**Checkpoint**: The authoritative Request template, source skill, and focused test agree on the Solution Constraints field names and Request/Discovery/ADR ownership boundaries before user-story implementation begins.

- [X] T004 Update `.highway/library/templates/output/request-record.md` with a `## Solution Constraints` section after `## Business Constraints` and before `## Completeness`, containing the eight fields defined in `specs/053-request-solution-constraints/data-model.md`.
- [X] T005 [P] Add the eight-field ordered record assertions and old-boolean absence assertions to `.highway/tools/tests/highway-new.test.sh` before source-skill implementation.
- [X] T006 [P] Add the Solution Constraints contract citation and seven-domain terminology requirements to `.highway/tools/tests/output-template.test.sh` or the nearest existing shared-template validation surface, preserving the repository's existing test ownership.
- [X] T007 Run `.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md` and `.highway/tools/tests/highway-new.test.sh` against the foundational template assertions, then repair only Feature 053 failures before continuing.

## Phase 3: User Story 1 - Capture Solution Constraints (Priority: P1) MVP

**Goal**: Collect an extensible list of allowed solution classes plus required/preferred platforms, known systems, hosting, vendor, procurement, and regulatory restrictions one question at a time without making recommendations.

**Independent Test**: Walk an intake through the Solution Constraints domain and verify that multiple allowed classes, required versus preferred platforms, known systems, procurement constraints, empty arrays, unknown values, and neutral absent constraints remain distinct business evidence with no architecture or solution decision.

### Tests for User Story 1

- [X] T008 [P] [US1] Add conversational fixture assertions for multiple `allowed_solution_classes`, required and preferred platforms, and one-question-per-turn behavior in `.highway/tools/tests/highway-new.test.sh`.
- [X] T009 [P] [US1] Add fixture assertions for `known_systems`, `procurement_constraints`, hosting/vendor/regulatory restrictions, and neutral absent constraints in `.highway/tools/tests/highway-new.test.sh`.
- [X] T010 [P] [US1] Add privacy and boundary assertions proving Solution Constraints do not create Discovery recommendations or ADR decisions in `.highway/tools/tests/highway-new.test.sh`.

### Implementation for User Story 1

- [X] T011 [US1] Extend the ordered evidence-domain workflow in `.highway/skills/highway-new/SKILL.md` to collect Solution Constraints after Business Constraints and ask one natural-language question at a time.
- [X] T012 [US1] Add deterministic intake rules in `.highway/skills/highway-new/SKILL.md` for the extensible `allowed_solution_classes` list, multiple entries without ranking, and distinct required versus preferred platform evidence.
- [X] T013 [US1] Add Solution Constraints collection rules in `.highway/skills/highway-new/SKILL.md` for `known_systems`, hosting restrictions, vendor restrictions, procurement constraints, and regulatory restrictions without architecture inference.
- [X] T014 [US1] Add empty-array, `unknown`, absent-constraint neutrality, malformed-value replacement, privacy exclusion, and Discovery/ADR ownership behavior to `.highway/skills/highway-new/SKILL.md`.
- [X] T015 [US1] Align `.highway/skills/highway-new/SKILL.md` with `specs/053-request-solution-constraints/contracts/request-solution-constraints-intake-contract.md` and remove all legacy solution-class boolean terminology.
- [X] T016 [US1] Run `.highway/tools/tests/highway-new.test.sh` and `.highway/tools/validate-skill.sh .highway/skills/highway-new` to verify the independent conversational intake slice for User Story 1.

**Checkpoint**: User Story 1 can collect all Solution Constraints evidence without ranking, recommending, selecting, or creating Discovery or ADR artifacts.

## Phase 4: User Story 2 - Publish a Complete Constrained Request (Priority: P1)

**Goal**: Persist the eight Solution Constraints fields in the ordered Request record, accept valid populated/empty/unknown states, and preserve existing completeness, catalog, privacy, and transaction behavior.

**Independent Test**: Validate a Request with all seven evidence domains and all eight Solution Constraints fields, including empty arrays and `unknown`, and verify Complete status, ordered output, unchanged catalog behavior, privacy exclusion, and no partial writes.

### Tests for User Story 2

- [X] T017 [P] [US2] Add complete-record fixture coverage for all seven evidence domains and all eight Solution Constraints fields in `.highway/tools/tests/highway-new.test.sh`.
- [X] T018 [P] [US2] Add completeness assertions proving populated values, empty arrays, and `unknown` are valid while missing fields and malformed values are rejected in `.highway/tools/tests/highway-new.test.sh`.
- [X] T019 [P] [US2] Add byte-preservation assertions proving existing catalog allocation, privacy, transaction, and no-partial-write behavior remains unchanged in `.highway/tools/tests/highway-new.test.sh`.
- [X] T020 [P] [US2] Add output-shape assertions matching `specs/053-request-solution-constraints/contracts/request-solution-constraints-record-contract.md` in `.highway/tools/tests/highway-new.test.sh`.

### Implementation for User Story 2

- [X] T021 [US2] Add seven-domain completeness rules and the eight-field Solution Constraints record rendering rules to `.highway/skills/highway-new/SKILL.md`, preserving existing Request ID, status, catalog, privacy, and transaction rules.
- [X] T022 [US2] Update `.highway/library/templates/output/request-record.md` and `.highway/skills/highway-new/SKILL.md` together so field order and placeholder semantics match the record contract.
- [X] T023 [US2] Verify `.highway/skills/highway-new/SKILL.md` and `.highway/library/templates/output/request-record.md` against `specs/053-request-solution-constraints/contracts/request-solution-constraints-record-contract.md` and repair any contract drift.
- [X] T024 [US2] Run `.highway/tools/tests/highway-new.test.sh`, `.highway/tools/validate-skill.sh .highway/skills/highway-new`, and `.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md` to verify the independent durable-record slice for User Story 2.

**Checkpoint**: User Stories 1 and 2 produce a complete, ordered Request record or preserve all existing artifact bytes on failure, without changing Discovery or ADR behavior.

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate derived artifacts, verify distribution correspondence, and execute the documented Feature 053 validation guide.

- [X] T025 [P] Regenerate `.highway/catalog/index.json` and `.highway/catalog/index.md` with `.highway/tools/generate-catalog.sh` after `.highway/skills/highway-new/SKILL.md` is valid.
- [X] T026 [P] Regenerate `.github/skills/highway-new/SKILL.md`, `.claude/skills/highway-new/SKILL.md`, and `.cursor/rules/highway-new.mdc` with `.highway/tools/generate-agent-adapters.sh` after the authoritative source changes.
- [X] T027 [P] Run `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/distribution-packaging.test.sh` to verify generated correspondence and shipped-tree independence.
- [X] T028 Run the scenarios in `specs/053-request-solution-constraints/quickstart.md`, including `.highway/tools/tests/highway-new.test.sh` and the relevant validators, and record Feature 053 results separately from baseline failures.
- [ ] T029 Run `.highway/tools/tests/run-all.sh` and record whether any failures are pre-existing or attributable to Feature 053.
- [X] T030 Review the final implementation diff against `specs/053-request-solution-constraints/spec.md`, `data-model.md`, both contracts, and `quickstart.md`; confirm no Discovery or ADR implementation files changed.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T002 and T003 can run in parallel after T001's scope review.
- **Foundational (Phase 2)**: Depends on Setup; T005 and T006 can run in parallel, then T004/T007 establish the shared contract gate.
- **User Story 1 (Phase 3)**: Depends on Foundational; T008-T010 can run in parallel, followed by T011-T015 and then T016.
- **User Story 2 (Phase 4)**: Depends on Foundational and the shared surfaces established by User Story 1; T017-T020 can run in parallel, followed by T021-T023 and then T024.
- **Polish (Phase 5)**: Depends on both user stories; T025-T027 can run in parallel after source validation, then T028-T030 run in order.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on another user story after Phase 2; it is the MVP and owns conversational evidence collection.
- **User Story 2 (P1)**: Depends on the shared contract from Phase 2 and the intake semantics from User Story 1 because durable output must serialize the same eight fields and states.

### Within Each User Story

- Tests are written before implementation tasks and must initially fail for the new behavior.
- Intake/model contract changes precede rendering and integration changes.
- Validation runs after each story's implementation slice.
- Story completion requires its independent test criteria to pass without changing Discovery or ADR behavior.

### Parallel Opportunities

- T002 and T003 can run concurrently.
- T005 and T006 can run concurrently after T004's field vocabulary is agreed.
- T008, T009, and T010 can run concurrently because they extend separate focused assertion groups in the same test file only when coordinated; otherwise execute sequentially to avoid merge conflicts.
- T017, T018, T019, and T020 can be prepared concurrently as separate fixture/assertion groups, then merged before implementation validation.
- T025, T026, and T027 can run concurrently only after authoritative source validation and generation inputs are stable.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 Setup and Phase 2 Foundational tasks.
2. Complete Phase 3 User Story 1 tasks.
3. Run T016 and confirm conversational Solution Constraints behavior independently.
4. Stop for MVP review before durable-record and generated-artifact work.

### Incremental Delivery

1. Complete Setup and Foundational phases.
2. Deliver User Story 1 as the conversational intake MVP.
3. Deliver User Story 2 with durable seven-domain output and preserved transaction behavior.
4. Regenerate adapters/catalogs and run repository-level validation.
5. Run the full suite and separate baseline failures from Feature 053 regressions.

## Notes

- `[P]` marks tasks that can usefully proceed in parallel without depending on incomplete work in another file.
- Every task includes an exact repository path.
- Discovery remains the owner of candidate generation, classification, comparison, scoring, recommendation, and architecture analysis.
- ADR remains the owner of solution and architecture decisions.
- No task changes Discovery or ADR implementation files.
