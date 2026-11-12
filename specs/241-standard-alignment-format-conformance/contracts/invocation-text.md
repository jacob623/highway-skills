# Contract: Invocation-Neutral Skill Text

## Scope

Every file under `skills/<id>/`: `SKILL.md`, `references/*`, and `assets/*`.

## Rule

Outside a `## Example` section, no line contains an invocation prefix before a Highway skill
name:

| Form | Pattern |
| --- | --- |
| Slash | `/highway-<id>`, unless `/` follows a path segment such as `skills/highway-help/` |
| Dollar | `$highway-<id>` |
| Plugin namespace | `highway:highway-<id>` |

A skill is named as `highway-<id>`, with its arguments after it, in or out of a code span.

## `## Example`

The section from `## Example` to the next `## ` heading, or to the end of the file, may keep a
`/highway-<id>` invocation as one agent's illustration.

## `metadata.usage`

The value begins with `Run highway-<id>`, or names the skill without a prefix, and contains no
form from the table.

## Check

`tests/agent-skills-format.test.sh` scans every file in scope. It fails on each matching line with
`<file>:<line>: <form> invocation outside ## Example`. A seeded probe adds a `/highway-adr` line
outside `## Example` to a copy of a skill and requires a failure.
