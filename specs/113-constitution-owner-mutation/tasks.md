---

description: "Task list for the Constitution owner mutation boundary amendment"
---

# Tasks: Constitution Owner Mutation Boundary

**Input**: Design documents from `/specs/113-constitution-owner-mutation/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Validation tasks are included because the feature specification requires the existing
full suite and focused textual and changed-path audits.

**Implementation target**: `.highway/governance/constitution.md` only.

## Phase 1: Setup (Baseline)

**Purpose**: Confirm the repository baseline and the current Constitution contract before editing.

- [X] T001 [P] Run the baseline validation suite with `.highway/tools/tests/run-all.sh` before editing `.highway/governance/constitution.md`.
- [X] T002 [P] Capture the existing Principle XII rows, precedence entry, rule counts, and version metadata from `.highway/governance/constitution.md` for comparison during implementation.

---

## Phase 2: Foundational (Change-Scope Guardrails)

**Purpose**: Establish the preservation and scope constraints that all amendment work must satisfy.

- [X] T003 Confirm P12.5 through P12.12 remain byte-for-byte unchanged in `.highway/governance/constitution.md` after each Principle XII edit.
- [X] T004 Confirm the implementation change set contains only `.highway/governance/constitution.md`, excluding skills, templates, and `.highway/governance/experience-standard.md`.

**Checkpoint**: The amendment can proceed with the preserved owner boundaries and single-file scope established.

---

## Phase 3: User Story 1 - Require Owner Mutation Before Dependent Results (Priority: P1) 🎯 MVP

**Goal**: Add an explicit, agent-checkable requirement that an owner mutation precedes any dependent owner result.

**Independent Test**: Inspect P12.13 in `.highway/governance/constitution.md` and verify its rule, observable, and `[agent-checkable]` tier make the mutation-before-result ordering decidable.

### Implementation for User Story 1

- [X] T005 [US1] Add P12.13 to `.highway/governance/constitution.md` with one mutation-before-dependent-result obligation, an observable stating the mutation occurs first, and the `[agent-checkable]` tier.

**Checkpoint**: P12.13 explicitly prevents an owner from reporting a dependent result before its accepted mutation occurs.

---

## Phase 4: User Story 2 - Keep Acceptance, Mutation, Result, and Completion Distinct (Priority: P1)

**Goal**: Distinguish acceptance authorization from owner mutation and require every required owner’s terminal result before orchestration completion.

**Independent Test**: Inspect P12.14, P12.15, and the persistence boundary clarification in `.highway/governance/constitution.md`; verify acceptance waits for the owning skill’s declared result, completion follows all required terminal results, and no post-write verification stage is introduced.

### Implementation for User Story 2

- [X] T006 [US2] Add P12.14 to `.highway/governance/constitution.md` with one acceptance-versus-mutation-result obligation, an observable requiring the owning skill’s declared result, and the `[agent-checkable]` tier.
- [X] T007 [US2] Add P12.15 to `.highway/governance/constitution.md` with one terminal-result completion obligation, an observable placing the Completion Claim after every required owner result, and the `[agent-checkable]` tier.
- [X] T008 [US2] Add the non-normative acceptance-to-owner-result persistence boundary clarification to `.highway/governance/constitution.md`, explicitly excluding post-write Persistence Verification and related read-back checks.

**Checkpoint**: The Constitution distinguishes acceptance → owner mutation → owner result → orchestration and does not require post-write verification.

---

## Phase 5: User Story 3 - Preserve Constitution Scope and Owner Boundaries (Priority: P1)

**Goal**: Synchronize amendment metadata while preserving existing owner-control rules and keeping Experience Standard behavior out of scope.

**Independent Test**: Compare `.highway/governance/constitution.md` with its pre-amendment baseline and audit `git diff --name-only`; verify P12.5–P12.12 are unchanged and no other implementation path is modified.

### Implementation for User Story 3

- [X] T009 [US3] Update the Sync Impact Report in `.highway/governance/constitution.md` to classify the amendment as MAJOR and identify P12.13–P12.15.
- [X] T010 [US3] Update the Principle XII rationale, rank-5 precedence reason, rule counts, and internal references in `.highway/governance/constitution.md` to mention owner mutation, readiness, results, and orchestrator advancement while retaining precedence rank 5.
- [X] T011 [US3] Update the version and self-application metadata in `.highway/governance/constitution.md` from `5.0.0` to `6.0.0`, including review coverage for P1.1–P1.4, P6.4, P6.6, and P7.3.

**Checkpoint**: Only the Constitution is amended; existing owner boundaries and Experience Standard scope remain intact.

---

## Phase 6: Polish & Cross-Cutting Validation

**Purpose**: Verify the completed amendment against the feature contract and repository checks.

- [X] T012 [P] Audit `.highway/governance/constitution.md` for exactly three new Principle XII rules, one keyword per new rule, one observable per new rule, and `[agent-checkable]` tiers.
- [X] T013 [P] Audit `.highway/governance/constitution.md` for absent recommendation, presentation, domain-wrap-up, question-order, and Setup transition rules.
- [X] T014 Run `.highway/tools/tests/run-all.sh`, `git diff --check`, and `git diff --name-only`; record the suite result and confirm the only implementation path is `.highway/governance/constitution.md`.
- [X] T015 Validate the final amendment against `specs/113-constitution-owner-mutation/quickstart.md`, reporting suite status, rule-count/version synchronization, self-application review, and exclusions.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 and T002 can run in parallel; both precede amendment work.
- **Foundational (Phase 2)**: T003 and T004 establish preservation and scope guardrails before implementation.
- **User Stories (Phases 3–5)**: Execute in order because all changes target `.highway/governance/constitution.md`; T005 precedes T006–T008, which precede T009–T011.
- **Polish (Phase 6)**: T012–T015 run after all amendment edits; T012 and T013 can run in parallel.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Phase 2; no dependency on another story’s semantics.
- **User Story 2 (P1)**: Depends on US1’s Principle XII placement and preserved owner rows.
- **User Story 3 (P1)**: Depends on US1 and US2 so metadata and counts reflect the complete rule set.

### Parallel Opportunities

- T001 and T002 can run in parallel.
- T012 and T013 can run in parallel after implementation.
- No implementation tasks are parallelizable because the three stories modify one governed document and must preserve its synchronized metadata.

## Parallel Example: Validation

```text
Task: Audit .highway/governance/constitution.md for the three new Principle XII rule contracts.
Task: Audit .highway/governance/constitution.md for excluded Experience Standard behavior.
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Add and validate P12.13 in Phase 3.
3. Stop and verify the mutation-before-result observable independently.

### Incremental Delivery

1. Complete the baseline and scope guardrails.
2. Add P12.13 for mutation ordering.
3. Add P12.14, P12.15, and the persistence boundary clarification.
4. Synchronize metadata and run the full validation audit.

## Notes

- Every task uses the required checkbox, sequential ID, optional parallel marker, and story label where applicable.
- Paths identify the governed Constitution, validation tools, and feature evidence.
- The final artifact must not modify skills, templates, or the Experience Standard.
- Validation note: `.highway/tools/tests/run-all.sh` passed with 62 tests and 0 failures;
  focused Constitution audits and `git diff --check` also passed.
