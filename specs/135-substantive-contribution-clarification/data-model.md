# Data Model: Substantive Contribution Re-evaluation and Conversational Clarification

This feature adds no retained data model. The entities below describe transient interaction concepts needed to keep the Experience Standard precise.

## Substantive Contribution

A person's response that adds, changes, corrects, removes, distinguishes, qualifies, redirects, or otherwise supplies information that can change the active understanding.

**Lifecycle**:

```text
person response
→ classify as substantive when new information can change understanding
→ contextual re-evaluation with active and accepted context
→ interpretation, clarification, contribution, continued development, or natural conclusion
```

**Invariants**:

- It is conversational meaning, not retained state, an artifact, a persistence event, or an owner result.
- A response containing only acceptance, rejection, confirmation, decline, or selection without new information is not substantive.
- Acceptance plus new information has both acceptance behavior and substantive-contribution re-evaluation.

## Conversational Clarification

Focused resolution of ambiguity, unresolved assumption, contradiction, missing fact, unclear relationship, or materially different interpretation revealed during active understanding development.

**Lifecycle**:

```text
Substantive Contribution
→ contextual re-evaluation
→ consequential uncertainty requiring the person's information
→ one focused clarification
→ updated understanding
→ continued development or next behavior
```

**Invariants**:

- It is transient interaction behavior and does not create a clarification record by itself.
- It is selective; clear input with a responsible interpretation continues without a ceremonial question.
- It is the only unresolved response-demanding question in its interaction turn.
- It does not accept or persist a Working Idea or Converged Proposal.
- It does not automatically satisfy Contribution Opportunity.

## Working Idea

A transient developing interpretation, contribution, recommendation, alternative, implication, or related thread that has not crossed an artifact acceptance boundary.

**Relationships**:

- Receives Substantive Contributions and active contextual re-evaluation.
- May contain unresolved uncertainty addressed by Conversational Clarification.
- May reach a Contribution Opportunity under X2.37.
- Becomes a Converged Proposal only when the owning workflow has a complete candidate.

## Contribution Opportunity

The distinct pre-convergence opportunity to add, correct, remove, or extend developed Working Idea substance when X2.37 applies.

**Invariants**:

- It is separate from Conversational Clarification and artifact acceptance.
- A clarification question satisfies this opportunity only when it also meaningfully invites substantive additions, corrections, removals, or extensions.
- It remains transient until the existing Converged Proposal acceptance boundary is crossed.

## Converged Proposal

A complete candidate representation presented for the owning workflow's existing acceptance decision.

**Invariants**:

- It contains only claims supported by the owning workflow's accepted or otherwise authorized evidence.
- It is synthesized after relevant development and Contribution Opportunity handling.
- It preserves existing acceptance, persistence, and owner-result semantics.

## Accepted Knowledge

User-owned knowledge that has crossed the applicable acceptance boundary and can inform later contextual re-evaluation.

**Relationship**: Accepted Knowledge participates in the post-acceptance re-evaluation loop and is distinct from transient Substantive Contributions and Working Ideas.

## Active Reasoning Context

Transient, task-anchored context containing relevant developing ideas, unresolved questions, implications, alternatives, tensions, and contributions used during the active interaction.

**Invariant**: It is not a required file or persisted artifact, and it remains available while the active task continues.
