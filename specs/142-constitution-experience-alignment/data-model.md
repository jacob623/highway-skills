# Feature 142 Data and Authority Model

This feature has no runtime data schema. The model below describes the governance states and ownership transitions that the amended Constitution must preserve.

## Entities

| Entity | Authority state | Owner | Required relationships |
|---|---|---|---|
| Active Reasoning Context | Transient information available during the active task | Constitution | Retains relevant Working Ideas until the task resolves or interaction ends; remains subordinate to accepted evidence. |
| Working Idea | Transient and non-authoritative developing material | Experience Standard for visible development; Constitution for authority state | Exists within Active Reasoning Context and may inform a candidate without becoming accepted repository knowledge. |
| Owner Candidate | Domain-complete candidate artifact or artifact set | Owning skill | Supplies domain completeness and artifact content; does not become a Converged Proposal from completeness alone. |
| Converged Proposal | Owner-complete candidate whose applicable Experience Standard convergence requirements are satisfied | Experience Standard for convergence qualification | May be presented at the artifact acceptance boundary. |
| Accepted User-Owned Artifact | Candidate accepted through its owning workflow and persisted through the owner's declared mutation path | Owning skill for mutation and persistence; Constitution for authority boundary | Successful persistence creates accepted repository knowledge. |
| Accepted Repository Knowledge | Accepted user-owned or authoritative repository information | Constitution | Available to later reasoning with other relevant declared context. |
| Owner Result | Declared result after owner-controlled mutation | Owning skill | Consumed by orchestration; acceptance alone is not the owner result. |

## State Transitions

```text
Active Reasoning Context
  -> Working Idea remains transient while development continues
  -> Owner Candidate when the owning skill establishes domain completeness
  -> Converged Proposal when Experience Standard convergence requirements are satisfied
  -> Artifact acceptance boundary when the person accepts or otherwise satisfies owner acceptance
  -> Owner mutation and declared Owner Result
  -> Accepted Repository Knowledge after successful persistence
  -> Later reasoning with relevant accepted context
```

## Validation Rules

1. Active Reasoning Context and Working Ideas are never retained artifact types.
2. Owner completeness is necessary but insufficient for Converged Proposal status.
3. Working Idea agreement is not automatically artifact acceptance.
4. Acceptance authorizes applicable owner mutation but is not successful persistence.
5. Orchestration advances only from the declared owner result and all required terminal results.
6. Accepted knowledge may inform later reasoning; it does not erase the distinction between post-acceptance re-evaluation and active collaborative re-evaluation.
