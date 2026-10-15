# Data Model: Highway Reference Implementation Workflow

## Accepted Reference Architecture

The one required source realization boundary.

| Field | Description | Validation |
|---|---|---|
| `id` | Reference Architecture identifier | Exactly one `ARCH######`; resolves through the authoritative architecture catalog |
| `status` | Architecture lifecycle state | Must be `accepted` |
| `title` | Architecture title | Used as the deterministic implementation title source |
| `context` | Architecture purpose and evidence | Read-only source for implementation context |
| `logical_components` | Conceptual components and purposes | Read-only source for runtime and implementation component mapping |
| `interaction_model` | Conceptual communication | Read-only source for integration realization |
| `trust_boundaries` | Security, ownership, and responsibility boundaries | Read-only source for security realization |
| `key_technologies` | Conceptual technology considerations | May constrain implementation choices but does not itself select them |
| `constraints` | Architecture and inherited governance constraints | Read-only source for implementation constraints |
| `traceability` | Request, Discovery, ADR, and architecture references | Preserve available identifiers explicitly |

Relationship: one accepted Reference Architecture produces at most one Reference Implementation.

## Optional Evidence Context

Clarification, Profile, Objectives, Controls, and NFRs are read-only advisory inputs.

| Source | States | Implementation behavior |
|---|---|---|
| `CLAR-ARCH######` | `not-started` or missing | Continue without clarification evidence |
| `CLAR-ARCH######` | `complete` | Consume resolved findings |
| `CLAR-ARCH######` | `in-progress` | Consume resolved findings; represent open findings as assumptions, risks, or unknowns |
| `CLAR-ARCH######` | `blocked` | Continue and record the condition as an implementation risk |
| `CLAR-ARCH######` | malformed | Preserve bytes, ignore clarification evidence, and fall back to authoritative architecture evidence |
| Profile, Objective, Control, or NFR | missing | Continue without fabricated evidence |
| Profile, Objective, Control, or NFR | blocked | Continue and record the source condition as an implementation risk |
| Profile, Objective, Control, or NFR | valid | Use for realization, constraints, relationships, risks, and dependencies |
| Profile, Objective, Control, or NFR | malformed or inconsistent | Abort without writing implementation or catalog output |

Evidence precedence is Reference Architecture, `CLAR-ARCH######`, Objectives, Controls, NFRs, then
Profile. No source is resolved by filesystem order, timestamps, recency, environment state, or
session state.

## Reference Implementation Record

The conceptual-to-realization blueprint identified by `RI######`.

| Field | Description | Validation |
|---|---|---|
| `id` | Permanent implementation identifier | `RI` plus six digits; catalog-owned and never reused |
| `architecture` | Source Reference Architecture | Must equal the single accepted `ARCH######` input |
| `status` | Initial implementation state | `proposed` |
| `title` | Deterministic implementation title | Derived from the accepted architecture title |
| `context` | Architecture reference and realization purpose | Required |
| `implementation_summary` | High-level realization description | Required |
| `technology_realization` | Architecture-to-technology mapping | Required; every choice references architecture intent and evidence |
| `runtime_components` | Realized runtime building blocks | Required and deterministically ordered |
| `deployment_topology` | Realized deployment arrangement | Required; may explicitly state `None` when architecture evidence is insufficient |
| `environment_strategy` | Development, test, staging, and production strategy | Required; may explicitly state `None` |
| `data_realization` | Realized data stores, ownership, and flows | Required |
| `integration_realization` | Realized interactions and integration mechanisms | Required |
| `security_control_realization` | Control-to-mechanism mappings | Required; no Control ownership mutation |
| `nfr_realization` | NFR-to-implementation requirement mappings | Required; no NFR ownership mutation |
| `lifecycle_activities` | Design, build, test, deploy, operate, monitor, improve mappings | All seven activities required |
| `assumptions` | Source limitations and realization premises | Required; may state `None` |
| `risks` | Blocked evidence, unknowns, and realization risks | Required; may state `None` |
| `constraints` | Inherited architecture and governance limits | Required; preserve source relationships |
| `dependencies` | Required upstream evidence and external realization dependencies | Required; may state `None` |
| `traceability` | REQ, DISC, ADR, ARCH, Objective, Control, and NFR references | Stable and explicit |

## Implementation Catalog

The authoritative identifier allocation and direct index.

| Field | Description | Validation |
|---|---|---|
| `version` | Catalog format version | Shared catalog template value |
| `next_id` | Next unused implementation identifier | Valid `RI######` greater than allocated identifiers |
| `entries` | Direct implementation index | One entry per successful record; ordered by RI identifier |
| `architecture_uniqueness` | Architecture-to-implementation constraint | No accepted architecture has more than one RI entry |

## State Transitions

```text
No implementation for accepted architecture
  -> validate ARCH input and optional evidence
  -> generate and validate blueprint
  -> allocate RI identifier
  -> proposed Reference Implementation + catalog entry

Any resolution, validation, allocation, or write failure
  -> no retained implementation or catalog state change

Existing implementation for architecture
  -> duplicate rejection; existing record and catalog remain unchanged
```
