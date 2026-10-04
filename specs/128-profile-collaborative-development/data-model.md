# Data Model: Profile Collaborative Development

This feature changes Profile conversation behavior without changing the retained Profile schema.
The entities below are conceptual interaction entities and are not new persisted fields.

## Working Idea

A transient user contribution or Highway recommendation under active development.

- **Lifecycle**: seeded from user evidence or accepted context; interpreted and sharpened; may be
  corrected, extended, redirected, replaced, split, combined, or abandoned; may converge into a
  Converged Proposal.
- **Persistence**: never persisted independently.
- **Readiness effect**: does not establish `discussed` or any new readiness state.
- **Scope**: remains anchored to the active Profile domain.

## Converged Proposal

A complete candidate for one Profile domain.

- **Lifecycle**: produced when accumulated evidence answers the domain purpose coherently without
  unsupported facts; presented for the existing domain validation decision.
- **Persistence**: accepted content is persisted through the existing Profile mutation path.
- **Readiness effect**: accepted content establishes the domain as `discussed`; an explicit user
  boundary may continue to establish `bounded` according to the existing contract.
- **Validation**: uses the existing Identity, Vision, Competitive Path, or Guiding Principles
  validation wording.

## Accepted Profile Knowledge

User-owned organizational narrative that crossed the applicable Converged Proposal acceptance boundary.

- **Attributes**: domain, accepted narrative, existing readiness outcome, permitted optional context.
- **Persistence**: stored only in the existing Profile artifact structure.
- **Relationships**: accumulates across all four domains and grounds later contextual re-evaluation.

## Active Reasoning Context

Transient context used while the active Profile subject remains unresolved.

- **Contents**: relevant Working Ideas, user contributions, interpretations, alternatives, tensions,
  implications, and relationships to later Profile subjects.
- **Persistence**: not stored as fields, files, logs, or workflow state.
- **Boundary**: only accepted organizational narrative crosses into retained Profile knowledge.
- **Subject anchoring**: related ideas are carried forward without interrupting the active subject.

## Profile Domain

One of the four retained domains:

| Domain | Purpose | Existing readiness states |
|---|---|---|
| Identity | Who is this organization? | `not_discussed`, `discussed`, `bounded` |
| Vision | Where is it trying to go? | `not_discussed`, `discussed`, `bounded` |
| Competitive Path | How does it intend to get there? | `not_discussed`, `discussed`, `bounded` |
| Guiding Principles | What should guide its decisions? | `not_discussed`, `discussed`, `bounded` |

## State Transitions

```text
User evidence or grounded recommendation
    -> Working Idea (transient)
    -> interpret / sharpen / contribute / user response / re-evaluate
    -> Converged Proposal (complete candidate)
    -> user acceptance
    -> Profile mutation
    -> persisted Accepted Profile Knowledge
    -> contextual re-evaluation with accumulated Profile
    -> next active subject or natural completion
```

The existing retained schema remains `3.0.0`. No Working Idea, Active Reasoning Context, maturity,
evolution, or additional readiness fields are introduced.
