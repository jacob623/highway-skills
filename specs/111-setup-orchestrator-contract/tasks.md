---

description: "Task list for simplifying highway-setup into a thin owner orchestrator"
---

# Tasks: Setup Orchestrator Contract Simplification

**Input**: Design documents from `specs/111-setup-orchestrator-contract/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Contract tests are included because the specification requires verification of routing, delegation, transitions, completion, and removed behavior.

## Phase 1: Setup

**Purpose**: Establish the baseline and identify generated outputs.

- [x] T001 Record the current full-suite result and changed-file baseline in `specs/111-setup-orchestrator-contract/quickstart.md`
- [x] T002 [P] Inspect `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-agent-adapters.sh`, and `.highway/tools/generate-instructions.sh` to identify outputs affected by `highway-setup`

## Phase 2: Foundational

**Purpose**: Define the contract-test inventory before changing the shipped skill.

- [x] T003 Add or update focused test fixtures for owner readiness, collection continuation, malformed results, and owner stop conditions in `.highway/tools/tests/fixtures/`
- [x] T004 [P] Add assertions for the four-owner order and owner-only dependency boundary in `.highway/tools/tests/setup-owner-loop-contract.test.sh`
- [x] T005 [P] Add assertions for the simplified Inputs, Experience, Error Handling, Verification, version, and removed-content contract in `.highway/tools/tests/highway-setup.test.sh`
- [x] T006 [P] Add executable routing cases for Continue, Finished, Declined, Aborted, Blocked, and fresh readiness in `.highway/tools/tests/highway-setup-executable.test.sh`

**Checkpoint**: Focused tests express the target contract and fail against the current `7.0.0` skill where behavior is superseded.

## Phase 3: User Story 1 — Orchestrate owners in order (Priority: P1) 🎯 MVP

**Goal**: Make Setup request readiness in Profile → Objectives → Controls → NFRs order and delegate only owner-supplied actions.

**Independent Test**: Run the owner-loop and Setup contract tests with fixtures for terminal, active, blocked, malformed, and unsupported owner results.

- [x] T007 [US1] Rewrite `## Inputs` in `.highway/skills/highway-setup/SKILL.md` to name only the project root, four owner contracts, Experience Standard, and active user request
- [x] T008 [US1] Replace the 30-step workflow, Profile routing, Controls orchestration state, and owner-internal routing with the generic owner loop in `.highway/skills/highway-setup/SKILL.md`
- [x] T009 [US1] Define owner advancement, delegation, malformed-result, blocked-result, declined-result, aborted-result, and unsupported-action behavior in `.highway/skills/highway-setup/SKILL.md`
- [x] T010 [US1] Remove Setup inspection of owner records, catalogs, candidate state, counts, relationships, identifiers, and persistence results from `.highway/skills/highway-setup/SKILL.md`
- [x] T011 [US1] Update `.highway/tools/tests/setup-owner-loop-contract.test.sh` and `.highway/tools/tests/highway-setup.test.sh` to pass the simplified owner-order and delegation contract

**Checkpoint**: User Story 1 is independently testable and Setup no longer derives owner state.

## Phase 4: User Story 2 — Continue and resume owner collection safely (Priority: P1)

**Goal**: Route collection Continue/Finished outcomes through fresh owner readiness without Setup checkpoints or conversational restoration.

**Independent Test**: Run executable Setup tests covering Continue, Finished, Declined, Aborted, Blocked, malformed, and new-interaction cases.

- [x] T012 [US2] Add the generic collection loop and four-field owner result contract to `.highway/skills/highway-setup/SKILL.md`
- [x] T013 [US2] Add the fresh-readiness and no-Setup-checkpoint resume rule to `.highway/skills/highway-setup/SKILL.md`
- [x] T014 [US2] Replace the per-step Error Handling table with Setup-specific exceptions in `.highway/skills/highway-setup/SKILL.md`
- [x] T015 [US2] Remove verified-completion, retained-output-verification, failed-persistence, owner-state inventory, and transient resume language from `.highway/skills/highway-setup/SKILL.md`
- [x] T016 [US2] Update `.highway/tools/tests/highway-setup-executable.test.sh` and `.highway/tools/tests/setup-owner-loop-contract.test.sh` for collection continuation and fresh-readiness behavior

**Checkpoint**: User Story 2 is independently testable without Setup-owned durable state.

## Phase 5: User Story 3 — Provide concise domain transitions and completion (Priority: P1)

**Goal**: Emit concise Setup transitions and the exact forward-looking completion message without duplicating owner interaction.

**Independent Test**: Assert transition wording, horizontal separation, absence of owner labels/openings, and exact single final completion output.

- [x] T017 [US3] Replace Objective, Controls, and NFR transition text in `.highway/skills/highway-setup/SKILL.md` with the specified concise transitions
- [x] T018 [US3] Remove `Setup-owned:` and `Objectives-owned:` labels, copied owner openings, copied examples, recommendation previews, and the former completion dashboard from `.highway/skills/highway-setup/SKILL.md`
- [x] T019 [US3] Add the exact final completion message and one-time completion condition to `.highway/skills/highway-setup/SKILL.md`
- [x] T020 [US3] Replace the local Experience and Guided Setup sections with the Experience Standard reference in `.highway/skills/highway-setup/SKILL.md`
- [x] T021 [US3] Update `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh` for transitions and completion

**Checkpoint**: User Story 3 is independently testable from the emitted Setup text and owner forwarding behavior.

## Phase 6: User Story 4 — Keep the Setup contract thin and governance-aligned (Priority: P2)

**Goal**: Finalize versioning, Verification, generated artifacts, and shared-governance boundaries.

**Independent Test**: Validate the canonical skill, generated artifacts, focused tests, and full suite against the simplified contract.

- [x] T022 [US4] Rewrite the Outputs and Verification sections in `.highway/skills/highway-setup/SKILL.md` to cover only owner-result consumption, routing, transitions, no writes/checkpoints, resume, and completion
- [x] T023 [US4] Set `metadata.version` to `8.0.0` and remove all historical `Created Control IDs`, step-number, owner-internal, and persistence-verification references from `.highway/skills/highway-setup/SKILL.md`
- [x] T024 [US4] Regenerate `.highway/catalog/`, `.github/`, `.claude/`, `.cursor/`, and `.codex/` outputs using the repository's declared generators after the canonical skill is complete
- [x] T025 [US4] Update generated-artifact expectations in `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/runtime-contract-hygiene.test.sh` where the old Setup contract is asserted

**Checkpoint**: All four user stories are implemented and generated outputs are synchronized.

## Phase 7: Polish & Cross-Cutting Validation

**Purpose**: Run the documented validation and confirm no adjacent owner schema changed.

- [x] T026 [P] Compare `.highway/skills/highway-profile/SKILL.md`, `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, and `.highway/skills/highway-nfrs/SKILL.md` to confirm owner contracts were not structurally changed
- [x] T027 [P] Run `git diff --check` across the canonical skill, tests, generated outputs, and feature artifacts
- [x] T028 Run `.highway/tools/tests/highway-setup.test.sh`, `.highway/tools/tests/highway-setup-executable.test.sh`, and `.highway/tools/tests/setup-owner-loop-contract.test.sh`
- [x] T029 Run `.highway/tools/tests/run-all.sh` and record the passing result in `specs/111-setup-orchestrator-contract/quickstart.md`
- [x] T030 Confirm no `[NEEDS CLARIFICATION]` markers or task placeholders remain in `specs/111-setup-orchestrator-contract/`

## Dependencies & Execution Order

### Phase Dependencies

- Phase 1 has no dependencies.
- Phase 2 depends on Phase 1 and blocks all story work.
- User Stories 1–3 depend on Phase 2; User Story 4 depends on Stories 1–3 because it finalizes the complete contract and generated outputs.
- Phase 7 depends on all implementation stories and regeneration.

### User Story Dependencies

- **US1**: Starts after Phase 2; establishes the generic routing contract.
- **US2**: Depends on US1's routing boundary; adds collection and resume semantics.
- **US3**: Depends on US1 and US2; adds user-visible transitions and completion.
- **US4**: Depends on US1–US3; finalizes verification, versioning, and generated artifacts.

### Parallel Opportunities

- T004–T006 can run in parallel after T003.
- T017–T020 can be drafted in parallel, then integrated into the single canonical skill in sequence.
- T026 and T027 can run in parallel after regeneration.
- Different test files can be prepared in parallel when they do not modify the same assertions.

## Implementation Strategy

### MVP First

1. Complete Phases 1–2.
2. Complete User Story 1.
3. Run the owner-order and delegation tests.
4. Stop for review if the thin orchestrator contract is sufficient as the MVP.

### Incremental Delivery

1. Add collection/resume semantics from US2.
2. Add transitions and completion from US3.
3. Finalize Verification, versioning, and generated artifacts in US4.
4. Run the complete suite and quickstart validation.

## Notes

- Every task uses the required checkbox, sequential ID, optional parallel marker, story label where applicable, and an exact file path.
- Owner artifact schemas remain out of scope.
