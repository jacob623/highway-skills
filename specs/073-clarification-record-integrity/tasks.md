# Tasks: Clarification Record Integrity

**Input**: Design documents from `specs/073-clarification-record-integrity/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/clarification-record-integrity.md`, and `quickstart.md`

**Tests**: Included because the specification requires executable verification of history identity, frontmatter structure, evidence traceability, recommendation basis/state mapping, lifecycle behavior, immutability, and no-partial-write behavior.

**Organization**: Tasks are grouped by the three P1 user stories. The stories share the canonical template and focused contract tests, so implementation proceeds in dependency order while each story retains an independent acceptance checkpoint.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the Feature 073 validation baseline and identify the canonical and derived contract surfaces.

- [X] T001 Record the baseline for `.highway/library/templates/output/clarification-record.md`, `.highway/tools/tests/highway-clarify.test.sh`, `.highway/tools/tests/output-template.test.sh`, and the generated Clarification adapters before changing Feature 073.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Prepare disposable fixtures and reusable assertions for all three stories.

- [X] T002 [P] Inventory the canonical template, dependent `highway-clarify` skill, generated adapters, catalogs, and focused test paths in `.highway/library/templates/output/clarification-record.md`, `.highway/skills/highway-clarify/SKILL.md`, `.github/skills/highway-clarify/SKILL.md`, `.claude/skills/highway-clarify/SKILL.md`, `.cursor/rules/highway-clarify.mdc`, and `.highway/tools/tests/`.
- [X] T003 [P] Add disposable fixture helpers and reusable assertions for frontmatter delimiters, section boundaries, unique history identifiers, evidence-source shape, basis/state mapping, lifecycle, source immutability, and no-partial-write behavior in `.highway/tools/tests/highway-clarify.test.sh` and `.highway/tools/tests/output-template.test.sh`.

**Checkpoint**: Canonical paths and isolated assertions are ready; user-story work can proceed without mutating user-owned records.

## Phase 3: User Story 1 - Trace Resolution History to Findings (Priority: P1)

**Goal**: Make every retained Resolution History entry traceable to exactly one stable finding.

**Independent Test**: Generate representative records with open and resolved findings, then verify each history list item contains Finding, Response, Revision, and Actor and references one unique finding in the same record.

### Tests for User Story 1

- [X] T004 [US1] Add focused probes for required history fields, stable `CLAR-<ARTIFACT-ID>-NNN` references, missing finding references, unknown finding references, and duplicate history references in `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 1

- [X] T005 [US1] Update Resolution History examples to use separate list items with Finding, Response, Revision, and Actor fields and stable finding references in `.highway/library/templates/output/clarification-record.md`.
- [X] T006 [US1] Document history-to-finding identity, uniqueness, and no-partial-write validation in `.highway/skills/highway-clarify/SKILL.md` and the explanatory contract section of `.highway/library/templates/output/clarification-record.md`.
- [X] T007 [US1] Run `.highway/tools/tests/highway-clarify.test.sh` and `.highway/tools/tests/output-template.test.sh`, repairing only User Story 1 defects.

**Checkpoint**: User Story 1 is independently testable as traceable, uniquely identified resolution history.

## Phase 4: User Story 2 - Read a Valid, Unambiguous Record Template (Priority: P1)

**Goal**: Restore valid frontmatter and keep retained record data separate from explanatory contract rules.

**Independent Test**: Parse the File Frontmatter example, inspect representative findings, and verify delimiters, exactly-once metadata, normalized fingerprint alignment, placeholder escalation ownership, and section boundaries.

### Tests for User Story 2

- [X] T008 [US2] Add focused probes for complete frontmatter delimiters, exactly-once metadata fields, canonical fingerprint indentation, placeholder `Escalation Owner: <owner>`, and rejection of explanatory prose inside retained sections in `.highway/tools/tests/output-template.test.sh`.

### Implementation for User Story 2

- [X] T009 [US2] Correct the File Frontmatter example, fingerprint field alignment, escalation-owner placeholder, and retained-section boundaries in `.highway/library/templates/output/clarification-record.md`.
- [X] T010 [US2] Define the retained-data versus explanatory-contract boundary and malformed-record no-partial-write behavior in `.highway/skills/highway-clarify/SKILL.md`.
- [X] T011 [US2] Run `.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md`, `.highway/tools/validate-skill.sh .highway/skills/highway-clarify`, and both focused tests, repairing only User Story 2 defects.

**Checkpoint**: User Stories 1 and 2 are independently testable as traceable history and structurally valid retained records.

## Phase 5: User Story 3 - Interpret Recommendation Evidence and Option Lifecycle (Priority: P1)

**Goal**: Make evidence traceability, recommendation basis/state, and advisory option lifecycle explicit.

**Independent Test**: Inspect single-source, multi-source, absent-evidence, conflict, and option-selection examples and verify deterministic basis/state mappings and response-authoritative lifecycle behavior across REQ, DISC, ADR, and RA.

### Tests for User Story 3

- [X] T012 [US3] Add focused probes for zero/one/multiple Evidence Sources, Source Type/Identifier/Reason Used fields, `Recommendation Basis`, distinct `Unknown` and `Escalate for Decision` states, Recommended Option storage, option selection, response acceptance, and resolved-state immutability in `.highway/tools/tests/highway-clarify.test.sh`.
- [X] T013 [P] [US3] Add representative REQ, DISC, ADR, and RA fixtures for basis/state, evidence, lifecycle, advisory ownership, and no-partial-write coverage in the disposable test workspace used by `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 3

- [X] T014 [US3] Normalize multi-source Evidence Sources entries, add Recommendation Basis fields, and add authoritative, evidence-gap, conflict, and option-selection examples to `.highway/library/templates/output/clarification-record.md`.
- [X] T015 [US3] Document the basis/state mapping, Recommended Option state storage, four-step Option Selection Lifecycle, advisory ownership, and preserved Feature 072 boundaries in `.highway/skills/highway-clarify/SKILL.md`.
- [X] T016 [US3] Run `.highway/tools/tests/highway-clarify.test.sh` and repair only User Story 3 evidence, recommendation, lifecycle, and ownership defects.

**Checkpoint**: All three P1 stories are independently testable and preserve Clarification's advisory decision boundary.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Synchronize derived artifacts and complete cross-contract validation.

- [X] T017 [P] Regenerate catalogs and all declared agent adapters with `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh` after canonical template and skill changes.
- [X] T018 [P] Revalidate `.highway/skills/highway-clarify`, the shared clarification-record template, every generated Clarification adapter, and the focused output-template contract under D8.1.
- [X] T019 Run the complete validation in `specs/073-clarification-record-integrity/quickstart.md`, including `.highway/tools/tests/run-all.sh` and `git diff --check`, and report suite results separately from Feature 073 requirement coverage.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 has no implementation dependency.
- **Foundational (Phase 2)**: T002 and T003 depend on T001 and may run in parallel.
- **User Story 1 (Phase 3)**: T004 follows T002/T003; T005/T006 follow the failing probes; T007 completes the history checkpoint.
- **User Story 2 (Phase 4)**: T008 follows Story 1; T009/T010 follow the failing probes; T011 completes the structure checkpoint.
- **User Story 3 (Phase 5)**: T012/T013 follow Story 2; T014/T015 follow the probes; T016 completes the recommendation checkpoint.
- **Polish (Phase 6)**: T017 and T018 follow all implementation stories and may run in parallel; T019 follows both.

### User Story Dependencies

- **User Story 1 (P1)**: Depends only on foundational tasks and delivers traceable history.
- **User Story 2 (P1)**: Depends on Story 1 because it extends the same retained record and validation surface.
- **User Story 3 (P1)**: Depends on Stories 1 and 2 because evidence and lifecycle examples must remain inside the valid record structure.

### Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- T013 can run in parallel with review of the canonical example, provided it only changes disposable fixture logic.
- T017 and T018 can run in parallel after Stories 1-3; T019 must wait for both.

## Parallel Example: Foundational Work

```text
Task: "Inventory Feature 073 canonical, generated, and focused-test surfaces"
Task: "Add disposable Feature 073 assertions for history, structure, evidence, and lifecycle"
```

## Parallel Example: Final Cross-Cutting Work

```text
Task: "Regenerate catalogs and agent adapters from canonical inputs"
Task: "Revalidate the Clarification template, skill, adapters, and dependent contract checks"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete T001-T003.
2. Complete T004-T007.
3. Validate unique Resolution History finding references and no-partial-write behavior independently.

### Incremental Delivery

1. Add Story 1 for traceable Resolution History.
2. Add Story 2 for valid frontmatter and retained-data boundaries.
3. Add Story 3 for evidence, recommendation basis/state, and option lifecycle.
4. Regenerate derived artifacts and run all cross-cutting checks.

### Completion Criteria

- All 19 tasks use the required checkbox, sequential ID, optional `[P]` marker, story label where required, and exact file path format.
- Every user story has an independent test criterion and focused test tasks before implementation tasks.
- Every contract and data-model decision maps to at least one implementation or validation task.
- Final suite results and Feature 073 requirement coverage are reported as separate claims.
