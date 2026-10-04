# Data Model: Profile Contribution Opportunity

## Scope

Feature 134 adds no retained data model. It defines a transient interaction model layered onto the existing Profile domain lifecycle.

## Conceptual Entities

### Working Idea

- **Purpose**: Hold developing Profile substance while Profile and the person interpret, sharpen, question, correct, or extend it.
- **Content**: Grounded themes, short statements, distinctions, directions, alternatives, implications, tradeoffs, or principles.
- **Authority**: Transient; it does not establish a Profile domain as `discussed` or `bounded`.
- **Relationship**: May receive a Contribution Opportunity and may later become a Converged Proposal.

### Contribution Opportunity

- **Purpose**: Let the person add, correct, remove, extend, or redirect substantive pieces of a developed Working Idea before final synthesis.
- **Lifetime**: Active only during transient collaborative development; no retained identifier or state.
- **Trigger**: Profile materially shaped the Working Idea and no equivalent meaningful opportunity already occurred.
- **Skip conditions**: Domain-complete user contribution, prior equivalent opportunity, explicit finished-contributing intent, explicit selected Converged Proposal, or another shared X2.37 exception.
- **Authority**: Not acceptance, provisional acceptance, persistence approval, or workflow completion.

### Converged Proposal

- **Purpose**: Present one cohesive, complete Profile domain representation for the existing domain acceptance decision.
- **Content**: A grounded organizational narrative answering the active domain's purpose without unsupported claims.
- **Relationship**: Synthesized from the updated Working Idea after the applicable Contribution Opportunity resolves.
- **Authority**: Crosses the existing Profile acceptance boundary only when the person accepts the presented proposal.

### Accepted Profile Knowledge

- **Purpose**: Retained Profile evidence after the existing domain acceptance and mutation path succeeds.
- **Relationship**: May update one of the existing domains: `identity`, `vision`, `competitive_path`, or `guiding_principles`.
- **Constraint**: No Contribution Opportunity response alone creates accepted knowledge.

## Lifecycle

```text
accepted context
  -> Working Idea
  -> collaborative development
  -> Contribution Opportunity when applicable
  -> add/correct/remove/extend or indicate nothing else
  -> update and re-evaluate Working Idea
  -> Converged Proposal
  -> existing domain acceptance
  -> accepted Profile knowledge
```

A mature or user-supplied domain-complete contribution may skip the distinct Contribution Opportunity. A complete discovered Identity may continue directly to accuracy validation when Profile has not materially changed its substance.

## Invariants

- Existing Profile readiness states remain exactly `not_discussed`, `discussed`, and `bounded`.
- Profile record schema remains `3.0.0`.
- No `contribution_pending`, `completion_pending`, `developing`, `provisional`, or equivalent retained state is introduced.
- The Contribution Opportunity and domain acceptance are separate interaction turns.
- Provisional substantive content is not persisted until the Converged Proposal crosses the existing acceptance boundary.
- Internal enrichment category names remain presentation-hidden and are not retained.
- Subject transitions remain `### Where you're going`, `### How you'll get there`, and `### What will guide your decisions`.
