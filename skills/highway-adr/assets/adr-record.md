---
name: adr-record
description: "Complete output skeleton for an accepted architecture decision record."
metadata:
  version: 3.1.0
---

## File Frontmatter

```yaml
---
id: ADRXXXXXX
request: REQXXXXXX | onboarding
discovery: DISCXXXXXX | highway
status: accepted | superseded
supersedes: None
superseded_by: None
---
```

## Body

```markdown
# <deterministic ADR title>

## Discovery Reference

Discovery: DISCXXXXXX
Request: REQXXXXXX
Recommendation: OPTXXXXXX
Recommendation Rationale: <Discovery rationale>

Comparison Matrix:
<Discovery comparison matrix copied without recalculation>

Reference Architecture Matches:
- <RA identifier, confidence, and recorded match reason, or `None`>

## Clarification Inputs

None

## Context

Problem: <the problem this decision responds to>
Forces: <the forces that make the decision necessary>
Evidence: <evidence-resolution record, or `None`>

## Decision

Selected Option: OPTXXXXXX
Selection Source: User-provided explicit selection
Decision Statement: <ADR-owned decision statement>
Decision Authority: <ADR decision authority>
Decision Rationale: <traceable rationale>
Authorization: Proceed to Reference Architecture; implementation authorization is excluded.

## Decision Scope

Covers: <what this decision decides>
Leaves Open: <what this decision does not decide, or `None`>

## Revisit When

<the condition that should cause this decision to be reopened, or `None`>

## Recommendation Override

Discovery Recommended Option: OPTXXXXXX
Selected Option: OPTXXXXXX
Override Rationale: <required when selected option differs from Discovery recommendation>

## Decision Confidence

Discovery Confidence: <Discovery confidence>
Confidence Considerations: <ADR-owned considerations without rescoring>

## Alternatives Considered

### OPTXXXXXX

Definition: <what this option is>
Outcome: <Selected, Rejected, or Evaluated>
Reason: <ADR-owned reason>

## Assumptions

<assumptions, including permitted open-finding uncertainty, or `None`>

## Risks

<risks, blocked Clarification conditions, and conflict guidance, or `None`>

## Open Clarification Findings

- <open finding identifier, or `None` when no contributing finding exists>

## Consequences

Positive: <positive consequences>
Negative: <negative consequences>
Operational: <operational consequences>
Governance: <governance consequences>

## Constraints

<constraints and traceable evidence, or `None`>

## Objective Relationships

- OBJXXXXXX: advances

## Control Relationships

- CTLXXXXXX: bound by

## NFR Relationships

- NFRXXXXXX: satisfies

## Reference Architecture Handoff

Architecture Direction: <direction, or `None`>
Required Architecture Work: <work list, or `None`>
Reference Architecture: <RA id, or `None`>
Authorization to Proceed: Proceed to Reference Architecture; do not implement.
```

The body is rendered in this order. Recommendation Override is present only when the selected
option differs from the Discovery recommendation, and is omitted when there is no Discovery
recommendation. Open Clarification Findings is present only when an open finding contributes.
Every Reference Architecture Handoff field remains present and uses a valid value or explicit
`None`. The handoff does not repeat the selected option or the Reference Architecture Matches.
The handoff contains no implementation entry. Reference Architecture is `None` until an architecture
exists. A reused architecture is named there when the decision is accepted. Updating that field
changes no other ADR field. A decision that runs beside the current decision of several
architectures lists every architecture it names there, in id order, separated by a comma and a
space, the same as its catalog Architecture ID cell. Its Required Architecture Work is `None`.

Alternatives Considered lists every option, including the selected one. Alternative outcomes are
exactly `Selected`, `Rejected`, or `Evaluated`; `Evaluated` means viable but not selected, while
`Rejected` means invalid or unsuitable. A Discovery-backed alternative is headed by its option id.

Each relationship line is one identifier and the one type for its section: Objectives use
`advances`, Controls use `bound by`, and NFRs use `satisfies`. A section with no relationship is
`None`.

`status` is `superseded` exactly when `superseded_by` names an ADR, and `accepted` otherwise. A
superseded record keeps its file. Supersession metadata is authoritative only in frontmatter.

An onboarding ADR uses `request: onboarding` and `discovery: highway`. Discovery, Request,
Recommendation, Recommendation Rationale, Comparison Matrix, Reference Architecture Matches, and
Discovery Confidence are `None`. Selected Option is the adopted provider name, and Selection Source
is `Accepted onboarding mapping`. Each alternative is headed by its name. The record contains no
option id.
