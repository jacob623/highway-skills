---

description: "Task list for the Constitution runtime boundary amendment"
---

# Tasks: Constitution Runtime Boundary

**Input**: Design documents from `/specs/145-constitution-runtime-boundary/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/constitution-development-boundary.md, quickstart.md

**Tests**: Focused validation tasks are included because the specification requires independently verifiable inventory, coverage, rule, alignment, and self-application outcomes.

## Phase 1: Setup

**Purpose**: Establish the amendment baseline and protected-file boundary.

- [X] T001 Review Feature 145 design artifacts and current `.highway/governance/constitution.md` amendment history before editing the Constitution
- [X] T002 [P] Record the protected runtime files and downstream-reference inventory in `specs/145-constitution-runtime-boundary/research.md`
- [X] T003 [P] Confirm the existing Constitution validator entry points and Bash portability assumptions in `specs/145-constitution-runtime-boundary/quickstart.md`

---

## Phase 2: Foundational

**Purpose**: Define the Layer 0 -> Layer 1 -> Layer 2 boundary and amendment accounting before story-specific edits.

- [X] T004 Update the Constitution Sync Impact Report and version footer from 7.0.0 to the reviewed MAJOR version in `.highway/governance/constitution.md`
- [X] T005 Define the development-only scope, non-runtime dependency boundary, protected runtime ownership, and development-time Experience Compliance contract in `.highway/governance/constitution.md`
- [X] T006 Add the complete retired/redefined rule-ID and downstream-reference accounting to the Constitution Sync Impact Report in `.highway/governance/constitution.md`

**Checkpoint**: The amendment has an explicit version, dependency direction, scope boundary, and retirement record before rule prose is changed.

---

## Phase 3: User Story 1 - Govern shipped skills during development (Priority: P1)

**Goal**: Make the Constitution a development validator for shipped skills and shared runtime contracts, never a runtime dependency.

**Independent Test**: Inspect the Constitution opening scope, definitions, Governance, precedence, and self-application text; run the Constitution inventory and alignment checks.

### Tests for User Story 1

- [X] T007 [P] [US1] Update development-boundary assertions for scope, runtime exclusion, governance ownership, and precedence in `.highway/tools/tests/constitution-experience-alignment.test.sh`
- [X] T008 [P] [US1] Add or update a static Constitution-only boundary check for protected runtime dependency language in `.highway/tools/tests/constitution-inventory.test.sh`

### Implementation for User Story 1

- [X] T009 [US1] Rewrite the Constitution opening scope, Definitions needed for development validation, Principle Precedence, Governance, and Self-Application sections in `.highway/governance/constitution.md`
- [X] T010 [US1] Preserve development validation requirements for structure, contracts, ownership, versioning, observables, tiers, and Experience Compliance without introducing runtime consultation in `.highway/governance/constitution.md`

**Checkpoint**: User Story 1 is independently verifiable without changing the Experience Standard or any skill.

---

## Phase 4: User Story 2 - Preserve correctness-critical determinism (Priority: P1)

**Goal**: Keep repeatable correctness requirements while allowing bounded variation in advisory reasoning.

**Independent Test**: Review Principle VI and its precedence rationale, classify representative contractual and advisory cases, and run rule/inventory validation.

### Tests for User Story 2

- [X] T011 [P] [US2] Update Constitution alignment assertions for Principle VI deterministic contract scope and advisory variation in `.highway/tools/tests/constitution-experience-alignment.test.sh`
- [X] T012 [P] [US2] Verify existing static assertions and focused checks reject stale runtime action-selection determinism wording while requiring correctness-critical determinism in `.highway/tools/tests/constitution-inventory.test.sh`

### Implementation for User Story 2

- [X] T013 [US2] Rewrite Principle VI, its rationale, observables, and precedence rationale to separate contractual determinism from adaptive advisory reasoning in `.highway/governance/constitution.md`
- [X] T014 [US2] Preserve deterministic state, mutation, persistence, ownership, routing, readiness, identifiers, artifact, output, destructive-action, outcome, and contractually generated-content safeguards in `.highway/governance/constitution.md`

**Checkpoint**: User Story 2 is independently verifiable and does not weaken authoritative correctness safeguards.

---

## Phase 5: User Story 3 - Keep runtime interaction ownership with the Experience Standard (Priority: P1)

**Goal**: Retain development-time Experience Compliance while removing Constitution-owned runtime collaboration and convergence semantics.

**Independent Test**: Confirm generic interaction concepts are delegated or removed, Experience Compliance remains a development check, and the Constitution does not prescribe runtime clarification or convergence.

### Tests for User Story 3

- [X] T015 [P] [US3] Replace old collaborative-interaction assertions with delegation and non-duplication assertions in `.highway/tools/tests/constitution-experience-alignment.test.sh`
- [X] T016 [P] [US3] Verify the existing stale-current-section checks for Constitution-owned collaboration, clarification, convergence, and runtime interaction prose in `.highway/tools/tests/constitution-inventory.test.sh`

### Implementation for User Story 3

- [X] T017 [US3] Remove or narrow Principle XIII and its runtime collaboration definitions so only development validation/delegation remains in `.highway/governance/constitution.md`
- [X] T018 [US3] Remove duplicate Experience-owned runtime interaction language while preserving Experience rule citation, exception accountability, and development compliance in `.highway/governance/constitution.md`

**Checkpoint**: User Story 3 is independently verifiable and leaves `.highway/governance/experience-standard.md` untouched.

---

## Phase 6: User Story 4 - Validate context and ownership without runtime governance (Priority: P1)

**Goal**: Preserve context, ownership, orchestration, failure, accepted-knowledge, and state-safety validation while assigning runtime mechanics to their owners.

**Independent Test**: Inspect Principles XI and XII and failure/ownership definitions, then run context and rule checks without editing downstream skills.

### Tests for User Story 4

- [X] T019 [P] [US4] Audit context-alignment assertions; record the protected Identity/Profile fixture failures without modifying `.highway/tools/tests/constitution-profile-context.test.sh`
- [X] T020 [P] [US4] Update failure/ownership assertions to require skill-owned failure behavior and reject Constitution runtime authority in `.highway/tools/tests/constitution-experience-alignment.test.sh`
- [X] T021 [P] [US4] Record downstream references for common failure model and retired context documents without mutating source skills in `specs/145-constitution-runtime-boundary/research.md`

### Implementation for User Story 4

- [X] T022 [US4] Rewrite Principle XI and context definitions to retain development declaration/ownership validation while removing retired context dependencies and behavioral-guidance claims in `.highway/governance/constitution.md`
- [X] T023 [US4] Rewrite Principle XII and failure/ownership definitions to preserve safe orchestration and false-success protections without a Constitution runtime common failure model in `.highway/governance/constitution.md`
- [X] T024 [US4] Remove or narrow runtime-only definitions and references for Agent, Repository Context, accepted knowledge, Working Ideas, proposals, behavior, participation, influence, and completion claims in `.highway/governance/constitution.md`

**Checkpoint**: User Story 4 is independently verifiable while downstream runtime references remain explicitly reported for later features.

---

## Phase 7: User Story 5 - Maintain a coherent constitutional artifact (Priority: P2)

**Goal**: Make inventory, tiers, observables, versioning, precedence, and self-application independently checkable after the amendment.

**Independent Test**: Run focused Constitution validation and inspect the complete amendment record for stale runtime-governance language and stable-ID accounting.

### Tests for User Story 5

- [X] T025 [P] [US5] Update expected rule counts, tier counts, version, retirement, and self-application assertions in `.highway/tools/tests/constitution-experience-alignment.test.sh`
- [X] T026 [P] [US5] Verify coverage and rule-check expectations for retired/redefined rule IDs and preserved auto-tier registration in `.highway/tools/tests/coverage-summary.test.sh`
- [X] T027 [P] [US5] Verify the Constitution source-document probe assertions for the revised boundary in `.highway/tools/tests/constitution-inventory.test.sh`

### Implementation for User Story 5

- [X] T028 [US5] Reconcile every surviving rule row, Observable, Tier, precedence rank, and retirement marker with the amended Constitution in `.highway/governance/constitution.md`
- [X] T029 [US5] Record downstream runtime references and protected-file non-changes in `specs/145-constitution-runtime-boundary/research.md` and `specs/145-constitution-runtime-boundary/quickstart.md`

**Checkpoint**: All Constitution-specific validation passes and all changed rule semantics are traceable.

---

## Phase 8: Polish & Cross-Cutting Validation

**Purpose**: Verify the complete feature, preserve scope discipline, and document remaining follow-up work.

- [X] T030 Run focused Constitution inventory, alignment, context, coverage, and rule-check tests from `specs/145-constitution-runtime-boundary/quickstart.md`
- [X] T031 Run `.highway/tools/tests/run-all.sh` and resolve only Feature 145 Constitution/test failures; report unrelated downstream failures without editing protected artifacts
- [X] T032 Verify the protected-file diff is empty, run `git diff --check`, and confirm all Feature 145 tasks are marked complete
- [X] T033 [P] Run the final downstream-reference audit and record any newly exposed follow-up paths in `specs/145-constitution-runtime-boundary/research.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the current baseline.
- **Foundational (Phase 2)**: Depends on Setup; blocks all story implementation.
- **User Stories 1-4 (Phases 3-6)**: Depend on Foundational and share `.highway/governance/constitution.md`; execute sequentially in priority order unless edits are coordinated.
- **User Story 5 (Phase 7)**: Depends on the completed amendment and validator updates from User Stories 1-4.
- **Polish (Phase 8)**: Depends on all story phases.

### Parallel Opportunities

- T002 and T003 can run in parallel.
- Within each story, test updates targeting different files can run in parallel, but Constitution edits remain sequential.
- T007/T008, T011/T012, T015/T016, T019-T021, and T025-T027 can be parallelized by separate contributors before their corresponding Constitution edit is validated.
- T030 and T033 are independent read/execute audits after implementation.

## Implementation Strategy

### MVP First

1. Complete Phases 1-2.
2. Complete User Story 1 and validate the development/runtime boundary.
3. Complete User Story 2 to preserve correctness-critical determinism.
4. Validate before continuing to the remaining ownership and coherence stories.

### Incremental Delivery

1. Establish and account for the amendment.
2. Refactor scope and determinism.
3. Remove runtime interaction ownership from Layer 1.
4. Reassign context, failure, and orchestration ownership.
5. Reconcile validators and run the full suite.

### Notes

- Every task includes an exact file path.
- `[P]` marks tasks that can use different files without incomplete-task dependencies.
- Protected runtime files are intentionally absent from implementation tasks.
- No task creates a replacement runtime failure or collaboration contract.
