---

description: "Executable task list for Feature 039 completion record enforcement"
---

# Tasks: Completion Record Enforcement

**Input**: Design documents from `/specs/039-completion-record-enforcement/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Organization**: Tasks are grouped by user story. Feature identity reconciliation is pulled into
Foundational because later phases write records into the relocated Feature 036 path.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the implementation baseline and inventory the affected development records.

- [X] T001 Record the passing baseline from `.highway/tools/tests/run-all.sh` in `specs/039-completion-record-enforcement/quickstart.md`
- [X] T002 [P] Inventory completed feature directories, requirement IDs, existing coverage filenames, and branch declarations in `specs/039-completion-record-enforcement/data-model.md`
- [X] T003 [P] Add the Feature 039 contract references to `specs/039-completion-record-enforcement/plan.md`
- [X] T004 [P] Create disposable completion-check fixtures under `.highway/tools/tests/fixtures/completion-record-enforcement/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Fix the coverage contract, the declared check scope, and every feature path before any
record is written, so no later task writes into a directory that is about to move.

**Checkpoint**: Schema, scope, and directory identities are stable; record back-fill can begin.

- [X] T005 Declare the enforced scope as Features 021 onward plus Feature 020, naming Feature 040 as owner of 001-019, and define the `coverage.md` schema in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T006 [P] Add contract assertions for the required coverage headers and allowed outcomes in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T007 [P] Add contract assertions for duplicate, unknown, missing, and malformed requirement rows in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T008 [P] Add failure fixtures for missing records, invalid outcomes, missing evidence, and absent satisfying artifacts in `.highway/tools/tests/fixtures/completion-record-enforcement/`
- [X] T009 Relocate `specs/036-feature-036/` to `specs/036-strengthen-035-evidence/` without changing any file's content
- [X] T010 [P] Reconcile the bracketed `Feature Branch` values in `specs/001-multi-agent-skill-suite/spec.md` and `specs/005-rename-content-to-library/spec.md`
- [X] T011 [P] Reconcile the canonical Feature 033 name and record the choice in `specs/039-completion-record-enforcement/research.md`
- [X] T012 Record pre-enable verdicts for D7.4, D5.5, D3.7, and D3.8 against the current tree in `specs/039-completion-record-enforcement/research.md`
- [X] T013 Observe the new checks failing on the seeded invalid fixtures before enabling the final assertions in `.highway/tools/tests/completion-coverage.test.sh`

---

## Phase 3: User Story 1 - Enforce Complete Coverage Records (Priority: P1) [MVP]

**Goal**: Make every completed feature from 021 onward, plus Feature 020, carry one machine-checkable
coverage record and make every invalid state fail the completion check.

**Independent Test**: Run `.highway/tools/tests/completion-coverage.test.sh` against every in-scope
feature, then exercise each invalid fixture and confirm failure before restoring the valid state.

### Tests for User Story 1

- [X] T014 [P] [US1] Assert that every completed feature in the declared scope has `coverage.md` in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T015 [P] [US1] Assert exact `Requirement`, `Outcome`, `Evidence` headers and the `satisfied`/`deferred`/`historical` outcome vocabulary in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T016 [P] [US1] Assert missing, duplicate, unknown, malformed, and artifact-resolution failures in `.highway/tools/tests/completion-coverage.test.sh`

### Implementation for User Story 1

- [X] T017 [US1] Replace non-enforcing `PRE_ENABLE` reporting with failing assertions for every completed feature in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T018 [US1] Normalize the existing records in `specs/021-completion-claim-accountability/coverage.md`, `specs/030-control-derived-nfr-generation/coverage.md`, and `specs/031-relationship-reconciliation-integrity/coverage.md`
- [X] T019 [US1] Convert artifact-column records to the declared schema in `specs/022-shared-output-templates/coverage.md`, `specs/023-help-description-listing/coverage.md`, `specs/024-highway-profile/coverage.md`, `specs/033-highway-setup/coverage.md`, and `specs/034-highway-setup-compliance/coverage.md`
- [X] T020 [US1] Normalize the third coverage schema in `specs/038-readiness-verification-corrections/coverage.md` to the declared columns and outcomes
- [X] T021 [US1] Replace the alternate records `specs/032-feature-completeness-enforcement/test-evidence.md` and `specs/037-readiness-ownership-refactor/requirements-coverage.md` with canonical `coverage.md` records
- [X] T022 [US1] Create missing `coverage.md` records for completed features 025 through 029, 032, 035, `specs/036-strengthen-035-evidence/`, and 037
- [X] T023 [US1] Assert that the `historical` outcome is rejected in any feature numbered 021 or above in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T024 [US1] Create `specs/020-highway-nfrs/coverage.md` naming FR-002, FR-020, FR-024, FR-027, and FR-032 as deferred with corrective ownership
- [X] T025 [US1] Run `.highway/tools/tests/completion-coverage.test.sh` and verify every in-scope feature passes with no non-enforcing pre-enable output

**Checkpoint**: US1 is complete when every in-scope feature has a valid canonical record and the
focused check fails and passes for each seeded state.

---

## Phase 4: User Story 2 - Preserve Honest Correction History (Priority: P1)

**Goal**: Make corrective relationships explicit without rewriting completed substantive records.

**Independent Test**: Review every corrective feature coverage record and confirm each revised
requirement names its originating feature, revised requirement, superseding feature, and honest
disposition.

### Tests for User Story 2

- [X] T026 [P] [US2] Add corrective-feature provenance assertions for deferred coverage rows in `.highway/tools/tests/completion-coverage.test.sh`
- [X] T027 [P] [US2] Add a fixture covering multiple corrective requirements and superseding features in `.highway/tools/tests/fixtures/completion-record-enforcement/correction-history/`

### Implementation for User Story 2

- [X] T028 [US2] Add originating-feature and superseding-feature evidence to corrective rows in `specs/025-profile-path-migration/coverage.md` and `specs/026-valid-profile-yaml/coverage.md`
- [X] T029 [US2] Add originating-feature and superseding-feature evidence to corrective rows in `specs/028-objectives-rename-cleanup/coverage.md` and `specs/029-migration-contract-enforcement/coverage.md`
- [X] T030 [US2] Add originating-feature and superseding-feature evidence to corrective rows in `specs/032-feature-completeness-enforcement/coverage.md`, `specs/034-highway-setup-compliance/coverage.md`, and `specs/036-strengthen-035-evidence/coverage.md`
- [X] T031 [US2] Add originating-feature and superseding-feature evidence to corrective rows in `specs/038-readiness-verification-corrections/coverage.md`
- [X] T032 [US2] Verify no deferred row claims satisfaction and no completed substantive file content changed, then run `.highway/tools/tests/completion-coverage.test.sh`

**Checkpoint**: US2 is complete when corrective coverage preserves historical claims and names later
ownership without modifying completed substantive records.

---

## Phase 5: User Story 3 - Prove Checks and Evidence Are Trustworthy (Priority: P1)

**Goal**: Ensure every registered automatic check can fail for its declared scope, every test
declares its instrument class, and the constitution records the new rules honestly.

**Independent Test**: Seed a defect into one artifact of each declared class of every registered
`[auto]` check, observe non-zero results, restore the fixtures, and confirm evidence classes stay
separate.

### Tests for User Story 3

- [X] T033 [P] [US3] Add seeded-failure scope assertions to `.highway/tools/tests/completion-coverage.test.sh`
- [X] T034 [P] [US3] Add evidence-class fixtures for static document contracts and executed behavior in `.highway/tools/tests/fixtures/completion-record-enforcement/evidence-classes/`

### Implementation for User Story 3

- [X] T035 [US3] Declare the artifact classes of every registered `[auto]` check across the files under `.highway/tools/tests/`
- [X] T036 [US3] Add or confirm seeded-defect probes for the D1.1 and D1.2 checks in `.highway/tools/tests/shipped-tree-independence.test.sh` and `.highway/tools/tests/distribution-packaging.test.sh`
- [X] T037 [US3] Add seeded-defect probes for the D4.1, D4.2, and D4.3 checks in `.highway/tools/tests/generate-agent-adapters.test.sh` and `.highway/tools/tests/generate-catalog.test.sh`
- [X] T038 [US3] Add seeded-defect probes for the D4.5, D4.6, and D4.7 checks in `.highway/tools/tests/adapter-coverage.test.sh`
- [X] T039 [US3] Add seeded-defect probes for the D5.4, D5.5, D7.2, and D7.4 checks in `.highway/tools/tests/spec-record.test.sh` and `.highway/tools/tests/completion-coverage.test.sh`
- [X] T040 [US3] Declare an instrument class in every test file under `.highway/tools/tests/`
- [X] T041 [US3] Mark runtime-behavior and static document-contract evidence classes in the coverage records for Features 021 onward under `specs/`
- [X] T042 [US3] Record the measured D3.7 and D3.8 conformance result, and any rule deferred to a later change, in `specs/039-completion-record-enforcement/research.md`
- [X] T043 [US3] Amend `.specify/memory/constitution.md` with D3.7, D3.8, D7.4, D7.5, D5.5, both D5.1 Observable exceptions, and the MINOR Sync Impact Report entry
- [X] T044 [US3] Add D5.5 and D7.4 to the Enforcement Map in `.specify/memory/constitution.md`, then run `.highway/tools/tests/constitution-inventory.test.sh`

**Checkpoint**: US3 is complete when every registered `[auto]` check proves its failure path, every
test declares its instrument class, and the amended constitution passes inventory.

---

## Phase 6: User Story 4 - Keep Feature Records and Names Consistent (Priority: P2)

**Goal**: Enforce that every feature directory identity agrees with its `Feature Branch`
declaration, and confirm the Foundational reconciliations hold.

**Independent Test**: Run the identity check across all feature directories and confirm the
relocated and reconciled records resolve with no substantive content change.

### Tests for User Story 4

- [X] T045 [P] [US4] Extend `.highway/tools/tests/spec-record.test.sh` to compare each feature directory suffix with its `Feature Branch` value
- [X] T046 [P] [US4] Add mismatch and placeholder directory fixtures to `.highway/tools/tests/fixtures/completion-record-enforcement/feature-identity/`

### Implementation for User Story 4

- [X] T047 [US4] Update repository references to the relocated Feature 036 path in `specs/039-completion-record-enforcement/research.md` and any other referencing file outside completed substantive records
- [X] T048 [US4] Verify the Foundational reconciliations changed no completed substantive file content by inspecting the diff for `specs/001-multi-agent-skill-suite/`, `specs/005-rename-content-to-library/`, and `specs/036-strengthen-035-evidence/`
- [X] T049 [US4] Run `.highway/tools/tests/spec-record.test.sh` and verify every feature directory from 001 onward has a matching identity

**Checkpoint**: US4 is complete when identity checks pass and historical feature content is intact.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Finalize traceability, documentation, and full validation.

- [X] T050 [P] Update `specs/039-completion-record-enforcement/quickstart.md` with final commands, expected results, and evidence boundaries
- [X] T051 [P] Update `specs/039-completion-record-enforcement/data-model.md` if implementation reveals additional coverage-record relationships
- [X] T052 Verify every Feature 039 functional requirement maps to an implementation task and validation artifact in `specs/039-completion-record-enforcement/plan.md`
- [X] T053 Create `specs/039-completion-record-enforcement/coverage.md` in the declared schema covering FR-001 through FR-027
- [X] T054 Run `.highway/tools/tests/run-all.sh` and record the final passing result in `specs/039-completion-record-enforcement/quickstart.md`
- [X] T055 Run `git diff --check` from `./` and inspect the final changed-file set for unintended edits outside the declared Layer 0 scope

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes baseline and fixtures.
- **Foundational (Phase 2)**: Depends on Setup; blocks every story. Directory relocation happens
  here so no later task writes into a path that is about to move.
- **User Story 1 (Phase 3)**: Depends on Foundational; MVP.
- **User Story 2 (Phase 4)**: Depends on US1's canonical records.
- **User Story 3 (Phase 5)**: Depends on Foundational; the constitution amendment lands last within
  the phase, after the evidence it governs exists.
- **User Story 4 (Phase 6)**: Depends on Foundational's reconciliations; verifies rather than
  performs them.
- **Polish (Phase 7)**: Depends on all four user stories.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational only.
- **User Story 2 (P1)**: Depends on US1's canonical coverage records.
- **User Story 3 (P1)**: Depends on Foundational; shares the completion test with US1, so integrate
  after the US1 assertions are stable.
- **User Story 4 (P2)**: Depends on Foundational; independent of US1 through US3.

### Within Each User Story

- Tests and seeded fixtures are created before implementation and must fail before the corresponding
  behavior is enabled.
- Coverage schema and scope precede record back-fill.
- Seeded-defect probes precede the constitution amendment that requires them.
- Identity relocation precedes every task that writes into the relocated path.

### Parallel Opportunities

- T002-T004 during Setup.
- T006-T008 and T010-T011 during Foundational.
- T014-T016 as US1 tests.
- T026-T027 as US2 tests.
- T033-T034 as US3 tests.
- T036-T038 touch different test files and can run in parallel.
- T045-T046 as US4 tests.
- T050-T051 during Polish.

## Parallel Example: User Story 3

```text
Task: "T036 [US3] Seeded-defect probes for D1.1 and D1.2 in .highway/tools/tests/shipped-tree-independence.test.sh"
Task: "T037 [US3] Seeded-defect probes for D4.1 and D4.2 in .highway/tools/tests/generate-catalog.test.sh"
Task: "T038 [US3] Seeded-defect probes for D4.5 through D4.7 in .highway/tools/tests/adapter-coverage.test.sh"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational.
2. Implement US1's canonical schema, back-fill, and failing completion assertions.
3. Run `.highway/tools/tests/completion-coverage.test.sh` independently.
4. Stop and validate before correction provenance, probes, and the constitution amendment.

### Incremental Delivery

1. US1: every completed feature has an enforceable canonical coverage record.
2. US2: corrective history is explicit and honest.
3. US3: every registered `[auto]` check proves its failure path and the constitution records the rules.
4. US4: feature directory identity is enforced.
5. Polish and full suite.

## Notes

- Every task uses the required `- [ ] T###` checklist format and names an exact repository path.
- `[P]` marks only tasks that can run in parallel without conflicting file edits.
- T023 asserts the `historical` bound rather than consuming it; Feature 040 under Phase 13 writes the
  309 rows for Features 001-019 and is the only consumer of that outcome.
- Static prose-contract tests remain valid evidence for requirements about skill text; they are not
  evidence of runtime behavior.
