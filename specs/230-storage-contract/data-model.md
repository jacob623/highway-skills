# Data Model: Storage Contract

## Storage contract

File: `.highway/governance/storage.md`. Shipped. No frontmatter. Version line `1.0.0`.

| Element | Content |
|---|---|
| Scope | A skill reaches the repository only through the four operations. A later mode fills its column; skills do not change. |
| Paths | Every path is relative to the repository root. |
| Modes | Local (supported), Remote (Option A), Chat (Option B). |
| Operations table | Four rows by three mode columns. |
| What a skill does not do | Run a script, run `git`, use an absolute path, decide from a file's time. Written file content is excluded. |

### Operation

| Operation | Local entry |
|---|---|
| Read a file | Reads the file at the path in the working tree. An absent file is reported as absent. |
| Check a file exists | Reports whether a file is at the path in the working tree. |
| List a folder | Returns the names directly inside the folder in the working tree. An absent folder lists nothing. |
| Write a group of files together | Writes each file in the group to the working tree. Nothing is committed. The person handles any git step. A failed write names the files already written and the file that failed. |

Remote and Chat entries read `not supported yet` in every row.

## Constitution rule P2.6

| Field | Value |
|---|---|
| ID | P2.6 |
| Rule | A skill MUST reach the repository only through the operations `.highway/governance/storage.md` declares. |
| Observable | Outside fenced blocks, the skill names no `.highway/tools/` path or script file, no `git` command, no absolute path, and no file time. Written file content is excluded. |
| Tier | `[auto]` |
| Check | `rc_check_P2_6` in `.highway/tools/lib/rule-checks.sh`, N/A condition `-`, library-exempt |

## Features table

File: `code/<folder>/.highway/metadata.md`, template `codify-metadata.md` 2.0.0.

| Column | Value | Source |
|---|---|---|
| ID | Three-digit feature number, `001` first | The next integer after the last row's ID |
| Folder | `<number>-<action>` | The feature folder under `.highway/features/` |
| Title | The automation title | `# <automation title>` in that feature's `codify.md` |
| Summary | One sentence | `## Summary` in that feature's `codify.md` |

Rules:

- One row per accepted feature, in acceptance order.
- A row is appended in the same write group as `codify.md` and the `code/code.md` row.
- A row is never removed or changed, so an ID is never reused.
- No status column.

### Lifecycle

1. New product accepted: `metadata.md` is written with frontmatter `id`, the product title, and a Features table with row `001`.
2. Feature accepted for a joined product: the file is read, the next ID is the last ID plus one, and one row is appended.
3. A finished feature leaves the `code/code.md` Features cell: its Features table row stays.
