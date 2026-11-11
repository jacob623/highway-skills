---

description: "Task list for Standard Alignment Removals"
---

# Tasks: Standard Alignment Removals

**Input**: Design documents from `specs/233-standard-alignment-removals/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [quickstart.md](quickstart.md)

**Tests**: The spec requires existing tests to change with the removals (FR-005, FR-010, FR-015). No new test file is created. The amended catalog test is run and observed failing before the generator changes (D3.6).

**Organization**: Tasks are grouped by user story. US1 and US2 come before US3, because both catalog generators link to the catalog README (research R2).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on an incomplete task)
- **[Story]**: The user story the task belongs to

---

## Phase 1: Setup

**Purpose**: Record the starting state the change is measured against.

- [X] T001 Run `.highway/tools/tests/run-all.sh` and confirm exit 0 before any source edit (D3.1, FR-015)
- [X] T002 [P] Record the test file count from `ls .highway/tools/tests/*.test.sh | wc -l`, and copy `.highway/catalog/index.json` to `/tmp/spec233-index-before.json` for the SC-004 comparison

**Checkpoint**: Baseline green; before-state captured.

---

## Phase 2: Foundational

No blocking prerequisite beyond Phase 1. Every story works on files that already exist.

---

## Phase 3: User Story 1 - Remove the shared library index (Priority: P1) 🎯 MVP

**Goal**: The library index, its generator, and its test are gone, nothing names them, and the development constitution lists only the remaining generators with no timestamp exception.

**Independent Test**: The suite passes, and quickstart step 3 finds no `library-index` or `generate-library-catalog` reference.

- [X] T003 [US1] Delete `.highway/tools/generate-library-catalog.sh`, `.highway/tools/tests/generate-library-catalog.test.sh`, `.highway/catalog/library-index.json`, and `.highway/catalog/library-index.md`
- [X] T004 [P] [US1] In `.highway/tools/tests/adapter-coverage.test.sh`, remove both `.highway/tools/generate-library-catalog.sh` calls (probe mode and normal mode) and drop `catalog/library-index.json` and `catalog/library-index.md` from the catalog comparison loop
- [X] T005 [P] [US1] In `.highway/tools/tests/distribution-packaging.test.sh`, drop the two `library-index` paths from `normalize_catalog_timestamps`
- [X] T006 [P] [US1] In `.highway/tools/tests/feature-092-correspondence.test.sh`, drop the `generate-library-catalog.sh` token and the `library-index.json` dependent; in `.highway/tools/tests/fixtures/profile-092/dependent-artifact-inventory.tsv` delete the library index row; in `.highway/tools/tests/fixtures/profile-092/impact-review.tsv` delete the library index row (research R6)
- [X] T007 [P] [US1] Delete the `generate-library-catalog.sh` section from `.highway/tools/README.md`
- [X] T008 [US1] Amend `.specify/memory/constitution.md` to 3.0.0 per research R8: remove `generate-library-catalog.sh` from the declared generators and replace the timestamp note; remove the timestamp exception from the D4.2 and D4.7 Observables and their Enforcement Map notes; update the version line and Last Amended date; add a Sync Impact Report with the changed elements and the D1.3, D1.4, and D5.3 self-application review
- [X] T009 [US1] Run `adapter-coverage.test.sh`, `distribution-packaging.test.sh`, `feature-092-correspondence.test.sh`, and `constitution-inventory.test.sh` under `.highway/tools/tests/` and confirm each passes

**Checkpoint**: US1 complete and independently verifiable.

---

## Phase 4: User Story 2 - Simplify the skill catalog (Priority: P1)

**Goal**: `generate-catalog.sh` writes only `index.json` with `entries`, byte-identical across runs; highway-help no longer mentions `overlap_flags`.

**Independent Test**: Quickstart steps 4 and 5.

- [X] T010 [US2] Amend `.highway/tools/tests/generate-catalog.test.sh` per research R3: require `entries`; reject `generated_at` and `overlap_flags`; require `.highway/catalog/index.md` absent after a run; compare two runs byte for byte with no filter; update the header comment of `catalog_snapshots_match`. Run it and record the failing output against the current generator (D3.6)
  - Observed failing, 2026-11-11, exit 1: `FAIL: catalog/index.json has removed key 'generated_at'`; `FAIL: catalog/index.json has removed key 'overlap_flags'`; `FAIL: catalog/index.md exists; the generator writes catalog/index.json only`; `FAIL: re-running with unchanged skills/ content produced a different catalog`
- [X] T011 [US2] Change `.highway/tools/generate-catalog.sh` to write `{"entries": [...]}` to `.highway/catalog/index.json` only: remove the `overlap_flags` preservation, the timestamp, the `index.md` block, and the `CATALOG_MD` variable; update the header comment and the closing `OK:` line
- [X] T012 [US2] Delete `.highway/catalog/index.md`, run `.highway/tools/generate-catalog.sh`, and confirm `.highway/tools/tests/generate-catalog.test.sh` now passes
- [X] T013 [P] [US2] In `.highway/tools/tests/adapter-coverage.test.sh`, remove `strip_timestamp` and its comment, and compare `catalog/index.json` with plain `diff`; drop `catalog/index.md` from the loop
- [X] T014 [P] [US2] In `.highway/tools/tests/distribution-packaging.test.sh`, remove `normalize_catalog_timestamps`, its calls, and the comment that justifies it
- [X] T015 [P] [US2] In `.highway/tools/tests/harness-path-map.test.sh`, change `expect .highway/catalog/index.md none -` to `expect .highway/catalog/index.json none -`
- [X] T016 [P] [US2] In `.highway/skills/_authoring-standard.md`, delete step 4 of the manual overlap review (research R4)
- [X] T017 [P] [US2] In `README.md`, reword the "Build the catalog" line to name only `.highway/catalog/index.json`; in `.highway/tools/README.md`, do the same in the `generate-catalog.sh` section
- [X] T018 [US2] In `.highway/skills/highway-help/SKILL.md`, delete the "When not to use" bullet naming `overlap_flags` and bump `metadata.version` from 3.1.0 to 3.1.1; then run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` so `.highway/catalog/index.json` and the four agent copies under `.agents/`, `.claude/`, `.cursor/`, and `.github/` match
  - The validator (P9.5) also required the `## Example` section's `Version:` line to read 3.1.1, and `.highway/tools/tests/storage-contract.test.sh` pins highway-help's version; both were updated to 3.1.1
- [X] T019 [US2] Compare `.highway/catalog/index.json` entries with `/tmp/spec233-index-before.json`: all 15 identical except highway-help's version (SC-004); run `generate-catalog.test.sh`, `adapter-coverage.test.sh`, `distribution-packaging.test.sh`, and `harness-path-map.test.sh`

**Checkpoint**: US1 and US2 both work independently.

---

## Phase 5: User Story 3 - Remove READMEs for folders that are going away (Priority: P2)

**Goal**: No README remains in the three library folders or the catalog folder, and no list names one.

**Independent Test**: Quickstart step 8 and the path-map test.

- [X] T020 [US3] Delete `.highway/library/governance/README.md`, `.highway/library/knowledge/README.md`, `.highway/library/templates/README.md`, and `.highway/catalog/README.md`
- [X] T021 [US3] Delete the three README `none` rows from `harness/selection/shared.txt`
- [X] T022 [US3] Run `.highway/tools/tests/harness-path-map.test.sh` and `.highway/tools/tests/generate-catalog.test.sh`, and check every path in `harness/selection/shared.txt` exists (SC-006)

**Checkpoint**: US3 verified.

---

## Phase 6: User Story 4 - Remove finished one-off tooling (Priority: P2)

**Goal**: The audits, allowlist, seeding script, and their tests are gone, with each dropped assertion accounted for.

**Independent Test**: Quickstart steps 2 and 7, and research R9 accounts for every dropped assertion.

- [X] T023 [US4] Delete `.highway/tools/audit-objective-rename.sh`, `.highway/tools/.objective-rename-allowlist`, `.highway/tools/audit-profile-migration.sh`, `.highway/tools/seed-library-context.sh`, `.highway/tools/tests/objective-rename-contract.test.sh`, `.highway/tools/tests/profile-migration.test.sh`, and `.highway/tools/tests/seed-library-context.test.sh`
- [X] T024 [US4] In `.highway/tools/.distribution-manifest`, delete the rows for `.objective-rename-allowlist`, `audit-objective-rename.sh`, `highway-identity.md`, `highway-platform-objectives.md`, and `highway-vision.md`; keep the `.DS_Store` row (research R10)
- [X] T025 [US4] Confirm `.highway/tools/tests/profile-markdown-contract.test.sh` still asserts `schema_version: 3.0.0` on the Profile template (the kept assertion in research R9), then run it, `distribution-packaging.test.sh`, and `shipped-tree-independence.test.sh`

**Checkpoint**: All four stories verified.

---

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T026 [P] Delete the untracked `.DS_Store`, `.highway/.DS_Store`, and `.highway/skills/.DS_Store` (FR-013)
- [X] T027 Run quickstart step 3 and confirm the only remaining matches are the ones it expects (SC-001)
- [X] T028 Run `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-agent-adapters.sh`, and `.highway/tools/generate-instructions.sh` twice each and confirm the second run leaves no diff (SC-003, FR-012)
- [X] T029 Run quickstart step 7: build a distribution into a temporary directory and confirm it holds none of the removed files (SC-005)
- [X] T030 Run `.highway/tools/tests/run-all.sh` and confirm exit 0, with a test file count exactly 4 below T002 (D3.2, SC-002)

---

## Dependencies & Execution Order

- **Setup (Phase 1)**: first. T001 must pass before any edit.
- **US1 (Phase 3)**: after Setup.
- **US2 (Phase 4)**: after US1, because T013 and T014 edit the same test files as T004 and T005.
- **US3 (Phase 5)**: after US1 and US2, because both generators linked to the catalog README until T003 and T011.
- **US4 (Phase 6)**: after Setup; independent of the other stories, but T024 and T014 both affect what the packaging test sees, so run T025 after T014.
- **Polish (Phase 7)**: after every story.

### Within each story

- US2: T010 runs and fails before T011 (D3.6). T018 regenerates after every source edit in the story.

### Parallel opportunities

- US1: T004, T005, T006, and T007 touch different files.
- US2: T013, T014, T015, T016, and T017 touch different files, after T012.
- Polish: T026 runs alongside any other task.

## Parallel Example: User Story 2

```bash
# After T012:
Task: "Remove strip_timestamp from .highway/tools/tests/adapter-coverage.test.sh"
Task: "Remove normalize_catalog_timestamps from .highway/tools/tests/distribution-packaging.test.sh"
Task: "Point the harness-path-map expectation at .highway/catalog/index.json"
Task: "Delete overlap review step 4 in .highway/skills/_authoring-standard.md"
```

## Implementation Strategy

### MVP first

1. Phase 1, then US1.
2. Stop and validate: the suite passes and the library index is gone.

### Incremental delivery

1. US1, then US2: the catalog is deterministic and the constitution is strengthened.
2. US3: the README files are gone.
3. US4: the one-off tools are gone.
4. Polish: sweep, regeneration, distribution, and full suite.
