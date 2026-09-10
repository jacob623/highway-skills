---

description: "Implementation tasks for Feature 034 Highway Setup Compliance Hardening"
---

# Tasks: Highway Setup Compliance Hardening

**Input**: Design documents from `/specs/034-highway-setup-compliance/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Behavioral and contract tests are required because the feature explicitly addresses missing verification evidence.

## Implementation Strategy

Deliver the executable behavioral fixture foundation first, then normalize the NFR and dashboard contracts, add routing measurement, complete manual ownership evidence, and finish with generated-artifact and full-suite validation. Preserve Feature 033 behavior except where the canonical contract explicitly resolves an ambiguity.

## Dependencies

- Phase 1 precedes all other phases.
- Phase 2 provides shared fixture, event-log, hash, output-capture, and evidence structures and blocks user-story work.
- User Story 1 establishes executable behavior evidence and must precede User Story 2 contract enforcement.
- User Story 2 may proceed after Phase 2, but its output assertions depend on the fixture harness from User Story 1.
- User Story 3 depends on the owner-call event model from User Story 1 and the state vocabulary from User Story 2.
- User Story 4 depends on evidence emitted by User Stories 1 through 3.
- Polish follows all user stories and includes generated-artifact regeneration and final suite validation.

## Parallel Execution Examples

### User Story 1

```text
T008 and T009 can run in parallel after T007: readiness-state fixtures and owner-result doubles touch separate sections of the focused test.
```

### User Story 2

```text
T014 and T015 can run in parallel after T013: canonical output fixtures and NFR-state assertions cover separate contract surfaces.
```

### User Story 3

```text
T017 and T018 can run in parallel after T016: matrix scoring and separate-result reporting touch different Feature 034 records.
```

### User Story 4

```text
T020 and T021 can run in parallel after T019: ownership evidence and completion-claim separation use separate records.
```

## Phase 1: Setup

**Purpose**: Confirm the Feature 034 scope and baseline before behavioral changes.

- [X] T001 Confirm Feature 034 paths and the affected Feature 033 artifacts in `specs/034-highway-setup-compliance/plan.md`, `.highway/skills/highway-setup/SKILL.md`, `.highway/tools/tests/highway-setup.test.sh`, and `specs/033-highway-setup/`
- [X] T002 [P] Record the passing pre-change repository suite and focused-test baseline in `specs/034-highway-setup/quickstart.md`

---

## Phase 2: Foundational

**Purpose**: Establish shared fixture and contract structures before story-specific behavior work.

**Checkpoint**: Fixture events, canonical output bytes, routing rows, and ownership evidence formats are defined before implementation tasks begin.

- [X] T003 [P] Define fixture fields, NFR states, routing rows, and evidence invariants in `specs/034-highway-setup-compliance/data-model.md`
- [X] T004 [P] Define tab-significant complete, objective-missing, and pending-NFR output blocks in `specs/034-highway-setup-compliance/contracts/dashboard-output.md`
- [X] T005 [P] Define the 20-row first-time routing matrix and 19/20 scoring rule in `specs/034-highway-setup-compliance/contracts/routing-matrix.md`
- [X] T006 [P] Define the six ownership boundaries and evidence requirements in `specs/034-highway-setup-compliance/contracts/ownership-review.md`
- [X] T007 Add disposable-tree helpers, event logging, output capture, and before/after hash helpers to `.highway/tools/tests/highway-setup.test.sh`

---

## Phase 3: User Story 1 - Verify setup behavior with executable scenarios (Priority: P1) 🎯 MVP

**Goal**: Replace static prose assertions with executable readiness, delegation, continuation, failure-stop, and idempotence fixtures.

**Independent Test**: Run `.highway/tools/tests/highway-setup.test.sh` and verify event order, owner calls, stop behavior, output, and hashes for the named disposable repository states.

### Tests for User Story 1

- [X] T008 [P] [US1] Add failing empty, Profile-only, Profile-plus-Objectives, Profile-plus-Controls, and complete repository fixtures to `.highway/tools/tests/highway-setup.test.sh`
- [X] T009 [P] [US1] Add failing success, declined, failed, malformed, incomplete, and pending owner-result doubles with expected events to `.highway/tools/tests/highway-setup.test.sh`

### Implementation for User Story 1

- [X] T010 [US1] Implement fixture execution that records Profile -> Objectives -> Controls -> NFR readiness events in `.highway/tools/tests/highway-setup.test.sh`
- [X] T011 [US1] Implement exact first-owner-call and downstream-call assertions for successful continuation and blocking outcomes in `.highway/tools/tests/highway-setup.test.sh`
- [X] T012 [US1] Implement repeated complete-state hash and zero-owner-call assertions in `.highway/tools/tests/highway-setup.test.sh`
- [X] T013 [US1] Update the Feature 033 verification section to describe executable scenarios and observed results in `specs/033-highway-setup/quickstart.md`

**Checkpoint**: User Story 1 proves behavior through disposable fixtures rather than source-text presence checks.

---

## Phase 4: User Story 2 - Enforce one canonical status and output contract (Priority: P1)

**Goal**: Resolve NFR state ambiguity and enforce one exact dashboard byte contract.

**Independent Test**: Run output and state fixtures and compare captured output byte-for-byte with `specs/034-highway-setup-compliance/contracts/dashboard-output.md`.

### Tests for User Story 2

- [X] T014 [P] [US2] Add failing byte-for-byte complete, objective-missing, and pending-NFR output comparisons in `.highway/tools/tests/highway-setup.test.sh`
- [X] T015 [P] [US2] Add failing NFR state-transition assertions for Missing, In Progress, Complete, Blocked, and Not Evaluated in `.highway/tools/tests/highway-setup.test.sh`

### Implementation for User Story 2

- [X] T016 [US2] Normalize the NFR state definitions and current-activity guidance in `.highway/skills/highway-setup/SKILL.md`
- [X] T017 [US2] Update the Feature 033 specification to distinguish pre-proposal `Missing` from pending-acceptance `In Progress` in `specs/033-highway-setup/spec.md`
- [X] T018 [US2] Update the Feature 033 setup output and delegation contracts to use the canonical tab-indented dashboard in `specs/033-highway-setup/contracts/setup-output.md` and `specs/033-highway-setup/contracts/owner-delegation.md`
- [X] T019 [US2] Update the generated or source dashboard examples and state references in `.highway/skills/highway-setup/SKILL.md` without adding a second output contract

**Checkpoint**: Complete and in-progress outputs have one byte-significant source contract and the NFR state transition is unambiguous.

---

## Phase 5: User Story 3 - Measure first-time routing coverage (Priority: P1)

**Goal**: Score a defined 20-case routing matrix and report routing coverage independently from suite and requirement coverage.

**Independent Test**: Execute all rows in `specs/034-highway-setup-compliance/contracts/routing-matrix.md` and verify at least 19 rows pass.

### Tests for User Story 3

- [X] T020 [P] [US3] Add failing matrix-row execution and expected first-action assertions to `.highway/tools/tests/highway-setup.test.sh`
- [X] T021 [P] [US3] Add failing numerator, denominator, percentage, and 19/20 threshold assertions to `.highway/tools/tests/highway-setup.test.sh`

### Implementation for User Story 3

- [X] T022 [US3] Implement deterministic routing-matrix scoring and row-level result output in `.highway/tools/tests/highway-setup.test.sh`
- [X] T023 [US3] Record the observed 20-row routing numerator, denominator, percentage, and threshold result in `specs/034-highway-setup-compliance/quickstart.md`
- [X] T024 [US3] Add separate routing-coverage reporting requirements to `specs/034-highway-setup-compliance/contracts/routing-matrix.md`

**Checkpoint**: Routing accuracy has a fixed denominator and is reported separately from general test success.

---

## Phase 6: User Story 4 - Complete ownership and completion evidence (Priority: P2)

**Goal**: Close the manual ownership gap and prevent a full compliance claim when evidence is missing.

**Independent Test**: Review all six ownership boundaries and verify separate automated, routing, requirement, and manual-review results.

### Tests for User Story 4

- [X] T025 [P] [US4] Add ownership-boundary and no-second-store assertions to `.highway/tools/tests/highway-setup.test.sh`
- [X] T026 [P] [US4] Add a completion-report structure check for separate evidence categories in `specs/034-highway-setup-compliance/quickstart.md`

### Implementation for User Story 4

- [X] T027 [US4] Complete O-001 through O-006 with concrete evidence and outcomes in `specs/034-highway-setup-compliance/contracts/ownership-review.md`
- [X] T028 [US4] Create the exact-once FR-001 through FR-012 requirement coverage record in `specs/034-highway-setup-compliance/coverage.md`
- [X] T029 [US4] Add a compliance-claim rule that blocks completion when ownership or executable evidence is unresolved in `specs/034-highway-setup-compliance/quickstart.md`

**Checkpoint**: Feature 034 distinguishes automated checks, routing coverage, requirement coverage, and manual ownership review.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Validate source, generated artifacts, contracts, and the complete repository state.

- [X] T030 [P] Run `.highway/tools/validate-skill.sh .highway/skills/highway-setup` and resolve relevant structural or contract findings in `.highway/skills/highway-setup/SKILL.md`
- [X] T031 Regenerate catalogs, adapter manifests, distribution manifests, and agent adapters with `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`; inspect generated outputs without hand-editing `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, or `.cursor/rules/`
- [X] T032 Run `.highway/tools/tests/highway-setup.test.sh`, `.highway/tools/tests/adapter-coverage.test.sh`, and `.highway/tools/tests/run-all.sh`; record separate results in `specs/034-highway-setup-compliance/quickstart.md`
- [X] T033 Run `git diff --check` and verify shipped-tree independence for `.github/skills/highway-setup/`, `.claude/skills/highway-setup/`, and `.cursor/rules/highway-setup.mdc`
- [X] T034 Review every completed task against its named artifact, confirm no generated file was hand-edited, and record final compliance categories in `specs/034-highway-setup-compliance/quickstart.md`

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; capture the baseline before edits.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational; establishes executable behavior evidence and is the MVP.
- **User Story 2 (Phase 4)**: Depends on User Story 1's fixture harness; can proceed independently from Story 3 after that point.
- **User Story 3 (Phase 5)**: Depends on User Story 1 event logging and User Story 2 state vocabulary.
- **User Story 4 (Phase 6)**: Depends on evidence from User Stories 1-3.
- **Polish (Phase 7)**: Depends on all desired stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational; no other story dependency.
- **User Story 2 (P1)**: Requires the executable fixture harness from User Story 1.
- **User Story 3 (P1)**: Requires event logging from User Story 1 and canonical states from User Story 2.
- **User Story 4 (P2)**: Requires all prior evidence categories.

### Within Each User Story

- Tests marked as failing are written before the corresponding implementation tasks and must be observed failing per D3.6.
- Fixture and contract definitions precede assertions that consume them.
- Behavior assertions precede evidence-record updates.
- No generated artifact is edited directly; generation follows source changes.

## Parallel Opportunities

- T003-T006 can run in parallel because they update separate Feature 034 design/contract files.
- T008-T009, T014-T015, T020-T021, and T025-T026 can run in parallel within their story phases.
- T017 and T018 can run in parallel after T016 because they update separate Feature 033 contract records.
- T023-T024 can run in parallel after T022 because quickstart evidence and contract reporting are separate files.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 baseline capture.
2. Complete Phase 2 fixture and contract foundation.
3. Complete Phase 3 executable readiness and owner-result fixtures.
4. Stop and validate User Story 1 independently with the focused test and full suite.

### Incremental Delivery

1. Add canonical NFR and dashboard semantics with User Story 2.
2. Add the fixed routing matrix and separate score with User Story 3.
3. Complete ownership and completion evidence with User Story 4.
4. Regenerate derived artifacts and run all final validation in Phase 7.

## Notes

- Every task has a checkbox, sequential ID, required story label where applicable, and at least one concrete file path.
- Feature 034 changes Feature 033 only where the new canonical contract resolves an identified ambiguity or missing verification behavior.
- The final completion report must separate suite results, routing coverage, requirement coverage, and manual ownership review.
