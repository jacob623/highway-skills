# Tasks: Readiness Ownership Refactor

**Input**: Design documents from `/specs/037-readiness-ownership-refactor/`
**Branch**: `037-readiness-ownership-refactor`

## Implementation Strategy

Deliver the smallest useful increment first: implement and verify the shared read-only readiness contract across all four owners (US1), then prove owner-specific state classification and no-write behavior (US2), then refactor Setup to consume the owner responses and route deterministically (US3). Finish with generated-artifact, documentation, full-suite, and requirement-coverage checks.

## Dependencies

- Phase 1 setup tasks precede all other tasks.
- Phase 2 foundational tasks precede user-story tasks.
- US1 precedes US2 because owner response parsing and action boundaries are prerequisites for owner-state fixture coverage.
- US2 precedes US3 because Setup routing depends on the owner status matrix and blocking-reason semantics.
- Final polish follows US1, US2, and US3.

Dependency graph: `Setup -> Foundational -> US1 -> US2 -> US3 -> Polish`

## Parallel Execution Examples

### US1

After T002 completes, T005, T006, T007, and T008 can run in parallel because they modify different owner skill files.

### US2

After US1, T010 and T011 can run in parallel because the fixture matrix and static ownership check are separate test files.

### US3

T013 and T014 can run in parallel after US2 because the Setup skill and its focused test changes are separate files, but T015 depends on both.

## Phase 1: Setup

- [X] T001 Confirm the Feature 037 source paths, existing owner artifact validators, and baseline test commands in `.highway/skills/`, `.highway/tools/tests/`, and `specs/037-readiness-ownership-refactor/`
- [X] T002 Record the shared four-field readiness contract and allowed statuses in `specs/037-readiness-ownership-refactor/contracts/shared-readiness-contract.md`

## Phase 2: Foundational

- [X] T003 Extend readiness response assertions for exact field order, allowed statuses, and blocking-reason rules in `.highway/tools/tests/test-helpers.sh`
- [X] T004 Add static contract assertions for readiness action names, field order, status vocabulary, and required ownership documentation in `.highway/tools/tests/readiness-contract.test.sh`

## Phase 3: User Story 1 - Query owner readiness consistently (Priority: P1)

**Goal**: All four owner skills expose the same deterministic, read-only readiness response.

**Independent Test**: Run `.highway/tools/tests/readiness-ownership.test.sh` and verify every owner emits exactly four ordered fields with an allowed status and no artifact or identifier mutation.

- [X] T005 [US1] Add the explicit read-only `/highway-profile readiness` action, four-field response, and Profile identity evaluation to `.highway/skills/highway-profile/SKILL.md`
- [X] T006 [P] [US1] Add the explicit read-only `/highway-objectives readiness` action, four-field response, and Objective baseline evaluation to `.highway/skills/highway-objectives/SKILL.md`
- [X] T007 [P] [US1] Add the explicit read-only `/highway-controls readiness` action, four-field response, and Control baseline evaluation to `.highway/skills/highway-controls/SKILL.md`
- [X] T008 [P] [US1] Add the explicit read-only `/highway-nfrs readiness` action, four-field response, and NFR candidate/accepted-artifact evaluation to `.highway/skills/highway-nfrs/SKILL.md`
- [X] T009 [US1] Add the shared owner fixture runner, response parser, no-write hash checks, and repeated-run determinism assertions for Profile, Objectives, Controls, and NFRs in `.highway/tools/tests/readiness-ownership.test.sh`

## Phase 4: User Story 2 - Keep readiness rules with the owning artifacts (Priority: P1)

**Goal**: Owner-specific validity and state transitions remain in the owning skills, with malformed and contradictory inputs classified without mutation.

**Independent Test**: Run the owner-state fixture and ownership-boundary tests; verify missing, blocked, complete, in-progress, and not-applicable outcomes, non-empty blocked reasons, and unchanged artifacts across three runs.

- [X] T010 [US2] Add Profile identity, malformed-profile, empty/whitespace, and valid-profile fixture cases with expected readiness responses in `.highway/tools/tests/readiness-owner-states.test.sh`
- [X] T011 [P] [US2] Add Objective, Control, and NFR malformed, missing, complete, pending, zero-candidate, and accepted-artifact fixture cases with expected responses in `.highway/tools/tests/readiness-owner-states.test.sh`
- [X] T012 [US2] Add static ownership-boundary checks proving owner skills contain readiness rules and Setup does not contain duplicated owner completeness predicates in `.highway/tools/tests/readiness-contract.test.sh`
- [X] T013 [US2] Document owner-specific readiness state tables and next actions in `.highway/skills/highway-profile/SKILL.md`, `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, and `.highway/skills/highway-nfrs/SKILL.md`

## Phase 5: User Story 3 - Orchestrate by readiness results (Priority: P1)

**Goal**: Setup invokes owners in order, short-circuits on the first non-complete prerequisite, and preserves zero-NFR completion semantics.

**Independent Test**: Run `.highway/tools/tests/highway-setup.test.sh` with ordered response fixtures; verify call order, short-circuiting, owner-provided dashboard fields, distinct NFR routes, and `NFRs: Not Applicable` completion.

- [X] T014 [US3] Refactor ordered readiness workflow, response consumption, malformed-response handling, and dashboard routing in `.highway/skills/highway-setup/SKILL.md`
- [X] T015 [P] [US3] Extend ordered Setup fixtures for Profile, Objectives, Controls, and NFR statuses, including call-order sentinels and downstream non-inspection checks in `.highway/tools/tests/highway-setup.test.sh`
- [X] T016 [US3] Add Setup assertions for owner summaries, next actions, blocked reasons, distinct NFR activities, and zero-candidate completion in `.highway/tools/tests/highway-setup.test.sh`
- [X] T017 [US3] Reconcile the Setup workflow with the formal routing contract and document orchestration-only ownership in `specs/037-readiness-ownership-refactor/contracts/setup-readiness-contract.md` and `.highway/skills/highway-setup/SKILL.md`

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T018 [P] Update readiness ownership and response references in `.highway/skills/highway-profile/SKILL.md`, `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, `.highway/skills/highway-nfrs/SKILL.md`, and `.highway/skills/highway-setup/SKILL.md`
- [X] T019 [P] Add executable/static/generated/limitation evidence reporting guidance in `specs/037-readiness-ownership-refactor/contracts/verification-evidence-contract.md` and `specs/037-readiness-ownership-refactor/quickstart.md`
- [X] T020 Regenerate catalogs and agent adapters from changed skill inputs using `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh`, without hand-editing generated files
- [X] T021 Run skill validators and generated-artifact correspondence checks through `.highway/tools/tests/validate-skill.test.sh` and `.highway/tools/tests/adapter-coverage.test.sh`
- [X] T022 Run focused readiness tests and the complete suite with `.highway/tools/tests/readiness-ownership.test.sh`, `.highway/tools/tests/readiness-owner-states.test.sh`, `.highway/tools/tests/highway-setup.test.sh`, and `.highway/tools/tests/run-all.sh`
- [X] T023 Record exact FR-001 through FR-015 coverage against changed artifacts and any explicit deferral in `specs/037-readiness-ownership-refactor/requirements-coverage.md`
- [X] T024 Verify three-run determinism, no-write artifact hashes, zero generated NFR artifacts for `Not Applicable`, and clean whitespace with `.highway/tools/tests/readiness-ownership.test.sh` and `git diff --check`
- [X] T025 Review the final changed-file set against the Feature 037 plan, contracts, constitution gates, and `specs/037-readiness-ownership-refactor/tasks.md`

## Completion Criteria

- All task checkboxes are complete.
- All four owners satisfy the shared readiness contract.
- Setup routes only from owner responses and preserves zero-NFR behavior.
- Focused and full test suites pass.
- Generated artifacts are regenerated and correspondence checks pass.
- `requirements-coverage.md` covers every functional requirement exactly once.
