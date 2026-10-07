# Data Model: Experience Runtime Refactor

This feature has no persisted data model. Its design model is the set of runtime concepts and document structures represented by the Experience Standard.

## Runtime concepts

| Concept | Meaning | Boundary or invariant |
|---|---|---|
| Working Idea | Transient substance or reasoning still being developed | Remains non-authoritative until the owning workflow accepts it |
| Substantive Contribution | Input that changes meaning, interpretation, relationship, implication, constraint, or direction | Triggers re-evaluation under X2.38 |
| Constructive Advisory Contribution | Grounded Highway-originated possibility, implication, relationship, distinction, alternative, tension, opportunity, concern, challenge, or recommendation | Must remain visibly advisory until accepted |
| Conversational Clarification | Focused question resolving consequential user-owned uncertainty | Owned by X2.4; not an acceptance or convergence mechanism |
| Contribution Opportunity | Meaningful opportunity to add, correct, remove, or extend substance Highway shaped | Owned by X2.37; an equivalent substantive interaction may satisfy it |
| Converged Proposal | Complete candidate whose relevant substance is unlikely to improve through further grounded reasoning | Governed by X2.41 and only presented before acceptance |
| Accepted Knowledge | User-owned knowledge that crossed the applicable acceptance boundary | May inform later reasoning and overrides stale provisional interpretation when actively corrected |
| Artifact Acceptance Boundary | Owning workflow point where an accepted proposal becomes eligible for declared persistence | Is not a convergence mechanism and does not prove persistence success |
| Owner | Skill or workflow authoritative for domain semantics, completeness, acceptance, persistence, and capability-specific runtime behavior | Experience governs presentation, not owner state or mutation mechanics |

## Document structure

- Definitions establish the runtime vocabulary.
- X-rule tables express user-visible obligations without development/test tier metadata.
- The Interaction Model explains the adaptive loop from context through advisory reasoning, re-evaluation, clarification, convergence, acceptance, and owner action.
- Explanatory sections provide runtime boundaries and examples without becoming a second rule system.
- A simple `9.0.0` version field provides provenance; development amendment mechanics are outside the runtime document.

No entity identity, storage lifecycle, API schema, or migration is introduced.
