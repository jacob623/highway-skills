# Data Model: Highway Reference Architecture Workflow

## Accepted ADR

The one required source decision.

| Field | Description | Validation |
|---|---|---|
| `id` | ADR identifier | Exactly one `ADRXXXXXX`; resolves through the ADR catalog |
| `status` | Lifecycle status | Must be `accepted` |
| `title` | Decision title | Used as the deterministic architecture title source |
| `decision` | Accepted decision and rationale | Read-only; architecture must not alter or replace it |
| `alternatives` | Considered options | Read-only; architecture must not select a different option |
| `consequences` | Decision consequences | Read-only source for architecture context and risks |
| `constraints` | Decision constraints | Read-only source for architecture constraints |
| `traceability` | Request, Discovery, and ADR references | Preserve available identifiers; represent unavailable values explicitly |

Relationship: one accepted ADR produces at most one Reference Architecture.

## Optional Governance Context

Profile, Objectives, Controls, and NFRs are read-only advisory inputs.

| State | Architecture behavior |
|---|---|
| Missing | Continue without fabricated evidence |
| Blocked | Continue and record the source and condition as an architecture risk |
| Valid | Use as advisory context, relationships, constraints, or capability evidence |
| Malformed or internally inconsistent | Abort without writing architecture or catalog output |

## Reference Architecture Record

The retained conceptual architecture identified by `ARCHXXXXXX`.

| Field | Description | Validation |
|---|---|---|
| `id` | Permanent architecture identifier | `ARCH` plus six digits; catalog-owned and never reused |
| `adr` | Source ADR identifier | Must equal the single accepted ADR input |
| `status` | Initial architecture state | `proposed` |
| `title` | Deterministic architecture title | Derived from the accepted ADR title |
| `context` | Why the architecture exists | Inherited or synthesized from declared inputs without unsupported facts |
| `architecture_summary` | High-level conceptual description | Required |
| `architecture_style` | Conceptual style classification | Required; no implementation authorization |
| `logical_components` | Major conceptual building blocks and purposes | Required and deterministically ordered |
| `interaction_model` | Conceptual component communication | Required |
| `trust_boundaries` | Security, ownership, or responsibility boundaries | Required; may explicitly state `None` |
| `deployment_pattern` | Conceptual deployment approach | Required; may explicitly state `None` |
| `key_technologies` | ADR-supported technology considerations | Required; must remain conceptual |
| `decisions_inherited` | ADR decision references | Must include the source ADR |
| `constraints` | ADR, Control, and NFR constraints | Required with source relationships |
| `objective_relationships` | Existing `OBJXXXXXX` references | No invented identifiers; stable ordering |
| `control_relationships` | Existing `CTLXXXXXX` references | No invented identifiers; stable ordering |
| `nfr_relationships` | Existing `NFRXXXXXX` references | No invented identifiers; stable ordering |
| `required_capabilities` | Advisory capability candidates | No capability artifacts or identifiers |
| `assumptions` | Architecture premises and source limitations | Required; may state `None` |
| `risks` | Architecture risks and blocked-input conditions | Required; may state `None` |
| `reference_implementation_guidance` | Future implementation handoff | Guidance only; no implementation authorization |
| `traceability` | Available REQ, DISC, ADR, and ARCH references | Stable and explicit |

## Architecture Catalog

The authoritative architecture identifier allocation and index.

| Field | Description | Validation |
|---|---|---|
| `version` | Catalog format version | Shared catalog template value |
| `next_id` | Next unused architecture identifier | Must be valid and greater than allocated IDs |
| `entries` | Direct architecture index | One entry per successful record; ordered by architecture ID |
| `adr_uniqueness` | ADR-to-architecture constraint | No ADR may have more than one architecture entry |

## State Transitions

```text
No architecture for ADR
  -> validate accepted ADR and inputs
  -> allocate ARCH identifier
  -> proposed Reference Architecture + catalog entry

Any validation/allocation/write failure
  -> no retained state change

Existing architecture for ADR
  -> duplicate rejection; existing record and catalog remain unchanged
```
