---

description: "Executable task list for Discovery Clarification status rules"
---

# Tasks: Discovery Clarification Status Rules

**Input**: Design documents from `/specs/070-discovery-clarification-status/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/clarification-status-consumption-contract.md](contracts/clarification-status-consumption-contract.md), and [quickstart.md](quickstart.md)

**Implementation surface**: Canonical Discovery skill content, the existing Discovery contract test, and generated agent adapters/catalogs. No runtime dependency or Discovery output-schema change is planned.

## Format

Every task uses `- [ ] [TaskID] [P?] [Story?] Description` with an exact repository path. `[P]` marks tasks that can proceed in parallel with their phase peers.

## Phase 1: Setup

**Purpose**: Establish the baseline and implementation boundaries before changing the shipped contract.

- [X] T001 Record the current passing baseline and affected artifact classes using `.highway/tools/tests/run-all.sh` and `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T002 [P] Confirm the canonical input/output paths and generated adapter targets in `.highway/skills/highway-discovery/SKILL.md`, `.highway/tools/tests/highway-discovery.test.sh`, and `.specify/feature.json`.

---

## Phase 2: Foundational

**Purpose**: Establish shared status, finding-state, validity, and determinism vocabulary before story-specific behavior is implemented.

- [X] T003 [P] Add the Feature 070 status, precedence, finding-state, invalidity, determinism, and verification contract vocabulary to `.highway/skills/highway-discovery/SKILL.md` without taking ownership of Clarification lifecycle rules.
- [X] T004 [P] Extend disposable fixture helpers and artifact-class declarations for status variants, finding states, invalid counts, source-byte snapshots, and repeated-run comparisons in `.highway/tools/tests/highway-discovery.test.sh`.

**Checkpoint**: Shared contract vocabulary and fixture support are ready; user-story work can proceed.

---

## Phase 3: User Story 1 - Interpret Clarification Status Consistently (Priority: P1) MVP

**Goal**: Make `not-started`, `in-progress`, `complete`, and `blocked` status projections explicit while preserving Discovery evaluation and ADR boundaries.

**Independent Test**: Run equivalent valid inputs across all four statuses and verify permitted advisory projections plus unchanged candidate generation, filtering, scores, ordering, recommendation selection, and ADR ownership.

### Tests for User Story 1

- [X] T005 [US1] Add status fixtures for `not-started`, `in-progress`, `complete`, and `blocked` Clarification records in `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T006 [US1] Add assertions for status-specific advisory projections and unchanged candidate/recommendation behavior in `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation for User Story 1

- [X] T007 [US1] Add explicit status handling rules for `not-started`, `in-progress`, `complete`, and `blocked` to the Clarification Consumption Contract in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T008 [US1] Add explicit invariants that status never affects candidate generation, filtering, scores, ordering, recommendation selection, or ADR ownership in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T009 [US1] Update the declared Discovery metadata version from `2.0.0` to `2.1.0` in `.highway/skills/highway-discovery/SKILL.md`.

**Checkpoint**: User Story 1 is independently testable and makes status behavior explicit without changing Discovery decisions.

---

## Phase 4: User Story 2 - Preserve Evidence Authority and Finding Meaning (Priority: P1)

**Goal**: Preserve Request-over-response precedence and distinguish open uncertainty from resolved accepted-response evidence.

**Independent Test**: Supply conflicting Request and response evidence plus open and resolved findings, then verify Request authority, advisory disagreement risk, existing-section projection, and unchanged candidate/recommendation results.

### Tests for User Story 2

- [X] T010 [US2] Add conflicting Request/response, open-finding, resolved-finding, and accepted-response fixtures in `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T011 [US2] Add assertions for precedence, existing-section projection, no uncertainty from resolved findings, and unchanged recommendation values in `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation for User Story 2

- [X] T012 [US2] Add explicit Request-over-response evidence precedence rules to `.highway/skills/highway-discovery/SKILL.md`.
- [X] T013 [US2] Add open versus resolved finding consumption rules for Research Findings, Assumptions, Unknowns, Risks, and confidence rationale to `.highway/skills/highway-discovery/SKILL.md`.
- [X] T014 [US2] Add the no-overwrite, no-replace, no-Request-mutation, and no-dedicated-Clarification-section invariants to `.highway/skills/highway-discovery/SKILL.md`.

**Checkpoint**: User Story 2 is independently testable against existing Discovery sections and unchanged recommendation behavior.

---

## Phase 5: User Story 3 - Reject Invalid Evidence Without Blocking Discovery (Priority: P1)

**Goal**: Treat unreadable, malformed, path-mismatched, state-invalid, and count-invalid Clarification records as unavailable while preserving bytes and deterministic fallback.

**Independent Test**: Exercise each invalidity class and repeated identical inputs, verifying Discovery continues, Clarification remains unchanged, advisory risk is optional/deterministic, and outputs retain existing schema and recommendation behavior.

### Tests for User Story 3

- [X] T015 [US3] Add invalid-record fixtures for unreadable, malformed, path-mismatched, state-invalid, and count-invalid artifacts in `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T016 [US3] Add assertions for whole-artifact rejection, byte immutability, blocked-state continuation, repeated-run determinism, and unchanged candidate/recommendation results in `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation for User Story 3

- [X] T017 [US3] Strengthen the Clarification resolution fallback rule to reject unreadable, malformed, path-mismatched, state-invalid, and count-invalid records in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T018 [US3] Add explicit Clarification determinism guarantees for resolution, advisory sections, confidence rationale, recommendation totals, selection, and ADR ownership in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T019 [US3] Add all Feature 070 verification entries, including advisory-only status, precedence, finding-state, blocked continuation, invalid fallback, and no-mutation checks, to `.highway/skills/highway-discovery/SKILL.md`.

**Checkpoint**: User Story 3 proves invalid or unavailable Clarification cannot block Discovery or mutate Clarification.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate shipped artifacts, validate contract correspondence, and run the complete verification path.

- [X] T020 [P] Regenerate Discovery adapters and catalogs using `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`.
- [X] T021 [P] Validate canonical and generated Discovery skill files with `.highway/tools/validate-skill.sh` and validate dependent library contracts with `.highway/tools/validate-library.sh`.
- [X] T022 Run focused Discovery contract tests through `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T023 Run the complete repository verification suite through `.highway/tools/tests/run-all.sh` and record the result separately from requirement coverage.
- [X] T024 Run the Feature 070 scenarios in `specs/070-discovery-clarification-status/quickstart.md` and confirm `git diff --check` passes.
- [X] T025 [P] Review generated correspondence and changed documentation paths against `specs/070-discovery-clarification-status/plan.md` and `.specify/memory/constitution.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies; establishes the baseline.
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all user stories.
- **Phase 3 (US1)**: Depends on Phase 2; delivers the MVP status contract.
- **Phase 4 (US2)**: Depends on Phase 2 and shared contract vocabulary; independently testable.
- **Phase 5 (US3)**: Depends on Phase 2 and the optional Clarification boundary; independently testable.
- **Phase 6 (Polish)**: Depends on the completed desired user stories.

### User Story Dependencies

- **US1 (P1)**: Starts after Phase 2; no dependency on US2 or US3.
- **US2 (P1)**: Starts after Phase 2; uses shared Clarification vocabulary and can be tested independently.
- **US3 (P1)**: Starts after Phase 2; exercises the same optional input boundary and can be tested independently.

### Parallel Opportunities

- T003 and T004 can run in parallel.
- T005 and T006 can run in parallel before US1 implementation.
- T010 and T011 can run in parallel before US2 implementation.
- T015 and T016 can run in parallel before US3 implementation.
- T020, T021, and T025 can run in parallel after canonical edits; T022-T024 remain ordered by validation scope.

## Parallel Execution Examples

### User Story 1

```text
Task: T005 status fixtures in .highway/tools/tests/highway-discovery.test.sh
Task: T006 status invariance assertions in .highway/tools/tests/highway-discovery.test.sh
```

### User Story 2

```text
Task: T010 precedence and finding fixtures in .highway/tools/tests/highway-discovery.test.sh
Task: T011 projection and recommendation invariance assertions in .highway/tools/tests/highway-discovery.test.sh
```

### User Story 3

```text
Task: T015 invalid-record fixtures in .highway/tools/tests/highway-discovery.test.sh
Task: T016 immutability and determinism assertions in .highway/tools/tests/highway-discovery.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement US1 status handling and version update.
3. Run US1 focused tests and seeded probes.
4. Stop for an MVP review: Discovery has explicit status semantics without changed decisions.

### Incremental Delivery

1. Add US2 precedence and finding-state semantics.
2. Add US3 invalid-record fallback and determinism guarantees.
3. Regenerate adapters/catalogs and run focused plus full validation.

## Notes

- Test tasks are included because the feature specifies independent acceptance scenarios and executable contract validation is required by the project constitution.
- Tests must demonstrate the intended failure before the corresponding implementation task is marked complete.
- `[P]` marks only independent work; tasks sharing the same canonical file should be merged carefully.
- No task creates or modifies a Clarification artifact, catalog row, finding, response, status, Discovery decision, or ADR decision at runtime.
