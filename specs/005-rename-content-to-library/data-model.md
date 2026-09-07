# Data Model: Rename Shared Content Directory to Library

This feature's "data" is the rename mapping itself — a closed table of what moves, what is
renamed, and what is explicitly left alone — plus the two entities carried over from feature
004 whose field values (not shape) change as a result.

## Entity: Rename Mapping

Every row is exhaustive within its category; nothing outside these rows is renamed by this
feature.

### Directories

| Old path | New path |
|---|---|
| `.highway/content/` | `.highway/library/` |
| `.highway/content/templates/` | `.highway/library/templates/` |
| `.highway/content/knowledge/` | `.highway/library/knowledge/` |
| `.highway/content/governance/` | `.highway/library/governance/` |
| `.highway/tools/tests/fixtures/content/` | `.highway/tools/tests/fixtures/library/` |

### Scripts and libraries

| Old path | New path | Internal rename |
|---|---|---|
| `.highway/tools/validate-content.sh` | `.highway/tools/validate-library.sh` | `content_type` var → `library_type`; `content_file` var → `library_file` |
| `.highway/tools/generate-content-catalog.sh` | `.highway/tools/generate-library-catalog.sh` | `CONTENT_DIR` → `LIBRARY_DIR`; `content_files` → `library_files`; `content_type_of` → `library_type_of` |
| `.highway/tools/lib/content-schema.sh` | `.highway/tools/lib/library-schema.sh` | `cs_validate_name` → `ls_validate_name`; `cs_validate_description` → `ls_validate_description` |

### Tests

| Old path | New path |
|---|---|
| `.highway/tools/tests/validate-content.test.sh` | `.highway/tools/tests/validate-library.test.sh` |
| `.highway/tools/tests/generate-content-catalog.test.sh` | `.highway/tools/tests/generate-library-catalog.test.sh` |
| `.highway/tools/tests/dependency-check.test.sh` (filename unchanged) | same path; its `TARGET_REL` fixture path constant changes from a `content/...`-rooted value to a `library/...`-rooted value |

### Generated artifacts

| Old filename | New filename |
|---|---|
| `.highway/catalog/content-index.json` | `.highway/catalog/library-index.json` |
| `.highway/catalog/content-index.md` | `.highway/catalog/library-index.md` |

### Identifiers (tags and fields)

| Old identifier | New identifier | Where |
|---|---|---|
| `[CONTENT-TYPE]` error tag | `[LIBRARY-TYPE]` | `validate-library.sh` |
| `content_type` JSON field | `library_type` | catalog schema, generator, and any consumer |

### Explicitly untouched (verified, not renamed)

| Identifier | Why it stays |
|---|---|
| `[SCHEMA]` error tag | Generic, shared with skill validation; does not derive from "content". |
| `con_*` prefix (`constitution.sh`) | Stands for "constitution", not "content". |
| `fm_*` prefix (`frontmatter.sh`) | Stands for "frontmatter". |
| `rc_*` prefix (`rule-checks.sh`) | Stands for "rule-checks". |
| `dc_*` prefix (`dependency-check.sh`) | Stands for "dependency-check". |
| `bs_*` / `sv_*` prefixes | Stand for "body-scan" / "schema-validate". |
| `name`, `description`, `version` schema fields | Generic field names, not "content"-derived. |
| `template` / `knowledge` / `governance` enum values | Content-type category names, not the word "content" itself. |
| `metadata.dependencies`, `[DEPENDENCY]` tag | Governs a skill's dependency declarations generally; unrelated to the directory's name. |
| `specs/001-...` through `specs/004-...` (all files) | Historical records of prior features (FR-007); never edited by a later feature. |

## Entity: Shared Content File (carried over from feature 004, shape unchanged)

Defined in `specs/004-shared-content-library/data-model.md`; this feature changes none of its
fields, validation rules, or required frontmatter. Only the value space of its `path` field
shifts: an example that previously read `content/knowledge/foo.md` now reads
`library/knowledge/foo.md`, because the field is framework-relative (relative to `.highway/`)
and the framework-relative root moved.

## Entity: Catalog Entry (carried over from feature 004, one field renamed)

| Field | Feature 004 name | This feature's name | Change |
|---|---|---|---|
| Category | `content_type` | `library_type` | Renamed (Rename Mapping, Identifiers). |
| Display name | `name` | `name` | Unchanged. |
| Summary | `description` | `description` | Unchanged. |
| Version | `version` | `version` | Unchanged. |
| Location | `source_path` | `source_path` | Unchanged in name; its value space shifts the same way `path` does above. |
