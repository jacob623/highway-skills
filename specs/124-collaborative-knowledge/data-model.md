# Data Model: Collaborative Knowledge Development

Feature 124 adds conceptual governance entities. They are not persisted as new files or storage records.

## Accepted Repository Knowledge

- **Meaning**: Accepted user-owned or authoritative repository information available to later work.
- **Authority**: Authoritative within its existing ownership and acceptance contract.
- **Relationship**: Provides the precedence boundary above transient Active Reasoning Context.
- **Validation**: Must not be displaced by an exploratory Working Idea.

## Active Reasoning Context

- **Meaning**: Interaction-scoped information organized toward the active task.
- **Contents**: Unaccepted contributions, proposals, interpretations, alternatives, implications, tensions, questions, and relationships.
- **Lifecycle**: Available while relevant until task resolution or interaction end.
- **Persistence**: Transient only; no retained artifact or cross-interaction restoration.

## Working Idea

- **Meaning**: An evolving contribution, proposal, interpretation, or synthesis inside Active Reasoning Context that is not authoritative user-owned knowledge.
- **Lifecycle**: May be refined, discarded, corrected, replaced, split, combined, or abandoned without creating a retained artifact.
- **Authority**: Cannot override accepted evidence or authoritative repository state.

## Converged Proposal

- **Meaning**: A complete candidate artifact or artifact set produced from the active interaction and presented at the applicable acceptance boundary.
- **Lifecycle**: Precedes possible user acceptance; it is not authoritative merely because it is complete or discussed.
- **Completeness**: Determined by the owning workflow for its domain. The Experience Standard governs presentation, not domain completeness.

## Accepted User-Owned Artifact

- **Meaning**: A Converged Proposal accepted through the owning workflow.
- **Mutation**: Persisted through the existing owner-controlled mutation path.
- **Ordering**: Owner mutation occurs before dependent results; orchestration waits for the owner's declared result.

## Relationships and transitions

```text
Accepted Repository Knowledge
          |
          v
Active Reasoning Context --> Working Idea --> Converged Proposal
          ^                                      |
          |                                      v
          +----------- re-evaluation <--- Accepted User-Owned Artifact
                                             (owner mutation)
```

The diagram describes conceptual flow only. It does not authorize a new persistence mechanism for
Active Reasoning Context or Working Ideas.
