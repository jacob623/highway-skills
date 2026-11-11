# Data Model: Standard Alignment Removals

## Skill catalog (`.highway/catalog/index.json`)

Written by `.highway/tools/generate-catalog.sh` from each `.highway/skills/<id>/SKILL.md`. Read by
highway-help and by `adapter-coverage.test.sh` (D4.5, D4.6).

### Before

```json
{
  "generated_at": "<UTC timestamp>",
  "entries": [ { ...entry... } ],
  "overlap_flags": []
}
```

The generator also wrote `.highway/catalog/index.md`, a Markdown table of the same entries plus an
"Overlap Flags" section.

### After

```json
{
  "entries": [ { ...entry... } ]
}
```

With no skills, the file is `{"entries": []}` in the same layout. `index.md` is not written.

### Entry (unchanged)

| Field | Source | Rule |
|---|---|---|
| `id` | the skill's directory name | equals the frontmatter `name` |
| `name` | frontmatter `name` | |
| `description` | frontmatter `description` | |
| `usage` | frontmatter `usage` | |
| `compatibility` | frontmatter `compatibility` | `all` when absent |
| `version` | frontmatter `metadata.version` | MAJOR.MINOR.PATCH |
| `source_path` | `skills/<id>/SKILL.md` | |

Entries keep directory order from the shell glob, as before.

### Validation rules

- Two runs over unchanged skill sources produce byte-identical files (FR-005, D4.2).
- An invalid skill aborts the run and leaves the existing file unchanged, as before.
- The file has no `generated_at` key and no `overlap_flags` key (FR-004).

## Removed entities

| Entity | Files | Replacement |
|---|---|---|
| Library index | `.highway/catalog/library-index.json`, `library-index.md` | None. Later phases move the library's contents into skills |
| Human-readable skill catalog | `.highway/catalog/index.md` | None. `index.json` is the only catalog |
| Overlap record | the `overlap_flags` array | None. P7.3 decides overlap at authoring time (research R4) |
