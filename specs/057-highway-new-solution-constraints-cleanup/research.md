# Research: Highway New Solution Constraints Cleanup

## Decisions

### Preserve the Spec 053 baseline

The eight Solution Constraints fields and their question order remain unchanged. The cleanup
clarifies their contracts rather than adding, removing, renaming, or reordering fields. The
existing Request record remains the durable output owner.

### Classify exactly four list-shaped fields

The list-shaped fields are:

- `allowed_solution_classes`
- `existing_platforms_required`
- `existing_platforms_preferred`
- `known_systems`

The first field is a candidate-space input and must contain one or more non-empty values or
`unknown`. The other three preserve three distinct states: a populated list, an explicit empty
array, or `unknown`.

### Classify exactly four scalar fields

The scalar restriction fields are:

- `hosting_restrictions`
- `vendor_restrictions`
- `procurement_constraints`
- `regulatory_restrictions`

Each contains a non-empty value or `unknown`. An empty array is not a valid scalar state.

### Keep the candidate-space rule explicit

An empty `allowed_solution_classes` list is rejected because it does not describe a determinate
allowable domain for future Discovery analysis. `unknown` is different: it records that the
requester cannot determine the domain while preserving an explicit downstream input state.

### Keep Business Constraints wording separate from representation

The requester-facing wording is `No business constraints` when the requester confirms that none
apply. The existing explicit empty representation in the Request record remains unchanged. When
the requester cannot determine whether constraints exist, the state remains `unknown`.

### Use local field correction

A malformed answer produces an actionable error naming the exact field, accepted shape, valid
example, and replacement action. A valid replacement updates only that field; prior valid answers
remain intact and collection resumes at the failed field. Existing privacy screening and write
safety remain authoritative.

### Reuse existing verification surfaces

The authoritative source is `.highway/skills/highway-new/SKILL.md`. The shared output contract,
focused test, validators, generators, and correspondence checks already cover the repository's
skill workflow. The implementation should extend those surfaces and add no runtime dependency.

### Preserve ownership boundaries

This feature verifies the shape of the future Discovery candidate-space input but does not
implement candidate generation, comparison, scoring, recommendation, or architecture analysis.
It does not create or alter ADR decisions, solution selection, rationale, consequences, or
authorization.

## Alternatives Rejected

- **Treat every field as a generic list**: rejected because scalar restrictions require a non-empty
  scalar or `unknown`, and generic wording permits invalid arrays.
- **Treat an empty allowed-class list as no restriction**: rejected because it makes the future
  candidate domain indeterminate rather than explicitly unconstrained.
- **Convert uncertainty to an empty array**: rejected because `unknown` carries different evidence
  meaning and must remain distinct from a known empty state.
- **Restart the whole domain after one malformed value**: rejected because it loses valid evidence
  and violates the requested local recovery behavior.
- **Introduce a parser, schema package, or service**: rejected because the repository's Markdown
  contract and Bash-focused validation are sufficient and the constitution prohibits new runtime
  dependencies for this change.

## Resolved Unknowns

No unresolved technical unknowns remain for planning. Implementation must still observe the
existing privacy, retry, transaction, catalog, and write-safety behavior while changing only the
specified guidance and verification surfaces.
