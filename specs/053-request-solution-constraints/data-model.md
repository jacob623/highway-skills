# Data Model: Request Solution Constraints

## Request Record

A user-owned business Request record containing the existing six evidence domains plus the ordered
`Solution Constraints` domain, followed by completeness state.

| Field | Meaning | Validation |
|---|---|---|
| `id` | Permanent Request identifier | Existing `REQ` plus exactly six digits rule remains unchanged |
| `status` | Request lifecycle state | Existing Version 1 creation status remains `proposed` |
| `title` | Deterministic business title | Existing explicit-title or Problem-derived rule remains unchanged |
| evidence domains | User-authored business evidence | Problem, Actors, Current Process, Desired Change, Success Measure, Business Constraints, Solution Constraints |
| `completeness` | Evidence completeness state | `Complete` only when all seven domains are present and valid; otherwise `Incomplete` |

## Solution Constraints Evidence

The seventh ordered Request evidence domain. It captures user-owned constraints and descriptive
business context without ranking or selecting a solution.

| Field | Shape | Meaning | Valid values |
|---|---|---|---|
| `allowed_solution_classes` | list | Solution classes Discovery may consider | User-owned list; may contain multiple entries; no ranking |
| `existing_platforms_required` | list | Enterprise platforms that must be used | Named required platforms or empty list; `unknown` where applicability cannot be determined |
| `existing_platforms_preferred` | list | Enterprise platforms the requester prefers | Named preferred platforms or empty list; preference does not create a requirement |
| `known_systems` | list | Systems involved in, affected by, referenced by, or participating in the Request's business process | Descriptive system names or empty list; no inferred architecture or integration |
| `hosting_restrictions` | list | Hosting conditions that exclude candidates | User-authored restrictions, empty list, or `unknown` |
| `vendor_restrictions` | list | Vendor conditions that exclude candidates | User-authored restrictions, empty list, or `unknown` |
| `procurement_constraints` | list | Acquisition constraints for products or services | User-authored constraints, empty list, or `unknown` |
| `regulatory_restrictions` | list | Regulatory or data-handling conditions | User-authored restrictions, empty list, or `unknown` |

### Evidence State Semantics

- A populated value records known business evidence.
- An empty array means the requester knows no values apply.
- `unknown` means the requester cannot currently determine whether values apply.
- Missing fields are invalid in a rendered Solution Constraints section; the field must be populated,
  explicitly empty, or explicitly `unknown` according to its shape.
- Absence of a constraint is neutral and must not become a preference, recommendation, ranking, or
  selection criterion.

## Ownership Boundaries

- Request owns collection, storage, privacy screening, completeness, and rendering of the evidence.
- Discovery may later consume the evidence to exclude invalid candidates, but owns candidate
  generation, classification, comparison, scoring, recommendation, and architecture analysis.
- ADR owns solution and architecture decisions, including selection, rationale, consequences, and
  authorization.

## State and Transaction Invariants

- The seven evidence domains remain ordered; Solution Constraints follows Business Constraints and
  precedes Completeness.
- `unknown` does not by itself make a Request incomplete.
- Allowed solution classes and restrictions never imply a selected or preferred candidate.
- Request catalog allocation, validation, privacy exclusion, and no-partial-write behavior remain
  unchanged from the existing Request contract.
- Request and catalog artifacts are built and validated before either is written.
- Feature 053 creates no Discovery or ADR artifact and mutates no Discovery or ADR baseline.
