---

description: "Executable task list for historical coverage reconstruction"
---

# Tasks: Historical Coverage Reconstruction

**Input**: Design documents from `/specs/040-historical-coverage-reconstruction/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Test tasks are included because the specification explicitly requires seeded failure
states, preservation of Feature 039 assertions, and passing validation before and after the change.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the passing baseline and inventory the historical scope before editing.

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing baseline before implementation.
- [ ] T002 [P] Inventory functional requirement identifiers in `specs/001-multi-agent-skill-suite/spec.md`, `specs/002-highway-folder-consolidation/spec.md`, and `specs/004-shared-content-library/spec.md` through `specs/019-repository-controls/spec.md`, confirming 18 target features, excluding `specs/003-constitution-enforcement/`, and confirming the verified 309-row historical total.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the evidence and enforcement rules that all user stories depend on.

- [X] T003 Read `.highway/tools/tests/completion-coverage.test.sh` and identify every Feature 039 assertion that must remain unchanged while its completed-feature discovery scope is widened.
- [X] T004 [P] Review `specs/020-highway-nfrs/coverage.md` and the corrective feature records under `specs/021-completion-claim-accountability/` through `specs/039-completion-record-enforcement/` to identify which historical requirements have demonstrable later corrections and which require carried-forward completion-record evidence.
- [X] T005 [P] Define the outcome-audit procedure from `specs/040-historical-coverage-reconstruction/data-model.md` and `specs/040-historical-coverage-reconstruction/quickstart.md`, including counts and proportions for `satisfied`, `deferred`, and `historical` rows and the predominantly-satisfied review failure signal.

**Checkpoint**: Requirement identifiers, corrective evidence, and the existing checker contract are understood before records or enforcement are changed.

---

## Phase 3: User Story 1 - Reconstruct pre-021 coverage honestly (Priority: P1) 🎯 MVP

**Goal**: Add one honest, schema-conforming coverage record for each of the 18 newly targeted completed features, using current artifact evidence only where it is substantively justified.

**Independent Test**: Inspect each new `coverage.md`, compare its rows with its feature's `spec.md`, and review every outcome and evidence cell against the current tree and later corrective features.

### Implementation for User Story 1

- [X] T006 [P] [US1] Create `specs/001-multi-agent-skill-suite/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T007 [P] [US1] Create `specs/002-highway-folder-consolidation/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T008 [P] [US1] Create `specs/004-shared-content-library/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T009 [P] [US1] Create `specs/005-rename-content-to-library/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T010 [P] [US1] Create `specs/006-help-skill/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T011 [P] [US1] Create `specs/007-highway-skill-namespace/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T012 [P] [US1] Create `specs/008-help-output-namespacing/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T013 [P] [US1] Create `specs/009-skill-id-namespace-alignment/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T014 [P] [US1] Create `specs/010-constitution-relocation/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T015 [P] [US1] Create `specs/011-skill-path-resolvability/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T016 [P] [US1] Create `specs/012-distribution-packaging/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T017 [P] [US1] Create `specs/013-auto-tier-honesty/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T018 [P] [US1] Create `specs/014-dev-tier-honesty/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T019 [P] [US1] Create `specs/015-requirements-inquiry/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T020 [P] [US1] Create `specs/016-artifact-correspondence/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T021 [P] [US1] Create `specs/017-experience-standard/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T022 [P] [US1] Create `specs/018-experience-enforcement/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [X] T023 [P] [US1] Create `specs/019-repository-controls/coverage.md` with exactly the `Requirement`, `Outcome`, and `Evidence` columns and one evidence-reviewed row for every declared functional requirement.
- [ ] T024 [US1] Audit the 18 new records against `specs/040-historical-coverage-reconstruction/data-model.md`, confirming 309 requirement rows, no duplicate or unknown identifiers, no green-suite-only `satisfied` rows, and a reported outcome distribution.

**Checkpoint**: User Story 1 is independently reviewable: all 18 new records exist, are schema-conforming, and contain honest evidence classifications. Feature 003 remains untouched and Feature 020's existing record is retained.

---

## Phase 4: User Story 2 - Enforce coverage across the project history (Priority: P1)

**Goal**: Make the existing completion checker evaluate every completed feature from 001 onward, exclude incomplete Feature 003, retain Feature 039's assertions, and reject out-of-range `historical` outcomes.

**Independent Test**: Run the focused checker against valid records and disposable mutations for missing records, missing rows, duplicate identifiers, unknown identifiers, malformed headers or outcomes, missing evidence, absent satisfying artifacts, and `historical` in Feature 021 or above.

### Tests for User Story 2

- [X] T025 [US2] Add or preserve disposable failure probes in `.highway/tools/tests/completion-coverage.test.sh` for every required invalid state, ensuring each probe exits non-zero and restores its fixture before the next assertion.

### Implementation for User Story 2

- [X] T026 [US2] Replace the `tasks.md`-dependent feature discovery in `.highway/tools/tests/completion-coverage.test.sh` with completed-feature discovery from 001 onward that explicitly excludes incomplete `specs/003-constitution-enforcement/` and retains Feature 020 and all later completed features.
- [X] T027 [US2] Add the declared historical-scope assertion to `.highway/tools/tests/completion-coverage.test.sh`, rejecting `historical` rows for feature numbers 021 and above while preserving the existing exact-header, outcome, evidence, identity, duplicate, unknown, missing-row, and satisfying-artifact checks.
- [X] T028 [US2] Run `.highway/tools/tests/completion-coverage.test.sh` and repair only local scope or fixture defects until the new 001-onward discovery and all Feature 039 regression probes pass.

**Checkpoint**: User Story 2 is independently testable: the focused completion check evaluates the full completed history, excludes Feature 003, and fails for every specified invalid coverage state.

---

## Phase 5: User Story 3 - Preserve governance boundaries (Priority: P2)

**Goal**: Confirm the implementation remains a records-and-check scope change and does not amend governance rules, shipping standards, or substantive completed specifications.

**Independent Test**: Review the changed paths and run the full suite before and after implementation, confirming only permitted coverage records and the completion checker are affected.

### Implementation for User Story 3

- [X] T029 [P] [US3] Audit the change set against `.specify/memory/constitution.md`, `.highway/governance/constitution.md`, and `.highway/governance/experience-standard.md`, confirming no rule, principle, or standard was added or amended.
- [X] T030 [P] [US3] Audit each completed target directory `specs/001-multi-agent-skill-suite/` through `specs/019-repository-controls/` and `specs/020-highway-nfrs/` to confirm only the permitted `coverage.md` record is new or changed and Feature 003 has no new record.
- [ ] T031 [US3] Run the boundary checks from `specs/040-historical-coverage-reconstruction/quickstart.md`, including the 18+1 feature count, 309-row total, historical-outcome bound, and outcome-distribution report.

**Checkpoint**: User Story 3 is independently testable: governance documents and substantive completed specs are unchanged, permitted records are the only historical additions, and the scope report is complete.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Complete final validation and leave the feature ready for implementation review.

- [X] T032 Run `.highway/tools/tests/run-all.sh` after all implementation changes and confirm exit status 0 with no residual fixture files.
- [X] T033 [P] Run `git diff --check` and inspect the final paths under `specs/040-historical-coverage-reconstruction/`, `.highway/tools/tests/completion-coverage.test.sh`, and the 18 target feature directories for accidental edits.
- [ ] T034 Update `specs/040-historical-coverage-reconstruction/quickstart.md` only if implementation findings change the runnable validation commands or expected results; otherwise record that the guide remains accurate.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establish the passing baseline and historical inventory first.
- **Foundational (Phase 2)**: Depends on Setup; evidence mapping and preservation review block all story work.
- **User Story 1 (Phase 3)**: Depends on Foundational; the 18 record tasks can run in parallel after evidence mapping.
- **User Story 2 (Phase 4)**: Depends on User Story 1 so the widened checker can validate the complete new record set.
- **User Story 3 (Phase 5)**: Depends on User Stories 1 and 2; it audits the complete implementation boundary.
- **Polish (Phase 6)**: Depends on all user stories; final suite and diff validation are last.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational; no dependency on another user story.
- **User Story 2 (P1)**: Depends on User Story 1's records so full-scope validation can pass.
- **User Story 3 (P2)**: Depends on User Stories 1 and 2 because its audit covers both records and enforcement.

### Within Each User Story

- US1 evidence mapping precedes record creation; each record task is independent after that mapping.
- US2 failure probes precede or accompany checker changes; focused validation must pass before boundary review.
- US3 path and governance audits can run in parallel, but the distribution and boundary report follows them.
- Final full-suite validation occurs only after all implementation and review tasks are complete.

### Parallel Opportunities

- T002, T004, and T005 can run in parallel after T001.
- T006-T023 can run in parallel after T004, provided each task edits only its named feature-local `coverage.md`.
- T029 and T030 can run in parallel after US2; T031 follows their findings.
- T033 can run in parallel with the final documentation accuracy review in T034, but both follow T032's passing suite.

## Parallel Example: User Story 1

```text
Task: "Create specs/001-multi-agent-skill-suite/coverage.md from its declared FR identifiers and reviewed evidence."
Task: "Create specs/010-constitution-relocation/coverage.md from its declared FR identifiers and reviewed evidence."
Task: "Create specs/019-repository-controls/coverage.md from its declared FR identifiers and reviewed evidence."
```

These tasks are parallel because they write separate feature-local records and share no incomplete
implementation state after the foundational evidence mapping is complete.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Run the baseline suite and inventory the 309 requirements.
2. Complete the foundational evidence review.
3. Create and audit the 18 historical coverage records.
4. Stop and independently review the record set before changing enforcement.

### Incremental Delivery

1. Complete Setup and Foundational phases.
2. Deliver US1 as the honest historical record set and review its outcome distribution.
3. Deliver US2 by widening the existing completion checker and proving every invalid state fails.
4. Deliver US3 by auditing governance boundaries and completed-spec immutability.
5. Run the final full suite and diff checks.

### Parallel Team Strategy

With multiple contributors, one contributor can maintain the evidence map, contributors can create
separate feature-local records in T006-T023, and another contributor can prepare the focused checker
probes. Merge or integrate only after the foundational evidence mapping is stable and before the
full-suite polish phase.

## Notes

- Every task uses the required `- [ ] T###` checklist form; story tasks carry `[US1]`, `[US2]`, or `[US3]`.
- `[P]` appears only where tasks write separate files or perform independent audits.
- Feature 003 is intentionally excluded, Feature 020 is retained, and no constitution or Experience Standard file is edited.
- No `contracts/` directory is needed because this feature exposes no external API or command contract.
