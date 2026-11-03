# Data Model: Codify Config Skill

## Platform row (`library/coding-standards/codify-platforms.md`)

| Field | Rule |
|---|---|
| Platform | The accepted implementation title |
| Implementation ID | Its `RI` id. One row per id |
| When to use | Entries separated by `; `. Blank until configured |
| When not to use | Entries separated by `; `. Blank until configured |

Rows stay in the order they were added. The first row is the last fallback Provider. A row with both guidance cells blank is never chosen by fit.

## Coding standard row (`library/coding-standards/coding-standards.md`)

| Field | Rule |
|---|---|
| Standard Title | A language or platform name followed by `Coding Standard` |
| Technology | The language or platform |
| File Patterns | Backticked globs, comma separated |
| Summary | One sentence |
| When to use | Entries separated by `; `, or blank |
| When not to use | Entries separated by `; `, or blank |
| Inherits From | Standard Titles separated by `; `, or blank |
| Standard Path | `library/coding-standards/<file>.md` |

Removing a row leaves its standard file in place.

## Standard file (`library/coding-standards/<file>.md`)

`# <Standard Title>`, `## Scope`, `## Rules` (1 to 10 numbered rules), and `## Tests` with `Tests: required` plus one sentence, or `Tests: not required`.

## Presented list

Any `; `-separated cell is shown in a proposal as an ordered list under its bold label, one entry per item. A blank cell is shown as `None`. Accepting joins the items back with `; `.

## Conflict

| Field | Rule |
|---|---|
| Title | Bold, short |
| Description | Quotes both entries and names both records |
| Recommendation | One change that removes it |

Types:

- Overlapping When to use between two platforms.
- One meaning in both lists of one record.
- Two standards whose patterns overlap, with overlapping When to use, where neither inherits from the other.
- An inherited title that is missing.
- An inheritance cycle.

## Task standards (codify)

Each proposal task carries `**Standards:**`, an ordered list of Standard Titles, or `No coding standard applies.` It is saved in the record task block. An earlier title wins a disagreement.

## Onboarding configure answers

A list of platforms the person said yes to, kept in the conversation and not written. The summary emits one pointer per entry.
