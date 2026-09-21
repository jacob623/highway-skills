---

description: "Implementation tasks for Highway Clarify Contract Hardening"
---

# Tasks: Highway Clarify Contract Hardening

**Input**: Design documents from `specs/059-highway-clarify-contract-hardening/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/clarification-hardening-contract.md`, `quickstart.md`

**Organization**: Tasks are grouped by the three P1 user stories. The canonical skill and shared template remain the source of truth; generated adapters and catalogs are refreshed only after canonical changes are complete.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the Feature 059 implementation and validation surface.

- [X] T001 [SETUP] Confirm the Feature 059 source and generated-artifact paths in `specs/059-highway-clarify-contract-hardening/plan.md`
- [X] T002 [P] [SETUP] Add Feature 059 contract scenario names and artifact classes to `.highway/tools/tests/highway-clarify.test.sh`
- [X] T003 [P] [SETUP] Add the stable identifier, consumer-field, profile, regeneration, ordering, privacy, status, revision, and template contract references to `specs/059-highway-clarify-contract-hardening/contracts/clarification-hardening-contract.md`

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define shared invariants before story-specific behavior is updated.

- [X] T004 [FOUNDATIONAL] Establish the canonical `CLAR-<ARTIFACT-ID>` identity, supported identifier validation, and source-immutability invariants in `.highway/skills/highway-clarify/SKILL.md`
- [X] T005 [FOUNDATIONAL] Define the stable response field schema and data types for all command outcomes in `.highway/skills/highway-clarify/SKILL.md`
- [X] T006 [FOUNDATIONAL] Define canonical status values, blocked-state reasons, revision semantics, and no-write conflict behavior in `.highway/skills/highway-clarify/SKILL.md`
- [X] T007 [FOUNDATIONAL] Define deterministic serialization requirements and the category/source/field/finding ordering key in `.highway/skills/highway-clarify/SKILL.md`
- [X] T008 [FOUNDATIONAL] Define privacy filtering boundaries, redaction markers, and pre-retention ordering in `.highway/skills/highway-clarify/SKILL.md`
- [X] T009 [FOUNDATIONAL] Define the authoritative frontmatter and required body structure in `.highway/library/templates/output/clarification-record.md`
- [X] T010 [P] [FOUNDATIONAL] Add the Feature 059 requirement-to-test mapping and expected outcomes to `.highway/tools/tests/highway-clarify.test.sh`

**Checkpoint**: Shared identity, response, status, revision, determinism, privacy, and template invariants are specified before user-story implementation.

## Phase 3: User Story 1 - Consume stable clarification metadata and responses (Priority: P1) - MVP

**Goal**: Make every supported command expose stable identifiers, consumer fields, statuses, revisions, and deterministic conflict responses.

### Independent Test

Run `.highway/tools/tests/highway-clarify.test.sh` against Generate, Update, Inspect, Read, Status, absent, malformed, blocked, and stale-revision cases; verify all eight consumer fields, exact conflict fields, no-write behavior, and stable `CLAR-<ARTIFACT-ID>` identity.

### Tests for User Story 1

- [X] T011 [US1] Add assertions for the exact metadata description and Generate/Update/Inspect/Read/Status usage forms in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T012 [P] [US1] Add stable identifier and eight-field response assertions for REQ, DISC, ADR, and RA fixtures in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T013 [P] [US1] Add not-started, complete, in-progress, and blocked status assertions in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T014 [US1] Add stale revision conflict assertions for action, artifact identifier, status, expected revision, actual revision, message, path, and unchanged bytes in `.highway/tools/tests/highway-clarify.test.sh`

### Implementation for User Story 1

- [X] T015 [US1] Update metadata, usage, command contract, stable response fields, and status derivation in `.highway/skills/highway-clarify/SKILL.md`
- [X] T016 [US1] Update revision initialization, successful-update incrementing, conflict response, and no-write rules in `.highway/skills/highway-clarify/SKILL.md`
- [X] T017 [US1] Add identifier, source metadata, status, revision, count, and blocking-reason frontmatter fields to `.highway/library/templates/output/clarification-record.md`
- [X] T018 [US1] Standardize Findings, Resolution History, Source, and Status sections and their field formatting in `.highway/library/templates/output/clarification-record.md`

**Checkpoint**: User Story 1 is independently consumable through all command response forms and its focused contract tests pass.

## Phase 4: User Story 2 - Regenerate clarification records without losing valid state (Priority: P1)

**Goal**: Regenerate current findings while preserving stable unchanged-evidence identities, valid responses, and resolution history.

### Independent Test

Generate a record, resolve a finding, modify the source, regenerate twice, and verify preserved valid state, recalculated findings, source immutability, deterministic ordering, and byte-identical output for identical inputs.

### Tests for User Story 2

- [X] T019 [P] [US2] Add first-generation and repeated-generation fixture assertions for deterministic colocated paths and `CLAR-<ARTIFACT-ID>` identity in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T020 [P] [US2] Add unchanged-evidence response and finding-identifier preservation assertions in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T021 [P] [US2] Add resolution-history retention and stale-response exclusion assertions after source changes in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T022 [US2] Add identical-input finding count, identifiers, ordering, severity, and generated-byte comparison assertions in `.highway/tools/tests/highway-clarify.test.sh`

### Implementation for User Story 2

- [X] T023 [US2] Define regeneration reconciliation rules for current findings, unchanged evidence, valid responses, and historical entries in `.highway/skills/highway-clarify/SKILL.md`
- [X] T024 [US2] Define canonical output section order, line-ending normalization, and volatile-field exclusion in `.highway/skills/highway-clarify/SKILL.md`
- [X] T025 [US2] Add stable finding identity, response state, source evidence reference, and resolution-history fields to `.highway/library/templates/output/clarification-record.md`
- [X] T026 [US2] Add regeneration preservation and deterministic serialization examples to `.highway/library/templates/output/clarification-record.md`

**Checkpoint**: User Story 2 preserves valid state while recalculating current findings and produces deterministic records.

## Phase 5: User Story 3 - Apply explicit profiles, deterministic ordering, and privacy protection (Priority: P1)

**Goal**: Apply profile precedence, extension-only ambiguity vocabulary, total finding ordering, and privacy filtering before retention.

### Independent Test

Exercise artifact-local, artifact-type, global, and absent profiles; generate multi-category findings with ties; inject secrets and regulated personal data into source, responses, history, metadata, and copied evidence; verify deterministic ordering and redacted retained output.

### Tests for User Story 3

- [X] T027 [P] [US3] Add artifact-local, artifact-type, global, and absent-profile precedence fixtures to `.highway/tools/tests/highway-clarify.test.sh`
- [X] T028 [P] [US3] Add default ambiguity vocabulary retention and profile extension-only assertions to `.highway/tools/tests/highway-clarify.test.sh`
- [X] T029 [P] [US3] Add category and within-category source/field/finding ordering assertions to `.highway/tools/tests/highway-clarify.test.sh`
- [X] T030 [US3] Add secret and regulated-PII redaction assertions across findings, responses, history, metadata, and copied evidence in `.highway/tools/tests/highway-clarify.test.sh`

### Implementation for User Story 3

- [X] T031 [US3] Document first-resolvable Clarification Profile discovery and unread-selected-profile behavior in `.highway/skills/highway-clarify/SKILL.md`
- [X] T032 [US3] Document default ambiguity vocabulary preservation and profile extension-only behavior in `.highway/skills/highway-clarify/SKILL.md`
- [X] T033 [US3] Document category and within-category finding ordering and privacy filtering before generation or writes in `.highway/skills/highway-clarify/SKILL.md`
- [X] T034 [US3] Add profile, ordering, and privacy metadata fields to the authoritative frontmatter/body structure in `.highway/library/templates/output/clarification-record.md`
- [X] T035 [US3] Add redaction markers and sanitized evidence/response/history examples to `.highway/library/templates/output/clarification-record.md`

**Checkpoint**: User Story 3 is independently testable for profile selection, vocabulary extension, deterministic ordering, and complete privacy filtering.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Refresh derived artifacts, verify correspondence, and run the complete validation path.

- [X] T036 [P] [POLISH] Regenerate the GitHub, Claude, and Cursor adapters from `.highway/skills/highway-clarify/SKILL.md` using `.highway/tools/generate-agent-adapters.sh`
- [X] T037 [P] [POLISH] Regenerate the skill and library catalogs using `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-library-catalog.sh`
- [X] T038 [POLISH] Run `.highway/tools/validate-skill.sh .highway/skills/highway-clarify` and `.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md`
- [X] T039 [POLISH] Run `.highway/tools/tests/highway-clarify.test.sh` and verify all Feature 059 focused contract assertions pass
- [X] T040 [POLISH] Run `.highway/tools/tests/adapter-coverage.test.sh`, `.highway/tools/tests/generate-catalog.test.sh`, `.highway/tools/tests/generate-library-catalog.test.sh`, and `.highway/tools/tests/distribution-packaging.test.sh`
- [ ] T041 [POLISH] Run `.highway/tools/tests/run-all.sh` and record the completed validation command and result in the implementation completion record
- [X] T042 [P] [POLISH] Run all Feature 059 seeded probes from `specs/059-highway-clarify-contract-hardening/quickstart.md` and remove only their disposable fixture residue
- [X] T043 [POLISH] Review `.highway/skills/highway-clarify/SKILL.md`, `.highway/library/templates/output/clarification-record.md`, generated adapters, and generated catalogs for source immutability, advisory semantics, and no unrelated changes

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T001-T003 may begin in parallel.
- **Foundational (Phase 2)**: Depends on Setup; T004-T010 define shared contracts before story work.
- **User Stories (Phases 3-5)**: Depend on Foundational completion. All three stories are P1 and can proceed in parallel when separate ownership is available, but T015/T016 and T023/T024 and T031-T033 edit the same canonical skill and should be sequenced or coordinated.
- **Polish (Phase 6)**: Depends on all desired story implementation and focused tests; generated outputs must be refreshed after canonical sources stabilize.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Phase 2 only; MVP story with no dependency on US2 or US3.
- **User Story 2 (P1)**: Depends on Phase 2 and the stable identity/template invariants from US1; can be tested independently after those invariants exist.
- **User Story 3 (P1)**: Depends on Phase 2 and the finding/template structures from US1; can be tested independently after those structures exist.

### Within Each User Story

- Tests precede implementation tasks for the story.
- Canonical skill and template changes precede generated artifact refresh.
- Focused story validation must pass before cross-cutting regeneration.
- A failed validation or conflict scenario must leave the prior artifact bytes, revision, and history unchanged.

## Parallel Examples

The per-story parallel execution examples below identify independent work and shared-file coordination points.

### User Story 1

```text
T012: Four-family stable identifier and response-field fixtures in .highway/tools/tests/highway-clarify.test.sh
T013: Status fixtures in .highway/tools/tests/highway-clarify.test.sh
```

These are parallel in intent but touch the same test file, so they require coordinated application or sequential commits.

### User Story 2

```text
T019: Initial/repeated generation fixtures in .highway/tools/tests/highway-clarify.test.sh
T020: Unchanged-evidence preservation fixtures in .highway/tools/tests/highway-clarify.test.sh
T021: History and stale-response fixtures in .highway/tools/tests/highway-clarify.test.sh
```

The scenarios can be designed in parallel; because they share one test file, merge them sequentially.

### User Story 3

```text
T027: Profile precedence fixtures in .highway/tools/tests/highway-clarify.test.sh
T028: Ambiguity vocabulary fixtures in .highway/tools/tests/highway-clarify.test.sh
T029: Ordering fixtures in .highway/tools/tests/highway-clarify.test.sh
T030: Privacy fixtures in .highway/tools/tests/highway-clarify.test.sh
```

These scenarios are independently specifiable but should be applied sequentially to the shared Bash harness.

### Cross-Cutting Work

```text
T036: Generate adapters from the canonical skill
T037: Generate catalogs from canonical skill/template inputs
T042: Run independent seeded probes from quickstart.md
```

These tasks can run in parallel only after canonical files and focused tests are stable; T038-T041 remain ordered validation gates.

## MVP Strategy

The implementation strategy below starts with User Story 1 and expands incrementally.

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Implement User Story 1 and run its independent contract checks.
3. Stop at the US1 checkpoint to validate stable consumer compatibility, status behavior, and conflicts.

### Incremental Delivery

1. Deliver stable identifiers, fields, statuses, revisions, and conflict behavior through US1.
2. Add regeneration preservation and deterministic serialization through US2.
3. Add profile precedence, ordering, ambiguity extensions, and privacy through US3.
4. Regenerate adapters/catalogs and run focused, packaging, seeded-probe, and full-suite validation.

### Recommended Ownership

- One owner for `.highway/skills/highway-clarify/SKILL.md` contract changes.
- One owner for `.highway/library/templates/output/clarification-record.md` structure changes.
- One owner for `.highway/tools/tests/highway-clarify.test.sh` fixture and assertion coverage, coordinated because all story tests share the file.

## Notes

- Every task has a checkbox, sequential ID, and an exact file path.
- User-story tasks carry the required `[US1]`, `[US2]`, or `[US3]` label.
- `[P]` is used only for tasks that can be independently prepared or run without incomplete prerequisite work; shared-file tasks are explicitly called out as coordination points.
- Tests are included because Feature 059 explicitly requires verification coverage and defines executable focused validation in `quickstart.md`.
