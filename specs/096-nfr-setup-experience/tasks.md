# Tasks: Highway NFR Setup Experience

**Input**: Design documents from `specs/096-nfr-setup-experience/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/nfr-setup-contract.md`, `quickstart.md`

**Tests**: Required by the specification and development constitution. Static contract evidence and executable behavior evidence remain distinct.

## Phase 1: Setup

**Purpose**: Confirm the existing canonical/generated layout and prepare focused evidence surfaces.

- [ ] T001 [P] Inventory Feature 096 design artifacts and existing NFR/Setup focused fixtures in `specs/096-nfr-setup-experience/` and `.highway/tools/tests/`
- [ ] T002 Record the current canonical NFR version, Setup version, adapter paths, and baseline focused test results in `specs/096-nfr-setup-experience/quickstart.md`

## Phase 2: Foundational

**Purpose**: Establish contract tests and ownership invariants before changing skill behavior.

- [ ] T003 Add failing static assertions for the separate NFR collection result, exact broad discovery prompt, recommendation wording, decision mapping, and unchanged four-field readiness in `.highway/tools/tests/highway-nfr-onboarding.test.sh`
- [ ] T004 [P] Add failing Setup assertions for NFR `Continue`, explicit `Finished`, fresh readiness, and owner-only result consumption in `.highway/tools/tests/highway-setup.test.sh`
- [ ] T005 [P] Add failing executable fixtures for zero-candidate finish, accepted-NFR continuation, malformed/blocked/declined/aborted results, and resume boundaries in `.highway/tools/tests/highway-setup-executable.test.sh`
- [ ] T006 [P] Add failing UX alignment assertions for one-question behavior, contextual recommendation language, exact open-discovery prompt, transient suggestions, and absence of internal candidate terminology in `.highway/tools/tests/highway-ux-alignment.test.sh`
- [ ] T007 Define Feature 096 contract evidence and traceability expectations in `specs/096-nfr-setup-experience/contracts/nfr-setup-contract.md`

**Checkpoint**: Focused tests fail for the missing collection contract and behavior while existing readiness and ownership checks remain meaningful.

## Phase 3: User Story 1 - Contextual Control-Derived Recommendations (Priority: P1) MVP

**Goal**: Present persisted Control-derived candidates as contextual, one-at-a-time Highway recommendations without changing durable candidate ownership, order, decisions, or resume behavior.

**Independent Test**: Run `.highway/tools/tests/highway-nfr-onboarding.test.sh` and the recommendation subset of `.highway/tools/tests/highway-ux-alignment.test.sh`; verify zero, one, and multiple candidates, stable resume, descriptor fallback, and omission of internal candidate machinery.

### Tests for User Story 1

- [ ] T008 [P] [US1] Extend populated and empty candidate fixtures with contextual recommendation expectations and stable pending-order markers in `.highway/tools/tests/fixtures/controls-nfr-onboarding/`
- [ ] T009 [P] [US1] Add static checks for descriptor selection, subject derivation, user-facing decision mapping, and preserved durable decision vocabulary in `.highway/tools/tests/highway-nfr-onboarding.test.sh`

### Implementation for User Story 1

- [ ] T010 [US1] Replace routine candidate review presentation with the contextual recommendation contract in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T011 [US1] Define transient subject and descriptor derivation with `requirements` fallback and prohibit new persisted Control presentation classifications in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T012 [US1] Map `accept`, `change`, `replace`, and `skip` to existing durable decisions while preserving cancel, pause, interruption, and Review Complete behavior in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T013 [US1] Remove internal candidate identifiers, titles, generation language, and state terminology from routine recommendation output while retaining explicit error/recovery provenance in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T014 [US1] Add focused assertions proving durable candidate order, first-pending resume, no regeneration, and no open discovery before review completion in `.highway/tools/tests/highway-nfr-onboarding.test.sh`
- [ ] T015 [US1] Run `bash .highway/tools/tests/highway-nfr-onboarding.test.sh` and `bash .highway/tools/tests/highway-ux-alignment.test.sh` and repair only recommendation-slice failures

**Checkpoint**: Derived recommendations are user-facing and contextual; persisted candidate state and review write boundaries remain unchanged.

## Phase 4: User Story 2 - Open Conversational NFR Discovery (Priority: P1)

**Goal**: Continue from derived review, or begin with zero candidates, into natural conversation that evaluates user evidence, handles uncertainty and suggestions, persists accepted NFRs through Add, and requires explicit finish.

**Independent Test**: Exercise direct statements, partial and multi-dimension evidence, corrections, `I don't know`, suggestion requests, accepted-NFR continuation, direct `setup`/`configure`, and immediate finish with zero accepted NFRs using the NFR and UX focused fixtures.

### Tests for User Story 2

- [ ] T016 [P] [US2] Add fixtures for exact broad discovery opening, direct usable Add evidence, partial evidence, multiple dimensions, correction, and one unresolved question in `.highway/tools/tests/fixtures/controls-nfr-onboarding/`
- [ ] T017 [P] [US2] Add fixtures proving `I don't know` produces guided discovery, not finish or invented content, in `.highway/tools/tests/fixtures/controls-nfr-onboarding/`
- [ ] T018 [P] [US2] Add fixtures proving one-to-three declared-context suggestions remain transient until adoption or restatement in `.highway/tools/tests/fixtures/controls-nfr-onboarding/`
- [ ] T019 [P] [US2] Add executable checks for accepted-NFR continuation, explicit finish, zero-candidate finish, direct invocation, and `controls: []` persistence in `.highway/tools/tests/highway-nfr-executable.test.sh`
- [ ] T020 [P] [US2] Add exact prompt, single-question, suggestion, uncertainty, and continuation assertions in `.highway/tools/tests/highway-ux-alignment.test.sh`

### Implementation for User Story 2

- [ ] T021 [US2] Add `setup` and `configure` action routing and active collection state semantics to `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T022 [US2] Add the exact broad discovery prompt and direct-invocation behavior, including evaluation of usable Add evidence before generic opening, to `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T023 [US2] Define evidence evaluation for ordinary, formal, partial, multi-dimension, corrected, and replacement input with at most one unresolved question or decision in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T024 [US2] Define guided `I don't know` handling and context-bounded transient suggestions without invented organizational facts in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T025 [US2] Define user-authored proposal confirmation, title refinement, existing Add persistence, duplicate/failure preservation, and `controls: []` behavior in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T026 [US2] Define continuation after every verified user-authored creation and explicit finish semantics, including zero accepted NFRs, in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T027 [US2] Add the separate active collection result with exact field order, allowed values, blocking-reason rules, and no created-ID list to `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T028 [US2] Add direct-invocation and transient-state resume rules while preserving durable candidate recovery in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T029 [US2] Run the NFR management, onboarding, executable, and UX focused tests and repair only open-discovery-slice failures in `.highway/tools/tests/`

**Checkpoint**: NFRs supports open discovery and explicit collection completion without conflating transient collection with persisted readiness.

## Phase 5: User Story 3 - Durable NFR Ownership and Setup Handoff (Priority: P1)

**Goal**: Make Setup consume NFR collection results authoritatively, request fresh readiness after explicit finish, and never inspect NFR internals or claim completion on non-successful owner results.

**Independent Test**: Run Setup static and executable routing scenarios for `Continue`, `Finished`, fresh `Complete`/`Not Applicable`/`In Progress`/`Blocked`, malformed, declined, and aborted NFR results; verify direct NFR invocation has no Setup transition language.

### Tests for User Story 3

- [ ] T030 [P] [US3] Add Setup owner-loop fixtures for NFR action-result-before-fresh-readiness and no-internal-inspection assertions in `.highway/tools/tests/fixtures/profile-092/`
- [ ] T031 [P] [US3] Add executable Setup scenarios for NFR `Continue`, explicit `Finished`, fresh readiness, zero accepted NFR finish, blocked/declined/aborted/malformed outcomes, and non-advancement in `.highway/tools/tests/highway-setup-executable.test.sh`
- [ ] T032 [P] [US3] Add direct invocation assertions and Setup transition ownership assertions in `.highway/tools/tests/highway-setup.test.sh`
- [ ] T033 [P] [US3] Add readiness-separation assertions ensuring NFR readiness remains exactly four fields and never exposes `Missing` in `.highway/tools/tests/readiness-contract.test.sh`

### Implementation for User Story 3

- [ ] T034 [US3] Update the NFR input/output and workflow sections to make the collection result owner-authoritative and distinct from readiness in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T035 [US3] Update Setup inputs to consume the NFR collection result without candidate, record, relationship, count, or readiness-predicate inspection in `.highway/skills/highway-setup/SKILL.md`
- [ ] T036 [US3] Add Setup workflow sequencing for NFR `Continue`, explicit `Finished`, fresh NFR readiness, and non-successful owner results while preserving Feature 095 transition and conclusion wording in `.highway/skills/highway-setup/SKILL.md`
- [ ] T037 [US3] Add Setup error handling for malformed, declined, aborted, blocked, failed, and non-terminal NFR owner results in `.highway/skills/highway-setup/SKILL.md`
- [ ] T038 [US3] Review and apply the Skill Versioning Policy to the material NFR contract change, updating canonical metadata in `.highway/skills/highway-nfrs/SKILL.md`
- [ ] T039 [US3] Run NFR management, readiness, Setup contract, Setup executable, and UX focused tests and repair only handoff-slice failures in `.highway/tools/tests/`

**Checkpoint**: Setup advances only from an explicit successful NFR finish followed by fresh owner readiness; all other outcomes remain with or stop at NFRs.

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Synchronize generated artifacts, complete governance review, and prove the full repository remains valid.

- [ ] T040 [P] Regenerate GitHub, Claude, Cursor, catalog, and library derived outputs from canonical skills with `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-library-catalog.sh`
- [ ] T041 [P] Validate canonical NFR and Setup skills with `.highway/tools/validate-skill.sh` and validate shared library output with `.highway/tools/validate-library.sh`
- [ ] T042 Run `.highway/tools/tests/adapter-coverage.test.sh` and verify generated correspondence without hand-editing adapter outputs
- [ ] T043 Run the Feature 096 quickstart commands from `specs/096-nfr-setup-experience/quickstart.md` and record static versus executable evidence in `specs/096-nfr-setup-experience/quickstart.md`
- [ ] T044 Review changed NFR and Setup content against `.highway/governance/constitution.md` and `.highway/governance/experience-standard.md`, documenting any required wording correction in `specs/096-nfr-setup-experience/plan.md`
- [ ] T045 Run `./.highway/tools/tests/run-all.sh`, then run `git diff --check` and inspect `git status --short` for unrelated or protected-file changes in the repository root

## Dependencies & Execution Order

### Phase Dependencies

- Phase 1 has no dependencies.
- Phase 2 depends on Phase 1 and blocks story implementation because it defines failing evidence.
- User Story 1 depends on Phase 2 and is the MVP increment.
- User Story 2 depends on the durable recommendation/review boundary from User Story 1.
- User Story 3 depends on the collection result defined in User Story 2 and updates the Setup consumer.
- Phase 6 depends on all three stories.

### User Story Dependencies

- **US1**: After Phase 2; establishes contextual presentation while preserving candidate state.
- **US2**: After US1; uses the successful review boundary to begin open discovery and retains direct authoring independence.
- **US3**: After US2; consumes the new collection result and fresh readiness boundary.

### Parallel Opportunities

- T003-T006 can run in parallel because they edit separate focused test surfaces.
- T008-T009 can run in parallel with each other before US1 implementation.
- T016-T020 can run in parallel because they add separate fixtures and test assertions.
- T030-T033 can run in parallel because they add separate Setup/readiness evidence surfaces.
- T040-T042 can run in parallel after canonical edits settle, subject to generator ordering where required by the scripts.

## Parallel Example: User Story 1

```text
T008: Extend candidate fixtures
T009: Add contextual recommendation contract assertions
```

## Parallel Example: User Story 2

```text
T016: Add discovery evidence fixtures
T017: Add uncertainty fixtures
T018: Add suggestion fixtures
T019: Add executable collection assertions
T020: Add UX assertions
```

## Parallel Example: User Story 3

```text
T030: Add owner-loop fixtures
T031: Add executable Setup scenarios
T032: Add Setup contract assertions
T033: Add readiness separation assertions
```

## Implementation Strategy

### MVP First

1. Complete setup and foundational evidence.
2. Implement User Story 1 and run its focused tests.
3. Validate the contextual recommendation MVP before proceeding to open discovery.

### Incremental Delivery

1. Add User Story 2 for direct and post-review conversational discovery.
2. Add User Story 3 for Setup handoff and fresh readiness.
3. Regenerate adapters and run governance, correspondence, focused, and full validation.

### Completion Criteria

The feature is complete only when every task is checked, the canonical skills and generated adapters
correspond, the four-field readiness contract is unchanged, explicit finish is followed by fresh
readiness, and the complete repository suite passes.
