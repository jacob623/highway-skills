# Contract: ADR Record Shape

## Changed and new body sections

```markdown
## Discovery Reference

Discovery: DISCXXXXXX
Request: REQXXXXXX
Recommendation: OPTXXXXXX
Recommendation Rationale: <Discovery rationale>

Comparison Matrix:
<Discovery comparison matrix copied without recalculation>

Reference Architecture Matches:
- <RA identifier, confidence, and recorded match reason, or `None`>

## Context

Problem: <the problem this decision responds to>
Forces: <the forces that make the decision necessary>
Evidence: <evidence-resolution record, or `None`>

## Decision

Selected Option: OPTXXXXXX
...

## Decision Scope

Covers: <what this decision decides>
Leaves Open: <what this decision does not decide, or `None`>

## Revisit When

<the condition that should cause this decision to be reopened, or `None`>

## Alternatives Considered

### OPTXXXXXX

Definition: <what this option is>
Outcome: <Selected, Rejected, or Evaluated>
Reason: <ADR-owned reason>

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
Reference Implementation: <RI id, or `None`>
Authorization to Proceed: Proceed to Reference Architecture; do not implement.
```

## Onboarding values

| Field | Value |
|---|---|
| `request` / `discovery` | `onboarding` / `highway` |
| Recommendation, Recommendation Rationale, Comparison Matrix, matches | `None` |
| Selected Option | Adopted provider name |
| Selection Source | `Accepted onboarding mapping` |
| Decision Confidence | `None` |
| Alternative heading | Alternative name, never an option id |

## Catalog status

`accepted`, `superseded`, or `removed`.

## Removed

- `Selection Status:`
- `Candidate Solution Options:`
- `Selected Option:` and `Reference Architecture Matches:` in the handoff
