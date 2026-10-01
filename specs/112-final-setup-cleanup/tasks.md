---

description: "Task list for final highway-setup contract cleanup"
---

# Tasks: Final Setup Contract Cleanup

**Input**: Design documents from `specs/112-final-setup-cleanup/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Contract tests are required by the specification and must cover owner-specific results,
welcome behavior, exact transitions, resume behavior, and completion.

## Phase 1: Setup

**Purpose**: Establish the implementation baseline and affected generated outputs.

- [x] T001 Record the current focused and full-suite results in `specs/112-final-setup-cleanup/quickstart.md`
- [x] T002 [P] Inspect the current Setup contract assertions in `.highway/tools/tests/` and identify all tests that encode the superseded shared-result or transition behavior

## Phase 2: Foundational

**Purpose**: Define corrected contract tests before changing the canonical skill.

- [x] T003 Add a malformed Purpose-boundary assertion and owner-specific result fixtures under `.highway/tools/tests/fixtures/`
- [x] T004 [P] Add owner-specific readiness/result assertions to `.highway/tools/tests/setup-owner-loop-contract.test.sh`
- [x] T005 [P] Add exact Inputs, Purpose, Completion, Resume, Error Handling, and Verification assertions to `.highway/tools/tests/highway-setup.test.sh`
- [x] T006 [P] Add first-run and resumed Setup welcome cases to `.highway/tools/tests/highway-setup-executable.test.sh`
- [x] T007 [P] Add exact horizontal-rule transition assertions for Objectives, Controls, and NFRs to `.highway/tools/tests/highway-ux-alignment.test.sh`

**Checkpoint**: Focused tests describe the corrected 8.0.0 contract and fail only for superseded behavior.

## Phase 3: User Story 1 — Route owner-specific results (Priority: P1) 🎯 MVP

**Goal**: Generalize Setup routing so each owner supplies and controls its own result contract.

**Independent Test**: Run owner-loop and readiness tests with Profile/Objectives-specific results and
Controls/NFR Collection Result cases.

- [x] T008 [US1] Fix the metadata boundary in `.highway/skills/highway-setup/SKILL.md` so `version: 8.0.0` is followed by `### Purpose`
- [x] T009 [US1] Preserve the existing Purpose sentence under `### Purpose` in `.highway/skills/highway-setup/SKILL.md`
- [x] T010 [US1] Replace the Workflow owner-result logic in `.highway/skills/highway-setup/SKILL.md` with the nine-step generic owner loop
- [x] T011 [US1] Add the clarification that Controls/NFRs use Collection Result contracts while Profile/Objectives use their own owner results
- [x] T012 [US1] Remove the shared collection-result requirement and duplicated Constitution boundary statements from `.highway/skills/highway-setup/SKILL.md`
- [x] T013 [US1] Remove the trailing readiness list from Inputs while retaining only the seven declared Setup inputs
- [x] T014 [US1] Update `.highway/tools/tests/setup-owner-loop-contract.test.sh`, `.highway/tools/tests/highway-setup.test.sh`, and `.highway/tools/tests/readiness-contract.test.sh`

**Checkpoint**: User Story 1 is independently testable without imposing a shared result schema.

## Phase 4: User Story 2 — Start and resume setup with correct UX (Priority: P1)

**Goal**: Add the first-run welcome and exact one-time domain transitions.

**Independent Test**: Exercise initial Setup, resumed Setup, skipped domains, first active domain
interactions, and continued interactions.

- [x] T015 [US2] Add the exact first-run Highway welcome and its initial-Setup-only emission condition to `.highway/skills/highway-setup/SKILL.md`
- [x] T016 [US2] Add the exact `---`-prefixed Objectives, Controls, and NFR transition blocks to `.highway/skills/highway-setup/SKILL.md`
- [x] T017 [US2] State that transitions occur only before the first active interaction in a domain and are not repeated for skipped or continuing domains
- [x] T018 [US2] Keep the fresh-readiness resume rule and no-checkpoint/no-conversational-state rule in `.highway/skills/highway-setup/SKILL.md`
- [x] T019 [US2] Remove duplicated owner openings, transition previews, and any local generic Experience Standard rules from `.highway/skills/highway-setup/SKILL.md`
- [x] T020 [US2] Update `.highway/tools/tests/highway-setup-executable.test.sh`, `.highway/tools/tests/highway-ux-alignment.test.sh`, and `.highway/tools/tests/experience-x23-contract.test.sh`

**Checkpoint**: User Story 2 is independently testable for welcome, separator, skip, resume, and no-duplication behavior.

## Phase 5: User Story 3 — Preserve the corrected thin contract (Priority: P1)

**Goal**: Finalize Completion, Error Handling, Verification, generated artifacts, and version behavior.

**Independent Test**: Validate the canonical skill, generated adapters/catalogs, focused tests, and
full repository suite.

- [x] T021 [US3] Simplify Completion in `.highway/skills/highway-setup/SKILL.md` to state that all four owners permit advancement in order before emitting Outputs once
- [x] T022 [US3] Retain only the four Setup-specific Error Handling exceptions in `.highway/skills/highway-setup/SKILL.md`
- [x] T023 [US3] Rewrite Verification in `.highway/skills/highway-setup/SKILL.md` to cover owner-specific contracts, welcome, transitions, resume, no writes, and one-time conclusion
- [x] T024 [US3] Remove Verification bullets that merely restate Constitution owner-boundary rules from `.highway/skills/highway-setup/SKILL.md`
- [x] T025 [US3] Regenerate `.highway/catalog/`, `.github/`, `.claude/`, `.cursor/`, and `.agents/` outputs using the declared generators
- [x] T026 [US3] Update affected legacy contract tests in `.highway/tools/tests/feature-092-contract.test.sh` and `.highway/tools/tests/readiness-contract.test.sh`

**Checkpoint**: User Story 3 is independently testable as the completed 8.0.0 Setup contract.

## Phase 6: Polish & Cross-Cutting Validation

**Purpose**: Confirm generated synchronization, quality, and unchanged owner schemas.

- [x] T027 [P] Compare Profile, Objectives, Controls, and NFR owner skills to confirm no owner schema changed
- [x] T028 [P] Run `git diff --check` across canonical, test, generated, and feature files
- [x] T029 Run all focused Setup checks from `specs/112-final-setup-cleanup/quickstart.md`
- [x] T030 Run `.highway/tools/tests/run-all.sh` and record the passing result in `specs/112-final-setup-cleanup/quickstart.md`

## Dependencies & Execution Order

- Phase 1 has no dependencies.
- Phase 2 depends on Phase 1 and blocks all user stories.
- US1 establishes the generic owner-result contract.
- US2 depends on US1's domain-entry routing.
- US3 depends on US1 and US2 and finalizes verification and generated outputs.
- Phase 6 depends on all story phases.

### Parallel Opportunities

- T004–T007 can run in parallel after T003.
- T015–T019 can be drafted in parallel but must be integrated into the single canonical skill sequentially.
- T027 and T028 can run in parallel after T025.

## Implementation Strategy

### MVP First

1. Complete Phases 1–2.
2. Complete US1.
3. Run the corrected owner-specific routing tests.

### Incremental Delivery

1. Add the generic result contract correction.
2. Add welcome and transition behavior.
3. Finalize verification and regenerate outputs.
4. Run focused and full validation.

## Notes

- Every task uses the required checkbox, sequential ID, story label where applicable, and exact file path.
- Owner artifact schemas remain out of scope.
