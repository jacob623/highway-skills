# Data Model: Standard Alignment Agent Skills Format Conformance

## Skill frontmatter

The YAML block between the first two `---` lines of `skills/<id>/SKILL.md`.

| Field | Scope | Required | Type | Constraint | Source of the rule |
| --- | --- | --- | --- | --- | --- |
| `name` | top | yes | string | 1–64 characters, `^[a-z0-9]+(-[a-z0-9]+)*$`, equals the folder name | Agent Skills; ASCII-only is Highway's narrowing |
| `description` | top | yes | string | 1–1,024 characters; contains a sentence beginning "Use when" | Agent Skills; P5.15 |
| `license` | top | yes | string | `Apache-2.0` in every Highway skill | Agent Skills (optional); FR-004 requires it |
| `compatibility` | top | no | string | 1–500 characters; omitted by every Highway skill | Agent Skills |
| `allowed-tools` | top | no | string | Accepted by the validator; declared by no Highway skill | Agent Skills; FR-016 |
| `metadata` | top | yes | mapping | Keys limited to `version` and `usage`; every value a string | Agent Skills; Highway's closed key set |
| `metadata.version` | metadata | yes | string | `MAJOR.MINOR.PATCH` | P7.2 |
| `metadata.usage` | metadata | yes | string | 1–500 characters; names the skill without `/`, `$`, or a namespace | FR-002, FR-008 |

Removed: top-level `usage`, the `compatibility` agent list, `metadata.agent_exceptions`, and
`metadata.dependencies`.

Validation rules:
- The frontmatter parses under PyYAML's SafeLoader with duplicate keys rejected, and is a mapping.
- Every field above with type string resolves to the YAML `str` type.
- For `name`, `description`, `license`, `compatibility`, `metadata.version`, and `metadata.usage`,
  the parser's value equals the value `fm_get` or `fm_get_nested` reads.

Example after this change:

```yaml
---
name: highway-adr
description: "Records one architecture decision for a discovery. Use when a discovery's options are ready and the person wants to choose one and record it as an ADR."
license: Apache-2.0
metadata:
  version: 6.5.0
  usage: "Run highway-adr with one discovery id."
---
```

## Parsed frontmatter line (internal)

The output of `yf_parse <file>` in `framework/lib/yaml-frontmatter.sh`. There is one line per
field, tab-separated:

| Column | Values |
| --- | --- |
| scope | `top` or `metadata` |
| key | the field name |
| type | `str`, `int`, `float`, `bool`, `null`, `date`, `map`, `list`, or `other` |
| value | the value, with `\` escaped as `\\`, newline as `\n`, and tab as `\t`; empty for `map` and `list` |

When parsing fails, it prints one `ERROR: [SCHEMA] <message>` line and returns 1. When the parser
is unavailable, it prints the unavailable error and returns 1.

## Help index entry

`skills/highway-help/assets/index.json`, one entry per skill, in folder order.

| Field | Source |
| --- | --- |
| `id` | the folder name |
| `name` | `name` |
| `description` | `description` |
| `usage` | `metadata.usage` (was top-level `usage`) |
| `version` | `metadata.version` |
| `example` | the first inline-code line under `## Example` |

Removed: `dependencies`.

## highway-help single-skill output

Five lines, in this order: `Name:`, `Description:`, `Version:`, `Usage:`, `Example:`. The
`Dependencies:` line is removed. The all-skills block is `Name:`, `Description:`,
`Help: highway-help <id>`.

## Constitution rows added

| Document | Row | Tier | Enforced by |
| --- | --- | --- | --- |
| Highway Skills Constitution | P5.15: the description contains a "Use when" sentence | `[auto]` | `rc_check_P5_15` |
| Highway Skills Constitution | P5.16: the "Use when" sentence agrees with `## When to use` | `[agent-checkable]` | review |
| Development constitution | D3.9: the validator enforces every Agent Skills rule | `[auto]` | `agent-skills-format.test.sh` |

## Fixture verdicts (D3.4)

These verdicts were recorded before the parser checks and P5.15 are wired in. Every fixture moves
to the new frontmatter shape: `usage` under `metadata`, no `compatibility`, `license: Apache-2.0`,
and a description with "Use when". After that move, each keeps exactly its own defect.

| Fixture | Defect | Verdict after this change |
| --- | --- | --- |
| `valid-skill` | none | PASS |
| `invalid-skill-name-mismatch` | `name` differs from folder | FAIL, SCHEMA name |
| `invalid-skill-missing-usage` | no `metadata.usage` | FAIL, SCHEMA `metadata.usage` |
| `invalid-skill-missing-version` | no `metadata.version` | FAIL, P7.2 |
| `invalid-skill-duplicate-key` | a repeated key | FAIL, SCHEMA duplicate key, from the parser |
| `invalid-skill-short-description` | was under 10 characters; becomes an empty description | FAIL, SCHEMA description |
| `invalid-skill-long-description` | description over the limit (made over 1,024) | FAIL, SCHEMA description |
| `invalid-skill-undeclared-key` | an undeclared top-level key | FAIL, SCHEMA undeclared key |
| `invalid-skill-unrecognized-word` | a word outside the closed list | removed with the word list |
| `invalid-skill-nondeterministic-criterion` | P6.4 token | FAIL, P6.4 only |
| `invalid-skill-relative-link` | relative link | FAIL, P8.7 only |
| `invalid-skill-missing-example` | no `## Example` | FAIL, SCHEMA section only |
| `invalid_skill_bad_id` | folder id not kebab-case | FAIL, SCHEMA id |
