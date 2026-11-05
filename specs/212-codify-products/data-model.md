# Data Model: Codify Products

No existing `code/CDY…/` folder is moved. New acceptances use the shapes below.

## Product

One row in `code/code.md`. One folder `code/<folder>/`.

| Field | Rule |
|---|---|
| ID | The CDY, derived as it is today. One per row. Not the folder name |
| Folder | `code/<folder>`. Unique, including removed rows |
| Title | The product title |
| Summary | One sentence: who it is for and what it returns |
| Implementations | Accepted implementation ids, separated by `; ` |
| Features | Decision entries only, separated by `; `. Each entry is `<number>-<action> \| one sentence` |
| Status | `accepted` or `removed` |

A feature is stored in Features only when it starts the product, adds an implementation, records an integration, changes the summary, or is open. A finished feature that did none of those leaves the cell. Its directory stays.

A removed row keeps its folder and recorded feature titles taken. It is not a join candidate.

## Feature

One directory `code/<folder>/.highway/features/<number>-<action>/`.

| File | Role |
|---|---|
| `codify.md` | The accepted proposal, including **Proposed project:** and **Rationale:** |
| `codify-tasks.md` | The task list. `Files:` paths are relative to `code/<folder>/` |

`<number>` is `001` for the first feature and the next integer in that product after that. An open feature is resumed. A new acceptance adds the next directory.

## Metadata

`code/<folder>/.highway/metadata.md`, written once.

| Field | Rule |
|---|---|
| id | The product CDY |

## Integration

One row in `code/integrations.md`.

| Field | Rule |
|---|---|
| From | An accepted implementation id |
| To | The other accepted implementation id |
| Kind | `composition` or `capability` |
| Summary | One sentence: what the connection does |
| Status | `accepted` or `removed` |

The same From, To, and Kind is one row. Accepting a proposal that includes a new pair appends it. Accepting a proposal for a pair that is already accepted writes no second row.

## Placement

| Condition | Result |
|---|---|
| The person named a folder | That folder |
| A recorded feature title matches the action | Leave the suggestion out. Resume the feature when it is open |
| A feature sentence or Summary means the same action | Leave the suggestion out |
| A matching coding standard names the home | That home replaces the rows below |
| Composition, one side has a product | Join it. List both implementations |
| Composition, both sides have products | Join the folder of the implementation being codified. Leave the other folder. List both implementations |
| Composition, neither side has a product | Start one folder. List both implementations |
| Capability whose From is selected | Join the product that lists From. Add To |
| Summary means the same consumer and outcome, action is new | Join that folder |
| Nothing fits | Start a folder from the product title |

The person can change the proposed project before acceptance. The written folder stays unique, the CDY stays in metadata, the feature stays under `.highway/features/`, and paths stay relative to the product folder.
