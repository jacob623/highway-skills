---

description: "Task list template for feature implementation"
---

# Tasks: Experience Rule Table Alignment

**Input**: Design documents from `/specs/080-experience-rule-table-alignment/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Focused validation tasks are included because FR-013 explicitly requires detection of missing, duplicate, malformed, or misplaced rows and verification of the new definitions and N/A example structure.

**Organization**: Tasks are grouped by user story. The stories share the same authoritative document and focused test file, so implementation proceeds in priority order.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the repository state and authoritative paths before editing.

- [X] T001 Run the existing focused governance checks and record their baseline results with `bash .highway/tools/tests/rule-checks.test.sh`, `bash .highway/tools/tests/coverage-summary.test.sh`, and `.highway/tools/tests/run-all.sh`
- [X] T002 Confirm Feature 079's approved X2 wording, tiers, samples, N5 condition, and current X2/example locations in `.highway/governance/experience-standard.md` and preserve `.highway/tools/.distribution-manifest`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the validation approach shared by all user stories.

- [X] T003 Add Bash 3.2-compatible document-contract test helpers and fixture strategy in `.highway/tools/tests/rule-checks.test.sh` without weakening existing assertions
- [X] T004 Define the Feature 080 validation contract in `.highway/tools/tests/rule-checks.test.sh` for exact X2 table rows, definitions, N/A example structure, and permitted PASS/FAIL/N/A vocabulary

**Checkpoint**: Shared validation conventions and baseline evidence are ready; story work can proceed in priority order.

## Phase 3: User Story 1 - Reviewers Can Parse Every X2 Rule Consistently (Priority: P1) 🎯 MVP

**Goal**: Represent X2.1-X2.6 exactly once as ordinary rows under one X2 table while preserving the approved X2.2-X2.6 wording, observables, tiers, and samples.

**Independent Test**: The focused check must fail when an X2.2-X2.6 row is missing, duplicated, malformed, or outside the X2 table, and pass when all six rows have ID, Rule, Observable, Tier, and Sample fields.

### Tests for User Story 1

- [X] T005 [US1] Add failing assertions for one-table X2.1-X2.6 uniqueness, five-field row shape, `[agent-checkable]` tiers, and Feature 079 wording/samples in `.highway/tools/tests/rule-checks.test.sh`

### Implementation for User Story 1

- [X] T006 [US1] Move X2.2-X2.6 into the existing X2 table and remove duplicate normative inline definitions while preserving X2.1 and Feature 079 content in `.highway/governance/experience-standard.md`
- [X] T007 [US1] Run `bash .highway/tools/tests/rule-checks.test.sh` and verify the User Story 1 assertions pass against `.highway/governance/experience-standard.md`

**Checkpoint**: User Story 1 is independently reviewable as a normalized X2 table and its focused checks pass.

## Phase 4: User Story 2 - Applicability Terms Are Defined (Priority: P1)

**Goal**: Define Guided information-collection workflow and Implementation details, then align X2.3/X2.4 Observables without changing their approved obligations.

**Independent Test**: The focused check must verify one exact definition for each term, consistent X2.3/X2.4 terminology, preservation of the Interactive Workflow distinction, and permission for requested implementation explanations.

### Tests for User Story 2

- [X] T008 [US2] Add failing assertions for the Guided information-collection workflow and Implementation details definitions plus X2.3/X2.4 terminology consistency in `.highway/tools/tests/rule-checks.test.sh`

### Implementation for User Story 2

- [X] T009 [US2] Add the two required definitions and update the X2.3/X2.4 Observables consistently in `.highway/governance/experience-standard.md` without broadening or narrowing Feature 079 obligations
- [X] T010 [US2] Run `bash .highway/tools/tests/rule-checks.test.sh` and verify the User Story 2 assertions pass, including the Interactive-versus-guided distinction and requested implementation-details exception

**Checkpoint**: User Stories 1 and 2 are independently reviewable with explicit applicability terminology.

## Phase 5: User Story 3 - N/A Outcomes Are Reported Without Mislabeling (Priority: P2)

**Goal**: Separate the no-long-running-activity case into a Scenario/Example table while retaining applicable compliant and non-compliant examples and recording both N5 outcomes.

**Independent Test**: The focused checks must verify a read-only status scenario with no intermediate activity, `X2.5=N5`, `X2.6=N5`, a distinct Example field, and no N/A placement under compliant/non-compliant headings or new verdict token.

### Tests for User Story 3

- [X] T011 [US3] Add failing assertions for the N/A Scenario/Example table, read-only no-intermediate-activity wording, `X2.5=N5`, `X2.6=N5`, and unchanged verdict vocabulary in `.highway/tools/tests/rule-checks.test.sh` and `.highway/tools/tests/coverage-summary.test.sh`

### Implementation for User Story 3

- [X] T012 [US3] Restructure the interaction examples in `.highway/governance/experience-standard.md` into applicable compliant/non-compliant examples plus a separate N/A Scenario/Example table
- [X] T013 [US3] Run `bash .highway/tools/tests/rule-checks.test.sh` and `bash .highway/tools/tests/coverage-summary.test.sh`, confirming the N/A example records both N5 outcomes without introducing a verdict, rule ID, or condition token

**Checkpoint**: All three user stories are implemented and independently validated by focused governance checks.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Complete governance provenance, regression validation, and final artifact review.

- [X] T014 Update the sync impact record and version according to the Experience Standard versioning policy in `.highway/governance/experience-standard.md`, naming the changed X2 table, definitions, Observables, rationale, and example structure
- [X] T015 Run `.highway/tools/tests/run-all.sh`, `git diff --check`, and the manual checks in `specs/080-experience-rule-table-alignment/quickstart.md`; preserve `.highway/tools/.distribution-manifest` and record any pre-existing catalog-drift failure without modifying unrelated generated artifacts

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes baseline and preservation boundaries.
- **Foundational (Phase 2)**: Depends on Setup; blocks story implementation because all stories use the shared focused validation surface.
- **User Story 1 (Phase 3)**: Depends on Phase 2 and is the MVP foundation for the normalized X2 table.
- **User Story 2 (Phase 4)**: Depends on User Story 1 because it updates the same X2 table's Observables and definitions.
- **User Story 3 (Phase 5)**: Depends on User Story 2 because it updates the same interaction examples and shares verdict/N5 assertions.
- **Polish (Phase 6)**: Depends on all desired user stories and includes final versioning and regression validation.

### User Story Dependencies

- **User Story 1 (P1)**: Depends only on Foundational Phase 2; delivers the MVP.
- **User Story 2 (P1)**: Depends on User Story 1's normalized X2 table; no external dependencies.
- **User Story 3 (P2)**: Depends on User Story 2's terminology and shared validation contract; no external dependencies.

### Parallel Opportunities

- T001 and T002 can run in parallel because they are read-only baseline and preservation checks.
- No story implementation tasks are marked parallel because US1-US3 intentionally edit shared files.
- After each story's focused test task is complete, its validation task can run independently before the next story begins.
- During final review, `git diff --check` and the manifest-preservation check can run in parallel with manual quickstart inspection.

## Parallel Example: Setup

```text
Task: "Run the baseline focused/full checks in T001"
Task: "Confirm Feature 079 source values and manifest preservation in T002"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 baseline and preservation checks.
2. Complete Phase 2 shared validation setup.
3. Add failing US1 row-contract assertions, then normalize the X2 table.
4. Run the US1 focused check and stop for an independently reviewable MVP.

### Incremental Delivery

1. Add US2 definitions and aligned Observables, then run its focused checks.
2. Add US3 N/A example restructuring and N5 checks, then run both focused checks.
3. Update the Experience Standard provenance/version record.
4. Run the full suite and quickstart validation; do not alter unrelated catalog artifacts solely to hide the known baseline drift.

## Notes

- Every task uses the required `- [ ] T###` checklist form; story-phase tasks carry `[US1]`, `[US2]`, or `[US3]` labels.
- `[P]` is used only for independent read-only setup work; shared-file edits remain sequential.
- Tests should be observed failing for their targeted defect before implementation makes them pass, per D3.6.
- The full suite's known pre-existing catalog drift is a validation blocker to record, not a Feature 080 scope expansion.
