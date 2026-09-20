---

# Tasks: Reference Implementation Evaluation

**Input**: Design documents from `/specs/050-reference-implementation-evaluation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: No new test-first tasks are required by the specification. Existing shell harness and structural checks are used for validation.

**Organization**: Tasks are grouped by user story to support independent documentation delivery and validation.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the Feature 050 record and confirm the documentation-only implementation boundary.

- [X] T001 Confirm Feature 050 registration resolves to `specs/050-reference-implementation-evaluation/` in `.specify/feature.json`
- [X] T002 [P] Review the source decisions and project structure in `specs/050-reference-implementation-evaluation/plan.md` and `specs/050-reference-implementation-evaluation/research.md`
- [X] T003 [P] Inventory the required Feature 050 artifacts under `specs/050-reference-implementation-evaluation/` and record any missing document before editing

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Align the shared data vocabulary and failure semantics before either user story is completed.

**Checkpoint**: Shared Reference Implementation entities, malformed-artifact rules, unavailable-catalog behavior, and advisory boundaries are established.

- [X] T004 Define the stable identifier, required fields, catalog authority, Reference Architecture Match, and derived count semantics in `specs/050-reference-implementation-evaluation/data-model.md`
- [X] T005 [P] Align structural malformed, unresolved-reference, duplicate-catalog, unreadable-catalog, and non-mutation rules in `specs/050-reference-implementation-evaluation/contracts/reference-implementation-evaluation-contract.md`
- [X] T006 [P] Confirm the documentation-only scope, no-new-dependency constraint, and post-design constitution result in `specs/050-reference-implementation-evaluation/plan.md`

---

## Phase 3: User Story 1 - Evaluate implementation evidence deterministically (Priority: P1) MVP

**Goal**: Document deterministic explicit-reference matching, unique implementation counting, malformed-artifact exclusion, and valid unavailable states for Discovery evidence.

**Independent Test**: With identical Discovery inputs and Reference Implementation baselines, the documented rules produce identical matches and unique counts; missing, unreadable, malformed, unresolved, and duplicate cases continue without treating implementation evidence as a score input.

### Implementation for User Story 1

- [X] T007 [US1] Specify explicit Reference Architecture matching, semantic-matching exclusion, unique stable-identifier counting, and highest-per-architecture aggregation in `specs/050-reference-implementation-evaluation/spec.md`
- [X] T008 [US1] Document the Reference Implementation and authoritative catalog entities, validations, and derived values in `specs/050-reference-implementation-evaluation/data-model.md`
- [X] T009 [US1] Document matching inputs, malformed-artifact exclusion reasons, catalog failure behavior, count output evidence, and non-mutation guarantees in `specs/050-reference-implementation-evaluation/contracts/reference-implementation-evaluation-contract.md`
- [X] T010 [US1] Add executable structural and behavioral scenarios for explicit references, duplicate paths, malformed artifacts, unresolved references, and unavailable catalogs to `specs/050-reference-implementation-evaluation/quickstart.md`

**Checkpoint**: User Story 1 is independently complete when the specification, data model, evaluation contract, and quickstart scenarios agree on deterministic matching and counting.

---

## Phase 4: User Story 2 - Resolve recommendation ties without changing scores (Priority: P1)

**Goal**: Document the ordered advisory tie-break and preserve Recommendation score, confidence, rationale, and ADR ownership boundaries.

**Independent Test**: Given tied Recommendation scores, the documented evaluation selects by Reference Architecture Match, then Reference Implementation Count, then lowest Discovery-scoped `OPT`; evaluation stops after a winner and implementation evidence does not alter score, confidence, rationale, or ADR authority.

### Implementation for User Story 2

- [X] T011 [P] [US2] Specify the tie-break trigger, ordered criteria, immediate-stop rule, multi-architecture maximum-count rule, and unchanged Recommendation fields in `specs/050-reference-implementation-evaluation/spec.md`
- [X] T012 [P] [US2] Define the ordered tie-break contract, equal-count fallback, determinism invariant, and ADR ownership invariant in `specs/050-reference-implementation-evaluation/contracts/recommendation-tie-break-contract.md`
- [X] T013 [US2] Add tie-break order, early-stop, score/confidence preservation, and advisory ADR handoff scenarios to `specs/050-reference-implementation-evaluation/quickstart.md`

**Checkpoint**: User Stories 1 and 2 are independently complete when the matching/counting contract and tie-break contract can be reviewed and validated without changing shipped Discovery or ADR implementation files.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Validate correspondence, completeness, and repository compatibility for the final documentation set.

- [X] T014 [P] Reconcile requirements coverage and mark the reviewer checklist in `specs/050-reference-implementation-evaluation/checklists/requirements.md`
- [X] T015 Run the Feature 050 structural checks from `specs/050-reference-implementation-evaluation/quickstart.md` and resolve any documentation inconsistency
- [X] T016 Run `./.highway/tools/tests/highway-discovery.test.sh` and record the focused result against the scenarios in `specs/050-reference-implementation-evaluation/quickstart.md`
- [X] T017 Run `./.highway/tools/tests/run-all.sh` and record any unrelated pre-existing failures without changing files outside `specs/050-reference-implementation-evaluation/`
- [X] T018 Run `git diff --check` and perform final cross-artifact review across `specs/050-reference-implementation-evaluation/spec.md`, `specs/050-reference-implementation-evaluation/plan.md`, `specs/050-reference-implementation-evaluation/data-model.md`, `specs/050-reference-implementation-evaluation/contracts/`, and `specs/050-reference-implementation-evaluation/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T001 must establish the Feature 050 registration before path-based checks.
- **Foundational (Phase 2)**: Depends on Setup; T004-T006 establish shared semantics and scope before story work.
- **User Story 1 (Phase 3)**: Depends on Phase 2; independently delivers matching and counting evidence.
- **User Story 2 (Phase 4)**: Depends on Phase 2 and may run in parallel with User Story 1; it consumes the shared count vocabulary but does not require US1 completion.
- **Polish (Phase 5)**: Depends on both user story phases; final checks cover the complete artifact set.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Phase 2; no dependency on User Story 2.
- **User Story 2 (P1)**: Can start after Phase 2; uses the shared data model and can proceed in parallel with User Story 1.

### Within Each User Story

- Update the specification and contracts from the shared foundation.
- Align the data model or quickstart scenarios with the contract.
- Complete the story checkpoint before final cross-cutting validation.

### Parallel Opportunities

- T002 and T003 can run in parallel after registration is confirmed.
- T005 and T006 can run in parallel after T004 establishes the shared vocabulary.
- T011 and T012 can run in parallel after Phase 2; T013 follows their agreed semantics.
- After Phase 2, US1 and US2 can be assigned to separate contributors because they touch separate contract/spec sections and have independent acceptance criteria.
- T014 and T018 can run in parallel after both stories are complete; T015-T017 are executable validation tasks that should run before final sign-off.

---

## Parallel Example: User Story 1

```text
Task: T007 Specify explicit matching and counting rules in specs/050-reference-implementation-evaluation/spec.md
Task: T009 Align the evaluation contract in specs/050-reference-implementation-evaluation/contracts/reference-implementation-evaluation-contract.md
```

T008 should follow the shared foundation and T007/T009 should be reconciled before T010 is finalized.

## Parallel Example: User Story 2

```text
Task: T011 Specify tie-break behavior in specs/050-reference-implementation-evaluation/spec.md
Task: T012 Define the tie-break contract in specs/050-reference-implementation-evaluation/contracts/recommendation-tie-break-contract.md
```

T013 should follow both tie-break definitions so the quickstart validates the same ordered criteria.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Run the focused Discovery and structural checks from `specs/050-reference-implementation-evaluation/quickstart.md`.
5. Stop for review if deterministic matching and unique counting are sufficient for the first documentation increment.

### Incremental Delivery

1. Complete Setup and Foundational phases.
2. Deliver User Story 1 as the matching/counting MVP.
3. Deliver User Story 2 as the ordered tie-break and ADR-boundary increment.
4. Complete Polish and cross-artifact validation.

### Parallel Team Strategy

1. Complete Setup and Foundational together.
2. Assign User Story 1 and User Story 2 to separate contributors after Phase 2.
3. Reconcile shared terminology and run the final validation phase together.

## Notes

- `[P]` tasks use different files or independent review surfaces and have no dependency on incomplete work.
- `[US1]` and `[US2]` labels map tasks to the two P1 stories in `spec.md`.
- This feature adds no shipped code, runtime dependency, generator input, or external interface.
- Existing shell tests validate repository compatibility; they do not replace review of the documentation contracts.
