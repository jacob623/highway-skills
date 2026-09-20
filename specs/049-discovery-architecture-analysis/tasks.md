# Tasks: Discovery Architecture Analysis

**Input**: Design documents from `specs/049-discovery-architecture-analysis/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`

**Organization**: Tasks are grouped by user story so each increment can be implemented and tested independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the canonical implementation and validation surfaces.

- [ ] T001 Confirm the Feature 049 design artifacts and active feature pointer; inspect specs/049-discovery-architecture-analysis/spec.md and .specify/feature.json.
- [ ] T002 [P] Snapshot the current canonical Discovery skill, shared output templates, generated adapters, and focused test paths listed in `specs/049-discovery-architecture-analysis/plan.md` before editing.
- [ ] T003 [P] Record the existing focused and full-suite validation commands and their baseline results in `specs/049-discovery-architecture-analysis/quickstart.md` without adding live user-owned fixtures.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Update shared contracts and output structure before story-specific behavior is implemented.

- [ ] T004 Extend `.highway/library/templates/output/discovery-record.md` with Candidate Solution Options, Candidate Solution Comparison Matrix, Recommendation, and Reference Architecture Matches in the required order.
- [ ] T005 [P] Update `specs/049-discovery-architecture-analysis/contracts/discovery-analysis-contract.md` with the closed-input order, option-generation precedence, exact Reference Architecture matching, and failure fallbacks.
- [ ] T006 [P] Update `specs/049-discovery-architecture-analysis/contracts/discovery-artifact-contract.md` with the expanded record structure, matrix invariants, advisory boundary, and tie-break fields.
- [ ] T007 [P] Update `specs/049-discovery-architecture-analysis/contracts/discovery-conversation-contract.md` with completion, abort, no-partial-write, and ADR handoff response requirements.
- [ ] T008 Add shared validation helpers and fixture setup for redaction, deterministic serialization, source-byte preservation, catalog allocation, and generated-template assertions in `.highway/tools/tests/highway-discovery.test.sh`.
- [ ] T009 Update `.highway/skills/highway-discovery/SKILL.md` with the new input, output, workflow, verification, and error-handling contract while preserving existing Request resolution and transaction behavior.

**Checkpoint**: Shared template, contracts, canonical skill, and focused-test scaffolding agree on the Feature 049 artifact boundary.

## Phase 3: User Story 1 - Generate Architectural Solution Options (Priority: P1) MVP

**Story Goal**: Produce two through five distinct, stable, evidence-backed Candidate Solution Options from a completed Request and preserve existing Discovery analysis sections.

**Independent Test Criteria**: Given closed input evidence supporting three viable strategies, run Discovery twice and verify exactly three complete options, stable sorted `OPT` identifiers, byte-identical output, and unchanged source baselines; verify fewer than two viable options abort without writes.

### Tests for User Story 1

- [ ] T010 [P] [US1] Add a three-strategy option-generation contract probe with expected option fields, ordering, `OPT` format, and exact count in `.highway/tools/tests/highway-discovery.test.sh`.
- [ ] T011 [P] [US1] Add a repeatability probe comparing serialized Discovery record and catalog bytes for identical closed inputs in `.highway/tools/tests/highway-discovery.test.sh`.
- [ ] T012 [P] [US1] Add lower-bound, deduplication, and upper-bound probes for fewer than two options, normalized duplicate strategies, and more than five viable options in `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation Tasks for User Story 1

- [ ] T013 Implement deterministic option derivation from Desired Change strategies followed by Objective, Control, NFR, Research Finding, and Reference Architecture evidence in `.highway/skills/highway-discovery/SKILL.md`.
- [ ] T014 Implement option viability validation, normalized deduplication, supporting-evidence aggregation, truncation-boundary recording, and required option fields in `.highway/skills/highway-discovery/SKILL.md`.
- [ ] T015 Implement deterministic option sorting and post-sort `OPT000001`-style identifier assignment in `.highway/skills/highway-discovery/SKILL.md`.
- [ ] T016 Add Candidate Solution Option fields and ordering rules to `.highway/library/templates/output/discovery-record.md`.
- [ ] T017 Add option-generation and identifier assertions to `.highway/tools/tests/highway-discovery.test.sh` and verify existing findings, assumptions, risks, unknowns, and governance relationship behavior remains covered.

**Checkpoint**: User Story 1 passes independently with deterministic options and no-write failure behavior.

## Phase 4: User Story 2 - Match Context and Recommend an Option (Priority: P1)

**Story Goal**: Match all applicable Reference Architectures, calculate the comparison matrix and weighted recommendation, and keep all recommendation output advisory.

**Independent Test Criteria**: Given governance baselines, Reference Architectures, and equal-scoring options, verify every matching architecture and highest-precedence reason, score identity between matrix and Recommendation, informational-category non-influence, confidence, and all tie-break fallbacks.

### Tests for User Story 2

- [ ] T018 [P] [US2] Add independent exact-match probes for explicit identifier, normalized title, capability, Objective, Control, and NFR rules plus highest-precedence reason reporting in `.highway/tools/tests/highway-discovery.test.sh`.
- [ ] T019 [P] [US2] Add Reference Architecture absence, unreadable, malformed, duplicate, and match-operation failure probes with unchanged source bytes in `.highway/tools/tests/highway-discovery.test.sh`.
- [ ] T020 [P] [US2] Add score formula, zero-denominator, 0-100 range, confidence-table, and total-identity probes in `.highway/tools/tests/highway-discovery.test.sh`.
- [ ] T021 [P] [US2] Add matrix completeness, option-order, exactly-one-Recommended-status, and matrix-to-Recommendation score-identity probes in `.highway/tools/tests/highway-discovery.test.sh`.
- [ ] T022 [P] [US2] Add tie-break probes for unmatched versus matched options, no-match lower `OPT`, highest Reference Implementation count across multiple matches, equal counts, and unavailable Reference Implementation catalog fallback in `.highway/tools/tests/highway-discovery.test.sh`.
- [ ] T023 [P] [US2] Add informational-category threshold and non-influence probes for Complexity, Governance Impact, and Operational Overhead in `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation Tasks for User Story 2

- [ ] T024 Implement independent exact Reference Architecture matching with six-rule precedence, all-match reporting, malformed-baseline handling, and advisory match metadata in `.highway/skills/highway-discovery/SKILL.md`.
- [ ] T025 Implement Objective, NFR, Control, Profile, and Risk score calculations, zero-denominator defaults, floor rounding, total validation, and confidence classification in `.highway/skills/highway-discovery/SKILL.md`.
- [ ] T026 Implement Reference Implementation-count tie-breaking, including highest count across an option's matches, zero counts for unavailable catalogs, and lower `OPT` fallback in `.highway/skills/highway-discovery/SKILL.md`.
- [ ] T027 Implement Comparison Matrix generation before Recommendation with all options, weighted scores, totals, Reference Architecture matches, recommendation status, and mandatory informational categories in `.highway/skills/highway-discovery/SKILL.md`.
- [ ] T028 Add matrix, Recommendation, Reference Architecture Match, and informational-category structures to `.highway/library/templates/output/discovery-record.md`.
- [ ] T029 Update `.highway/tools/tests/highway-discovery.test.sh` to assert that informational categories never affect score, confidence, ranking, selection, or option ordering.

**Checkpoint**: User Story 2 independently produces complete deterministic matching, scoring, matrix, and advisory recommendation output.

## Phase 5: User Story 3 - Hand Analysis to ADR Without Deciding (Priority: P1)

**Story Goal**: Expose the complete Discovery analysis to ADR while keeping selection, rejection, acceptance, rationale, consequences, and decision authority in ADR.

**Independent Test Criteria**: Given a successful Discovery, verify the handoff exposes the Discovery identifier, every option and `OPT`, matrix, Recommendation, rationale, and all Reference Architecture Matches; verify Discovery contains no decision fields and remains unchanged when ADR selects a non-recommended option.

### Tests for User Story 3

- [ ] T030 [P] [US3] Add ADR handoff completeness assertions for Discovery identifier, Request identifier, options, matrix, Recommendation, rationale, and Reference Architecture Matches in `.highway/tools/tests/highway-discovery.test.sh`.
- [ ] T031 [P] [US3] Add advisory-boundary assertions forbidding selected option, rejected option, approval, architecture decision, implementation authorization, and governance mutation fields in `.highway/tools/tests/highway-discovery.test.sh`.
- [ ] T032 [P] [US3] Add a non-recommended ADR selection fixture and byte-preservation assertion for the Discovery artifact in `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation Tasks for User Story 3

- [ ] T033 Implement the complete Discovery-to-ADR handoff projection and exactly-one-future-ADR eligibility rule in `.github/skills/highway-discovery/SKILL.md`.
- [ ] T034 Propagate the canonical Discovery skill changes to `.claude/skills/highway-discovery/SKILL.md` and `.cursor/rules/highway-discovery.mdc` using the repository generator rather than hand editing.
- [ ] T035 Extend `.highway/library/templates/output/discovery-catalog.md` only where needed to preserve catalog-authoritative Discovery allocation and one-record indexing for the expanded artifact in `.highway/library/templates/output/discovery-catalog.md`.
- [ ] T036 Update `.highway/tools/tests/highway-discovery.test.sh` to prove ADR handoff consumes the complete Discovery without repeating analysis or mutating any source baseline.

**Checkpoint**: User Story 3 independently proves the advisory ADR handoff and Discovery decision boundary.

## Requirement and Success-Criteria Traceability

| Scope | Covered by tasks |
| --- | --- |
| FR-001-FR-006, FR-029-FR-031, FR-035, FR-042 | T004-T009, T024, T033-T036, T040-T044 |
| FR-007-FR-016, FR-032-FR-033, FR-040-FR-041 | T010-T017 |
| FR-017-FR-025, FR-034, FR-036-FR-049 | T018-T029 |
| FR-050-FR-062 | T021-T029 |
| FR-026-FR-028, FR-030, FR-033, FR-042 | T030-T036 |
| SC-001-SC-007, SC-011 | T010-T017, T020, T022, T040-T044 |
| SC-008-SC-010, SC-012, SC-016 | T018-T019, T030-T036, T042-T044 |
| SC-013-SC-015, SC-017-SC-022 | T021-T029, T038-T044 |

Explicit identifier index: FR-001, FR-002, FR-003, FR-004, FR-005, FR-006, FR-007, FR-008,
FR-009, FR-010, FR-011, FR-012, FR-013, FR-014, FR-015, FR-016, FR-017, FR-018, FR-019,
FR-020, FR-021, FR-022, FR-023, FR-024, FR-025, FR-026, FR-027, FR-028, FR-029, FR-030,
FR-031, FR-032, FR-033, FR-034, FR-035, FR-036, FR-037, FR-038, FR-039, FR-040, FR-041,
FR-042, FR-043, FR-044, FR-045, FR-046, FR-047, FR-048, FR-049, FR-050, FR-051, FR-052,
FR-053, FR-054, FR-055, FR-056, FR-057, FR-058, FR-059, FR-060, FR-061, FR-062; SC-001,
SC-002, SC-003, SC-004, SC-005, SC-006, SC-007, SC-008, SC-009, SC-010, SC-011, SC-012,
SC-013, SC-014, SC-015, SC-016, SC-017, SC-018, SC-019, SC-020, SC-021, SC-022.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate retained artifacts, run all validators, and confirm complete traceability and reproducibility.

- [ ] T037 [P] Regenerate agent adapters and catalog outputs from canonical sources using `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-catalog.sh`.
- [ ] T038 [P] Update `.highway/tools/tests/highway-discovery.test.sh` probe declarations and expected contract tokens for all Feature 049 artifact classes.
- [ ] T039 [P] Update `specs/049-discovery-architecture-analysis/quickstart.md` with final commands, fixture expectations, and observed validation outcomes.
- [ ] T040 Run `.highway/tools/validate-skill.sh .highway/skills/highway-discovery/SKILL.md` and repair any Feature 049 skill-contract failures in `.highway/skills/highway-discovery/SKILL.md`.
- [ ] T041 Run `.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md` and repair any shared-template failures in `.highway/library/templates/output/discovery-record.md`.
- [ ] T042 Run `.highway/tools/tests/highway-discovery.test.sh` with its declared probe classes and confirm seeded failures fail before neutralization and pass after neutralization.
- [ ] T043 Run `.highway/tools/tests/run-all.sh` and resolve only Feature 049 regressions in the touched skill, templates, generators, adapters, or focused test.
- [ ] T044 Compare generated artifacts and source baselines with `git diff --check`, generator correspondence checks, and byte snapshots from `.highway/tools/tests/highway-discovery.test.sh`; record residual unrelated failures without altering unrelated work.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 first; T002 and T003 can run in parallel after T001.
- **Foundational (Phase 2)**: T004-T009 depend on T001; T005-T008 can run in parallel where they touch different files; T009 and T008 depend on the contract/template decisions.
- **User Stories (Phases 3-5)**: T010-T012 depend on T008; T013-T017 follow the US1 probes and shared foundation. US2 begins after T009 and T016; US3 begins after T009 and the expanded record structure. Story work can be parallelized only when tasks touch different files and do not depend on incomplete shared-template changes.
- **Polish (Phase 6)**: T037-T044 depend on all desired story tasks and on the canonical skill/template changes.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Phase 2; MVP scope.
- **User Story 2 (P1)**: Depends on Phase 2 and the Candidate Solution Option structure from US1; adds matching, matrix, and recommendation behavior.
- **User Story 3 (P1)**: Depends on Phase 2 and the expanded Discovery artifact; can be validated independently after the handoff contract is implemented.

### Within Each User Story

- Write focused probes before implementation where feasible; establish expected failure before the behavior is added.
- Update the canonical skill and shared template before regenerating derived adapters.
- Validate each story at its checkpoint before starting unrelated story work.
- Preserve source baselines, catalog allocation authority, deterministic serialization, and no-partial-write behavior throughout.

## Parallel Opportunities

- **Setup**: T002 and T003 can run in parallel after T001.
- **Foundation**: T005, T006, T007, and T008 can run in parallel after T004's section order is agreed.
- **US1**: T010, T011, and T012 can run in parallel; T013-T015 are sequential because derivation precedes validation, sorting, and identifier assignment.
- **US2**: T018-T023 can run in parallel as independent probes; T024-T027 are sequential in analysis order, while T028 can follow the template boundary independently.
- **US3**: T030-T032 can run in parallel; T033 and T034 are sequential because adapters depend on the canonical skill, while T035 can proceed independently if catalog structure is unchanged.
- **Polish**: T037-T039 can run in parallel after story work; T040-T044 are validation and repair steps in the listed order.

## Parallel Example: User Story 1

```text
Task: T010 [US1] Add the three-strategy option-generation probe in .highway/tools/tests/highway-discovery.test.sh
Task: T011 [US1] Add the repeatability byte-comparison probe in .highway/tools/tests/highway-discovery.test.sh
Task: T012 [US1] Add lower-bound, deduplication, and upper-bound probes in .highway/tools/tests/highway-discovery.test.sh
```

## Parallel Example: User Story 2

```text
Task: T018 [US2] Add exact Reference Architecture matching probes in .highway/tools/tests/highway-discovery.test.sh
Task: T020 [US2] Add score and confidence probes in .highway/tools/tests/highway-discovery.test.sh
Task: T023 [US2] Add informational-category probes in .highway/tools/tests/highway-discovery.test.sh
```

## Parallel Example: User Story 3

```text
Task: T030 [US3] Add ADR handoff completeness assertions in .highway/tools/tests/highway-discovery.test.sh
Task: T031 [US3] Add advisory-boundary assertions in .highway/tools/tests/highway-discovery.test.sh
Task: T032 [US3] Add non-recommended ADR selection preservation fixture in .highway/tools/tests/highway-discovery.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 Setup and Phase 2 Foundational tasks.
2. Complete User Story 1 option generation, deterministic identifiers, and no-write probes.
3. Run the US1 checkpoint and the focused Discovery test.
4. Stop for an MVP review before adding recommendation or ADR handoff behavior.

### Incremental Delivery

1. Deliver deterministic Candidate Solution Options as the first usable increment.
2. Add Reference Architecture matching, Comparison Matrix, and Recommendation as User Story 2.
3. Add the complete advisory ADR handoff as User Story 3.
4. Regenerate adapters and run the full validation suite after each integrated story.

### Parallel Team Strategy

1. Complete Phase 1 and the shared-template decision together.
2. Assign foundation contract/test work to separate files after T004.
3. Assign US1 option generation, US2 matching/scoring, and US3 handoff probes to separate owners only after their shared dependencies are complete.
4. Integrate canonical skill changes before regenerating adapters and running the full suite.

## Notes

- Every task uses the required checklist format with a sequential ID and concrete repository path.
- `[P]` marks only tasks that can work on different files or independent probe sections without incomplete dependencies.
- `[US1]`, `[US2]`, and `[US3]` map directly to the P1 user stories in `spec.md`.
- Tests are included because the feature changes executable workflow behavior and the plan's Testing Gate requires focused behavior checks.
- `tasks.md` is a planning artifact; implementation starts only after task review and `/speckit-implement`.
