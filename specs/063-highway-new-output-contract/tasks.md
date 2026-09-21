# Tasks: Highway New Shared Output Contract Migration

**Input**: Design documents from `specs/063-highway-new-output-contract/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Included because the feature specification requires focused disposable-fixture and correspondence validation.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested independently after foundational inventory work.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the explicit Feature 063 implementation context without invoking the stale Feature 061 resolver.

- [x] T001 Confirm Feature 063 source and design paths in `specs/063-highway-new-output-contract/plan.md` and `specs/063-highway-new-output-contract/spec.md`
- [x] T002 [P] Capture a baseline status and byte-preservation reference for `.highway/skills/highway-new/SKILL.md`, `.highway/library/templates/output/request-record.md`, `.highway/library/templates/output/request-catalog.md`, generated highway-new adapters, and user-owned Request paths in `.highway/tools/tests/highway-new.test.sh`
- [x] T003 [P] Inspect the existing focused test entry points and Bash 3.2 conventions in `.highway/tools/tests/highway-new.test.sh` and `.highway/tools/tests/output-template.test.sh`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the ownership and behavior inventory that every story depends on.

- [x] T004 Inventory the authoritative Request record and catalog template sections and placeholders in `.highway/library/templates/output/request-record.md` and `.highway/library/templates/output/request-catalog.md`
- [x] T005 Inventory duplicated structural declarations and retained behavioral invariants in `.highway/skills/highway-new/SKILL.md`
- [x] T006 Define independent disposable fixture helpers and canonical/user-owned byte-preservation assertions in `.highway/tools/tests/highway-new.test.sh`

**Checkpoint**: Baseline inventory and isolated fixture strategy are ready; User Stories 1 and 2 can proceed independently, while User Story 3 consumes both migrated contract slices.

## Phase 3: User Story 1 - Delegate Request Record Structure (Priority: P1) 🎯 MVP

**Goal**: Make the Request record template the sole structural authority while preserving intake, privacy, validation, status, and write behavior.

**Independent Test**: A focused source check accepts the complete Request record citation and rejects missing citation or duplicated Request record structure in disposable fixtures; the canonical skill still passes validation.

### Tests for User Story 1

- [x] T007 [P] [US1] Add a disposable fixture that removes `.highway/library/templates/output/request-record.md` citation and assert `.highway/tools/tests/highway-new.test.sh` fails for that defect
- [x] T008 [P] [US1] Add a disposable fixture that reintroduces duplicated Request record headings/fields and assert `.highway/tools/tests/highway-new.test.sh` fails for that defect

### Implementation for User Story 1

- [x] T009 [US1] Refactor the Request record entry in the Outputs section of `.highway/skills/highway-new/SKILL.md` to cite the complete authoritative template without restating its structure
- [x] T010 [US1] Replace duplicated Request record shape checks in the Verification section of `.highway/skills/highway-new/SKILL.md` with Request record template-conformance verification
- [x] T011 [US1] Preserve evidence completeness, privacy filtering, status `proposed`, validation, and no-write behavior in `.highway/skills/highway-new/SKILL.md` while removing only duplicated record structure
- [x] T012 [US1] Run `.highway/tools/validate-skill.sh .highway/skills/highway-new` and the focused User Story 1 probes in `.highway/tools/tests/highway-new.test.sh`

**Checkpoint**: User Story 1 independently delegates Request record shape to the shared template and passes its focused validation.

## Phase 4: User Story 2 - Delegate Request Catalog Structure (Priority: P1)

**Goal**: Make the Request catalog template the sole catalog-structure authority while preserving allocation, retry, transaction, and write-sequencing behavior.

**Independent Test**: A focused source check accepts the complete Request catalog citation and rejects missing citation or duplicated catalog shape in disposable fixtures; the canonical skill still validates.

### Tests for User Story 2

- [x] T013 [P] [US2] Add a disposable fixture that removes `.highway/library/templates/output/request-catalog.md` citation and assert `.highway/tools/tests/highway-new.test.sh` fails for that defect
- [x] T014 [P] [US2] Add a disposable fixture that reintroduces duplicated catalog Version, Next ID, or index-row shape and assert `.highway/tools/tests/highway-new.test.sh` fails for that defect

### Implementation for User Story 2

- [x] T015 [US2] Refactor the Request catalog entry in the Outputs section of `.highway/skills/highway-new/SKILL.md` to cite the complete authoritative template without restating its structure
- [x] T016 [US2] Replace duplicated catalog shape checks in the Verification section of `.highway/skills/highway-new/SKILL.md` with Request catalog template-conformance verification
- [x] T017 [US2] Preserve identifier allocation, bounded retries, exactly-once Next ID advancement, transaction ordering, and existing-byte preservation in `.highway/skills/highway-new/SKILL.md`
- [x] T018 [US2] Run `.highway/tools/validate-skill.sh .highway/skills/highway-new` and the focused User Story 2 probes in `.highway/tools/tests/highway-new.test.sh`

**Checkpoint**: User Story 2 independently delegates Request catalog shape to the shared template and passes its focused validation.

## Phase 5: User Story 3 - Preserve Behavioral Ownership and Prove Compliance (Priority: P2)

**Goal**: Prove that structural delegation preserves all `highway-new` behavior, P9.1 compliance, disposable isolation, and generated correspondence.

**Independent Test**: Focused behavioral and disposable-fixture checks detect removed invariants and stale adapters, while canonical files and user-owned Request data remain byte-for-byte unchanged.

### Tests for User Story 3

- [x] T019 [P] [US3] Add disposable fixtures for removed evidence, privacy, determinism, Solution Constraints, Discovery handoff, transaction, and no-write invariants in `.highway/tools/tests/highway-new.test.sh`
- [x] T020 [P] [US3] Add a disposable stale-adapter fixture and correspondence assertion for generated highway-new adapters in `.highway/tools/tests/highway-new.test.sh`
- [x] T021 [P] [US3] Add canonical and user-owned byte-preservation assertions around all disposable probes in `.highway/tools/tests/highway-new.test.sh`

### Implementation for User Story 3

- [x] T022 [US3] Remove duplicated Solution Constraints ordering and remaining structural wording from `.highway/skills/highway-new/SKILL.md` while retaining accepted value shapes and Discovery handoff boundaries
- [x] T023 [US3] Retain and make independently detectable deterministic title/question/example behavior, privacy replacement handling, empty-array versus `unknown` semantics, and `allowed_solution_classes` validation in `.highway/skills/highway-new/SKILL.md`
- [x] T024 [US3] Retain and make independently detectable transaction failure, allocation conflict retry, incomplete-intake no-write, and architecture/ADR fallback behavior in `.highway/skills/highway-new/SKILL.md`
- [x] T025 [US3] Run focused behavioral, disposable-fixture, no-write, and P9.1 checks in `.highway/tools/tests/highway-new.test.sh`

**Checkpoint**: User Story 3 proves the migration preserves behavioral ownership and isolated contract enforcement.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate derived artifacts and validate the complete repository state.

- [x] T026 [P] Regenerate GitHub Copilot, Claude Code, and Cursor adapters from `.highway/skills/highway-new/SKILL.md` with `.highway/tools/generate-agent-adapters.sh`
- [x] T027 [P] Validate the Request record and catalog templates with `.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md` and `.highway/tools/validate-library.sh .highway/library/templates/output/request-catalog.md`
- [x] T028 Run generated adapter correspondence and distribution checks with `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/distribution-packaging.test.sh`
- [x] T029 Run the complete repository suite with `.highway/tools/tests/run-all.sh` and confirm all applicable checks pass
- [x] T030 Run `git diff --check` and review `git status --short` to confirm no changes under `specs/061-*`, `specs/062-*`, or user-owned Request paths

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No implementation dependency; tasks T002 and T003 can run in parallel after T001.
- **Foundational (Phase 2)**: Depends on T001; T004, T005, and T006 establish the shared inventory before story work.
- **User Story 1 (Phase 3)**: Depends on Phase 2; delivers the MVP independently.
- **User Story 2 (Phase 4)**: Depends on Phase 2 and can run in parallel with User Story 1 when separate ownership is available; shared edits to `.highway/skills/highway-new/SKILL.md` require coordination.
- **User Story 3 (Phase 5)**: Depends on the completed User Story 1 and User Story 2 migrations because it proves the combined behavioral contract.
- **Polish (Phase 6)**: Depends on all desired user stories; regeneration and full-suite checks are final.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on another story after Phase 2; recommended MVP.
- **User Story 2 (P1)**: No dependency on another story after Phase 2; shares the canonical skill file with US1 and therefore requires edit coordination if parallelized.
- **User Story 3 (P2)**: Depends on US1 and US2 because its combined probes verify the final migrated contract.

### Within Each User Story

- Fixture tests must be added before the corresponding implementation edits.
- Canonical skill edits precede validator and focused-test execution.
- Behavioral preservation tasks precede final story validation.
- A story checkpoint must pass before dependent story work begins.

## Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- T004 and T005 can run in parallel because they inspect separate artifact classes.
- T007 and T008 can run in parallel because they add independent disposable defects to the same test surface only if changes are coordinated; otherwise run sequentially.
- T013 and T014 can run in parallel under the same coordination constraint.
- T019, T020, and T021 can run in parallel only when edits to `.highway/tools/tests/highway-new.test.sh` are coordinated.
- T026 and T027 can run in parallel because they operate on separate generator/validator concerns.

## Parallel Example: User Story 1

```text
Task T007: Add the missing record-template-citation fixture in `.highway/tools/tests/highway-new.test.sh`.
Task T008: Add the duplicated-record-structure fixture in `.highway/tools/tests/highway-new.test.sh`.
After both fixtures exist:
Task T009: Refactor the Request record Outputs citation in `.highway/skills/highway-new/SKILL.md`.
Task T010: Replace duplicated Request record verification with template conformance in `.highway/skills/highway-new/SKILL.md`.
Task T011: Review retained intake behavior in the same canonical skill.
Task T012: Run focused validation and the canonical skill validator.
```

## Parallel Example: User Story 2

```text
Task T013: Add the missing catalog-template-citation fixture in `.highway/tools/tests/highway-new.test.sh`.
Task T014: Add the duplicated-catalog-shape fixture in `.highway/tools/tests/highway-new.test.sh`.
After both fixtures exist:
Task T015: Refactor the Request catalog Outputs citation in `.highway/skills/highway-new/SKILL.md`.
Task T016: Replace duplicated catalog verification with template conformance in `.highway/skills/highway-new/SKILL.md`.
Task T017: Review retained allocation and transaction behavior in the same canonical skill.
Task T018: Run focused validation and the canonical skill validator.
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 Setup and Phase 2 Foundational inventory.
2. Complete Phase 3 User Story 1.
3. Stop and validate Request record citation, structure delegation, and retained behavior independently.
4. Proceed to User Story 2 only after the MVP checkpoint passes.

### Incremental Delivery

1. Complete Setup and Foundational inventory.
2. Deliver User Story 1: Request record authority and validation.
3. Deliver User Story 2: Request catalog authority and allocation preservation.
4. Deliver User Story 3: behavioral proof, disposable isolation, and P9.1 compliance.
5. Regenerate adapters and run the full repository validation suite.

### Final Validation

The feature is complete only when the focused `highway-new` checks, both template validators,
adapter correspondence, distribution packaging, full suite, and `git diff --check` pass without
modifying Features 061/062 or user-owned Request data.

## Notes

- `[P]` marks tasks that can proceed in parallel only when edits do not collide.
- `[US1]`, `[US2]`, and `[US3]` map directly to the user stories in `spec.md`.
- No `contracts/` tasks are present because Feature 063 exposes no external interface.
- The resolver's stale Feature 061 target must not be used for task execution.
