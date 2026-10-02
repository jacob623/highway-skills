# Data Model: Profile Verification Cleanup

This feature changes Verification language only. It introduces no persisted entities or schema fields.
The entities below are conceptual interaction states already defined by the shared Profile model.

## Working Idea

A transient developing Profile interpretation, contribution, recommendation, alternative, implication,
or related thread.

- **Persistence**: never persisted independently.
- **Readiness effect**: does not establish `discussed`, `bounded`, or a new readiness state.
- **Scope**: remains anchored to the active Profile subject.
- **Agreement**: natural agreement does not cross the Profile acceptance boundary.

## Converged Proposal

A complete Profile candidate that answers the active domain purpose coherently and is presented for the
existing artifact acceptance decision.

- **Persistence**: accepted content crosses the existing Profile mutation boundary.
- **Readiness effect**: accepted content establishes the applicable unresolved domain as `discussed`.
- **Validation**: artifact-level validation applies to this state, not to a Working Idea.

## Active Reasoning Context

Transient, task-anchored context containing relevant Working Ideas, unresolved relationships,
interpretations, alternatives, tensions, and contributions while the active Profile subject continues.

- **Persistence**: not stored as fields, files, logs, or workflow state.
- **Boundary**: only accepted organizational narrative crosses into retained Profile knowledge.
- **Anchoring**: related Working Ideas remain connected to the active subject and do not interrupt it.

## Accepted Profile Knowledge

User-owned organizational narrative that crossed the applicable Converged Proposal acceptance boundary.

- **Attributes**: Profile domain, accepted narrative, existing readiness outcome, and permitted optional
  context.
- **Relationship**: grounds contextual re-evaluation and subsequent Profile contributions.

## Profile Domain

One of the four retained domains: Identity, Vision, Competitive Path, or Guiding Principles.
Each domain retains one of `not_discussed`, `discussed`, or `bounded` under schema `3.0.0`.

## State Transitions

```text
User contribution or grounded recommendation
    -> Working Idea (transient)
    -> interpret / sharpen / contribute / re-evaluate
    -> Converged Proposal (complete candidate)
    -> acceptance
    -> existing Profile mutation
    -> persisted accepted Profile knowledge
    -> contextual re-evaluation with accumulated Profile context
    -> next contribution or natural transition
```

The cleanup verifies this lifecycle but does not add Working Idea, Active Reasoning Context, maturity,
collaboration, evolution, or additional readiness fields to the retained Profile record.
