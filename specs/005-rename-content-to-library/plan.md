# Implementation Plan: Rename Shared Content Directory to Library

**Branch**: `005-rename-content-to-library` | **Date**: 2026-09-07 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/005-rename-content-to-library/spec.md`

## Summary

Rename `.highway/content/` to `.highway/library/` (directories and every file inside them,
moved with `git mv` to preserve history) and, per the resolved clarification (full rename),
carry the same rename through every tool/script name, error tag, JSON field name, and
test/fixture path that feature 004 coined using the word "content" to denote this concept:
`validate-content.sh`→`validate-library.sh`, `generate-content-catalog.sh`→
`generate-library-catalog.sh`, `lib/content-schema.sh`→`lib/library-schema.sh` (and its
`cs_*` function prefix → `ls_*`), the `[CONTENT-TYPE]` tag→`[LIBRARY-TYPE]`, the catalog's
`content_type` field→`library_type`, `content-index.json`/`.md`→`library-index.json`/`.md`, and
the `tests/fixtures/content/` tree and its two content-specific test files. Identifiers that do
not stand for "content" (`con_*` in constitution.sh, `fm_*`, `rc_*`, `dc_*`, `bs_*`, `sv_*`, the
shared `[SCHEMA]` tag, and the `name`/`description`/`version` schema fields) are left untouched.
Historical spec documents under `specs/001-...` through `specs/004-...` are not edited
(FR-007); the two contracts whose shape genuinely changes (validation output tag, catalog
schema field/filename) are added fresh under this feature's own `contracts/` directory instead.

## Technical Context

**Language/Version**: Bash 3.2-compatible shell, with `awk`, `sed`, `grep`, and `git`. No new
language runtime.

**Primary Dependencies**: None added. This feature renames existing `.highway/tools/` shell
tooling built by features 003 and 004; it introduces no new library.

**Storage**: N/A. The only persisted state is the generated catalog, which continues to be
regenerated in full on each run under its new filename (no partial writes on failure, carried
over from feature 004's precedent).

**Testing**: The existing harness at `.highway/tools/tests/run-all.sh`, which discovers and
runs every `*.test.sh` and returns non-zero if any fails.

**Target Platform**: macOS default shell (bash 3.2.57) as the floor; must also run on Linux
bash 4+. No associative arrays, no `mapfile`, no `${var,,}` (carried over from feature 004).

**Project Type**: Single project. Command-line shell tooling in one directory.

**Performance Goals**: Validation of one library file and generation of the library listing
complete under 2 seconds each on the reference platform, matching feature 004's existing
budget (this feature changes no algorithm, only names).

**Constraints**:
- This is a pure rename: no file's content, frontmatter, or validation rule changes as part of
  this feature, other than the specific identifiers named in FR-008/FR-009.
- Renames are performed with `git mv` (or an equivalent that git records as a rename), since
  every file this feature moves is already committed history (feature 004 was merged to
  `main`), and a delete+recreate would discard that history for no benefit.
- Historical spec directories (`specs/001-...` through `specs/004-...`) are never edited by
  this feature (FR-007) — carried over as an explicit constraint, not just an assumption.
- SC-004 requires a scriptable, zero-residue check (`grep` for the literal string
  `.highway/content` across live files), not a manual review pass.

**Scale/Scope**: One directory tree (3 subdirectories, 3 README files) moved; 2 tool scripts,
1 library file, 2 test files, and 1 fixture tree renamed; 3 live docs
(`.highway/tools/README.md`, `.highway/catalog/README.md`, and the three moved per-directory
READMEs) updated; 2 new contract files added under this feature's own `contracts/` directory.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The constitution governs skills. This feature renames shell tooling, a directory, and
documentation, and authors no skill content and no shared library content (populating
`.highway/library/` remains out of scope, carried over from feature 004). The skill-facing
principles therefore do not apply to this feature's own output; the table below records that
and evaluates the principles that do bear on tooling work, the same way feature 004's plan did.

| Principle | Status | Notes |
|---|---|---|
| I. Unambiguous, Actionable Directives | N/A | No skill content is authored. |
| II. Technology-Agnostic Portability | N/A | No skill content is authored. |
| III. Grounding in Approved Authority Sources | N/A | No skill content is authored. |
| IV. Measurable Quality Gates | PASS | Every success criterion in the spec is a count, an existence check, or a test-suite exit status (SC-001 through SC-004). |
| V. Reusable Patterns and Defined Error Handling | PASS | The rename is executed and verified by named, repeatable commands (`git mv`, `grep` for residue, `run-all.sh`), not manual review; a failure of any of these is a defined, non-silent stop. |
| VI. Deterministic, Explicit Decision Criteria | PASS | The rename mapping (old name/path → new name/path, and the fixed list of identifiers explicitly left untouched) is a closed table in data-model.md, not left to per-file discretion. |
| VII. Long-Term Maintainability | PASS | No rule content or check logic is duplicated or rewritten; `con_*`, `fm_*`, `rc_*`, `dc_*`, `bs_*`, `sv_*` and the checks they implement are untouched — only names and paths change. |
| VIII. Reliability and Repeatability | PASS | The renamed catalog generator's output for given inputs still depends only on those inputs and the constitution; no new clock or environment default is introduced. |

**Gate result**: PASS. No violations to justify; Complexity Tracking is not required.

## Project Structure

### Documentation (this feature)

```text
specs/005-rename-content-to-library/
├── plan.md                          # This file
├── research.md                      # Phase 0 output
├── data-model.md                    # Phase 1 output: rename mapping + carried-over entities
├── quickstart.md                    # Phase 1 output
├── contracts/
│   ├── library-validation-output.md    # Phase 1 output: supersedes content-validation-output.md's
│   │                                    #   tag/field shape for the renamed validator
│   └── library-catalog.schema.json     # Phase 1 output: supersedes content-catalog.schema.json's
│                                        #   field/filename shape for the renamed catalog
└── tasks.md                         # Phase 2 output (/speckit-tasks — NOT created here)
```

Note: `specs/004-shared-content-library/contracts/dependency-validation-output.md` is not
superseded — the `[DEPENDENCY]` tag and message shape it governs do not change in this feature
(FR-008 names only the content-type tag, field, script, and catalog filenames), so
`dependency-check.sh` continues to cite that existing contract unchanged.

### Source Code (repository root)

```text
.highway/
├── library/                          # renamed from content/ via git mv
│   ├── templates/README.md           # renamed + prose updated (content/ -> library/, and its
│   │                                  #   validate-content.sh link -> validate-library.sh)
│   ├── knowledge/README.md           # renamed + prose updated
│   └── governance/README.md          # renamed + prose updated
├── tools/
│   ├── validate-skill.sh                    # updated: one comment line's path only
│   ├── validate-library.sh                  # renamed from validate-content.sh; content_type
│   │                                         #   variable -> library_type; [CONTENT-TYPE] ->
│   │                                         #   [LIBRARY-TYPE]; path match content/* -> library/*
│   ├── generate-library-catalog.sh          # renamed from generate-content-catalog.sh;
│   │                                         #   CONTENT_DIR -> LIBRARY_DIR; content-index.* ->
│   │                                         #   library-index.*; content_type field -> library_type
│   ├── lib/
│   │   ├── library-schema.sh                # renamed from content-schema.sh; cs_* -> ls_*
│   │   ├── dependency-check.sh              # unchanged (no "content"-specific identifiers)
│   │   ├── frontmatter.sh                   # unchanged (fm_get_dependencies has no such identifiers)
│   │   └── rule-checks.sh                   # unchanged (rc_template_exempt_ids has no such identifiers)
│   ├── tests/
│   │   ├── fixtures/library/                # renamed from fixtures/content/ (contents unchanged
│   │   │                                    #   except embedded content-type-detection prose)
│   │   ├── validate-library.test.sh         # renamed from validate-content.test.sh
│   │   ├── generate-library-catalog.test.sh # renamed from generate-content-catalog.test.sh
│   │   ├── dependency-check.test.sh         # updated: target path uses library/... not content/...
│   │   └── run-all.sh                       # unchanged (auto-discovers *.test.sh)
│   └── README.md                            # updated: library table rows + script sections renamed
├── catalog/
│   ├── library-index.json                  # renamed output of generate-library-catalog.sh
│   ├── library-index.md                    # renamed output of generate-library-catalog.sh
│   └── README.md                            # updated: artifact names + contract link renamed
```

**Structure Decision**: Single project, renaming in place within the existing `.highway/`
tree. No new top-level project; `.highway/library/` occupies the same position
`.highway/content/` did, as a sibling of `.highway/skills/`, `.highway/tools/`, and
`.highway/catalog/`.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

Not applicable. The Constitution Check gate passed with no violations.

