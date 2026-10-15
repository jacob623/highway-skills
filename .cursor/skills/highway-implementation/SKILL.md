---
name: highway-implementation
description: "Manages the repository-wide implementation baseline."
usage: "Invoke as `/highway-implementation` with one Reference Architecture ID."
compatibility: all
metadata:
  version: 1.0.0
---

# highway-implementation

## Purpose

Create one deterministic, conceptual-to-realization Reference Implementation from exactly one accepted Reference Architecture while preserving architecture, governance, and traceability ownership as immutable evidence through the `REQ -> DISC -> ADR -> RA -> RI -> Plan -> Tasks -> Generated Code` workflow.

## Experience

Reference Implementation work follows the Highway Experience Standard. Put `Next Action` first,
describe realization decisions and risks in user-relevant terms, and keep the downstream handoff
explicit. `User Exits` are `pause`, `cancel`, or `stop responding`; `Owner Outcomes` are `declined`,
`aborted`, or `blocked`. This workflow does not create plans, tasks, executable source code,
infrastructure definitions, deployment authorization, or self-service productization artifacts.

## When to use

- Exactly one explicit uppercase `ARCH######` identifier is available.
- The identifier resolves uniquely through the authoritative Reference Architecture catalog.
- The resolved Reference Architecture is accepted and its decisions, components, interactions,
  trust boundaries, constraints, and traceability are readable.
- The implementation catalog and both shared implementation templates are available:
  `.highway/library/templates/output/implementation-record.md` and
  `.highway/library/templates/output/implementation-catalog.md`.

## When not to use

- Do not use for missing, lowercase, ambiguous, duplicated, malformed, or implicit architecture
  identifiers.
- Do not use for a Reference Architecture that is not accepted.
- Do not redesign architecture, change an architecture decision, select a different ADR option,
  modify upstream artifacts, grant deployment authorization, create plans or tasks, generate code or IaC, or
  produce self-service productization artifacts.

## Direct invocation guard

The invocation must contain exactly one explicit uppercase `ARCH######` identifier. When the
identifier is missing, respond before processing:

```text
Next Action: Provide the Reference Architecture to implement.

Which Reference Architecture would you like to use?

Examples:
- ARCH000001
- ARCH000002
```

A missing identifier must allocate no identifier, create no implementation artifact, and select no architecture automatically. The guard must not select the newest or only ARCH, must not infer an ARCH from context, and must not use filesystem order, timestamps, recency, environment state, or session memory. It must preserve every pre-operation implementation and catalog byte.

For an explicit identifier, validate exact format, existence, unique resolution, and accepted
status, then apply the canonical completeness validator and canonical readiness validator before
processing. Any invalid, missing, duplicate, ambiguous, malformed, incomplete, or not-ready ARCH
stops without writes and uses the established failure outcome.

## Inputs

Required inputs are exactly one explicit `ARCH######`, the authoritative architecture catalog and
resolved accepted architecture record, the implementation catalog, both shared implementation
output templates, and Highway Identity and Experience Standard context. The owner must provide one or more
explicit Implementation Selections before compatibility assessment. A selection names the
intended implementation component, technology or mechanism, realization category, and owner
evidence; missing selections stop before any RI or catalog write. Optional read-only inputs are
`CLAR-ARCH######`, Profile, Objectives, Controls, and NFRs. Resolve all inputs by declared
identifiers and catalog entries, never by newest file, filesystem order, timestamps, environment
state, or session state.

## Architecture Compatibility Assessment

Assess Implementation Selections against the accepted architecture before generating or allocating
an RI. Extract Logical Components, Interaction Model, Trust Boundaries, Deployment Pattern, Required
Capabilities, Constraints, Control Relationships, NFR Relationships, and Reference Implementation
Guidance. The architecture remains authoritative; an implementation selection cannot silently
redesign it, override an ADR, or invent an omitted responsibility.

The assessment produces exactly one result: `Compatible`, `Incomplete`, or `Incompatible`.
Evaluate the ordered realization categories Compute, Messaging, Persistence, Identity, Networking,
Security, Observability, Recovery, Deployment, and Operations. Each category receives exactly one
coverage status: `Satisfied`, `Unsatisfied`, or `Not Applicable`. Preserve stable architecture and
selection ordering, and never omit an applicable architecture responsibility. `Not Applicable`
requires evidence that the category is outside the accepted architecture.

Implementation Selections are user-owned and may include future observed brownfield components,
but this workflow does not create a separate brownfield discovery or validation engine. Normalize
equivalent names and ordering deterministically while preserving the original selection evidence.

For `Incomplete`, report an Implementation Gap Analysis for every unsatisfied responsibility with
Missing Capability, Why It Matters, Suggested Realization, Recommendation Confidence, evidence, and
an owner resolution action. Recommendations are evidence-backed; when evidence is insufficient,
record `Unknown` rather than inventing a technology. Do not generate or persist an RI while any gap
remains unresolved.

For `Incompatible`, report Implementation Conflicts with Architecture Requirement, Implementation
Selection, Conflict Explanation, evidence, and impact. Do not silently repair the architecture.
Offer exactly two resolution paths: `Resolve Implementation` or `Revisit Architecture`. Do not
generate or persist an RI for an incompatible assessment.

For `Compatible`, retain the complete Coverage Summary and produce Technology Realization Rationale
for every selected technology or mechanism, including architecture intent, reason selected, and
supporting evidence. Only this outcome permits the existing RI validation, allocation, and atomic
publication workflow. A failed assessment performs no RI allocation, identifier advancement,
implementation write, or catalog write; in short, it produces no RI.

Architecture Authority is the accepted Reference Architecture and its ADR decisions. Controls and
NFRs remain authoritative for their own records; their realization is reported as a read-only
projection with traceability, never as a source mutation.

## Ownership and evidence

Reference Architecture remains authoritative for architecture decisions, logical architecture,
components, interactions, trust boundaries, rationale, constraints, and ownership. Objectives,
Controls, NFRs, Profile, and Clarification remain authoritative for their own records. The
implementation workflow owns implementation realization, technology realization, runtime topology,
deployment realization, lifecycle realization, assumptions, risks, constraints, dependencies, and
the downstream handoff.

The workflow does not redesign architecture. The workflow will retry an allocation conflict no more than three times before the operation aborts without writes.

Resolve evidence in this exact first-match order: Reference Architecture, `CLAR-ARCH######`,
Objectives, Controls, NFRs, then Profile.

Optional evidence is advisory only:

- missing -> continue without fabricated evidence
- blocked -> continue and record the source condition as an implementation risk
- valid -> use as advisory realization, relationship, constraint, risk, or dependency evidence
- malformed or inconsistent Profile, Objective, Control, or NFR -> abort without writes
- malformed Clarification -> preserve bytes, ignore clarification evidence, and fall back to the
  authoritative architecture evidence

Clarification is read-only. `complete` consumes resolved findings; `in-progress` consumes resolved
and open findings as advisory context; `not-started` continues without clarification evidence; and
`blocked` is recorded as an implementation risk. Open findings never block generation.

## Entities and state

One accepted Reference Architecture produces at most one Reference Implementation. A Reference
Implementation record has a permanent catalog-owned `RI######` identifier, source `ARCH######`,
initial status `proposed`, and a deterministic title derived from the accepted architecture title.
The implementation catalog owns `Next ID`, direct record index entries, and architecture uniqueness.
The state transition is `no implementation -> validate -> allocate -> proposed implementation`;
duplicate or failed operations leave the prior state unchanged.

## Outputs

A successful run produces exactly one `implementations/RIXXXXXX.md` record and one direct entry in
`implementations/implementations.md`. The record follows
`.highway/library/templates/output/implementation-record.md`. The catalog follows
`.highway/library/templates/output/implementation-catalog.md`.

The shared implementation record template owns the complete retained structure for Context,
Implementation Summary, Technology Realization, Runtime Components, Deployment Topology,
Environment Strategy, Data Realization, Integration Realization, Security Control Realization, NFR
Realization, Lifecycle Activities, Assumptions, Risks, Constraints, Dependencies, and Traceability.
The initial status is always `proposed`. NFR Realization and Security Control Realization remain
read-only projections of their source ownership.

The implementation is a blueprint and clean downstream handoff only. It does not produce plans,
tasks, executable source code, infrastructure definitions, deployment authorization, or
self-service productization artifacts.

## Realization contract

Technology Realization translates architecture components into implementation components while
preserving architecture intent. Technology choices are permitted only when the architecture permits
multiple realizations and deterministic implementation evidence supports the choice. Every choice
references the architecture intent and supporting evidence; unsupported choices remain unknown rather
than invented.

Security Control Realization maps available Controls to implementation mechanisms such as encryption,
secrets management, MFA, audit logging, or access control without changing Control ownership. NFR
Realization maps available NFRs to implementation requirements such as scalability, recovery,
availability, and monitoring without changing NFR ownership. Lifecycle Activities include design,
build, test, deploy, operate, monitor, and improve realization mappings.

## Workflow

1. Validate that invocation contains exactly one explicit uppercase `ARCH######` identifier.
2. Resolve exactly one architecture catalog entry and record; require status `accepted` and reject
   duplicate architecture-to-implementation entries.
3. Snapshot Clarification and governance evidence in the declared precedence order without mutating
   any source; apply malformed Clarification fallback to architecture evidence.
4. Normalize the owner-provided Implementation Selections and assess compatibility against every
   applicable architecture responsibility.
5. Stop with the required gap or conflict report when the result is `Incomplete` or `Incompatible`.
6. Project architecture intent, components, interactions, trust boundaries, constraints, risks,
   dependencies, governance realization, and available traceability into the implementation model.
7. Generate the complete record and catalog in memory using the shared implementation templates.
8. Validate all required sections, references, status, relationships, ordering, technology-choice
   evidence, and scope before persistence. This is validation before persistence.
9. Read and reserve the exact catalog `Next ID`; retry an allocation conflict no more than three
   times.
10. Publish the record and catalog atomically, advancing `Next ID` exactly once.
11. Verify source-byte preservation, one record, one direct catalog entry, proposed status, complete
   traceability, all seven lifecycle activities, and absence of deferred artifacts before reporting
   completion.

## Determinism and failure handling

Identical declared inputs and catalog state produce byte-identical content, section ordering,
traceability, identifier allocation behavior, and catalog results. Components, relationships,
assumptions, risks, dependencies, and sections use stable identifier and declared-source ordering.
Generated content contains No timestamps, creation dates, modification dates, environment metadata,
random values, or session identifiers.

Validation happens before persistence. Resolution, malformed or inconsistent evidence, duplicate,
catalog allocation, validation, or write failure aborts without writes; no partial output is reported
as success. Allocation conflicts stop after three retries. Existing architecture and all upstream
records remain byte-identical. Record and catalog publication is atomic.

## Verification

Confirm exactly one accepted ARCH input, one permanent RI identifier, one record, one direct catalog
entry, proposed status, complete required sections, stable relationships, unchanged upstream bytes,
architecture-traceable implementation decisions, realized Controls and NFRs, all seven lifecycle
activities, complete available traceability, and no deferred artifacts.

Confirm the completion response includes Implementation ID, Architecture ID, record path, catalog
path, and available `REQXXXXXX -> DISCXXXXXX -> ADRXXXXXX -> ARCHXXXXXX -> RIXXXXXX` traceability.
Confirm no executable code, infrastructure definitions, plans, tasks, deployment authorization, or
self-service productization artifacts were created.

## Error Handling

Invalid, missing, ambiguous, duplicated, malformed, non-accepted, or inconsistently resolved inputs,
malformed governance, allocation conflicts after three retries, validation failures, and write
failures return a clear failure with no partial implementation or catalog output and preserve every
pre-operation byte.

## Example

`/highway-implementation ARCH000001`
