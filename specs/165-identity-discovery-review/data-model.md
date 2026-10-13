# Data Model: Identity Discovery Contribution Opportunity

Feature 165 introduces no retained schema. The model below describes transient interaction states and
how they connect to the existing Profile acceptance boundary.

## Entities

### Discovery Evidence

Material from the repository website, imported discovery material, or existing Profile context that can
support an Identity expression. It is proposed input until accepted through the existing Profile flow.

### Review Finding

One candidate organizational expression with a concise title and one-sentence summary grounded in the
available evidence. Findings are review content, not accepted Profile facts.

### Identity Discovery Contribution Opportunity

A transient, ordered set of Review Findings presented before Identity convergence. It includes the
source evidence basis and makes clear that the findings are provisional.

### Review Contribution Opportunity

The user's opportunity to correct, add, remove, combine, or split proposed findings. A response updates
proposed evidence; it does not itself accept or persist an Identity narrative.

### Updated Discovery Review

The re-synthesized review produced after a meaningful contribution. It replaces the prior review for the
active interaction and is presented again before convergence.

### Identity Converged Proposal

The existing Profile proposal created only after the review is stable and the correction loop has no
meaningful pending change. It remains subject to the existing user acceptance gate.

### Accepted Identity Narrative

The existing retained Profile content written only after acceptance. It is the only durable result in
this feature's flow.

## State transitions

```text
Discovery Evidence
  -> Initial Identity Discovery Contribution Opportunity
  -> User Contribution Opportunity
  -> correction/addition/removal/combination/split
  -> Updated Identity Discovery Contribution Opportunity
  -> User Contribution Opportunity (repeat while meaningful changes continue)
  -> Stable Identity Discovery Contribution Opportunity
  -> existing Identity Converged Proposal
  -> existing acceptance gate
  -> Accepted Identity Narrative
```

## Invariants

- A review finding is never presented as an accepted fact before acceptance.
- Meaningful corrections always cause re-synthesis and re-presentation before convergence.
- The system stays in review while meaningful corrections continue.
- Stability is required before creating the Converged Proposal.
- Review and final proposal are separate artifacts in the interaction, even though neither review content
  nor proposal content is a new retained file.
- Existing Profile persistence, readiness, schema, and domain ownership are unchanged.
