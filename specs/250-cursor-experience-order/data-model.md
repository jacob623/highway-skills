# Data Model: Cursor Experience Order

## Activation signal (Cursor)

| Field | Meaning |
| --- | --- |
| Source | `tool_call` stream event (`SDKToolUseMessage`) |
| Skill id | Directory name under `…/skills/<skill-id>/` in the tool path/args, or an explicit skill field when present |
| Experience activation | Approved read whose path matches `/(^|\/)highway-experience\/SKILL\.md$/` (shared `isExperienceSkillRead`), and/or skill id `highway-experience` recorded before first person-visible output |
| Not a skill id | The path segment `skills` immediately after `…/highway/` (false positive from the old regex) |

## Path normalization

| Input path shape | Normalized form |
| --- | --- |
| Absolute or relative path containing `.cursor/plugins/local/highway/<suffix>` | `join(readRoot, <suffix>)` where `readRoot` is the attempt’s install root |
| Other paths | Unchanged; shared `permissionPolicy` applies |

Normalization runs in the Cursor driver before policy and before skill-id extraction from the
path used for accounting.

## DriveResult fields (unchanged shape)

| Field | Cursor fill rule after this fix |
| --- | --- |
| `skillsInvoked` | Skill ids extracted from tool calls (corrected extractor) |
| `skillsBeforeOutput` | Those ids (and experience SKILL.md reads) while `!outputSeen` |
| Install outcome | Unchanged shared checks: name `highway`, 16 skills, enabled, no warning |

## F29 resolution record

| Gate | Rule |
| --- | --- |
| Confirmation logs | `smoke-1.log`, `smoke-2.log`, `codify.log` under this spec’s `harness/` |
| Close F29 | Zero attempts in those three runs with experience-order `actual no skill` |
| Residual | Other experience-order → F27 (or new residual if model-skip rate is still much worse) |

## Entities (from spec)

- **F29**, **Experience-order check**, **Activation signal**, **Committed run log** — as in
  `spec.md` Key Entities; no new persisted store beyond logs and findings markdown.
