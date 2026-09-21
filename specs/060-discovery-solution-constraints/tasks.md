# Tasks: Discovery Solution Constraints

**Input**: Design documents from `specs/060-discovery-solution-constraints/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`

**Tests**: Focused contract and behavior tests are included because the specification requires focused verification and seeded failure probes.

**Organization**: Tasks are grouped by user story, with shared contract work completed first.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the Feature 060 implementation surface and preserve the repository's existing Markdown/Bash toolchain.

- [X] T001 Review `specs/060-discovery-solution-constraints/plan.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md` and record the canonical source files in `.highway/skills/highway-discovery/SKILL.md`, `.highway/library/templates/output/discovery-record.md`, and `.highway/tools/tests/highway-discovery.test.sh`
- [X] T002 [P] Inspect `.highway/library/templates/output/discovery-catalog.md`, `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-library-catalog.sh` to confirm generated-output dependencies for Feature 060
- [X] T003 [P] Capture the pre-change baseline by running `.highway/tools/tests/highway-discovery.test.sh`, `.highway/tools/tests/output-template.test.sh`, `.highway/tools/validate-skill.sh .highway/skills/highway-discovery`, and `.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the shared contract and test vocabulary before story-specific behavior is implemented.

- [X] T004 Update `specs/060-discovery-solution-constraints/spec.md` to replace the stale User Story 3 matrix wording `Constraint Violations` with `Constraint Compliance` and align all scenarios with retained-only scoring
- [X] T005 [P] Add Feature 060 contract assertions for the eight canonical Request Solution Constraints fields and section order in `.highway/tools/tests/highway-discovery.test.sh`
- [X] T006 [P] Add Feature 060 shared-template assertions for Candidate Elimination Log, Request Solution Constraints, retained-candidate traceability, and Constraint Compliance in `.highway/tools/tests/output-template.test.sh`
- [X] T007 [P] Extend `.highway/tools/tests/highway-discovery.test.sh` with declared artifact classes and seeded source-document, generated-artifact, and disposable-fixture probes for the new contract
- [X] T008 Validate the foundational contract edits with `.highway/tools/tests/highway-discovery.test.sh`, `.highway/tools/tests/output-template.test.sh`, `.highway/tools/validate-skill.sh .highway/skills/highway-discovery`, and `.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md`

**Checkpoint**: Shared contract vocabulary, test scope, and baseline validators are ready for independent user-story implementation.

## Phase 3: User Story 1 - Generate Candidates Within Declared Solution Boundaries (Priority: P1) 🎯 MVP

**Goal**: Consume Request Solution Constraints explicitly and restrict candidate generation to known allowed solution classes while preserving existing behavior for `unknown`.

**Independent Test**: Verify known allowed classes limit candidate generation, `unknown` preserves unconstrained generation, empty or malformed allowed classes abort before allocation, and identical inputs produce identical candidate sets.

### Tests for User Story 1

- [X] T009 [P] [US1] Add contract assertions for the Discovery Inputs section and `allowed_solution_classes` behavior in `.highway/tools/tests/highway-discovery.test.sh`
- [X] T010 [P] [US1] Add disposable probe fixtures for known allowed classes, `unknown`, empty allowed classes, and malformed allowed classes in `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 1

- [X] T011 [US1] Add the eight Request Solution Constraints inputs and closed-input loading order to `.highway/skills/highway-discovery/SKILL.md`
- [X] T012 [US1] Define allowed-class-aware candidate generation, `unknown` fallback behavior, malformed-input abort behavior, and no-write guarantees in `.highway/skills/highway-discovery/SKILL.md`
- [X] T013 [US1] Add the ordered `Request Solution Constraints` section with all eight fields to `.highway/library/templates/output/discovery-record.md`
- [X] T014 [US1] Extend `specs/060-discovery-solution-constraints/contracts/discovery-analysis-contract.md` with allowed-class loading, generation constraints, and failure behavior
- [X] T015 [US1] Extend `specs/060-discovery-solution-constraints/contracts/discovery-artifact-contract.md` with canonical Request Solution Constraints rendering and `unknown`/empty-array preservation
- [X] T016 [US1] Run the User Story 1 focused probes in `.highway/tools/tests/highway-discovery.test.sh` and confirm candidate generation, fallback, abort, and byte-preservation behavior

**Checkpoint**: User Story 1 independently delivers a constrained candidate space and is testable without recommendation scoring enhancements.

## Phase 4: User Story 2 - Remove Candidates That Violate Mandatory Restrictions (Priority: P1)

**Goal**: Evaluate mandatory Solution Constraints after normalization and exclude invalid candidates before scoring, with deterministic elimination evidence.

**Independent Test**: Verify required-platform, hosting, vendor, procurement, and regulatory violations are excluded before scoring, logged in deterministic order, and produce a safe abort when no viable candidates remain.

### Tests for User Story 2

- [X] T017 [P] [US2] Add required-platform elimination assertions and pre-scoring ordering checks in `.highway/tools/tests/highway-discovery.test.sh`
- [X] T018 [P] [US2] Add hosting, vendor, procurement, regulatory, all-excluded, and elimination-log ordering fixtures in `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 2

- [X] T019 [US2] Define the generate, normalize, evaluate, filter, then score execution order and mandatory filter set in `.highway/skills/highway-discovery/SKILL.md`
- [X] T020 [US2] Define Candidate Elimination Log placement, fields, exclusion reasons, and ordering by candidate identifier, constraint category, then constraint identifier or value in `.highway/skills/highway-discovery/SKILL.md`
- [X] T021 [US2] Add Candidate Elimination Log structure after Unknowns and before Candidate Solution Options in `.highway/library/templates/output/discovery-record.md`
- [X] T022 [US2] Extend `specs/060-discovery-solution-constraints/contracts/discovery-analysis-contract.md` with mandatory filtering, elimination ordering, and zero-viable-candidate failure behavior
- [X] T023 [US2] Extend `specs/060-discovery-solution-constraints/contracts/discovery-artifact-contract.md` with excluded-candidate representation and omission from scoring, matrix, and recommendation
- [X] T024 [US2] Run User Story 2 focused probes and confirm excluded candidates appear only in the ordered Candidate Elimination Log and no partial record/catalog is written

**Checkpoint**: User Story 2 independently guarantees that mandatory restriction violations cannot reach scoring or recommendation.

## Phase 5: User Story 3 - Compare and Recommend Candidates With Constraint Traceability (Priority: P1)

**Goal**: Score surviving candidates deterministically using platform preference and known-system alignment, expose traceability, and produce an advisory recommendation with the revised matrix.

**Independent Test**: Verify preferred-platform scoring-only behavior, known-system scores of 100/75/50, retained Required Platform Match 100, Constraint Compliance values, revised weights, deterministic matrix ordering, and ADR ownership.

### Tests for User Story 3

- [X] T025 [P] [US3] Add deterministic known-system 100/75/50 scoring assertions to `.highway/tools/tests/highway-discovery.test.sh`
- [X] T026 [P] [US3] Add preferred-platform scoring-only and retained Required Platform Match = 100 fixtures to `.highway/tools/tests/highway-discovery.test.sh`
- [X] T027 [P] [US3] Add matrix, retained-candidate traceability, revised-weight, recommendation, and advisory-ownership assertions to `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 3

- [X] T028 [US3] Define retained-only Constraint Alignment composition, preferred-platform 100/50 scoring, known-system 100/75/50 scoring, and the revised 25/25/20/20/10 weights in `.highway/skills/highway-discovery/SKILL.md`
- [X] T029 [US3] Define retained candidate fields Constraint Alignment, Satisfied Constraints, Unsatisfied Constraints, Required Platform Match 100, Preferred Platform Match, and Constraint Compliance in `.highway/skills/highway-discovery/SKILL.md`
- [X] T030 [US3] Replace the matrix template columns and Recommendation score labels with Allowed Solution Class, Constraint Alignment Score, Required Platform Match, Preferred Platform Match, Constraint Compliance, and revised weights in `.highway/library/templates/output/discovery-record.md`
- [X] T031 [US3] Extend `specs/060-discovery-solution-constraints/contracts/discovery-analysis-contract.md` with retained-only scoring tables, revised score composition, and recommendation eligibility
- [X] T032 [US3] Extend `specs/060-discovery-solution-constraints/contracts/discovery-artifact-contract.md` with retained traceability fields, matrix compliance semantics, and Required Platform Match 100
- [X] T033 [US3] Run User Story 3 focused probes in `.highway/tools/tests/highway-discovery.test.sh` and confirm identical closed inputs produce identical scores, ordering, matrix values, and recommendation output

**Checkpoint**: All three P1 stories independently expose a deterministic, constraint-aware, advisory Discovery result.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate product outputs, validate all contracts, and verify source immutability and repository-wide integrity.

- [X] T034 [P] Regenerate `.github/skills/highway-discovery/SKILL.md`, `.claude/skills/highway-discovery/SKILL.md`, and `.cursor/rules/highway-discovery.mdc` with `.highway/tools/generate-agent-adapters.sh`
- [X] T035 [P] Regenerate `.highway/catalog/index.json`, `.highway/catalog/index.md`, `.highway/catalog/library-index.json`, and `.highway/catalog/library-index.md` with the canonical catalog generators
- [X] T036 [P] Update any affected Discovery contract correspondence assertions in `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/highway-discovery.test.sh`
- [X] T037 Run `.highway/tools/validate-skill.sh .highway/skills/highway-discovery` and `.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md`
- [X] T038 Run `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/generate-catalog.test.sh`, `.highway/tools/tests/generate-library-catalog.test.sh`, and `.highway/tools/tests/distribution-packaging.test.sh`
- [X] T039 Run all Feature 060 scenarios from `specs/060-discovery-solution-constraints/quickstart.md`, including required-platform elimination, known-system scoring, canonical ordering, and zero-viable-candidate no-write behavior
- [X] T040 Run `.highway/tools/tests/run-all.sh` and resolve any Feature 060 regressions without weakening unrelated assertions
- [X] T041 Confirm `git diff --check`, generated artifact currency, source-baseline immutability, and no unrelated changes from repository root

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T001-T003 establish scope and baseline.
- **Foundational (Phase 2)**: Depends on Setup; T004-T008 establish shared contract vocabulary and test coverage.
- **User Stories (Phases 3-5)**: Depend on Foundational completion. Stories are all P1, but US1 establishes candidate-space inputs, US2 adds mandatory filtering, and US3 consumes retained candidates for scoring and recommendation.
- **Polish (Phase 6)**: Depends on all desired user stories and contract edits; generated outputs must follow canonical sources.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Phase 2; no dependency on US2 or US3 for its candidate-generation behavior.
- **User Story 2 (P1)**: Depends on US1's input-loading contract; independently validates mandatory filtering and elimination reporting.
- **User Story 3 (P1)**: Depends on US2's retained/excluded state boundary; independently validates scoring and recommendation for retained candidates.

### Parallel Opportunities

- T002 and T003 can run in parallel after T001 scope review.
- T005-T007 can run in parallel because they touch separate contract/test concerns.
- T009-T010 can run in parallel before US1 implementation.
- T017-T018 can run in parallel before US2 implementation.
- T025-T027 can run in parallel before US3 implementation.
- T034-T036 can run in parallel only after all canonical source edits are complete.
- T037-T039 can run in parallel after regeneration; T040 follows their results.

## Parallel Example: User Story 1

```text
Task T009: Add allowed-class contract assertions in .highway/tools/tests/highway-discovery.test.sh
Task T010: Add allowed-class disposable fixtures in .highway/tools/tests/highway-discovery.test.sh
```

## Parallel Example: User Story 2

```text
Task T017: Add required-platform pre-scoring assertions in .highway/tools/tests/highway-discovery.test.sh
Task T018: Add mandatory restriction fixtures in .highway/tools/tests/highway-discovery.test.sh
```

## Parallel Example: User Story 3

```text
Task T025: Add known-system scoring assertions in .highway/tools/tests/highway-discovery.test.sh
Task T026: Add preferred-platform and Required Platform Match fixtures in .highway/tools/tests/highway-discovery.test.sh
Task T027: Add matrix and recommendation assertions in .highway/tools/tests/highway-discovery.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement US1 input loading, allowed-class filtering, `unknown` fallback, and safe failure.
3. Run the US1 focused probes and validators.
4. Stop for an independently demonstrable constrained candidate-space MVP.

### Incremental Delivery

1. Add US2 mandatory restriction filtering and deterministic elimination reporting.
2. Add US3 retained-only scoring, traceability, matrix semantics, and advisory recommendation.
3. Regenerate adapters/catalogs and run the complete validation suite.

### Parallel Team Strategy

After Foundational completion, one contributor can implement US1, another can prepare US2 filtering
contracts/tests, and a third can prepare US3 scoring/matrix contracts/tests. Canonical skill and
shared-template edits should be integrated in dependency order before regeneration.

## Notes

- Every task uses a checkbox, sequential ID, required story label where applicable, and an exact file path.
- Tests are intentionally included because the Feature 060 specification requires focused verification and seeded probes.
- No new runtime dependency, service, parser, or user-owned fixture is required.
