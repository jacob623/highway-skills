# Data Model: Codify Platform Catalog

## Platform catalog

File: `library/knowledge/codify-platforms.md`, shaped by `.highway/library/templates/output/codify-platforms.md`.

| Column | Rule |
|---|---|
| Platform | The implementation title, or the name the person added |
| Implementation ID | The `RI` id, or `None` when the person added the row |
| Source | `implementation` or `own` |

One row per Implementation ID. A person's row is unique by platform title, compared without regard to case. Row order is the order the rows were added. The first row is the default Provider when no other rule in [research.md](research.md) R1 applies.

## Inclusion

| Case | Catalog |
|---|---|
| Accepted implementation can start automation, and no row has its id | Add one `implementation` row. Say it is included |
| A row already has that id | Keep that one row. Say it is included again |
| The person removed it, then the implementation is accepted again | Add the row again and say it is included |
| The realization is a store, newsletter, records product, or backup | Write nothing. Say nothing |
| The record is opened, listed, or the proposal is declined | Write nothing |

The two sentences are: "[Platform] is included as a platform that can start automation. To remove it, run /highway-codify configure."

## Configure

| Reply | Result |
|---|---|
| Add a new name | One `own` row, Implementation ID `None` |
| Add a name already present | Keep the row. Say it is already included |
| Remove a listed platform | That row is dropped. Other rows stay |
| Remove or correct a name that is absent | Say it is not included. Write nothing else |
| Correct a listed row | That row's platform title is replaced. Its Implementation ID and Source stay |
| Decline | The file is unchanged |

An empty catalog still has the file header once the file exists. Configure says nothing is included yet.

## Provider and diagram

| Field | Rule |
|---|---|
| Provider | One platform for the whole automation. Every task names it |
| Target | The platform, object, or API the task changes. The implementation being automated is a target |
| Diagram | One `flowchart TB`. The Provider is the only source of arrows. Each task is one arrow from the Provider to that task's target, in task order |

```flowchart
flowchart TB
  P["[Provider]"] -->|[First action]| T1["[First target]"]
  P -->|[Next action]| T2["[Next target]"]
```

A named platform that is not in the catalog stays the Provider. The proposal adds: "[Platform] is not included as a platform that can start automation. To add it, run /highway-codify configure."

## Worked examples

| Moment | Result |
|---|---|
| Accept Cursor, an agent that starts the work | Row: Cursor, its `RI` id, `implementation`. The two sentences name Cursor |
| Accept Shopify | No row and no sentence |
| Configure, remove Cursor, add a pipeline the person names | Cursor is gone. The pipeline is an `own` row |
| Propose a Shopify automation while Cursor is the first row | Every task's Provider is Cursor. Both arrows leave Cursor |
| Propose while the catalog is empty and no platform is named | The Provider is unset. The proposal points to configure |
