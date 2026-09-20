# Data Model: Discovery Architecture Analysis

## Discovery Analysis

The existing `DISCXXXXXX` record remains the aggregate root. It references exactly one completed
`REQXXXXXX`, preserves source evidence, and contains all generated analysis sections. A successful
record is proposed, advisory, and eligible for one future ADR handoff. Discovery does not own the
Request lifecycle or ADR decision state.

## Candidate Solution Option

| Field | Rule |
| --- | --- |
| Option Identifier | Discovery-scoped `OPT` followed by exactly six digits; assigned after deterministic sorting and unique within the record. |
| Title | Deterministic, non-empty title for the architecture approach; alphabetical title is the final option sort key. |
| Summary | Non-empty description of the distinct architecture approach. |
| Benefits | Deterministic list derived from closed evidence. |
| Risks | Deterministic list of option-specific risks. |
| Assumptions | Deterministic list of option-specific assumptions. |
| Dependencies | Unique dependency list used for Dependency Count. |
| Supporting Evidence | Closed, redacted evidence references supporting viability and alignment. |
| Alignment Metadata | Desired Change, Objective, and constraint alignment values used for ordering. |
| Reference Architecture Matches | Zero or more advisory matches, independently evaluated. |

At least two and no more than five distinct viable options are required. A viable option is
distinct, supported by at least one closed evidence domain, and complete enough to populate every
required field. Deduplication occurs before identifier allocation.

## Reference Architecture Match

| Field | Rule |
| --- | --- |
| Reference Architecture Identifier | Stable `RA` identifier from the authoritative optional catalog. |
| Confidence | Deterministic confidence associated with the matched rule. |
| Match Reason | Highest-precedence matching rule for that candidate. |
| Matched Option | One or more option identifiers may reference the same architecture. |
| Reference Implementation Count | Advisory count from the authoritative optional catalog; zero when absent or unreadable. |
|

Candidates are evaluated independently. Every candidate with at least one exact match is reported;
semantic, similarity, and inference matching are excluded from Version 1.

## Candidate Solution Comparison Matrix

One matrix exists per successful Discovery and contains every option in the same order as the
Candidate Solution Options section. It includes each weighted score, total score, Reference
Architecture matches, recommendation status, and mandatory informational classifications:

- Complexity from unique Dependency Count: 0-2 Low, 3-5 Medium, 6+ High.
- Governance Impact from unique matched Objectives, Controls, NFRs, and Reference Architectures:
  0-2 Low, 3-5 Medium, 6+ High.
- Operational Overhead from unique operational dependency categories: 0-2 Low, 3-5 Medium, 6+
  High.

Informational categories are advisory and never contribute to score, confidence, ranking,
selection, or option ordering. Exactly one option has `Recommended` status.

## Recommendation

Exactly one Recommendation exists per successful Discovery. It contains one valid `OPT` identifier,
the five score components, total, confidence, rationale, and matched Reference Architecture
identifiers. Score weights are Objective 30, NFR 30, Control 20, Profile 10, and Risk Reduction
10; component totals are whole numbers and the total is 0 through 100 inclusive. A zero denominator
produces zero for that component.

## ADR Handoff

The handoff is a read-only projection of the Discovery identifier, all options and identifiers,
matrix, recommendation, rationale, and Reference Architecture Matches. ADR may select any option
and owns selected/rejected identifiers, acceptance, rejection rationale, and consequences.

## State and Transaction Boundaries

1. **Input resolution**: one completed Request and closed optional inputs are resolved.
2. **Analysis assembly**: options, matches, matrix, and recommendation are built in memory.
3. **Validation**: identifiers, counts, score identity, advisory boundaries, and template order
   are checked.
4. **Commit**: catalog allocation and record/catalog writes occur as one ordered transaction.
5. **Failure**: any resolution, redaction, matching, scoring, validation, allocation, or write
   failure aborts with existing bytes unchanged.

No Discovery state represents ADR acceptance, rejection, approval, architecture decision, or
implementation authorization.