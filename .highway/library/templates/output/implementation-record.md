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

## Context

<architecture context and realization purpose>

## Implementation Summary

<high-level conceptual-to-realization blueprint>

## Technology Realization

- <architecture intent>: <technology or mechanism and deterministic supporting evidence>

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
