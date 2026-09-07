---

description: "Task list template for feature implementation"
---

# Tasks: Rename Shared Content Directory to Library

**Input**: Design documents from `/specs/005-rename-content-to-library/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md (all present)

**Tests**: Included. This feature renames existing tooling and its existing
`.highway/tools/tests/*.test.sh` suite; the renamed/updated test files are the mechanism that
proves FR-005 (every currently-passing test keeps passing) and are therefore mandatory
implementation work, not optional new TDD tests.

**Organization**: Tasks are grouped by user story (US1, US2, US3 — spec.md priorities P1, P1, P2).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: US1, US2, or US3 — maps to spec.md's user stories
- Setup, Foundational, and Polish tasks carry no story label

## Path Conventions

Single project. All paths are relative to the repository root, rooted at `.highway/` for
tooling and `specs/005-rename-content-to-library/` for this feature's own documentation.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the pre-rename baseline this feature must not regress.

- [X] T001 Run `.highway/tools/tests/run-all.sh` from repo root and confirm the full suite
      passes before any rename begins (quickstart.md Prerequisites)

**Checkpoint**: Baseline confirmed green; safe to begin renaming.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: No additional shared code is needed before user story work starts — Setup's
baseline check is the only cross-story prerequisite. US2 (tooling repoint) depends on US1
(directory relocation) by necessity, since the tooling must point somewhere that exists; US3
(docs) is sequenced after US2 by priority and because it names US2's final script/artifact
names.

**Checkpoint**: Proceed directly to User Story phases; there is no additional blocking work.

---

## Phase 3: User Story 1 - Shared files live under the new directory name (Priority: P1)

**Goal**: `.highway/content/` is relocated to `.highway/library/` with identical contents; the
old path no longer exists.

**Independent Test**: Confirm `.highway/content/` is absent and
`.highway/library/{templates,knowledge,governance}/` exist with the same file contents as
before, just relocated.

### Implementation for User Story 1

- [X] T002 [US1] `git mv .highway/content .highway/library` — a single recursive rename that
      relocates `templates/`, `knowledge/`, `governance/`, and their three `README.md` files as
      one git-recorded move, preserving history (data-model.md Rename Mapping — Directories;
      FR-001; research.md Decision 1)
- [X] T003 [US1] Verify `.highway/content` no longer exists and
      `.highway/library/{templates,knowledge,governance}/` exist with byte-identical file
      contents to what `.highway/content/` held before T002 (depends on T002; FR-001, FR-002;
      SC-001; quickstart.md scenario 1)

**Checkpoint**: User Story 1 is fully functional and independently testable — the directory
tree has moved intact and the old path is gone. (Existing tooling will not yet resolve the new
location; that is delivered by User Story 2.)

---

## Phase 4: User Story 2 - Tooling resolves the new location (Priority: P1)

**Goal**: The validator and catalog generator resolve files under `.highway/library/`; a
dependency declared with the old `content/...` prefix fails validation (not silently
translated), and one declared with the new `library/...` prefix resolves.

**Independent Test**: Run the renamed validator against a file under `.highway/library/` and
confirm it is checked; run the renamed catalog generator and confirm the listing is built from
`.highway/library/`; declare a dependency at an old `content/...` path and confirm it fails
naming that exact path.

### Test Updates for User Story 2

- [X] T004 [P] [US2] `git mv .highway/tools/tests/fixtures/content .highway/tools/tests/fixtures/library`
      — recursive rename of the fixture tree used by the renamed validator/catalog tests
      (depends on T002; data-model.md Rename Mapping — Directories)
- [X] T005 [P] [US2] `git mv .highway/tools/tests/validate-content.test.sh
      .highway/tools/tests/validate-library.test.sh`; update its script-under-test path
      (`validate-content.sh`→`validate-library.sh`), its fixture paths
      (`fixtures/content/`→`fixtures/library/`), and its orphan-file assertion tag
      (`[CONTENT-TYPE]`→`[LIBRARY-TYPE]`) (depends on T004;
      contracts/library-validation-output.md)
- [X] T006 [P] [US2] `git mv .highway/tools/tests/generate-content-catalog.test.sh
      .highway/tools/tests/generate-library-catalog.test.sh`; update its script-under-test path,
      fixture paths, expected output filenames (`content-index.*`→`library-index.*`), the schema
      contract it validates against
      (`specs/005-rename-content-to-library/contracts/library-catalog.schema.json`), and its
      field assertions (`content_type`→`library_type`) (depends on T004;
      contracts/library-catalog.schema.json)
- [X] T007 [US2] Update `.highway/tools/tests/dependency-check.test.sh`'s target-fixture path
      constant from a `content/...`-rooted value to a `library/...`-rooted value (depends on
      T004; data-model.md Rename Mapping — Tests)

### Implementation for User Story 2

- [X] T008 [P] [US2] `git mv .highway/tools/lib/content-schema.sh
      .highway/tools/lib/library-schema.sh`; rename its `cs_validate_name`→`ls_validate_name`
      and `cs_validate_description`→`ls_validate_description` functions (research.md
      Decision 4; data-model.md Rename Mapping — Scripts and libraries)
- [X] T009 [US2] `git mv .highway/tools/validate-content.sh .highway/tools/validate-library.sh`;
      update its `source` line to `library-schema.sh`'s new function names; rename its
      `content_type`/`content_file` variables to `library_type`/`library_file`; change its
      path-match check from `content/*` to `library/*`; change its orphan-file tag from
      `[CONTENT-TYPE]` to `[LIBRARY-TYPE]`; change its result-line noun from `content` to
      `library` (depends on T008; contracts/library-validation-output.md)
- [X] T010 [US2] `git mv .highway/tools/generate-content-catalog.sh
      .highway/tools/generate-library-catalog.sh`; rename `CONTENT_DIR`→`LIBRARY_DIR` (pointed
      at `.highway/library`), `content_files`→`library_files`, `content_type_of`→
      `library_type_of`; change its validator call to `validate-library.sh`; change the
      filenames it writes from `content-index.json`/`.md` to `library-index.json`/`.md`; change
      the JSON field it writes from `content_type` to `library_type` (depends on T009;
      contracts/library-catalog.schema.json)
- [X] T011 [US2] Confirm (no code change needed) that `.highway/tools/lib/dependency-check.sh`
      resolves a dependency's `path` framework-relative to `$HIGHWAY_ROOT`, so a `library/...`
      path now resolves and a stale `content/...` path fails as a plain missing-path error, with
      no silent translation between the two (depends on T002; FR-003, FR-004; research.md
      Decision 3)
- [X] T012 [US2] Run `validate-library.test.sh`, `generate-library-catalog.test.sh`, and
      `dependency-check.test.sh`; confirm every assertion passes, including the
      old-prefix-fails / new-prefix-resolves pair (depends on T005, T006, T007, T009, T010,
      T011; quickstart.md scenarios 2-6)

**Checkpoint**: User Story 2 is fully functional and independently testable — all tooling
resolves `.highway/library/`, and the old `content/...` prefix fails cleanly instead of being
silently translated.

---

## Phase 5: User Story 3 - Documentation reflects the new name (Priority: P2)

**Goal**: Every live doc that named the old directory or its tools now names the new ones, with
no remaining "content" terminology for this concept.

**Independent Test**: Read `.highway/tools/README.md`, `.highway/catalog/README.md`, and the
three per-directory READMEs under `.highway/library/`; confirm each references only "library"
terminology and the renamed script/artifact names.

### Implementation for User Story 3

- [X] T013 [P] [US3] Update prose in `.highway/library/templates/README.md`,
      `.highway/library/knowledge/README.md`, and `.highway/library/governance/README.md`:
      replace "content" terminology with "library", including any
      `validate-content.sh`→`validate-library.sh` link (depends on T002; FR-006)
- [X] T014 [P] [US3] Update `.highway/tools/README.md`'s library responsibility table: rename
      the `content-schema.sh`, `validate-content.sh`, and `generate-content-catalog.sh` rows to
      their new names and descriptions (depends on T008, T009, T010; FR-006)
- [X] T015 [US3] Update `.highway/catalog/README.md`: rename the documented artifacts
      (`content-index.json`/`.md`→`library-index.json`/`.md`) and its contract link from
      `specs/004-shared-content-library/contracts/content-catalog.schema.json` to
      `specs/005-rename-content-to-library/contracts/library-catalog.schema.json` (depends on
      T010; FR-006)

**Checkpoint**: All three user stories are independently functional. No live documentation
still names the old directory, scripts, or artifacts.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Repo-wide consistency checks that span more than one user story.

- [X] T016 [P] Confirmed (no change needed): `path-integrity.test.sh`'s existing generic regex
      (`tools/[A-Za-z0-9._-]+\.sh`) catches zero stale references to the renamed scripts without
      modification
- [X] T017 [P] Run `grep -rln '\.highway/content' .` excluding `.git` and
      `specs/001-multi-agent-skill-suite/` through `specs/004-shared-content-library/`; confirm
      zero remaining matches (FR-007; SC-004; quickstart.md scenario 7). **Implementation-time
      correction**: this surfaced two items the original task list missed — a stale comment in
      `.highway/tools/validate-skill.sh` (fixed in place) and the superseded, git-tracked
      `.highway/catalog/content-index.json`/`.md` artifacts from feature 004 (removed via
      `git rm`, since `generate-library-catalog.sh` now writes `library-index.*` instead)
- [X] T018 Run `.highway/tools/tests/run-all.sh` and confirm the full suite passes, including
      every renamed test file from this feature (SC-002; quickstart.md scenario 8)
- [X] T019 Execute every scenario in `specs/005-rename-content-to-library/quickstart.md` in
      order and confirm each expected outcome

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately.
- **Foundational (Phase 2)**: Depends on Setup; contributes no additional blocking work of its
  own (see Phase 2 note).
- **User Story 1 (Phase 3)**: Depends on Setup. Must complete before User Story 2 (the tooling
  it repoints must point at a location that exists).
- **User Story 2 (Phase 4)**: Depends on User Story 1 (T002).
- **User Story 3 (Phase 5)**: Depends on User Story 2 (needs the final script/artifact names to
  document) and on User Story 1 (needs the moved READMEs to edit).
- **Polish (Phase 6)**: Depends on all three user stories being complete.

### User Story Dependencies

- **US1 (P1)**: No dependency on US2 or US3. Must complete first — it is the physical
  prerequisite both other stories build on.
- **US2 (P1)**: Depends on US1 only.
- **US3 (P2)**: Depends on US1 and US2.

### Within Each User Story

- Fixture/directory renames before the test files that reference them.
- Library renames before the script that sources them.
- Test file updates before the task that runs them and confirms the assertions pass.
- Script renames before the docs that name them.

### Parallel Opportunities

- T004-T006 (US2 test-file/fixture renames) are independent files — run in parallel.
- T008 can run in parallel with T004-T007 (different files); T009 depends on T008.
- T013 and T014 (Polish-adjacent US3 docs) are independent files — run in parallel.
- T016 and T017 (Polish) are independent checks — run in parallel.

---

## Parallel Example: User Story 2 test updates

```bash
# Test Updates for User Story 2 (Phase 4) — run together once T002/T004 complete:
Task: "git mv validate-content.test.sh to validate-library.test.sh and update its references"
Task: "git mv generate-content-catalog.test.sh to generate-library-catalog.test.sh and update its references"
```

---

## Implementation Strategy

### MVP First (User Story 1 + User Story 2 together)

1. Complete Phase 1: Setup.
2. Complete Phase 3: User Story 1 (directory relocation).
3. Complete Phase 4: User Story 2 (tooling repoint).
4. **STOP and VALIDATE**: run `validate-library.test.sh`, `generate-library-catalog.test.sh`,
   and `dependency-check.test.sh`; confirm the renamed tooling resolves `.highway/library/` and
   the old `content/...` prefix fails cleanly.
5. Unlike feature 004's additive stories, US1 and US2 must ship together here: moving the
   directory (US1) without repointing the tooling (US2) would leave every existing script
   looking for a path that no longer exists, breaking the full test suite until both are done.

### Incremental Delivery

1. Setup → baseline confirmed green.
2. US1 + US2 together → the rename is functionally complete and the full suite passes again.
3. Add User Story 3 → all live documentation reflects the new name.
4. Polish → repo-wide zero-residue check, full-suite and quickstart confirmation.
