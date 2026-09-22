---

description: "Executable task list for Discovery consumption of Clarification artifacts"
---

# Tasks: Discovery Consumption of Clarification Artifacts

**Input**: Design documents from `/specs/069-discovery-clarification-consumption/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/clarification-consumption-contract.md](contracts/clarification-consumption-contract.md), and [quickstart.md](quickstart.md)

**Implementation surface**: Canonical Discovery skill content, the existing Discovery contract test, and generated agent adapters. No runtime dependency or Discovery output-schema change is planned.

## Format

Every task uses `- [ ] [TaskID] [P?] [Story?] Description` with an exact repository path. `[P]` marks tasks that can proceed in parallel with their phase peers.

## Phase 1: Setup

**Purpose**: Establish the baseline and implementation boundaries before changing the shipped skill.

- [X] T001 Record the current passing baseline and affected artifact classes using `.highway/tools/tests/run-all.sh` and `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T002 [P] Confirm the canonical input/output paths and generated adapter targets in `.highway/skills/highway-discovery/SKILL.md`, `.highway/library/templates/output/clarification-catalog.md`, `.highway/library/templates/output/clarification-record.md`, and `.specify/feature.json`.

---

## Phase 2: Foundational

**Purpose**: Establish shared contract vocabulary before story-specific behavior is implemented.

- [X] T003 [P] Add the consumer contract's resolution, field, precedence, failure, ownership, and determinism requirements to `.highway/skills/highway-discovery/SKILL.md` without duplicating the Clarification producer's lifecycle rules.
- [X] T004 [P] Extend the fixture helpers and artifact-class declarations in `.highway/tools/tests/highway-discovery.test.sh` for catalog rows, clarification records, source-byte snapshots, and deterministic output comparisons.

**Checkpoint**: Shared consumer terminology and disposable-fixture support are ready; user-story behavior can be implemented independently.

---

## Phase 3: User Story 1 - Resolve Clarification Evidence Safely (Priority: P1) MVP

**Goal**: Resolve `CLAR-<REQ-ID>` only through the authoritative Clarification Catalog and read the referenced artifact without mutation or workflow blockage.

**Independent Test**: A completed Request with a matching catalog row loads the direct clarification path and read-only fields; absent catalogs, missing rows, duplicate rows, stale mappings, and path mismatches continue without clarification evidence and leave all files unchanged.

### Tests for User Story 1

- [X] T005 [US1] Add failing catalog-resolution fixtures for a valid `CLAR-REQ######` row, absent catalog, missing entry, duplicate entry, stale entry, and path-mismatched entry in `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T006 [US1] Add failing read-only and source-byte-preservation assertions for the catalog and clarification artifact in `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation for User Story 1

- [X] T007 [US1] Add the optional `clarifications/clarifications.md` input and the post-Request `CLAR-<REQ-ID>` resolution step to `.highway/skills/highway-discovery/SKILL.md`.
- [X] T008 [US1] Define catalog-authoritative identity, direct-path validation, supported Request linkage, and no filesystem-order selection rules in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T009 [US1] Define read-only consumption of clarification status, finding counts, summaries, responses, and blocking reason while preserving Clarification ownership in `.highway/skills/highway-discovery/SKILL.md`.

**Checkpoint**: User Story 1 resolves only the catalog-selected artifact, preserves bytes on every resolution gap, and remains independently testable.

---

## Phase 4: User Story 2 - Use Clarification as Advisory Discovery Evidence (Priority: P1)

**Goal**: Project validated responses and findings into existing Discovery evidence sections while preserving evidence precedence and all candidate/recommendation behavior.

**Independent Test**: Responses can contribute to Research Findings; open findings can contribute to Assumptions, Unknowns, Risks, and confidence rationale; the Discovery record has no Clarification section and candidate scores, ordering, totals, and selection remain unchanged.

### Tests for User Story 2

- [X] T010 [US2] Add failing fixtures for open findings, resolved findings, finding summaries, blocking reasons, and accepted responses in `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T011 [US2] Add failing assertions for Request-over-response precedence, existing-section projection, unchanged score/ranking/recommendation values, and no dedicated Clarification section in `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation for User Story 2

- [X] T012 [US2] Add the evidence precedence order and response contribution rules to `.highway/skills/highway-discovery/SKILL.md`.
- [X] T013 [US2] Add advisory projection rules for Research Findings, Assumptions, Risks, Unknowns, confidence rationale, and advisory risk reporting to `.highway/skills/highway-discovery/SKILL.md`.
- [X] T014 [US2] Add explicit invariants preventing clarification evidence from changing candidate generation, scores, ranking, ordering, recommendation totals, recommendation selection, or the Discovery record schema in `.highway/skills/highway-discovery/SKILL.md`.

**Checkpoint**: User Story 2 can be validated independently against existing Discovery sections and unchanged recommendation outputs.

---

## Phase 5: User Story 3 - Continue Discovery Through Clarification Gaps (Priority: P1)

**Goal**: Treat optional, unreadable, malformed, and open Clarification inputs as advisory conditions that never block Discovery or mutate Clarification state.

**Independent Test**: Absent, unreadable, malformed, and open-finding cases all continue safely; malformed or unreadable referenced artifacts may produce only an appropriate deterministic advisory risk; identical inputs produce byte-identical output.

### Tests for User Story 3

- [X] T015 [US3] Add failing fallback fixtures for absent catalogs, unreadable artifacts, malformed frontmatter/body, unsupported status, count mismatch, open findings, and no-clarification operation in `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T016 [US3] Add failing assertions for deterministic advisory-risk behavior, clarification-byte immutability, repeated byte-identical runs, and unchanged candidate/recommendation results in `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation for User Story 3

- [X] T017 [US3] Add missing-catalog, missing-entry, duplicate/stale/path-mismatch, unreadable-artifact, malformed-artifact, and open-finding fallback rules to `.highway/skills/highway-discovery/SKILL.md`.
- [X] T018 [US3] Add deterministic-output, privacy-preservation, and no-mutation verification requirements for Clarification failures to `.highway/skills/highway-discovery/SKILL.md`.
- [X] T019 [US3] Add the Feature 069 verification and error-handling checks to `.highway/skills/highway-discovery/SKILL.md`, including catalog resolution, advisory evidence, fallback, ownership, scoring invariance, and repeatability.

**Checkpoint**: User Story 3 tolerates every specified Clarification gap and proves Discovery remains usable without a completed Clarification artifact.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate shipped adapters, validate shared contracts, and run the complete verification path.

- [X] T020 [P] Regenerate the Discovery catalog entry and agent adapters from `.highway/skills/highway-discovery/SKILL.md` using `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh` as applicable.
- [X] T021 [P] Validate the canonical and generated Discovery skill files with `.highway/tools/validate-skill.sh`, and validate the cited shared templates with `.highway/tools/validate-library.sh`.
- [X] T022 Run all focused Discovery contract tests and seeded probes through `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T023 Run the complete repository verification suite through `.highway/tools/tests/run-all.sh` and record the result separately from requirement coverage.
- [X] T024 Run the Feature 069 scenarios in `specs/069-discovery-clarification-consumption/quickstart.md` and confirm `git diff --check` passes.
- [X] T025 [P] Review generated adapter correspondence and changed documentation paths against `specs/069-discovery-clarification-consumption/plan.md` and `.specify/memory/constitution.md`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies; establishes the baseline.
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all story work.
- **Phase 3 (US1)**: Depends on Phase 2; delivers the MVP resolution path.
- **Phase 4 (US2)**: Depends on Phase 2 and the resolution vocabulary from US1; independently testable once the shared catalog fixture support exists.
- **Phase 5 (US3)**: Depends on Phase 2 and the consumer path from US1; independently testable with fallback fixtures.
- **Phase 6 (Polish)**: Depends on the completed desired user stories.

### User Story Dependencies

- **US1 (P1)**: Starts after Phase 2; no dependency on US2 or US3.
- **US2 (P1)**: Starts after Phase 2; uses the resolved artifact identity from US1 but can be tested with fixtures independently.
- **US3 (P1)**: Starts after Phase 2; exercises the same optional input boundary as US1 and can be tested independently.

### Parallel Opportunities

- T003 and T004 can run in parallel.
- T005 and T006 can run in parallel before US1 implementation.
- T010 and T011 can run in parallel before US2 implementation.
- T015 and T016 can run in parallel before US3 implementation.
- After Phase 2, US1, US2, and US3 can be assigned to separate workers if their edits are merged carefully because they share `.highway/skills/highway-discovery/SKILL.md` and `.highway/tools/tests/highway-discovery.test.sh`.
- T020, T021, and T025 can run in parallel after the final canonical edits; T022-T024 remain ordered by validation scope.

## Parallel Execution Examples

### User Story 1

```text
Task: T005 catalog-resolution fixtures in .highway/tools/tests/highway-discovery.test.sh
Task: T006 source-byte and read-only assertions in .highway/tools/tests/highway-discovery.test.sh
```

### User Story 2

```text
Task: T010 clarification-field fixtures in .highway/tools/tests/highway-discovery.test.sh
Task: T011 precedence and score-invariance assertions in .highway/tools/tests/highway-discovery.test.sh
```

### User Story 3

```text
Task: T015 malformed and unavailable-input fixtures in .highway/tools/tests/highway-discovery.test.sh
Task: T016 determinism and immutability assertions in .highway/tools/tests/highway-discovery.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement US1 catalog resolution and read-only artifact consumption.
3. Run the US1 focused tests and seeded probes.
4. Stop for an MVP review: Discovery can trace a Request to Clarification without making Clarification a prerequisite.

### Incremental Delivery

1. Add US2 advisory evidence projection while preserving the existing Discovery schema and recommendation invariants.
2. Add US3 fallback and determinism coverage for all unavailable or malformed Clarification cases.
3. Regenerate adapters and run focused plus full validation.

## Notes

- Test tasks are included because this is a behavioral change and the project constitution requires an amended behavioral test.
- Tests must demonstrate the intended failure before the corresponding implementation task is marked complete.
- `[P]` marks only independent work; tasks sharing the same canonical file should be merged carefully.
- No task creates or modifies a Clarification artifact, catalog row, finding, response, status, Discovery decision, or ADR decision at runtime.
