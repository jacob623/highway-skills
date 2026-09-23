# Data Model: Highway ADR Decision Workflow

## ADR Aggregate

The `ADRXXXXXX` record is the aggregate root allocated by the ADR catalog. It references exactly
one `DISC######` and its transitive `REQ######`, contains one selected option, records every other
Discovery option as evaluated, and carries the authoritative decision and Reference Architecture
handoff.

| Field | Rule |
|---|---|
| ADR Identifier | Six-digit `ADR` identifier allocated from `adrs/adrs.md`. |
| Discovery Reference | Exactly one valid `DISC######`; includes recommendation, rationale, options, matrix, matches, and Request ID. |
| Request Reference | The Request identifier carried by Discovery; read-only traceability. |
| Status | `accepted` on initial creation; only `proposed`, `accepted`, `rejected`, or `superseded` are valid values. |
| Decision | Exactly one selected Discovery-owned `OPTXXXXXX`, decision statement, authority, rationale, and authorization to proceed to Reference Architecture. |
| Decision Confidence | Discovery confidence plus deterministic confidence considerations; no ADR rescoring. |
| Alternatives Considered | One entry for every Discovery option, each with identifier, outcome, selection status, and reason. |
| Consequences | Separate positive, negative, operational, and governance labels. |
| Relationships | Objective, Control, and NFR references sorted by type, numeric identifier suffix, and title. |
| Supersession | Initial values are `Supersedes: None` and `Superseded By: None`. |

## Candidate Solution Option

Candidate options are immutable Discovery-owned values. ADR may select or reject them, but may not
create, rename, rescore, rerank, or otherwise modify them.

| Field | Constraint |
|---|---|
| Identifier | `OPT` plus exactly six digits and present in Discovery. |
| Selection status | Exactly one `Selected`; all other Discovery options are `Rejected` or `Evaluated`. |
| Reason | ADR-owned decision reasoning; does not alter Discovery evidence. |

## Clarification Input Snapshot

Only `CLAR-REQ######` and `CLAR-DISC######` may be consumed. The snapshot includes the catalog
mapping, status, finding identifiers, states, responses, conflict guidance, and source bytes as
read at input resolution. It is advisory and never written back.

| Status | ADR treatment |
|---|---|
| `not-started` or missing | No clarification evidence; continue. |
| `in-progress` | Consume resolved findings; carry open findings into assumptions, risks, and follow-up. |
| `complete` | Consume resolved findings; do not introduce open-finding uncertainty. |
| `blocked` | Record blocked condition as a risk and continue. |
| Malformed | Fall back to Discovery evidence and preserve Clarification bytes. |

Open findings are listed once by finding identifier when they contribute. Conflict guidance is
copied into ADR Risks and Decision Rationale as non-authoritative evidence.

## Reference Architecture Handoff

The handoff is complete only when each field is present with a valid value or explicit `None`:

| Field | Source/ownership |
|---|---|
| Selected Option | ADR decision; must match the selected option. |
| Reference Architecture Matches | Discovery-recorded matches, confidence, and reasons; no recomputation. |
| Architecture Direction | ADR-owned direction for the selected option. |
| Required Architecture Work | ADR-owned work list or explicit `None`. |
| Authorization to Proceed | Explicit authorization to proceed to Reference Architecture, excluding implementation authorization. |

## Catalog and Transaction Boundary

`adrs/adrs.md` owns the next ADR identifier and one index row per ADR. Discovery identifier is the
uniqueness key. Resolution, validation, rendering, and verification happen before writes; a
successful commit creates one ADR and advances the catalog once. Any failure, duplicate Discovery,
or exhausted allocation conflict preserves all pre-operation bytes.

## State Transitions

Initial generation has one permitted transition:

```text
unallocated -> accepted
```

Future workflows own transitions to `proposed`, `rejected`, or `superseded`; this feature does not
perform them.