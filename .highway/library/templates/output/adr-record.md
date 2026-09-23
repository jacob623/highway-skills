---
name: adr-record
description: "Complete output skeleton for an accepted architecture decision record."
metadata:
  version: 1.0.0
---

## File Frontmatter

```yaml
---
id: ADRXXXXXX
request: REQXXXXXX
discovery: DISCXXXXXX
status: accepted
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

Candidate Solution Options:
- OPTXXXXXX: <Discovery option definition>

Comparison Matrix:
<Discovery comparison matrix copied without recalculation>

Reference Architecture Matches:
- <RA identifier, confidence, and recorded match reason, or `None`>

## Clarification Inputs

- <CLAR-REQ###### or CLAR-DISC###### status and contribution, or `None`>

## Context

<ADR-owned context and evidence-resolution record>

## Decision

Selected Option: OPTXXXXXX
Decision Statement: <ADR-owned decision statement>
Decision Authority: <ADR decision authority>
Decision Rationale: <traceable rationale>
Authorization: Proceed to Reference Architecture; implementation authorization is excluded.

## Recommendation Override

Discovery Recommended Option: OPTXXXXXX
Selected Option: OPTXXXXXX
Override Rationale: <required when selected option differs from Discovery recommendation>

## Decision Confidence

Discovery Confidence: <Discovery confidence>
Confidence Considerations: <ADR-owned considerations without rescoring>

## Alternatives Considered

### OPTXXXXXX

Outcome: <accepted or rejected/evaluated>
Selection Status: Selected or Rejected or Evaluated
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

<stable typed relationship list, or `None`>

## Control Relationships

<stable typed relationship list, or `None`>

## NFR Relationships

<stable typed relationship list, or `None`>

## Reference Architecture Handoff

Selected Option: OPTXXXXXX
Reference Architecture Matches: <Discovery matches with confidence and reasons, or `None`>
Architecture Direction: <direction, or `None`>
Required Architecture Work: <work list, or `None`>
Authorization to Proceed: Proceed to Reference Architecture; do not implement.

Supersedes: None
Superseded By: None
```

The body is rendered in this order. Recommendation Override is present only when the selected
option differs from the Discovery recommendation. Open Clarification Findings is present only when
an open finding contributes. Every Reference Architecture Handoff field remains present and uses a
valid value or explicit `None`.