---
description: "Implementation tasks for Highway Clarify"
---

# Tasks: Highway Clarify

**Input**: Design documents from `/specs/058-highway-clarify/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Organization**: Tasks are grouped by the three P1 user stories so each lifecycle capability can be implemented and validated independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the feature's source and validation surfaces.

- [ ] T001 [P] Create the canonical skill directory and source file at `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T002 [P] Create the shared clarification output template at `.highway/library/templates/output/clarification-record.md`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define the shared artifact, resolution, analysis, and response contracts required by every user story.

- [ ] T003 [P] Define clarification record fields, finding entities, response history, revisions, and status transitions in `specs/058-highway-clarify/data-model.md`.
- [ ] T004 [P] Define Markdown/YAML artifact structure and validation rules in `specs/058-highway-clarify/contracts/clarification-artifact-contract.md`.
- [ ] T005 [P] Define command inputs and Generate, Update, Inspect, Read, and Status response contracts in `specs/058-highway-clarify/contracts/command-response-contract.md`.
- [ ] T006 [P] Define deterministic identifier resolution, category precedence, explicit evidence rules, and revision conflict behavior in `specs/058-highway-clarify/contracts/analysis-rules-contract.md`.
- [ ] T007 Validate the shared template against repository authoring rules with `.highway/tools/validate-library.sh`; validate the canonical skill in the adjacent skill source.
**Checkpoint**: Shared contracts and validation rules are stable; user story work can proceed independently.

---

## Phase 3: User Story 1 - Generate deterministic clarification findings (Priority: P1) MVP

**Goal**: Generate one deterministic, colocated clarification record from a supported source without modifying source bytes.

### Tests for User Story 1
- [ ] T008 [P] [US1] Add static contract assertions for five command forms, supported uppercase identifiers, deterministic resolution, category ordering, and colocated naming in `.highway/tools/tests/highway-clarify.test.sh`.
- [ ] T009 [P] [US1] Add disposable Generate fixtures covering explicit contradiction, declared missing input, unknown markers, ambiguity vocabulary, unresolved assumptions, overlapping evidence, and repeatability in `.highway/tools/tests/highway-clarify.test.sh`.
### Implementation for User Story 1
- [ ] T010 [US1] Implement exact uppercase REQ, DISC, ADR, and RA validation plus declared identifier/catalog/path resolution in `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T011 [US1] Implement colocated `<ARTIFACT-ID>-clarification.md` path derivation and source-byte preservation rules in `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T012 [US1] Implement ordered contradiction, missing-input, unknown-value, ambiguity, and unresolved-assumption analysis with one finding per evidence source in `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T013 [US1] Implement Generate validation, no-partial-write behavior, stable finding identity, and Generate response fields in `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T014 [US1] Validate Generate behavior with `.highway/tools/tests/highway-clarify.test.sh`, then validate the canonical skill source.

**Checkpoint**: Generate independently produces deterministic advisory records and leaves source artifacts byte-for-byte unchanged.

---

## Phase 4: User Story 2 - Resolve findings without losing history (Priority: P1)

**Goal**: Record valid finding responses, preserve all prior findings, append history, and update status through revision-safe optimistic concurrency.

**Independent Test**: Generate a multi-finding record, update responses, verify revision and history, then simulate competing revisions and confirm conflict aborts without partial writes or automatic merging.

### Tests for User Story 2

- [ ] T015 [P] [US2] Add Update fixture assertions for valid responses, unknown findings, invalid responses, preserved findings, status transitions, and source immutability in `.highway/tools/tests/highway-clarify.test.sh`.
- [ ] T016 [P] [US2] Add revision-conflict fixtures proving expected/actual revision reporting, no history append, no partial writes, no automatic merge, and three-conflict retry termination in `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 2

- [ ] T017 [US2] Implement complete clarification record validation and response targeting before staging Update changes in `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T018 [US2] Implement revision read, immediate pre-write revalidation, exact increment, conflict response, and bounded retry rules in `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T019 [US2] Implement response persistence, append-only resolution history, derived status, and no-partial-write failure handling in `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T020 [US2] Validate Update behavior with `.highway/tools/tests/highway-clarify.test.sh`, then validate the shared artifact contract.

**Checkpoint**: Update independently preserves audit history and source ownership while detecting stale revisions deterministically.

---

## Phase 5: User Story 3 - Consume clarification state through stable read-only views (Priority: P1)

**Goal**: Provide Inspect, Read, and Status views for absent, valid, complete, in-progress, and malformed records without writing.

**Independent Test**: Exercise all three read-only commands across absent, valid, resolved, open, zero-finding, and malformed fixtures; verify response fields, blocked reasons, advisory behavior, and unchanged hashes.

### Tests for User Story 3

- [ ] T021 [P] [US3] Add Inspect, Read, and Status fixture assertions for `not-started`, `in-progress`, `complete`, and `blocked` cases in `.highway/tools/tests/highway-clarify.test.sh`.
- [ ] T022 [P] [US3] Add read-only hash checks and downstream advisory-consumption assertions in `.highway/tools/tests/highway-clarify.test.sh`.

### Implementation for User Story 3

- [ ] T023 [US3] Implement status derivation for absent, open, resolved, zero-finding, and malformed clarification records in `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T024 [US3] Implement Inspect fields for status, open findings, resolved findings, total findings, path, and blocking reason in `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T025 [US3] Implement complete validated Read output and lightweight Status output with strict read-only behavior in `.highway/skills/highway-clarify/SKILL.md`.
- [ ] T026 [US3] Validate read-only views with `.highway/tools/tests/highway-clarify.test.sh`, then validate the canonical skill source.

**Checkpoint**: All five commands provide stable contracts, and open findings remain advisory to downstream workflows.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Publish generated artifacts, prove correspondence, and validate the complete feature.

- [ ] T027 [P] Regenerate the skill catalog with `.highway/tools/generate-catalog.sh`.
- [ ] T028 [P] Regenerate GitHub Copilot, Claude Code, and Cursor adapters with `.highway/tools/generate-agent-adapters.sh`.
- [ ] T029 [P] Register all three generated adapter paths for distribution in `.highway/tools/.distribution-manifest`.
- [ ] T030 [P] Make the focused test executable at `.highway/tools/tests/highway-clarify.test.sh` and preserve Bash 3.2 compatibility.
- [ ] T031 Run `.highway/tools/tests/adapter-coverage.test.sh` to verify generated correspondence, including the catalog-generation check.
- [ ] T032 Run seeded source-document, generated-artifact, and disposable-fixture probes for `.highway/tools/tests/highway-clarify.test.sh`, confirming failure before neutralization and success after neutralization.
- [ ] T033 Run `.highway/tools/tests/run-all.sh` and record the results in the feature quickstart.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001-T002 can run in parallel; no prior feature work is required.
- **Foundational (Phase 2)**: T003-T006 can run in parallel after setup; T007 depends on the source/template and contracts.
- **User Stories (Phases 3-5)**: Each depends on T007. US2 uses the record model established by US1, and US3 consumes the artifact/status model established by US1 and US2; their tests remain independently executable with disposable fixtures.
- **Polish (Phase 6)**: T027-T030 can run after source validation; T031-T033 depend on generated outputs and all story implementations.

### User Story Dependencies

- **US1 (P1)**: Depends on Phase 2; MVP story and first independently demonstrable increment.
- **US2 (P1)**: Depends on the clarification record and finding identity from US1; can be tested with generated disposable records.
- **US3 (P1)**: Depends on the record/status contract from US1 and Update state transitions from US2; read-only fixtures can run independently after foundational contracts exist.

### Parallel Opportunities

- T001-T002 and T003-T006 can run in parallel across separate files.
- Within US1, T008-T009 can run in parallel before T010-T013; T010-T012 are separate rule sections but converge in the same skill file, so implementation should be sequenced to avoid edit conflicts.
- Within US2, T015-T016 can run in parallel; implementation tasks T017-T019 should be sequenced because they share the canonical skill file.
- Within US3, T021-T022 can run in parallel; implementation tasks T023-T025 should be sequenced for shared-file consistency.
- T027-T030 can run in parallel only after source and focused-test changes are complete; T031-T033 are sequential validation gates.

### Parallel Example: User Story 1

```text
Task T008: Static contract assertions in .highway/tools/tests/highway-clarify.test.sh
Task T009: Disposable Generate fixtures in .highway/tools/tests/highway-clarify.test.sh
```

### Parallel Example: Cross-Cutting Publication

```text
Task T027: Generate .highway/catalog/index.json and .highway/catalog/index.md
Task T028: Generate .github/skills/highway-clarify/SKILL.md, .claude/skills/highway-clarify/SKILL.md, and .cursor/rules/highway-clarify.mdc
Task T029: Update .highway/tools/.distribution-manifest
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 setup and Phase 2 foundational contracts.
2. Complete Phase 3 Generate behavior and focused validation.
3. Stop and validate deterministic findings, colocated output, category precedence, and source immutability.
4. Publish generated adapters only after the canonical skill passes validation.

### Incremental Delivery

1. Add US1 Generate and validate it independently.
2. Add US2 Update, history, status transitions, and optimistic concurrency; validate without changing US1 source behavior.
3. Add US3 read-only views and advisory downstream contracts.
4. Regenerate catalogs/adapters and run correspondence, packaging, and full-suite checks.

### Completion Criteria

- Every task uses the required `- [ ] T###` checklist form.
- User-story tasks carry exactly one `[US1]`, `[US2]`, or `[US3]` label.
- Parallel tasks are marked `[P]` only when they target independent files or validation surfaces.
- Every implementation and test task names an exact repository path.
- All three P1 stories have an independent test criterion and checkpoint.
