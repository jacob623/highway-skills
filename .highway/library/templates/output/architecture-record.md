---
name: architecture-record
description: "Complete output skeleton for a proposed Reference Architecture record."
metadata:
  version: 1.0.0
---

## File Frontmatter

```yaml
---
id: ARCHXXXXXX
adr: ADRXXXXXX
status: proposed
---
```

## Body

```markdown
# <deterministic architecture title>

## ADR Reference

ADR: ADRXXXXXX
Title: <accepted ADR title>
Status: accepted

## Context

<why the architecture exists and the evidence used>

## Architecture Summary

<high-level conceptual architecture description>

## Architecture Style

<conceptual style classification; implementation authorization is excluded>

## Logical Components

- <component>: <purpose>

## Interaction Model

<conceptual communication and interaction flow>

## Trust Boundaries

<security, ownership, and responsibility boundaries, or `None`>

## Deployment Pattern

<conceptual deployment approach, or `None`>

## Key Technologies

<ADR-supported technology considerations; remain conceptual, or `None`>

## Inherited ADR Decisions

- ADRXXXXXX: <decision inherited without alteration>

## Constraints

<ADR, Control, and NFR constraints with source references, or `None`>

## Objective Relationships

<stable OBJXXXXXX relationship list, or `None`>

## Control Relationships

<stable CTLXXXXXX relationship list, or `None`>

## NFR Relationships

<stable NFRXXXXXX relationship list, or `None`>

## Required Capabilities

<advisory capability candidates without capability identifiers or artifacts, or `None`>

## Assumptions

<architecture premises and source limitations, or `None`>

## Risks

<architecture risks and blocked-input conditions, or `None`>

## Reference Implementation Guidance

<future implementation guidance only; no implementation authorization>

## Traceability

Request: REQXXXXXX
Discovery: DISCXXXXXX
ADR: ADRXXXXXX
Architecture: ARCHXXXXXX
```

The body is rendered in this order. The initial status is always `proposed`; the source ADR is
accepted and immutable. Empty optional evidence uses explicit `None`. Capability candidates are
advisory text only and never receive capability identifiers or artifacts.
