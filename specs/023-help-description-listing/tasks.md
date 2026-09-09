# Tasks: Help Description Listing

**Input**: Design documents from [specs/023-help-description-listing/](.)

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [quickstart.md](quickstart.md)

**Tests**: Focused shell contract tests are required because the change is behavioral and D3.3 requires test coverage for behavioral changes.

## Phase 1: Setup

**Purpose**: Establish the current baseline and confirm the generated source/artifact boundary.

- [X] T001 [P] Run the pre-change baseline suite with `.highway/tools/tests/run-all.sh` and record the result before editing the source contract.
- [X] T002 [P] Confirm the authoritative source and generated paths in `.highway/skills/highway-help/SKILL.md`, `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` before making changes.

---

## Phase 2: Foundational

**Purpose**: Add regression checks that fail against the current All-Skills contract and protect the unchanged named-skill contract.

- [X] T003 [P] Add the All-Skills contract regression test in `.highway/tools/tests/help-output-all.test.sh` to assert `Description:` blocks, no All-Skills `Usage:` labels, catalog order, one block per entry, and copyable help commands for FR-001 through FR-003.
- [X] T004 [P] Add the Single-Skill compatibility regression test in `.highway/tools/tests/help-output-single.test.sh` to assert the existing six-field order, `Usage:` preservation, empty-catalog response, and unknown-identifier error for FR-004 and FR-005.
- [X] T005 Run `.highway/tools/tests/help-output-all.test.sh` and `.highway/tools/tests/help-output-single.test.sh` before implementation and record that the new All-Skills expectation fails against the current source contract, satisfying the D3.6 precondition.

**Checkpoint**: Focused tests exist, cover both P1 stories, and the changed behavior is observed failing before implementation.

---

## Phase 3: User Story 1 - Discover Skill Descriptions (Priority: P1) 🎯 MVP

**Goal**: Make no-argument `highway-help` list each catalog entry with its description instead of its usage text.

**Independent Test**: Run `.highway/tools/tests/help-output-all.test.sh`; it passes with one catalog-ordered `Name:`/`Description:`/`Help:` block per entry and no All-Skills `Usage:` line.

### Implementation

- [X] T006 [US1] Update the All-Skills output contract in `.highway/skills/highway-help/SKILL.md` so each catalog entry uses `Description:` with the catalog description and retains `Name:` plus `Help: /highway-help <id>` in catalog order.
- [X] T007 [US1] Preserve the existing empty-catalog and unknown-identifier behavior while updating `.highway/skills/highway-help/SKILL.md`, and verify no All-Skills requirement still labels the catalog description as `Usage:`.
- [X] T008 [US1] Bump `metadata.version` in `.highway/skills/highway-help/SKILL.md` from `3.0.3` to the next PATCH version `3.0.4` for the contract change.
- [X] T009 [US1] Run `.highway/tools/tests/help-output-all.test.sh` and confirm the All-Skills discovery story passes independently.

**Checkpoint**: User Story 1 is independently functional and testable as the MVP.

---

## Phase 4: User Story 2 - Preserve Named Skill Details (Priority: P1)

**Goal**: Keep named-skill help compatible while the no-argument listing changes.

**Independent Test**: Run `.highway/tools/tests/help-output-single.test.sh`; it passes with exactly the existing six labels in order, including `Usage:`, plus unchanged empty/error behavior.

### Implementation

- [X] T010 [US2] Review the named-skill `Outputs` and `Example` sections in `.highway/skills/highway-help/SKILL.md` and retain the six-field order `Name:`, `Description:`, `Dependencies:`, `Version:`, `Usage:`, `Example:`.
- [X] T011 [US2] Run `.highway/tools/tests/help-output-single.test.sh` and confirm the named-skill compatibility story passes independently.

**Checkpoint**: Both P1 user stories pass independently without changing the named-skill contract.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate shipped derivatives, validate correspondence, and complete requirement coverage.

- [X] T012 [P] Regenerate the catalog from source skills with `.highway/tools/generate-catalog.sh`, updating `.highway/catalog/index.json` and `.highway/catalog/index.md` without hand-editing generated output.
- [X] T013 [P] Regenerate agent adapters with `.highway/tools/generate-agent-adapters.sh`, updating `.github/skills/`, `.claude/skills/`, `.cursor/rules/`, `.mock-agent-4/skills/`, and the adapter manifest.
- [X] T014 Validate `.highway/skills/highway-help` with `.highway/tools/validate-skill.sh` and validate generated correspondence with `.highway/tools/tests/adapter-coverage.test.sh`.
- [X] T015 Run `.highway/tools/tests/run-all.sh` and confirm zero failures after all source and generated-artifact changes.
- [X] T016 Record the FR-001 through FR-006 coverage mapping in `specs/023-help-description-listing/coverage.md`, separating requirement coverage from test results in accordance with D7.2 and D7.3.
- [X] T017 Run the commands in `specs/023-help-description-listing/quickstart.md` and confirm the final source, generated artifacts, focused checks, and full suite agree.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T001 and T002 can run in parallel.
- **Foundational (Phase 2)**: Depends on Setup; T003 and T004 can run in parallel, then T005 observes their pre-implementation behavior.
- **User Story 1 (Phase 3)**: Depends on Foundational; T006-T008 are sequential source edits, followed by T009.
- **User Story 2 (Phase 4)**: Depends on Foundational and can be reviewed in parallel with User Story 1, but T011 runs after the source change is complete.
- **Polish (Phase 5)**: Depends on both user stories; T012 and T013 can run in parallel only when their generators write disjoint generated outputs, followed by T014-T017.

### User Story Dependencies

- **User Story 1 (P1)**: Depends only on the Foundational phase and is the MVP.
- **User Story 2 (P1)**: Depends only on the Foundational phase; it protects an existing contract and has no functional dependency on the changed All-Skills label.

### Parallel Opportunities

- T001 and T002 can run in parallel during Setup.
- T003 and T004 can run in parallel because they create separate test files.
- User Story 1 and User Story 2 review/test work can proceed in parallel after T005.
- T012 and T013 can run in parallel when the generator safety checks confirm disjoint targets; otherwise run them sequentially.

## Requirement Coverage

| Requirement | Tasks |
|---|---|
| FR-001 | T003, T006, T009 |
| FR-002 | T003, T006, T009 |
| FR-003 | T003, T006, T009, T012-T015 |
| FR-004 | T004, T010, T011 |
| FR-005 | T004, T007, T011 |
| FR-006 | T003, T006, T009 |

## Implementation Strategy

### MVP First

1. Complete Setup and Foundational phases.
2. Complete User Story 1 and run its independent test.
3. Stop with the no-argument discovery behavior working and validated.

### Incremental Delivery

1. Add User Story 2 compatibility verification.
2. Regenerate catalog and adapters from the source skill.
3. Run correspondence checks, the quickstart, and the full suite.
4. Record requirement coverage separately from check results.

## Notes

- Every task has a checkbox, sequential ID, and exact file or command path.
- `[P]` marks only tasks that can operate on independent files or inputs without incomplete dependencies.
- Generated artifacts are updated through their generators rather than by hand.
