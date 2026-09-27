# Context and UX Contract

## Context priority

For deterministic interpretation and question selection, use this priority:

1. active user input;
2. accepted existing Controls;
3. accepted Profile;
4. accepted Business Objectives;
5. Identity, Vision, and Platform Objectives framing.

Lower-priority context may refine explanation or suggestions but cannot override higher-priority
evidence. Context may identify, prioritize, or suggest a concern and may surface a relevant connection;
it cannot choose organizational policy or create a new persisted relationship.

A malformed owner Profile is consumed as Profile-owned `Blocked` and causes `Action Status: Blocked`
for the Profile-dependent action. Other unavailable optional context is excluded. A complete direct
obligation is not blocked solely by absent Profile or Objectives.

## Proposal UX

The review action comes first:

```text
Next Action: Review this proposed Control and accept, correct, replace, or reject it.
```

Then show human-facing title, statement, and rationale sections. `Next Action` is interaction
framing, not a retained field. A vague user override is advised, explicitly retained, and never
represented as measurable when it is not.

## Interaction exits

Pause, cancel, stop responding, decline, abort, and block do not restore discovery, proposals,
suggestions, continuation, or collection provenance. A new invocation uses persisted repository state
only. The user-facing experience must not imply that an unfinished interaction will be restored.
