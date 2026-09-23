# Setup Output Contract

This contract describes the user-visible output ordering for Feature 085. It does not create structured response fields or replace owner contracts.

## Input-Required Collection

The output sequence is:

1. A Highway welcome message, or a resume greeting after a prior interaction.
2. A brief introduction naming the active owner workflow.
3. The active owner's next unresolved question, with owner-provided wording preserved.
4. A wait for one user response.

Routine collection does not foreground readiness evaluation, owner-selection reasoning, routing, orchestration, or progress stages.

## Status and Non-Collection Outcomes

Dashboard information may be shown when setup is complete, blocked, declined, aborted, or the user explicitly requests status. Blocked, declined, aborted, and status responses may include:

- `Owner Workflow`
- `Blocking Reason`
- `Next Action`

The existing completion dashboard and ownership destinations remain unchanged.

## Verification Vocabulary

Normal collection must not emit these implementation-oriented phrases:

- `first incomplete stage`
- `owner contract`
- `workflow routing`
- `forwarding response`
- `repository initialization state`
