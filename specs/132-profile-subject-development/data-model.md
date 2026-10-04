# Data Model: Profile Subject Transition and Working-Idea Development

This feature adds no persisted entity, field, readiness state, migration, or retained artifact type.

## Conceptual entities

### Visible Subject Transition

- **Meaning**: The user-facing separation between re-evaluation of an accepted subject and the heading and content of the next unresolved subject.
- **Relationship**: Connects accepted Identity to Vision, accepted Vision to Competitive Path, and accepted Competitive Path to Guiding Principles.
- **Persistence**: None; presentation remains transient.

### Working Idea

- **Meaning**: A grounded, incomplete contribution that advances a Profile subject and gives the person something concrete to react to.
- **Possible content**: Direction, distinction, implication, alternative, tradeoff, connection, or provisional recommendation.
- **Lifecycle**: Develop -> focus a question or compare grounded alternatives -> converge or abandon.
- **Persistence**: None until incorporated into an accepted Converged Proposal.

### Focused Working-Idea Question

- **Meaning**: One question requesting only the unresolved information needed to develop an existing Working Idea.
- **Inputs**: Unresolved choice, distinction, priority, boundary, tradeoff, capability, approach, or organizational fact.
- **Persistence**: None.

### Grounded Alternative

- **Meaning**: A materially distinct direction supported by accepted Profile evidence.
- **Constraints**: Must keep the user-authored path available, must not be presented as accepted organizational truth, and may include a grounded advisory preference.
- **Persistence**: None until the person incorporates the direction into an accepted Converged Proposal.

### Converged Proposal

- **Meaning**: A complete Profile-domain candidate eligible for the existing owner acceptance decision.
- **Lifecycle**: Working Idea development -> Converged Proposal -> acceptance -> Profile mutation -> contextual re-evaluation.
- **Persistence**: Existing Profile record only after acceptance.

## Existing retained model unchanged

- Schema version: `3.0.0`
- Domains: `identity`, `vision`, `competitive_path`, `guiding_principles`
- States: `not_discussed`, `discussed`, `bounded`
- Existing validation wording, persistence ordering, readiness, completion, website scope, and error handling remain authoritative.
