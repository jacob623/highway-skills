---

description: "Task list for Highway New Solution Constraints Cleanup"
---

# Tasks: Highway New Solution Constraints Cleanup

**Input**: Design documents from `specs/057-highway-new-solution-constraints-cleanup/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Required by the feature specification for focused wording, validation, recovery, privacy, and boundary checks.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested as an incremental contract change.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the existing source, output, test, and generated-artifact surfaces without changing implementation behavior.

- [X] T001 Record the current `highway-new` focused-test baseline and existing user modifications in `.highway/tools/tests/highway-new.test.sh`
- [X] T002 [P] Confirm the active Spec 057 requirements and implementation paths in `specs/057-highway-new-solution-constraints-cleanup/spec.md` and `specs/057-highway-new-solution-constraints-cleanup/plan.md`
- [X] T003 [P] Confirm the existing eight-field order and durable Request structure in `.highway/library/templates/output/request-record.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the shared contract vocabulary and preservation constraints required by all three stories.

- [X] T004 Define the eight Solution Constraints field states, invalid states, and correction transition in `specs/057-highway-new-solution-constraints-cleanup/data-model.md`
- [X] T005 [P] Map the intake behavior, privacy boundary, and no-restart recovery contract in `specs/057-highway-new-solution-constraints-cleanup/contracts/solution-constraints-intake-contract.md`
- [X] T006 [P] Map verification assertions, static-versus-runtime evidence, and Discovery/ADR boundaries in `specs/057-highway-new-solution-constraints-cleanup/contracts/solution-constraints-verification-contract.md`

**Checkpoint**: Shared field semantics and ownership boundaries are explicit; user-story implementation can proceed in priority order.

---

## Phase 3: User Story 1 - Understand Solution Constraints Field Shapes (Priority: P1) MVP

**Goal**: Make all four list-shaped and four scalar Solution Constraints fields explicit, including the distinct permitted empty and `unknown` states.

**Independent Test**: Review the authoritative guidance and focused assertions to confirm exactly four list-shaped fields and exactly four scalar fields, with valid state rules and no scalar empty arrays.

### Tests for User Story 1

- [X] T007 [P] [US1] Add failing focused assertions for the four list-shaped fields, four scalar fields, permitted states, and legacy generic list wording in `.highway/tools/tests/highway-new.test.sh`

### Implementation for User Story 1

- [X] T008 [US1] Replace generic list guidance with explicit list-shaped field categories and empty-versus-`unknown` semantics in `.highway/skills/highway-new/SKILL.md`
- [X] T009 [P] [US1] Align the shared Request output guidance with the four list-shaped and four scalar field contracts without changing field order or structure in `.highway/library/templates/output/request-record.md`
- [X] T010 [US1] Run the focused field-shape assertions and confirm the corrected wording passes while the legacy wording assertion fails when seeded in `.highway/tools/tests/highway-new.test.sh`

**Checkpoint**: User Story 1 is independently testable; field shape and state semantics are explicit without changing the Request schema.

---

## Phase 4: User Story 2 - Preserve a Determinate Discovery Candidate Space (Priority: P1)

**Goal**: Require `allowed_solution_classes` to contain one or more non-empty values or `unknown`, and ensure an empty candidate space is rejected and never handed to Discovery.

**Independent Test**: Focused validation accepts populated and `unknown` candidate-space values, rejects empty or malformed values, and verifies the downstream handoff shape without implementing Discovery analysis.

### Tests for User Story 2

- [X] T011 [P] [US2] Add failing focused cases for empty, blank, scalar, empty-entry, populated, and `unknown` `allowed_solution_classes` values plus the Discovery handoff invariant in `.highway/tools/tests/highway-new.test.sh`

### Implementation for User Story 2

- [X] T012 [US2] Document why an empty `allowed_solution_classes` list makes the future Discovery domain indeterminate and specify the accepted non-empty-or-`unknown` rule in `.highway/skills/highway-new/SKILL.md`
- [X] T013 [P] [US2] Update the shared Request output verification wording so an empty `allowed_solution_classes` value cannot be persisted or forwarded while preserving the existing record structure in `.highway/library/templates/output/request-record.md`
- [X] T014 [US2] Run candidate-space focused validation and confirm it does not add candidate generation, filtering, scoring, recommendation, or architecture analysis in `.highway/tools/tests/highway-new.test.sh`

**Checkpoint**: User Story 2 is independently testable; future Discovery receives only a valid candidate-space shape.

---

## Phase 5: User Story 3 - Recover from a Field Error Without Restarting Intake (Priority: P1)

**Goal**: Give actionable field-specific correction requests, preserve valid prior answers, screen replacements for privacy, and continue at the failed field.

**Independent Test**: Seed invalid list, scalar, and candidate-space answers; verify each error names the field and shape, gives an example, requests a replacement or `unknown`, and updates only the failed field.

### Tests for User Story 3

- [X] T015 [P] [US3] Add failing focused assertions for exact field-error content, local replacement, retained prior answers, privacy rejection, and legacy field-error wording in `.highway/tools/tests/highway-new.test.sh`

### Implementation for User Story 3

- [X] T016 [US3] Replace the legacy field-error guidance with exact-field, accepted-shape, valid-example, and replacement-or-`unknown` recovery instructions in `.highway/skills/highway-new/SKILL.md`
- [X] T017 [P] [US3] Align the shared Request contract's Business Constraints wording with `No business constraints` and preserve its explicit empty state and `unknown` distinction in `.highway/library/templates/output/request-record.md`
- [X] T018 [US3] Run local-correction and privacy-focused validation, confirming collection does not restart and disallowed replacements are not written in `.highway/tools/tests/highway-new.test.sh`

**Checkpoint**: All three P1 stories are independently testable and preserve question order, privacy, retry, transaction, and write-safety behavior.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate distributed outputs, run repository validation, and verify the complete feature contract.

- [X] T019 [P] Regenerate catalog and all declared agent adapters from the updated source skill using `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh`
- [X] T020 [P] Validate the updated authoritative skill and shared Request template with `.highway/tools/validate-skill.sh` and `.highway/tools/validate-library.sh`
- [X] T021 Run adapter coverage, distribution, shipped-tree, and focused correspondence checks against `.github/skills/highway-new/SKILL.md`, `.claude/skills/highway-new/SKILL.md`, and `.cursor/rules/highway-new.mdc`
- [X] T022 Run the full repository test suite and record any unrelated pre-existing failures separately from Spec 057 results in `.highway/tools/tests/run-all.sh`
- [X] T023 Run every design-artifact and scenario command in `specs/057-highway-new-solution-constraints-cleanup/quickstart.md` and verify `git diff --check`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No implementation dependency; establishes baseline and confirms the intended surfaces.
- **Foundational (Phase 2)**: Depends on Setup; defines shared semantics and boundaries before story edits.
- **User Story 1 (Phase 3)**: Depends on Foundational; provides the field-shape vocabulary used by later stories.
- **User Story 2 (Phase 4)**: Depends on User Story 1's field classification; narrows the `allowed_solution_classes` exception.
- **User Story 3 (Phase 5)**: Depends on User Stories 1 and 2 so recovery messages can name each final shape and candidate-space rule.
- **Polish (Phase 6)**: Depends on all desired stories; regenerates outputs and runs final validation.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Phase 2 only; independently delivers the field-shape contract.
- **User Story 2 (P1)**: Depends on US1's classification; independently verifies candidate-space semantics after that vocabulary exists.
- **User Story 3 (P1)**: Depends on US1 and US2; recovery must cover the final list, scalar, and candidate-space rules together.

### Within Each User Story

- Focused test assertions are added and observed failing before the corresponding guidance is changed.
- Authoritative skill and shared-template changes remain separate tasks because they are different files.
- Focused validation runs after each story before proceeding to the next story.
- Generated artifacts are updated only after all authoritative source changes are complete.

### Parallel Opportunities

- T002 and T003 can run in parallel with baseline collection after setup begins.
- T005 and T006 can run in parallel because they edit separate contract documents.
- T007 can be prepared while the foundational contracts are reviewed; T009 is parallelizable with T008 after the failing assertions exist.
- T011 can be prepared while US1's source/template edits are reviewed; T013 is parallelizable with T012 after candidate-space tests exist.
- T015 can be prepared while US2's source/template edits are reviewed; T017 is parallelizable with T016 after recovery tests exist.
- T019 and T020 can run in parallel after all source edits; T021 follows regeneration.

---

## Parallel Example: User Story 1

```text
Task: Add failing field-shape and legacy-wording assertions in .highway/tools/tests/highway-new.test.sh
Task: Review the existing shared Request structure in .highway/library/templates/output/request-record.md

After the assertions exist:
Task: Update field-shape guidance in .highway/skills/highway-new/SKILL.md
Task: Update corresponding shared output wording in .highway/library/templates/output/request-record.md
```

## Parallel Example: User Story 2

```text
Task: Add failing candidate-space assertions in .highway/tools/tests/highway-new.test.sh
Task: Review candidate-space handoff wording in .highway/library/templates/output/request-record.md

After the assertions exist:
Task: Update candidate-space guidance in .highway/skills/highway-new/SKILL.md
Task: Update candidate-space verification wording in .highway/library/templates/output/request-record.md
```

## Parallel Example: User Story 3

```text
Task: Add failing field-error and local-recovery assertions in .highway/tools/tests/highway-new.test.sh
Task: Review existing privacy and write-safety assertions in .highway/tools/tests/highway-new.test.sh

After the assertions exist:
Task: Update field-error recovery guidance in .highway/skills/highway-new/SKILL.md
Task: Update Business Constraints wording in .highway/library/templates/output/request-record.md
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Add and observe the failing US1 field-shape assertions.
3. Update the authoritative skill and shared output wording.
4. Run the US1 focused validation checkpoint.
5. Stop for review if only explicit field-shape guidance is required; otherwise continue to US2.

### Incremental Delivery

1. Deliver US1's four-list/four-scalar vocabulary and state semantics.
2. Deliver US2's non-empty candidate-space invariant and Discovery handoff shape.
3. Deliver US3's field-local correction and privacy-preserving recovery behavior.
4. Regenerate adapters/catalog and run validators, correspondence checks, and the full suite.

### Scope Guardrails

- Do not add, remove, rename, or reorder the eight Solution Constraints fields.
- Do not change the durable Request schema or Business Constraints empty representation.
- Do not implement Discovery candidate analysis or ADR decisions.
- Preserve user modifications already present in `.highway/tools/tests/highway-new.test.sh`.
