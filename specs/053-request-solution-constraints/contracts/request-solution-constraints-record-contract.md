# Request Solution Constraints Record Contract

## Request Record

Path: `requests/REQXXXXXX.md`

The existing Request record contract remains authoritative, with this ordered evidence extension:

```markdown
## Business Constraints

<user-authored constraint evidence or explicit no-constraint statement>

## Solution Constraints

allowed_solution_classes:
  - <user-owned solution class>
existing_platforms_required: []
existing_platforms_preferred: []
known_systems: []
hosting_restrictions: []
vendor_restrictions: []
procurement_constraints: []
regulatory_restrictions: []

## Completeness

Complete | Incomplete
```

The illustrative empty arrays may instead contain user-authored entries or the literal `unknown`
where the requester cannot determine the value. The implementation must follow the shared output
template rather than treating this excerpt as a second template authority.

## Validation Rules

- The Solution Constraints section appears after Business Constraints and before Completeness.
- All eight named fields are present in stable order.
- `allowed_solution_classes` is an extensible list and may contain multiple entries without rank.
- Required and preferred platforms are distinct fields.
- Known systems are descriptive business context.
- Empty arrays and `unknown` remain distinct.
- Unknown values do not alone produce `Incomplete` status.
- No recommendation, selected solution, architecture, rationale, consequence, authorization, or
  relationship section is added.
- Existing Request ID, status, catalog, privacy, transaction, and no-partial-write rules remain
  unchanged.

## Exclusions

This contract does not define Discovery candidate generation, classification, comparison, scoring,
recommendation, or architecture analysis. It does not define ADR creation or decisions.
