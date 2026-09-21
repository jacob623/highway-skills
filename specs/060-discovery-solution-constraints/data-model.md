# Feature 060 Data Model

## Request Solution Constraints

The closed, read-only constraint evidence loaded from one completed Request.

| Field | Shape | Meaning | Evaluation |
|---|---|---|---|
| `allowed_solution_classes` | One or more values or `unknown` | Permitted candidate classes | Limits candidate generation when known; no ranking or selection |
| `existing_platforms_required` | List, empty list, or `unknown` | Platforms a viable candidate must satisfy | Mandatory eligibility filter; mismatch eliminates before scoring |
| `existing_platforms_preferred` | List, empty list, or `unknown` | Platforms that improve fit when used | Scoring-only, never eliminates |
| `known_systems` | List, empty list, or `unknown` | Existing systems relevant to the request | Scoring-only, never eliminates |
| `hosting_restrictions` | Scalar value or `unknown` | Hosting boundary | Mandatory eligibility filter |
| `vendor_restrictions` | Scalar value or `unknown` | Vendor boundary | Mandatory eligibility filter |
| `procurement_constraints` | Scalar value or `unknown` | Acquisition boundary | Mandatory eligibility filter |
| `regulatory_restrictions` | Scalar value or `unknown` | Regulatory/data-handling boundary | Mandatory eligibility filter |

The output renders these fields in the exact order shown above. Empty arrays and `unknown` remain
distinct; an unknown optional constraint is treated as unspecified.

## Candidate Eligibility State

A generated candidate is normalized, then evaluated against allowed class and mandatory
constraints before any score is calculated.

| State | Entry condition | Output behavior |
|---|---|---|
| Generated | Candidate derived from closed Discovery evidence | Candidate enters normalization |
| Normalized | Candidate has stable comparison fields | Candidate enters Solution Constraint evaluation |
| Excluded | Candidate violates allowed class, required platform, hosting, vendor, procurement, or regulatory constraint | Candidate is omitted from scoring/matrix/recommendation and receives one or more elimination entries |
| Retained | Candidate satisfies all mandatory eligibility rules | Candidate receives alignment fields, score components, matrix row, and recommendation consideration |

No state transition may mutate the Request or governance baselines.

## Candidate Elimination Entry

Each entry records:

- Candidate identifier and candidate title.
- Status: `Excluded`.
- Constraint category: allowed class, required platform, hosting, vendor, procurement, or
  regulatory.
- Constraint identifier or value.
- Deterministic reason.

Entries are ordered by candidate identifier, constraint category, then constraint identifier or
value. Elimination entries are rendered after Unknowns and before Candidate Solution Options.

## Retained Candidate Constraint Traceability

Each retained Candidate Solution Option contains:

- Allowed Solution Class.
- Constraint Alignment.
- Satisfied Constraints.
- Unsatisfied Constraints.
- Required Platform Match: always 100 for retained candidates.
- Preferred Platform Match: 100 when a preferred platform is used, otherwise 50.
- Known-System Alignment: 100 for all known systems reused, 75 for one or more but not all reused,
  and 50 for none reused.
- Constraint Compliance: `Fully Compliant` or `Satisfied`.

Constraint Alignment is calculated only after mandatory filtering. It cannot restore an excluded
candidate.

## Score Model

| Component | Weight | Notes |
|---|---:|---|
| Objective | 25 | Existing objective alignment, normalized to 0-100 component range |
| NFR | 25 | Existing NFR alignment, normalized to 0-100 component range |
| Control | 20 | Existing control alignment, normalized to 0-100 component range |
| Constraint Alignment | 20 | Retained-candidate platform preference and known-system alignment |
| Risk Reduction | 10 | Existing risk-reduction calculation |
| Total | 100 | Weighted total, bounded 0-100 |

The matrix and Recommendation use the same component values and total. Reference Implementation
data remains tie-break-only and does not change scores.

## Discovery Record State

- **Abort**: malformed or contradictory constraint input, empty invalid allowed-class value, failed
  privacy/validation/scoring/allocation/write operation, or zero viable candidates. No record or
  catalog bytes are written.
- **Proposed**: validated record with two through five retained candidates, complete matrix, one
  advisory Recommendation, and complete constraint traceability.

## Relationships

- One completed Request supplies one Request Solution Constraints entity per Discovery invocation.
- One Discovery record contains zero or more elimination entries and two through five retained
  Candidate Solution Options on success.
- Each retained option has one matrix row and one set of constraint traceability fields.
- One Discovery Recommendation references one retained option advisory-only.
- ADR consumes the Discovery record once and owns later selection and authorization.
