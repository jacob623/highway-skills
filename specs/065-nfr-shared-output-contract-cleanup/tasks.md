# Tasks: highway-nfrs Shared Output Contract Final Cleanup

**Input**: Design documents from `specs/065-nfr-shared-output-contract-cleanup/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Included because the feature specification requires disposable-fixture, behavior-preservation, adapter-correspondence, byte-preservation, and full-suite validation.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the Feature 065 implementation context and validation baseline.

- [X] T001 Confirm Feature 065 source and design paths in `specs/065-nfr-shared-output-contract-cleanup/plan.md` and `specs/065-nfr-shared-output-contract-cleanup/spec.md`
- [X] T002 [P] Capture baseline hashes/status for `.highway/skills/highway-nfrs/SKILL.md`, the two NFR output templates, three generated NFR adapters, protected Request paths, and user-owned NFR paths in `.highway/tools/tests/output-template.test.sh`
- [X] T003 [P] Inspect existing NFR contract, output-template, adapter, distribution, and Bash 3.2 validation conventions in `.highway/tools/tests/nfr-management.test.sh` and `.highway/tools/tests/output-template.test.sh`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the structure-versus-behavior inventory and disposable fixture strategy required by all user stories.

**Checkpoint**: The NFR record/catalog structural inventory, retained behavior inventory, and isolated fixture strategy are ready before skill edits begin.

- [X] T004 Inventory NFR record frontmatter/body/relationship structure in `.highway/library/templates/output/nfr-record.md`
- [X] T005 Inventory NFR catalog identity/version/next-ID/index structure in `.highway/library/templates/output/nfr-catalog.md`
- [X] T006 Inventory duplicated structural declarations and retained behavioral invariants in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T007 Define disposable fixture helpers and canonical/template/generated/user-owned byte-preservation assertions in `.highway/tools/tests/nfr-management.test.sh` and `.highway/tools/tests/output-template.test.sh`

## Phase 3: User Story 1 - Delegate NFR Record Structure (Priority: P1) MVP

**Goal**: Make `nfr-record.md` the sole structural authority for retained NFR records while preserving record workflow behavior.

**Independent Test**: Focused checks reject a missing record-template citation and restored record-shape declarations, while the canonical skill and record template validate and retained workflow behavior remains detectable.

### Tests for User Story 1

- [X] T008 [P] [US1] Add a disposable fixture removing `.highway/library/templates/output/nfr-record.md` citation and assert `.highway/tools/tests/nfr-management.test.sh` rejects it
- [X] T009 [P] [US1] Add a disposable fixture restoring NFR record field/body/relationship declarations and assert `.highway/tools/tests/nfr-management.test.sh` rejects it
- [X] T010 [P] [US1] Add focused assertions for NFR record path ownership, no-version behavior, controls relationship boundaries, validation, and no-write failure behavior in `.highway/tools/tests/nfr-management.test.sh`

### Implementation for User Story 1

- [X] T011 [US1] Add the complete `.highway/library/templates/output/nfr-record.md` citation to the Outputs section of `.highway/skills/highway-nfrs/SKILL.md`
- [X] T012 [US1] Remove duplicated NFR record frontmatter, field, body, relationship, and ordering declarations from `.highway/skills/highway-nfrs/SKILL.md`
- [X] T013 [US1] Replace duplicated NFR record verification bullets with template-conformance verification against `.highway/library/templates/output/nfr-record.md` in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T014 [US1] Run `.highway/tools/validate-skill.sh .highway/skills/highway-nfrs`, `.highway/tools/validate-library.sh .highway/library/templates/output/nfr-record.md`, and `.highway/tools/tests/nfr-management.test.sh`

**Checkpoint**: User Story 1 independently delegates NFR record structure and passes focused validation.

## Phase 4: User Story 2 - Delegate NFR Catalog Structure (Priority: P1)

**Goal**: Make `nfr-catalog.md` the sole structural authority for retained NFR catalogs while preserving deterministic allocation and regeneration behavior.

**Independent Test**: Focused checks reject a missing catalog-template citation and restored catalog-shape declarations, while no-timestamp and unchanged-baseline behavior remain detectable.

### Tests for User Story 2

- [X] T015 [P] [US2] Add a disposable fixture removing `.highway/library/templates/output/nfr-catalog.md` citation and assert `.highway/tools/tests/output-template.test.sh` rejects it
- [X] T016 [P] [US2] Add a disposable fixture restoring NFR catalog contents, version, `next_id`, index, or management-shape declarations and assert `.highway/tools/tests/output-template.test.sh` rejects it
- [X] T017 [P] [US2] Add focused assertions for catalog derivation, no timestamp, recorded next-ID allocation, unchanged-baseline determinism, and version behavior in `.highway/tools/tests/output-template.test.sh`

### Implementation for User Story 2

- [X] T018 [US2] Add the complete `.highway/library/templates/output/nfr-catalog.md` citation to the Outputs section of `.highway/skills/highway-nfrs/SKILL.md`
- [X] T019 [US2] Replace the duplicated generated catalog contents prose with catalog-path and shared-template authority wording in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T020 [US2] Preserve the behavioral `The catalog contains no timestamp` statement in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T021 [US2] Replace duplicated catalog field, next-ID, index, and ordering verification with template-conformance verification against `.highway/library/templates/output/nfr-catalog.md` in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T022 [US2] Run `.highway/tools/validate-skill.sh .highway/skills/highway-nfrs`, `.highway/tools/validate-library.sh .highway/library/templates/output/nfr-catalog.md`, and `.highway/tools/tests/output-template.test.sh`

**Checkpoint**: User Story 2 independently delegates NFR catalog structure and passes focused validation.

## Phase 5: User Story 3 - Prove NFR Behavioral and Distribution Integrity (Priority: P2)

**Goal**: Prove that the final migration preserves NFR behavior, generated correspondence, and protected/user-owned bytes.

**Independent Test**: Combined focused probes reject missing citations, restored structure, removed behavioral rules, stale adapters, and residue; adapters regenerate correctly; and the full validation suite passes.

### Tests for User Story 3

- [X] T023 [P] [US3] Add independent disposable fixtures for removed NFR classification, Control routing, outcome routing, allocation, permanent identifier, and no-reuse invariants in `.highway/tools/tests/nfr-management.test.sh`
- [X] T024 [P] [US3] Add independent disposable fixtures for removed NFR versioning, destructive-action confirmation, relationship-impact, transaction, determinism, validation, and no-write invariants in `.highway/tools/tests/nfr-management.test.sh`
- [X] T025 [P] [US3] Add stale-adapter fixtures and canonical-to-adapter correspondence assertions for `.github/skills/highway-nfrs/SKILL.md`, `.claude/skills/highway-nfrs/SKILL.md`, and `.cursor/rules/highway-nfrs.mdc` in `.highway/tools/tests/output-template.test.sh`
- [X] T026 [P] [US3] Add before/after byte-preservation assertions for the canonical NFR skill, shared templates, generated adapters, protected Request paths, and user-owned NFR records/catalogs in `.highway/tools/tests/nfr-management.test.sh` and `.highway/tools/tests/output-template.test.sh`

### Implementation for User Story 3

- [X] T027 [US3] Make focused tests independently reject missing NFR template citations and restored record/catalog structural duplication without mutating canonical or user-owned files in `.highway/tools/tests/nfr-management.test.sh` and `.highway/tools/tests/output-template.test.sh`
- [X] T028 [US3] Make focused tests independently reject removed NFR workflow behavior while accepting the retained migrated contracts in `.highway/tools/tests/nfr-management.test.sh`
- [X] T029 [US3] Run the combined focused NFR validation surfaces and confirm disposable fixtures are cleaned up with no residue in `.highway/tools/tests/nfr-management.test.sh` and `.highway/tools/tests/output-template.test.sh`

**Checkpoint**: User Story 3 proves the final NFR migration preserves behavioral ownership, generated correspondence, and isolated contract enforcement.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate derived artifacts and validate the complete repository state.

- [X] T030 [P] Regenerate GitHub Copilot, Claude Code, and Cursor adapters for `highway-nfrs` from `.highway/skills/highway-nfrs/SKILL.md` with `.highway/tools/generate-agent-adapters.sh`
- [X] T031 [P] Validate `.highway/library/templates/output/nfr-record.md`, `.highway/library/templates/output/nfr-catalog.md`, and `.highway/skills/highway-nfrs` with the existing library and skill validators
- [X] T032 Run generated adapter correspondence and distribution checks with `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/distribution-packaging.test.sh`
- [X] T033 Run every validation command in `specs/065-nfr-shared-output-contract-cleanup/quickstart.md` and record the expected completion evidence
- [X] T034 Run `.highway/tools/tests/run-all.sh` with a 300-second allowance and confirm all applicable checks pass
- [X] T035 Run `git diff --check` and inspect `git status --short` to confirm no changes under `specs/061-*`, `specs/062-*`, protected Request paths, or user-owned NFR records/catalogs

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T002 and T003 can run in parallel after T001.
- **Foundational (Phase 2)**: Depends on Phase 1; T004-T007 establish the shared inventory and fixture strategy before user stories.
- **User Story 1 (P1)**: Depends on Phase 2 and can proceed independently.
- **User Story 2 (P1)**: Depends on Phase 2 and can proceed independently of User Story 1, with coordinated edits if both touch the same skill/test files.
- **User Story 3 (P2)**: Depends on User Stories 1 and 2 because it proves the combined migrated contract.
- **Polish (Final Phase)**: Depends on all user stories and runs regeneration before final correspondence and suite checks.

### User Story Dependencies

- **User Story 1**: No dependency on another story after Phase 2; recommended MVP.
- **User Story 2**: No dependency on another story after Phase 2; independently validates catalog authority.
- **User Story 3**: Depends on completed User Stories 1 and 2; validates their combined behavior and generated outputs.

### Within Each User Story

- Disposable failure probes precede canonical skill edits.
- Canonical skill edits precede validator and focused-test execution.
- Behavioral preservation assertions precede final story validation.
- Adapter regeneration follows canonical edits and precedes correspondence checks.

## Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- T004 and T005 can run in parallel because they inspect separate shared templates.
- T008-T010 can run in parallel only with coordinated edits to `.highway/tools/tests/nfr-management.test.sh`.
- T015-T017 can run in parallel only with coordinated edits to `.highway/tools/tests/output-template.test.sh`.
- T023-T026 can run in parallel when edits are coordinated across the two focused test files.
- T030 and T031 can run in parallel because regeneration and validation operate on separate concerns.

## Parallel Example: User Story 1

```text
Task: Add the missing NFR record citation fixture in .highway/tools/tests/nfr-management.test.sh
Task: Add the restored NFR record structure fixture in .highway/tools/tests/nfr-management.test.sh
Task: Add retained NFR record behavior assertions in .highway/tools/tests/nfr-management.test.sh
```

## Parallel Example: User Story 2

```text
Task: Add the missing NFR catalog citation fixture in .highway/tools/tests/output-template.test.sh
Task: Add the restored NFR catalog structure fixture in .highway/tools/tests/output-template.test.sh
Task: Add retained NFR catalog behavior assertions in .highway/tools/tests/output-template.test.sh
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Complete User Story 1: NFR record template authority.
3. Stop and validate the record migration independently.
4. Proceed to User Story 2 after the MVP checkpoint passes.

### Incremental Delivery

1. Complete Setup and Foundational phases.
2. Deliver User Story 1 and validate record structure/behavior independently.
3. Deliver User Story 2 and validate catalog structure/determinism independently.
4. Deliver User Story 3 and validate combined behavior, adapters, isolation, and residue cleanup.
5. Regenerate adapters and run the complete quickstart and repository validation suite.

### Final Validation

The feature is complete only when both focused NFR contract surfaces, both template validators,
adapter correspondence, distribution packaging, the complete suite, quickstart commands, and
`git diff --check` pass without modifying Features 061/062, protected Request paths, or user-owned
NFR records/catalogs.

## Notes

- `[P]` marks tasks that can run in parallel when they touch independent files or coordinated regions.
- Story labels map tasks directly to the feature's user stories.
- No `contracts/` tasks are present because Feature 065 exposes no external interface.
- No extension hooks were registered because `.specify/extensions.yml` is absent.
