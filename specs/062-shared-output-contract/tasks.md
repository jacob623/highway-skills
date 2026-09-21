# Tasks: Shared Output Contract Implementation

**Input**: Design documents from `/specs/062-shared-output-contract/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Included because the specification explicitly requires focused validation, disposable fixtures, generated correspondence, and full-suite validation.

**Organization**: Tasks are grouped by user story so each increment can be implemented and tested independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the implementation inventory and preserve the current baseline before canonical edits.

- [X] T001 Inventory the five retained record/catalog pairs, current catalog metadata, and emitting skill citations in `.highway/library/templates/output/` and `.highway/skills/`
- [X] T002 [P] Capture the current generated adapters, catalogs, manifests, and user-owned baseline status for comparison in `.github/skills/`, `.claude/skills/`, `.cursor/rules/`, `.highway/catalog/`, and repository status output
- [X] T003 [P] Record the existing output-template validator and focused-test entry points in `.highway/tools/validate-library.sh`, `.highway/tools/validate-skill.sh`, and `.highway/tools/tests/output-template.test.sh`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define the shared structural vocabulary and validation boundaries required by all user stories.

- [X] T004 Define the five retained artifact identities, record/catalog pairing rules, and no-write boundaries in `.highway/tools/tests/output-template.test.sh`
- [X] T005 Define the structural-versus-behavioral assertion categories and required behavior-preservation checks for the five skills in `.highway/tools/tests/output-template.test.sh`
- [X] T006 [P] Define disposable temporary-workspace and independent-invalid-fixture helpers compatible with Bash 3.2 in `.highway/tools/tests/output-template.test.sh`
- [X] T007 [P] Confirm the canonical generation commands and correspondence checks used by the feature in `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/tests/adapter-coverage.test.sh`

**Checkpoint**: Shared artifact inventory, behavior categories, fixture isolation, and generation boundaries are ready for story implementation.

## Phase 3: User Story 1 - Establish Complete Output Contract Coverage (Priority: P1) MVP

**Goal**: Provide authoritative record and catalog templates for Request, Objective, Control, NFR, and Discovery without changing user-owned paths or allocation semantics.

**Independent Test**: Validate all ten templates, confirm each catalog declares identity/version/next identifier/index structure/stable columns, and prove missing-template and incomplete-catalog fixtures fail without modifying canonical files.

### Tests for User Story 1

- [X] T008 [P] [US1] Add inventory assertions for all five authoritative record/catalog template pairs in `.highway/tools/tests/output-template.test.sh`
- [X] T009 [P] [US1] Add catalog identity, version, next-identifier, index-heading, and stable-column assertions in `.highway/tools/tests/output-template.test.sh`
- [X] T010 [P] [US1] Add independent disposable invalid fixtures for a missing catalog template and each incomplete catalog metadata rule in `.highway/tools/tests/output-template.test.sh`
- [X] T011 [US1] Add byte-preservation assertions proving template inventory checks leave canonical templates and user-owned records/catalogs unchanged in `.highway/tools/tests/output-template.test.sh`

### Implementation for User Story 1

- [X] T012 [P] [US1] Create the authoritative Objective catalog template from current catalog behavior in `.highway/library/templates/output/objective-catalog.md`
- [X] T013 [P] [US1] Create the authoritative Control catalog template from current catalog behavior in `.highway/library/templates/output/control-catalog.md`
- [X] T014 [P] [US1] Create the authoritative NFR catalog template from current catalog behavior in `.highway/library/templates/output/nfr-catalog.md`
- [X] T015 [US1] Review and normalize Request catalog structure against the shared catalog contract without changing user-owned semantics in `.highway/library/templates/output/request-catalog.md`
- [X] T016 [US1] Review and normalize Discovery catalog structure against the shared catalog contract without reopening Feature 061 behavior in `.highway/library/templates/output/discovery-catalog.md`
- [X] T017 [US1] Validate all five record/catalog template pairs and their catalog metadata with `.highway/tools/validate-library.sh` and `.highway/tools/tests/output-template.test.sh`

**Checkpoint**: User Story 1 is independently complete when all five pairs are authoritative and focused template checks pass.

## Phase 4: User Story 2 - Migrate Skills to Template-Owned Structure (Priority: P1)

**Goal**: Make each affected skill cite complete record and catalog templates while retaining all workflow and domain behavior.

**Independent Test**: Inspect each skill's Outputs and Verification sections, confirm complete citations, detect no duplicated complete structure, and verify required behavioral rules remain present.

### Tests for User Story 2

- [X] T018 [P] [US2] Add complete record/catalog citation assertions for `highway-new`, `highway-objectives`, `highway-controls`, `highway-nfrs`, and `highway-discovery` in `.highway/tools/tests/output-template.test.sh`
- [X] T019 [P] [US2] Add independent disposable invalid fixtures for missing citations and duplicated structural declarations in `.highway/tools/tests/output-template.test.sh`
- [X] T020 [US2] Add behavioral-preservation assertions for evidence/privacy/allocation/transaction/determinism, readiness/relationships/versioning, and Discovery filtering/scoring/recommendation/traceability rules in `.highway/tools/tests/output-template.test.sh`

### Implementation for User Story 2

- [X] T021 [P] [US2] Replace duplicated Request record/catalog structure prose with complete template citations while retaining behavior in `.highway/skills/highway-new/SKILL.md`
- [X] T022 [P] [US2] Replace duplicated Objective record/catalog structure prose with complete template citations while retaining behavior in `.highway/skills/highway-objectives/SKILL.md`
- [X] T023 [P] [US2] Replace duplicated Control record/catalog structure prose with complete template citations while retaining behavior in `.highway/skills/highway-controls/SKILL.md`
- [X] T024 [P] [US2] Replace duplicated NFR record/catalog structure prose with complete template citations while retaining behavior in `.highway/skills/highway-nfrs/SKILL.md`
- [X] T025 [P] [US2] Replace duplicated Discovery record/catalog structure prose with complete template citations while retaining elimination/filtering/scoring/recommendation/traceability behavior in `.highway/skills/highway-discovery/SKILL.md`
- [X] T026 [US2] Validate the five migrated canonical skills and run focused citation, duplication, and behavior-preservation checks through `.highway/tools/validate-skill.sh` and `.highway/tools/tests/output-template.test.sh`

**Checkpoint**: User Story 2 is independently complete when every affected skill cites complete templates, duplicated structure is absent, and behavior checks pass.

## Phase 5: User Story 3 - Prove Structural Authority and Regeneration (Priority: P2)

**Goal**: Prove disposable defect detection and regenerate all derived adapters/catalogs/manifests from canonical sources.

**Independent Test**: Seed each disposable missing/stale/duplicated defect, confirm the focused check fails and canonical bytes remain unchanged, restore the fixture, regenerate outputs, and pass correspondence plus full-suite validation.

### Tests for User Story 3

- [X] T027 [P] [US3] Add disposable stale-citation and stale-generated-output fixtures with independent failure assertions in `.highway/tools/tests/output-template.test.sh`
- [X] T028 [P] [US3] Add generated adapter/catalog/manifest correspondence assertions for changed canonical skills and templates in `.highway/tools/tests/output-template.test.sh`
- [X] T029 [US3] Add a no-write and restoration check covering all seeded fixtures and generated artifacts in `.highway/tools/tests/output-template.test.sh`

### Implementation for User Story 3

- [X] T030 Regenerate GitHub Copilot, Claude Code, and Cursor adapters from canonical skills with `.highway/tools/generate-agent-adapters.sh`
- [X] T031 Regenerate the skill catalog and library catalog from canonical sources with `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-library-catalog.sh`
- [X] T032 Verify generated adapter correspondence and catalog currency in `.github/skills/`, `.claude/skills/`, `.cursor/rules/`, and `.highway/catalog/` using `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/generate-catalog.test.sh`, and `.highway/tools/tests/generate-library-catalog.test.sh`
- [X] T033 Run distribution/package validation and the complete repository regression suite through `.highway/tools/tests/distribution-packaging.test.sh` and `.highway/tools/tests/run-all.sh`

**Checkpoint**: User Story 3 is independently complete when seeded defects are detected, derived outputs correspond to canonical sources, and the full suite passes.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Close the implementation with traceability, whitespace, and final scope checks.

- [X] T034 [P] Update Feature 062 implementation evidence and completion notes in `specs/062-shared-output-contract/plan.md` and `specs/062-shared-output-contract/quickstart.md`
- [X] T035 Review the final source/generated diff for unchanged user-owned records, catalogs, baselines, relationships, and paths in the repository root
- [X] T036 Run final whitespace and artifact-scope validation with `git diff --check` and confirm no files outside the intended Feature 062 and canonical/generated surfaces changed

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; inventory and baseline capture can begin immediately.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user-story work.
- **User Story 1 (Phase 3)**: Depends on Foundational; MVP and prerequisite for reliable skill citations.
- **User Story 2 (Phase 4)**: Depends on User Story 1 templates; can migrate the five skills in parallel after the template pairs exist.
- **User Story 3 (Phase 5)**: Depends on User Stories 1 and 2; validates and regenerates the complete canonical/derived surface.
- **Polish (Phase 6)**: Depends on all desired user stories and final regeneration.

### User Story Dependencies

- **User Story 1 (P1)**: Depends only on Phase 2; no dependency on other stories.
- **User Story 2 (P1)**: Depends on User Story 1's authoritative record/catalog templates.
- **User Story 3 (P2)**: Depends on User Stories 1 and 2 because correspondence checks require the completed canonical source migration.

### Within Each User Story

- Focused tests and fixture assertions should be added before implementation changes where practical.
- Catalog templates must exist before skills cite them.
- Canonical skill/template changes must be complete before regeneration.
- Regeneration must complete before correspondence and full-suite validation.

## Parallel Execution Examples

### User Story 1

```text
Task T012: Create objective-catalog.md
Task T013: Create control-catalog.md
Task T014: Create nfr-catalog.md

These tasks touch separate catalog template files and can run in parallel after T001-T007.
```

### User Story 2

```text
Task T021: Migrate highway-new/SKILL.md
Task T022: Migrate highway-objectives/SKILL.md
Task T023: Migrate highway-controls/SKILL.md
Task T024: Migrate highway-nfrs/SKILL.md
Task T025: Migrate highway-discovery/SKILL.md

These tasks touch separate canonical skill files and can run in parallel after User Story 1.
```

### User Story 3

```text
Task T027: Add stale/invalid fixture checks
Task T028: Add generated correspondence assertions

These tasks can run in parallel in output-template.test.sh only if coordinated to avoid edit conflicts;
otherwise execute them sequentially in the same test file.
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Create and validate all five authoritative record/catalog template pairs.
3. Run User Story 1's independent inventory, metadata, fixture, and no-write checks.
4. Stop with a complete structural-template MVP before migrating skill prose.

### Incremental Delivery

1. Add User Story 1 template coverage and validate independently.
2. Add User Story 2 skill citations and behavior-preservation checks.
3. Add User Story 3 fixture proof, regenerate derived outputs, and run the full suite.
4. Complete final scope and whitespace checks.

## Notes

- Every task uses the required `- [ ] T###` checklist form.
- `[P]` marks only tasks that can operate on separate files or independent validation concerns.
- `[US1]`, `[US2]`, and `[US3]` map directly to the three stories in `spec.md`.
- No external `contracts/` directory exists because this feature introduces no public API or integration interface.
- User-owned records and catalogs are read-only validation subjects and must not be rewritten.
