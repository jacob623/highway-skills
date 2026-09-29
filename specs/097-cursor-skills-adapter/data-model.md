# Data Model: Deliver Highway Skills to Cursor as Skills, Not Rules

This feature changes file-delivery records, not application data. The entities below are the
tracked files and records the change reads or rewrites.

## Entities

### Skill source

`.highway/skills/<id>/SKILL.md`. The single origin of every deliverable. Unchanged by this feature.

| Field | Notes |
|---|---|
| `id` | Directory name; equals frontmatter `name`; the full agent-facing id (for example `highway-help`) |
| frontmatter | `name`, `description`, `usage`, `compatibility`, `metadata.version` |
| body | Markdown sections |

### Agent target row (generator configuration)

One position across three parallel single-line arrays in `generate-agent-adapters.sh`.

| Field | Before (Cursor) | After (Cursor) |
|---|---|---|
| `AGENT_IDS` entry | `cursor` | `cursor` (unchanged) |
| `AGENT_TARGET_TEMPLATES` entry | `.cursor/rules/%s.mdc` | `.cursor/skills/%s/SKILL.md` |
| `AGENT_TRANSFORMS` entry | `mdc-transform` | `identity-copy` |

Validation rules: the three arrays stay the same length and each stays on one line. Every template
contains exactly one `%s`, replaced by the skill id.

### Cursor deliverable

The generated file Cursor reads for one skill.

| Attribute | Before | After |
|---|---|---|
| Path | `.cursor/rules/<id>.mdc` | `.cursor/skills/<id>/SKILL.md` |
| Frontmatter | `description`, `alwaysApply: false` only | All source fields, unchanged |
| Body | Source body, re-emitted | Source body, unchanged |
| Equality | Differs from the other two agents' files | Byte-identical to `.claude/skills/<id>/SKILL.md` and `.github/skills/<id>/SKILL.md` |

Cardinality: exactly one per source skill (12 today).

### Adapter manifest row

Tab-delimited line in `.highway/tools/.adapter-manifest`.

| Field | Meaning |
|---|---|
| 1 path | Repository-relative path of one generated file |
| 2 skill id | The skill the file was produced from |
| 3 version | `metadata.version` at generation |
| 4 hash | sha256 of the file as generated |

Change: the 12 rows whose path begins `.cursor/rules/` are removed; 12 rows whose path begins
`.cursor/skills/` are added, each carrying the same hash as the skill's Claude Code row (because
the files are byte-identical). Rows for `.github/`, `.claude/` and the 12 `.mock-agent-4` rows are
preserved unchanged.

Invariant: a row exists for a path only while that file exists, and its hash matches the file
unless the file has been hand-edited (which the generator refuses to overwrite).

### Distribution manifest row

Tab-delimited line in `.highway/tools/.distribution-manifest`: classification, source, destination.

Change: 12 rows `include<TAB>.cursor/rules/<id>.mdc<TAB>-` are replaced by 12 rows
`include<TAB>.cursor/skills/<id><TAB>-`. The row `exclude<TAB>.cursor<TAB>-` is unchanged and
still covers `.cursor/skills/speckit-*`.

### Legacy rule file

A file under `.cursor/rules/` that the migration may act on. Its state decides the outcome.

| State | Definition | Migration action |
|---|---|---|
| `TRACKED_CLEAN` | Has an adapter manifest row and its sha256 equals the recorded hash | Delete file, delete row |
| `TRACKED_EDITED` | Has a row, file exists, hash differs | Keep file and row; report; result incomplete |
| `TRACKED_MISSING` | Has a row, file does not exist | Delete row; report |
| `ORPHAN_CLEAN` | The single named leftover exists and its sha256 equals `60826b12...7392` | Delete file |
| `ORPHAN_EDITED` | The named leftover exists and its hash differs | Keep; report; result incomplete |
| `ORPHAN_ABSENT` | The named leftover does not exist | Nothing to do |
| `FOREIGN` | Any other file under `.cursor/rules/` | Never read, never touched |

State transitions across runs: `TRACKED_EDITED` or `ORPHAN_EDITED` become `TRACKED_CLEAN` or
`ORPHAN_CLEAN` if the maintainer restores the recorded content, or leave the migration's scope if
the maintainer deletes the file (`TRACKED_MISSING` then clears its row; `ORPHAN_ABSENT` needs
nothing). Any state ending in a deleted file and dropped row is terminal, so a repeat run is a no-op.

### Spec Kit skill

`.cursor/skills/speckit-*/`. Owned by the Spec Kit integration, untracked by the adapter manifest,
excluded from the distribution. The generator and the migration never create, modify or delete one.

## Relationships

- Skill source (1) to Cursor deliverable (1) to Adapter manifest row (1) to Distribution manifest
  row (1): a chain that must be complete for every source skill (D4.5) and must name no absent
  skill (D4.6).
- Cursor deliverable equals Claude Code deliverable, byte for byte.
- Legacy rule file (0..13) is retired by the migration; no legacy rule file corresponds to a
  Cursor deliverable after migration.
