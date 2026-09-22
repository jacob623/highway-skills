# Tasks: Clarification Determinism and Lifecycle Contracts

**Input**: Design documents from `/specs/067-clarification-determinism-lifecycle/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/clarification-determinism-contract.md, quickstart.md

## Implementation Strategy

Deliver the deterministic analysis contracts first as the MVP: ambiguity vocabulary and contradiction rule boundaries. Add stable finding identity and status precedence next, then complete catalog bootstrap and Clarification Path behavior. Finish by regenerating derived artifacts and running focused and full validation serially. Tests are included because the specification defines independently testable acceptance scenarios and byte-preserving failure paths.

## Dependencies

- Phase 1 setup precedes all other work.
- Phase 2 foundational contract/test inventory precedes user stories.
- User Story 1 establishes the analysis contract used by User Story 2.
- User Story 2 establishes lifecycle identity and status state used by User Story 3 catalog synchronization.
- User Story 3 depends on the clarification and lifecycle contracts, then completes cross-cutting generated-artifact validation.

## Phase 1: Setup

**Purpose**: Confirm the Feature 067 design surface and existing validation conventions.

- [X] T001 Confirm Feature 067 source, plan, research, data model, contract, quickstart, and checklist paths in `specs/067-clarification-determinism-lifecycle/plan.md`
- [X] T002 [P] Record existing `highway-clarify` profile precedence, finding ordering, privacy, revision, and catalog conventions in `specs/067-clarification-determinism-lifecycle/research.md`
- [X] T003 [P] Confirm Bash 3.2.57 disposable-fixture and static-contract test conventions in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T004 [P] Confirm shared catalog template validation and citation conventions in `.highway/tools/tests/output-template.test.sh`

## Phase 2: Foundational

**Purpose**: Establish the shared contract vocabulary, lifecycle fields, and fixture/test matrix before story implementation.

- [X] T005 Define ambiguity vocabulary, contradiction rule, finding fingerprint, retired identifier, status, catalog row, and bootstrap entities in `specs/067-clarification-determinism-lifecycle/data-model.md`
- [X] T006 [P] Define section placement, required fields, validation rules, and failure guarantees for the new Clarify contracts in `specs/067-clarification-determinism-lifecycle/contracts/clarification-determinism-contract.md`
- [X] T007 [P] Add disposable fixture directories for ambiguity, contradiction, identity, status, bootstrap, path, and failure scenarios under `.highway/tools/tests/fixtures/highway-clarify/`
- [X] T008 Add a Feature 067 validation matrix mapping FR-001 through FR-023 and SC-001 through SC-009 to focused checks in `.highway/tools/tests/highway-clarify.test.sh`

## Phase 3: User Story 1 - Classify Ambiguity and Contradictions Deterministically (Priority: P1) 🎯 MVP

**Goal**: Make ambiguity findings exact and case-insensitive, and ensure contradiction findings originate only from declared rules.

**Independent Test**: Analyze default terms, profile extensions, partial-word and regex-like inputs, and declared contradiction-rule fixtures; confirm allowed matches produce one finding and unsupported inference produces none.

### Tests for User Story 1

- [X] T009 [P] [US1] Add fixtures covering all ten default ambiguity terms with mixed casing and leading/trailing whitespace in `.highway/tools/tests/fixtures/highway-clarify/ambiguity-defaults/`
- [X] T010 [P] [US1] Add fixtures covering partial-word, regular-expression-looking, semantic-similarity, duplicate-extension, and attempted-default-removal cases in `.highway/tools/tests/fixtures/highway-clarify/ambiguity-rejections/`
- [X] T011 [P] [US1] Add fixtures covering append-only Clarification Profile vocabulary extensions in `.highway/tools/tests/fixtures/highway-clarify/ambiguity-profile-extensions/`
- [X] T012 [P] [US1] Add fixtures for contradiction rules with missing fields, false conditions, true conditions, and multiple matching rules in `.highway/tools/tests/fixtures/highway-clarify/contradictions/`
- [X] T013 [US1] Add failing-first assertions for exact ambiguity matching, append-only profile extensions, and one-finding-per-match behavior in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T014 [US1] Add failing-first assertions that contradiction findings require declared rules, both fields, and a true condition, with no inference-based findings, in `.highway/tools/tests/highway-clarify.test.sh`

### Implementation for User Story 1

- [X] T015 [US1] Add the `Ambiguity Vocabulary Contract` immediately after `Inputs`, including the ten defaults and prohibited matching methods, in `.highway/skills/highway-clarify/SKILL.md`
- [X] T016 [US1] Add the `Contradiction Rule Contract` immediately after the ambiguity contract, including all required rule fields and rule-only finding conditions, in `.highway/skills/highway-clarify/SKILL.md`
- [X] T017 [US1] Replace the workflow contradiction wording with the declared-rule-only wording and document trim/case-fold exact matching in `.highway/skills/highway-clarify/SKILL.md`
- [X] T018 [US1] Add ambiguity and contradiction verification/error-path requirements to `.highway/skills/highway-clarify/SKILL.md`
- [X] T019 [US1] Run `.highway/tools/tests/highway-clarify.test.sh` and record the User Story 1 result in `specs/067-clarification-determinism-lifecycle/quickstart.md`

**Checkpoint**: User Story 1 is independently testable when all ambiguity and contradiction fixture assertions pass.

## Phase 4: User Story 2 - Preserve Finding Identity and Unambiguous Status (Priority: P1)

**Goal**: Preserve finding IDs across revisions and apply exactly one deterministic status using the declared precedence.

**Independent Test**: Reorder and remove findings, introduce new fingerprints, repeat identical inputs, and evaluate absent, malformed, complete, and in-progress records; confirm stable IDs, retired-ID protection, and precedence.

### Tests for User Story 2

- [X] T020 [P] [US2] Add fixtures for unchanged fingerprints, reordered findings, removed findings, new fingerprints, and retired sequence identifiers in `.highway/tools/tests/fixtures/highway-clarify/finding-identity/`
- [X] T021 [P] [US2] Add fixtures for absent, malformed, structurally invalid, zero-open-finding, and open-finding records in `.highway/tools/tests/fixtures/highway-clarify/status-precedence/`
- [X] T022 [US2] Add failing-first assertions for fingerprint reuse, order-independent IDs, no renumbering, retired-ID non-reuse, and byte-identical repeated IDs in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T023 [US2] Add failing-first assertions for blocked-over-complete precedence, complete, in-progress, not-started, and exactly-one-status selection in `.highway/tools/tests/highway-clarify.test.sh`

### Implementation for User Story 2

- [X] T024 [US2] Add the `Finding Identity Contract` before `Workflow`, including fingerprint inputs, identifier reuse, sequence allocation, and retired identifiers, in `.highway/skills/highway-clarify/SKILL.md`
- [X] T025 [US2] Extend the clarification record lifecycle fields and finding metadata needed to persist fingerprints and retired identifiers in `.highway/library/templates/output/clarification-record.md`
- [X] T026 [US2] Replace the status derivation rule with the blocked, complete, in-progress, not-started precedence contract in `.highway/skills/highway-clarify/SKILL.md`
- [X] T027 [US2] Add finding identity, retired identifier, status precedence, and deterministic repeated-input checks to the Verification and Error Handling sections in `.highway/skills/highway-clarify/SKILL.md`
- [X] T028 [US2] Run `.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md` and `.highway/tools/tests/highway-clarify.test.sh`, then record User Story 2 results in `specs/067-clarification-determinism-lifecycle/quickstart.md`

**Checkpoint**: User Story 2 is independently testable when identity and status fixture assertions pass without changing command syntax or source artifacts.

## Phase 5: User Story 3 - Bootstrap and Maintain the Clarification Catalog Safely (Priority: P1)

**Goal**: Bootstrap missing catalogs from the authoritative template, validate them exactly like existing catalogs, and expose a deterministic informational Clarification Path.

**Independent Test**: Generate with no catalog, validate the in-memory bootstrap and path, exercise malformed/reference/status/write failures, and compare all pre-operation bytes.

### Tests for User Story 3

- [X] T029 [P] [US3] Add first-catalog and template-bootstrap fixtures under `.highway/tools/tests/fixtures/highway-clarify/catalog-bootstrap/`
- [X] T030 [P] [US3] Add malformed, duplicate, unsupported-value, missing-reference, status-mismatch, and write-failure fixtures under `.highway/tools/tests/fixtures/highway-clarify/catalog-failures/`
- [X] T031 [P] [US3] Add catalog rows with deterministic Clarification Paths and repeated-input expected bytes under `.highway/tools/tests/fixtures/highway-clarify/catalog-paths/`
- [X] T032 [US3] Add failing-first assertions for template-based bootstrap, same-validation behavior, path resolution, catalog status agreement, and byte preservation in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T033 [US3] Add failing-first assertions for the Clarification Path column, required catalog fields, version `1.0.0`, and explanatory note in `.highway/tools/tests/output-template.test.sh`

### Implementation for User Story 3

- [X] T034 [US3] Add the `Clarification Path` column and direct-resolution explanation to `.highway/library/templates/output/clarification-catalog.md` without changing metadata version `1.0.0`
- [X] T035 [US3] Add catalog bootstrap construction, same-path validation, path resolution, status agreement, and no-write failure handling to the Workflow in `.highway/skills/highway-clarify/SKILL.md`
- [X] T036 [US3] Update Clarify Outputs, Verification, and Error Handling to describe bootstrap validation, Clarification Path ownership, and byte preservation in `.highway/skills/highway-clarify/SKILL.md`
- [X] T037 [US3] Advance `highway-clarify` metadata from `1.2.0` to `1.3.0` in `.highway/skills/highway-clarify/SKILL.md`
- [X] T038 [US3] Run `.highway/tools/tests/highway-clarify.test.sh`, `.highway/tools/tests/output-template.test.sh`, and `.highway/tools/validate-library.sh .highway/library/templates/output/clarification-catalog.md`, recording results in `specs/067-clarification-determinism-lifecycle/quickstart.md`

**Checkpoint**: User Story 3 is independently testable when bootstrap, path, validation, and failure-path fixtures pass.

## Phase 6: Generated Artifacts and Cross-Cutting Validation

- [X] T039 Regenerate all derived Clarify adapters with `.highway/tools/generate-agent-adapters.sh`
- [X] T040 Regenerate library and Highway indexes with `.highway/tools/generate-library-catalog.sh` and `.highway/tools/generate-catalog.sh`
- [X] T041 [P] Validate the canonical skill and shared templates with `.highway/tools/validate-skill.sh .highway/skills/highway-clarify` and the applicable `.highway/tools/validate-library.sh` commands
- [X] T042 [P] Validate generated correspondence with `.highway/tools/tests/adapter-coverage.test.sh`
- [X] T043 Run the focused Clarify and output-template tests serially and record observed outcomes in `specs/067-clarification-determinism-lifecycle/quickstart.md`
- [X] T044 Run the complete repository suite exactly once with `perl -e '$SIG{ALRM}=sub { exit 124 }; alarm 200; exec @ARGV' .highway/tools/tests/run-all.sh`, with no concurrent test command

## Phase 7: Polish and Cross-Cutting Concerns

- [X] T045 Confirm Feature 067 does not change command syntax, artifact ownership, supported artifact types, Discovery behavior, ADR behavior, clarification analysis ordering, or scoring in `.highway/skills/highway-clarify/SKILL.md`
- [X] T046 [P] Review all changed skill, template, test, and design-document references for resolvable paths in `specs/067-clarification-determinism-lifecycle/quickstart.md` and `.highway/skills/highway-clarify/SKILL.md`
- [X] T047 [P] Revalidate the Feature 067 requirements checklist against the final design and implementation evidence in `specs/067-clarification-determinism-lifecycle/checklists/requirements.md`
- [X] T048 Record final requirement coverage, test results, generated-artifact status, and any residual full-suite timeout in `specs/067-clarification-determinism-lifecycle/plan.md`

## Dependency Graph

```text
Setup (T001-T004)
  -> Foundational (T005-T008)
    -> US1 ambiguity/contradiction (T009-T019)
      -> US2 identity/status (T020-T028)
        -> US3 catalog/bootstrap/path (T029-T038)
          -> Generated validation (T039-T044)
            -> Polish (T045-T048)
```

User Stories 1 and 2 are both P1, but US2 depends on US1's finding-category and evidence conventions. US3 depends on the lifecycle state established by US2. Within each story, fixture/test tasks precede the corresponding implementation tasks; validation tasks follow implementation.

## Parallel Execution Examples

### Setup and Foundation

```text
T002, T003, and T004 can run in parallel after T001.
T006 and T007 can run in parallel after T005.
```

### User Story 1

```text
T009, T010, T011, and T012 can run in parallel.
T013 and T014 can run in parallel after the fixtures exist.
T015 and T016 can be reviewed in parallel, but both modify the same canonical skill and should be applied serially by one implementer.
```

### User Story 2

```text
T020 and T021 can run in parallel.
T022 and T023 can run in parallel after the fixtures exist.
T024 and T025 can run in parallel because they touch separate canonical files.
```

### User Story 3

```text
T029, T030, and T031 can run in parallel.
T032 and T033 can run in parallel after fixtures exist.
T034 can be implemented in parallel with T035 only if the shared-template citation is revalidated afterward; otherwise apply them serially.
```

## MVP Scope

The MVP is User Story 1: exact ambiguity vocabulary matching, append-only profile extensions, declared-rule-only contradiction findings, and focused verification. User Stories 2 and 3 complete stable identity/status lifecycle behavior and safe catalog bootstrap/path maintenance before the feature is considered complete.

## Task Format Validation

Every task uses the required `- [ ] T###` checklist form, includes a concrete repository-relative file path, and applies `[US1]`, `[US2]`, or `[US3]` only within user-story phases. Parallel tasks use `[P]` only when their files and incomplete-task dependencies permit independent work.
