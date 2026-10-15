# Data Model: Highway Implementation Compatibility Assessment

Feature 178 adds assessment information to the existing implementation workflow. It introduces no external datastore or new identifier family. The entities below describe the transient assessment and the persisted sections added to the existing Reference Implementation record.

## Assessment Input

| Property | Rule |
|---|---|
| Source | Exactly one accepted `ARCH######` resolved through the authoritative catalog |
| Implementation Selections | One or more user-owned components, services, products, frameworks, databases, middleware, infrastructure elements, or provider capabilities |
| Optional evidence | Existing Controls, NFRs, Profile, Objectives, and Clarification evidence under current precedence and malformed-input rules |
| Ordering | Normalize equivalent names and sort deterministically without changing meaning |
| Brownfield compatibility | Future observed components may use the same representation; discovery is out of scope |

## Architecture Requirement

An implementation-relevant responsibility extracted from accepted architecture evidence. Sources include Logical Components, Interaction Model, Trust Boundaries, Deployment Pattern, Required Capabilities, Constraints, Control Relationships, NFR Relationships, and Reference Implementation Guidance.

Fields:

- stable source reference or section
- responsibility statement
- required/optional applicability
- related realization category
- supporting architecture or governance evidence

Architecture requirements remain read-only projections. They do not modify the Reference Architecture or ADR.

## Realization Category and Coverage Status

The category vocabulary is stable and evaluated in this order:

1. Compute
2. Messaging
3. Persistence
4. Identity
5. Networking
6. Security
7. Observability
8. Recovery
9. Deployment
10. Operations

Each category receives exactly one status:

- `Satisfied`: required responsibilities are covered by one or more selections with supporting evidence.
- `Unsatisfied`: the category is required but one or more responsibilities remain unresolved.
- `Not Applicable`: the architecture does not require the category.

## Selection Realization

A relation connecting one Implementation Selection to one or more Architecture Requirements.

Fields:

- normalized selection name
- original user-owned name when normalization changes presentation
- architecture responsibility or responsibilities
- reason selected
- supporting evidence
- unsupported flag when no responsibility can be established

Every selection must be mapped or surfaced for owner resolution; no selection is silently ignored.

## Compatibility Assessment

The first-class assessment output.

Fields:

- source `ARCH######`
- normalized Implementation Selections
- extracted Architecture Requirements
- Coverage Summary
- exactly one Result: `Compatible`, `Incomplete`, or `Incompatible`
- Implementation Gaps, when incomplete
- Implementation Conflicts, when incompatible
- recommendation values, including `Unknown` where evidence is insufficient
- available traceability identifiers

State transitions:

```text
accepted ARCH + selections
  -> validate and normalize inputs
  -> extract architecture responsibilities
  -> evaluate category coverage and conflicts
  -> Compatible | Incomplete | Incompatible

Incomplete
  -> owner accepts/substitutes/adds selections
  -> reassess
  -> Compatible | Incomplete | Incompatible

Incompatible
  -> Resolve Implementation or Revisit Architecture
  -> no RI generation until a new valid assessment exists

Compatible
  -> existing RI proposal generation and atomic persistence
```

## Implementation Gap

A required responsibility not covered by the selections and not contradicted by them.

Required fields:

- `Missing Capability`
- `Why It Matters`
- `Suggested Realization`
- `Recommendation Confidence`

`Suggested Realization` may be `Unknown` when evidence is insufficient.

## Implementation Conflict

A direct contradiction between a selection and an explicit architecture requirement.

Required fields:

- `Architecture Requirement`
- `Implementation Selection`
- `Conflict Explanation`

An incompatible assessment exposes exactly two paths: `Resolve Implementation` and `Revisit Architecture`.

## Reference Implementation Boundary

The existing RI record remains catalog-owned and proposed on successful generation. It may be created only from `Compatible`. Failed, incomplete, incompatible, allocation, validation, and write paths preserve source, existing RI, and catalog bytes.

The record adds these sections without changing existing ownership:

- Architecture Compatibility Assessment
- Coverage Summary
- Implementation Gaps
- Implementation Conflicts
- Implementation Selections
- Technology Realization Rationale

Traceability remains `REQ -> DISC -> ADR -> ARCH -> RI` where identifiers are available.
