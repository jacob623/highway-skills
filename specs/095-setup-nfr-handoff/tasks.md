# Tasks: Highway Setup NFR Handoff

**Input**: Design documents from `/specs/095-setup-nfr-handoff/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/setup-handoff-contract.md`, `quickstart.md`

**Tests**: Included because the specification defines independent tests and measurable acceptance criteria.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the existing repository surfaces used by this contract-only change.

- [X] T001 Record the current Setup validation baseline by running `.highway/tools/tests/highway-setup.test.sh`, `.highway/tools/tests/highway-setup-executable.test.sh`, `.highway/tools/tests/highway-ux-alignment.test.sh`, and `.highway/tools/tests/feature-092-contract.test.sh`
- [X] T002 Inspect `.highway/skills/highway-setup/SKILL.md`, `.highway/governance/constitution.md`, and `.highway/governance/experience-standard.md` to identify the current version, completion dashboard, owner routing, and applicable review gates

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define focused contract assertions and preserve the existing ownership and correspondence boundaries before changing the canonical skill.

- [X] T003 [P] Add Feature 095 transition, terminal no-interaction, resume, and conclusion assertions to `.highway/tools/tests/highway-setup.test.sh`
- [X] T004 [P] Add executable handoff routing fixtures for Controls `Continue`, fresh `Missing`, fresh `Blocked`, pre-delegation `Complete`, post-collection `Complete`, terminal NFR no-interaction, resumed NFR work, and successful completion to `.highway/tools/tests/highway-setup-executable.test.sh`
- [X] T005 [P] Add exact transition/conclusion wording, dashboard removal, and direct-NFR exclusion checks to `.highway/tools/tests/highway-ux-alignment.test.sh`
- [X] T006 [P] Verify Feature 095 correspondence through the existing generated-adapter and Feature 092 correspondence surfaces

**Checkpoint**: Focused checks express the new contract and preserve existing negative routing assertions before implementation.

## Phase 3: User Story 1 - Handoff from Controls to NFRs (Priority: P1) MVP

**Goal**: Move from authoritative Controls completion into NFR interaction with one Setup-owned transition, while retaining Controls readiness and failure semantics.

**Independent Test**: Run `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh`; verify zero transition messages for active, missing, and blocked Controls, and exactly one transition immediately before the first required NFR interaction for both Controls completion paths.

### Tests for User Story 1

- [X] T007 [US1] Run the new handoff assertions in `.highway/tools/tests/highway-setup.test.sh` and capture the expected pre-implementation failures
- [X] T008 [US1] Run the Controls/NFR routing fixtures in `.highway/tools/tests/highway-setup-executable.test.sh` and capture the expected pre-implementation failures

### Implementation for User Story 1

- [X] T009 [US1] Update the Controls-to-NFR orchestration and exact transition output in `.highway/skills/highway-setup/SKILL.md`, covering `Continue`, fresh `Missing`, fresh `Blocked`, post-collection `Complete`, and pre-delegation `Complete`
- [X] T010 [US1] Gate the transition in `.highway/skills/highway-setup/SKILL.md` on the first actual NFR-owned interaction and suppress it for terminal NFR results that require no interaction, direct `/highway-nfrs` invocation, and resumed NFR work
- [X] T011 [US1] Re-run `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh` and repair only the Setup handoff slice until the User Story 1 independent test passes

**Checkpoint**: Controls transitions naturally into NFRs without changing NFR ownership or manufacturing an interaction.

## Phase 4: User Story 2 - Preserve NFR Ownership and Resume Semantics (Priority: P1)

**Goal**: Delegate all NFR interaction and interpretation to the NFR owner and resume from authoritative state without replaying transient Setup presentation.

**Independent Test**: Run the executable Setup routing tests with interrupted and resumed NFR fixtures; verify unchanged NFR output, no NFR-internal inspection, no restored Setup state, and no duplicate handoff.

### Tests for User Story 2

- [X] T012 [US2] Run the ownership and resume assertions in `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-setup-executable.test.sh` and capture any remaining failures

### Implementation for User Story 2

- [X] T013 [US2] Preserve unchanged NFR delegation, owner-result forwarding, first-incomplete-owner routing, and no-checkpoint resume wording in `.highway/skills/highway-setup/SKILL.md`
- [X] T014 [US2] Verify `.highway/skills/highway-setup/SKILL.md` contains no NFR candidate inspection, candidate handling, NFR question authoring, NFR decision logic, or NFR completion logic
- [X] T015 [US2] Re-run `.highway/tools/tests/highway-setup.test.sh`, `.highway/tools/tests/highway-setup-executable.test.sh`, and `.highway/tools/tests/highway-ux-alignment.test.sh` until the User Story 2 independent test passes

**Checkpoint**: NFRs remains the sole owner of NFR interaction, and New interactions resume deterministically from authoritative owner state.

## Phase 5: User Story 3 - Forward-Looking Setup Conclusion (Priority: P1)

**Goal**: Replace the completion dashboard with the prescribed forward-looking conclusion only after every required owner contract permits successful completion.

**Independent Test**: Run the successful and failure-path fixtures and verify the conclusion appears once only for valid terminal Setup, contains `/highway-help` without invoking it, and contains none of the former dashboard fields.

### Tests for User Story 3

- [X] T016 [US3] Run the conclusion and failure-gating assertions in `.highway/tools/tests/highway-setup.test.sh` and `.highway/tools/tests/highway-ux-alignment.test.sh` and capture the expected pre-implementation failures
- [X] T017 [US3] Run successful, blocked, malformed, declined, aborted, failed-persistence, and repeated-terminal fixtures in `.highway/tools/tests/highway-setup-executable.test.sh`

### Implementation for User Story 3

- [X] T018 [US3] Replace the old completion dashboard with the exact prescribed conclusion and non-invoked `/highway-help` recommendation in `.highway/skills/highway-setup/SKILL.md`
- [X] T019 [US3] Gate the conclusion on all required terminal owner results and suppress it for blocked, incomplete, malformed, declined, aborted, failed, invalid, or non-terminal owner results in `.highway/skills/highway-setup/SKILL.md`
- [X] T020 [US3] Apply the Skill Versioning Policy to the breaking Setup output change and update the canonical version in `.highway/skills/highway-setup/SKILL.md`
- [X] T021 [US3] Re-run `.highway/tools/tests/highway-setup.test.sh`, `.highway/tools/tests/highway-setup-executable.test.sh`, and `.highway/tools/tests/highway-ux-alignment.test.sh` until the User Story 3 independent test passes

**Checkpoint**: Successful Setup ends with the forward-looking conclusion and never claims completion for an invalid owner state.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate distributed outputs, validate correspondence, and complete governance checks.

- [X] T022 Regenerate `.github/skills/highway-setup/SKILL.md`, `.claude/skills/highway-setup/SKILL.md`, `.cursor/rules/highway-setup.mdc`, and affected `.highway/catalog/` outputs from `.highway/skills/highway-setup/SKILL.md` using `.highway/tools/generate-agent-adapters.sh`
- [X] T023 [P] Run `.highway/tools/validate-skill.sh .highway/skills/highway-setup` and verify the amended skill passes Constitution and Experience Standard validation
- [X] T024 [P] Run `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/feature-092-correspondence.test.sh` to verify generated correspondence
- [X] T025 Run `.highway/tools/tests/run-all.sh` and repair only Feature 095 regressions in the canonical skill, focused tests, or generated outputs
- [X] T026 [P] Execute the manual acceptance matrix in `specs/095-setup-nfr-handoff/quickstart.md` and record any remaining human-review result in the Feature 095 completion evidence
- [X] T027 [P] Verify requirement-to-test coverage for FR-001 through FR-015 and update `specs/095-setup-nfr-handoff/quickstart.md` if the final validation command set changes

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establishes the baseline.
- **Foundational (Phase 2)**: Depends on Setup; blocks story work until assertions and fixtures exist.
- **User Stories (Phases 3-5)**: Depend on Foundational. US1 establishes the handoff path; US2 and US3 build on the same Setup orchestration contract and can be implemented sequentially to avoid conflicts in one canonical file.
- **Polish (Phase 6)**: Depends on all three stories; generated outputs must follow the final canonical skill.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Phase 2; MVP and prerequisite for the NFR delegation path.
- **User Story 2 (P1)**: Depends on US1's handoff branch, but its ownership assertions remain independently testable.
- **User Story 3 (P1)**: Depends on the terminal routing established by US1 and the owner-forwarding guarantees preserved by US2.

### Parallel Opportunities

- T003-T006 can run in parallel because they modify separate focused test files.
- T023, T024, T026, and T027 can run in parallel after canonical implementation and regeneration complete.
- US1, US2, and US3 should not modify `SKILL.md` concurrently; they share one canonical orchestration contract.

## Parallel Example: Foundational Tests

```text
Task T003: Extend .highway/tools/tests/highway-setup.test.sh
Task T004: Extend .highway/tools/tests/highway-setup-executable.test.sh
Task T005: Extend .highway/tools/tests/highway-ux-alignment.test.sh
Task T006: Extend .highway/tools/tests/feature-092-contract.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phases 1 and 2.
2. Implement User Story 1 and validate the two Controls completion paths.
3. Confirm the handoff is absent for active, missing, blocked, direct, resumed, and terminal no-interaction paths.

### Incremental Delivery

1. Add User Story 2 to lock NFR ownership and resume behavior.
2. Add User Story 3 to replace the completion claim and enforce failure gating.
3. Regenerate adapters and catalogs, then run focused and full validation.

### Final Validation

Run `specs/095-setup-nfr-handoff/quickstart.md`, `.highway/tools/validate-skill.sh`, correspondence checks, and `.highway/tools/tests/run-all.sh` before reporting completion.

## Notes

- `[P]` tasks touch different files and have no dependency on incomplete work.
- Every story task names an exact artifact path and carries its story label.
- The implementation must not modify `.highway/skills/highway-nfrs/SKILL.md`.
- No new retained storage, runtime dependency, or Setup checkpoint is introduced.