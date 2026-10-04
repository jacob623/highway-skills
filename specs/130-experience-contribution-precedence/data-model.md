# Data Model: Experience Contribution Precedence

This feature introduces no persisted data model, schema field, or external contract. The entities below
are conceptual interaction terms used to validate the shared Experience Standard amendment.

## Working Idea

A transient grounded direction, distinction, implication, alternative, hypothesis, connection,
provisional recommendation, or explanation that materially helps develop the active task.

- **Lifecycle**: develops, may be corrected/refined/replaced/abandoned, and remains transient until an applicable owning acceptance boundary is crossed.
- **Acceptance**: agreement or reaction to a Working Idea is not artifact acceptance.
- **Grounding**: uses accepted information, available evidence, active task context, or declared domain expertise without inventing organizational facts.

## Converged Proposal

A complete grounded candidate that the owning workflow can present for its existing acceptance decision.

- **Lifecycle**: may be reached directly from a mature contribution or after Working Idea development.
- **Acceptance**: existing owning-workflow boundaries remain unchanged.
- **Relationship**: has precedence over a Working Idea when the understanding is complete.

## Focused Unresolved Question

A narrowly scoped request for information that remains genuinely necessary after relevant context has
been evaluated for both a Converged Proposal and a useful Working Idea.

- **Lifecycle**: is the fallback, not the default response to incomplete artifact grounding.
- **Constraint**: asks only for information the person genuinely needs to provide.

## Contribution Precedence

The conceptual decision order is:

`Converged Proposal -> useful Working Idea -> focused unresolved question`

This is guidance for selecting the strongest available contribution. It does not force a contribution
when context provides no responsible basis and does not change persistence or acceptance semantics.

## Available Relevant Context

The accepted information, available evidence, active task context, and declared grounding that a workflow
may use to evaluate whether either contribution form is responsible.

## State Transition Summary

```text
available relevant context
  -> complete candidate supported -> Converged Proposal -> existing acceptance decision
  -> complete candidate unsupported but useful contribution supported -> Working Idea -> continue development or ask when needed
  -> neither contribution responsibly supported -> focused unresolved question
```

No state in this model is persisted by the feature, and no Working Idea or Active Reasoning Context is
added to a retained artifact schema.
