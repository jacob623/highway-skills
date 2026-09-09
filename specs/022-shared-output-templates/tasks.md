---
description: "Implementation tasks for shared output templates"
---

# Tasks: Shared Output Templates

**Input**: Design documents from `specs/022-shared-output-templates/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, and `quickstart.md`

**Tests**: Required for this feature because the specification defines measurable governance, contract-preservation, correspondence, and drift-validation outcomes.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently after the foundational governance amendments are in place.

## Phase 1: Setup

**Purpose**: Establish the feature's test and template paths without changing existing governance behavior.

- [X] T001 [P] Add the output-template fixture and test path conventions to `.highway/tools/README.md`, preserving the separation from `.highway/library/templates/requirements-inquiry.md`.
- [X] T002 [P] Record the Feature 022 validation commands and expected outputs in `specs/022-shared-output-templates/quickstart.md`.
- [X] T003 Confirm the implementation baseline and affected-file inventory in `specs/022-shared-output-templates/research.md`, including the two source skills, governance documents, generators, catalog, adapters, and manifests.

## Phase 2: Foundational

**Purpose**: Add the governance rules and shared validation primitives that all user stories depend on.

- [X] T004 Add `P9.1` under Principle IX in `.highway/governance/constitution.md`, including its `[auto]` tier, Outputs-section observable, output-template path requirement, version change, and self-application review.
- [X] T005 Add `X1.5` to `.highway/governance/experience-standard.md`, requiring frontmatter on retained file artifacts while excluding transient messages and non-file output, including the version change and self-application review.
- [X] T006 Add `D8.1` to `.specify/memory/constitution.md`, requiring re-validation of every skill citing a changed shared library artifact and checking complete frontmatter and body correspondence, including the version change and self-application review.
- [X] T007 [P] Add the shared output-template path and complete NFR and Control skeleton definitions to `.highway/tools/lib/rule-checks.sh`, without imposing semantic values on user-owned records.
- [X] T008 [P] Add focused governance fixtures and assertions for `P9.1`, `X1.5`, and `D8.1` to `.highway/tools/tests/output-template.test.sh`, ensuring the tests fail for missing citation, missing retained-file frontmatter, and omitted dependent review.

**Checkpoint**: Governance rules and focused checks exist; user-story migrations can proceed without introducing an untested rule path.

## Phase 3: User Story 1 - Author a Consistent File-Emitting Skill (Priority: P1) 🎯 MVP

**Goal**: Make each affected file-emitting skill cite a complete shared template instead of restating its file structure inline.

**Independent Test**: Inspect both affected skills' Outputs sections and cited templates; confirm each template defines frontmatter and body structure and each skill has no duplicate inline structure contract.

### Tests for User Story 1

- [X] T009 [P] [US1] Add a positive test fixture for a skill citing `.highway/library/templates/output/` and a negative fixture for a file-emitting skill with inline frontmatter/body structure in `.highway/tools/tests/fixtures/`.
- [X] T010 [US1] Extend `.highway/tools/tests/output-template.test.sh` to assert that `highway-nfrs` and `highway-controls` cite complete output templates and reject duplicate structure prose before the migration is considered complete.

### Implementation for User Story 1

- [X] T011 [P] [US1] Create the complete NFR output skeleton, preserving existing field order and body sections without prescribing user values, in `.highway/library/templates/output/nfr-record.md`.
- [X] T012 [P] [US1] Create the complete Control output skeleton, preserving existing field order and body sections without prescribing user values, in `.highway/library/templates/output/control-record.md`.
- [X] T013 [US1] Replace the inline NFR frontmatter and body structure contract in the Outputs section of `.highway/skills/highway-nfrs/SKILL.md` with a citation to `.highway/library/templates/output/nfr-record.md`, retaining path and ownership behavior.
- [X] T014 [US1] Replace the inline Control frontmatter and body structure contract in the Outputs section of `.highway/skills/highway-controls/SKILL.md` with a citation to `.highway/library/templates/output/control-record.md`, retaining path and ownership behavior.
- [X] T015 [US1] Validate `.highway/library/templates/output/nfr-record.md`, `.highway/library/templates/output/control-record.md`, `.highway/skills/highway-nfrs`, and `.highway/skills/highway-controls` with the existing library and skill validators, then record the result in `specs/022-shared-output-templates/quickstart.md`.

**Checkpoint**: Both current file-emitting skills use complete shared templates and pass the new authoring rule independently of generated artifacts.

## Phase 4: User Story 2 - Preserve Existing Output Contracts (Priority: P1)

**Goal**: Preserve the NFR and Control fields, ordering, body sections, retained-file behavior, and user-owned semantics through template migration.

**Independent Test**: Compare each pre-migration output declaration with its template and post-migration skill declaration; verify no field or body section was removed, reordered, or given a new semantic value requirement.

### Tests for User Story 2

- [X] T016 [P] [US2] Add NFR and Control contract fixtures containing representative frontmatter and body structures under `.highway/tools/tests/fixtures/nfr/` and `.highway/tools/tests/fixtures/control/`, including retained files with frontmatter and transient messages that are excluded.
- [X] T017 [US2] Add contract-preservation assertions in `.highway/tools/tests/nfr-management.test.sh` and `.highway/tools/tests/library-containment.test.sh` for complete frontmatter, body ordering, retained-file behavior, and unchanged user-owned value semantics.

### Implementation for User Story 2

- [X] T018 [US2] Update `.highway/governance/experience-standard.md` enforcement references and output-shape guidance so `X1.5` is applied to retained artifacts without changing existing `X1.1`, `X1.2`, `X4.1`, or `X6.1` contracts.
- [X] T019 [US2] Update `.highway/skills/highway-nfrs/SKILL.md` to state retained NFR files begin with the cited template's frontmatter while leaving transient messages and user-owned NFR values unconstrained.
- [X] T020 [US2] Update `.highway/skills/highway-controls/SKILL.md` to state retained Control files begin with the cited template's frontmatter while leaving transient messages and user-owned Control values unconstrained.
- [X] T021 [US2] Verify the migrated NFR and Control templates and source skills preserve the baseline contract, and document the comparison result in `specs/022-shared-output-templates/data-model.md`.

**Checkpoint**: Existing NFR and Control output contracts remain intact, and retained file artifacts satisfy the new frontmatter requirement without governing user-owned values.

## Phase 5: User Story 3 - Detect Shared Template Drift (Priority: P2)

**Goal**: Ensure every skill citing a changed shared library artifact is identified and re-validated, with frontmatter or body mismatches reported.

**Independent Test**: Change a shared output template in a controlled fixture, enumerate all citing skills, run dependent validation, and confirm every dependent skill is reviewed and a mismatch is reported rather than silently accepted.

### Tests for User Story 3

- [X] T022 [P] [US3] Add a changed-template fixture and a citing-skill fixture under `.highway/tools/tests/fixtures/` that differ in frontmatter or body structure after the template change.
- [X] T023 [US3] Add a dependent-review regression test to `.highway/tools/tests/output-template.test.sh` that discovers every skill citing the changed template, requires each citation to be reviewed, and fails on an unreported frontmatter or body mismatch.

### Implementation for User Story 3

- [X] T024 [US3] Implement the `D8.1` dependent-review procedure through `.highway/tools/README.md`, `specs/022-shared-output-templates/quickstart.md`, and focused citer/contract tests, keeping semantic output matching agent-checkable rather than registering a false automatic comparison.
- [X] T025 [US3] Document the changed-template review procedure and mismatch-reporting evidence in `.highway/tools/README.md` and `specs/022-shared-output-templates/quickstart.md`.
- [X] T026 [US3] Verify the review path against both `.highway/library/templates/output/nfr-record.md` and `.highway/library/templates/output/control-record.md`, confirming no uncited or unrelated skill is silently omitted.

**Checkpoint**: Shared-template changes produce an explicit dependent review for every citing skill and report complete-structure mismatches.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate derived artifacts, update governance records, and run the complete validation envelope.

- [X] T027 Regenerate the catalog from the updated source skills and templates with `.highway/tools/generate-catalog.sh`, updating `.highway/catalog/index.json`, `.highway/catalog/index.md`, `.highway/catalog/library-index.json`, `.highway/catalog/library-index.md`, and any generator-owned metadata.
- [X] T028 Regenerate all declared agent adapters from the updated source skills with `.highway/tools/generate-agent-adapters.sh`, updating `.github/skills/`, `.claude/skills/`, `.cursor/rules/`, `.mock-agent-4/skills/`, `.highway/tools/.adapter-manifest`, and `.highway/tools/.distribution-manifest` as applicable.
- [X] T029 Bump PATCH versions for `highway-nfrs` and `highway-controls` in their source frontmatter and verify the generated catalog and adapter metadata match in `.highway/skills/highway-nfrs/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, and derived artifacts.
- [X] T030 Update the Feature 022 governance rollout and rule-amendment record in `governance-plan.md`, including `P9.1`, `X1.5`, `D8.1`, pre-enable conformance, and MINOR classification evidence.
- [X] T031 Run `.highway/tools/tests/spec-record.test.sh`, focused Feature 022 tests, `.highway/tools/tests/adapter-coverage.test.sh`, and `.highway/tools/tests/run-all.sh`; record verified outcomes in `specs/022-shared-output-templates/quickstart.md`.
- [X] T032 Review all Feature 022 artifacts for requirement coverage and consistency across `specs/022-shared-output-templates/spec.md`, `plan.md`, `research.md`, `data-model.md`, `quickstart.md`, `coverage.md`, and `tasks.md`, then mark only completed tasks in this file.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No implementation dependency; establishes paths and baseline records.
- **Foundational (Phase 2)**: Depends on Setup and blocks all user-story implementation because the new rules and focused checks must exist first.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the MVP template-citation migration.
- **User Story 2 (Phase 4)**: Depends on User Story 1 because contract preservation validates the templates and migrations created there.
- **User Story 3 (Phase 5)**: Depends on Foundational and the shared templates from User Story 1; it can begin after User Story 1, while its review procedure is independent of catalog regeneration.
- **Polish (Phase 6)**: Depends on User Stories 1-3 so derived artifacts and final governance records reflect the complete implementation.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational only; MVP scope.
- **User Story 2 (P1)**: Depends on User Story 1's templates and skill citations; independently verifies preserved contracts.
- **User Story 3 (P2)**: Depends on User Story 1's shared templates; does not depend on User Story 2's contract fixtures except for final complete-output verification.

### Parallel Opportunities

- T004, T005, and T006 can proceed in parallel because they amend separate governance documents.
- T007 and T008 can proceed in parallel after the rule routing is settled.
- T011 and T012 can proceed in parallel because they create separate templates.
- T013 and T014 can proceed in parallel after the templates exist; they edit separate source skills.
- T016 and T022 can proceed in parallel once the relevant story's baseline structure is known.
- T027 and T028 can proceed in parallel only after all source skills and templates are finalized; both must complete before correspondence validation.

## Parallel Example: User Story 1

```text
Task T011: Create nfr-record.md in .highway/library/templates/output/
Task T012: Create control-record.md in .highway/library/templates/output/

After both templates exist:
Task T013: Migrate highway-nfrs/SKILL.md to cite nfr-record.md
Task T014: Migrate highway-controls/SKILL.md to cite control-record.md
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Complete User Story 1 to create both templates and migrate both skills.
3. Run the independent User Story 1 validation and the existing skill/library validators.
4. Stop for review before adding contract-preservation, drift-review, and generated-artifact work.

### Incremental Delivery

1. Deliver shared templates and citations as the MVP.
2. Verify unchanged NFR and Control contracts.
3. Add dependent-review behavior for future shared-library changes.
4. Regenerate catalog/adapters and run the full suite before enabling the governance amendment.

## Completion Criteria

- Every task follows the required checklist format with a sequential ID and concrete file path.
- Every user story has a goal, independent test, tests, implementation tasks, and checkpoint.
- Every affected skill cites a complete template under `.highway/library/templates/output/`.
- Retained NFR and Control files preserve frontmatter and body structure.
- Shared-template drift identifies and re-validates every citing skill.
- Generated catalog and adapters correspond to updated source skills.
- The full test suite passes before the feature is enabled.
