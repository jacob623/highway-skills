# Contract: highway-setup seeding

## Assets

`skills/highway-setup/assets/` holds exactly these 12 files (research R1). `hw_seeded` in
`framework/lib/paths.sh` lists the same pairs, one `<asset>\t<project path>` line each, in this order.

| Asset | Project file |
| --- | --- |
| `request-catalog.md` | `requests/requests.md` |
| `discovery-catalog.md` | `discoveries/discoveries.md` |
| `adr-catalog.md` | `adrs/adrs.md` |
| `architecture-catalog.md` | `architectures/architectures.md` |
| `implementation-catalog.md` | `implementations/implementations.md` |
| `capability-catalog.md` | `implementations/capabilities.md` |
| `codify-catalog.md` | `code/code.md` |
| `codify-integrations.md` | `code/integrations.md` |
| `codify-platforms.md` | `library/coding-standards/codify-platforms.md` |
| `coding-standards-catalog.md` | `library/coding-standards/coding-standards.md` |
| `assessment-findings.md` | `library/knowledge/assessment-findings.md` |
| `storage.md` | `library/knowledge/storage.md` |

A catalog skeleton:

- is the retired template's `## File Frontmatter` fence content (when it has one), a blank line, then its
  `## Catalog Structure` or `## Body` fence content;
- holds no line with a `<placeholder>` and no table row after the header separator;
- is byte-identical to the file seeded into a project.

`storage.md`:

```markdown
# Storage

Mode: Local
```

## Seed step

highway-setup's Procedure gains `### Seed` before `### Welcome`:

- It runs first in every run, after the storage contract's mode check.
- For each asset, when its project file is absent, it writes the file from the asset. All absent files are
  written as one group.
- It never changes a file that exists.
- It emits nothing.
- A failed write stops setup without the welcome, says which file could not be written, and says what the
  person can do next.

Outputs replaces "No repository file written by Setup." with the seeded files, citing `assets/`.
Verification replaces "Setup writes no repository file." with lines that seeding writes only absent
seeded files, changes no existing file, and shows nothing.

## Not seeded

The objective, control, and NFR catalogs. Their templates live in their skills' `assets/`.
