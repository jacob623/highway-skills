# Feature 061 Data Model: Discovery Contract Alignment

This feature defines document-contract entities rather than runtime persistence entities.

## Discovery Section Contract

An ordered sequence of section names declared by the Discovery skill, its Verification section,
and the shared `discovery-record.md` template.

| Property | Meaning | Validation |
|---|---|---|
| section name | Canonical Markdown heading name | Exact text match across all three authorities |
| position | One-based order in the contract | Identical ordering across all three authorities |

## Alignment Value

A traceability value for Desired Change, Objective, and Constraints.

| Property | Meaning | Validation |
|---|---|---|
| value | Integer alignment score | Inclusive range 0-100 (0 through 100) |
| invalid forms | Decimal, negative, above 100, or qualitative value | Must be rejected by focused validation |

## Retained Candidate Compliance

A retained candidate that survives mandatory filtering.

| Property | Meaning | Validation |
|---|---|---|
| Constraint Compliance | Deterministic retained-candidate status | Exactly `Fully Compliant`; `Satisfied` is invalid |
| Required Platform Match | Required-platform traceability result | Always 100 for retained candidates; traceability only |

## Candidate Elimination Entry

A record of a candidate removed before scoring.

| Property | Meaning | Validation |
|---|---|---|
| Candidate Identifier | Stable candidate identity | Required |
| Constraint Category | Failing constraint family | Required |
| Constraint Identifier or Value | Specific failing field/value | Required |
| elimination ordering | Deterministic entry order | Candidate Identifier, then Constraint Category, then Constraint Identifier or Value |

## Relationships and Invariants

- The skill, Verification section, and shared template are synchronized contract authorities.
- Mandatory required-platform failures occur before scoring and never appear as retained candidates.
- Developer-facing fixtures exercise contract validation; normal Discovery remains advisory and non-executable.
- Generated adapters and catalogs derive from canonical sources and are not independent authorities.
- Fixture execution does not mutate canonical source, template, adapter, or catalog bytes.
