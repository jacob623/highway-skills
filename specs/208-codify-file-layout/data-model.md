# Data Model: Codify File Layout

## Coding standard file

| Section | Rule |
|---|---|
| `# <Standard Title>` | As today |
| `## Scope` | As today |
| `## File and Folder Structure` | Required. An ordered list of paths relative to the automation folder. It can use placeholders. No path begins with `/` or `code/` |
| `## Rules` | 1 to 10 numbered rules |
| `## Tests` | `Tests: required`, one sentence, and `Test path:` naming a path from the structure. Or `Tests: not required` |

## Coding standards catalog

Unchanged columns. It is created by `highway-codify-config` with the first accepted standard. It is never shipped.

## Feature

One proposal task. It holds the Standards list and the Files list. Its task list lines are grouped under `[Task N]`.

## Task line

| Field | Rule |
|---|---|
| Tag | `[Executor]` before the features, `[Task N]` for a feature, `[README]` last |
| Work | One action |
| Files | The relative paths this line creates or changes |
| Standards | The Standard Paths, in the task's order, or `No coding standard applies.` |

A required test is the feature's first line.

## Proposal task Files

An ordered list of relative paths on each proposal task, saved in the record. A correction changes this automation only.
