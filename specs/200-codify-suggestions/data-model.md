# Data Model: Codify Suggestions

## Relationships

| From | To | Rule |
|---|---|---|
| Suggestion | Implementation | Offered for one accepted implementation. Not saved |
| Proposal | Suggestion | Carries that suggestion's title and summary after it is selected |
| Proposal | Component | Names zero or more components, each with one responsibility and one boundary |
| Named action | Proposal | Skips the suggestion list and opens this proposal |

## Suggestion

| Field | Rule |
|---|---|
| Title | The capability title, or `Establish [implementation title]`, or `Run [implementation title]` |
| Summary | One sentence. For a capability, the first sentence of its evidence, or `None`. For a fallback, the first sentence of the implementation summary, or `None` |
| Kind | Establishing when the title contains `establish`. Otherwise run, change, or recover |

The list holds at most five. The kind that fits the current state comes first. Within a kind, record order is kept. The list is not written to a file.

## Proposal

Shown after one selection, and also when the invocation already names the action.

| Field | Rule |
|---|---|
| Title | The selected suggestion title, the person's own title, or the named action |
| Summary | The matching summary |
| Description | What the one automation does |
| Diagram | One fenced flowchart |
| Acceptance criteria | One or more checkable conditions |
| Components | Each name, its responsibility, and its boundary, or `None` |
| Current state | The sentence used for the instance, or `None` |
| Day | `Day 1` or `Day 2` |
| Means | The accepted architecture title |
| Action | The one automation. The title and the action name the same automation |

A proposal with zero acceptance criteria is not written. A second action is not kept.

## Saved record

`codify-record.md` gains Summary, Description, Diagram, and Acceptance Criteria. Components gain Responsibility and Boundary. Current State, Action, Day, and Means stay. Frontmatter is unchanged.

The catalog row is unchanged. Its title is the automation title.
