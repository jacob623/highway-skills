# Data Model: Contribution Opportunity Before Convergence

This feature adds no persisted entity, field, readiness state, migration, or retained artifact type.

## Conceptual entities

### Working Idea

- **Meaning**: A transient developing interpretation, contribution, recommendation, alternative, implication,
  or related thread that has not crossed an artifact acceptance boundary.
- **Lifecycle**: Develop -> optionally provide Contribution Opportunity -> incorporate the person's response
  and re-evaluate -> converge or continue development.
- **Authority**: Non-authoritative until a complete Converged Proposal crosses the existing acceptance boundary.

### Contribution Opportunity

- **Meaning**: A transient conversational opportunity to add, correct, remove, or extend substantive elements
  of a developed Working Idea before Highway synthesizes it into a Converged Proposal.
- **Trigger**: Highway materially shaped the Working Idea and no prior meaningful equivalent opportunity occurred.
- **Presentation**: Provisional substance may use themes, bullets, distinctions, alternatives, implications,
  or other decomposed content.
- **Skip conditions**: Domain-complete user contribution, prior equivalent opportunity, explicit completion of
  contribution, explicit desire to proceed, ceremonial questioning, or explicitly selected Converged Proposal.
- **Authority**: Not an acceptance boundary and not permission to persist.

### Converged Proposal

- **Meaning**: A complete candidate artifact or artifact set that the owning workflow can present for its
  applicable acceptance decision.
- **Relationship**: Synthesized after applicable Working-Idea development and Contribution Opportunity handling.
- **Presentation**: Existing X2.21 review heading and one acceptance request remain authoritative.

### Artifact Acceptance Boundary

- **Meaning**: The existing decision point after which the owning workflow may treat a complete candidate as
  accepted user-owned knowledge and perform its established persistence behavior.
- **Relationship**: A Contribution Opportunity response does not cross this boundary unless it independently
  satisfies an already-presented acceptance decision.

## Unchanged model boundaries

- No `contribution_pending`, `completion_pending`, provisional, draft-approved, or working-accepted state.
- No Setup checkpoint or owner-specific Contribution Opportunity state.
- Existing Accepted Knowledge, Active Reasoning Context, owner mutation, persistence, and Contextual
  Re-evaluation remain unchanged.
- Existing contribution precedence remains: Converged Proposal when supported -> useful Working Idea when
  supported -> focused unresolved question when needed.
