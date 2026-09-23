# Data Model: Clarification Contract Consistency

## Recommendation Basis/State Pair

Represents why a Recommended Option value was produced and the state it may expose.

| Field | Values | Constraint |
|---|---|---|
| Recommendation Basis | `authoritative`, `evidence-gap`, `conflict` | Exactly one value is required. |
| Recommended Option | Evidence-backed recommendation, `Unknown`, or `Escalate for Decision` | `evidence-gap` maps to `Unknown`; `conflict` maps to `Escalate for Decision`; `authoritative` must not use either non-authoritative state. |

The combined value `Unknown / Escalate for Decision` is invalid and must not appear in canonical or generated artifacts.

## Evidence Source Entry

A traceability list item used by a recommendation or finding.

| Field | Required | Constraint |
|---|---|---|
| Source Type | Yes when an evidence source exists | Appears directly in the source list item. |
| Source Identifier | Yes when an evidence source exists | Identifies the source without relying on list order. |
| Reason Used | Yes when an evidence source exists | Explains the deterministic reason the source contributed. |

Multiple sources are separate list items. With no sources, the record uses `Evidence Sources: None`. A nested `Source:` wrapper is invalid.

## Resolution History Entry

A retained history item for one finding.

| Field | Required | Constraint |
|---|---|---|
| Finding | Yes | References exactly one finding identifier in the same record. |
| Response | Yes | Retains the candidate or accepted response value. |
| Revision | Yes | Retains the revision associated with the entry. |
| Actor | Yes | Identifies the actor value retained by the contract. |

Finding identifiers are unique within one Resolution History section, regardless of Response, Actor, Revision, or other field differences. A duplicate causes validation failure before any retained write.

## Generated Artifact Scope

Generated artifacts include catalogs, adapters, validation outputs, generated examples, and retained artifacts derived from the canonical Clarification skill or clarification-record template. Canonical inputs include `clarify.md`, `clarification-record.md`, generated schema inputs, and generated validation inputs.

## Validation Invariants

1. Every Recommendation Basis value has exactly one valid state mapping.
2. No non-authoritative state exists outside `Unknown` and `Escalate for Decision`.
3. Evidence Sources entries have the direct three-field list-item shape, or the record explicitly states `Evidence Sources: None`.
4. Resolution History Finding identifiers are unique within one history section.
5. Any violation of FR-001 through FR-019 fails validation, writes no retained output, and preserves pre-operation bytes.
6. Canonical and generated Clarification artifacts contain no retired combined conflict state.
7. Clarification guidance and clarification-record contract use identical recommendation, evidence-source, and duplicate-history rules.
