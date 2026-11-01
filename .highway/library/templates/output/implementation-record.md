---
name: implementation-record
description: "Complete output skeleton for an accepted Reference Implementation record."
metadata:
  version: 2.1.0
---

## File Frontmatter

```yaml
---
id: RIXXXXXX
architecture: RAXXXXXX
status: accepted
---
```

## Body

```markdown
# <product title>

## Architecture Reference

Architecture: RAXXXXXX
Title: <accepted architecture title>
Status: accepted

## Variation Choices

- <what the architecture left free>: <the choice this implementation made>

## Coverage

| Responsibility | Status |
|---|---|
| <architecture responsibility> | covered or not applicable |

Conformance: compatible or incomplete

## Realized Interfaces

- <architecture interface>: <realized interface>

Conformance Evidence: <how conformance was shown, or `None`>

## Limitations

<limitations of this accepted realization, or `None`>

## Technology Choice

Intent: <architecture intent>
Choice: <technology or mechanism>
Reason: <why this choice>
Evidence: <deterministic supporting evidence>

## Context

<architecture context and realization purpose>

## Implementation Summary

<high-level conceptual-to-realization blueprint>

## Realized Capabilities

- Title: <business-recognizable outcome>
  Realized By: <provider, platform, product, technology, service, process, or mechanism; one or more>
  Evidence: <accepted implementation evidence explaining the realization>

## Runtime Components

- <runtime component>: <realized purpose and architecture relationship>

## Data Realization

<realized data stores, ownership, and flows, or `None`>

## Integration Realization

<realized interactions and integration mechanisms, or `None`>

## Security Control Realization

<Control-to-mechanism mappings without changing Control ownership, or `None`>

## NFR Realization

<NFR-to-implementation requirement mappings without changing NFR ownership, or `None`>

## Assumptions

<implementation premises and source limitations, or `None`>

## Risks

<blocked evidence, unknowns, and realization risks, or `None`>

## Constraints

<inherited architecture and governance constraints, or `None`>

## Dependencies

<upstream evidence and external realization dependencies, or `None`>

## Traceability

Request: REQXXXXXX
Discovery: DISCXXXXXX
ADR: ADRXXXXXX
Implementation: RIXXXXXX
```

The body is rendered in this order. The title is the product or named mechanism, followed by "for"
and the purpose only when that product title is taken. The identifier is `RI` plus eight hex
digits. The parent is an
`RA` id. Status is `accepted`. The record does not use an `ARCH` parent or status `proposed`. The
architecture is named once, in Architecture Reference. Coverage rows are the architecture's stated
responsibilities. Each row is covered or not applicable. Conformance is `compatible` when every row
is one of those two, and that record has no gap section and no conflict section. Conformance is
`incomplete` when a stated responsibility is uncovered, and the gap is stated. A technology choice
is stated once, with its intent, reason, and evidence. Empty optional evidence uses explicit
`None`. Technology choices must include architecture intent and deterministic evidence.
