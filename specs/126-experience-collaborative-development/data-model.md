# Data Model: Experience Standard Collaborative Development

This feature adds no persisted data, retained artifact type, schema field, API payload, or runtime
state. The entities below are conceptual terms used to describe user-visible collaboration and
ownership boundaries in the Experience Standard.

## Working Idea

A transient developing contribution, interpretation, recommendation, alternative, implication,
question, tension, or related thread that has not crossed an artifact acceptance boundary.

**Properties**:

- transient within the active interaction;
- anchored to the active task;
- may be interpreted, sharpened, connected, expanded, narrowed, challenged, split, combined,
  corrected, replaced, or abandoned;
- is not accepted repository knowledge and does not require artifact persistence.

## Active Reasoning Context

The transient collection of relevant developing ideas, unresolved questions, implications,
alternatives, tensions, and contributions that Highway keeps available while reasoning about the
active task.

**Relationships**:

- contains relevant Working Ideas;
- uses accepted context as an input for contextual re-evaluation;
- remains subordinate to accepted user evidence and repository authority;
- is not a user-visible workflow state and is not persisted by this feature.

## Converged Proposal

A complete candidate artifact or artifact set that the owning workflow can present for its domain's
acceptance decision.

**Validation**:

- completeness is determined by the owning skill, not by the Experience Standard;
- presentation must follow the shared user-visible interaction rules;
- a proposal may be formed from collaborative understanding rather than field-by-field questioning.

## Artifact Acceptance Boundary

The applicable decision point at which the person accepts a complete candidate for the owning
workflow.

**State transition**:

```text
Working Idea -> Converged Proposal -> acceptance decision -> accepted knowledge
```

Agreement with a Working Idea does not force the transition when the candidate is not yet complete.

## Accepted Knowledge

User-owned knowledge that has crossed the applicable acceptance boundary and may inform later
contextual re-evaluation.

**Authority**:

- remains user-owned and authoritative under the owning workflow's existing contract;
- may change what becomes visible in the active task;
- does not convert earlier Highway interpretations into accepted facts unless the applicable boundary
  accepts them.

## Owner

The skill or workflow responsible for domain completeness, presenting the Converged Proposal,
handling acceptance, and performing its existing persistence behavior.

**Boundary**:

- the owner decides what is complete for its domain;
- the Experience Standard governs collaboration and presentation;
- no owner contract, artifact schema, or persistence mechanism changes in this feature.

## Non-Modelled Concerns

The following are intentionally not entities or persisted records in this feature:

- conversation-state files or reasoning logs;
- Working Agreement, Draft Accepted, Provisional Acceptance, or Artifact Acceptance user labels;
- Profile, Objective, Control, NFR, Setup, or other retained artifact schemas;
- API, command, storage, or external integration contracts.
