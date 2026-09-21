# Tasks: Final Shared Output Contract Cleanup

**Input**: Design documents from `specs/064-shared-output-contract-cleanup/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

**Tests**: Included because the feature specification requires focused disposable-fixture, behavior-preservation, correspondence, and full-suite validation.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested independently after foundational inventory work.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the Feature 064 implementation context and validation baseline.

- [X] T001 Confirm Feature 064 source and design paths in `specs/064-shared-output-contract-cleanup/plan.md` and `specs/064-shared-output-contract-cleanup/spec.md`
- [X] T002 [P] Capture baseline hashes/status for `.highway/skills/highway-controls/SKILL.md`, `.highway/skills/highway-discovery/SKILL.md`, the three shared output templates, six generated adapters, and protected/user-owned paths in `.highway/tools/tests/output-template.test.sh`
- [X] T003 [P] Inspect the existing focused test entry points and Bash 3.2 conventions in `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/highway-discovery.test.sh`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the structure-versus-behavior inventory required by all user stories.

**Checkpoint**: The shared-template inventory, duplicated-prose inventory, and disposable fixture strategy are ready; User Stories 1 and 2 can proceed independently.

- [X] T004 Inventory Control catalog identity, version, next-ID, index, and ownership structure in `.highway/library/templates/output/control-catalog.md`
- [X] T005 Inventory Discovery record headings/order and Discovery catalog fields/index structure in `.highway/library/templates/output/discovery-record.md` and `.highway/library/templates/output/discovery-catalog.md`
- [X] T006 Inventory duplicated structural declarations and retained behavioral invariants in `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-discovery/SKILL.md`
- [X] T007 Define independent disposable fixture helpers and canonical/shared-template/user-owned byte-preservation assertions in `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/highway-discovery.test.sh`

## Phase 3: User Story 1 - Delegate Control Catalog Structure (Priority: P1) MVP

Goal: Make the Control catalog template the sole catalog-structure authority while preserving Control derivation, allocation, versioning, readiness, relationship, and transaction behavior.

**Goal Criteria**: The Control skill cites the complete catalog template, contains no independent complete catalog shape declaration, and retains deterministic catalog behavior.

**Independent Test**: Focused checks accept the complete Control catalog citation and reject missing citation or duplicated catalog shape in disposable fixtures; the canonical Control skill and shared Control catalog template validate successfully, and the catalog determinism wording remains detectable.

### Tests for User Story 1

- [X] T008 [P] [US1] Add a disposable fixture that removes `.highway/library/templates/output/control-catalog.md` citation and assert `.highway/tools/tests/output-template.test.sh` fails for that defect
- [X] T009 [P] [US1] Add a disposable fixture that reintroduces Control catalog version, next-identifier, index, or management-shape declarations and assert `.highway/tools/tests/output-template.test.sh` fails for that defect
- [X] T010 [P] [US1] Add focused assertions for Control catalog derivation, no timestamp, unchanged-baseline determinism, allocation, transaction, and readiness behavior in `.highway/tools/tests/output-template.test.sh`

### Implementation for User Story 1

- [X] T011 [US1] Refactor the Control catalog entry in the Outputs section of `.highway/skills/highway-controls/SKILL.md` to cite `.highway/library/templates/output/control-catalog.md` as the complete authoritative structure
- [X] T012 [US1] Remove duplicated Control catalog listing, version, next-identifier, and management-shape declarations from `.highway/skills/highway-controls/SKILL.md` while retaining catalog derivation and no-timestamp determinism behavior
- [X] T013 [US1] Replace any duplicated Control catalog shape verification in `.highway/skills/highway-controls/SKILL.md` with conformance verification against `.highway/library/templates/output/control-catalog.md`
- [X] T014 [US1] Run `.highway/tools/validate-skill.sh .highway/skills/highway-controls`, `.highway/tools/validate-library.sh .highway/library/templates/output/control-catalog.md`, and the focused User Story 1 checks in `.highway/tools/tests/output-template.test.sh`

**Checkpoint**: User Story 1 independently delegates Control catalog shape to the shared template and passes its focused validation.

## Phase 4: User Story 2 - Delegate Discovery Record and Catalog Structure (Priority: P1)

Goal: Make the Discovery record and catalog templates the sole structural authorities while preserving Discovery analysis, filtering, scoring, recommendation, allocation, determinism, privacy, and ADR handoff behavior.

**Goal Criteria**: The Discovery skill cites both complete templates, contains no independent complete record/catalog layout declaration, and retains all specified analysis and handoff behavior.

**Independent Test**: Focused checks accept both complete Discovery template citations and reject missing citations or reintroduced record/catalog layout declarations in disposable fixtures; the canonical Discovery skill and both shared templates validate successfully, and all named behavioral rules remain detectable.

### Tests for User Story 2

- [X] T015 [P] [US2] Add a disposable fixture that removes `.highway/library/templates/output/discovery-record.md` citation and assert `.highway/tools/tests/highway-discovery.test.sh` fails for that defect
- [X] T016 [P] [US2] Add a disposable fixture that removes `.highway/library/templates/output/discovery-catalog.md` citation and assert `.highway/tools/tests/highway-discovery.test.sh` fails for that defect
- [X] T017 [P] [US2] Add a disposable fixture that reintroduces Objective Relationships, Control Relationships, or NFR Relationships as an independent Inputs structure declaration and assert `.highway/tools/tests/highway-discovery.test.sh` fails for that defect
- [X] T018 [P] [US2] Add a disposable fixture that reintroduces Discovery record section-order or catalog field/index verification and assert `.highway/tools/tests/highway-discovery.test.sh` fails for that defect

### Implementation for User Story 2

- [X] T019 [US2] Add complete `.highway/library/templates/output/discovery-record.md` and `.highway/library/templates/output/discovery-catalog.md` citations to the Inputs and Outputs sections of `.highway/skills/highway-discovery/SKILL.md`
- [X] T020 [US2] Remove the independent Objective Relationships, Control Relationships, and NFR Relationships structure declaration from the Inputs section of `.highway/skills/highway-discovery/SKILL.md`
- [X] T021 [US2] Replace duplicated Discovery record section-order verification in `.highway/skills/highway-discovery/SKILL.md` with conformance verification against `.highway/library/templates/output/discovery-record.md`
- [X] T022 [US2] Replace duplicated Discovery catalog field and index verification in `.highway/skills/highway-discovery/SKILL.md` with conformance verification against `.highway/library/templates/output/discovery-catalog.md`
- [X] T023 [US2] Preserve candidate generation, constraint evaluation, elimination ordering, scoring, ranking, recommendation, traceability extraction, Reference Architecture matching, and Reference Implementation tie-break behavior in `.highway/skills/highway-discovery/SKILL.md`
- [X] T024 [US2] Preserve advisory Recommendation semantics, no implementation authorization, no governance mutation, no ADR decision, allocation, validation, determinism, privacy, and no-write failure behavior in `.highway/skills/highway-discovery/SKILL.md`
- [X] T025 [US2] Run `.highway/tools/validate-skill.sh .highway/skills/highway-discovery`, validate both Discovery templates with `.highway/tools/validate-library.sh`, and run `.highway/tools/tests/highway-discovery.test.sh`

**Checkpoint**: User Story 2 independently delegates Discovery record/catalog shape to shared templates and passes its focused validation.

## Phase 5: User Story 3 - Prove Final Migration Integrity (Priority: P2)

Goal: Prove that both migrations preserve behavioral ownership, P9.1 compliance, disposable isolation, and generated correspondence.

**Goal Criteria**: Focused probes independently reject each seeded structural or behavioral defect, regenerated adapters correspond to canonical skills, and protected/user-owned bytes remain unchanged.

**Independent Test**: Focused structural and behavioral probes detect missing citations, duplicated structure, removed behavior, stale adapters, and residue while canonical files, shared templates, generated artifacts, user-owned Control/Discovery outputs, and protected Request paths remain byte-for-byte unchanged.

### Tests for User Story 3

- [X] T026 [P] [US3] Add independent disposable fixtures for removed Control allocation, versioning, transaction, readiness, relationship, and NFR proposal invariants in `.highway/tools/tests/output-template.test.sh`
- [X] T027 [P] [US3] Add independent disposable fixtures for removed Discovery filtering, scoring, recommendation, traceability, determinism, privacy, no-write, and ADR-boundary invariants in `.highway/tools/tests/highway-discovery.test.sh`
- [X] T028 [P] [US3] Add stale-adapter fixtures and canonical-to-adapter correspondence assertions for Control and Discovery adapters in `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/highway-discovery.test.sh`
- [X] T029 [P] [US3] Add before/after byte-preservation assertions covering canonical skills, shared templates, generated artifacts, user-owned Control/Discovery outputs, and protected Request paths in `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/highway-discovery.test.sh`

### Implementation for User Story 3

- [X] T030 [US3] Make the focused tests independently reject missing citations and reintroduced structural duplication for both affected skills without mutating canonical or user-owned files in `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/highway-discovery.test.sh`
- [X] T031 [US3] Make the focused tests independently reject removed behavioral rules for both affected skills while accepting the retained migrated contracts in `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/highway-discovery.test.sh`
- [X] T032 [US3] Run the combined focused validation surfaces and confirm disposable fixtures are cleaned up with no residue using `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/highway-discovery.test.sh`

**Checkpoint**: User Story 3 proves the final migration preserves behavioral ownership and isolated contract enforcement.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate derived artifacts and validate the complete repository state.

- [X] T033 [P] Regenerate GitHub Copilot, Claude Code, and Cursor adapters for both changed skills from `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-discovery/SKILL.md` with `.highway/tools/generate-agent-adapters.sh`
- [X] T034 [P] Validate all three shared templates with `.highway/tools/validate-library.sh` and both canonical skills with `.highway/tools/validate-skill.sh`
- [X] T035 Run generated adapter correspondence and distribution checks with `.highway/tools/tests/adapter-coverage.test.sh` and `.highway/tools/tests/distribution-packaging.test.sh`
- [X] T036 Run the complete repository validation suite with `.highway/tools/tests/run-all.sh` and confirm all applicable checks pass
- [X] T037 Run `git diff --check` and inspect `git status --short` to confirm no changes under `specs/061-*`, `specs/062-*`, protected Request paths, or user-owned Control/Discovery outputs
- [X] T038 Run every validation command in `specs/064-shared-output-contract-cleanup/quickstart.md` and record the expected completion evidence

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No implementation dependency; T002 and T003 can run in parallel after T001.
- **Foundational (Phase 2)**: Depends on T001; T004-T007 establish the shared inventory and fixture strategy before story work.
- **User Story 1 (Phase 3)**: Depends on Phase 2; delivers the Control catalog migration MVP slice.
- **User Story 2 (Phase 4)**: Depends on Phase 2 and can run in parallel with User Story 1 when separate ownership is available; its canonical skill and test files require coordination if edited concurrently.
- **User Story 3 (Phase 5)**: Depends on completed User Stories 1 and 2 because it proves the combined migrated contract.
- **Polish (Phase 6)**: Depends on all desired user stories; regeneration and full-suite checks are final.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on another story after Phase 2; recommended MVP.
- **User Story 2 (P1)**: No dependency on another story after Phase 2; shares focused validation conventions but is independently testable.
- **User Story 3 (P2)**: Depends on User Stories 1 and 2 because its probes verify the final combined state.

### Within Each User Story

- Disposable fixture tests must be added before the corresponding implementation edits.
- Canonical skill edits precede validator and focused-test execution.
- Behavioral preservation tasks precede final story validation.
- A story checkpoint must pass before dependent story work begins.

## Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- T004 and T005 can run in parallel because they inspect separate template classes.
- T008-T010 can run in parallel only with coordinated edits to `.highway/tools/tests/output-template.test.sh`.
- T015-T018 can run in parallel only with coordinated edits to `.highway/tools/tests/highway-discovery.test.sh`.
- T026-T029 can run in parallel only when edits to the two focused test files are coordinated.
- T033 and T034 can run in parallel because regeneration and validation operate on separate concerns.

## Parallel Example: User Story 1

```text
Task T008: Add the missing Control catalog citation fixture in `.highway/tools/tests/output-template.test.sh`.
Task T009: Add the duplicated Control catalog shape fixture in `.highway/tools/tests/output-template.test.sh`.
Task T010: Add retained Control behavior assertions in `.highway/tools/tests/output-template.test.sh`.
After the fixtures and assertions exist:
Task T011: Refactor the Control catalog Outputs citation in `.highway/skills/highway-controls/SKILL.md`.
Task T012: Remove duplicated Control catalog shape wording while preserving behavior.
Task T013: Replace duplicated Control catalog verification with template conformance.
Task T014: Run focused validation and both canonical validators.
```

## Parallel Example: User Story 2

```text
Task T015: Add the missing Discovery record citation fixture in `.highway/tools/tests/highway-discovery.test.sh`.
Task T016: Add the missing Discovery catalog citation fixture in `.highway/tools/tests/highway-discovery.test.sh`.
Task T017: Add the duplicated relationship-structure fixture in `.highway/tools/tests/highway-discovery.test.sh`.
Task T018: Add the duplicated record/catalog verification fixture in `.highway/tools/tests/highway-discovery.test.sh`.
After the fixtures exist:
Task T019: Add complete Discovery template citations in `.highway/skills/highway-discovery/SKILL.md`.
Task T020: Remove the independent relationship-section declaration.
Task T021: Replace record verification with template conformance.
Task T022: Replace catalog verification with template conformance.
Task T023-T024: Review retained behavior and boundaries.
Task T025: Run focused validation and canonical/template validators.
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 Setup and Phase 2 Foundational inventory.
2. Complete Phase 3 User Story 1.
3. Stop and validate Control catalog authority, determinism, and retained behavior independently.
4. Proceed to User Story 2 only after the MVP checkpoint passes.

### Incremental Delivery

1. Complete Setup and Foundational inventory.
2. Deliver User Story 1: Control catalog authority and behavior preservation.
3. Deliver User Story 2: Discovery record/catalog authority and behavior preservation.
4. Deliver User Story 3: combined disposable isolation, behavioral proof, and P9.1 integrity.
5. Regenerate adapters and run the full repository validation suite.

### Final Validation

The feature is complete only when both focused contract surfaces, all three template validators,
adapter correspondence, distribution packaging, the complete suite, quickstart commands, and
`git diff --check` pass without modifying Features 061/062 or user-owned outputs.

## Notes

- `[P]` marks tasks that can proceed in parallel only when edits do not collide.
- `[US1]`, `[US2]`, and `[US3]` map directly to the user stories in `spec.md`.
- No `contracts/` tasks are present because Feature 064 exposes no external interface.
- The task-generation setup resolver was run once; task paths are grounded in the active Feature 064 directory and plan structure.
