# Data Model: Highway Codify

## Relationships

| From | To | Rule |
|---|---|---|
| Automation | Implementation | Names one accepted implementation |
| Implementation | Automation | Has many automations |
| Automation | Architecture | The means is one accepted architecture, shown by title |
| Request | Implementation | No field. The closing message names a match |
| Finding | Request | An explored finding becomes a request. Assessment does not write an automation |

A current implementation is an accepted implementation-catalog row. A removed row does not match.

## Codify record

Path: `code/CDY<8 hex>/codify.md`

| Field | Rule |
|---|---|
| `id` | `CDY` plus eight hex digits derived from the automation title |
| `implementation` | The `RI` id of the accepted implementation |
| `architecture` | The `RA` id of the means |
| `status` | `accepted` |
| Current state | The sentence used to decide the instance, or `None` |
| Action | The one automation |
| Day | `Day 1` or `Day 2` |
| Means | The accepted architecture title |
| Components | The parts this one action needs, or `None` |

The body is the accepted proposal. It does not copy the implementation, the architecture, or the decision.

## Catalog

Path: `code/code.md`

| Column | Rule |
|---|---|
| Automation ID | `CDY` plus eight hex digits. One row each |
| Implementation ID | The parent `RI` id. Many rows may share one |
| Automation Title | The one action |
| Automation Path | `code/<id>/codify.md` |
| Status | `accepted` or `removed` |

Rows are ordered by Automation ID. There is no `Next ID` field. `accepted` has the folder. `removed` keeps the id and has no folder. An empty baseline is `Version: 1.0.0` and the header, with no data rows.

Adding an automation increments the catalog minor version. The first catalog version is `1.0.0`.

## Folder

```text
code/CDY<8 hex>/codify.md
code/CDY<8 hex>/README.md
code/CDY<8 hex>/<component>/
```

`<component>` is the component name from the accepted proposal, lowercased, with spaces written as hyphens. The folder exists only for a component the proposal names. The files in it are the automation for that part of the one action.

## Readme

`README.md` has two parts.

| Part | Reader | Content |
|---|---|---|
| Implement | The platform engineer or business owner who accepted the proposal | What is put in place, where it goes, and how to enable it, including preparation |
| Use | A non-technical person | How to start this one automation, what to provide, and what comes back, using the interface of the accepted means |

The use part does not ask that person to edit the generated files or read the implementation record.

## Request close

The request record is unchanged. The closing message is the relationship.

| Accepted request | Next step |
|---|---|
| One matching implementation | `/highway-codify` for that title and the one action |
| Two to five matches | A title-and-description list, then the one-match step after a pick |
| More than five matches | No list until the person gives a title or description, then at most five |
| No match | `/highway-discovery` with the request id |

## Day and action

| How codify was started | Action | Day |
|---|---|---|
| Accepted request | The one action that request asks for | Day 2 when an instance is running, otherwise Day 1 |
| No action supplied | `Establish [implementation title]`, or the first realized capability title when an instance is running | Same day rule |

A second action in the same proposal is not written. The person can correct the action and the day before acceptance.
