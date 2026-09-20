# Tasks: Discovery Contract Completion

**Input**: Design documents from `/specs/051-discovery-contract-completion/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/), [quickstart.md](quickstart.md)

**Scope**: Complete the registered Discovery skill contract at `.github/skills/highway-discovery/SKILL.md` and its focused contract test at `.highway/tools/tests/highway-discovery.test.sh`. No runtime module, package, generator, distribution manifest, or ADR implementation is introduced.

## Phase 1: Setup

**Purpose**: Establish the implementation baseline and exact validation surface.

- [X] T001 Confirm Feature 051 design inputs and current shipped Discovery skill path in `specs/051-discovery-contract-completion/plan.md`, `specs/051-discovery-contract-completion/spec.md`, and `.github/skills/highway-discovery/SKILL.md`
- [X] T002 [P] Record the current focused Discovery contract-test baseline by running `.highway/tools/tests/highway-discovery.test.sh`
- [X] T003 [P] Review shared Discovery record and catalog templates referenced by `.github/skills/highway-discovery/SKILL.md` at `.highway/library/templates/output/discovery-record.md` and `.highway/library/templates/output/discovery-catalog.md`

## Phase 2: Foundational

**Purpose**: Prepare shared contract assertions and preserve repository governance boundaries before story-specific edits.

- [X] T004 Add Feature 051 structural token assertions for the required Discovery sections to `.highway/tools/tests/highway-discovery.test.sh`
- [X] T005 Add focused test assertions for no-output-on-failure, unchanged baselines, and ADR ownership invariants to `.highway/tools/tests/highway-discovery.test.sh`
- [X] T006 Verify the implementation remains documentation-only and does not modify `.highway/tools/generate-agent-adapters.sh`, `.highway/catalog/`, package manifests, or ADR skills

**Checkpoint: Foundation ready**: Shared validation assertions and implementation boundaries are ready; user story work can proceed.

## Phase 3: User Story 1 - Produce a valid Discovery output contract (Priority: P1) 🎯 MVP

**Goal**: Restore a complete, readable Outputs contract for the user-owned Discovery record, catalog, completion response, required sections, template dependency, and no-output failure boundary.

**Independent Test**: Inspect `.github/skills/highway-discovery/SKILL.md` and confirm the Outputs contract names `discoveries/DISCXXXXXX.md`, `discoveries/discoveries.md`, all required record sections in shared-template order, the four completion response fields, and the no-output failure rule; run `.highway/tools/tests/highway-discovery.test.sh`.

### Tests for User Story 1

- [X] T007 [P] [US1] Add output-contract assertions for record path, catalog path, required sections, completion response fields, shared catalog template, and no-output failure behavior in `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 1

- [X] T008 [US1] Replace the malformed `## Outputs` section with the complete output contract in `.github/skills/highway-discovery/SKILL.md`
- [X] T009 [US1] Preserve the existing ADR Handoff boundary while aligning output ownership, template order, and failure wording in `.github/skills/highway-discovery/SKILL.md`
- [X] T010 [US1] Run the focused output-contract validation and verify `.github/skills/highway-discovery/SKILL.md` passes `.highway/tools/tests/highway-discovery.test.sh`

**Checkpoint: User Story 1**: This story independently delivers a complete Discovery output contract and preserves no-write failure semantics.

## Phase 4: User Story 2 - Evaluate Reference Implementations explicitly and deterministically (Priority: P1)

**Goal**: Define explicit Reference Architecture matching, unique Reference Implementation counting, malformed and unavailable handling, catalog inconsistency handling, zero-count fallbacks, and traceable advisory evidence.

**Independent Test**: Review `.github/skills/highway-discovery/SKILL.md` and confirm both explicit matching conditions, exclusion of semantic inference, unique stable-identifier counting, malformed/unreadable/absent/inconsistent catalog behavior, unresolved-reference non-match behavior, and traceability-only evidence; run `.highway/tools/tests/highway-discovery.test.sh`.

### Tests for User Story 2

- [X] T011 [P] [US2] Add matching assertions for explicit Reference Architecture references and explicit architecture identifiers, with negative assertions for semantic similarity, inference, approximation, and similarity scoring, in `.highway/tools/tests/highway-discovery.test.sh`
- [X] T012 [P] [US2] Add counting and failure assertions for unique stable identifiers, duplicate paths, malformed artifacts, missing or unreadable implementations, absent or unreadable catalogs, inconsistent catalogs, zero counts, and unresolved references in `.highway/tools/tests/highway-discovery.test.sh`
- [X] T013 [P] [US2] Add traceability assertions that Reference Implementation matches indicate artifact existence only and exclude endorsement, approval, suitability, correctness, and authorization in `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 2

- [X] T014 [US2] Add a `## Reference Implementation Matching` section with the two explicit match conditions and prohibited inference rules to `.github/skills/highway-discovery/SKILL.md`
- [X] T015 [US2] Add a `## Reference Implementation Counting` section defining unique stable-identifier counts, duplicate suppression, zero contributions, malformed exclusion, and multi-architecture highest-count behavior to `.github/skills/highway-discovery/SKILL.md`
- [X] T016 [US2] Add a `## Reference Implementation Determinism` section covering identical closed inputs, excluded time and environment inputs, and stable matches and counts to `.github/skills/highway-discovery/SKILL.md`
- [X] T017 [US2] Add a `## Reference Implementation Scope Clarification` section separating included advisory evaluation from excluded recommendation, approval, authorization, governance, and ADR responsibilities in `.github/skills/highway-discovery/SKILL.md`
- [X] T018 [US2] Add a `## Reference Implementation Traceability` section defining artifact-existence evidence and explicitly preserving ADR decision ownership in `.github/skills/highway-discovery/SKILL.md`
- [X] T019 [US2] Update the Discovery workflow and error handling in `.github/skills/highway-discovery/SKILL.md` to evaluate Reference Implementation data only after score and Reference Architecture evaluation, use it exclusively for deterministic tie-breaking, continue on optional evidence failures, record blocking reasons, and preserve source bytes
- [X] T020 [US2] Run the focused matching, counting, determinism, scope, traceability, and error-handling validation in `.highway/tools/tests/highway-discovery.test.sh`

**Checkpoint: User Story 2**: This story independently provides explicit, unique, deterministic, advisory implementation evidence with defined failure behavior.

## Phase 5: User Story 3 - Resolve ties without changing recommendation authority (Priority: P1)

**Goal**: Formalize ordered tie-break evaluation, early stopping, score and confidence preservation, and the unchanged ADR ownership boundary.

**Independent Test**: Review `.github/skills/highway-discovery/SKILL.md` and confirm tied options are evaluated by Reference Architecture Match, then Reference Implementation Count, then lowest `OPT`; evaluation stops after a winner; score, confidence, rationale, and ADR ownership remain unchanged; run the focused test and full suite.

### Tests for User Story 3

- [X] T021 [P] [US3] Add tie-break assertions for criterion order, architecture-match precedence, highest count across multiple architectures, lowest `OPT` fallback, and immediate stopping in `.highway/tools/tests/highway-discovery.test.sh`
- [X] T022 [P] [US3] Add invariant assertions for unchanged Recommendation score, confidence, rationale, ranking outside tie-breaking, and ADR ownership in `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 3

- [X] T023 [US3] Replace the partial Reference Implementation tie-break wording with a `## Recommendation Tie-Break Evaluation` section that states the trigger, ordered criteria, early stop, and multi-architecture highest-count rule in `.github/skills/highway-discovery/SKILL.md`
- [X] T024 [US3] Add `## Verification Expectations` covering explicit matching, unique counting, malformed exclusion, zero counts, score and confidence preservation, tie order, immediate stopping, deterministic repetition, and ADR ownership in `.github/skills/highway-discovery/SKILL.md`
- [X] T025 [US3] Add `## Error Handling Expectations` covering malformed, unreadable, duplicate-path, absent, unreadable, inconsistent-catalog, and match-failure behavior in `.github/skills/highway-discovery/SKILL.md`
- [X] T026 [US3] Verify the exact workflow sentence `Reference Implementation data is evaluated only according to the Reference Implementation Evaluation rules and is used exclusively for deterministic tie-breaking.` appears in `.github/skills/highway-discovery/SKILL.md`
- [X] T027 [US3] Run the focused tie-break contract validation and the full repository suite using `perl -e 'alarm shift; exec @ARGV' 300 ./.highway/tools/tests/highway-discovery.test.sh` and `perl -e 'alarm shift; exec @ARGV' 300 ./.highway/tools/tests/run-all.sh`

**Checkpoint: User Story 3**: This story independently delivers deterministic tie-breaking without changing recommendation semantics or ADR authority.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Reconcile the implementation with all Feature 051 artifacts and perform final repository checks.

- [X] T028 [P] Reconcile `.github/skills/highway-discovery/SKILL.md` against `specs/051-discovery-contract-completion/spec.md` and the three contracts under `specs/051-discovery-contract-completion/contracts/`
- [X] T029 [P] Validate all task-referenced paths, Markdown structure, and whitespace with `git diff --check` and the Feature 051 quickstart commands in `specs/051-discovery-contract-completion/quickstart.md`
- [X] T030 Confirm no generated artifacts, package manifests, distribution files, ADR records, governance baselines, or unrelated files changed with `git status --short` and `git diff --stat` for `.github/skills/highway-discovery/SKILL.md`, `.highway/tools/tests/highway-discovery.test.sh`, and `specs/051-discovery-contract-completion/`

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T002 and T003 can run in parallel after T001 identifies the active paths.
- **Foundational (Phase 2)**: Depends on T001; T004-T006 establish shared assertions and boundaries before story edits.
- **User Story 1 (Phase 3)**: Depends on Phase 2; MVP output contract can be implemented and tested independently.
- **User Story 2 (Phase 4)**: Depends on Phase 2 and benefits from US1's restored output terminology; its matching/counting contract is independently testable.
- **User Story 3 (Phase 5)**: Depends on US2's matching/counting terminology; its tie-break contract is independently testable after US2.
- **Polish (Phase 6)**: Depends on all required story phases and final focused validation.

### User Story Dependencies

- **US1 (P1)**: Can start after Phase 2; no dependency on another story.
- **US2 (P1)**: Can start after Phase 2; implementation terminology should align with US1's restored Outputs contract.
- **US3 (P1)**: Depends on US2's explicit matching and counting contract because tie-breaking consumes those derived values.

## Parallel Opportunities

- T002 and T003 can run in parallel after the path confirmation task.
- T004-T006 can be performed in parallel because they touch separate validation/boundary concerns, subject to avoiding concurrent edits to the same test file.
- T011-T013 can be drafted in parallel conceptually, then consolidated into `.highway/tools/tests/highway-discovery.test.sh` to avoid file conflicts.
- T014-T018 cover distinct contract sections and can be prepared in parallel, then applied as one ordered edit to `.github/skills/highway-discovery/SKILL.md`.
- T021 and T022 can be prepared in parallel before the tie-break implementation.
- T028-T030 can be reviewed in parallel after implementation and validation.

## Parallel Example: User Story 1

```text
Task T007: Add output-contract assertions in .highway/tools/tests/highway-discovery.test.sh
Task T008: Replace malformed Outputs in .github/skills/highway-discovery/SKILL.md
```

## Parallel Example: User Story 2

```text
Task T011: Add explicit matching assertions in .highway/tools/tests/highway-discovery.test.sh
Task T012: Add unique counting and failure assertions in .highway/tools/tests/highway-discovery.test.sh
Task T013: Add traceability assertions in .highway/tools/tests/highway-discovery.test.sh
Task T014: Add Reference Implementation Matching in .github/skills/highway-discovery/SKILL.md
Task T015: Add Reference Implementation Counting in .github/skills/highway-discovery/SKILL.md
```

## Parallel Example: User Story 3

```text
Task T021: Add tie-break order and early-stop assertions in .highway/tools/tests/highway-discovery.test.sh
Task T022: Add score, confidence, rationale, and ADR invariants in .highway/tools/tests/highway-discovery.test.sh
Task T023: Add Recommendation Tie-Break Evaluation in .github/skills/highway-discovery/SKILL.md
Task T024: Add Verification Expectations in .github/skills/highway-discovery/SKILL.md
Task T025: Add Error Handling Expectations in .github/skills/highway-discovery/SKILL.md
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 setup and Phase 2 foundational assertions.
2. Replace the malformed Outputs section in the registered Discovery skill.
3. Run the focused Discovery contract test.
4. Stop at the US1 checkpoint for review; this establishes a valid output contract without changing ADR authority.

### Incremental Delivery

1. Deliver US1 output-contract restoration and validate it independently.
2. Deliver US2 explicit matching, unique counting, deterministic evidence, and failure behavior.
3. Deliver US3 ordered tie-breaking, early stop, invariant preservation, and complete verification/error sections.
4. Run the focused and full suites, then reconcile the skill against the Feature 051 contracts.

### Parallel Team Strategy

1. One contributor owns the shared test assertions and baseline checks.
2. One contributor owns the ordered edits to `.github/skills/highway-discovery/SKILL.md` for US1 and US2.
3. A second contributor can review the tie-break, verification, and error-handling contract for US3 after US2 terminology is established.
4. Consolidate same-file edits before running the focused and full suites.

## Notes

- Every task uses the required `- [ ] T###` checklist format.
- `[P]` marks only tasks that can be prepared independently without incomplete-task dependencies.
- `[US1]`, `[US2]`, and `[US3]` map directly to the three P1 stories in `spec.md`.
- Tests are included because Feature 051 explicitly requires verification of the listed behaviors.
- No task creates an ADR, makes a decision, authorizes implementation, or mutates governance baselines.
