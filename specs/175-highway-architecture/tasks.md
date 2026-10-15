---

description: "Task list for Highway Reference Architecture Workflow"
---

# Tasks: Highway Reference Architecture Workflow

**Input**: Design documents from `/specs/175-highway-architecture/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Focused contract and failure-fixture tests are required by the specification and quickstart.

**Organization**: Tasks are grouped by user story to enable independent implementation and validation.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the source, template, and failing validation surfaces for the new skill.

- [X] T001 [P] Review `.highway/skills/highway-adr/SKILL.md`, `.highway/library/templates/output/adr-record.md`, and `.highway/library/templates/output/adr-catalog.md` to capture reusable workflow and output-contract patterns.
- [X] T002 Create `.highway/library/templates/output/architecture-record.md` with the declared Reference Architecture frontmatter and required section order.
- [X] T003 Create `.highway/library/templates/output/architecture-catalog.md` with catalog-owned `ARCHXXXXXX` allocation and direct index-entry structure.
- [X] T004 [P] Create `.highway/tools/tests/highway-architecture-onboarding.test.sh` with a pre-implementation failing contract harness for invocation, ownership, outputs, identifier rules, and deferred scope.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build the source-first skill boundary and shared validation primitives before story-specific behavior.

**No user story work can begin until this phase is complete.**

- [X] T005 Create `.highway/skills/highway-architecture/SKILL.md` with valid frontmatter, one Purpose, declared inputs, ownership boundaries, and references to the shared architecture templates.
- [X] T006 [P] Add the architecture input-resolution, optional-context, and ownership contract assertions to `.highway/tools/tests/highway-architecture-onboarding.test.sh`.
- [X] T007 Define the architecture record and catalog entities, relationships, and state transitions in `.highway/skills/highway-architecture/SKILL.md` using the canonical `ARCHXXXXXX` vocabulary from `specs/175-highway-architecture/data-model.md`.
- [X] T008 Add the ordered workflow and verification sections to `.highway/skills/highway-architecture/SKILL.md`, including read-only upstream consumption, validation-before-persistence, and atomic publication.

**Checkpoint**: The source skill, shared templates, and focused contract harness exist; the focused test fails only for unimplemented architecture behavior.

---

## Phase 3: User Story 1 - Create a Reference Architecture from one accepted ADR (Priority: P1) 🎯 MVP

**Goal**: Consume exactly one accepted ADR and publish one complete proposed Reference Architecture and catalog entry.

**Independent Test**: Run `.highway/tools/tests/highway-architecture-onboarding.test.sh` with a valid accepted ADR fixture and verify one complete `ARCHXXXXXX` record, one direct catalog entry, and all required architecture sections.

### Tests for User Story 1

- [X] T009 [P] [US1] Add valid accepted-ADR, missing-ADR, malformed-ADR, ambiguous-ADR, non-accepted-ADR, and duplicate-architecture fixtures to `.highway/tools/tests/highway-architecture-onboarding.test.sh`.

### Implementation for User Story 1

- [X] T010 [US1] Define exact `/highway-architecture ADRXXXXXX` resolution and accepted-status validation in `.highway/skills/highway-architecture/SKILL.md`.
- [X] T011 [US1] Define conceptual architecture generation for Context, Architecture Summary, Architecture Style, Logical Components, Interaction Model, Trust Boundaries, Deployment Pattern, Key Technologies, Constraints, Required Capabilities, Assumptions, Risks, and Reference Implementation Guidance in `.highway/skills/highway-architecture/SKILL.md`.
- [X] T012 [US1] Define `ARCHXXXXXX` catalog allocation, ADR uniqueness, proposed initial status, and direct record/catalog output paths in `.highway/skills/highway-architecture/SKILL.md`.
- [X] T013 [US1] Define the successful completion response and traceability chain in `.highway/skills/highway-architecture/SKILL.md` and `.highway/tools/tests/highway-architecture-onboarding.test.sh`.

**Checkpoint**: A valid accepted ADR produces one complete proposed architecture and catalog entry; invalid ADR inputs produce no writes.

---

## Phase 4: User Story 2 - Preserve ownership and provide a clean implementation handoff (Priority: P1)

**Goal**: Preserve ADR and governance ownership while producing a conceptual handoff with explicit risks, relationships, and future implementation guidance.

**Independent Test**: Run the focused contract test with missing, blocked, valid, and malformed optional governance fixtures and compare upstream bytes before and after generation.

### Tests for User Story 2

- [X] T014 [P] [US2] Add missing, blocked, valid, and malformed Profile/Objective/Control/NFR fixtures and upstream-byte preservation assertions to `.highway/tools/tests/highway-architecture-onboarding.test.sh`.

### Implementation for User Story 2

- [X] T015 [US2] Define optional governance handling in `.highway/skills/highway-architecture/SKILL.md`: missing continues without invention, blocked continues as an architecture risk, and malformed or inconsistent input aborts without writes.
- [X] T016 [US2] Define ADR decision, rationale, alternatives, consequences, and authorization ownership boundaries plus prohibited implementation and downstream mutations in `.highway/skills/highway-architecture/SKILL.md`.
- [X] T017 [US2] Define Objective, Control, and NFR relationships, inherited constraints, traceability, and deterministic relationship ordering in `.highway/skills/highway-architecture/SKILL.md`.
- [X] T018 [US2] Define capability candidates and Reference Implementation Guidance as advisory outputs without capability artifacts, capability identifiers, implementation artifacts, or implementation authorization in `.highway/skills/highway-architecture/SKILL.md`.

**Checkpoint**: The architecture handoff preserves every upstream owner, exposes blocked evidence as risk, and remains conceptual and implementation-neutral.

---

## Phase 5: User Story 3 - Produce deterministic, atomic architecture records (Priority: P1)

**Goal**: Make allocation, ordering, validation, retries, failure handling, and repeated runs deterministic and atomic.

**Independent Test**: Run the focused test's failure and repeatability fixtures, then run the full repository suite and compare all pre-operation bytes.

### Tests for User Story 3

- [X] T019 [P] [US3] Add invalid-catalog, allocation-conflict, validation-failure, write-failure, repeated-input, volatile-metadata, and deferred-artifact fixtures to `.highway/tools/tests/highway-architecture-onboarding.test.sh`.

### Implementation for User Story 3

- [X] T020 [US3] Define deterministic component, relationship, capability, assumption, risk, and section ordering plus volatile-metadata exclusions in `.highway/skills/highway-architecture/SKILL.md`.
- [X] T021 [US3] Define validation-before-persistence, atomic record/catalog publication, bounded allocation retries, duplicate rejection, and no-partial-write behavior in `.highway/skills/highway-architecture/SKILL.md`.
- [X] T022 [US3] Define the architecture verification outcomes for unchanged upstream bytes, one record, one catalog entry, valid status, complete sections, and no implementation authorization in `.highway/skills/highway-architecture/SKILL.md`.

**Checkpoint**: Identical inputs are byte-stable, failures preserve all pre-operation bytes, and deferred artifacts are not created.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate derived surfaces, validate the complete repository, and confirm the quickstart path.

- [X] T023 [P] Regenerate `.github/skills/highway-architecture/SKILL.md`, `.claude/skills/highway-architecture/SKILL.md`, `.cursor/skills/highway-architecture/SKILL.md`, `.agents/skills/highway-architecture/SKILL.md`, and catalogs using the declared `.highway/tools/generate-*.sh` scripts.
- [X] T024 [P] Run `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/validate-library.test.sh`, and `.highway/tools/tests/validate-skill.test.sh` and resolve only architecture-specific failures.
- [X] T025 Run `.highway/tools/tests/highway-architecture-onboarding.test.sh` and record focused contract and failure-fixture results against `specs/175-highway-architecture/contracts/architecture-workflow.md`.
- [X] T026 Run `specs/175-highway-architecture/quickstart.md` validation commands, `.highway/tools/tests/run-all.sh`, and `git diff --check`.
- [X] T027 Update `README.md` or the relevant live skill/catalog documentation only if the generated architecture skill is required to be discoverable there, preserving D6.1 and D6.2.

---

## Dependencies & Execution Order

### Phase Dependencies

- Setup (Phase 1) has no dependencies and establishes templates and the failing focused test.
- Foundational (Phase 2) depends on Setup and blocks all user story implementation.
- US1 (Phase 3) depends on Foundational and is the MVP slice.
- US2 (Phase 4) depends on Foundational and can proceed after the source boundary exists; its fixtures depend on US1 output shape.
- US3 (Phase 5) depends on US1 output and US2 ownership/context behavior.
- Polish (Phase 6) depends on US1, US2, and US3.

### Story Completion Order

```text
Foundational -> US1 -> US2 -> US3 -> Polish
```

### Parallel Opportunities

- T001 and T004 can run in parallel during Setup.
- T002 and T003 can run in parallel during Setup.
- T006 and T007 can run in parallel after T005.
- T009 can be prepared in parallel with T010-T013 once the output templates exist.
- T014 can be prepared in parallel with T015-T018 after US1 output shape is stable.
- T019 can be prepared in parallel with T020-T022 after failure boundaries are agreed.
- T023 and T024 can run in parallel after all source edits; T025 and T026 run after regeneration.

## Implementation Strategy

1. Deliver the MVP as US1: one accepted ADR to one proposed Reference Architecture with deterministic catalog publication.
2. Add US2 ownership and optional-context behavior without broadening ADR or Reference Implementation authority.
3. Add US3 failure, retry, determinism, and no-partial-write coverage.
4. Regenerate all derived surfaces and run focused plus full repository validation before completion.
