# Tasks: Shared Content Library

**Input**: Design documents from `/specs/004-shared-content-library/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md (all present)

**Tests**: Included. Feature 003 established this repository's convention of a fixture + `*.test.sh`
per new behavior, run by the existing `.highway/tools/tests/run-all.sh` harness; this feature
follows that convention.

**Organization**: Tasks are grouped by user story (US1, US2, US3 — spec.md priorities P1, P1, P2).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: US1, US2, or US3 — maps to spec.md's user stories
- Setup, Foundational, and Polish tasks carry no story label

## Path Conventions

Single project. All paths are relative to the repository root, rooted at `.highway/` for
tooling and `specs/004-shared-content-library/` for this feature's own documentation.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the directory structure every user story's fixtures and tests need.

- [X] T001 Create `.highway/content/templates/README.md` documenting the directory's purpose
      (centralizes skill output markdown templates); the README itself is documentation, not a
      template (FR-001, FR-002)
- [X] T002 [P] Create `.highway/content/knowledge/README.md` documenting the directory's
      purpose (centralizes general knowledge markdown files) (FR-001, FR-003)
- [X] T003 [P] Create `.highway/content/governance/README.md` documenting the directory's
      purpose (centralizes governance markdown files) (FR-001, FR-004)

**Checkpoint**: `.highway/content/{templates,knowledge,governance}/` exist and are committed.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: No additional shared code is needed before user story work starts — the three
directories from Phase 1 are the only cross-story prerequisite. US1 (dependency resolution) and
US2 (content validation) do not depend on each other's library code; US3 (discovery) depends on
US2's `validate-content.sh` and is sequenced after it by priority (P2 after P1).

**Checkpoint**: Proceed directly to User Story phases; there is no additional blocking work.

---

## Phase 3: User Story 1 - An author shares one file instead of duplicating it (Priority: P1) 🎯 MVP

**Goal**: A skill declares a dependency on a shared content file by path and pinned version; a
missing path or a version mismatch fails validation, naming the path.

**Independent Test**: Author a skill with a `metadata.dependencies` entry pointing at a real
file under `.highway/content/`; validate it and confirm success. Point the same entry at a
nonexistent path and confirm failure naming the path. Pin a stale version and confirm failure
naming expected vs. actual version.

### Tests for User Story 1

> **Implementation-time correction**: `dependency-check.sh` resolves `path` anchored at the
> real `$HIGHWAY_ROOT` (FR-007), not fixture-relative, so a static target file under
> `tools/tests/fixtures/content/` can never be a valid dependency target. T004-T007 as
> originally planned (static committed fixture directories) were replaced with a single test
> (T008) that generates its target file and three skill variants at run time under temp
> locations, mirroring `generate-catalog.test.sh`'s existing temp-real-artifact pattern.

- [X] T004 [P] [US1] ~~Create fixture target file~~ superseded — see correction note above;
      `dependency-check.test.sh` generates this at run time instead
- [X] T005 [P] [US1] ~~Create fixture skill `valid-skill-with-dependency`~~ superseded — see
      correction note above
- [X] T006 [P] [US1] ~~Create fixture skill `invalid-skill-missing-dependency`~~ superseded —
      see correction note above
- [X] T007 [P] [US1] ~~Create fixture skill `invalid-skill-stale-dependency-version`~~
      superseded — see correction note above
- [X] T008 [US1] Write `.highway/tools/tests/dependency-check.test.sh` asserting: a skill with a
      resolvable dependency at the pinned version produces zero `[DEPENDENCY]` findings; a
      missing dependency path fails naming the path; a stale pinned version fails naming
      expected vs. actual version; a skill with no `dependencies` field (the existing
      `valid-skill` fixture) produces zero findings

### Implementation for User Story 1

- [X] T009 [US1] Add `fm_get_dependencies` to `.highway/tools/lib/frontmatter.sh`, structurally
      mirroring the existing `fm_get_agent_exceptions` state machine: emits one `path|version`
      line per `metadata.dependencies[]` entry (research.md Decision 2)
- [X] T010 [US1] Create `.highway/tools/lib/dependency-check.sh` with
      `dc_validate_dependencies <skill_file> <highway_root>`: for each `fm_get_dependencies`
      entry, resolve `path` as `$highway_root/$path` (framework-relative, matching the existing
      catalog's `source_path` convention); print the missing-path message
      (`contracts/dependency-validation-output.md`) if absent; else read the target's
      `metadata.version` via `fm_get_nested` and print the version-mismatch message if it
      differs from the pinned version; return 1 if any message was printed, else 0 (depends on
      T009; research.md Decisions 3-4)
- [X] T011 [US1] Wire `dependency-check.sh` into `.highway/tools/validate-skill.sh`: source the
      new library, call `dc_validate_dependencies "$skill_file" "$HIGHWAY_ROOT"` after the
      existing schema checks, collect its output as `[DEPENDENCY]`-tagged findings the same way
      existing `[SCHEMA]` findings are collected (depends on T010)
- [X] T012 [US1] Run `dependency-check.test.sh` and confirm all assertions from T008 pass
      (depends on T008, T011)

**Checkpoint**: User Story 1 is fully functional and independently testable — a skill's
dependency on a shared file is resolved, and a missing or stale-versioned dependency fails
validation naming the path.

---

## Phase 4: User Story 2 - Shared content is held to the same constitution as a skill (Priority: P1)

**Goal**: A shared template, knowledge, or governance file gets the same rule-ID-level
validation feedback a skill gets, with the rule subset correctly scoped by content type.

**Independent Test**: Seed one rule violation in a file under each of the three content
directories; confirm each is detected and reported by rule ID. Confirm a template containing
placeholder text with the word "MUST" still passes.

### Tests for User Story 2

- [X] T013 [P] [US2] Create fixture
      `.highway/tools/tests/fixtures/content/governance/valid/policy.md`: conforming governance
      file (minimal frontmatter, a MUST-level rule citing an AS-1..AS-6 source in the
      constitution's Citation Format)
- [X] T014 [P] [US2] Create fixture
      `.highway/tools/tests/fixtures/content/governance/invalid-bad-citation/policy.md`: same
      shape as T013 but with a citation that does not resolve to AS-1 through AS-6 (violates
      P3.5)
- [X] T015 [P] [US2] Create fixture
      `.highway/tools/tests/fixtures/content/knowledge/valid/reference.md`: conforming knowledge
      file
- [X] T016 [P] [US2] Create fixture
      `.highway/tools/tests/fixtures/content/knowledge/invalid-two-keywords/reference.md`: same
      shape as T015 but with one normative line carrying both MUST and SHOULD (violates P1.1)
- [X] T017 [P] [US2] Create fixture
      `.highway/tools/tests/fixtures/content/templates/valid/output-shape.md`: conforming
      template whose placeholder body intentionally contains the literal word "MUST" as
      illustrative output text (must NOT fail P1.1/P1.3/P7.4/P7.5)
- [X] T018 [P] [US2] Create fixture
      `.highway/tools/tests/fixtures/content/templates/invalid-missing-version/output-shape.md`:
      same shape as T017 but frontmatter omits `metadata.version`. **Implementation-time
      correction**: tagged `P7.2` (a rule id), not `[SCHEMA]` as originally planned —
      `content-schema.sh` deliberately does not duplicate version-format checking, mirroring
      `schema-validate.sh`'s existing skill-side comment that P7.2 is the version rule's one and
      only owner
- [X] T019 [P] [US2] Create fixture
      `.highway/tools/tests/fixtures/content/invalid-orphan/orphan.md`: a file placed directly
      under `.highway/content/` (not inside `templates/`, `knowledge/`, or `governance/`)
- [X] T020 [US2] Write `.highway/tools/tests/validate-content.test.sh` asserting: T013 and T015
      pass; T014 fails naming `P3.5`; T016 fails naming `P1.1`; T017 passes with its `N/A:`
      coverage group containing `P1.1=N2 P1.3=N2 P7.4=N2 P7.5=N2`; T018 fails tagged `P7.2`;
      T019 fails tagged `[CONTENT-TYPE]` (depends on T013-T019;
      `contracts/content-validation-output.md`)

### Implementation for User Story 2

- [X] T021 [P] [US2] Create `.highway/tools/lib/content-schema.sh` with checks for `name`
      (non-empty) and `description` (non-empty and ≤500 characters, reusing the skill
      threshold), each finding tagged `[SCHEMA]` (research.md Decision 6; data-model.md Shared
      Content File). `metadata.version` format is deliberately **not** duplicated here — rule
      P7.2 (already in the registry loop) is its one owner, exactly as for a skill
- [X] T022 [US2] Add a template-exclusion list to `.highway/tools/lib/rule-checks.sh`: a
      `rc_template_exempt_ids` function returning `P1.1 P1.3 P7.4 P7.5` (research.md Decision 1;
      data-model.md rule applicability table)
- [X] T023 [US2] Create `.highway/tools/validate-content.sh <content-file>`: derive
      `content_type` from the file's path (must be under `content/templates/`,
      `content/knowledge/`, or `content/governance/`, else fail tagged `[CONTENT-TYPE]`); run
      `content-schema.sh` checks; loop `con_rules` like `validate-skill.sh` does, skipping (N/A,
      condition `N2`) any rule in `rc_template_exempt_ids` when `content_type` is `template`;
      print the same `CHECKED/FAILED/N/A/DEFERRED/UNCHECKED` coverage summary and result line
      per `contracts/content-validation-output.md` (depends on T021, T022)
- [X] T024 [US2] Run `validate-content.test.sh` and confirm all assertions from T020 pass
      (depends on T020, T023)

**Checkpoint**: User Story 2 is fully functional and independently testable — every content
file gets rule-ID-level feedback, and templates are exempt from exactly the four rules that
would otherwise misfire on placeholder text.

---

## Phase 5: User Story 3 - An author finds the right shared file without reading every skill (Priority: P2)

**Goal**: A generated, sibling listing artifact names every file under `.highway/content/`,
grouped by content type, without a manual registration step.

**Independent Test**: With the fixtures from US2 in place, run the generator and confirm every
valid fixture appears in the listing exactly once, grouped by content type.

### Tests for User Story 3

- [X] T025 [US3] Write `.highway/tools/tests/generate-content-catalog.test.sh` asserting: the
      generated `content-index.json` validates against
      `specs/004-shared-content-library/contracts/content-catalog.schema.json`'s shape (every
      required field present, `additionalProperties: false` respected); every valid fixture from
      US2 appears exactly once with the correct `content_type`; a directory containing an
      invalid fixture causes the generator to exit non-zero with no catalog file written (no
      partial write, matching `generate-catalog.sh`'s existing precedent)

### Implementation for User Story 3

- [X] T026 [US3] Create `.highway/tools/generate-content-catalog.sh`: walk
      `.highway/content/{templates,knowledge,governance}/*.md`; validate each via
      `validate-content.sh` first, aborting with no write if any fails (mirrors
      `generate-catalog.sh`'s all-or-nothing precedent); write
      `.highway/catalog/content-index.json` per `contracts/content-catalog.schema.json` and a
      human-readable `.highway/catalog/content-index.md` (depends on T023; research.md
      Decision 5). **Implementation-time note**: iterates by numeric index rather than
      `"${array[@]}"`, matching `generate-catalog.sh`'s existing workaround for bash 3.2's
      `set -u` treating an empty array expansion as an unbound variable
- [X] T027 [US3] Run `generate-content-catalog.test.sh` and confirm all assertions from T025
      pass (depends on T025, T026)

**Checkpoint**: All three user stories are independently functional. Discovery reflects every
file with zero manual registration.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Repo-wide consistency checks that span more than one user story.

- [X] T028 [P] Confirmed (no change needed): `path-integrity.test.sh`'s existing regex
      (`tools/[A-Za-z0-9._-]+\.sh`) is already generic and caught zero stale references to the
      four new scripts/libs this feature added, without modification
- [X] T029 [P] Update `.highway/tools/README.md`'s library responsibility table with
      `content-schema.sh` and `dependency-check.sh`, and document `validate-content.sh` and
      `generate-content-catalog.sh` alongside the existing `validate-skill.sh` /
      `generate-catalog.sh` entries. Also updated `.highway/catalog/README.md` to document the
      new sibling `content-index.json`/`.md` artifacts
- [X] T030 Run `.highway/tools/tests/run-all.sh` and confirm the full suite passes, including
      every new test file from this feature
- [X] T031 Execute every scenario in `specs/004-shared-content-library/quickstart.md` in order
      and confirm each expected outcome, including the working-directory-independence check
      (quickstart.md step 9) and the full-suite check (step 10). **Implementation-time
      correction**: scenarios 5-7 and 9 were rewritten to generate their dependency fixtures at
      run time (see the T004-T008 correction note above) rather than referencing static fixture
      directories that no longer exist

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately.
- **Foundational (Phase 2)**: Depends on Setup; contributes no additional blocking work of its
  own (see Phase 2 note).
- **User Story 1 (Phase 3)**: Depends on Setup (needs `.highway/content/` to exist for its
  dependency-target fixture). Independent of User Story 2.
- **User Story 2 (Phase 4)**: Depends on Setup. Independent of User Story 1.
- **User Story 3 (Phase 5)**: Depends on User Story 2's `validate-content.sh` (T023).
- **Polish (Phase 6)**: Depends on all three user stories being complete.

### User Story Dependencies

- **US1 (P1)**: No dependency on US2 or US3.
- **US2 (P1)**: No dependency on US1 or US3.
- **US3 (P2)**: Depends on US2 (T023) only; independent of US1.

### Within Each User Story

- Fixtures before the test file that asserts against them.
- Library functions before the script that calls them.
- Test file before the task that runs it and confirms the assertions pass.

### Parallel Opportunities

- T001-T003 (Setup) are independent files — run in parallel.
- T004-T007 (US1 fixtures) are independent files — run in parallel.
- T013-T019 (US2 fixtures) are independent files — run in parallel.
- US1 (Phase 3) and US2 (Phase 4) can be staffed in parallel once Setup completes; neither
  depends on the other's code.
- T028 and T029 (Polish) are independent files — run in parallel.

---

## Parallel Example: Setup + User Story 1 fixtures

```bash
# Setup (Phase 1) — run together:
Task: "Create .highway/content/templates/README.md"
Task: "Create .highway/content/knowledge/README.md"
Task: "Create .highway/content/governance/README.md"

# User Story 1 fixtures (Phase 3) — run together once Setup completes:
Task: "Create fixture target file .highway/tools/tests/fixtures/content/knowledge/valid/dependency-target.md"
Task: "Create fixture skill .highway/tools/tests/fixtures/valid-skill-with-dependency/SKILL.md"
Task: "Create fixture skill .highway/tools/tests/fixtures/invalid-skill-missing-dependency/SKILL.md"
Task: "Create fixture skill .highway/tools/tests/fixtures/invalid-skill-stale-dependency-version/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 3: User Story 1 (dependency resolution).
3. **STOP and VALIDATE**: run `dependency-check.test.sh`; confirm a skill can reference a shared
   file, a missing reference fails naming the path, and a stale version fails naming both
   versions.
4. This alone delivers the feature's stated core value (share one file, edit it once) even
   before content-type rule enforcement (US2) exists, since US1's fixture target only needs
   valid minimal frontmatter, not a passing `validate-content.sh` run.

### Incremental Delivery

1. Setup → directories exist.
2. Add User Story 1 → dependency resolution works → demo-able MVP.
3. Add User Story 2 → content files get rule-ID-level enforcement → demo-able independently.
4. Add User Story 3 → discovery listing → demo-able independently (depends on US2 only).
5. Polish → repo-wide consistency, full-suite and quickstart confirmation.
