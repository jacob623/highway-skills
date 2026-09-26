---

description: "Implementation tasks for Conversational Objective Discovery"
---

# Tasks: Conversational Objective Discovery

**Input**: Design documents from `specs/093-conversational-objective-discovery/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/), and [quickstart.md](quickstart.md)

**Tests**: Required by FR-022 and the implementation requirements. Tests cover static contracts, executable interaction fixtures, persistence boundaries, generated correspondence, and the full suite.

**Implementation surface**: Existing Markdown skills, Bash 3.2-compatible tests, shared templates, generators, and user-owned Objective outputs. No application runtime or new dependency is introduced.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the implementation baseline and reusable fixtures without changing shipped behavior.

- [X] T001 Record the Feature 093 implementation scope, source paths, generated-output policy, and validation commands in `specs/093-conversational-objective-discovery/plan.md`
- [X] T002 [P] Add disposable repository and Objective baseline fixture helpers for adaptive discovery tests in `.highway/tools/tests/`
- [X] T003 [P] Add Bash 3.2-compatible assertions for byte-preservation, retained-output verification, and marker absence in `.highway/tools/tests/`
- [X] T004 [P] Update the Feature 093 validation command list and expected outcomes in `specs/093-conversational-objective-discovery/quickstart.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define the shared behavioral vocabulary, ownership boundaries, and durable-output invariants required by every story.

- [X] T005 [P] Add the transient conversation, proposal, context, readiness, and state-transition obligations to the behavioral contract section of `.highway/skills/highway-objectives/SKILL.md`
- [X] T006 [P] Add the Setup ownership, delegation, forwarding, and fresh-readiness obligations to `.highway/skills/highway-setup/SKILL.md`
- [X] T007 Preserve the complete retained Objective record schema and citations to `.highway/library/templates/output/objective-record.md` in `.highway/skills/highway-objectives/SKILL.md`
- [X] T008 Preserve the complete retained Objective catalog schema and citations to `.highway/library/templates/output/objective-catalog.md` in `.highway/skills/highway-objectives/SKILL.md`
- [X] T009 [P] Add shared baseline, catalog, identifier, version, relationship, and no-transient-state fixtures to `.highway/tools/tests/objective-management.test.sh`
- [X] T010 [P] Add shared Setup/Profile/Objective readiness fixtures to `.highway/tools/tests/highway-setup.test.sh`
- [X] T011 Run `bash .highway/tools/validate-skill.sh .highway/skills/highway-objectives`, `bash .highway/tools/validate-skill.sh .highway/skills/highway-setup`, and both Objective template validators against `.highway/library/templates/output/` before story implementation

**Checkpoint**: Shared ownership, schema, readiness, transaction, fixture, and validator foundations are ready for independent story work.

---

## Phase 3: User Story 1 - Guided Setup Handoff (Priority: P1) MVP

**Goal**: Setup introduces the purpose only for a non-terminal Objective baseline, delegates to Objectives, and forwards the exact owner-owned opening and subsequent results without interpreting Objective content.

**Independent Test**: Run Setup with terminal-success Profile plus Missing Objective readiness and verify the exact Setup introduction, exact Objectives opening, ordering, single emission, and absence of Setup-owned Objective questions or writes. Run again with Complete Objective readiness and verify no Objective introduction or discovery question before Controls routing.

### Tests for User Story 1

- [X] T012 [P] [US1] Add static assertions for the exact Setup introduction, Objectives opening, ownership wording, and absence of legacy Setup Objective prompts in `.highway/tools/tests/highway-setup.test.sh`
- [X] T013 [P] [US1] Add executable handoff tests for Missing and Complete Objective readiness branches, forwarding, owner failure, and no Setup artifact writes in `.highway/tools/tests/highway-setup-executable.test.sh`
- [X] T014 [P] [US1] Add direct contract assertions for the Setup-to-Objectives handoff in `.highway/tools/tests/highway-setup.test.sh`

### Implementation for User Story 1

- [X] T015 [US1] Implement the non-terminal Objective readiness branch and exact purpose introduction in `.highway/skills/highway-setup/SKILL.md`
- [X] T016 [US1] Implement exact owner-content delegation and unchanged forwarding for Objective questions, decisions, failures, and completion results in `.highway/skills/highway-setup/SKILL.md`
- [X] T017 [US1] Implement the Complete Objective readiness branch that skips the introduction and proceeds to Controls in `.highway/skills/highway-setup/SKILL.md`
- [X] T018 [US1] Verify Setup re-reads fresh Objective readiness after verified owner completion and never restores a transient Objective question in `.highway/skills/highway-setup/SKILL.md`

**Checkpoint**: Setup-mediated onboarding is independently testable and preserves Objectives ownership.

---

## Phase 4: User Story 2 - Adaptive Outcome Discovery (Priority: P1)

**Goal**: Objectives replaces the rigid three-prompt form with adaptive, transient discovery across Outcome, Success, and Significance, including uncertainty guidance and Profile-grounded suggestions.

**Independent Test**: Invoke Objectives directly with concise, rich, uncertain, activity-based, cross-dimension, and explicit suggestion responses. Verify that only unresolved evidence produces a question, no fixed progress language remains, suggestions are grounded and transient, and a complete proposal is produced when all required evidence is supported.

### Tests for User Story 2

- [X] T019 [P] [US2] Add static contract tests for adaptive ordering, one unresolved decision, no fixed three-step language, and no persisted discovery fields in `.highway/tools/tests/objective-management.test.sh`
- [X] T020 [P] [US2] Add executable tests for concise, rich, uncertain, activity-to-outcome, and cross-dimension responses in `.highway/tools/tests/objective-management.test.sh`
- [X] T021 [P] [US2] Add executable tests distinguishing explicit Profile-grounded suggestions from uncertainty-driven generic discovery in `.highway/tools/tests/objective-management.test.sh`
- [X] T022 [P] [US2] Add suggestion-adoption tests proving explanatory follow-up does not adopt a suggestion and explicit selection establishes only supported Outcome evidence in `.highway/tools/tests/objective-management.test.sh`

### Implementation for User Story 2

- [X] T023 [US2] Replace the fixed three-prompt creation workflow and legacy progress language with adaptive Outcome, Success, and Significance evaluation in `.highway/skills/highway-objectives/SKILL.md`
- [X] T024 [US2] Implement full-response evidence evaluation and next-action ordering with one unresolved question or decision in `.highway/skills/highway-objectives/SKILL.md`
- [X] T025 [US2] Implement uncertainty-guided discovery, activity-to-outcome exploration, natural business language, and contextual acknowledgments in `.highway/skills/highway-objectives/SKILL.md`
- [X] T026 [US2] Implement Profile-wide relevant-evidence filtering and one-to-three transient suggestions with explicit adoption rules in `.highway/skills/highway-objectives/SKILL.md`
- [X] T027 [US2] Implement complete proposal synthesis with distinct Title, Statement, Success Measures, and Rationale presentation labels in `.highway/skills/highway-objectives/SKILL.md`
- [X] T028 [US2] Remove every retained `Accept, modify, or replace?`, identifier-before-confirmation, and fixed-form guarantee from the Objective UX contract, workflow, Verification, and Example in `.highway/skills/highway-objectives/SKILL.md`

**Checkpoint**: Direct adaptive discovery is independently testable before correction, persistence, and collection-loop work is added.

---

## Phase 5: User Story 3 - Natural Correction and Confirmation (Priority: P1)

**Goal**: Users can accept, correct, replace, reject, cancel, or abandon a complete proposal naturally, with staged evidence re-evaluated before any durable mutation.

**Independent Test**: Produce a complete proposal, exercise natural acceptance, partial correction, substantial replacement, rejection, cancellation, and abandonment, then verify revised proposals, invalidated downstream evidence, no pre-confirmation writes, and all-or-nothing verified creation.

### Tests for User Story 3

- [X] T029 [P] [US3] Add static tests for natural validation, correction, replacement, rejection, cancellation, abandonment, and no second persistence-confirmation question in `.highway/tools/tests/objective-management.test.sh`
- [X] T030 [P] [US3] Add executable correction tests for title, Statement, Success Measure, Rationale, substantial Outcome replacement, and downstream evidence invalidation in `.highway/tools/tests/objective-management.test.sh`
- [X] T031 [P] [US3] Add executable non-write tests proving declined, cancelled, abandoned, and interrupted proposals preserve record, catalog, `next_id`, and version bytes in `.highway/tools/tests/objective-management.test.sh`
- [X] T032 [P] [US3] Add persistence-failure tests that identify the unverified record or catalog and never claim successful creation in `.highway/tools/tests/objective-management.test.sh`

### Implementation for User Story 3

- [X] T033 [US3] Implement natural proposal validation and correction parsing without requiring workflow-command vocabulary in `.highway/skills/highway-objectives/SKILL.md`
- [X] T034 [US3] Implement correction-driven re-evaluation that discards unsupported staged Outcome, Success, and Significance interpretations in `.highway/skills/highway-objectives/SKILL.md`
- [X] T035 [US3] Implement final authoritative baseline and overlap revalidation after confirmation and before identifier allocation in `.highway/skills/highway-objectives/SKILL.md`
- [X] T036 [US3] Implement permanent identifier allocation only after confirmation, with exactly-once Add/New MINOR version semantics and preserved `capabilities: []` in `.highway/skills/highway-objectives/SKILL.md`
- [X] T037 [US3] Implement all-or-nothing Objective record and catalog mutation, retained-output verification, failure reporting, and completion claims in `.highway/skills/highway-objectives/SKILL.md`
- [X] T038 [US3] Set the amended Objective skill version to `2.0.0` and retain `Resume Applicability: New interaction` in `.highway/skills/highway-objectives/SKILL.md`

**Checkpoint**: A confirmed proposal persists safely, while every non-write path preserves the verified baseline.

---

## Phase 6: User Story 4 - Context-Aware Objective Conversation (Priority: P2)

**Goal**: Objectives consumes only relevant declared context, handles absent or malformed context locally, respects context roles and ordering, and uses existing Objectives only for overlap and related guidance.

**Independent Test**: Run each declared context document as present, absent, malformed, and contradictory where applicable. Verify Profile-only organizational evidence, non-organizational roles for Identity/Vision/Platform Objectives, no fabricated claims, and advisory duplicate or overlap handling.

### Tests for User Story 4

- [X] T039 [P] [US4] Add static Repository Context declarations, role-boundary, and conflict-ordering assertions for Identity, Vision, Platform Objectives, and Profile in `.highway/tools/tests/objective-management.test.sh`
- [X] T040 [P] [US4] Add malformed and unavailable context fixtures for each declared context document in `.highway/tools/tests/objective-management.test.sh`
- [X] T041 [P] [US4] Add executable relevant-versus-unrelated Profile suggestion tests and unsupported-fact assertions in `.highway/tools/tests/objective-management.test.sh`
- [X] T042 [P] [US4] Add contradictory-context tests proving active user intent remains authoritative in `.highway/tools/tests/objective-management.test.sh`
- [X] T043 [P] [US4] Add exact-duplicate and semantic-overlap tests naming the existing Objective and requiring one user decision without silent merge or rewrite in `.highway/tools/tests/objective-management.test.sh`

### Implementation for User Story 4

- [X] T044 [US4] Declare Objectives as a Repository Context Participating Skill and define the four context document roles in `.highway/skills/highway-objectives/SKILL.md`
- [X] T045 [US4] Implement relevant-only context consumption, unavailable/malformed context recording, exclusion, and owner-level Blocked distinction in `.highway/skills/highway-objectives/SKILL.md`
- [X] T046 [US4] Implement Profile-only organizational evidence boundaries for suggestions, Significance interpretation, and Rationale synthesis in `.highway/skills/highway-objectives/SKILL.md`
- [X] T047 [US4] Implement existing Objective baseline inspection, exact duplicate identification, semantic overlap advisory handling, and final overlap recheck in `.highway/skills/highway-objectives/SKILL.md`

**Checkpoint**: Context-aware discovery is independently testable without allowing non-Profile context to invent organizational Objective evidence.

---

## Phase 7: User Story 4a - Direct Objective Invocation (Priority: P2)

**Goal**: Direct `/highway-objectives setup` and `/highway-objectives add` invocations provide concise context and process supplied evidence before selecting the next action.

**Independent Test**: Invoke `/highway-objectives setup`, bare `/highway-objectives add`, and `/highway-objectives add <evidence>` with concise and rich evidence. Verify direct context does not duplicate Setup language, the exact opening appears only when needed, and rich evidence goes directly to proposal review.

### Tests for User Story 4a

- [X] T048 [P] [US4a] Add direct-entry static assertions for `/highway-objectives setup`, bare `add`, supplied evidence handling, and absence of Setup transition text in `.highway/tools/tests/objective-management.test.sh`
- [X] T049 [P] [US4a] Add executable direct-invocation tests for concise, Outcome-supported, and rich Outcome/Success/Significance `add` inputs in `.highway/tools/tests/objective-management.test.sh`

### Implementation for User Story 4a

- [X] T050 [US4a] Implement concise direct-invocation context and the complete Objectives-owned opening for `/highway-objectives setup` and bare `/highway-objectives add` in `.highway/skills/highway-objectives/SKILL.md`
- [X] T051 [US4a] Implement pre-question processing of supplied `/highway-objectives add` evidence and direct rich-evidence proposal synthesis in `.highway/skills/highway-objectives/SKILL.md`

**Checkpoint**: Objectives remains independently usable without Setup and never claims Setup introduced its direct-entry context.

---

## Phase 8: User Story 5 - Multiple Objectives and Durable Baseline (Priority: P2)

**Goal**: Verified Objectives can be collected repeatedly in one interaction, while readiness, identifiers, catalog order, relationships, and resume behavior remain durable and authoritative.

**Independent Test**: Confirm one Objective, provide a second outcome through the collection loop, confirm it, finish, and inspect records, deterministic catalog ordering, `next_id`, versions, relationships, readiness, and fresh Setup behavior after interruption.

### Tests for User Story 5

- [X] T052 [P] [US5] Add collection-loop static assertions for the exact follow-up question, direct second-outcome handling, affirmative-without-outcome handling, uncertainty, suggestions, and finish behavior in `.highway/tools/tests/objective-management.test.sh`
- [X] T053 [P] [US5] Add executable multi-Objective tests for user-provided order, unique IDs, deterministic catalog order, `next_id`, version increments, and Capability relationship shape in `.highway/tools/tests/objective-management.test.sh`
- [X] T054 [P] [US5] Add interruption/resume tests proving a partial second Objective and collection-loop question are not restored and the first verified Objective remains intact in `.highway/tools/tests/highway-setup-executable.test.sh`
- [X] T055 [P] [US5] Add readiness tests for Missing, Complete, and Blocked baselines with exact four-field ordering and read-only behavior in `.highway/tools/tests/objective-management.test.sh`

### Implementation for User Story 5

- [X] T056 [US5] Implement the verified-creation collection loop and exact `Anything else you'd like to accomplish?` decision handling in `.highway/skills/highway-objectives/SKILL.md`
- [X] T057 [US5] Implement direct second-outcome continuation, affirmative-without-outcome prompting, suggestion reuse, uncertainty assistance, and explicit finish completion in `.highway/skills/highway-objectives/SKILL.md`
- [X] T058 [US5] Preserve read-only readiness as Missing, Complete, or Blocked with exact output order and active-collection separation in `.highway/skills/highway-objectives/SKILL.md`
- [X] T059 [US5] Verify repeated Add/New mutations preserve permanent identifiers, deterministic catalog ordering, authoritative `next_id`, semantic version increments, and `capabilities: []` compatibility in `.highway/skills/highway-objectives/SKILL.md`
- [X] T060 [US5] Verify Setup uses persisted readiness after interrupted collection and advances only from a fresh terminal Objective result in `.highway/skills/highway-setup/SKILL.md`

**Checkpoint**: Multiple Objective collection and durable baseline behavior are independently testable end to end.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate shipped correspondence, run the complete validation path, and remove stale legacy guarantees.

- [X] T061 [P] Regenerate skill catalogs from `.highway/tools/generate-catalog.sh` and verify generated catalog correspondence
- [X] T062 [P] Regenerate library catalogs from `.highway/tools/generate-library-catalog.sh` and verify Objective catalog correspondence
- [X] T063 [P] Regenerate agent adapters and distribution metadata from `.highway/tools/generate-agent-adapters.sh`
- [X] T064 Remove any stale fixed-form, identifier-before-confirmation, or legacy validation wording from generated Objective/Setup outputs using `.highway/skills/highway-objectives/SKILL.md` and `.highway/skills/highway-setup/SKILL.md`, not generated-file edits
- [X] T065 Run shared template checks in `.highway/tools/tests/output-template.test.sh`, adapter coverage checks in `.highway/tools/tests/adapter-coverage.test.sh`, and distribution checks in `.highway/tools/tests/distribution-packaging.test.sh`
- [X] T066 Run all focused Feature 093 tests and `.highway/tools/tests/run-all.sh`, then record the results in `specs/093-conversational-objective-discovery/quickstart.md`
- [X] T067 Run the skill and library validators against `.highway/skills/`, `.highway/library/templates/output/objective-record.md`, and `.highway/library/templates/output/objective-catalog.md`; resolve all applicable failures without changing user-owned `library/` artifacts

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; establish disposable fixtures and validation scope.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user stories because it defines shared ownership, schema, and fixture contracts.
- **User Story 1 (Phase 3)**: Depends on Foundational; MVP handoff can be implemented and tested independently.
- **User Story 2 (Phase 4)**: Depends on Foundational; can proceed in parallel with US1 after shared fixtures are available.
- **User Story 3 (Phase 5)**: Depends on US2 adaptive proposal synthesis; adds correction and mutation behavior.
- **User Story 4 (Phase 6)**: Depends on US2 context-consuming conversation; overlap checks feed US3 final revalidation.
- **User Story 4a (Phase 7)**: Depends on US2 entry and proposal behavior; can proceed in parallel with US4.
- **User Story 5 (Phase 8)**: Depends on US3 persistence and US1 fresh-readiness handoff; adds collection and durable baseline behavior.
- **Polish (Phase 9)**: Depends on all selected stories and runs generators plus full validation.

### User Story Dependencies

- **US1 (P1)**: Foundational only; MVP story.
- **US2 (P1)**: Foundational only; independent adaptive-discovery increment.
- **US3 (P1)**: Depends on US2 proposal state and evidence evaluation.
- **US4 (P2)**: Depends on US2 context-aware proposal flow; supports US3 overlap revalidation.
- **US4a (P2)**: Depends on US2; independent of US4 after shared Objective behavior exists.
- **US5 (P2)**: Depends on US1 readiness handoff and US3 verified persistence.

### Parallel Opportunities

- Setup fixture work T002-T004 can run in parallel.
- Foundational skill, fixture, and template-citation tasks T005-T010 can run in parallel when they touch distinct files.
- After Phase 2, US1 and US2 can proceed in parallel; their test tasks are parallel within each story.
- US4 and US4a can proceed in parallel after US2; US3 can proceed after US2 while context tests continue separately.
- Generator tasks T061-T063 can run in parallel only after all source skill and test changes are complete.

### Parallel Example: User Story 1

```text
Task: T012 static Setup handoff assertions in .highway/tools/tests/highway-setup.test.sh
Task: T013 executable Setup handoff fixtures in .highway/tools/tests/highway-setup-executable.test.sh
Task: T015 non-terminal Setup branch in .highway/skills/highway-setup/SKILL.md
```

### Parallel Example: User Story 2

```text
Task: T019 adaptive contract assertions in .highway/tools/tests/objective-management.test.sh
Task: T021 suggestion-versus-uncertainty fixtures in .highway/tools/tests/objective-management.test.sh
Task: T023 adaptive workflow contract in .highway/skills/highway-objectives/SKILL.md
Task: T026 Profile-grounded suggestion rules in .highway/skills/highway-objectives/SKILL.md
```

### Parallel Example: User Story 4

```text
Task: T040 malformed context fixtures in .highway/tools/tests/objective-management.test.sh
Task: T041 relevant Profile suggestion tests in .highway/tools/tests/objective-management.test.sh
Task: T044 Repository Context declarations in .highway/skills/highway-objectives/SKILL.md
```

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1 Setup and Phase 2 Foundational tasks.
2. Complete Phase 3 User Story 1.
3. Run the Setup static and executable handoff tests plus validators.
4. Stop and validate that Setup introduces purpose once, delegates ownership, and forwards exact Objectives content.

### Incremental Delivery

1. Add US2 adaptive discovery and validate concise, rich, uncertain, and suggestion paths.
2. Add US3 natural correction and verified transactional creation.
3. Add US4 context boundaries and overlap handling.
4. Add US4a direct invocation behavior.
5. Add US5 multiple Objective collection, readiness, and resume behavior.
6. Regenerate correspondence and run the complete suite after all selected stories.

### Parallel Team Strategy

1. Complete Setup and Foundational phases together.
2. Assign US1 and US2 to separate contributors after the foundation checkpoint.
3. Assign US3 persistence, US4 context, and US4a direct invocation according to their dependencies.
4. Complete US5 after verified persistence and handoff behavior stabilize.
5. Run generation and full validation as a coordinated final phase.

## Notes

- Every task uses the required `- [ ] T###` checklist format.
- Story tasks use the required `[US1]` through `[US5]` labels; Setup, Foundational, and Polish tasks intentionally have no story label.
- Tests are included because Feature 093 explicitly requires focused coverage and executable verification.
- Generated outputs must be regenerated from source; do not hand-edit generated artifacts.

## Format Validation

- All implementation tasks use the required `- [ ] T###` checklist syntax and sequential IDs `T001` through `T067`.
- User Story tasks use `[US1]`, `[US2]`, `[US3]`, `[US4]`, `[US4a]`, or `[US5]`; setup, foundational, and polish tasks intentionally omit story labels as required by the task format.
- Every task description names a concrete repository file or command path.
- No sample task placeholders, `TXXX` identifiers, or unresolved feature-template labels remain.
