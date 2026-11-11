# Data Model: Standard Alignment highway-experience

The entities are files and the records that point at them. No database is involved.

## highway-experience (skill folder)

| Field | Value |
|---|---|
| Location | `skills/highway-experience/`; shipped at `.highway/skills/highway-experience/`; copied to each declared agent tree |
| Files | `SKILL.md`, `references/highway-identity.md`, `references/experience-standard.md`, `references/storage-contract.md`; nothing else |
| Frontmatter | `name: highway-experience`, a `description` for its supporting role, a `usage` naming `/highway-experience`, `compatibility: all`, `metadata.version: 1.0.0` |
| Body | The eight required sections plus `## Procedure` with two steps: `### Activated by a skill` and `### Invoked directly` |
| Relationships | Activated by name by every other Highway skill; never activates itself |

Validation: passes `framework/validate-skill.sh`; has a catalog entry, four agent copies of each of its
four files, adapter-manifest rows for all sixteen copies, and an included distribution row per agent tree.

## Reference files

| Reference | Source before | Content rule |
|---|---|---|
| `references/highway-identity.md` | `.highway/library/knowledge/highway-identity.md` | Byte-identical |
| `references/experience-standard.md` | `.highway/governance/experience-standard.md` | Byte-identical; version stays `11.1.0` |
| `references/storage-contract.md` | `.highway/governance/storage.md` | Same meaning, plus the contract in [contracts/storage-contract.md](contracts/storage-contract.md); version `1.1.0` |

## Storage record (project file)

| Field | Value |
|---|---|
| Path | `library/knowledge/storage.md`, relative to the repository root |
| Holds | The project's storage mode, and later the Remote settings |
| Absent | The skill uses Local |
| Names Local | The skill uses Local |
| Names another mode | The skill stops before any other repository read or write and says the mode is not supported yet |
| Written by | Nothing in Phase 7; highway-setup seeds it in Phase 8 |

## Activation step

| Field | Value |
|---|---|
| Text | `Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.` |
| Position | First non-blank line under `## Procedure` |
| Present in | All 15 existing skills; not highway-experience |
| Checked by | `tests/experience-activation.test.sh` (text and position), the harness invariant (load order) |

## Drive result (harness)

| Field | Type | Meaning |
|---|---|---|
| `skillsInvoked` | `string[]` | Every skill invoked during the attempt, in order (unchanged) |
| `skillsBeforeOutput` | `string[]` | The skills invoked before the first output the person sees; every skill invoked when nothing was shown |

First output: the first question sent to the person, or the first top-level assistant message with
non-empty content and no tool requests.

State transition per attempt: `no output yet` → (question or plain message) → `output seen`. Skill
invocations are added to `skillsBeforeOutput` only in the first state.

## Removed

`.highway/instructions/highway-agent-context.md`, `framework/generate-instructions.sh`,
`framework/.instruction-manifest`, `AGENTS.md`, `.cursor/rules/highway-agent-context.mdc`,
`.claude/CLAUDE.md`, `.github/copilot-instructions.md`, `.highway/governance/` (emptied by the moves),
`tests/generate-instructions.test.sh`, `tests/instruction-coverage.test.sh`.
