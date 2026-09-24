---

 description: "Task list for seeding Highway context documents into the knowledge library"
---

# Tasks: Seed Library Context Documents

**Input**: Design documents from `specs/087-seed-library-context/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Project type**: Repository Markdown files and Bash 3.2-compatible validation suite; no application framework, persistence layer, or external contract

## Phase 1: Setup

**Purpose**: Confirm the source set and existing validation baseline before implementation.

- [X] T001 Verify `highway-identity.md`, `highway-platform-objectives.md`, and `highway-vision.md` exist at the repository root and record the passing baseline with `.highway/tools/tests/run-all.sh`
- [X] T002 [P] Verify `.highway/library/knowledge/` exists and record the pre-existing filenames in `.highway/library/knowledge/` without modifying them

## Phase 2: Foundational

**Purpose**: Establish the focused test harness and deterministic temporary-fixture strategy before the copy behavior is implemented.

- [X] T003 [P] Define the source-to-destination mapping and temporary-fixture cleanup helpers in `.highway/tools/tests/seed-library-context.test.sh`
- [X] T004 Add failing probes for missing-source handling, conflicting-destination convergence, and unrelated-file preservation in `.highway/tools/tests/seed-library-context.test.sh`

**Checkpoint**: The focused test structure and seeded failure probes are ready before the implementation copy is marked complete.

## Phase 3: User Story 1 - Seed foundational Highway context in the knowledge library (Priority: P1) 🎯 MVP

**Goal**: Preserve the three root seed documents and create exact same-named copies under `.highway/library/knowledge/`.

**Independent Test**: Run `bash .highway/tools/tests/seed-library-context.test.sh`; confirm all three destinations exist, compare byte-for-byte with their sources, source bytes remain unchanged, missing sources fail clearly, conflicting destinations converge, and unrelated knowledge files remain unchanged.

### Tests for User Story 1

- [X] T005 [US1] Run `.highway/tools/tests/seed-library-context.test.sh` against the seeded source set and capture the expected pre-implementation failure in the test report

### Implementation for User Story 1

- [X] T006 [US1] Copy `highway-identity.md`, `highway-platform-objectives.md`, and `highway-vision.md` to their same-named destinations under `.highway/library/knowledge/` without transforming file bytes
- [X] T007 [US1] Add byte-for-byte destination comparisons, source-preservation checks, and exact destination existence assertions to `.highway/tools/tests/seed-library-context.test.sh`
- [X] T008 [US1] Add preflight and convergence behavior so missing root sources fail before complete success and differing destinations are replaced with exact source bytes in `.highway/tools/tests/seed-library-context.test.sh`
- [X] T009 [US1] Exclude the three opaque context filenames from `.highway/tools/generate-library-catalog.sh` without weakening validation for other knowledge files
- [X] T010 [US1] Run `bash .highway/tools/tests/seed-library-context.test.sh` and verify all Feature 087 acceptance scenarios pass without deleting the root source files

**Checkpoint**: User Story 1 is independently complete and the three library copies are verified byte-for-byte.

## Phase 4: Polish and Cross-Cutting Validation

**Purpose**: Validate the complete feature against its design artifacts and repository-wide constraints.

- [X] T011 [P] Classify the three temporary root sources in `.highway/tools/.distribution-manifest` and run the focused packaging test
- [X] T012 [P] Run the manual `cmp -s` checks from `specs/087-seed-library-context/quickstart.md` for all three source/destination pairs
- [X] T013 Run `.highway/tools/tests/run-all.sh` and record the final suite result separately from the focused copy-test result
- [X] T014 Verify `specs/087-seed-library-context/spec.md`, `plan.md`, `research.md`, `data-model.md`, `quickstart.md`, and `tasks.md` remain consistent with the implemented destination `.highway/library/knowledge/`

## Dependencies and Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the source and repository baseline.
- **Foundational (Phase 2)**: Depends on Setup; establishes the focused test and failure probes.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the complete MVP copy and verification behavior.
- **Polish (Phase 4)**: Depends on User Story 1; performs focused, manual, and full-suite validation.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on another user story; it is the only story and the complete MVP.

### Parallel Opportunities

- T002 can run in parallel with T001 because it only inspects the destination directory.
- T003 can run in parallel with T002 after the source mapping is confirmed because it creates the independent focused-test scaffold.
- T010 can run in parallel with T011 after T009 passes because the manual comparisons and full suite are independent validations.

## Parallel Example: User Story 1

```text
Task: "Verify .highway/library/knowledge/ contents in T002"
Task: "Define the focused test mapping and fixture cleanup helpers in .highway/tools/tests/seed-library-context.test.sh in T003"
```

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Implement User Story 1 through T009.
3. Stop and validate the three byte-identical knowledge copies independently.

### Incremental Delivery

1. Establish the source/destination test contract and failure probes.
2. Add the three exact library copies and verification behavior.
3. Run focused validation, manual comparisons, and the full repository suite.
4. Leave deletion of the root source files to the maintainer as a separate manual action.

## Notes

- Every task names an exact repository path or command.
- No `contracts/` tasks are needed because the feature has no external interface.
- The focused test must remain compatible with Bash 3.2.57 and must clean up all temporary fixtures.
- Root source files must not be deleted by implementation tasks.
