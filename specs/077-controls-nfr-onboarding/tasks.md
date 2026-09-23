# Tasks: Controls and NFRs Onboarding Enhancement

**Input**: Design documents from `/specs/077-controls-nfr-onboarding/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by SC-013 and constitution rules D3.2-D3.3. Add focused fixture/contract coverage before changing the owning skill contracts.

## Phase 1: Setup

**Purpose**: Establish the feature test and fixture surfaces without changing shipped behavior.

- [X] T001 Confirm Feature 077 prerequisites, design artifacts, and 22/22 requirements checklist status in specs/077-controls-nfr-onboarding/
- [X] T002 [P] Add Feature 077 fixture directories and README scenario index under .highway/tools/tests/fixtures/controls-nfr-onboarding/
- [X] T003 [P] Add the focused test entrypoint skeleton in .highway/tools/tests/highway-controls-onboarding.test.sh
- [X] T004 [P] Add the focused test entrypoint skeleton in .highway/tools/tests/highway-nfr-onboarding.test.sh

## Phase 2: Foundational

**Purpose**: Define shared assertions, transaction snapshots, and contract coverage required by all stories.

- [X] T005 Add reusable temporary-root, byte-snapshot, failure-injection, and deterministic-output assertions to .highway/tools/tests/fixtures/controls-nfr-onboarding/README.md and the focused test scripts
- [X] T006 [P] Add command-contract assertions for controls-command.md, nfr-command.md, and setup-readiness.md to .highway/tools/tests/governance-routing.test.sh
- [X] T007 [P] Add shared readiness-state assertions for Control and NFR owner outputs to .highway/tools/tests/readiness-owner-states.test.sh
- [X] T008 [P] Add fixture cases for empty, valid-existing, malformed, duplicate, undecided, and injected-failure governance states under .highway/tools/tests/fixtures/controls-nfr-onboarding/
- [X] T009 Run the focused pre-change probes in .highway/tools/tests/ and record the expected failing assertions for the new Feature 077 behavior before implementation edits

**Checkpoint**: Foundational test and fixture contract is ready; story implementation can proceed.

## Phase 3: User Story 1 - Guided Control Baseline Setup (Priority: P1) 🎯 MVP

**Goal**: Collect Controls in fixed categories with advisory generated titles, no-write cancellation, and existing-baseline routing.

**Independent Test**: Run the US1 fixture set with missing, valid, and existing Control baselines; verify category order, `none`, repeated entries, generated title proposal state, cancellation byte preservation, and no collection prompts for an existing baseline.

### Tests for User Story 1

- [X] T010 [P] [US1] Add tests for fixed category order, one-at-a-time collection, case-insensitive first-response `none`, and add-another prompts in .highway/tools/tests/highway-controls-onboarding.test.sh
- [X] T011 [P] [US1] Add tests for deterministic advisory Proposed Title generation, editability, authoritative statements, and non-persistence before review in .highway/tools/tests/highway-controls-onboarding.test.sh
- [X] T012 [P] [US1] Add tests for collection cancellation, proposal discard, no identifier allocation, and byte preservation in .highway/tools/tests/highway-controls-onboarding.test.sh
- [X] T013 [P] [US1] Add tests for valid existing-baseline detection, no collection prompts, no proposal state, and routing to existing Control actions in .highway/tools/tests/highway-controls-onboarding.test.sh

### Implementation for User Story 1

- [X] T014 [US1] Update guided Control setup, category ordering, collection cancellation, and existing-baseline routing in .highway/skills/highway-controls/SKILL.md
- [X] T015 [US1] Document deterministic advisory Proposed Title generation and review-approved title persistence boundaries in .highway/skills/highway-controls/SKILL.md
- [X] T016 [US1] Update the canonical Control onboarding command contract in specs/077-controls-nfr-onboarding/contracts/controls-command.md to match the implemented collection state machine
- [X] T017 [US1] Run .highway/tools/tests/highway-controls-onboarding.test.sh and confirm all collection and routing assertions pass

**Checkpoint**: Guided Control setup is independently testable and preserves all pre-review bytes.

## Phase 4: User Story 2 - Control Review and Candidate Generation (Priority: P1)

**Goal**: Require complete Control decisions, support advisory duplicate detection and cancellation, commit accepted Controls atomically, and generate ordered candidates only after successful persistence.

**Independent Test**: Submit multiple proposals, exercise Accept/Modify/Replace/Remove, leave one undecided, cancel, complete a valid review, verify duplicate diagnostics, atomic failure behavior, persisted-ID ordering, and zero-candidate validity.

### Tests for User Story 2

- [X] T018 [P] [US2] Add tests for Accept/Modify/Replace/Remove decisions, exactly-one-decision completion gates, and undecided Review Complete failure in .highway/tools/tests/highway-controls-onboarding.test.sh
- [X] T019 [P] [US2] Add tests for Control Cancel Review without decision completeness and full proposal/Control/catalog/relationship/candidate byte preservation in .highway/tools/tests/highway-controls-onboarding.test.sh
- [X] T020 [P] [US2] Add tests for duplicate proposed Control advisory diagnostics, independent reviewability, and non-blocking completion in .highway/tools/tests/highway-controls-onboarding.test.sh
- [X] T021 [P] [US2] Add tests for all-or-nothing Control persistence, identifier allocation timing, validation failure, catalog failure, and injected write failure in .highway/tools/tests/highway-controls-onboarding.test.sh
- [X] T022 [P] [US2] Add tests for post-transaction candidate generation, final approved Control inputs, persisted Control-ID ordering, availability/security/performance ordering, and zero-match behavior in .highway/tools/control-derived-nfr.test.sh

### Implementation for User Story 2

- [X] T023 [US2] Update Control Review Complete/Cancel Review semantics, final-decision validation, and atomic write boundary in .highway/skills/highway-controls/SKILL.md
- [X] T024 [US2] Update Control-derived candidate timing, final approved input set, persisted-ID ordering, and no-generation-during-review rules in .highway/skills/highway-controls/SKILL.md
- [X] T025 [US2] Update duplicate proposal diagnostics and failure-path behavior in .highway/skills/highway-controls/SKILL.md
- [X] T026 [US2] Update the Control command contract and data model references for review completion and candidate generation in specs/077-controls-nfr-onboarding/contracts/controls-command.md and specs/077-controls-nfr-onboarding/data-model.md
- [X] T027 [US2] Run .highway/tools/tests/highway-controls-onboarding.test.sh and .highway/tools/tests/control-derived-nfr.test.sh, then repair only failures in the touched contract/test slice

**Checkpoint**: Accepted Controls and derived candidates are produced only by a complete, successful review transaction.

## Phase 5: User Story 3 - NFR Candidate Review and Readiness (Priority: P1)

**Goal**: Review derived candidates with complete-decision gates, duplicate-safe atomic NFR writes, cancellation, direct-NFR independence, and readiness state projection.

**Independent Test**: Review candidates with every decision, leave one undecided, cancel, attempt duplicate acceptance, inject a write failure, verify relationship preservation, and verify all four NFR readiness states.

### Tests for User Story 3

- [X] T028 [P] [US3] Add tests for NFR Accept/Modify/Replace/Reject decisions, exactly-one-decision completion gates, and undecided Review Complete failure in .highway/tools/tests/highway-nfr-onboarding.test.sh
- [X] T029 [P] [US3] Add tests for NFR Cancel Review without decision completeness and candidate/NFR/catalog/relationship byte preservation in .highway/tools/tests/highway-nfr-onboarding.test.sh
- [X] T030 [P] [US3] Add tests for duplicate NFR detection before allocation, safe failure, and no partial writes in .highway/tools/tests/highway-nfr-onboarding.test.sh
- [X] T031 [P] [US3] Add tests for one-transaction NFR persistence, relationship preservation, and injected allocation/catalog/relationship failure in .highway/tools/tests/highway-nfr-onboarding.test.sh
- [X] T032 [P] [US3] Add tests for NFR readiness In Progress, Not Applicable, Complete, and Blocked states plus direct `controls: []` authoring in .highway/tools/tests/highway-nfr-onboarding.test.sh
- [X] T033 [P] [US3] Add tests for `/highway-nfrs review` and `/highway-nfrs onboarding` aliases and rejection/cancellation no-write behavior in .highway/tools/tests/governance-routing.test.sh

### Implementation for User Story 3

- [X] T034 [US3] Update NFR Review Complete/Cancel Review semantics, final-decision validation, duplicate detection timing, and atomic write boundary in .highway/skills/highway-nfrs/SKILL.md
- [X] T035 [US3] Update NFR candidate review action aliases, decision outcomes, relationship preservation, and direct-authoring independence in .highway/skills/highway-nfrs/SKILL.md
- [X] T036 [US3] Update NFR readiness state semantics and setup routing references in .highway/skills/highway-nfrs/SKILL.md and .highway/skills/highway-setup/SKILL.md
- [X] T037 [US3] Update the NFR command and setup-readiness contracts in specs/077-controls-nfr-onboarding/contracts/nfr-command.md and specs/077-controls-nfr-onboarding/contracts/setup-readiness.md
- [X] T038 [US3] Run .highway/tools/tests/highway-nfr-onboarding.test.sh and .highway/tools/tests/governance-routing.test.sh, then repair only failures in the touched contract/test slice

**Checkpoint**: NFR candidate review and readiness are independently testable without changing direct NFR ownership.

## Phase 6: Polish and Cross-Cutting Validation

**Purpose**: Regenerate shipped adapters/catalogs, validate all skill contracts, and prove full-suite integrity.

- [X] T039 [P] Regenerate catalog outputs with .highway/tools/generate-catalog.sh and .highway/tools/generate-library-catalog.sh after source skill changes
- [X] T040 [P] Regenerate agent adapters with .highway/tools/generate-agent-adapters.sh after source skill changes
- [X] T041 Update generated-artifact and distribution correspondence expectations only if regeneration changes are required, preserving .github/skills/, .claude/skills/, and .cursor/rules/ consistency
- [X] T042 Run .highway/tools/validate-skill.sh against highway-controls, highway-nfrs, and highway-setup and validate all changed templates/contracts
- [X] T043 Run focused tests from specs/077-controls-nfr-onboarding/quickstart.md and record results for collection, review, candidate, readiness, routing, and failure-path fixtures
- [X] T044 Run .highway/tools/tests/run-all.sh and git diff --check; repair relevant failures and repeat until both pass
- [X] T045 Verify requirement coverage against specs/077-controls-nfr-onboarding/spec.md, update the implementation plan status, and confirm all tasks are marked complete

## Dependencies and Execution Order

### Phase Dependencies

- Phase 1 has no dependencies.
- Phase 2 depends on Phase 1 and blocks all user stories.
- Phase 3 (US1) depends on Phase 2 and is the MVP.
- Phase 4 (US2) depends on Phase 2 and the US1 collection contract.
- Phase 5 (US3) depends on Phase 4 candidate output and the foundational transaction/readiness assertions.
- Phase 6 depends on all three user stories.

### User Story Dependencies

- US1 can begin after Phase 2 and establishes the collection/proposal state used by later stories.
- US2 depends on US1's proposal shape and completes the Control persistence/candidate boundary.
- US3 depends on US2's candidate shape and originating Control relationship.

### Parallel Opportunities

- T002-T004 can run in parallel because they create separate fixture/test files.
- T006-T008 can run in parallel because they extend separate shared test surfaces and fixture directories.
- T010-T013 can run in parallel as test additions, but implementation tasks touching `.highway/skills/highway-controls/SKILL.md` remain sequential.
- T018-T022 can run in parallel across separate test scopes.
- T028-T033 can run in parallel across separate NFR/routing test scopes.
- T039-T040 can run in parallel only after all source skill edits are complete; generated outputs must be reviewed together.

## Implementation Strategy

### MVP First

1. Complete Phases 1-2.
2. Complete US1 and validate guided collection independently.
3. Continue to US2 and US3 because the requested onboarding journey is complete only when candidate review and readiness are implemented.

### Incremental Delivery

1. Establish fixture and contract assertions.
2. Deliver Control collection and routing.
3. Deliver atomic Control review and candidate generation.
4. Deliver NFR candidate review and readiness.
5. Regenerate artifacts and run the full suite.

### Notes

- Every task includes an exact repository path.
- `[P]` tasks touch different files or independent fixture scopes; tasks sharing a skill file remain sequential.
- Test tasks precede the corresponding implementation tasks within each story.
- Mark each task `[X]` only after its focused validation passes.
