---
name: highway-architecture
description: "Manages the repository-wide Reference Architecture baseline."
usage: "Invoke as `/highway-architecture` with one ADR ID."
compatibility: all
metadata:
  version: 1.0.0
---

# highway-architecture

## Purpose

Create one deterministic, conceptual Reference Architecture from exactly one accepted ADR while
preserving every upstream decision and governance artifact as immutable evidence.

## Experience

Reference Architecture work follows the Highway Experience Standard. Put `Next Action` first,
describe architecture decisions and risks in user-relevant terms, and keep the handoff explicit.
`User Exits` are `pause`, `cancel`, or `stop responding`; `Owner Outcomes` are `declined`,
`aborted`, or `blocked`. This workflow does not authorize implementation or create a Reference
Implementation.

## When to use

- Exactly one explicit ADRXXXXXX identifier is available.
- The identifier resolves uniquely through `architectures/architectures.md`'s ADR source catalog.
- The resolved ADR status is accepted and its decision, alternatives, consequences, constraints,
  and traceability are readable.
- The architecture catalog and both shared architecture templates are available:
  `.highway/library/templates/output/architecture-record.md` and
  `.highway/library/templates/output/architecture-catalog.md`.

## When not to use

- Do not use for a missing, lowercase, ambiguous, duplicated, or implicit ADR identifier.
- Do not use for a non-accepted ADR, an ADR alternative, implementation generation, capability
  artifact generation, lifecycle activity, diagram or threat-model production, brownfield onboarding,
  or architecture scoring.

## Direct invocation guard

The invocation must contain exactly one explicit uppercase `ADR######` identifier. When the
identifier is missing, respond before processing:

```text
Next Action: Provide the Architecture Decision Record to use.

Which ADR would you like to convert into a Reference Architecture?

Examples:
- ADR000001
- ADR000002
```

A missing identifier must allocate no identifier, create no Reference Architecture, and select no ADR automatically. The guard must not select the newest or only ADR, must not infer an ADR from context, and must not use filesystem order, timestamps, recency, environment state, or session memory. It must preserve every pre-operation architecture and catalog byte.

For an explicit identifier, validate exact format, existence, unique resolution, and accepted
status, then apply the canonical completeness validator and canonical readiness validator before
processing. Any invalid, missing, duplicate, ambiguous, malformed, incomplete, or not-ready ADR
stops without writes and uses the established failure outcome.

## Inputs

Required inputs are exactly one explicit `ADRXXXXXX`, the authoritative ADR catalog and resolved
ADR record, Highway Identity and Experience Standard context, and the two shared architecture
output templates. Optional read-only inputs are Profile, Objectives, Controls, and NFRs. Resolve
all inputs by declared identifiers and catalog entries, never by newest file, filesystem order,
timestamps, environment state, or session state.

## Ownership and evidence

ADR remains authoritative for its decision, rationale, alternatives, consequences, constraints, and
authorization to proceed to Reference Architecture. The architecture workflow owns the conceptual
architecture representation, architecture relationships, assumptions, risks, capability candidates,
and future implementation guidance. It does not modify ADR, Discovery, Request, Profile, Objective,
Control, or NFR artifacts; select an ADR alternative; authorize implementation; or create a
Reference Implementation.

Optional governance is advisory only:

- missing -> continue without fabricated evidence
- blocked -> continue and record the source condition as an architecture risk
- valid -> use as advisory context, relationships, constraints, or capability evidence
- malformed or inconsistent -> abort without writes

## Entities and state

An accepted ADR is one required source and produces at most one architecture. A Reference
Architecture record has a permanent catalog-owned `ARCHXXXXXX` identifier, the source `ADRXXXXXX`,
initial status `proposed`, and a deterministic title derived from the accepted ADR title. The
architecture catalog owns `Next ID`, direct record index entries, and ADR uniqueness. The state
transition is `no architecture -> validate -> allocate -> proposed architecture`; duplicate or
failed operations leave the prior state unchanged.

## Outputs

A successful run produces exactly one `architectures/ARCHXXXXXX.md` record and one direct entry in
`architectures/architectures.md`. The record follows `.highway/library/templates/output/architecture-record.md`.
The catalog follows `.highway/library/templates/output/architecture-catalog.md`. The record includes
Context, Architecture Summary, Architecture Style, Logical Components, Interaction Model, Trust
Boundaries, Deployment Pattern, Key Technologies, Inherited ADR Decisions, Constraints, Objective,
Control, and NFR Relationships, Required Capabilities, Assumptions, Risks, Reference Implementation
Guidance, and Traceability. Empty optional evidence is explicit `None`.

Required capabilities are advisory candidates only. No capability artifacts, capability identifiers,
implementation artifacts, or implementation authorization are produced. The output includes
Reference Implementation Guidance as a future handoff, and implementation authorization is excluded.

## Workflow

1. Validate that invocation contains exactly one explicit uppercase `ADRXXXXXX` identifier.
2. Resolve exactly one catalog entry and ADR record; require ADR status `accepted` and reject duplicate
   ADR-to-architecture entries.
3. Read optional governance in identifier order and apply the missing, blocked, valid, or malformed
   handling above without mutating any source.
4. Project the ADR decision, rationale, alternatives, consequences, constraints, relationships,
   and traceability into the architecture model without changing their meaning or selecting another
   alternative.
5. Generate the complete record and catalog in memory from the shared templates.
6. Validate all required sections, references, status, relationships, ordering, and scope (validation before persistence).
7. Read and reserve the exact catalog `Next ID`; retry an allocation conflict only within the
   existing bounded retry limit.
8. Publish the record and catalog atomically, advancing `Next ID` exactly once.
9. Verify source-byte preservation, one record, one catalog entry, proposed status, and the complete
   traceability chain before reporting completion.

## Determinism and failure handling

Identical declared inputs and catalog state produce byte-identical content, identifiers, ordering,
and catalog results. Components, relationships, capabilities, assumptions, risks, and sections use
stable identifier and declared-source ordering. Generated content contains No timestamps, dates,
environment identifiers, random values, or session identifiers.

Validation happens before persistence. Resolution, status, malformed or inconsistent governance,
duplicate, catalog allocation, validation, or write failure aborts without writes; no partial output
is reported as success. Allocation conflicts stop after the bounded retry limit. Existing ADR and all
upstream records remain byte-identical.

## Verification

Confirm exactly one accepted ADR, one permanent architecture identifier, one record, one direct
catalog entry, proposed status, complete required sections, stable relationships, unchanged source
bytes, and no deferred artifacts. Confirm the completion response includes Architecture ID, ADR ID,
record path, catalog path, and available `REQXXXXXX -> DISCXXXXXX -> ADRXXXXXX -> ARCHXXXXXX`
traceability. Confirm the architecture remains conceptual and implementation authorization is
excluded.

## Error Handling

Invalid, missing, ambiguous, duplicate, malformed, non-accepted, or inconsistently resolved inputs,
allocation conflicts after the bounded retry limit, validation failures, and write failures return a
clear failure with no partial architecture or catalog output.

## Example

`/highway-architecture ADR000001`
