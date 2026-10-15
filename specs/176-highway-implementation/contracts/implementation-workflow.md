# Reference Implementation Workflow Contract

## Invocation

```text
/highway-implementation ARCHXXXXXX
```

The invocation MUST contain exactly one explicit uppercase `ARCH######` identifier. The workflow
resolves that identifier through the authoritative Reference Architecture catalog and requires the
resolved architecture to have status `accepted`.

## Input Contract

Required:

- One exact `ARCH######` identifier.
- Reference Architecture catalog and resolved architecture record.
- Implementation catalog and implementation output templates.
- Highway Identity and Highway Experience Standard context.

Optional:

- `CLAR-ARCH######` clarification record.
- Profile, Objectives, Controls, and NFR baselines.

Evidence is consumed in this order: Reference Architecture, `CLAR-ARCH######`, Objectives,
Controls, NFRs, then Profile. Missing optional evidence continues without invention. Blocked optional
evidence continues and becomes an implementation risk. Malformed or internally inconsistent Profile,
Objective, Control, or NFR input aborts without writes. Malformed Clarification is preserved,
excluded from evidence, and falls back to the authoritative architecture; open findings never block
generation.

## Ownership Contract

Reference Architecture remains authoritative for architecture decisions, logical architecture,
components, interactions, trust boundaries, rationale, constraints, and authorization boundaries.
Objectives remain authoritative for business outcomes. Controls remain authoritative for safeguards.
NFRs remain authoritative for operational expectations. Clarification remains authoritative for
findings, responses, status, and resolution history.

The implementation workflow owns implementation realization, technology realization, deployment
realization, runtime topology, implementation structure, lifecycle realization, assumptions, risks,
constraints, dependencies, and future planning handoff. It MUST NOT modify Requests, Discovery
records, ADRs, Reference Architectures, Objectives, Controls, NFRs, or Clarifications; redesign the
architecture; select a different ADR option; authorize deployment; or create plans, tasks, source
code, infrastructure definitions, or self-service productization artifacts.

## Output Contract

A successful run produces exactly:

- `implementations/RIXXXXXX.md`, status `proposed`, referencing the accepted `ARCHXXXXXX`.
- One direct entry in `implementations/implementations.md`.
- An allocation that advances the catalog exactly once.
- A completion response containing the RI identifier, ARCH identifier, record path, catalog path,
  and available REQ, DISC, ADR, ARCH, Objective, Control, and NFR traceability.

The implementation record follows the shared implementation record template. The catalog follows the
shared implementation catalog template.

## Realization Contract

The record includes Context, Implementation Summary, Technology Realization, Runtime Components,
Deployment Topology, Environment Strategy, Data Realization, Integration Realization, Security
Control Realization, NFR Realization, Lifecycle Activities, Assumptions, Risks, Constraints,
Dependencies, and Traceability.

Architecture remains technology-agnostic. Implementation may choose concrete technologies only when
the architecture permits multiple realizations and deterministic evidence supports the choice. Every
choice references the architecture intent and its evidence. Controls map to implementation
mechanisms, NFRs map to implementation requirements, and all seven lifecycle activities are present.

## Determinism and Persistence Contract

For identical declared inputs and catalog state, content, ordering, traceability, identifiers, and
catalog results are byte-identical. Output excludes timestamps, dates, environment metadata, random
values, and session identifiers. Validation completes before persistence. Record and catalog
publication is atomic. Allocation conflicts retry no more than three times. Any resolution,
validation, duplicate, allocation, or write failure preserves every pre-operation byte and leaves
no partial implementation output.

## Completion Contract

```text
Reference Implementation Created

Implementation Identifier: RIXXXXXX
Architecture Identifier: ARCHXXXXXX

Record Path:
implementations/RIXXXXXX.md

Catalog Path:
implementations/implementations.md

Traceability:
REQXXXXXX
-> DISCXXXXXX
-> ADRXXXXXX
-> ARCHXXXXXX
-> RIXXXXXX
```
