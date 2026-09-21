# Discovery Analysis Contract: Solution Constraints

## Inputs

Discovery receives exactly one completed `REQ` identifier and reads closed inputs in this order:
Request, Request Solution Constraints, Profile, Objective, Control, NFR, and optional Reference
Architecture. Reference Implementation data remains advisory tie-break input. All inputs are
read-only and privacy-filtered before copying, matching, scoring, or serialization.

Request Solution Constraints are loaded from the completed Request in this exact order:

1. `allowed_solution_classes`
2. `existing_platforms_required`
3. `existing_platforms_preferred`
4. `known_systems`
5. `hosting_restrictions`
6. `vendor_restrictions`
7. `procurement_constraints`
8. `regulatory_restrictions`

## Deterministic Analysis Order

1. Resolve and validate exactly one completed Request and its eight Solution Constraint fields.
2. Load closed baselines in the declared order and normalize line endings and comparison text.
3. Redact secrets and regulated personal data before output construction.
4. Preserve existing findings, assumptions, risks, and unknowns extraction rules.
5. Read `allowed_solution_classes` before candidate generation. If it is known, generate only
   candidates belonging to an allowed class; if it is `unknown`, preserve existing unconstrained
   generation behavior.
6. Generate, normalize, and evaluate each candidate in this order: generate candidate, normalize
   candidate, evaluate Solution Constraints, filter invalid candidates, then score survivors.
7. Exclude candidates violating required platforms, hosting, vendor, procurement, or regulatory
   restrictions. Record every exclusion with candidate identifier, status, reason, and constraint.
8. Order Candidate Elimination Log entries by candidate identifier, constraint category, then
   constraint identifier or value.
9. Deduplicate and retain two through five complete candidates. Fewer than two viable candidates
   aborts without writes.
10. Calculate alignment only for retained candidates. Required Platform Match is 100 for every
    retained candidate. Preferred Platform Match is 100 when used and 50 otherwise. Known-System
    Alignment is 100 when all declared known systems are reused, 75 when one or more but not all
    are reused, and 50 when none are reused. Preferred platforms and known systems never eliminate.
11. Calculate weighted scores with Objective 25, NFR 25, Control 20, Constraint Alignment 20, and
    Risk Reduction 10. Constraint Alignment cannot restore an excluded candidate.
12. Sort retained options by the existing deterministic option ordering, render the complete matrix
    and one advisory Recommendation, validate the record and catalog in memory, allocate once, and
    write the ordered transaction.

## Constraint Evaluation Rules

- `allowed_solution_classes` constrains generation when known and preserves unconstrained
   generation when `unknown`; it never ranks or selects a class.
- `existing_platforms_required`, `hosting_restrictions`, `vendor_restrictions`,
   `procurement_constraints`, and `regulatory_restrictions` are mandatory filters evaluated before
   scoring, comparison, and recommendation.
- `existing_platforms_preferred` and `known_systems` are scoring-only inputs and never eliminate a
   candidate.
- Known-system alignment is 100 when all declared systems are reused, 75 when one or more but not
   all are reused, and 50 when none are reused. Required-platform match is 100 for every retained
   candidate; preferred-platform match is 100 when used and 50 otherwise.
- Constraint Alignment is calculated only for retained candidates and cannot restore an excluded
   candidate. Retained matrix compliance is `Fully Compliant` or `Satisfied`.

## Score Composition

Weighted score components are Objective 25, NFR 25, Control 20, Constraint Alignment 20, and Risk
Reduction 10. The weights total 100; component and total scores remain in the range 0-100.

## Candidate Elimination Log

The log is rendered after `Unknowns` and before `Candidate Solution Options`. Each entry contains:

- Candidate identifier and title.
- Status: `Excluded`.
- Reason category.
- Constraint identifier or value.

Violating candidates do not receive scores, matrix rows, Recommendation status, or ADR selection
status.

## Failure Behavior

Malformed or contradictory Solution Constraints, an empty invalid `allowed_solution_classes` value,
failed privacy/validation/scoring, or zero viable candidates abort without a Discovery record,
catalog update, partial output, or source mutation. Existing baseline bytes remain unchanged.

## Ownership

Discovery owns candidate generation, filtering, scoring, comparison, and advisory recommendation.
Solution Constraints constrain eligibility but do not select, approve, or create a solution. ADR
owns architecture selection, rationale, consequences, decision recording, and authorization.
