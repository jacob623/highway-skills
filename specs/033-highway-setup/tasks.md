# Tasks: Highway Setup Orchestration

**Input**: Design documents from `/specs/033-highway-setup/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

## Implementation Strategy

Deliver the smallest independently testable onboarding slice first: the ordered readiness evaluator and in-progress dashboard. Add owner delegation and continuation next, then exact completion guidance and safe-stop coverage. Finish by regenerating registration artifacts, running the full suite, and recording exact requirement coverage.

## Dependencies

- Phase 1 precedes all other phases.
- Phase 2 precedes every user story because the source skill contract and focused fixture harness are shared foundations.
- User Story 1 precedes User Story 2 because delegation depends on the ordered readiness state model.
- User Story 3 may proceed after Phase 2, but final dashboard validation depends on the state model from User Story 1.
- User Story 4 depends on User Stories 1 and 2 because safe stopping validates owner results against the orchestration loop.
- Polish follows all user stories and includes generated artifact regeneration and full-suite validation.

## Parallel Execution Examples

### User Story 1

```text
T004 and T005 can run in parallel after T003: the skill contract skeleton and disposable fixture harness touch different files.
```

### User Story 2

```text
T008 and T009 can run in parallel after T007: owner delegation rules and continuation assertions are separate sections of the skill and test fixture.
```

### User Story 3

```text
T011 and T012 can run in parallel after T010: output contract assertions and ownership-route assertions are independent test concerns.
```

### User Story 4

```text
T014 and T015 can run in parallel after T013: failure-state assertions and no-direct-write assertions cover separate behaviors.
```

## Phase 1: Setup

- [X] T001 Confirm the active Feature 033 paths and existing owner skill contracts in `.highway/skills/highway-profile/SKILL.md`, `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, and `.highway/skills/highway-nfrs/SKILL.md`
- [X] T002 [P] Record the planned Feature 033 source, test, generated-artifact, and coverage paths in `specs/033-highway-setup/plan.md`

## Phase 2: Foundational

- [X] T003 Create the `highway-setup` skill frontmatter, Purpose, Inputs, ownership boundaries, and invocation contract in `.highway/skills/highway-setup/SKILL.md`
- [X] T004 [P] Create the disposable repository fixture harness, assertion helpers, and temporary-tree cleanup in `.highway/tools/tests/highway-setup.test.sh`
- [X] T005 [P] Add the ordered setup-state entity, status vocabulary, and transition rules to `.highway/skills/highway-setup/SKILL.md` using `specs/033-highway-setup/data-model.md`
- [X] T006 Add the ordered decision table and explicit project-root discovery behavior to `.highway/skills/highway-setup/SKILL.md`, including a failure path for every numbered step

## Phase 3: User Story 1 - Assess setup readiness in governance order (Priority: P1)

**Goal**: Determine Profile, Business Objective, Control, and NFR readiness in strict order and mark downstream areas `Not Evaluated` after the first incomplete prerequisite.

**Independent Test**: Run `.highway/tools/tests/highway-setup.test.sh` against empty, Profile-only, Profile-plus-Objectives, Profile-plus-Objectives-plus-Controls, and complete fixture trees; assert evaluation order and statuses.

- [X] T007 [US1] Implement Profile readiness rules, including missing profile and empty `organization.name`, in `.highway/skills/highway-setup/SKILL.md`
- [X] T008 [P] [US1] Implement Business Objective readiness rules for missing or empty user-owned objective records in `.highway/skills/highway-setup/SKILL.md`
- [X] T009 [P] [US1] Implement Control and NFR readiness rules, including accepted-NFR completion and downstream `Not Evaluated` behavior, in `.highway/skills/highway-setup/SKILL.md`
- [X] T010 [US1] Add ordered readiness and status assertions for FR-002 through FR-007 in `.highway/tools/tests/highway-setup.test.sh`

## Phase 4: User Story 2 - Complete missing setup through owning workflows (Priority: P1)

**Goal**: Invoke the correct owner workflow for the first incomplete area, reassess after success, and continue through the next incomplete area without requiring the user to select underlying skills.

**Independent Test**: Use deterministic owner-workflow stubs in `.highway/tools/tests/highway-setup.test.sh` and verify Profile -> Objectives -> Controls -> NFR proposal ordering, reassessment, and automatic continuation.

- [X] T011 [US2] Add Profile, Business Objective, and Control delegation steps with exact owner routes and successful-result reassessment in `.highway/skills/highway-setup/SKILL.md`
- [X] T012 [US2] Add the Control-owned NFR proposal handoff, author-acceptance pause, and NFR-owner completion boundary in `.highway/skills/highway-setup/SKILL.md`
- [X] T013 [P] [US2] Add owner-call ordering, continuation, and NFR-pending assertions for FR-008 through FR-012 in `.highway/tools/tests/highway-setup.test.sh`

## Phase 5: User Story 3 - Show status and completion guidance (Priority: P1)

**Goal**: Emit deterministic in-progress and complete dashboards with exact status ordering and ownership routes.

**Independent Test**: Compare fixture output byte-for-byte with `specs/033-highway-setup/contracts/setup-output.md` for incomplete and complete repository states.

- [X] T014 [US3] Add the exact complete and in-progress dashboard output contracts, current-activity rules, and ownership guidance to `.highway/skills/highway-setup/SKILL.md`
- [X] T015 [P] [US3] Add byte-for-byte complete and in-progress dashboard assertions for FR-013 through FR-015 in `.highway/tools/tests/highway-setup.test.sh`
- [X] T016 [P] [US3] Verify the dashboard ownership routes match `specs/033-highway-setup/contracts/setup-output.md` and `specs/033-highway-setup/contracts/owner-delegation.md` without adding alternate artifact paths

## Phase 6: User Story 4 - Preserve ownership and stop safely (Priority: P2)

**Goal**: Stop on declined, failed, malformed, or incomplete owner outcomes, preserve existing bytes, and never directly author foundational artifacts.

**Independent Test**: Run owner-result fixtures for every failure state and a repeated complete-state fixture; assert no downstream call, no false completion, and unchanged artifact hashes/content.

- [X] T017 [US4] Add explicit error handling for declined, failed, malformed, incomplete, pending, and missing-root outcomes in `.highway/skills/highway-setup/SKILL.md`
- [X] T018 [P] [US4] Add failure-stop, no-downstream-call, no-direct-write, idempotence, and byte-preservation assertions for FR-016 through FR-018 in `.highway/tools/tests/highway-setup.test.sh`
- [X] T019 [US4] Add a manual ownership review checklist to `specs/033-highway-setup/contracts/owner-delegation.md` confirming setup never creates, updates, removes, or replaces owner records

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T020 [P] Run `.highway/tools/validate-skill.sh .highway/skills/highway-setup` and fix all structural, frontmatter, workflow, and constitution-citation findings in `.highway/skills/highway-setup/SKILL.md`
- [X] T021 Regenerate catalog, adapter, adapter-manifest, and distribution artifacts with the repository's declared generators after adding `.highway/skills/highway-setup/`
- [X] T022 [P] Run `.highway/tools/tests/highway-setup.test.sh` and record the focused behavioral result in `specs/033-highway-setup/quickstart.md`
- [X] T023 Run `.highway/tools/tests/run-all.sh` and resolve any Feature 033 regressions without weakening existing assertions
- [X] T024 [P] Verify `specs/033-highway-setup/checklists/requirements.md` remains fully checked after implementation without changing reviewer-owned markers
- [X] T025 Create `specs/033-highway-setup/coverage.md` mapping FR-001 through FR-018 exactly once to the satisfying skill, test, contract, or explicit deferral
- [X] T026 Review completed changes in `.highway/skills/highway-setup/SKILL.md`, `.highway/tools/tests/highway-setup.test.sh`, generated catalog and adapter manifests, and `specs/033-highway-setup/coverage.md`; confirm no generated file was hand-edited and report test results separately from requirement coverage

## Requirement Coverage

Coverage is completed by T025 after implementation. Every FR-001 through FR-018 must appear exactly once in `specs/033-highway-setup/coverage.md`, mapped to a concrete artifact or an explicit deferral.

## MVP Scope

The MVP is User Story 1: the skill can determine ordered readiness and show the in-progress dashboard. User Story 2 is the next required increment for usable onboarding; User Stories 3 and 4 complete the user-facing contract and governance safety behavior.
