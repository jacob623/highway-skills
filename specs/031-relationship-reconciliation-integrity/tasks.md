---

description: "Task list for relationship reconciliation and integrity management"
---

# Tasks: Relationship Reconciliation and Integrity Management

**Input**: Design documents from `/specs/031-relationship-reconciliation-integrity/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/relationship-integrity-workflow.md, quickstart.md

**Tests**: Focused Bash contract tests are included because the feature specification defines independent test criteria and the plan requires fixture-driven validation.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently after the foundational contract is available.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the shipped skill surface and disposable test layout.

- [X] T001 [P] Create the `highway-relationships` skill directory and initial `SKILL.md` at `.highway/skills/highway-relationships/SKILL.md` with frontmatter, purpose, usage, and ownership boundaries
- [X] T002 [P] Create the relationship-integrity fixture directory at `.highway/tools/tests/fixtures/relationship-integrity/` with isolated baseline, malformed, asymmetric, orphan, duplicate, and direct-NFR fixture cases
- [X] T003 [P] Create the focused test entry point at `.highway/tools/tests/relationship-integrity.test.sh` with Bash 3.2-compatible setup, temporary fixture copying, and assertion helpers
- [X] T004 Document Feature 031 test commands and fixture scenarios in `specs/031-relationship-reconciliation-integrity/quickstart.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define shared parsing, graph, ordering, and write-safety contracts before story behavior is implemented.

**CRITICAL**: User-story implementation depends on this phase.

- [X] T005 Define the graph entities, finding classes, repair decisions, impact records, snapshot rules, and invariants in `specs/031-relationship-reconciliation-integrity/data-model.md`
- [X] T006 Define inspect, repair, impact, deterministic-ordering, atomicity, and scope-exclusion behavior in `specs/031-relationship-reconciliation-integrity/contracts/relationship-integrity-workflow.md`
- [X] T007 Implement shared project-root discovery, governance-path resolution, record parsing, identifier validation, and baseline error reporting in `.highway/skills/highway-relationships/SKILL.md`
- [X] T008 Implement canonical record, relationship, finding, and recommendation ordering in `.highway/skills/highway-relationships/SKILL.md`
- [X] T009 Add fixture assertions for missing catalogs, malformed records, duplicate IDs, invalid relationship fields, and no-partial-write preconditions in `.highway/tools/tests/relationship-integrity.test.sh`
- [X] T010 Run the focused foundational test setup and confirm it fails only on unimplemented relationship behavior with `/bin/bash .highway/tools/tests/relationship-integrity.test.sh`

**Checkpoint**: Shared graph parsing, classification inputs, ordering, and failure boundaries are defined before story-specific workflows begin.

---

## Phase 3: User Story 1 - Inspect Relationship Integrity (Priority: P1) MVP

**Goal**: Inspect every existing Control-to-NFR relationship, classify its integrity, and produce a complete deterministic read-only report.

**Independent Test**: Run Inspect mode against valid, orphaned, malformed, asymmetric, duplicate, and direct-NFR fixtures; verify every finding is classified and no fixture file changes.

### Tests for User Story 1

- [X] T011 [P] [US1] Add valid reciprocal, orphan, malformed-ID, wrong-type, asymmetric, duplicate, and direct-NFR inspection cases to `.highway/tools/tests/fixtures/relationship-integrity/`
- [X] T012 [US1] Add read-only integrity-report assertions for valid, broken, asymmetric, orphan, duplicate, and blocked sections in `.highway/tools/tests/relationship-integrity.test.sh`

### Implementation for User Story 1

- [X] T013 [US1] Implement read-only Control `nfrs` and NFR `controls` traversal and target existence/type validation in `.highway/skills/highway-relationships/SKILL.md`
- [X] T014 [US1] Implement reciprocal-membership, malformed-reference, orphan-reference, duplicate-reference, and blocked-baseline classifications in `.highway/skills/highway-relationships/SKILL.md`
- [X] T015 [US1] Implement deterministic Integrity Report sections for relationship summary, valid relationships, broken relationships, asymmetric relationships, orphan references, required repairs, and blocking conditions in `.highway/skills/highway-relationships/SKILL.md`
- [X] T016 [US1] Add inspection no-write and direct-NFR `controls: []` assertions to `.highway/tools/tests/relationship-integrity.test.sh`

**Checkpoint**: Inspect mode is independently useful, read-only, deterministic, and classifies all required relationship states.

---

## Phase 4: User Story 2 - Review and Apply Relationship Repairs (Priority: P1)

**Goal**: Show complete relationship-only repair proposals, obtain explicit per-recommendation decisions, and apply only approved reciprocal additions or orphan removals atomically.

**Independent Test**: Generate proposals for asymmetric and orphan fixtures, verify artifact/current/proposed/reason/impact fields, reject or cancel with no writes, then approve a subset and verify only that subset changes.

### Tests for User Story 2

- [X] T017 [P] [US2] Add asymmetric, orphan, mixed-recommendation, rejected, cancelled, approved-subset, and invalid-baseline repair fixtures under `.highway/tools/tests/fixtures/relationship-integrity/`
- [X] T018 [US2] Add proposal completeness, per-recommendation decision, reciprocal-repair, orphan-removal, rejection, cancellation, and subset-approval assertions to `.highway/tools/tests/relationship-integrity.test.sh`

### Implementation for User Story 2

- [X] T019 [US2] Implement deterministic repair recommendation generation with artifact, current state, proposed state, reason, and impact fields in `.highway/skills/highway-relationships/SKILL.md`
- [X] T020 [US2] Implement explicit approval, rejection, cancellation, and incomplete-decision handling before any write in `.highway/skills/highway-relationships/SKILL.md`
- [X] T021 [US2] Implement reciprocal-add and orphan-remove staging that mutates only `Control.nfrs` and `NFR.controls` relationship values in `.highway/skills/highway-relationships/SKILL.md`
- [X] T022 [US2] Implement baseline snapshot validation, selected-recommendation validation, atomic commit, and zero-partial-write failure handling in `.highway/skills/highway-relationships/SKILL.md`
- [X] T023 [US2] Add repair-preservation assertions proving identifiers, titles, statements, rationales, statuses, catalogs, and unrelated records remain unchanged in `.highway/tools/tests/relationship-integrity.test.sh`

**Checkpoint**: Repair mode is proposal-first, confirmation-gated, independently reviewable, relationship-only, and atomic.

---

## Phase 5: User Story 3 - Analyze Destructive-Operation Impact (Priority: P1)

**Goal**: List every relationship and affected artifact that would be lost before Control removal, NFR removal, or baseline replacement proceeds.

**Independent Test**: Request impact analysis for related Controls, NFRs, and replacement baselines; verify every affected ID/title is listed individually and declined confirmation leaves all data unchanged.

### Tests for User Story 3

- [X] T024 [P] [US3] Add Control-removal, NFR-removal, baseline-replacement, empty-impact, and declined-confirmation fixtures under `.highway/tools/tests/fixtures/relationship-integrity/`
- [X] T025 [US3] Add individual affected-ID/title, relationship-direction, empty-impact, and decline-safe assertions to `.highway/tools/tests/relationship-integrity.test.sh`

### Implementation for User Story 3

- [X] T026 [US3] Implement Control-removal, NFR-removal, and baseline-replacement impact analysis with individually listed immutable IDs, titles, directions, and lost traceability in `.highway/skills/highway-relationships/SKILL.md`
- [X] T027 [US3] Update destructive-operation routing and preflight requirements in `.highway/skills/highway-controls/SKILL.md` to require relationship impact analysis before removal or set confirmation
- [X] T028 [US3] Update destructive-operation routing and preflight requirements in `.highway/skills/highway-nfrs/SKILL.md` to require relationship impact analysis before removal or set confirmation
- [X] T029 [US3] Add assertions that impact analysis does not delete records, increment versions, alter catalogs, or repair relationships in `.highway/tools/tests/relationship-integrity.test.sh`

**Checkpoint**: Destructive workflows retain artifact ownership while requiring complete, decline-safe relationship impact review.

---

## Phase 6: User Story 4 - Produce Deterministic Integrity Results (Priority: P2)

**Goal**: Guarantee byte-stable inspection reports and repair proposals for byte-identical baselines.

**Independent Test**: Run inspection and repair planning twice on isolated identical fixtures and compare reports, ordering, and resulting relationship fields byte-for-byte.

### Tests for User Story 4

- [X] T030 [P] [US4] Add repeated-run and filesystem/catalog-reordering fixtures under `.highway/tools/tests/fixtures/relationship-integrity/`
- [X] T031 [US4] Add byte-for-byte repeated inspect, repeated proposal, stable ordering, and no timestamp/random/environment-value assertions to `.highway/tools/tests/relationship-integrity.test.sh`

### Implementation for User Story 4

- [X] T032 [US4] Remove or reject timestamp, randomness, environment, and incidental filesystem/catalog ordering from integrity output in `.highway/skills/highway-relationships/SKILL.md`
- [X] T033 [US4] Implement canonical serialized output and stable recommendation keys for reports and proposals in `.highway/skills/highway-relationships/SKILL.md`
- [X] T034 [US4] Add deterministic-output verification requirements to `.highway/skills/highway-relationships/SKILL.md`

**Checkpoint**: Identical baselines produce identical integrity classifications, proposal contents, ordering, and approved relationship results.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Complete generated surfaces, validate packaging, and confirm all feature boundaries.

- [X] T035 [P] Regenerate the skill catalog and generated adapters from `.highway/catalog/index.json`, `.github/skills/highway-relationships/SKILL.md`, `.claude/skills/highway-relationships/SKILL.md`, and `.cursor/rules/highway-relationships.mdc` using the repository generators
- [X] T036 [P] Update `.highway/tools/.adapter-manifest` and `.highway/tools/.distribution-manifest` for the new skill and verify generated correspondence
- [X] T037 Run `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/distribution-packaging.test.sh`, and `.highway/tools/tests/shipped-tree-independence.test.sh` after generated surfaces are updated
- [X] T038 Run `/bin/bash .highway/tools/tests/relationship-integrity.test.sh` and `/bin/bash .highway/tools/tests/run-all.sh` and resolve only Feature 031 failures
- [X] T039 Run `/bin/bash .highway/tools/validate-skill.sh .highway/skills/highway-relationships`, validators for modified existing skills, and `git diff --check`
- [X] T040 Verify `specs/031-relationship-reconciliation-integrity/quickstart.md` end-to-end using disposable governance fixtures and record the final validation result
- [X] T041 Confirm Feature 030 one-way Control-derived NFR behavior and direct NFR `controls: []` behavior remain unchanged in `.highway/tools/tests/relationship-integrity.test.sh` and the full test suite

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the skill, fixture, and test paths.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user stories because every workflow uses the shared graph parser, ordering, and failure boundary.
- **User Story 1 (Phase 3)**: Depends on Foundational; provides the read-only graph inspection baseline.
- **User Story 2 (Phase 4)**: Depends on Foundational and reuses US1 classifications; US1 inspection behavior should remain passing while repair is added.
- **User Story 3 (Phase 5)**: Depends on Foundational; can be implemented after Setup in parallel with US1/US2, but final integration depends on the shared relationship contract.
- **User Story 4 (Phase 6)**: Depends on Foundational and the report/proposal shapes from US1/US2; validates cross-story determinism.
- **Polish (Phase 7)**: Depends on all desired user stories and updates generated surfaces only after source changes stabilize.

### User Story Dependencies

- **US1 (P1)**: Depends only on Phase 2; MVP and first independently testable increment.
- **US2 (P1)**: Depends on Phase 2 and the finding classifications established by US1; repair remains independently testable through its own fixtures.
- **US3 (P1)**: Depends only on Phase 2 for impact analysis; Control/NFR routing edits should be coordinated with US2 to preserve write ownership.
- **US4 (P2)**: Depends on the stable report/proposal contracts from US1 and US2; it is a cross-cutting validation story rather than a prerequisite for inspection.

### Parallel Opportunities

- T001, T002, and T003 can run in parallel.
- T005 and T006 can run in parallel as documentation contracts; T009 can proceed independently once fixture paths exist.
- US1 fixture/test preparation (T011-T012), US3 fixture/test preparation (T024-T025), and US4 fixture/test preparation (T030-T031) can run in parallel after Phase 2.
- T027 and T028 can run in parallel because they modify different existing skill files.
- T035 and T036 can run in parallel only after the source skill and generated artifact inputs are complete.
- US1 and US3 implementation can be developed in parallel after Phase 2; US2 should follow the shared finding behavior, while US4 follows report/proposal stabilization.

### Parallel Example: User Story 1

```text
Task: T011 Add valid, orphan, malformed-ID, wrong-type, asymmetric, duplicate, and direct-NFR fixtures
Task: T012 Add read-only integrity-report assertions

After T011/T012:
Task: T013 Implement graph traversal and target validation
Task: T014 Implement relationship finding classifications
Task: T015 Implement deterministic report sections
Task: T016 Add no-write and direct-NFR assertions
```

### Parallel Example: User Story 3

```text
Task: T024 Add destructive-impact fixtures
Task: T025 Add impact-analysis assertions

After the shared impact contract is agreed:
Task: T027 Update highway-controls destructive routing
Task: T028 Update highway-nfrs destructive routing
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Complete US1 inspection traversal, classification, deterministic report, and no-write tests.
3. Run the focused relationship test and stop for independent validation.
4. Add US2 repair only after read-only inspection behavior is stable.

### Incremental Delivery

1. Deliver read-only inspection as the first usable increment.
2. Add proposal-first repair with explicit approval and atomic writes.
3. Add destructive impact preflight while preserving existing artifact owners.
4. Add deterministic repeated-run checks and generated packaging validation.

### Final Validation

Run the focused relationship test, modified-skill validators, adapter correspondence, distribution
packaging, shipped-tree independence, full test suite, quickstart scenarios, and `git diff --check`.
No `tasks.md` task should add a second relationship store, alter immutable IDs, edit governance
wording during repair, or bypass explicit confirmation.
