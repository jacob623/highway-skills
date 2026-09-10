---
description: "Task list for Feature 038 readiness verification corrections"
---

# Tasks: Readiness Verification Corrections

**Input**: Design documents from `specs/038-readiness-verification-corrections/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Test tasks are included because the specification requires executable owner fixtures, Setup routing verification, static contract checks, and generated-artifact correspondence evidence.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently after the foundational harness is ready.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the Feature 038 fixture and evidence structure without changing Feature 037 history.

- [X] T001 Create the Feature 038 fixture directory and disposable-fixture helper structure in `.highway/tools/tests/fixtures/feature-038/`.
- [X] T002 [P] Add shared Bash 3.2-compatible fixture, hashing, response-parsing, and evidence-report helpers in `.highway/tools/tests/feature-038-helpers.sh`.
- [X] T003 [P] Add Feature 038 test entry points to `.highway/tools/tests/` and document their intended evidence classes in `.highway/tools/tests/README.md`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define the shared response and evidence boundaries required by all three stories.

- [X] T004 Implement the ordered four-field response parser and status-specific validation from `specs/038-readiness-verification-corrections/contracts/nfr-readiness-state-contract.md` in `.highway/tools/tests/feature-038-helpers.sh`.
- [X] T005 Implement disposable-tree hashing, before/after mutation detection, and three-run determinism assertions from `specs/038-readiness-verification-corrections/contracts/executable-evidence-contract.md` in `.highway/tools/tests/feature-038-helpers.sh`.
- [X] T006 [P] Add a canonical-source/generated-output path map and evidence-category writer in `.highway/tools/tests/feature-038-helpers.sh`, keeping `.highway/skills/` authoritative and generated trees read-only.
- [X] T007 [P] Add the Feature 038 requirement-to-test coverage record in `specs/038-readiness-verification-corrections/coverage.md`, covering FR-001 through FR-015 and SC-001 through SC-008.

**Checkpoint**: Shared fixture creation, response parsing, hash comparison, repeat-run comparison, and evidence classification are available to every user story.

---

## Phase 3: User Story 1 - Reconcile NFR Readiness States (Priority: P1) 🎯 MVP

**Goal**: Make the five-row NFR owner state model authoritative, explicitly exclude NFR `Missing`, and align the NFR owner and Setup routing contracts.

**Independent Test**: Run the NFR state fixture and contract tests against zero-candidate, pending-candidate, accepted, unavailable, malformed, and contradictory inputs; verify exactly one status and route per supported input and no NFR-specific `Missing` route.

### Tests for User Story 1

- [X] T008 [P] [US1] Add exhaustive NFR input/state assertions for the five ordered rows in `.highway/tools/tests/readiness-owner-states.test.sh`.
- [X] T009 [P] [US1] Add assertions that NFR-specific contracts, fixtures, and coverage exclude `Missing` while shared non-NFR owner vocabulary remains valid in `.highway/tools/tests/readiness-contract.test.sh`.
- [X] T010 [P] [US1] Add zero-count-with-entries contradiction and malformed-response routing cases in `.highway/tools/tests/highway-setup.test.sh`.

### Implementation for User Story 1

- [X] T011 [US1] Update the authoritative readiness and response rules in `.highway/skills/highway-nfrs/SKILL.md` so candidates with none accepted always return `In Progress`, zero successful candidates return `Not Applicable`, and NFR `Missing` is excluded.
- [X] T012 [US1] Update the orchestration rules and ordered route table in `.highway/skills/highway-setup/SKILL.md` to remove the NFR `Missing` route and retain distinct `In Progress`, `Blocked`, `Complete`, and `Not Applicable` handling.
- [X] T013 [US1] Align the Feature 038 NFR and Setup contracts with the canonical skill wording in `specs/038-readiness-verification-corrections/contracts/nfr-readiness-state-contract.md` and `specs/038-readiness-verification-corrections/contracts/executable-evidence-contract.md`.
- [X] T014 [US1] Regenerate the catalog and agent adapters from the updated canonical skills using `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh`, without hand-editing generated outputs.

**Checkpoint**: NFR state and Setup routing tests pass independently, and generated outputs correspond to the updated canonical owner skills.

---

## Phase 4: User Story 2 - Keep Planning Artifacts Aligned with Source Ownership (Priority: P1)

**Goal**: Ensure Feature 038 records identify `.highway/skills/` as the behavior-owning source, distinguish generated outputs, contain no template residue, and preserve Feature 037 as history.

**Independent Test**: Run the planning-artifact contract test and inspect the Feature 038 plan, tasks, contracts, and coverage record for canonical paths, generated-output handling, no placeholders, and explicit Feature 037 preservation.

### Tests for User Story 2

- [X] T015 [P] [US2] Add canonical-source, generated-output, placeholder, and Feature 037 immutability assertions in `.highway/tools/tests/feature-038-plan.test.sh`.
- [X] T016 [P] [US2] Add task checklist-format, sequential-ID, story-label, and exact-path assertions in `.highway/tools/tests/feature-038-plan.test.sh`.

### Implementation for User Story 2

- [X] T017 [US2] Update `specs/038-readiness-verification-corrections/plan.md` and `specs/038-readiness-verification-corrections/quickstart.md` if implementation details or command paths differ from the final canonical source and test layout.
- [X] T018 [US2] Record the canonical source map, generated adapter trees, distribution outputs, and no-hand-edit boundary in `specs/038-readiness-verification-corrections/data-model.md` and `specs/038-readiness-verification-corrections/research.md`.
- [X] T019 [US2] Add the final evidence categories, implementation checks, coverage checks, generated-artifact checks, and limitations to `specs/038-readiness-verification-corrections/quickstart.md` and `.highway/tools/tests/feature-038-evidence-report.sh`.
- [X] T020 [US2] Verify Feature 037 remains unchanged and record that historical-spec check in `.highway/tools/tests/feature-038-plan.test.sh` without editing `specs/037-readiness-ownership-refactor/`.

**Checkpoint**: Feature 038 planning artifacts and their automated checks point to canonical sources, identify generated outputs separately, and preserve Feature 037.

---

## Phase 5: User Story 3 - Verify Owner Behavior with Executable Fixtures (Priority: P1)

**Goal**: Exercise Profile, Objectives, Controls, and NFR readiness against disposable artifact fixtures, prove read-only behavior and determinism, and verify Setup short-circuiting from captured responses.

**Independent Test**: Run the owner fixture and Setup executable tests; each required fixture invokes documented owner behavior or an explicitly labeled deterministic adapter, emits four parsed fields, preserves hashes, repeats identically three times, and routes in owner order.

### Tests for User Story 3

- [X] T021 [P] [US3] Add disposable Profile readiness fixtures for valid, missing, malformed, empty, and whitespace-only inputs in `.highway/tools/tests/fixtures/feature-038/profile/`.
- [X] T022 [P] [US3] Add disposable Objectives readiness fixtures for valid, missing, malformed, empty, and contradictory inputs in `.highway/tools/tests/fixtures/feature-038/objectives/`.
- [X] T023 [P] [US3] Add disposable Controls readiness fixtures for valid, missing, malformed, empty, and contradictory inputs in `.highway/tools/tests/fixtures/feature-038/controls/`.
- [X] T024 [P] [US3] Add disposable NFR readiness fixtures for zero candidates, pending candidates, accepted artifacts, unavailable generation, malformed generation, and contradictory count inputs in `.highway/tools/tests/fixtures/feature-038/nfrs/`.
- [X] T025 [US3] Implement owner-specific executable evaluation and four-field parsing in `.highway/tools/tests/readiness-executable.test.sh`, invoking the documented behavior or an explicitly identified deterministic test adapter.
- [X] T026 [US3] Add before/after artifact and identifier hash checks plus three unchanged repeat evaluations to `.highway/tools/tests/readiness-executable.test.sh`.
- [X] T027 [US3] Implement captured-response Setup routing fixtures, first-non-complete short-circuiting, downstream non-inspection, malformed-response blocking, and distinct retained NFR routes in `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T028 [US3] Add executable evidence output with separate owner behavior, Setup routing, static contract, generated artifact, coverage, and limitation sections in `.highway/tools/tests/feature-038-evidence-report.sh`.
- [X] T029 [US3] Add the new executable owner, Setup, plan, evidence, and coverage tests to `.highway/tools/tests/run-all.sh` in dependency order.

**Checkpoint**: All required owner fixture categories and ordered Setup routes are executable, deterministic, read-only, and separately reported.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate and validate every shipped representation, then run the complete Feature 038 evidence path.

- [ ] T030 [P] Run `.highway/tools/tests/validate-skill.test.sh` and `.highway/tools/tests/validate-library.test.sh` against the updated canonical skill content.
- [ ] T031 [P] Run `.highway/tools/tests/generate-catalog.test.sh`, `.highway/tools/tests/generate-agent-adapters.test.sh`, and `.highway/tools/tests/adapter-coverage.test.sh` to verify generated correspondence.
- [ ] T032 [P] Run `.highway/tools/tests/distribution-packaging.test.sh` and `.highway/tools/tests/shipped-tree-independence.test.sh` to verify distributed-tree behavior without development artifacts.
- [ ] T033 Run every validation command listed in `specs/038-readiness-verification-corrections/quickstart.md`, including `.highway/tools/tests/run-all.sh` and `git diff --check`; record each result in `.highway/tools/tests/feature-038-evidence-report.sh` output.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; creates the Feature 038 fixture and helper surface.
- **Foundational (Phase 2)**: Depends on Setup; blocks all story work because every story uses the response, hash, and evidence helpers.
- **User Story 1 (Phase 3)**: Depends on Foundational; establishes the authoritative NFR and Setup state behavior.
- **User Story 2 (Phase 4)**: Depends on Foundational; can proceed in parallel with User Story 1, but its final path assertions should run after any source-path changes settle.
- **User Story 3 (Phase 5)**: Depends on Foundational and the state contract from User Story 1; can begin fixture authoring in parallel, but final execution depends on T011-T012.
- **Polish (Phase 6)**: Depends on all desired stories and regenerated canonical outputs.

### User Story Dependencies

- **US1 (P1)**: Foundational only; no dependency on US2 or US3 for state-model implementation.
- **US2 (P1)**: Foundational only; independently validates planning and source ownership, with no runtime dependency on US3.
- **US3 (P1)**: Foundational plus US1's authoritative state rules; uses US2's evidence categories and final paths for reporting.

### Parallel Opportunities

- T002, T003, T006, and T007 can run in parallel after T001.
- T008, T009, and T010 can run in parallel after the foundational helpers exist.
- T015 and T016 can run in parallel with US1 implementation.
- T021, T022, T023, and T024 can run in parallel because each owns a separate fixture directory.
- T030, T031, and T032 can run in parallel after story implementation and regeneration.

## Parallel Example: User Story 1

```text
T008 readiness-owner-states.test.sh
T009 readiness-contract.test.sh
T010 highway-setup.test.sh

T011 .highway/skills/highway-nfrs/SKILL.md
T012 .highway/skills/highway-setup/SKILL.md
```

## Parallel Example: User Story 2

```text
T015 feature-038-plan.test.sh source and placeholder assertions
T016 feature-038-plan.test.sh task-format assertions
T017 plan.md and quickstart.md path corrections
T018 data-model.md and research.md source-map corrections
```

## Parallel Example: User Story 3

```text
T021 profile fixtures
T022 objectives fixtures
T023 controls fixtures
T024 NFR fixtures
```

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phases 1 and 2.
2. Complete User Story 1 and regenerate canonical outputs.
3. Run the NFR contract and Setup state tests independently.
4. Stop with the authoritative state model and routing correction validated.

### Incremental Delivery

1. Add User Story 2 to lock planning/source ownership and preserve Feature 037 history.
2. Add User Story 3 to provide executable owner and Setup evidence.
3. Run the polish phase to validate generated adapters, catalogs, distribution packaging, and the full suite.
4. Report executable behavior, Setup routing, static contracts, generated artifacts, coverage, and limitations separately.

## Completion Criteria

- All tasks are checked as complete after implementation and validation.
- Every task follows `- [ ] T### [P?] [US#?] description with an exact file path`.
- Feature 037 remains untouched.
- NFR `Missing` is absent from NFR-specific owner and Setup contracts, fixtures, and coverage.
