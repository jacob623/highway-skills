# Data Model: Codify Proposal Tasks

## Suggestion (not written)

| Field | Rule |
|---|---|
| Title | An action that starts with a verb and names its target, built from one realized capability |
| Summary | One sentence that expands on the action, grounded in Realized By and the first sentence of the capability's evidence |
| Kind | Establishing when the source capability title contains `establish` without regard to case. Otherwise, run, change, or recover |

The list holds at most five items. When no instance is running, establishing items come first. When one is running, the other kind comes first. Within a kind, items keep Realized Capabilities order.

## Opening name (not written)

| Source | Result |
|---|---|
| Exactly one `## Technology Choice` block | Its `Choice:` value |
| None or several | The implementation title |

## Draft proposal (not written until acceptance)

| Field | Rule |
|---|---|
| Title | The selected title, or the action named in the invocation |
| Summary | The selected summary, or one sentence for the named action |
| Description | What this one automation does, for whom, and what it returns |
| Acceptance criteria | At least one observable result |
| Executor | Who or what starts the automation. It is the first diagram node and is not a task |
| Tasks | At least one ordered proposal task |

## Proposal task

| Field | Rule |
|---|---|
| Action | Starts with a verb. It is the same text as its diagram arrow |
| Target | One platform, object, or API. It is the diagram node the arrow points to |
| Scope | What the task does |
| Provider | The specific thing that completes it: the person, or something the accepted architecture or implementation names |
| Method | How it is done, naming the plugins, modules, libraries, MCP servers, or APIs it uses |
| Assumptions | What it relies on that is not an earlier task, or `None` |
| Own artifact | Yes when its method needs files beyond the executor. Decides whether it adds file-list lines |

## Alignment result (not written)

| Result | Shown before the proposal |
|---|---|
| Congruent | Nothing |
| Corrected | One sentence naming the standard and what changed |
| None applies | One sentence that no coding standard applies |
| Unavailable | One sentence that the named standard was not found |
| Cannot be met | One sentence. The proposal is not shown, and codify returns to `suggest` |

## Source check result (not written)

| Result | Shown before the proposal |
|---|---|
| Confirmed | Nothing |
| Corrected | One sentence naming the change and citing the vendor source, or both sources when they conflict |
| Inconclusive | One sentence naming the claim as inconclusive. The proposal is unchanged |

## Saved record `code/[ID]/codify.md` (codify-record 3.0.0)

Frontmatter: `id`, `implementation`, `architecture`, `status`, all unchanged.

Body order: `# <title>`, `## Summary`, `## Description`, `## Acceptance Criteria`, `## Diagram`, `## Tasks`.

Removed: `## Components`, `## Current State`, `## Action`, `## Day`, `## Means`.

## File list `code/[ID]/codify-tasks.md` (codify-tasks 2.0.0)

| Tag | Files | Folder |
|---|---|---|
| `[Executor]` | Written once, first | `code/[ID]/executor/` |
| `[Task N]` | Only when proposal task N has its own artifact, in task order | `code/[ID]/task-N/` |
| `[README]` | Last | `code/[ID]/README.md` |

Each line is one file. A test line follows its file only when that file's standard says `Tests: required`.

## State flow

`choose` → `suggest` (skipped when an action is named) → `start` (draft) → `align` → `propose` → `identifier` → `title` when needed → `write` → `code` → `close`.

When a standard cannot be met, `align` returns to `suggest`. An edit to a provider or method in `propose` returns to `align` for that task.
