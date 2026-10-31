# Data Model: Multiple Reference Implementations

## Relationships

| From | To | Rule |
|---|---|---|
| Decision | Architecture | One decision names at most one architecture |
| Architecture | Decision | Lists every current decision that names it |
| Implementation | Architecture | Names one architecture |
| Architecture | Implementation | Has many current implementations |
| Decision | Implementation | No field. A current implementation belongs to an option when a current decision for that architecture selected the same exact option title |

A current decision is accepted, not superseded, and not removed.

## Decision record

The handoff `Reference Architecture` value is the reused RA id, or `None` when a new architecture is still required. The handoff has no implementation entry.

`supersedes` names the replaced decision, or `None`. `status` becomes `superseded` on the replaced record when the new decision is accepted. The replaced file remains.

## Architecture record

| Field | Rule |
|---|---|
| `id` | `RA` plus eight hex digits |
| `status` | `accepted` |
| Current decisions | Every current decision id that names this architecture |
| Context | When it applies, and what it leaves open |
| Style | The style and why it was chosen |
| Components | Responsibility, and the interface other components rely on, or `None` |
| Information | What it handles, who owns it, what crosses a trust boundary, or `None` |
| Variation | What every implementation must keep, and what it may choose, or `None` |
| Responsibilities | The list a realization covers or marks not applicable |
| Relationships | `advances`, `bound by`, `satisfies`, or `None` |
| Capabilities | Each names its component and has no capability id, or `None` |

`Key Technologies` is absent. A decision statement is not copied. The record does not name a product, platform, or vendor.

## Implementation record

| Field | Rule |
|---|---|
| `id` | `RI` plus eight hex digits |
| `architecture` | The RA id |
| `status` | `accepted` |
| Variation choices | The choice for each thing the architecture left free, or `None` |
| Coverage | One row per architecture responsibility: covered or not applicable |
| Conformance | `compatible` or `incomplete`, agreeing with the rows |
| Realized interface | One per architecture interface, or `None` |
| Conformance evidence | How conformance was shown, or `None` |
| Limitations | The limitations of this realization, or `None` |
| Technology choice | Stated once, with intent, reason, and evidence |

A compatible record omits gap and conflict sections. An incomplete record states the gap. A conflict is not written.

## Catalog rows

| Catalog | Many side |
|---|---|
| Architecture | ADR ID column lists the current decision ids |
| Implementation | Many rows may share one Architecture ID |
| Decision | Architecture ID column is the one RA id, or `None` |

A write that changes a relationship updates the affected records and catalogs together.

## Next step

| Condition | Closing suggestion |
|---|---|
| No architecture to reuse | Create the reference architecture for this decision |
| Reused architecture, option not yet implemented | Create the reference implementation for that architecture |
| Exact-title decision already has a current implementation | Name that implementation |
