# Feature 161 Data Model

Feature 161 changes no durable Objective schema. The entities below describe the existing owner workflow and transient working state that the implementation must preserve.

## Objective Development Lifecycle

- **Purpose**: Ordered workflow from recommendation or direct user contribution through proposal, one review, capture, and the next Objective.
- **Inputs**: Accepted Profile evidence, accepted Objective context, a selected recommendation, or a user-provided Objective.
- **Transitions**: Recommendation or direct contribution -> Converged Objective proposal -> one review -> owner capture -> next queue item or continuation.
- **Constraints**: Proposal-first when evidence supports it; discovery only for missing support or consequential ambiguity; no capture before review and owner capture.

## Converged Objective Proposal

- **Fields**: Objective title, Objective statement, proposed Success Measures, synthesized Rationale.
- **State**: Working Idea until the existing Objective acceptance boundary is crossed.
- **Validation**: Must be grounded in accepted Profile evidence where available; proposed measures remain user-refinable; unsupported claims must not be presented as accepted organizational fact.
- **Relationships**: Belongs to the current lifecycle item and is the sole review candidate for that item.

## Proposed Success Measures

- **Fields**: One or more grounded measures when accepted evidence supports them.
- **State**: Proposed until the person approves, modifies, replaces, or removes them through the existing Objective workflow.
- **Validation**: If evidence cannot support reasonable measures, ask only the consequential unresolved Success question; do not manufacture measures.
- **Relationship**: Supports the Objective statement without replacing it as the primary conversational anchor.

## Active Objective Queue

- **Fields**: Ordered selected recommendations awaiting sequential development.
- **State**: Transient working state; selected, current, completed, declined, interrupted, or unresolved.
- **Validation**: Queue membership determines development order only and is never Objective capture.
- **Transitions**: Selected -> current -> proposal/review/capture -> next selected item; declined or unresolved items remain uncaptured.
- **Persistence**: No durable queue record, identifier, catalog change, or baseline version change.

## Discovery Exception

- **Purpose**: Focused conversational path when accepted evidence cannot support a responsible proposal, cannot support reasonable Success Measures, or leaves consequential ambiguity unresolved.
- **Constraint**: Must not be used to rediscover information already established by accepted Profile evidence when a grounded proposal can be shown first.

## Objective Capture

- **Owner**: Existing `highway-objectives` owner.
- **Boundary**: Converged proposal exists, one review completes, and the owner performs the existing acceptance and atomic persistence behavior.
- **Preserved invariants**: Permanent identifiers, catalogs, versions, duplicate and overlap checks, readiness, mutation output, non-write behavior, and revalidation remain unchanged.
