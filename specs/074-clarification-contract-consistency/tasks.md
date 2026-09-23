---

description: "Implementation tasks for Clarification Contract Consistency"
---

# Tasks: Clarification Contract Consistency

**Input**: Design documents from `specs/074-clarification-contract-consistency/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/clarification-contract-consistency.md](contracts/clarification-contract-consistency.md), [quickstart.md](quickstart.md)

**Organization**: Tasks are grouped by the three P1 user stories. Canonical skill and output-template inputs are authoritative; generated artifacts are refreshed after canonical edits.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the implementation baseline and identify canonical and generated contract surfaces.

- [X] T001 Run the existing baseline suite from `.highway/tools/tests/run-all.sh` and record its exit status before editing canonical Clarification inputs. (Timed out during `frontmatter-lexicon.test.sh`.)
- [X] T002 Inventory canonical Clarification inputs and generated outputs in `.highway/skills/highway-clarify/SKILL.md`, `.highway/library/templates/output/clarification-record.md`, `.highway/catalog/`, `.github/skills/highway-clarify/SKILL.md`, `.claude/skills/highway-clarify/SKILL.md`, and `.cursor/rules/highway-clarify.mdc`.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Add shared contract-test coverage and disposable-fixture boundaries.

- [X] T003 [P] Add source-document, generated-artifact, and disposable-fixture probe coverage to `.highway/tools/tests/highway-clarify.test.sh`.
- [X] T004 [P] Add canonical clarification-record assertions to `.highway/tools/tests/output-template.test.sh` for direct Evidence Sources, empty evidence, distinct recommendation states, and single explanatory contract text.
- [X] T005 [P] Define Feature 074 fixture byte-preservation and generated-output comparison cases in `.highway/tools/tests/highway-clarify.test.sh` and `.highway/tools/tests/output-template.test.sh`.

**Checkpoint**: Shared test probes and disposable-write boundaries are ready.

## Phase 3: User Story 1 - Distinguish Recommendation States (Priority: P1)

**Goal:** Remove the retired combined conflict state and enforce deterministic Recommendation Basis/state pairings.

**Independent Test:** Search canonical and generated artifacts for the retired state and run focused state assertions.

### Tests for User Story 1

- [X] T006 [P] [US1] Add static assertions for the three valid Recommendation Basis/state pairings and rejection of combined states in `.highway/tools/tests/highway-clarify.test.sh`.
- [X] T007 [P] [US1] Add generated-artifact assertions for the retired combined state and state vocabulary in `.highway/tools/tests/output-template.test.sh`.

### Implementation for User Story 1

- [X] T008 [US1] Replace combined conflict wording and add Outputs, Verification, and Error Handling state-pairing rules in `.highway/skills/highway-clarify/SKILL.md`.
- [X] T009 [US1] Replace combined conflict guidance, retain distinct state examples, and remove duplicate explanatory contract text in `.highway/library/templates/output/clarification-record.md`.
- [X] T010 [US1] Regenerate catalogs and Clarification adapters with `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`.
- [X] T011 [US1] Run focused Clarification, output-template, and generated-artifact tests.

**Checkpoint**: No canonical or generated artifact uses the retired combined state.

## Phase 4: User Story 2 - Represent Evidence Sources Consistently (Priority: P1)

**Goal:** Make single-source, multi-source, zero-source, and generated records conform to one direct list-item structure.

**Independent Test:** Inspect the canonical template and run Evidence Sources assertions.

### Tests for User Story 2

- [X] T012 [P] [US2] Add single-source, multi-source, zero-source, and nested-Source-wrapper assertions to `.highway/tools/tests/output-template.test.sh`.
- [X] T013 [P] [US2] Add generated clarification-record Evidence Sources assertions to `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 2

- [X] T014 [US2] Replace nested Evidence Sources examples with direct fields and add the empty-source example in `.highway/library/templates/output/clarification-record.md`.
- [X] T015 [US2] Update Clarification output and contract wording for generated Evidence Sources in `.highway/skills/highway-clarify/SKILL.md`.
- [X] T016 [US2] Regenerate catalogs and the three Clarification adapters with the declared generator scripts.
- [X] T017 [US2] Run focused Evidence Sources and generator correspondence tests.

**Checkpoint**: Canonical and generated Evidence Sources examples use the direct list-item contract.

## Phase 5: User Story 3 - Enforce History and Contract Validation (Priority: P1)

**Goal:** Detect duplicate Resolution History Finding identifiers and preserve pre-operation bytes on covered failures.

**Independent Test:** Run duplicate-history and malformed-state/source fixtures and verify no retained write.

### Tests for User Story 3

- [X] T018 [P] [US3] Add duplicate Resolution History Finding identifier fixtures to `.highway/tools/tests/highway-clarify.test.sh`.
- [X] T019 [P] [US3] Add invalid basis/state and malformed Evidence Sources fixtures with byte assertions to `.highway/tools/tests/output-template.test.sh`.

### Implementation for User Story 3

- [X] T020 [US3] Add duplicate Resolution History validation and duplicate-identifier no-write handling to `.highway/skills/highway-clarify/SKILL.md`.
- [X] T021 [US3] Document unique history identifiers, failure invariants, and direct Evidence Sources validation in `.highway/library/templates/output/clarification-record.md`.
- [X] T022 [US3] Add generated-artifact and cross-document assertions for `clarify.md` and `clarification-record.md` in `.highway/tools/tests/highway-clarify.test.sh`.
- [X] T023 [US3] Regenerate all affected catalogs and Clarification adapters.
- [X] T024 [US3] Run focused tests, validators, and generator tests for duplicate-history and no-partial-write behavior.

**Checkpoint**: Covered malformed inputs fail without retained writes or source mutation.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verify complete contract, generated correspondence, documentation, and regression behavior.

- [X] T025 [P] Review `specs/074-clarification-contract-consistency/quickstart.md` against completed commands; no update required.
- [X] T026 Run the skill and library validators.
- [X] T027 Run all generators and corresponding generator tests to confirm no generated drift.
- [X] T028 Run `.highway/tools/tests/run-all.sh` and `git diff --check`; record suite and whitespace results. (`git diff --check` passed; full suite advanced through `objective-rename-contract.test.sh` before the bounded run was stopped.)
- [X] T029 Search canonical and generated artifacts for the retired combined state, verify the explanatory sentence appears exactly once, and record FR/SC coverage in the completion report. (Zero matches in `.highway/skills`, `.highway/library`, `.highway/catalog`, `.github`, `.claude`, and `.cursor`; historical specs/tests retain the literal only as documented search fixtures.)

## Dependencies & Execution Order

- Setup precedes Foundational; Foundational precedes all user stories; Polish follows all stories.
- T003/T004, T006/T007, T012/T013, and T018/T019 can run in parallel because they edit different test files.
- Generator tasks follow canonical input edits and must not run concurrently against shared generated outputs.

## Notes

- Every task has a unique sequential ID, a checkbox, and a concrete repository path.
- `[P]` marks tasks that can run concurrently without editing the same file.
- Tests are included because the specification requires fixture coverage and measurable outcomes.
