# Reference Architecture Workflow Contract

## Invocation

```text
/highway-architecture ADRXXXXXX
```

The invocation MUST contain exactly one explicit uppercase `ADRXXXXXX` identifier. The workflow
resolves that identifier through the authoritative ADR catalog and requires the resolved ADR to have
status `accepted`.

## Input Contract

Required:

- One exact ADR identifier.
- ADR catalog and resolved ADR record.
- Architecture record and catalog output templates.
- Highway Identity and Highway Experience Standard context.

Optional:

- Profile, Objectives, Controls, and NFRs.

Optional input handling:

- Missing: continue without fabricated evidence.
- Blocked: continue and record the source condition as an architecture risk.
- Malformed or internally inconsistent: abort without writes.

## Ownership Contract

ADR remains authoritative for decision, rationale, alternatives, consequences, and authorization to
proceed to Reference Architecture. The Reference Architecture workflow owns the conceptual
architecture representation, architecture relationships, assumptions, risks, capabilities, and
future implementation guidance. It MUST NOT modify ADR, Discovery, Request, Profile, Objective,
Control, or NFR artifacts; select an ADR alternative; authorize implementation; or create a
Reference Implementation.

## Output Contract

A successful run produces exactly:

- `architectures/ARCHXXXXXX.md`, status `proposed`, referencing the accepted ADR.
- One direct entry in `architectures/architectures.md`.
- An allocation that advances the catalog exactly once.
- A completion response containing the Architecture ID, ADR ID, record path, catalog path, and
  available traceability chain.

The architecture record follows `.highway/library/templates/output/architecture-record.md`. The
catalog follows `.highway/library/templates/output/architecture-catalog.md`.

## Determinism and Persistence Contract

For identical declared inputs and catalog state, content, ordering, identifiers, and catalog results
are byte-identical. Output excludes timestamps, dates, environment identifiers, random values, and
session identifiers. Validation completes before persistence. Record and catalog publication is
atomic; any resolution, validation, duplicate, allocation, or write failure preserves every
pre-operation byte and leaves no partial architecture output. Allocation conflicts stop after the
existing bounded retry limit.

## Completion Contract

```text
Reference Architecture Created

Architecture Identifier: ARCHXXXXXX
ADR Identifier: ADRXXXXXX

Record Path:
architectures/ARCHXXXXXX.md

Catalog Path:
architectures/architectures.md

Traceability:
REQXXXXXX
-> DISCXXXXXX
-> ADRXXXXXX
-> ARCHXXXXXX
```
