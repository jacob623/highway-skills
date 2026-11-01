---
name: architecture-record
description: "Complete output skeleton for an accepted Reference Architecture record."
metadata:
  version: 2.1.0
---

## File Frontmatter

```yaml
---
id: RAXXXXXX
status: accepted
---
```

## Body

```markdown
# <purpose title>

## Current Decisions

- ADRXXXXXX

Carries: <what this architecture carries from these decisions, without copying a decision statement>

## Context

Applies: <when this architecture applies>
Leaves Open: <what this architecture leaves open>

## Architecture Summary

<high-level conceptual architecture description>

## Architecture Style

Style: <conceptual style classification>
Why: <why this style was chosen>

## Logical Components

- Component: <component>
  Responsibility: <what this component is responsible for>
  Interface: <the interface other components rely on, or `None`>

## Information

<what this architecture handles, who owns it, and what crosses a trust boundary, or `None`>

## Variation

Must Keep: <what every implementation must keep>
May Choose: <what an implementation may choose, or `None`>

## Responsibilities

- <a responsibility a realization covers or marks not applicable>

## Interaction Model

<conceptual communication and interaction flow>

## Trust Boundaries

<security, ownership, and responsibility boundaries, or `None`>

## Deployment Pattern

<conceptual deployment approach, or `None`>

## Constraints

<ADR, Control, and NFR constraints with source references, or `None`>

## Objective Relationships

- OBJXXXXXX: advances

## Control Relationships

- CTLXXXXXX: bound by

## NFR Relationships

- NFRXXXXXX: satisfies

## Required Capabilities

- Component: <component that offers it>
  Capability: <advisory capability text without a capability identifier>

## Assumptions

<architecture premises and source limitations, or `None`>

## Risks

<architecture risks and blocked-input conditions, or `None`>

## Reference Implementation Guidance

<future implementation guidance only; no implementation authorization>

## Traceability

Request: REQXXXXXX
Discovery: DISCXXXXXX
Current Decisions: <the ids listed above>
Architecture: RAXXXXXX
```

The body is rendered in this order. The title is the decision's purpose and names no product. The
identifier is `RA` plus eight hex digits. Status is
`accepted`. The record does not use an `ARCH` identifier or status `proposed`. Current Decisions
lists every current decision that names this architecture. A superseded or removed decision is not
in that list. The list does not copy a decision statement. A variation names no product, platform,
or vendor. Empty optional evidence uses explicit `None`. A relationship section with no link is
`None`. Each relationship line is one identifier and the one type for its section. Required
capabilities name the component that offers them and never receive capability identifiers. When no
capability applies, Required Capabilities is `None`. A removed catalog row has no record file.
