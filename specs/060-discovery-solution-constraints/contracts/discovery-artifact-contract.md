# Discovery Artifact Contract: Solution Constraints

## Record Section Order

A successful Discovery record follows the shared template and renders these sections in order:

1. Request
2. Research Findings
3. Assumptions
4. Risks
5. Unknowns
6. Request Solution Constraints
7. Candidate Elimination Log
8. Candidate Solution Options
9. Candidate Solution Comparison Matrix
10. Recommendation
11. Objective Relationships
12. Control Relationships
13. NFR Relationships
14. Reference Architecture Matches

## Request Solution Constraints

The section contains all eight fields in this exact order:

1. `allowed_solution_classes`
2. `existing_platforms_required`
3. `existing_platforms_preferred`
4. `known_systems`
5. `hosting_restrictions`
6. `vendor_restrictions`
7. `procurement_constraints`
8. `regulatory_restrictions`

Values are privacy-filtered retained evidence. Empty arrays and `unknown` remain distinct.

## Candidate Elimination Log

Each excluded candidate is represented exactly once per triggering constraint evaluation with:

- Candidate identifier.
- Candidate title.
- Status: `Excluded`.
- Reason category.
- Constraint identifier or value.

Entries sort by candidate identifier, constraint category, then constraint identifier or value.
Excluded candidates do not appear in Candidate Solution Options, the matrix, or Recommendation.

## Retained Candidate Fields

Each retained option includes:

- Allowed Solution Class.
- Constraint Alignment.
- Satisfied Constraints.
- Unsatisfied Constraints.
- Required Platform Match: `100`.
- Preferred Platform Match: `100` when used or `50` when not used.
- Known-System Alignment: `100`, `75`, or `50` according to the explicit analysis table.
- Constraint Compliance: `Fully Compliant` or `Satisfied`.

## Comparison Matrix

The matrix includes these constraint columns in addition to existing score and informational
columns:

- Allowed Solution Class
- Constraint Alignment Score
- Required Platform Match
- Preferred Platform Match
- Constraint Compliance

Retained candidates always report Required Platform Match `100`. Violations are represented in the
Candidate Elimination Log rather than in the matrix.

## Recommendation and ADR Boundary

The matrix and Recommendation use the same score values. Recommendation weights are Objective 25,
NFR 25, Control 20, Constraint Alignment 20, and Risk Reduction 10. The Recommendation is
advisory and may reference only a retained candidate. It is not a selection, approval, architecture
decision, or implementation authorization; ADR owns those outcomes.

## Canonical Ordering and Compliance

Request Solution Constraints render in the eight-field Request order. Candidate Elimination Log
entries sort by candidate identifier, constraint category, then constraint identifier or value.
Retained candidates alone receive scores, matrix rows, and recommendation status. Required Platform
Match is always `100` for retained candidates, and Constraint Compliance is always `Fully Compliant`
or `Satisfied`.
