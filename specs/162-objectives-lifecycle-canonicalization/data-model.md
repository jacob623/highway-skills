# Feature 162 Data Model: Objectives Lifecycle Canonicalization

This feature does not change a persisted data model. The entities below describe the guidance contract that must remain internally consistent.

## Objective Development Lifecycle

- **Purpose**: The single authoritative sequence for Objective development.
- **Sequence**: Recommendation Selected or User Provided Objective -> Present Converged Objective proposal -> User Acceptance -> Capture -> Next Objective.
- **Relationship**: Owns the canonical definition referenced by capture and queue guidance.

## Converged Objective Proposal

- **Fields**: Objective title, Objective statement, proposed Success Measures, synthesized Rationale.
- **State**: Advisory or transient until User Acceptance.
- **Relationship**: Presented once in the normal path; changes requested by the person update the current proposal rather than creating an implicit preliminary lifecycle stage.

## User Acceptance

- **Purpose**: The explicit user-owned event before Objective capture.
- **Constraint**: Presentation, discussion, or queue selection is not acceptance.
- **Relationship**: Follows proposal presentation and precedes owner-controlled capture.

## Active Objective Queue

- **Purpose**: A transient ordered set of selected recommendations.
- **Constraint**: Determines development order only and does not constitute acceptance or capture.
- **Relationship**: Each item uses the Objective Development Lifecycle sequentially.

## Discovery Exception

- **Purpose**: Focused discovery when accepted evidence cannot support a responsible proposal, reasonable Success Measures, or a consequential ambiguity remains unresolved.
- **Constraint**: It is not a default lifecycle stage when a grounded proposal can be presented.

## Invariants

- Exactly one authoritative proposal-content definition exists in the guidance.
- Queue and capture guidance reference that definition rather than redefining its fields.
- Selection never captures an Objective.
- Capture requires User Acceptance of the current proposal.
- Existing record schema, identifiers, catalog, persistence, duplicate, overlap, readiness, and revalidation behavior remain unchanged.
