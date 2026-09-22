---

description: "Implementation tasks for clarification state and fingerprint normalization"
---

# Tasks: Clarification State and Fingerprint Normalization

**Input**: Design documents from `/specs/068-clarification-state-normalization/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`, and `quickstart.md`

**Tests**: Test tasks are included because the specification defines mandatory independent tests,
acceptance scenarios, measurable outcomes, and a validation baseline.

**Organization**: Tasks are grouped by the three P1 user stories. Each story has an independent test
criterion, with shared canonical files sequenced where they overlap.

## Phase 1: Setup

**Purpose**: Establish the implementation baseline without changing Feature 067 behavior.

- [X] T001 Record the Feature 067 baseline, target versions, and preservation constraints against `.highway/skills/highway-clarify/SKILL.md`, `.highway/library/templates/output/clarification-record.md`, `.highway/library/templates/output/clarification-catalog.md`, and `.highway/tools/tests/`
- [X] T002 [P] Run the existing Clarify skill, template, and adapter-coverage checks from `quickstart.md` and capture the pre-change baseline for `.highway/skills/highway-clarify/SKILL.md` and `.highway/library/templates/output/`

---

## Phase 2: Foundational

**Purpose**: Establish shared contract-test conventions and protect the existing transaction and ownership boundaries before story work begins.

**Checkpoint**: Shared validation surfaces are identified and the Feature 067 baseline is green before user-story changes.

- [X] T003 Add reusable assertion and disposable-fixture coverage conventions for normalization, state, counts, catalog relationships, and byte preservation in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T004 [P] Preserve existing command syntax, supported artifact types, source immutability, and pre-operation byte safety assertions while preparing `.highway/skills/highway-clarify/SKILL.md` and `.highway/tools/tests/highway-clarify.test.sh` for Feature 068 rules

---

## Phase 3: User Story 1 - Normalize Finding Fingerprints Deterministically (Priority: P1) MVP

**Goal**: Make equivalent category, source-field, and evidence inputs converge through one ordered normalization contract before fingerprint generation, while preserving distinctions that remain after normalization.

**Independent Test**: Run `.highway/tools/tests/highway-clarify.test.sh` and confirm CRLF/CR/LF, case, surrounding whitespace, repeated whitespace, and source-field aliases produce identical fingerprints, while materially different normalized inputs remain distinct.

### Tests for User Story 1

- [X] T005 [US1] Add static contract assertions for the ordered LF, trim, lowercase, whitespace-collapse, canonical-source-field, and post-normalization fingerprint rules in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T006 [US1] Add disposable normalization probes covering mixed line endings, whitespace-only values, case differences, repeated whitespace, source-field aliases, equivalent fingerprints, and distinct normalized inputs in `.highway/tools/tests/highway-clarify.test.sh`

### Implementation for User Story 1

- [X] T007 [US1] Add the Fingerprint Normalization Contract and canonical source-field rules inside the Finding Identity Contract in `.highway/skills/highway-clarify/SKILL.md`
- [X] T008 [US1] Extend the Clarify Verification section with normalization-before-generation, equivalence, distinction, and identity-preservation checks in `.highway/skills/highway-clarify/SKILL.md`

**Checkpoint**: User Story 1 is independently verifiable through the focused Clarify test and the canonical skill contract.

---

## Phase 4: User Story 2 - Govern Finding State and Count Integrity (Priority: P1)

**Goal**: Restrict findings to `open` and `resolved`, permit only one-way resolution, retain resolved identity/history/evidence, and reject invalid count relationships as `blocked`.

**Independent Test**: Validate records with new, open, resolved, reopening, unsupported-state, valid-count, invalid-count, negative-count, non-integer-count, and zero-open fixtures; confirm lifecycle and `total_findings = open_findings + resolved_findings` behavior.

### Tests for User Story 2

- [X] T009 [US2] Add static assertions for supported states, new-open behavior, open-to-resolved transition, resolved identity/history retention, rejected reopen, and blocked precedence in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T010 [US2] Add record-template assertions and disposable count/state probes for valid mixed records, invalid totals, negative/non-integer counts, unsupported states, and zero-open blocked records in `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/highway-clarify.test.sh`

### Implementation for User Story 2

- [X] T011 [US2] Add the Finding State Contract after the Finding Identity Contract and document the one-way `open` to `resolved` lifecycle in `.highway/skills/highway-clarify/SKILL.md`
- [X] T012 [US2] Advance the clarification record template metadata to `1.2.0`, document `total_findings = open_findings + resolved_findings`, and replace the single open specimen with one open and one resolved finding in `.highway/library/templates/output/clarification-record.md`
- [X] T013 [US2] Extend Clarify verification and status-precedence language for supported states, retained resolved history, malformed count handling, and `blocked` derivation in `.highway/skills/highway-clarify/SKILL.md`

**Checkpoint**: User Story 2 is independently verifiable through the record/template and Clarify focused probes without changing command syntax or artifact ownership.

---

## Phase 5: User Story 3 - Verify Catalog Consistency and Versioned Schema (Priority: P1)

**Goal**: Keep catalog entries and authoritative clarification artifacts in a one-to-one, status-matching, directly resolvable relationship under the versioned catalog schema.

**Independent Test**: Validate valid, missing, duplicate, extra, stale, status-mismatched, and path-mismatched catalog fixtures; confirm valid entries resolve directly, invalid operations fail before writes, and the catalog reports `1.1.0`.

### Tests for User Story 3

- [X] T014 [US3] Add catalog consistency assertions for existing-artifact resolution, one-to-one rows, status agreement, direct Clarification Paths, bootstrap, maintenance, and byte preservation in `.highway/tools/tests/highway-clarify.test.sh`
- [X] T015 [US3] Add catalog schema assertions for metadata/rendered version `1.1.0`, Clarification Path semantics, and clarification record version `1.2.0` in `.highway/tools/tests/output-template.test.sh`
- [X] T016 [US3] Add disposable catalog fixtures for duplicate rows, missing artifacts, missing rows, stale references, status mismatches, path mismatches, and failed staged writes in `.highway/tools/tests/highway-clarify.test.sh`

### Implementation for User Story 3

- [X] T017 [US3] Advance clarification catalog template metadata and rendered version to `1.1.0` while retaining the informational Clarification Path column in `.highway/library/templates/output/clarification-catalog.md`
- [X] T018 [US3] Add the one-to-one catalog consistency, direct-path, status-agreement, bootstrap/maintenance, and byte-preservation contract rules to `.highway/skills/highway-clarify/SKILL.md`
- [X] T019 [US3] Extend Clarify verification with catalog-entry, artifact, status, path, and pre-operation-byte checks in `.highway/skills/highway-clarify/SKILL.md`

**Checkpoint**: User Story 3 is independently verifiable through catalog/template checks and disposable consistency fixtures.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Update metadata, regenerate derived artifacts, validate correspondence, and run the complete repository checks.

- [X] T020 Update `highway-clarify` metadata to version `1.4.0` and reconcile all Feature 068 citations and version references in `.highway/skills/highway-clarify/SKILL.md`, `.highway/library/templates/output/clarification-record.md`, and `.highway/library/templates/output/clarification-catalog.md`
- [X] T021 Regenerate canonical derived outputs with `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-catalog.sh`, updating `.github/skills/highway-clarify/SKILL.md`, `.claude/skills/highway-clarify/SKILL.md`, `.cursor/rules/highway-clarify.mdc`, `.highway/catalog/`, and `.highway/tools/.adapter-manifest`
- [X] T022 Run `.highway/tools/validate-skill.sh .highway/skills/highway-clarify`, both `.highway/tools/validate-library.sh` commands from `quickstart.md`, `.highway/tools/tests/highway-clarify.test.sh`, `.highway/tools/tests/output-template.test.sh`, and `.highway/tools/tests/adapter-coverage.test.sh` and repair only Feature 068 regressions in the canonical files
- [X] T023 Run the serialized full suite using `perl -e '$SIG{ALRM}=sub { exit 124 }; alarm 200; exec @ARGV' .highway/tools/tests/run-all.sh`, then verify `git diff --check` and the Feature 068 design artifacts under `specs/068-clarification-state-normalization/`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001 and T002 have no implementation dependencies and establish the baseline.
- **Foundational (Phase 2)**: T003 and T004 depend on the baseline and block story work.
- **User Stories (Phases 3-5)**: All depend on Phase 2. The stories are all P1, but shared files require the practical order US1, US2, then US3.
- **Polish (Phase 6)**: Depends on all three stories; regeneration occurs only after canonical sources are complete.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Phase 2 and is the MVP; no dependency on another story's behavior.
- **User Story 2 (P1)**: Depends on Phase 2 and the identity vocabulary established by US1; its state/count rules are independently testable.
- **User Story 3 (P1)**: Depends on Phase 2 and the status/count vocabulary established by US2; its catalog relationship is independently testable.

### Within Each User Story

- Tests are added before the corresponding canonical contract/template changes.
- Contract language is updated before verification assertions are finalized.
- Shared-file tasks are sequenced to avoid conflicting edits.
- Each story must pass its independent test criterion before the next story begins.

### Parallel Opportunities

- T001 and T002 can run in parallel as read-only baseline work.
- T003 and T004 can be split by file only if the existing test-file overlap is coordinated.
- Within US1, static and disposable test additions can be developed in parallel only with coordinated edits to `highway-clarify.test.sh`; otherwise run T005 then T006.
- Within US2, record-template assertions in `output-template.test.sh` can proceed in parallel with Clarify assertions in `highway-clarify.test.sh`.
- Within US3, catalog-template assertions in `output-template.test.sh` can proceed in parallel with disposable consistency fixtures in `highway-clarify.test.sh`.
- T021's three generator commands are serial commands by repository convention, while their generated outputs are independently validated by T022.

## Parallel Example: User Story 1

```text
Task T005: Add normalization contract assertions in .highway/tools/tests/highway-clarify.test.sh
Task T006: Add disposable normalization probes in .highway/tools/tests/highway-clarify.test.sh
Task T007: Add the normalization contract in .highway/skills/highway-clarify/SKILL.md
```

Run T005 and T006 sequentially when editing the same test file; T007 can be reviewed in parallel,
but T008 should follow T007 so verification language matches the canonical contract.

## Parallel Example: User Story 2

```text
Task T009: Add state assertions in .highway/tools/tests/highway-clarify.test.sh
Task T010: Add record/count assertions in .highway/tools/tests/output-template.test.sh
Task T012: Update .highway/library/templates/output/clarification-record.md
```

T009 and T010 touch different test files; T011 and T012 can be prepared concurrently, but T013
must follow the final Clarify contract wording.

## Parallel Example: User Story 3

```text
Task T014: Add catalog consistency probes in .highway/tools/tests/highway-clarify.test.sh
Task T015: Add catalog schema assertions in .highway/tools/tests/output-template.test.sh
Task T017: Update .highway/library/templates/output/clarification-catalog.md
```

T014 and T015 touch different test files; T018 and T019 must be sequenced after the final canonical
skill text is agreed.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 baseline and Phase 2 shared test preparation.
2. Complete User Story 1 normalization tests and Clarify contract updates.
3. Run the independent fingerprint test criterion.
4. Stop for review or proceed incrementally to state/count integrity.

### Incremental Delivery

1. Deliver deterministic normalization and identity preservation as the first P1 increment.
2. Add two-state lifecycle and count invariants, then validate records independently.
3. Add catalog consistency and schema versioning, then validate catalog fixtures independently.
4. Regenerate all derived artifacts only after canonical sources are complete.
5. Run focused validators, adapter correspondence, and the serialized full suite.

### Parallel Team Strategy

1. One contributor owns the Clarify skill contract and its verification sections.
2. A second contributor owns the record/catalog templates and `output-template.test.sh`.
3. A third contributor owns disposable probes in `highway-clarify.test.sh` and generated-artifact validation.
4. Integrate shared-file edits before regeneration and full-suite validation.

## Notes

- Every task uses the required `- [ ] T### [P?] [US#?] description` checklist format.
- `[P]` appears only where the task can be performed independently without an incomplete dependency.
- User-story labels are present on all Phase 3-5 tasks and absent from setup, foundational, and polish tasks.
- Generated adapters and catalog indexes remain derived outputs; canonical sources are the skill and shared templates.
