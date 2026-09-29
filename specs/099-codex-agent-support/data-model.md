# Data Model: Codex as a Supported Agent

## Supported agent

The set is `github-copilot`, `claude-code`, `cursor`, `codex`.

`all` in a skill's `compatibility` field means every member of this set. Publishing does not read
that field when choosing destinations. A skill reaches Codex when it reaches the other three.

## Codex skill

| Field | Rule |
|---|---|
| Source | `.highway/skills/<id>/SKILL.md` |
| Path | `.agents/skills/<id>/SKILL.md` |
| Bytes | Identical to the source and to the GitHub Copilot, Claude Code, and Cursor copies |
| Manifest | One row in `.highway/tools/.adapter-manifest`: path, skill id, version, sha256 |
| Distribution | `include` `.agents/skills/<id>` for each Highway skill. `exclude` `.agents` covers everything else under that tree |

The current Highway ids are `highway-objectives`, `highway-help`, `highway-controls`,
`highway-inquiry`, `highway-nfrs`, `highway-profile`, `highway-relationships`, `highway-setup`,
`highway-new`, `highway-discovery`, `highway-clarify`, and `highway-adr`.

`speckit-*` names are not sources and are not written under `.agents/skills/`.

## Codex repository guidance

| Field | Rule |
|---|---|
| Path | `AGENTS.md` at the repository root |
| Bytes | Identical to `.claude/CLAUDE.md` and `.github/copilot-instructions.md` |
| One instruction | The file equals that instruction body |
| No instructions | The file is one newline |
| Manifest | One row in `.highway/tools/.instruction-manifest`: path `AGENTS.md`, id equal to the other merged rows, sha256 |
| Distribution | One `include` row for `AGENTS.md` |

The id field is the source ids in `LC_ALL=C` filename order, joined by commas, or `-` when there
are no sources.

## State of a generated Codex file

| State | Publisher |
|---|---|
| Absent | Create the file and set the row |
| Present, hash matches its row | Rewrite the same bytes |
| Present, hash differs, or present with no row | Exit non-zero, name the file, write nothing else in that run |

Removing a skill source does not delete `.agents/skills/<id>/SKILL.md` or its adapter-manifest
row. The correspondence check reports that orphan. Removing an instruction source updates
`AGENTS.md` on the next successful instruction publish, together with the other merged files,
and does not delete skill files.

## Relationships

- One Highway skill has one Codex skill file, one adapter-manifest row, and one distribution include.
- `AGENTS.md` has one instruction-manifest row and one distribution include.
- `AGENTS.md` and the other two merged files are the same bytes.
- A Codex skill file is not an input to instruction publishing. `AGENTS.md` is not an input to skill publishing.
