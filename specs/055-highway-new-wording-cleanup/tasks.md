# Tasks: Highway New Wording Cleanup

**Input**: Design documents from `specs/055-highway-new-wording-cleanup/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Required by FR-008 and the repository's TDD workflow. Add focused assertions before implementing wording changes and observe them fail.

**Organization**: Tasks are grouped by user story so the single P1 story can be implemented and validated independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the Feature 055 scope and current Feature 054 baseline.

- [X] T001 Review `specs/055-highway-new-wording-cleanup/spec.md`, `plan.md`, `research.md`, `data-model.md`, both contract files, and `quickstart.md` to confirm the four wording corrections and unchanged durable-state boundaries.
- [X] T002 [P] Inspect `.highway/skills/highway-new/SKILL.md`, `.highway/tools/tests/highway-new.test.sh`, `.highway/tools/tests/output-template.test.sh`, and the generated adapters to locate current duplicate or legacy wording.
- [X] T003 [P] Run `.highway/tools/tests/highway-new.test.sh`, `.highway/tools/tests/output-template.test.sh`, `.highway/tools/validate-skill.sh .highway/skills/highway-new`, and `.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md` to record the pre-change baseline.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the exact wording and state vocabulary before changing the authoritative skill.

- [X] T004 Confirm the `allowed_solution_classes` exception, other list-shaped field states, `No business constraints` boundary, and durable-state invariants against `specs/055-highway-new-wording-cleanup/data-model.md` and `contracts/durable-state-contract.md`.
- [X] T005 [P] Define focused assertion vocabulary for duplicate cardinality, duplicate field-error wording, legacy `None known` wording, the explicit list-field exception, and `No business constraints` in `.highway/tools/tests/highway-new.test.sh`.
- [X] T006 [P] Add shared-template regression assertions for unchanged durable empty-state representation and distinct `unknown` handling in `.highway/tools/tests/output-template.test.sh`.

**Checkpoint**: The focused tests express all four requested corrections and fail for the current wording without changing the durable record contract.

## Phase 3: User Story 1 - Present Precise Solution Constraints Guidance (Priority: P1) 🎯 MVP

**Goal**: Make `highway-new` wording concise and unambiguous while preserving existing Request states and ownership boundaries.

**Independent Test**: Run the focused skill/template assertions and validators, then inspect the authoritative skill to confirm one consolidated allowed-class rule, the explicit exception for other list-shaped fields, one concise field-error rule, and `No business constraints` wording.

### Tests for User Story 1

- [X] T007 [P] [US1] Add failing assertions for the consolidated `allowed_solution_classes` rule and absence of duplicate cardinality wording in `.highway/tools/tests/highway-new.test.sh`.
- [X] T008 [P] [US1] Add failing assertions for the populated-list/empty-array/`unknown` rule excluding `allowed_solution_classes` in `.highway/tools/tests/highway-new.test.sh`.
- [X] T009 [P] [US1] Add failing assertions for the concise Solution Constraints field-error sentence and absence of the duplicated error clause in `.highway/tools/tests/highway-new.test.sh`.
- [X] T010 [P] [US1] Add failing assertions for `No business constraints`, rejection of legacy `None known`, and preservation of `unknown` distinction in `.highway/tools/tests/highway-new.test.sh` and `.highway/tools/tests/output-template.test.sh`.

### Implementation for User Story 1

- [X] T011 [US1] Replace the duplicate `allowed_solution_classes` statements with one consolidated rule in `.highway/skills/highway-new/SKILL.md`.
- [X] T012 [US1] Replace the general Solution Constraints recording sentence with the exception-first list-state rule in `.highway/skills/highway-new/SKILL.md`.
- [X] T013 [US1] Collapse the duplicated Solution Constraints field-error wording into one concise rule in `.highway/skills/highway-new/SKILL.md`.
- [X] T014 [US1] Replace requester-facing `None known` wording with `No business constraints` in `.highway/skills/highway-new/SKILL.md` while preserving the existing durable empty-state and `unknown` rules.
- [X] T015 [US1] Align `specs/055-highway-new-wording-cleanup/data-model.md`, `contracts/wording-contract.md`, and `contracts/durable-state-contract.md` with the final authoritative wording and state vocabulary.
- [X] T016 [US1] Run `.highway/tools/tests/highway-new.test.sh`, `.highway/tools/tests/output-template.test.sh`, `.highway/tools/validate-skill.sh .highway/skills/highway-new`, and `.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md` to verify the story independently.

**Checkpoint**: User Story 1 is complete when all four wording corrections pass focused assertions and no durable-state, field-order, Discovery, or ADR behavior changes are detected.

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate derived artifacts and validate repository-wide correspondence and packaging.

- [X] T017 [P] Regenerate `.highway/catalog/index.json` and `.highway/catalog/index.md` with `.highway/tools/generate-catalog.sh` after `.highway/skills/highway-new/SKILL.md` is valid.
- [X] T018 [P] Regenerate `.github/skills/highway-new/SKILL.md`, `.claude/skills/highway-new/SKILL.md`, and `.cursor/rules/highway-new.mdc` with `.highway/tools/generate-agent-adapters.sh` after authoritative source changes.
- [X] T019 [P] Run `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/shipped-tree-independence.test.sh`, and `.highway/tools/tests/distribution-packaging.test.sh` to verify generated correspondence and shipped-tree independence.
- [ ] T020 Run `.highway/tools/tests/run-all.sh` and record the complete result, including any baseline diagnostics or timeout, without claiming success from a partial run.
- [X] T021 Review the final diff against `specs/055-highway-new-wording-cleanup/spec.md`, `data-model.md`, both contracts, and `quickstart.md`; confirm no Discovery or ADR implementation files changed and run `git diff --check`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T002 and T003 can run in parallel after T001.
- **Foundational (Phase 2)**: Depends on Setup; T005 and T006 can run in parallel, then the assertion vocabulary must be ready before story implementation.
- **User Story 1 (Phase 3)**: Depends on Foundational; T007-T010 precede T011-T015, then T016 is the story gate.
- **Polish (Phase 4)**: Depends on the User Story 1 checkpoint; T017-T019 can run in parallel after source changes stabilize, then T020-T021 run in order.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on another story after Foundational; it is the complete MVP and owns all four wording corrections.

### Within the User Story

- Tests MUST be added and observed failing before implementation tasks are marked complete.
- The authoritative skill changes precede contract alignment and focused validation.
- Generated outputs are regenerated only after the authoritative source is valid.
- The story checkpoint must pass before broadening to distribution and full-suite validation.

### Parallel Opportunities

- T002 and T003 can run in parallel after T001 because they are read-only baseline checks.
- T005 and T006 can run in parallel because they touch separate test surfaces.
- T007-T010 can be developed in parallel as separate assertion groups, subject to coordination in the shared test files.
- T017-T019 can run in parallel after the source and contract changes stabilize.

## Parallel Example: User Story 1

```text
Task T007: Add consolidated allowed_solution_classes assertions in .highway/tools/tests/highway-new.test.sh
Task T008: Add list-field exception assertions in .highway/tools/tests/highway-new.test.sh
Task T009: Add concise field-error assertions in .highway/tools/tests/highway-new.test.sh
Task T010: Add Business Constraints wording assertions in .highway/tools/tests/highway-new.test.sh and .highway/tools/tests/output-template.test.sh
```

These assertion groups are logically separable but share test files and must be coordinated before implementation begins.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Add and observe the four groups of failing wording assertions.
3. Update the authoritative `highway-new` skill and design contracts.
4. Run the User Story 1 focused validation gate.
5. Stop for MVP review before regenerating distribution artifacts.

### Incremental Delivery

1. Complete Setup + Foundational and record the baseline.
2. Deliver User Story 1 and validate all four wording corrections independently.
3. Regenerate catalog and adapters.
4. Run correspondence, packaging, and full-suite validation.
5. Complete the final diff and scope audit.

## Notes

- `[P]` marks tasks that can proceed independently without depending on incomplete work in another file.
- Every user-story task includes the `[US1]` label and an exact repository path.
- Generated adapters and catalogs are outputs, not hand-edited implementation surfaces.
- Discovery and ADR remain out of scope.
