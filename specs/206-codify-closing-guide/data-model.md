# Data Model: Codify Closing Guide

## README

File: `code/[ID]/README.md`, written by the last task.

| Part | Heading | Content |
|---|---|---|
| 1 | `## Setup Instructions` | What is put in place, where it goes, and how to enable it, including preparation |
| 2 | `## User Guide` | How a non-technical person starts this one automation, what they provide, and what they receive, through the Provider's interface |

## Close

| Task progress | Close |
|---|---|
| Every task is done | Notices that apply, then the completion message in [contracts/completion-close.md](contracts/completion-close.md) |
| A task could not be finished | Notices that apply, then the stopped-task block |

## Automations catalog

File: `code/code.md`, shaped by `.highway/library/templates/output/codify-catalog.md`.

| Rule | Value |
|---|---|
| Columns | Automation ID, Implementation ID, Automation Title, Automation Path, Status. Unchanged |
| Row order | Acceptance order. A new row is appended last |
| Status change | The row keeps its position |
| Existing catalog | Read as written. Not reordered |

## Catalog view

Read-only. Built from accepted rows of `code/code.md`, `implementations/implementations.md`, and each `code/[ID]/codify-tasks.md`.

| Accepted rows | Lines shown | After the lines |
|---|---|---|
| 0 | None | "No automation has been created yet." |
| 1 to 5 | All, newest first | The question |
| More than 5 | Last 5, newest first | "[N] more automations are not shown." ("1 more automation is not shown." when N is 1), then the question and the name-or-describe sentence |

| Task list | Progress text |
|---|---|
| No open task | Every task is done. |
| An open task | Task [T###] is next. |

### Worked example

Seven automations accepted in order A to G. G stopped at T004. B was removed.

```text
1. G: Store. Task T004 is next.
2. F: Pipeline. Every task is done.
3. E: Store. Every task is done.
4. D: Agent. Every task is done.
5. C: Store. Every task is done.

1 more automation is not shown.
```

A is the one not shown. B is removed, so it is neither listed nor counted.
