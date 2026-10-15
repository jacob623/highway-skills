# Data Model: Highway Architecture and Implementation Invocation Guards

Feature 177 adds no durable data entity, schema, catalog type, or retained interaction state. The model below names the transient guard concepts and existing artifacts whose invariants the implementation must preserve.

## Invocation Request

A direct command received by one owning skill.

| Property | Architecture | Implementation |
|---|---|---|
| Command | `/highway-architecture` | `/highway-implementation` |
| Required identifier | Exactly one `ADR######` | Exactly one `ARCH######` |
| Missing input | Request an ADR with exact prompt and examples | Request an ARCH with exact prompt and examples |
| Persistence before validation | None | None |

## Source Resolution

The deterministic mapping from the explicit identifier to one authoritative source record.

- Architecture resolves one ADR through the authoritative ADR catalog.
- Implementation resolves one Reference Architecture through the authoritative architecture catalog.
- Missing, duplicate, or ambiguous resolution fails before processing.
- Filesystem order, timestamps, recency, context, environment state, and session state are not resolution inputs.

## Source Validation Result

The transient result of applying the existing canonical checks before processing.

- Identifier format is exact and uppercase.
- Artifact exists and resolves uniquely.
- Source is structurally complete.
- Source passes the canonical readiness validator and its established failure outcome.
- A failed result identifies the source or identifier and permits no write.

## Traceability Chain

The available immutable identifiers carried from upstream records into the downstream output.

```text
REQ -> DISC -> ADR -> ARCH -> RI
```

The architecture guard preserves the available prefix through `ARCH`; the implementation guard preserves the available chain through `RI`. Missing optional upstream identifiers are not fabricated.

## Existing Output Boundary

The existing owning workflows remain responsible for successful output and persistence.

- Architecture: one proposed `ARCH######` record and one catalog entry.
- Implementation: one proposed `RI######` record and one catalog entry.
- Allocation occurs only after validation and uses the existing catalog-owned next identifier.
- Any failure preserves pre-operation bytes.

## State Transitions

```text
no explicit identifier
  -> exact request for identifier
  -> no write

explicit identifier
  -> format and source resolution
  -> canonical completeness/readiness validation
  -> existing owning workflow
  -> allocate and publish only after successful validation

any failure before publication
  -> no allocation, no partial artifact, unchanged catalog and source bytes
```

## Deliberately Not Modelled

- ADR, Reference Architecture, and Reference Implementation record fields, which remain owned by their existing templates and workflows.
- A new readiness state, identifier family, source-ranking algorithm, session checkpoint, or runtime service.
- Plans, tasks, executable source code, infrastructure definitions, deployment authorization, or productization artifacts.
