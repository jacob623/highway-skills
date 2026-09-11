# Feature Specification: Rename Shared Content Directory to Library

**Feature Branch**: `005-rename-content-to-library`

**Created**: 2026-09-07

**Status**: Draft

**Input**: User description: "I want to rename .highway/content to .highway/library"

## Clarifications

### Session 2026-09-07

- Q: Feature 004 introduced not just the `.highway/content/` directory but a matching set of
  tool names, error tags, JSON field names, test/fixture paths, and docs that all use the word
  "content" to refer to the same concept. How far should this rename reach? → A: Full rename —
  every tool/script name, error tag, JSON field name, and test/fixture path coined by feature
  004 alongside the directory is also renamed to "library" terminology, for full naming
  consistency with zero "content" residue anywhere in the tooling.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Shared files live under the new directory name (Priority: P1)

A framework maintainer renames the shared-files directory so that every file currently under
`.highway/content/templates/`, `.highway/content/knowledge/`, and `.highway/content/governance/`
is found, unchanged in content, at the same relative position under
`.highway/library/templates/`, `.highway/library/knowledge/`, and `.highway/library/governance/`
— and `.highway/content/` no longer exists.

**Why this priority**: This is the rename itself; every other story depends on the directory
having already moved.

**Independent Test**: Can be fully tested by confirming `.highway/content/` is absent,
`.highway/library/{templates,knowledge,governance}/` exist, and every file that existed under
the old tree exists byte-for-byte under the corresponding new path.

**Acceptance Scenarios**:

1. **Given** the repository before this feature, **When** the rename is applied, **Then**
   `.highway/content/` does not exist and `.highway/library/templates/`,
   `.highway/library/knowledge/`, `.highway/library/governance/` exist with the same file
   contents as before, just relocated.
2. **Given** the renamed directory, **When** a new shared file is added under
   `.highway/library/knowledge/`, **Then** it is discovered and validated the same way a file
   under the old `.highway/content/knowledge/` was before the rename (no functional regression).

---

### User Story 2 - Tooling resolves the new location (Priority: P1)

A skill author declares `metadata.dependencies` pointing at a `library/...`-relative path, and a
framework maintainer runs the discovery/catalog generator — both resolve against
`.highway/library/`, not `.highway/content/`, with no residual behavior tied to the old path.

**Why this priority**: Equal to User Story 1 — a moved directory the tooling cannot find is a
regression, not a rename.

**Independent Test**: Can be fully tested by pointing a skill's `metadata.dependencies` entry at
a `library/...` path and confirming validation resolves it; and by running the catalog generator
and confirming its output lists every file under the new tree.

**Acceptance Scenarios**:

1. **Given** a skill with `metadata.dependencies: [{path: library/knowledge/foo.md, version:
   1.0.0}]` and a matching file at `.highway/library/knowledge/foo.md` version `1.0.0`, **When**
   the skill is validated, **Then** validation passes with no dependency finding.
2. **Given** the same skill but with `metadata.dependencies` still pointing at
   `content/knowledge/foo.md` (the pre-rename path), **When** the skill is validated, **Then**
   validation reports the dependency path does not exist (the old path is not silently
   honored).
3. **Given** any number of files under `.highway/library/`, **When** a maintainer requests the
   discovery listing, **Then** every file appears in the generated catalog with no reference to
   the old `.highway/content/` path anywhere in the output.

---

### User Story 3 - Documentation reflects the new name (Priority: P2)

A new contributor reading `.highway/tools/README.md`, `.highway/catalog/README.md`, and the
per-directory `README.md` files under `.highway/library/` sees only the new "library" name and
its current paths — nothing that says "content" and points at a path that no longer exists.

**Why this priority**: Lower than P1 because it doesn't change behavior, but a maintainer-facing
doc that names a path that no longer exists actively misleads the next contributor, which is a
real cost even though nothing crashes.

**Independent Test**: Can be fully tested by grepping the live (non-historical) docs and tooling
comments for the literal string `.highway/content` and confirming zero matches outside of files
that are explicitly historical records (see Out of Scope).

**Acceptance Scenarios**:

1. **Given** `.highway/tools/README.md` and `.highway/catalog/README.md`, **When** a
   contributor reads them, **Then** every path they name that exists under the renamed tree uses
   `.highway/library/...`, and every command example they show runs successfully as written.

---

### Edge Cases

- What happens to the previously generated `content-index.json` / `content-index.md` catalog
  artifacts? They are removed and replaced by newly generated `library-index.json` /
  `library-index.md`; the old filenames must not be left behind alongside the new ones.
- What happens to a skill's `metadata.dependencies` entry that still names the old
  `content/...` path after the rename? It must fail validation naming the (now nonexistent)
  path, exactly like any other missing dependency — no automatic path translation or silent
  fallback (FR-004).
- What happens to historical spec/plan/contract documents under `specs/004-shared-content-library/`
  that describe the directory by its original name? They are a historical record of what feature
  004 built and are explicitly out of scope for editing (see Out of Scope) — this mirrors how
  earlier features' spec directories in this repository are never renamed after the fact even
  when the runtime artifacts they describe later evolve.
- What happens to the generic English word "content" used elsewhere in the repository with no
  relation to this directory (e.g., "body content", "content quality checks")? It is explicitly
  untouched — only the identifiers and paths that denote this specific directory/feature are in
  scope.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The directory tree currently at `.highway/content/` (including `templates/`,
  `knowledge/`, `governance/`, and every file inside them) MUST be relocated to
  `.highway/library/` with identical file contents and identical relative structure.
- **FR-002**: `.highway/content/` MUST NOT exist after this feature is complete.
- **FR-003**: Every runtime tool that resolves a shared-file path (dependency validation, content
  discovery/catalog generation) MUST resolve against `.highway/library/`, not
  `.highway/content/`.
- **FR-004**: A `metadata.dependencies` entry naming a path under the old `content/...` prefix
  MUST fail validation (reported as a missing dependency), not be silently translated to the new
  `library/...` path.
- **FR-005**: Every currently-passing automated test in `.highway/tools/tests/` MUST continue to
  pass after the rename, updated only insofar as they refer to the renamed paths.
- **FR-006**: Every live (non-historical) document that names the old `.highway/content/` path —
  at minimum `.highway/tools/README.md` and `.highway/catalog/README.md` — MUST be updated to
  name the new `.highway/library/` path instead.
- **FR-007**: Historical spec documents under `specs/004-shared-content-library/` (spec, plan,
  research, data-model, contracts, tasks, quickstart) MUST NOT be edited by this feature; they
  remain a record of what feature 004 built under its original name.
- **FR-008**: The generated catalog artifact filenames (`content-index.json` /
  `content-index.md`), the validator/generator script names (`validate-content.sh`,
  `generate-content-catalog.sh`), the shared library (`lib/content-schema.sh`), the
  `[CONTENT-TYPE]` error tag, and the `content_type` field in the catalog schema MUST all be
  renamed to use "library" terminology, for full naming consistency with the new directory name
  and zero "content" residue anywhere in the tooling.
- **FR-009**: Every test file and fixture path under `.highway/tools/tests/` that names
  "content" specifically to refer to this feature (e.g. `validate-content.test.sh`,
  `generate-content-catalog.test.sh`, `tests/fixtures/content/`) MUST be renamed to the matching
  "library" name, and every in-file reference to the renamed scripts/tags/fields MUST be updated
  to match (FR-008).

### Key Entities *(include if feature involves data)*

- **Shared Content File** (data-model.md, feature 004): unchanged in shape; its `path` field's
  example values move from a `content/...`-rooted path to a `library/...`-rooted path.
- **Catalog artifact**: the generated discovery listing; renamed on disk from
  `content-index.json`/`.md` to `library-index.json`/`.md` (FR-008).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `find .highway/content` reports the path does not exist; `find .highway/library`
  lists the same set of files (by relative path and content) that previously existed under
  `.highway/content`.
- **SC-002**: 100% of tests under `.highway/tools/tests/` pass after the rename (`run-all.sh`
  exits 0).
- **SC-003**: A dependency declared with a `library/...` path resolves; the same path expressed
  with the old `content/...` prefix fails validation, in a single validation run, with zero
  manual path translation required by the skill author.
- **SC-004**: Zero occurrences of the literal string `.highway/content` remain in any live
  (non-historical, per FR-007) file in the repository.

## Assumptions

- The rename is a pure relocation/rename: no file's content, frontmatter, or validation rules
  change as part of this feature — only paths and the tool/script/tag/field names named in
  FR-008.
- No skill in the repository currently declares a `metadata.dependencies` entry (confirmed by
  the current codebase), so there is no in-repo consumer to migrate; this feature only has to
  keep the mechanism itself correct.
- No external tooling outside this repository consumes the previously-generated
  `content-index.json` (feature 004 shipped with an empty catalog and stated real content
  authoring was out of scope), so there is no external backward-compatibility concern.
- Historical spec directories in this repository (e.g. `specs/001-...`, `specs/004-...`) are
  never renamed or edited to match later renames of the runtime artifacts they describe — this
  feature's own spec/plan/contracts are the place new naming decisions are recorded going
  forward, matching existing precedent in this repository.

## Out of Scope

- Editing any file under `specs/001-multi-agent-skill-suite/`, `specs/002-highway-folder-consolidation/`,
  `specs/003-constitution-enforcement/`, or `specs/004-shared-content-library/` — those directories
  are historical records of prior features and are not touched by this rename (FR-007).
- Renaming the skill catalog (`.highway/catalog/index.json` / `index.md`) or
  `.highway/skills/` — this feature only concerns the shared-content directory feature 004
  introduced.
- Authoring any real template/knowledge/governance content — `.highway/library/` (like
  `.highway/content/` before it) remains empty of real content; this feature only renames the
  scaffold.
- Adding backward-compatibility for the old `content/...` dependency path prefix (FR-004) —
  this is a rename, not a migration with a deprecation period.

