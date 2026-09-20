---

description: "Executable task list for Discovery Analysis"
---

# Tasks: Discovery Analysis

**Input**: Design documents from `specs/048-discovery-artifact/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Organization**: Tasks are grouped by user story. Baseline test remediation is a prerequisite because the plan explicitly requires the existing suite to be green before Feature 048 completion.

Known baseline failures to remediate: constitution-inventory.test.sh, distribution-packaging.test.sh, and highway-new.test.sh were failing before Feature 048 implementation. The remediation tasks below must resolve them without weakening assertions.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the measured baseline and repair the three pre-existing failures before Feature 048 behavior is added.

- [X] T001 Record the current `.highway/tools/tests/run-all.sh` result and the three known failures in `specs/048-discovery-artifact/plan.md` without attributing them to Feature 048.
- [X] T002 Repair the D1.2 seeded-defect probes and neutralized-probe path in `.highway/tools/tests/constitution-inventory.test.sh` so malformed source and generated artifacts make the packaging check fail for the intended reason.
- [X] T003 Repair stray `.DS_Store` handling and negative-fixture diagnostics in `.highway/tools/tests/distribution-packaging.test.sh`, preserving development-reference, unresolved-reference, and overwrite-guard assertions.
- [X] T004 Restore the allowed no-constraint phrases in `.highway/skills/highway-new/SKILL.md`, regenerate `.github/skills/highway-new/SKILL.md`, `.claude/skills/highway-new/SKILL.md`, `.cursor/rules/highway-new.mdc`, and update generated catalog inputs as required.
- [X] T005 Run `.highway/tools/tests/constitution-inventory.test.sh`, `.highway/tools/tests/distribution-packaging.test.sh`, `.highway/tools/tests/highway-new.test.sh`, and `.highway/tools/tests/run-all.sh`; record the repaired baseline and any remaining unrelated failure in `specs/048-discovery-artifact/plan.md`.

**Checkpoint**: The baseline failures are repaired or explicitly blocked with evidence before Discovery implementation proceeds.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create the shared contracts, source skill boundary, and disposable test harness required by every user story.

- [X] T006 [P] Create the complete Discovery record template at `.highway/library/templates/output/discovery-record.md` with frontmatter, title, Request, analysis, and relationship sections in contract order.
- [X] T007 [P] Create the complete Discovery catalog template at `.highway/library/templates/output/discovery-catalog.md` with Version, Next ID, and Discovery Index structure only.
- [X] T008 [P] Add the Discovery test harness and disposable workspace setup in `.highway/tools/tests/highway-discovery.test.sh`, including byte snapshots and cleanup for user-owned `requests/` and `discoveries/` files.
- [X] T009 Create the source skill skeleton and frontmatter in `.highway/skills/highway-discovery/SKILL.md`, citing both shared templates and the conversation and analysis contracts without referencing development-only paths.
- [X] T010 Add contract assertions for invocation, closed inputs, deterministic rule order, output structure, ADR handoff, and failure behavior to `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T011 Validate the templates and source skill with `.highway/tools/validate-library.sh` and `.highway/tools/validate-skill.sh`, and record any contract corrections in `.highway/tools/tests/highway-discovery.test.sh`.

**Checkpoint**: Templates, source boundary, and focused test harness are valid; user-story implementation can proceed.

## Phase 3: User Story 1 - Create a Discovery from a Completed Request (Priority: P1) MVP

**Goal**: Analyze one explicitly selected completed Request and create exactly one deterministic Discovery record and catalog entry.

**Independent Test**: In a disposable workspace, provide one completed `REQ000001` and no Discovery catalog, invoke the skill with that identifier, and verify `DISC000001`, catalog bootstrap, all nine sections, one Request reference, and deterministic repeated output.

### Tests for User Story 1

- [X] T012 [US1] Add bootstrap, allocation, authoritative Request preservation, title derivation, catalog advancement, and deterministic-repeat scenarios to `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T013 [US1] Add record and catalog structure assertions against `.highway/library/templates/output/discovery-record.md`, `.highway/library/templates/output/discovery-catalog.md`, and generated disposable outputs in `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation for User Story 1

- [X] T014 [US1] Implement explicit `REQ` source resolution and completed-state validation in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T015 [US1] Implement closed input loading and authoritative Request evidence preservation in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T016 [US1] Implement deterministic normalization, research findings, assumptions, risks, unknowns, candidate approaches, title derivation, stable ordering, and serialization rules in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T017 [US1] Implement catalog bootstrap, catalog-authoritative `DISC` allocation, exactly-once index advancement, in-memory construction, output validation, and ordered writes in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T018 [US1] Run the focused User Story 1 scenarios in `.highway/tools/tests/highway-discovery.test.sh` and correct only implementation defects in `.highway/skills/highway-discovery/SKILL.md` or the shared templates.

**Checkpoint**: User Story 1 independently creates a deterministic Discovery and catalog entry from a completed Request.

## Phase 4: User Story 2 - Reject Requests That Are Not Ready (Priority: P1)

**Goal**: Refuse invalid source input or unsafe analysis without creating or mutating Discovery outputs.

**Independent Test**: Run missing, malformed, ambiguous, nonexistent, non-unique, incomplete, privacy-sensitive, malformed-catalog, validation-failure, and write-failure scenarios, then compare output file sets and bytes before and after.

### Tests for User Story 2

- [X] T019 [US2] Add invalid-source and incomplete-Request no-write scenarios to `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T020 [US2] Add privacy exclusion, replacement-evidence, malformed-catalog, allocation-retry-limit, validation-failure, and write-failure byte-preservation scenarios to `.highway/tools/tests/highway-discovery.test.sh`.

### Implementation for User Story 2

- [X] T021 [US2] Implement explicit abort messages and zero-write behavior for missing, ambiguous, malformed, nonexistent, non-unique, and incomplete sources in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T022 [US2] Implement privacy-first redaction and stable replacement-evidence behavior for secrets and regulated personal data in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T023 [US2] Implement malformed-catalog rejection, exclusive allocation retries capped at three, validation ordering, and no-partial-write failure handling in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T024 [US2] Run the focused User Story 2 scenarios in `.highway/tools/tests/highway-discovery.test.sh` and verify existing Request, Discovery, and catalog bytes remain unchanged on every failure path.

**Checkpoint**: User Stories 1 and 2 both pass independently; invalid and unsafe inputs cannot mutate user-owned outputs.

## Phase 5: User Story 3 - Record Advisory Relationships and Boundaries (Priority: P2)

**Goal**: Identify deterministic Objective, Control, and NFR candidates with rationale and confidence while preserving governance ownership and bytes.

**Independent Test**: Provide matching and non-matching Objective, Control, and NFR baselines, run Discovery, and verify advisory candidates, confidence, rationale, empty sections, and unchanged baseline bytes.

### Tests for User Story 3

- [X] T025 [US3] Add explicit-identifier High, exact-title Medium, two-token Low, one-token rejection, duplicate, ordering, and no-match relationship scenarios to `.highway/tools/tests/highway-discovery.test.sh`.
- [X] T026 [US3] Add governance immutability and ADR handoff assertions to `.highway/tools/tests/highway-discovery.test.sh`, including exactly one `REQ` reference and the future exactly one `DISC` handoff reference.

### Implementation for User Story 3

- [X] T027 [US3] Implement independent Objective, Control, and NFR matching with explicit-identifier, normalized-title/statement, and two-token confidence rules in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T028 [US3] Implement relationship rationale, confidence labels, advisory markers, deduplication, and deterministic confidence/identifier ordering in `.highway/skills/highway-discovery/SKILL.md`.
- [X] T029 [US3] Implement governance ownership boundaries and ADR handoff behavior in `.highway/skills/highway-discovery/SKILL.md` and validate the complete output structure in `.highway/library/templates/output/discovery-record.md`.
- [X] T030 [US3] Run the focused User Story 3 scenarios in `.highway/tools/tests/highway-discovery.test.sh` and prove Objective, Control, NFR, Request, and catalog source bytes are unchanged except for the intended Discovery outputs.

**Checkpoint**: All three user stories pass independently, with relationships advisory and governance baselines immutable.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate shipped outputs, verify correspondence and documentation, and close the full validation loop.

- [X] T031 Regenerate `.highway/catalog/`, `.github/skills/highway-discovery/SKILL.md`, `.claude/skills/highway-discovery/SKILL.md`, and `.cursor/rules/highway-discovery.mdc` with `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh`.
- [X] T032 Run `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/validate-skill.test.sh`, `.highway/tools/tests/validate-library.test.sh`, and `.highway/tools/tests/output-template.test.sh`; repair drift only in source inputs or generators, never generated outputs.
- [X] T033 Run the complete quickstart scenarios from `specs/048-discovery-artifact/quickstart.md` and record command results separately from Feature 048 requirement coverage in `specs/048-discovery-artifact/plan.md`.
- [X] T034 Run `.highway/tools/tests/run-all.sh`, confirm the three baseline failures remain resolved, and record any remaining failure with its owning test and diagnostic in `specs/048-discovery-artifact/plan.md`.
- [X] T035 Verify all shipped references and development documentation links resolve, including `specs/048-discovery-artifact/plan.md`, `specs/048-discovery-artifact/quickstart.md`, `.highway/library/templates/output/discovery-record.md`, and `.highway/library/templates/output/discovery-catalog.md`.
- [X] T036 Update the Feature 048 completion evidence in `specs/048-discovery-artifact/plan.md` and `specs/048-discovery-artifact/quickstart.md` with final suite results, requirement coverage, generated-artifact status, and unresolved-risk notes.

## Dependencies and Execution Order

### Phase Dependencies

- **Phase 1**: Baseline remediation can begin immediately and must complete before the final green-suite claim.
- **Phase 2**: Depends on Phase 1's measured baseline; blocks all user-story work because every story uses the shared templates, source skill, and focused test harness.
- **Phase 3 (US1)**: Depends on Phase 2 and is the MVP increment.
- **Phase 4 (US2)**: Depends on Phase 3's output transaction path; it hardens the same source skill and test harness.
- **Phase 5 (US3)**: Depends on Phase 2 and can proceed after the shared output path exists; final integration follows US1 and US2 for one coherent skill.
- **Phase 6**: Depends on all desired user stories and baseline remediation.

### User Story Dependencies

- **US1 (P1)**: Depends on Foundational Phase 2; no dependency on US2 or US3.
- **US2 (P1)**: Depends on US1's construction and write path; independently validates rejection and no-write behavior.
- **US3 (P2)**: Depends on Foundational Phase 2; relationship matching can be developed in parallel with US2 but integrates after the core output path.

### Parallel Opportunities

- T002 and T003 can run in parallel because they modify separate test files.
- T006, T007, and T008 can run in parallel because they create separate template/test files.
- After T011, US2 test preparation (T019-T020) and US3 test preparation (T025-T026) can run in parallel with US1 implementation, provided each uses the shared harness without conflicting edits.
- T031 and T032 are sequential because correspondence validation depends on regenerated outputs; T035 can run in parallel with final command execution.

## Parallel Execution Examples

### User Story 1

```text
Task T012: Add bootstrap and deterministic scenarios in .highway/tools/tests/highway-discovery.test.sh
Task T013: Add record/catalog contract assertions in .highway/tools/tests/highway-discovery.test.sh
Task T014: Implement source resolution in .highway/skills/highway-discovery/SKILL.md
```

T012 and T013 must be merged before implementation validation; T014-T017 remain ordered because they extend one source skill.

### User Story 2

```text
Task T019: Add invalid-source scenarios in .highway/tools/tests/highway-discovery.test.sh
Task T020: Add privacy and transaction scenarios in .highway/tools/tests/highway-discovery.test.sh
```

T019 and T020 target the same test file, so they are conceptual parallel opportunities only and should be serialized by one implementer.

### User Story 3

```text
Task T025: Add relationship matching scenarios in .highway/tools/tests/highway-discovery.test.sh
Task T026: Add immutability and handoff assertions in .highway/tools/tests/highway-discovery.test.sh
Task T027: Implement matching rules in .highway/skills/highway-discovery/SKILL.md
```

T025 and T026 should be serialized because they share the focused test file; T027 can begin after the contract cases are agreed.

## Implementation Strategy

### MVP First: User Story 1

1. Complete Phase 1 baseline remediation.
2. Complete Phase 2 shared templates, source boundary, and focused harness.
3. Complete Phase 3 User Story 1.
4. Run the independent bootstrap, allocation, structure, and determinism scenarios.
5. Stop for MVP review before adding failure hardening and relationship matching.

### Incremental Delivery

1. Baseline repairs plus setup/foundation.
2. Add US1 for deterministic Discovery creation.
3. Add US2 for invalid-input, privacy, and transaction safety.
4. Add US3 for advisory relationships and ADR handoff boundaries.
5. Regenerate outputs and run the complete quickstart and suite.

### Completion Evidence

The implementation is complete only when every task is checked, all three user stories pass their independent tests, generated artifacts have no drift, the baseline failures are resolved, and final requirement coverage is reported separately from executable check results.

## Notes

- Every task uses `- [ ] T###` format and names at least one concrete repository path.
- `[P]` marks only tasks that can safely use separate files without incomplete dependencies.
- Story labels appear only in User Story phases.
- Tests are included because the specification and quickstart define executable validation scenarios.
- Generated files are outputs of existing generators and must not be hand-edited.
