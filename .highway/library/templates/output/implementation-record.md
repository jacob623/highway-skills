---
name: implementation-record
description: "Complete output skeleton for a proposed Reference Implementation blueprint."
metadata:
  version: 1.0.0
---

## File Frontmatter

```yaml
---
id: RIXXXXXX
architecture: ARCHXXXXXX
status: proposed
---
```

## Body

```markdown
# <deterministic implementation title>

## Architecture Reference

Architecture: ARCHXXXXXX
Title: <accepted architecture title>
Status: accepted

## Implementation Selections

- Selection: <owner-provided component, technology, or mechanism>
  Category: <Compute | Messaging | Persistence | Identity | Networking | Security | Observability | Recovery | Deployment | Operations>
  Owner Evidence: <declared selection evidence>
  Normalized Name: <deterministic normalized name>

## Architecture Compatibility Assessment

Result: Compatible | Incomplete | Incompatible
Architecture Authority: <accepted Reference Architecture and governing ADR decisions>
Assessment Scope: <architecture responsibilities assessed before RI generation>

## Coverage Summary

| Category | Status | Architecture Responsibility | Implementation Selection | Evidence |
|---|---|---|---|---|
| Compute | Satisfied | <responsibility or None> | <selection or None> | <evidence or None> |
| Messaging | Not Applicable | <responsibility or None> | <selection or None> | <evidence or None> |
| Persistence | Not Applicable | <responsibility or None> | <selection or None> | <evidence or None> |
| Identity | Not Applicable | <responsibility or None> | <selection or None> | <evidence or None> |
| Networking | Not Applicable | <responsibility or None> | <selection or None> | <evidence or None> |
| Security | Not Applicable | <responsibility or None> | <selection or None> | <evidence or None> |
| Observability | Not Applicable | <responsibility or None> | <selection or None> | <evidence or None> |
| Recovery | Not Applicable | <responsibility or None> | <selection or None> | <evidence or None> |
| Deployment | Not Applicable | <responsibility or None> | <selection or None> | <evidence or None> |
| Operations | Not Applicable | <responsibility or None> | <selection or None> | <evidence or None> |

## Implementation Gaps

Result: Incomplete

- Missing Capability: <capability or None>
  Why It Matters: <architecture or governance impact>
  Suggested Realization: <evidence-backed suggestion or Unknown>
  Recommendation Confidence: <High | Medium | Low | Unknown>
  Evidence: <source evidence or None>
  Owner Resolution Action: <action required before reassessment>

## Implementation Conflicts

Result: Incompatible

- Architecture Requirement: <accepted requirement>
  Implementation Selection: <conflicting selection>
  Conflict Explanation: <direct contradiction and impact>
  Evidence: <source evidence or None>
  Resolution Paths: Resolve Implementation; Revisit Architecture

## Context

<architecture context and realization purpose>

## Implementation Summary

<high-level conceptual-to-realization blueprint>

## Realized Capabilities

- Title: <business-recognizable outcome>
  Realized By: <provider, platform, product, technology, service, process, or mechanism; one or more>
  Evidence: <accepted implementation evidence explaining the realization>

## Technology Realization

- <architecture intent>: <technology or mechanism and deterministic supporting evidence>

## Technology Realization Rationale

- Selection: <implementation selection>
  Architecture Intent: <preserved architecture responsibility>
  Reason Selected: <deterministic reason>
  Supporting Evidence: <architecture, governance, or owner evidence>

## Runtime Components

- <runtime component>: <realized purpose and architecture relationship>

## Deployment Topology

<realized deployment arrangement, or `None`>

## Environment Strategy

<development, test, staging, and production realization, or `None`>

## Data Realization

<realized data stores, ownership, and flows, or `None`>

## Integration Realization

<realized interactions and integration mechanisms, or `None`>

## Security Control Realization

<Control-to-mechanism mappings without changing Control ownership, or `None`>

## NFR Realization

<NFR-to-implementation requirement mappings without changing NFR ownership, or `None`>

## Lifecycle Activities

### Design

<design realization mapping, or `None`>

### Build

<build realization mapping, or `None`>

### Test

<test realization mapping, or `None`>

### Deploy

<deploy realization mapping, or `None`>

### Operate

<operate realization mapping, or `None`>

### Monitor

<monitor realization mapping, or `None`>

### Improve

<improve realization mapping, or `None`>

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
Architecture: ARCHXXXXXX
Implementation: RIXXXXXX
```

The body is rendered in this order. The initial status is always `proposed`; the source Reference
Architecture and governance records remain immutable. Empty optional evidence uses explicit `None`.
Technology choices must include architecture intent and deterministic evidence.
