# Data Model: ADR Record Completeness

## ADR record

### Frontmatter

| Field | Rule |
|---|---|
| `id` | Unchanged |
| `request` | Request id, or `onboarding` |
| `discovery` | Discovery id, or `highway` |
| `status` | `accepted`, or `superseded` exactly when `superseded_by` names an ADR |
| `supersedes` | ADR id or `None` |
| `superseded_by` | ADR id or `None` |

### Body, in order

| Section | Change |
|---|---|
| Discovery Reference | Candidate Solution Options removed. Onboarding: Recommendation, Recommendation Rationale, Comparison Matrix, and matches are `None` |
| Clarification Inputs | Unchanged |
| Context | Problem, Forces, Evidence |
| Decision | Selected Option is an option id or the onboarding provider name. Selection Source adds `Accepted onboarding mapping` |
| Decision Scope | New. Covers, Leaves Open |
| Revisit When | New. A condition or `None` |
| Recommendation Override | Unchanged. Omitted when the choice matches or there is no recommendation |
| Decision Confidence | Unchanged. Onboarding: `None` |
| Alternatives Considered | Definition, Outcome, Reason. Selection Status removed. Includes the chosen option as `Selected` |
| Assumptions, Risks, Open Clarification Findings, Consequences, Constraints | Unchanged |
| Objective, Control, NFR Relationships | Typed lines |
| Reference Architecture Handoff | Adds Reference Architecture and Reference Implementation. Drops Selected Option and matches |

## Handoff state

| Event | Reference Architecture | Reference Implementation | Chain |
|---|---|---|---|
| ADR written | `None` | `None` | Open |
| Architecture written, ADR updated | RA id | `None` | Open |
| Architecture written, ADR update failed | `None` | `None` | Not complete |
| Implementation written, ADR updated | RA id | RI id | Complete |
| Implementation written, ADR update failed | RA id | `None` | Not complete |

A later invocation that finds the existing record fills a field that is still `None`.

## Catalog row status

| Status | Record file | Id taken |
|---|---|---|
| `accepted` | Present | Yes |
| `superseded` | Present | Yes |
| `removed` | Absent | Yes |
