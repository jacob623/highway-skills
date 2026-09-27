---
description: "Implementation tasks for Conversational Control Discovery"
---

# Tasks: Conversational Control Discovery

**Input**: Design documents from `/specs/094-conversational-control-discovery/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Organization**: Tasks are grouped by user story. Tests are included because the specification explicitly requires focused behavioral fixtures and contract verification.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the implementation surface and baseline evidence before changing shipped skill contracts.

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root, allowing up to 240 seconds for completion, and record the pre-change result in `specs/094-conversational-control-discovery/quickstart.md`
- [X] T002 [P] Inventory canonical and generated Controls, Setup, NFR, UX, template, and test paths in `specs/094-conversational-control-discovery/plan.md`
- [X] T003 [P] Map FR-001 through FR-042k and SC-001 through SC-027 to implementation files and tests in `specs/094-conversational-control-discovery/coverage.md`
- [X] T004 [P] Record the existing Controls/NFR ownership and version contracts in `specs/094-conversational-control-discovery/contracts/controls-nfr-candidate.md`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared owner-result, readiness, and output contracts before story-specific workflow changes.

- [X] T005 [P] Add failing contract fixtures for separate Controls Action Result and Controls Readiness Result shapes in `.highway/tools/tests/highway-controls-onboarding.test.sh`
- [X] T006 [P] Add failing fixture coverage for immediate candidate generation, durable candidate readiness, zero candidates, and blocked generation in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T007 [P] Add failing fixture coverage for Setup consuming delegated action results before fresh readiness in `.highway/tools/tests/setup-owner-loop-contract.test.sh`
- [X] T008 [P] Add failing fixture coverage for no transient restoration and false completion after failed persistence in `.highway/tools/tests/highway-setup.test.sh`
- [X] T009 Reconcile the Controls/NFR ownership, candidate timing, readiness, output, and version contracts in `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-nfrs/SKILL.md`
- [X] T010 Update the shared proposal, continuation, owner-outcome, and machine-output wording in `.highway/skills/_authoring-standard.md`
- [X] T011 Update the retained Control and NFR output contract references without adding Concern, Condition, Obligation, or classification fields in `.highway/library/templates/output/control-record.md` and `.highway/library/templates/output/nfr-record.md`
- [X] T012 Run the focused failing fixtures from T005-T008 and record their observed failures before implementing story behavior in `specs/094-conversational-control-discovery/quickstart.md`

## Phase 3: User Story 1 - Controls Handoff From Setup (Priority: P1) MVP

**Goal**: Make Setup introduce Controls exactly once, delegate the owner action, consume its result, and use fresh readiness without taking ownership of discovery.

**Independent Test**: Run Setup with non-terminal Controls readiness, terminal pre-delegation `Complete`, successful `Continue`, explicit `Finished`, `Blocked`, `Declined`, `Aborted`, malformed, and failed-persistence results. Verify exact transition/opening, no Setup-written Controls, action-result-before-readiness ordering, and no false completion.

### Tests for User Story 1

- [X] T013 [P] [US1] Add exact Setup transition/opening and pre-delegation `Complete` fixtures in `.highway/tools/tests/highway-setup.test.sh`
- [X] T014 [P] [US1] Add delegated action-result ordering and non-terminal collection fixtures in `.highway/tools/tests/setup-owner-loop-contract.test.sh`
- [X] T015 [P] [US1] Add explicit-finish, zero-Control, blocked-owner, and false-completion fixtures in `.highway/tools/tests/highway-setup-executable.test.sh`

### Implementation for User Story 1

- [X] T016 [US1] Rewrite Setup Controls routing, delegated-result consumption, fresh-readiness sequencing, and `/highway-controls setup` routing in `.highway/skills/highway-setup/SKILL.md`
- [X] T017 [US1] Add Setup Outputs, Verification, and failure-map requirements for Controls transition, exact opening, explicit finish, and false completion in `.highway/skills/highway-setup/SKILL.md`
- [X] T018 [US1] Replace legacy Controls setup handoff references with the Controls Action Result and Controls Readiness Result contracts in `.highway/skills/highway-setup/SKILL.md`
- [X] T019 [US1] Run the User Story 1 focused Setup and owner-loop fixtures and update `specs/094-conversational-control-discovery/quickstart.md` with observed outcomes

**Checkpoint**: Setup can safely reach Controls and cannot claim completion from readiness alone.

## Phase 4: User Story 2 - Adaptive Control Discovery (Priority: P1)

**Goal**: Replace fixed categories with bounded Concern/Condition/Obligation reasoning, NFR classification, normal proposals, and explicit vague-wording overrides.

**Independent Test**: Invoke Controls with concern-only, condition-rich, complete obligation, rich multi-dimension, NFR-shaped, ambiguous, formal, ordinary-language, uncertain, and vague override inputs. Verify one unresolved question or decision and no historical category progress.

### Tests for User Story 2

- [X] T020 [P] [US2] Add adaptive branching and one-question fixtures for Concern, Condition, Obligation, grouping, NFR classification, and ambiguity in `.highway/tools/tests/highway-controls-onboarding.test.sh`
- [X] T021 [P] [US2] Add user-override, ordinary-language, formal-language, mature-language, and no-dimension-progress fixtures in `.highway/tools/tests/highway-ux-alignment.test.sh`
- [X] T022 [P] [US2] Add exact proposal action-first framing and retained-field fixtures in `.highway/tools/tests/output-template.test.sh`

### Implementation for User Story 2

- [X] T023 [US2] Replace category onboarding and legacy batch Review Complete behavior with numbered adaptive discovery steps in `.highway/skills/highway-controls/SKILL.md`
- [X] T024 [US2] Add deterministic grouping, NFR classification, ambiguous routing, and user-override branching in `.highway/skills/highway-controls/SKILL.md`
- [X] T025 [US2] Add human-facing proposal framing with action first and distinct title, statement, and rationale sections in `.highway/skills/highway-controls/SKILL.md`
- [X] T026 [US2] Add direct `add` one-Control behavior and preserve Update, Remove, and Set action-selection safeguards in `.highway/skills/highway-controls/SKILL.md`
- [X] T027 [US2] Add organizational-language, no-persona, no-jargon, and no-ceremonial-context-question verification cases to `.highway/tools/tests/highway-controls-onboarding.test.sh`
- [X] T028 [US2] Run adaptive discovery and proposal fixtures and record contract versus runtime evidence in `specs/094-conversational-control-discovery/coverage.md`

**Checkpoint**: A complete or explicitly overridden user-owned Control can reach proposal without fixed-category ceremony.

## Phase 5: User Story 3 - Context-Aware Guidance (Priority: P1)

**Goal**: Use accepted context deterministically for guidance while preserving user authority, Profile ownership, optional-context tolerance, and relevant-connection boundaries.

**Independent Test**: Run identical discovery with accepted context, conflicting active input, Profile `Blocked`, malformed optional context, absent optional context, unrelated context, and direct complete obligation without Profile/Objectives.

### Tests for User Story 3

- [X] T029 [P] [US3] Add context-priority and active-user-precedence fixtures in `.highway/tools/tests/profile-participation.test.sh`
- [X] T030 [P] [US3] Add Profile owner-Blocked and optional malformed-context fixtures in `.highway/tools/tests/profile-context-contract.test.sh`
- [X] T031 [P] [US3] Add relevant-connection versus persisted-relationship and no-extra-question fixtures in `.highway/tools/tests/highway-ux-alignment.test.sh`

### Implementation for User Story 3

- [X] T032 [US3] Declare every Controls context document and accepted artifact path in the Inputs contract of `.highway/skills/highway-controls/SKILL.md`
- [X] T033 [US3] Add deterministic context priority, Profile owner-result consumption, optional-context exclusion, and direct no-context behavior in `.highway/skills/highway-controls/SKILL.md`
- [X] T034 [US3] Define relevant connection as advisory and preserve identifier-only `nfrs` relationships in `.highway/skills/highway-controls/SKILL.md` and `.highway/library/templates/output/control-record.md`
- [X] T035 [US3] Add context acknowledgment, Decision Context, adaptive examples, and no-ceremonial-question behavior to `.highway/skills/highway-controls/SKILL.md`
- [X] T036 [US3] Run context participation, Profile, and UX fixtures and record PASS/FAIL/N/A/DEFERRED applicability evidence in `specs/094-conversational-control-discovery/coverage.md`

**Checkpoint**: Context improves guidance without becoming policy, inventing facts, or creating new relationships.

## Phase 6: User Story 4 - Natural Proposal and Persistence (Priority: P1)

**Goal**: Persist accepted Controls atomically with existing identifiers, versions, catalogs, safeguards, reuse semantics, and completion integrity.

**Independent Test**: Exercise accept, correction, replacement, rejection, cancellation, interruption, reuse, exact duplicate, decision-changing overlap, write failure, verification failure, and multi-Control version behavior.

### Tests for User Story 4

- [X] T037 [P] [US4] Add proposal correction, rejection, cancellation, interruption, and failed-write fixtures in `.highway/tools/tests/highway-controls-onboarding.test.sh`
- [X] T038 [P] [US4] Add exact reuse no-write/no-version/no-relationship/no-candidate fixtures in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T039 [P] [US4] Add overlap revalidation and confirmation invalidation fixtures in `.highway/tools/tests/relationship-integrity.test.sh`
- [X] T040 [P] [US4] Add one-Add-per-Control MINOR version and abandoned-next-proposal fixtures in `.highway/tools/tests/readiness-executable.test.sh`

### Implementation for User Story 4

- [X] T041 [US4] Implement per-Control Add persistence, retained-output verification, prior-baseline preservation, and post-persistence identifier/version reporting in `.highway/skills/highway-controls/SKILL.md`
- [X] T042 [US4] Preserve exact duplicate, decision-changing overlap, target resolution, and destructive-action safeguards in `.highway/skills/highway-controls/SKILL.md`
- [X] T043 [US4] Define accepted-Control reuse as adopted equivalent governance and keep reused IDs out of `Created Control IDs` in `.highway/skills/highway-controls/SKILL.md`
- [X] T044 [US4] Preserve retained Control fields and identifier-only relationships in `.highway/library/templates/output/control-record.md`
- [X] T045 [US4] Run persistence, reuse, overlap, and version fixtures and separate static contract evidence from executed behavior in `specs/094-conversational-control-discovery/coverage.md`

**Checkpoint**: Every accepted new Control is durable and every non-acceptance or failure path is non-writing and non-completing.

## Phase 7: User Story 5 - Durable Baseline and Continuation (Priority: P2)

**Goal**: Continue setup/configure after readiness becomes Complete, finish explicitly, generate NFR candidates immediately, and defer only NFR review.

**Independent Test**: Create Control 1, verify candidate generation and readiness state, continue to Control 2, interrupt before finish, start a new invocation, then finish and exercise NFR review, zero-candidate, and blocked-candidate paths.

### Tests for User Story 5

- [X] T046 [P] [US5] Add continuation prompt, affirmative continuation, direct evidence, suggestions, help, finish, and pause fixtures in `.highway/tools/tests/highway-controls-onboarding.test.sh`
- [X] T047 [P] [US5] Add immediate candidate generation, exactly-once classification, interruption, zero-candidate, and blocked-generation fixtures in `.highway/tools/tests/control-derived-nfr.test.sh`
- [X] T048 [P] [US5] Add NFR readiness outcomes for zero candidates, none accepted, accepted artifacts, malformed result, and generation failure in `.highway/tools/tests/highway-nfr-onboarding.test.sh`
- [X] T049 [P] [US5] Add Setup stop-before-NFR-review and fresh-readiness fixtures in `.highway/tools/tests/highway-setup.test.sh`

### Implementation for User Story 5

- [X] T050 [US5] Add cumulative collection result, explicit finish, continuation, pause, and no-restoration workflow steps in `.highway/skills/highway-controls/SKILL.md`
- [X] T051 [US5] Move candidate generation to the verified per-Control persistence boundary and preserve stable normalized title/statement derivation in `.highway/skills/highway-controls/SKILL.md`
- [X] T052 [US5] Add durable candidate-generation readiness, zero-candidate Not Applicable, blocked-generation, and deferred-review behavior in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T053 [US5] Update Setup's NFR routing to consume Controls finish, fresh Controls readiness, and NFR readiness without inferring completion in `.highway/skills/highway-setup/SKILL.md`
- [X] T054 [US5] Update Controls/NFR versions, ownership references, and downstream output contracts in `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-nfrs/SKILL.md`
- [X] T055 [US5] Run continuation, interruption, candidate, and NFR readiness fixtures and record results in `specs/094-conversational-control-discovery/coverage.md`

**Checkpoint**: An interrupted collection cannot lose downstream candidate processing, and Setup advances only through explicit finish plus valid owner readiness.

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Reconcile generated artifacts, documentation, compliance evidence, and the complete verification surface.

- [X] T056 [P] Regenerate catalogs, adapters, manifests, and distributed copies from canonical sources using `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T057 [P] Update live documentation and usage examples affected by Controls, Setup, and NFR behavior in `README.md`, `.highway/skills/highway-controls/SKILL.md`, `.highway/skills/highway-setup/SKILL.md`, and `.highway/skills/highway-nfrs/SKILL.md`
- [X] T058 [P] Complete the phase-specific PASS/FAIL/N/A/DEFERRED compliance matrix in `specs/094-conversational-control-discovery/coverage.md`
- [X] T059 Run all focused Feature 094 checks from `specs/094-conversational-control-discovery/quickstart.md`
- [X] T060 Run `.highway/tools/tests/run-all.sh`, allowing up to 240 seconds for completion, and resolve any Feature 094 failure without weakening existing assertions
- [X] T061 Run `.specify/scripts/bash/check-prerequisites.sh --json --paths-only`, generated-artifact correspondence checks, and `git diff --check`; record the results in `specs/094-conversational-control-discovery/coverage.md`
- [X] T062 Reconcile the final implementation against `specs/094-conversational-control-discovery/spec.md`, `specs/094-conversational-control-discovery/plan.md`, and all contracts before claiming completion

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 Setup**: No implementation dependency; establishes baseline and coverage records.
- **Phase 2 Foundational**: Depends on Phase 1 and blocks all story work because owner-result and candidate contracts are shared.
- **Phase 3 User Story 1**: Depends on Phase 2; MVP handoff can be delivered and tested independently.
- **Phase 4 User Story 2**: Depends on Phase 2; can proceed in parallel with US1 when canonical Controls edits are coordinated.
- **Phase 5 User Story 3**: Depends on US2's adaptive discovery boundary and Phase 2 owner contracts.
- **Phase 6 User Story 4**: Depends on US2 proposal behavior and Phase 2 persistence contracts.
- **Phase 7 User Story 5**: Depends on US1, US4, and the reconciled Controls/NFR contracts because it integrates continuation, persistence, and downstream readiness.
- **Phase 8 Polish**: Depends on all desired stories and all canonical source edits.

### User Story Dependencies

- **US1 (P1)**: Phase 2 only; MVP and independently testable.
- **US2 (P1)**: Phase 2 only for adaptive discovery; shares canonical Controls file with US1, so coordinate edits or serialize file-level work.
- **US3 (P1)**: Depends on US2's discovery input boundary; context fixtures remain independently testable.
- **US4 (P1)**: Depends on US2's proposal route; persistence fixtures remain independently testable.
- **US5 (P2)**: Depends on US1 action/readiness sequencing, US4 verified persistence, and NFR contract reconciliation.

### Parallel Opportunities

- T002-T004 can run in parallel because they only inspect or document separate evidence.
- T005-T008 can run in parallel because they amend separate test surfaces.
- T013-T015 can run in parallel before the Setup implementation tasks.
- T020-T022, T029-T031, T037-T040, and T046-T049 can each run in parallel within their story.
- T056-T058 can run in parallel after canonical source edits are complete.
- Different story teams can work in parallel after Phase 2, but Controls skill edits require coordination to avoid same-file conflicts.

## Parallel Execution Examples

### User Story 1

```text
Task T013: exact handoff fixtures in .highway/tools/tests/highway-setup.test.sh
Task T014: delegated-result fixtures in .highway/tools/tests/setup-owner-loop-contract.test.sh
Task T015: finish/failure fixtures in .highway/tools/tests/highway-setup-executable.test.sh
```

### User Story 2

```text
Task T020: adaptive branching fixtures in .highway/tools/tests/highway-controls-onboarding.test.sh
Task T021: language and progress fixtures in .highway/tools/tests/highway-ux-alignment.test.sh
Task T022: proposal framing fixtures in .highway/tools/tests/output-template.test.sh
```

### User Story 3

```text
Task T029: context priority fixtures in .highway/tools/tests/profile-participation.test.sh
Task T030: Profile blocked fixtures in .highway/tools/tests/profile-context-contract.test.sh
Task T031: connection/UX fixtures in .highway/tools/tests/highway-ux-alignment.test.sh
```

### User Story 4

```text
Task T037: persistence exit fixtures in .highway/tools/tests/highway-controls-onboarding.test.sh
Task T038: reuse/candidate fixtures in .highway/tools/tests/control-derived-nfr.test.sh
Task T039: overlap fixtures in .highway/tools/tests/relationship-integrity.test.sh
Task T040: version fixtures in .highway/tools/tests/readiness-executable.test.sh
```

### User Story 5

```text
Task T046: continuation fixtures in .highway/tools/tests/highway-controls-onboarding.test.sh
Task T047: candidate timing fixtures in .highway/tools/tests/control-derived-nfr.test.sh
Task T048: NFR readiness fixtures in .highway/tools/tests/highway-nfr-onboarding.test.sh
Task T049: Setup/NFR routing fixtures in .highway/tools/tests/highway-setup.test.sh
```

## Implementation Strategy

### MVP First: User Story 1

1. Complete Phase 1 baseline and coverage setup.
2. Complete Phase 2 owner-result and readiness contracts.
3. Implement and validate US1 Setup handoff and delegated-result sequencing.
4. Stop at the US1 checkpoint and validate the exact transition, opening, failure handling, and no-false-completion behavior.

### Incremental Delivery

1. Add US2 adaptive discovery and proposal framing.
2. Add US3 deterministic context guidance and boundaries.
3. Add US4 atomic persistence, reuse, overlap, and version behavior.
4. Add US5 continuation and interruption-safe NFR candidate lifecycle.
5. Complete polish, generated correspondence, compliance evidence, and full suite validation, allowing up to 240 seconds for completion.

## Notes

- Every implementation task has a checkbox, sequential ID, required story label in story phases, and an exact file path.
- `[P]` marks only tasks that can safely run in parallel on different files or independent fixtures.
- Tests must be observed failing before the implementation they cover is marked complete, consistent with D3.6.
- Static contract checks and executed behavior checks must be reported separately, consistent with D3.8.
