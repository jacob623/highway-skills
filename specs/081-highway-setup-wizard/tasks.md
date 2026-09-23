---

description: "Executable task list for the Highway Setup Wizard feature"
---

# Tasks: Highway Setup Wizard

**Input**: Design documents from `/specs/081-highway-setup-wizard/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/setup-wizard.md](contracts/setup-wizard.md), [quickstart.md](quickstart.md)

**Tests**: Required by FR-018 and the existing validation contracts. Extend the focused static and executable Bash tests before changing the shipped skill behavior.

**Organization**: Tasks are grouped by the four user stories in priority order. Each story has an independent test checkpoint.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the existing implementation and validation surfaces before story work begins.

- [X] T001 Confirm the current Setup workflow, owner readiness fixtures, and baseline test commands in `.highway/skills/highway-setup/SKILL.md`, `.highway/tools/tests/highway-setup.test.sh`, and `.highway/tools/tests/highway-setup-executable.test.sh`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared wizard vocabulary and test fixtures before implementing any user story.

- [X] T002 [P] Add shared test helpers and fixture data for Profile, Objectives, Controls, and NFR owner responses in `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T003 [P] Add static contract assertions for `Current Stage`, `Current Activity`, step mapping, terminality categories, and owner-only mutation language in `.highway/tools/tests/highway-setup.test.sh`.

**Checkpoint**: Shared owner-response fixtures and wizard contract assertions are ready; story implementation can begin.

---

## Phase 3: User Story 1 - Complete Setup Through One Guided Entry Point (Priority: P1) 🎯 MVP

**Goal**: Turn `/highway-setup` into an active ordered wizard that automatically delegates Profile, Objectives, Controls, and NFR collection and advances after terminal success.

**Independent Test**: Start each owner stage incomplete, provide valid owner responses, and verify one `/highway-setup` interaction advances through all applicable stages without manually invoking downstream commands.

### Tests for User Story 1

- [X] T004 [P] [US1] Add executable routing cases for automatic Profile-to-Objectives-to-Controls-to-NFR advancement in `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T005 [P] [US1] Add static assertions for active guided setup, fixed owner order, automatic advancement, and completion output in `.highway/tools/tests/highway-setup.test.sh`.

### Implementation for User Story 1

- [X] T006 [US1] Replace the readiness-and-stop workflow with the active ordered delegation flow in `.highway/skills/highway-setup/SKILL.md`.
- [X] T007 [US1] Add the guided entry, owner response forwarding, terminal advancement, and `Highway Setup Complete` dashboard behavior to `.highway/skills/highway-setup/SKILL.md`.

**Checkpoint**: User Story 1 is independently testable through the focused Setup tests.

---

## Phase 4: User Story 2 - Owner Workflows Retain Artifact Authority (Priority: P1)

**Goal**: Ensure Setup routes collection and owner output without directly mutating Profile, Objective, Control, NFR, catalog, identifier, candidate, or relationship artifacts.

**Independent Test**: Run the wizard through proposal and completion paths, inspect owner call routing and fixture hashes, and verify only the owner workflow can change governed artifacts.

### Tests for User Story 2

- [X] T008 [P] [US2] Add static no-write and owner-authority assertions for Profile, Objectives, Controls, NFRs, catalogs, identifiers, candidates, and relationships in `.highway/tools/tests/highway-setup.test.sh`.
- [X] T009 [P] [US2] Add executable artifact-hash and declined/cancelled proposal fixtures proving Setup preserves owner-controlled bytes in `.highway/tools/tests/highway-setup-executable.test.sh`.

### Implementation for User Story 2

- [X] T010 [US2] Document owner delegation boundaries, proposal forwarding, and no-write behavior in `.highway/skills/highway-setup/SKILL.md`.
- [X] T011 [US2] Document direct-mutation routing to the owning skill and preservation of owner confirmation, cancellation, rejection, duplicate, validation, and no-write semantics in `.highway/skills/highway-setup/SKILL.md`.

**Checkpoint**: User Stories 1 and 2 are independently testable, with owner artifact authority preserved.

---

## Phase 5: User Story 3 - Users Can See and Resume Wizard Progress (Priority: P1)

**Goal**: Provide deterministic step/stage progress, one unresolved question per turn, and readiness-based resume after interruption or cancellation.

**Independent Test**: Interrupt each active stage, invoke `/highway-setup` again, and verify the first incomplete stage, step mapping, completed/current/remaining progress, owner activity, and next unresolved question.

### Tests for User Story 3

- [X] T012 [P] [US3] Add static assertions for `Step`, `Stage`, `Completed Stages`, `Current Stage`, `Remaining Stages`, `Current Activity`, FR-009A mapping, and byte-identical owner question/example output in `.highway/tools/tests/highway-setup.test.sh`.
- [X] T013 [P] [US3] Add executable interruption, cancellation, resume, and one-question-at-a-time scenarios in `.highway/tools/tests/highway-setup-executable.test.sh`.

### Implementation for User Story 3

- [X] T014 [US3] Add the transient wizard state, progress report, one-question collection, and exact step-to-stage mapping to `.highway/skills/highway-setup/SKILL.md`.
- [X] T015 [US3] Add readiness-based resume and explicit pause/cancellation behavior without a Setup checkpoint to `.highway/skills/highway-setup/SKILL.md`.

**Checkpoint**: User Stories 1 through 3 are independently testable, including interruption and resume behavior.

---

## Phase 6: User Story 4 - Wizard Failures Remain Deterministic and Actionable (Priority: P2)

**Goal**: Classify owner responses through the explicit terminality table and stop safely on blocked, declined, malformed, unknown, or incomplete outcomes.

**Independent Test**: Feed every decision-table response class and verify terminal advancement, non-terminal pause/stop behavior, owner reason/action output, and no downstream invocation after a non-terminal result.

### Tests for User Story 4

- [X] T016 [P] [US4] Add decision-table coverage for Complete, applicable Not Applicable, Missing, In Progress, Blocked, declined, aborted, malformed, and unknown owner responses in `.highway/tools/tests/highway-setup-executable.test.sh`.
- [X] T017 [P] [US4] Add static assertions for FR-013A classifications, deterministic blocking, downstream short-circuiting, and existing NFR zero-candidate semantics in `.highway/tools/tests/highway-setup.test.sh`.

### Implementation for User Story 4

- [X] T018 [US4] Add the explicit owner-response terminality decision table and deterministic routing/error behavior to `.highway/skills/highway-setup/SKILL.md`.
- [X] T019 [US4] Preserve blocked, declined, malformed, contradictory, pending, and zero-candidate NFR handling while preventing fabricated completion in `.highway/skills/highway-setup/SKILL.md`.

**Checkpoint**: All four user stories are independently testable with deterministic failure handling.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Reconcile documentation, run the complete validation matrix, and report requirement coverage separately from check results.

- [X] T020 [P] Update the implementation-facing validation references and scenario matrix in `specs/081-highway-setup-wizard/quickstart.md` and `specs/081-highway-setup-wizard/contracts/setup-wizard.md` after the final skill contract is settled.
- [X] T021 Run both focused Setup tests and the full suite from `specs/081-highway-setup-wizard/quickstart.md`; record command results separately from FR/SC requirement coverage.
- [X] T022 Run `git diff --check`, verify the distribution manifest remains unchanged, and confirm no `.specify/extensions.yml` hooks or development-only references were added to shipped files.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; confirms the existing surfaces.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Phase 2; MVP.
- **User Story 2 (Phase 4)**: Depends on US1's delegation path, then can be validated independently.
- **User Story 3 (Phase 5)**: Depends on US1's active flow and US2's owner-response boundary.
- **User Story 4 (Phase 6)**: Depends on the shared response fixtures and active flow; can be implemented after Phase 2 but is sequenced after progress behavior for coherent output.
- **Polish (Phase 7)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **US1 (P1)**: No story dependency after Phase 2; delivers the MVP.
- **US2 (P1)**: Depends on US1's forwarding path to validate ownership without duplicating orchestration.
- **US3 (P1)**: Depends on US1's stage flow and US2's owner-output boundary.
- **US4 (P2)**: Uses the shared response fixtures and can proceed in parallel with US2 or US3 after Phase 2, but final integration follows the active flow.

### Parallel Opportunities

- T002 and T003 can run in parallel because they touch different test files.
- Within each story, the static test task and executable test task can run in parallel before the corresponding skill edits.
- T004/T005, T008/T009, T012/T013, and T016/T017 are parallel test-writing pairs.
- US2 and US4 can be developed in parallel after US1 if separate contributors work on the static and executable test surfaces, then reconciled before polish.

---

## Parallel Example: User Story 1

```text
Task: "Add executable routing cases for automatic four-stage advancement in .highway/tools/tests/highway-setup-executable.test.sh"
Task: "Add static assertions for active guided setup and completion output in .highway/tools/tests/highway-setup.test.sh"
```

## Parallel Example: User Story 2

```text
Task: "Add static owner-authority and no-write assertions in .highway/tools/tests/highway-setup.test.sh"
Task: "Add executable artifact-preservation fixtures in .highway/tools/tests/highway-setup-executable.test.sh"
```

## Parallel Example: User Story 3

```text
Task: "Add static progress and step-mapping assertions in .highway/tools/tests/highway-setup.test.sh"
Task: "Add executable interruption, cancellation, resume, and one-question scenarios in .highway/tools/tests/highway-setup-executable.test.sh"
```

## Parallel Example: User Story 4

```text
Task: "Add static terminality-table assertions in .highway/tools/tests/highway-setup.test.sh"
Task: "Add executable response-matrix cases in .highway/tools/tests/highway-setup-executable.test.sh"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational test fixtures and shared assertions.
3. Complete Phase 3: User Story 1 active ordered wizard.
4. Run the focused Setup tests and stop for an MVP review.
5. Continue with ownership, progress/resume, and failure hardening only after the MVP path passes.

### Incremental Delivery

1. Deliver US1: active four-stage guided advancement.
2. Deliver US2: owner authority and no-write preservation.
3. Deliver US3: progress, one-question collection, interruption, and resume.
4. Deliver US4: explicit terminality matrix and deterministic failures.
5. Run Phase 7 validation and report checks separately from requirement coverage.

## Notes

- `[P]` tasks touch different files and have no dependency on incomplete work.
- `[US1]` through `[US4]` map directly to the four user stories in `spec.md`.
- No new runtime dependency, persistent Setup artifact, generated artifact, or distribution manifest entry is expected.
- Tests must be observed failing for the behavior they claim to cover before implementation is marked complete, per D3.6.
