# Data Model: Help Description Listing

## Catalog Entry

A registered skill record consumed by `highway-help`.

| Field | Meaning | Validation |
|---|---|---|
| `id` | Full agent-facing skill identifier | Used verbatim in `Name:` and the copyable help command |
| `description` | User-facing purpose of the skill | Rendered verbatim after `Description:` in All-Skills mode |
| `usage` | Invocation guidance | Retained for Single-Skill mode; not rendered as the All-Skills label |
| catalog position | Order in the generated registry | Preserved in the All-Skills listing |

## All-Skills Listing Block

A transient three-line response block for one catalog entry:

1. `Name: <id>`
2. `Description: <description>`
3. `Help: /highway-help <id>`

The block has no persisted state and no identifier of its own. Its cardinality equals the number of catalog entries.

## Single-Skill Detail Response

A transient six-line response for one resolved catalog entry. Its existing field order and labels are unchanged: `Name:`, `Description:`, `Dependencies:`, `Version:`, `Usage:`, and `Example:`.

## Relationships and invariants

- Each catalog entry produces exactly one All-Skills listing block.
- Listing blocks preserve catalog order.
- The All-Skills block uses `description`; it does not substitute `usage`.
- Single-Skill output continues to use `usage` in its existing position.
- An empty catalog has the existing exact empty-result form rather than a block collection.
