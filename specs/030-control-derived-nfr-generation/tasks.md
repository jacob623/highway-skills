# Tasks: Control-Derived NFR Generation

**Input**: Design documents from `/specs/030-control-derived-nfr-generation/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `contracts/derived-nfr-workflow.md`

**Tests**: Focused behavioral tests are included because the feature specification defines independent tests and measurable write-order, determinism, preservation, and relationship outcomes.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated as an incremental governance workflow.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish disposable fixtures and the focused test surface without modifying live user-owned governance data.

- [X] T001 [P] Create isolated Control-derived NFR fixture directories and baseline catalog records in `.highway/tools/tests/fixtures/control-derived-nfr/`.
- [X] T002 [P] Add the focused Bash test entry point with cleanup traps and temporary `library/governance/` setup in `.highway/tools/tests/control-derived-nfr.test.sh`.
- [X] T003 Record the existing reserved `nfrs` and `controls` template shapes and allocator assumptions in `.highway/tools/tests/fixtures/control-derived-nfr/README.md`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define the shared deterministic proposal, review, allocation, and failure contracts before story implementation.

**Checkpoint**: The fixture harness can snapshot user-owned records/catalogs and assert zero writes on rejected, cancelled, zero-candidate, and invalid-baseline paths.

- [X] T004 [P] Encode the fixed ordered Control-content candidate rules and normalized-input expectations in `.highway/tools/tests/fixtures/control-derived-nfr/candidate-rules.expected`.
- [X] T005 [P] Add fixture Controls covering derivable intent, zero candidates, multiple candidates, existing relationships, and invalid input in `.highway/tools/tests/fixtures/control-derived-nfr/controls/`.
- [X] T006 [P] Add fixture NFR catalogs covering safe allocation, existing relationships, malformed state, missing state, and unsafe `next_id` allocation in `.highway/tools/tests/fixtures/control-derived-nfr/nfrs/`.
- [X] T007 Implement shared snapshot, frontmatter, relationship, and byte-preservation assertions in `.highway/tools/tests/control-derived-nfr.test.sh`.
- [X] T008 Document the proposal-before-write barrier, stable candidate order, identifier-only links, and Phase 4 exclusions in `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-nfrs/SKILL.md`.

---

## Phase 3: User Story 1 - Propose NFRs from a new Control (Priority: P1) 🎯 MVP

**Goal**: A valid newly added Control produces deterministic, reviewable NFR candidates, or an explicit zero-candidate result without creating NFR artifacts.

**Independent Test**: Add the same fixture Control in isolated runs and compare candidate titles, statements, rationales, ordering, and originating Control information byte-for-byte; verify the zero-candidate Control remains valid and produces no NFR write.

### Tests for User Story 1

- [X] T009 [P] [US1] Add deterministic repeated-generation, normalized-input, and catalog-order-independence assertions in `.highway/tools/tests/control-derived-nfr.test.sh`.
- [X] T010 [P] [US1] Add candidate-content and zero-candidate assertions for fixture Controls in `.highway/tools/tests/control-derived-nfr.test.sh`.

### Implementation for User Story 1

- [X] T011 [US1] Define the fixed ordered candidate mapping and normalization procedure in `.highway/skills/highway-controls/SKILL.md` using only Control title and statement.
- [X] T012 [US1] Add the proposal-rendering workflow to `.highway/skills/highway-controls/SKILL.md`, including Control ID/title, candidate title/statement/rationale, stable order, and explicit no-match handling.
- [X] T013 [US1] Add proposal output and zero-candidate verification instructions to `.highway/skills/highway-controls/SKILL.md` without allocating NFR IDs or mutating NFR artifacts.

**Checkpoint**: User Story 1 is independently testable with deterministic proposal output and no-write zero-candidate behavior.

---

## Phase 4: User Story 2 - Review candidates before creation (Priority: P1)

**Goal**: The author controls every candidate outcome through Accept, Modify, Replace, Reject, or Cancel before any NFR-side write.

**Independent Test**: Generate candidates, confirm records/catalogs are unchanged at proposal time, exercise all review actions, and verify only approved wording can proceed to creation.

### Tests for User Story 2

- [X] T014 [P] [US2] Add proposal-before-write assertions proving no NFR ID, record, catalog entry, or relationship exists before review in `.highway/tools/tests/control-derived-nfr.test.sh`.
- [X] T015 [P] [US2] Add Accept, Modify, Replace, Reject, and Cancel decision fixtures and assertions for approved wording and zero-write outcomes in `.highway/tools/tests/control-derived-nfr.test.sh`.

### Implementation for User Story 2

- [X] T016 [US2] Define per-candidate Accept, Modify, Replace, Reject, and Cancel interaction rules in `.highway/skills/highway-controls/SKILL.md`.
- [X] T017 [US2] Enforce the hard review write barrier and stable processing order in `.highway/skills/highway-controls/SKILL.md`.
- [X] T018 [US2] Specify that Modify and Replace require complete author-approved title, statement, and rationale before acceptance in `.highway/skills/highway-controls/SKILL.md`.
- [X] T019 [US2] Update direct NFR authoring behavior and output wording in `.highway/skills/highway-nfrs/SKILL.md` so un-derived NFRs retain `controls: []`.

**Checkpoint**: User Story 2 is independently testable with all review actions and zero-write rejection/cancellation behavior.

---

## Phase 5: User Story 3 - Preserve accepted Control-to-NFR traceability (Priority: P1)

**Goal**: Accepted candidates allocate safe immutable NFR IDs, create approved NFR records, and update both existing identifier-only relationship fields while preserving unrelated user data.

**Independent Test**: Accept one and several candidates against existing Control/NFR baselines, then verify NFR `controls`, Control `nfrs`, catalog allocation, existing relationships, direct NFR behavior, and invalid-state zero partial writes.

### Tests for User Story 3

- [X] T020 [P] [US3] Add accepted single- and multi-candidate relationship assertions for `Control.nfrs` and `NFR.controls` in `.highway/tools/tests/control-derived-nfr.test.sh`.
- [X] T021 [P] [US3] Add preservation and duplicate-prevention assertions for existing IDs, records, catalogs, and relationships in `.highway/tools/tests/control-derived-nfr.test.sh`.
- [X] T022 [P] [US3] Add malformed-catalog, missing-catalog, unsafe-allocation, and write-failure assertions proving zero partial derived writes in `.highway/tools/tests/control-derived-nfr.test.sh`.

### Implementation for User Story 3

- [X] T023 [US3] Document accepted NFR allocation, approved record creation, Control relationship update, catalog regeneration, and verification order in `.highway/skills/highway-controls/SKILL.md`.
- [X] T024 [US3] Update the Control and NFR output templates to preserve record formats while documenting the reserved relationship fields in `.highway/library/templates/output/control-record.md` and `.highway/library/templates/output/nfr-record.md`.
- [X] T025 [US3] Specify identifier-only relationship values, existing-relationship preservation, duplicate avoidance, and safe-stop behavior across `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-nfrs/SKILL.md`.
- [X] T026 [US3] Add accepted-derived relationship and direct-authoring examples to `.highway/tools/tests/fixtures/control-derived-nfr/` without creating root-level live governance records.

**Checkpoint**: User Story 3 is independently testable for accepted traceability, preservation, direct NFR authoring, and zero partial writes.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate all derived surfaces, validate shipped skill correspondence, and prove the complete feature without modifying user-owned root governance data.

- [X] T027 [P] Regenerate catalogs from updated skill and template sources using `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-library-catalog.sh`.
- [X] T028 [P] Regenerate agent adapters and correspondence manifests using `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-distribution.sh`.
- [X] T029 Run the focused Control-derived NFR test `.highway/tools/tests/control-derived-nfr.test.sh` and repair only failures in the Feature 030 slice.
- [X] T030 Run skill and library validators `.highway/tools/validate-skill.sh` and `.highway/tools/validate-library.sh` against all changed source surfaces.
- [X] T031 Run adapter coverage, packaging, generated-correspondence, and full-suite checks through `.highway/tools/tests/run-all.sh`.
- [X] T032 Run the scenarios in `specs/030-control-derived-nfr-generation/quickstart.md`, including direct NFR empty-controls and deferred Phase 4 scope checks.
- [X] T033 Run `git diff --check` and verify no root-level `library/governance/` user data was created or modified by the focused tests.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; creates only disposable fixtures and the focused harness.
- **Foundational (Phase 2)**: Depends on Setup; blocks all story implementation.
- **User Story 1 (Phase 3)**: Depends on Foundational; establishes deterministic candidate generation and is the MVP.
- **User Story 2 (Phase 4)**: Depends on User Story 1 proposal output; adds review decisions and the hard write barrier.
- **User Story 3 (Phase 5)**: Depends on User Story 2 approved decisions; adds allocation, records, catalogs, and both relationship writes.
- **Polish (Phase 6)**: Depends on all desired stories; regenerates artifacts and runs complete validation.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Phase 2; no other story dependency.
- **User Story 2 (P1)**: Depends on User Story 1's candidate contract and output surface.
- **User Story 3 (P1)**: Depends on User Story 2's approved review results; it must not bypass the review barrier.

### Within Each User Story

- Tests establish the behavior and failure assertions before the corresponding skill workflow is enabled.
- Candidate contract precedes review behavior; review behavior precedes allocation and relationship writes.
- Accepted writes use existing catalogs and templates; generated artifacts are regenerated only after source changes.
- Each story checkpoint must pass before proceeding to the next story.

## Parallel Opportunities

- T001-T006 can be split across fixture, harness, and contract work once the existing record shapes are confirmed.
- T009 and T010 can run in parallel because they add independent assertions to the focused test surface.
- T014 and T015 can run in parallel before User Story 2 implementation.
- T020-T022 can run in parallel because they cover distinct accepted-write and failure behaviors.
- T027 and T028 can run in parallel after all source changes are complete.
- Different story phases should remain sequential because each later phase consumes the prior phase's contract.

## Parallel Example: User Story 1

```text
Task: "T009 [US1] Add deterministic repeated-generation assertions in .highway/tools/tests/control-derived-nfr.test.sh"
Task: "T010 [US1] Add candidate-content and zero-candidate assertions in .highway/tools/tests/control-derived-nfr.test.sh"
```

## Parallel Example: User Story 3

```text
Task: "T020 [US3] Add accepted single- and multi-candidate relationship assertions in .highway/tools/tests/control-derived-nfr.test.sh"
Task: "T021 [US3] Add preservation and duplicate-prevention assertions in .highway/tools/tests/control-derived-nfr.test.sh"
Task: "T022 [US3] Add invalid-catalog and unsafe-allocation zero-partial-write assertions in .highway/tools/tests/control-derived-nfr.test.sh"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement deterministic candidate generation and zero-candidate handling in User Story 1.
3. Run the focused User Story 1 assertions and confirm proposal output is stable and write-free.
4. Stop for review/demo before enabling accepted NFR writes.

### Incremental Delivery

1. Add User Story 1 for deterministic proposals.
2. Add User Story 2 for author review and zero-write rejection/cancellation.
3. Add User Story 3 for accepted NFR creation and two-sided immutable traceability.
4. Complete Polish to regenerate artifacts and run the full validation suite.

### Scope Guard

Do not add reverse NFR-to-Control generation, removal coupling, reconciliation, orphan repair,
bidirectional synchronization, an alternate relationship store, or a Control/NFR record-format change.
