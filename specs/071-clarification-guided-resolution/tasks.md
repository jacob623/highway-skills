# Tasks: Clarification Guided Resolution Workflow

**Input**: Design documents from `specs/071-clarification-guided-resolution/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/guided-resolution-contract.md`, and `quickstart.md`

**Tests**: Included because the feature specification requires executable verification of determinism, precedence, lifecycle, immutability, validation, and no-partial-write behavior.

**Organization**: Tasks are grouped by the three P1 user stories. The stories share the canonical skill, output template, and contract test, so implementation proceeds in dependency order even though each story has an independent acceptance target.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the implementation baseline and confirm the existing contract surfaces.

- [ ] T001 Record the passing baseline for `.highway/tools/tests/run-all.sh`, `.highway/tools/validate-skill.sh`, and `.highway/tools/validate-library.sh` before changing the Clarification contract.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Add shared record and fixture structures required by every guided-resolution story.

- [X] T002 [P] Add reusable disposable-fixture helpers and artifact-class probes in `.highway/tools/tests/highway-clarify.test.sh` without weakening existing assertions.
- [X] T003 [P] Extend the shared finding record skeleton with guidance, source-traceability, and informational-selection fields in `.highway/library/templates/output/clarification-record.md` while preserving existing identity, state, count, history, privacy, and response fields.

**Checkpoint**: Shared output shape and test fixtures are ready; user-story implementation can proceed in priority order.

## Phase 3: User Story 1 - Understand an Open Finding (Priority: P1) 🎯 MVP

**Goal**: Every open finding receives one deterministic question, one deterministic Why It Matters explanation, and retained guidance after resolution.

**Independent Test**: Generate open findings for `REQ`, `DISC`, `ADR`, and `RA` fixtures and verify exactly one question and one Why It Matters explanation per finding, byte-identical repeated output, and retained guidance for resolved findings.

### Tests for User Story 1

- [X] T004 [US1] Add failing focused probes for one-question, one-Why-It-Matters, resolved-guidance retention, and repeated-generation byte determinism in `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 1

- [X] T005 [US1] Update the canonical contract version to `2.0.0` and define deterministic Finding, Question, Why It Matters, and guidance-retention behavior in `.highway/skills/highway-clarify/SKILL.md`.
- [X] T006 [US1] Align the generated finding example and required guidance fields for open and resolved findings in `.highway/library/templates/output/clarification-record.md`.
- [X] T007 [US1] Run `.highway/tools/tests/highway-clarify.test.sh` and repair only the Story 1 contract or fixture defects until the independent Story 1 criteria pass.

**Checkpoint**: Story 1 is independently testable as the MVP.

## Phase 4: User Story 2 - Compare Advisory Resolution Options (Priority: P1)

**Goal**: Each open finding presents exactly three deterministic generated options plus Custom in A/B/C/D order, with traceable rationale and declared-source precedence.

**Independent Test**: Generate identical findings for all four artifact types and verify A Recommended, B Alternative, C Alternative, D Custom ordering, rationale completeness, artifact-specific source filtering, highest-precedence selection, absent-evidence fallback, and same-precedence conflict escalation.

### Tests for User Story 2

- [X] T008 [US2] Add failing focused probes for A/B/C/D ordering, rationale completeness, artifact-specific source sets, global precedence, absent evidence, and conflicting highest-precedence evidence in `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 2

- [X] T009 [US2] Define deterministic option generation, declared-source filtering, precedence evaluation, `Unknown` evidence-gap handling, and `Unknown / Escalate for Decision` conflict handling in `.highway/skills/highway-clarify/SKILL.md`.
- [X] T010 [US2] Add Recommended, Alternative B, Alternative C, Custom, rationale, and evidence-source traceability examples and defaults to `.highway/library/templates/output/clarification-record.md`.
- [X] T011 [US2] Run `.highway/tools/tests/highway-clarify.test.sh` and repair only the Story 2 contract or fixture defects until the independent Story 2 criteria pass.

**Checkpoint**: Stories 1 and 2 both pass independently; recommendations remain advisory and source artifacts remain immutable.

## Phase 5: User Story 3 - Record User Selection Without Taking Ownership (Priority: P1)

**Goal**: Record informational option selections separately from accepted responses while preserving lifecycle, history, privacy, source bytes, and ownership boundaries.

**Independent Test**: Record A, B, C, D, and None selections for open and resolved findings; verify selections do not resolve findings, accepted responses perform only `open -> resolved`, invalid values and conflicts produce no write, and all source bytes remain unchanged.

### Tests for User Story 3

- [X] T012 [US3] Add failing focused probes for valid and invalid `selected_option` values, Custom response candidates, accepted-response resolution, resolved-finding retention, privacy filtering, revision conflicts, no-partial-write behavior, and governance/architecture/ADR ownership boundaries in `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 3

- [X] T013 [US3] Define informational selection updates, explicit accepted-response resolution, immutable resolved findings, conflict handling, privacy filtering, and ownership prohibitions in `.highway/skills/highway-clarify/SKILL.md`.
- [X] T014 [US3] Ensure Selected Option defaults to None and Response defaults to None while preserving resolution history and source/evidence retention in `.highway/library/templates/output/clarification-record.md`.
- [X] T015 [US3] Run `.highway/tools/tests/highway-clarify.test.sh` and repair only the Story 3 contract or fixture defects until the independent Story 3 criteria pass.

**Checkpoint**: All three P1 stories are independently testable and preserve the existing Clarification lifecycle and ownership boundaries.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Synchronize shipped artifacts and complete cross-contract validation.

- [X] T016 [P] Regenerate the Clarification catalog, library catalog, and all declared agent adapters with `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh` after canonical contract changes.
- [X] T017 [P] Revalidate `.highway/skills/highway-clarify` and `.highway/library/templates/output/clarification-record.md`, then identify and revalidate every skill and generated adapter that cites the changed shared template under D8.1.
- [X] T018 Run the complete quickstart validation from `specs/071-clarification-guided-resolution/quickstart.md`, including `.highway/tools/tests/run-all.sh` and `git diff --check`, and record requirement coverage separately from check results.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 has no implementation dependency and establishes the pre-edit baseline.
- **Foundational (Phase 2)**: T002 and T003 depend on T001 and may run in parallel because they touch different files; both block user stories.
- **User Story 1 (Phase 3)**: T004 follows T002/T003; T005/T006 follow the failing probes; T007 completes the MVP checkpoint.
- **User Story 2 (Phase 4)**: T008 follows Story 1; T009/T010 follow the failing probes; T011 completes the options checkpoint.
- **User Story 3 (Phase 5)**: T012 follows Story 2; T013/T014 follow the failing probes; T015 completes the lifecycle checkpoint.
- **Polish (Phase 6)**: T016 and T017 follow all implementation stories and may run in parallel; T018 follows both and is the final validation gate.

### User Story Dependencies

- **User Story 1 (P1)**: Depends only on Foundational tasks; delivers the MVP.
- **User Story 2 (P1)**: Depends on Story 1 because it extends the same guidance fields and shared template, but its independent test covers options and precedence.
- **User Story 3 (P1)**: Depends on Stories 1 and 2 because selection and accepted-response persistence update the same finding guidance record.

### Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- T016 and T017 can run in parallel after Stories 1-3; T018 must wait for both.
- Within each story, the failing test task is separate from the canonical skill/template implementation files, but implementation remains sequential where files overlap.

## Parallel Example: Foundational Work

```text
Task: "Add reusable disposable-fixture helpers in .highway/tools/tests/highway-clarify.test.sh"
Task: "Extend the shared finding record skeleton in .highway/library/templates/output/clarification-record.md"
```

## Parallel Example: Final Cross-Cutting Work

```text
Task: "Regenerate catalogs and agent adapters with the existing generators"
Task: "Revalidate highway-clarify and every skill citing clarification-record.md under D8.1"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete T001-T003.
2. Complete T004-T007.
3. Stop and validate deterministic question, Why It Matters, and retained-guidance behavior independently.

### Incremental Delivery

1. Add Story 1 for the minimum guided finding experience.
2. Add Story 2 for deterministic options and source precedence.
3. Add Story 3 for informational selection and explicit resolution.
4. Regenerate and run all cross-cutting checks after the three stories are complete.

### Completion Criteria

- All 18 tasks use the required checkbox, sequential ID, optional `[P]` marker, story label where required, and exact file path format.
- Every user story has an independent test criterion and a focused test task before implementation tasks.
- The final suite result and requirement coverage are reported as separate claims.
