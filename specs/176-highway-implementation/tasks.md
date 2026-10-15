---

description: "Task list for Highway Reference Implementation Workflow"
---

# Tasks: Highway Reference Implementation Workflow

**Input**: Design documents from `/specs/176-highway-implementation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/implementation-workflow.md, quickstart.md

**Tests**: Focused shell contract coverage is required by the feature's measurable success criteria and quickstart.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the source and shared output surfaces required by the implementation workflow.

- [X] T001 [P] Add the authoritative skill directory and entrypoint at `.highway/skills/highway-implementation/SKILL.md`
- [X] T002 [P] Add the Reference Implementation record template at `.highway/library/templates/output/implementation-record.md`
- [X] T003 [P] Add the implementation catalog template at `.highway/library/templates/output/implementation-catalog.md`
- [X] T004 [P] Add the focused onboarding test harness at `.highway/tools/tests/highway-implementation-onboarding.test.sh`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define shared contracts and fixture scaffolding before story-specific behavior is completed.

**Critical**: User story implementation depends on these contract surfaces.

- [X] T005 [P] Define the accepted `ARCH######` input, optional evidence states, `RI######` record fields, catalog fields, and no-write state transitions in `specs/176-highway-implementation/data-model.md`
- [X] T006 [P] Define invocation, ownership, input, output, realization, determinism, persistence, completion, and error behavior in `specs/176-highway-implementation/contracts/implementation-workflow.md`
- [X] T007 Extend `.highway/tools/tests/highway-implementation-onboarding.test.sh` with deterministic fixture helpers and pre-operation byte-snapshot assertions
- [X] T008 Run the focused test harness against the source contract and record the initial failing assertions before implementation in `.highway/tools/tests/highway-implementation-onboarding.test.sh`

**Checkpoint**: Shared contract, template, and failure-fixture foundations are ready for story work.

---

## Phase 3: User Story 1 - Create a Reference Implementation (Priority: P1) 🎯 MVP

**Goal**: Resolve one accepted architecture and publish exactly one proposed, cataloged, traceable implementation blueprint.

**Independent Test**: A valid accepted architecture fixture produces one `RI######` record, one direct catalog entry, proposed status, required blueprint sections, and REQ/DISC/ADR/ARCH traceability.

### Tests for User Story 1

- [X] T009 [P] [US1] Add valid accepted architecture, malformed input, non-accepted input, ambiguity, duplicate architecture, and invalid catalog fixtures in `.highway/tools/tests/highway-implementation-onboarding.test.sh`
- [X] T010 [P] [US1] Add assertions for one `RI######` record, one catalog entry, proposed status, required sections, completion response fields, and upstream traceability in `.highway/tools/tests/highway-implementation-onboarding.test.sh`

### Implementation for User Story 1

- [X] T011 [US1] Specify the `highway-implementation` invocation, accepted `ARCH######` resolution, and downstream workflow position in `.highway/skills/highway-implementation/SKILL.md`
- [X] T012 [US1] Define the deterministic implementation record structure, required realization sections, status, and traceability fields in `.highway/library/templates/output/implementation-record.md`
- [X] T013 [US1] Define implementation catalog versioning, `RI######` allocation, direct entries, and architecture uniqueness in `.highway/library/templates/output/implementation-catalog.md`
- [X] T014 [US1] Implement the valid-input creation contract, proposed status, one-record/one-entry publication, and completion response in `.highway/skills/highway-implementation/SKILL.md`
- [X] T015 [US1] Implement architecture resolution rejection and duplicate handling with unchanged outputs in `.highway/skills/highway-implementation/SKILL.md`
- [X] T016 [US1] Complete valid-fixture assertions and run the focused MVP contract test in `.highway/tools/tests/highway-implementation-onboarding.test.sh`

**Checkpoint**: User Story 1 is independently usable as the architecture-to-implementation MVP.

---

## Phase 4: User Story 2 - Realize Governance and Operational Expectations (Priority: P1)

**Goal**: Carry architecture, governance, operational, lifecycle, assumptions, risks, constraints, and dependencies into the blueprint without mutating upstream ownership.

**Independent Test**: Valid, missing, and blocked optional evidence produces deterministic realization mappings or explicit risks while all upstream source bytes remain unchanged.

### Tests for User Story 2

- [X] T017 [P] [US2] Add missing, blocked, valid, complete, in-progress, not-started, and malformed Clarification/Profile/Objective/Control/NFR fixtures in `.highway/tools/tests/highway-implementation-onboarding.test.sh`
- [X] T018 [P] [US2] Add assertions for evidence precedence, malformed-Clarification architecture fallback, control and NFR realization, seven lifecycle activities, risks, constraints, dependencies, and byte-identical upstream sources in `.highway/tools/tests/highway-implementation-onboarding.test.sh`

### Implementation for User Story 2

- [X] T019 [US2] Document read-only ownership boundaries, evidence precedence, missing/blocked behavior, and malformed optional-input abort behavior in `.highway/skills/highway-implementation/SKILL.md`
- [X] T020 [US2] Define technology realization, runtime components, deployment topology, environment strategy, data realization, integration realization, security controls, NFRs, and lifecycle activities in `.highway/library/templates/output/implementation-record.md`
- [X] T021 [US2] Define assumptions, risks, constraints, dependencies, and available upstream traceability rendering in `.highway/library/templates/output/implementation-record.md`
- [X] T022 [US2] Document deterministic technology-choice evidence and architecture-intent preservation rules in `.highway/skills/highway-implementation/SKILL.md`
- [X] T023 [US2] Document the no-redesign, no-option-switching, no-upstream-mutation, and no-deployment-authorization boundaries in `.highway/skills/highway-implementation/SKILL.md`
- [X] T024 [US2] Complete governance and lifecycle fixture assertions and run the focused contract test in `.highway/tools/tests/highway-implementation-onboarding.test.sh`

**Checkpoint**: User Story 2 is independently usable as a governed implementation realization handoff.

---

## Phase 5: User Story 3 - Preserve Determinism and Downstream Boundaries (Priority: P1)

**Goal**: Make repeated generation stable, allocation atomic, failures no-write, and downstream boundaries explicit.

**Independent Test**: Repeatability, volatile metadata, allocation conflict, validation failure, write failure, deferred-artifact, and generated-surface fixtures pass with unchanged pre-operation bytes on failure.

### Tests for User Story 3

- [X] T025 [P] [US3] Add repeatability, volatile-metadata exclusion, three-retry allocation conflict, validation failure, write failure, and partial-publication fixtures in `.highway/tools/tests/highway-implementation-onboarding.test.sh`
- [X] T026 [P] [US3] Add assertions that plans, tasks, source code, IaC, deployment authorization, and self-service artifacts are absent and generated surfaces correspond in `.highway/tools/tests/highway-implementation-onboarding.test.sh`

### Implementation for User Story 3

- [X] T027 [US3] Document deterministic ordering, volatile metadata exclusion, pre-persistence validation, atomic publication, and three-attempt allocation behavior in `.highway/skills/highway-implementation/SKILL.md`
- [X] T028 [US3] Document resolution, validation, duplicate, allocation, and write failure no-write guarantees in `.highway/skills/highway-implementation/SKILL.md`
- [X] T029 [US3] Document the downstream handoff boundary and explicit non-generation of plans, tasks, executable code, infrastructure definitions, deployment authorization, and productization artifacts in `.highway/skills/highway-implementation/SKILL.md`
- [X] T030 [US3] Complete repeatability, atomicity, boundary, and correspondence assertions and run the focused contract test in `.highway/tools/tests/highway-implementation-onboarding.test.sh`

**Checkpoint**: All three P1 stories are independently validated and the workflow is safe to hand downstream.

---

## Phase 6: Generated Surfaces and Polish

**Purpose**: Regenerate distributed adapters/catalogs and run all repository validation.

- [X] T031 [P] Regenerate skill adapters with `.highway/tools/generate-agent-adapters.sh`
- [X] T032 [P] Regenerate skill and library catalogs with `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-library-catalog.sh`
- [X] T033 [P] Regenerate instruction surfaces with `.highway/tools/generate-instructions.sh`
- [X] T034 Validate generated adapters and catalogs with `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/validate-library.test.sh`, and `.highway/tools/tests/validate-skill.test.sh`
- [X] T035 Run the complete repository test suite with `.highway/tools/tests/run-all.sh`
- [X] T036 Run `git diff --check` and the Feature 176 quickstart checks from `specs/176-highway-implementation/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T001-T004 can run in parallel.
- **Foundational (Phase 2)**: Depends on the source/template/test surfaces from Phase 1.
- **User Stories (Phases 3-5)**: Depend on Phase 2; all are P1 but should be completed in order because US2 and US3 extend the MVP contract.
- **Generated Surfaces and Polish (Phase 6)**: Depends on all user stories and source changes.

### User Story Dependencies

- **User Story 1**: Depends on Phase 2 and provides the MVP record/catalog publication path.
- **User Story 2**: Depends on US1's record structure and extends it with governance and lifecycle realization.
- **User Story 3**: Depends on US1 and US2 behavior and hardens persistence, determinism, and downstream boundaries.

### Parallel Opportunities

- T001-T004 can run in parallel because each creates a distinct source surface.
- T005-T006 can run in parallel; T007-T008 then exercise those contracts.
- T009-T010, T017-T018, and T025-T026 can run in parallel within their respective story phases.
- T031-T033 can run in parallel after all authoritative source inputs are complete.

## Parallel Example: User Story 1

```text
T009 valid and invalid architecture fixtures
T010 output and traceability assertions
T011 invocation and resolution contract
T012 record template structure
T013 catalog template structure
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement and validate User Story 1.
3. Stop at the MVP checkpoint and verify one accepted architecture creates one proposed RI record and catalog entry.

### Incremental Delivery

1. Add User Story 2 governance and lifecycle realization.
2. Add User Story 3 determinism, atomicity, and downstream boundary protections.
3. Regenerate distributed surfaces and run the full suite.

### Completion Criteria

Every task uses the required checkbox, sequential ID, optional `[P]` marker, story label where required, and an exact repository file path.
