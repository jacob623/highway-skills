# Tasks: Completion Claim Accountability

**Input**: Design documents from `/specs/021-completion-claim-accountability/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Included because the specification defines independent tests, failure proofs, fixture evaluation, and a registered automatic check.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the feature-local records and fixture layout without editing completed feature directories.

- [X] T001 Create the feature-local coverage record template and requirement-entry structure in `specs/021-completion-claim-accountability/coverage.md`
- [X] T002 [P] Create the feature-local red-to-green evidence record structure in `specs/021-completion-claim-accountability/test-evidence.md`
- [X] T003 [P] Create isolated completion-accountability fixture directories under `.highway/tools/tests/fixtures/completion-claim-accountability/`
- [X] T004 [P] Add the Feature 020 historical assessment fixture naming FR-002, FR-020, FR-024, FR-027, and FR-032 as unsatisfied or deferred in `.highway/tools/tests/fixtures/completion-claim-accountability/feature-020/`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define the feature-local formats, parser boundaries, and pre-enable verdict process required by all user stories.

- [X] T005 Add the coverage record schema, allowed outcomes, and malformed-entry rules to `specs/021-completion-claim-accountability/coverage.md`
- [X] T006 [P] Add the test-evidence record schema and behavior-specific observation requirements to `specs/021-completion-claim-accountability/test-evidence.md`
- [X] T007 [P] Define the fixture input and result contract for the completion coverage check in `.highway/tools/tests/fixtures/completion-claim-accountability/README.md`
- [X] T008 Record the pre-enable evaluation method and verdicts for every existing completed feature in `specs/021-completion-claim-accountability/test-evidence.md`
- [X] T009 Add the D3.6, D7.1, and D7.3 amendment content, tier declarations, Principle VII, and amendment history to `.specify/memory/constitution.md`; reserve D7.2 enablement for the US3 pre-enable evaluation and failure proof
- [X] T010 [P] Prepare the D7.2 amendment entry, automatic tier declaration, and Enforcement Map update for application after the coverage check exists in `.specify/memory/constitution.md`

**Checkpoint**: Feature-local records, historical assessment inputs, and the Layer 0 rule contract exist; implementation can proceed by story.

## Phase 3: User Story 1 - A test claim is evidenced before completion (Priority: P1) MVP

**Goal**: Require a recorded behavior-specific failing observation before a test-backed task can be accepted as complete, while allowing valid static prose-contract tests.

**Independent Test**: In an isolated fixture, omit the failing observation and verify completion review rejects the task; add a behavior-specific failing observation followed by a passing observation and verify acceptance; repeat with a static prose-contract test.

### Tests for User Story 1

- [X] T011 [P] [US1] Add a failing fixture test for a task with a passing result but no recorded failing observation in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T012 [P] [US1] Add a failing fixture test for unrelated red output that does not name the claimed behavior in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T013 [P] [US1] Add a passing fixture test for behavior-specific red-to-green evidence in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T014 [P] [US1] Add a passing static prose-contract evidence fixture for agent instructions in `.highway/tools/tests/fixtures/completion-claim-accountability/static-prose/`

### Implementation for User Story 1

- [X] T015 [US1] Implement test-evidence parsing and missing-evidence diagnostics in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T016 [US1] Record the observed failing and passing runs for the coverage test in `specs/021-completion-claim-accountability/test-evidence.md`
- [X] T017 [US1] Document that static prose-contract tests are accepted when their evidence names the behavior under test in `specs/021-completion-claim-accountability/test-evidence.md`

**Checkpoint**: US1 independently rejects green-from-birth claims, accepts behavior-specific red-to-green evidence, and accepts valid static contract tests.

## Phase 4: User Story 2 - Completed tasks correspond to their artifacts (Priority: P1)

**Goal**: Make each completed task accountable for the artifact path and described change it names, without automatically changing task checkboxes.

**Independent Test**: Review isolated fixtures containing an accurate completed task, a missing artifact, an existing artifact with an absent described change, and an intentionally deferred unchecked task.

### Tests for User Story 2

- [X] T018 [P] [US2] Add an accurate completed-task correspondence fixture and expected pass in `.highway/tools/tests/fixtures/completion-claim-accountability/task-correspondence/`
- [X] T019 [P] [US2] Add a missing-artifact completed-task fixture and expected failure naming the path in `.highway/tools/tests/fixtures/completion-claim-accountability/task-correspondence/`
- [X] T020 [P] [US2] Add an absent-described-change fixture and expected failure in `.highway/tools/tests/fixtures/completion-claim-accountability/task-correspondence/`
- [X] T021 [P] [US2] Add an intentionally deferred unchecked-task fixture and expected non-completed status in `.highway/tools/tests/fixtures/completion-claim-accountability/task-correspondence/`

### Implementation for User Story 2

- [X] T022 [US2] Add the task correspondence review procedure for `[X]` tasks, named paths, and semantic findings to `specs/021-completion-claim-accountability/data-model.md`
- [X] T023 [US2] Implement fixture assertions that distinguish missing artifacts, absent described changes, and unchecked deferrals in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T024 [US2] Record the task correspondence review outcomes and the non-automatic checkbox policy in `specs/021-completion-claim-accountability/test-evidence.md`

**Checkpoint**: US2 independently identifies inaccurate completed-task claims and preserves deferred unchecked work.

## Phase 5: User Story 3 - Every requirement has an explicit coverage outcome (Priority: P1)

**Goal**: Add the automatic D7.2 coverage check, prove it fails and recovers, and assess existing completed features without fabricating historical coverage.

**Independent Test**: Run complete, missing, duplicate, unknown, malformed, satisfied, and deferred coverage fixtures; only the complete mapping passes mechanically, while deferred entries remain visible as not satisfied.

### Tests for User Story 3

- [X] T025 [P] [US3] Add a complete requirement-coverage fixture with one entry per requirement ID in `.highway/tools/tests/fixtures/completion-claim-accountability/coverage-valid/`
- [X] T026 [P] [US3] Add missing, duplicate, unknown, and malformed requirement-ID fixtures in `.highway/tools/tests/fixtures/completion-claim-accountability/coverage-invalid/`
- [X] T027 [P] [US3] Add satisfied-artifact and deferred-reason coverage fixtures in `.highway/tools/tests/fixtures/completion-claim-accountability/coverage-outcomes/`
- [X] T028 [US3] Add the coverage test invocation and expected fixture verdict assertions to `.highway/tools/tests/completion-coverage.test.sh`
- [X] T029 [US3] Add the valid coverage fixture's requirement-removal failure proof and restoration pass proof to `.highway/tools/tests/completion-coverage.test.sh`

### Implementation for User Story 3

- [X] T030 [US3] Implement mechanical extraction and comparison of requirement IDs from `spec.md` and `coverage.md` in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T031 [US3] Implement diagnostics for missing, duplicate, unknown, malformed, and silently repaired mappings in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T032 [US3] Implement pre-enable evaluation across every existing completed feature and record missing coverage honestly in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T033 [US3] Add D7.2's automatic check registration and exact test filename assertion to `.highway/tools/tests/constitution-inventory.test.sh`, then apply the prepared D7.2 amendment and Enforcement Map entry in `.specify/memory/constitution.md`
- [X] T034 [US3] Record the D7.2 failure-proof result, restored pass result, and every existing completed-feature verdict in `specs/021-completion-claim-accountability/test-evidence.md`
- [X] T035 [US3] Record Feature 020's five known gaps as deferred or unsatisfied coverage outcomes in `specs/021-completion-claim-accountability/coverage.md` without editing `specs/020-highway-nfrs/`

**Checkpoint**: US3 independently validates exact requirement-ID coverage, reports malformed mappings, proves D7.2 can fail, and distinguishes historical missing coverage from satisfaction.

## Phase 6: User Story 4 - Completion reports separate evidence from coverage (Priority: P2)

**Goal**: Make completion reporting distinguish check results, requirement coverage, task correspondence, deferrals, and qualified status.

**Independent Test**: Review reports containing only checks, only coverage, separated checks and coverage, and conflated claims; only the separated report with visible deferrals is compliant.

### Tests for User Story 4

- [X] T036 [P] [US4] Add a compliant separated completion-report fixture in `.highway/tools/tests/fixtures/completion-claim-accountability/report-valid/`
- [X] T037 [P] [US4] Add conflated, checks-only, and coverage-only report fixtures with expected review failures in `.highway/tools/tests/fixtures/completion-claim-accountability/report-invalid/`
- [X] T038 [P] [US4] Add a deferred-requirement report fixture that requires qualified status in `.highway/tools/tests/fixtures/completion-claim-accountability/report-deferred/`

### Implementation for User Story 4

- [X] T039 [US4] Define the completion report sections and qualified-status rules in `specs/021-completion-claim-accountability/data-model.md`
- [X] T040 [US4] Add report-review assertions for separate check results, coverage outcomes, and deferred status to `.highway/tools/tests/completion-coverage.test.sh`
- [X] T041 [US4] Add the completion-report evidence and review outcomes to `specs/021-completion-claim-accountability/test-evidence.md`
- [X] T042 [US4] Update `specs/021-completion-claim-accountability/quickstart.md` with the implemented coverage-check and report-review commands in `.highway/tools/tests/`

**Checkpoint**: US4 independently prevents passing checks from being reported as unqualified feature completion.

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Integrate the new check into the suite, verify governance records, and run the complete quickstart.

- [X] T043 Integrate `.highway/tools/tests/completion-coverage.test.sh` into `.highway/tools/tests/run-all.sh`
- [X] T044 [P] Update the Development Constitution Enforcement Map and D7.2 amendment evidence in `.specify/memory/constitution.md`
- [X] T045 [P] Verify no completed feature directory was edited and record the check in `specs/021-completion-claim-accountability/test-evidence.md`
- [X] T046 [P] Run the complete quickstart scenarios and record commands, results, and qualified outcomes in `specs/021-completion-claim-accountability/test-evidence.md`
- [X] T047 Run `.highway/tools/tests/run-all.sh` and record the final suite result separately from requirement coverage in `specs/021-completion-claim-accountability/test-evidence.md`
- [X] T048 [P] Update `governance-plan.md` Phase 10 status and completion evidence at `governance-plan.md`

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; creates feature-local records and isolated fixture roots.
- **Foundational (Phase 2)**: Depends on Setup; defines formats and adds the Layer 0 rule contract before story implementation.
- **User Stories (Phases 3-6)**: Depend on Foundational. US1, US2, and US3 can proceed in parallel after shared formats exist; US4 depends on the coverage vocabulary from US3 but its report fixtures can be prepared in parallel.
- **Polish (Phase 7)**: Depends on all desired stories and the D7.2 failure-proof work.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational only; independently testable.
- **User Story 2 (P1)**: Depends on Foundational only; semantic review remains separate from US1 evidence.
- **User Story 3 (P1)**: Depends on Foundational; provides the coverage vocabulary used by US4.
- **User Story 4 (P2)**: Depends on Foundational and the coverage outcome definitions from US3; independently testable with report fixtures.

### Within Each User Story

- Tests and failure fixtures are created first and observed failing before implementation tasks are marked complete.
- Implementation and evidence-record tasks follow the failing observations.
- A story checkpoint is validated independently before cross-story polish.

## Parallel Opportunities

- Setup tasks T002-T004 can run in parallel.
- Foundational tasks T006-T007 and T010 can run in parallel after T005 establishes the record vocabulary.
- US1, US2, and the fixture preparation portions of US3 can be staffed in parallel after Phase 2.
- Within US1, T011-T014 are independent fixture/test additions.
- Within US2, T018-T021 are independent correspondence fixtures.
- Within US3, T025-T027 are independent coverage fixture groups.
- Within US4, T036-T038 are independent report fixtures.
- Polish documentation tasks T044-T046 and T048 touch separate records and can run in parallel, subject to the final suite task T047.

## Parallel Example: User Story 1

```text
Task T011: Add the no-failing-observation fixture and assertion
Task T012: Add the unrelated-red-output fixture and assertion
Task T013: Add the behavior-specific red-to-green fixture and assertion
Task T014: Add the static prose-contract evidence fixture
```

## Parallel Example: User Story 3

```text
Task T025: Add the complete coverage fixture
Task T026: Add invalid coverage fixtures
Task T027: Add satisfied/deferred outcome fixtures
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Complete US1's failing and passing test-evidence fixtures.
3. Record red-to-green evidence, including a valid static prose-contract case.
4. Run the US1 checkpoint independently.
5. Continue to US3 before claiming the feature complete, because D7.2 is the minimum requirement-coverage control.

### Incremental Delivery

1. Establish feature-local evidence and the Layer 0 amendment.
2. Deliver US1 to prevent unsupported test claims.
3. Deliver US2 to prevent unsupported task-to-artifact claims.
4. Deliver US3 to enforce exact requirement coverage and historical assessment.
5. Deliver US4 to separate check results from coverage in completion reports.
6. Run polish and the full suite; report any deferred requirements explicitly.

### Completion Standard

A task is not complete merely because its checkbox is marked. The implementation record must include the named artifact change, behavior-specific evidence where a test is claimed, and the relevant requirement coverage outcome. The final report must state check results separately from satisfied and deferred coverage.
