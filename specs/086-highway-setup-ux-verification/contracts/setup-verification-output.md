# Setup Verification Output Contract

This contract defines the verification boundary for Feature 086. It clarifies the existing `highway-setup` output modes and does not create structured response fields or replace owner contracts.

## Collection Mode

When setup requires input, verification confirms this order:

1. A welcome greeting, or a resume greeting after a prior interaction.
2. An introduction to the active owner workflow.
3. Owner-provided informational context, when supplied, in its original order.
4. The active owner's next unresolved question, when supplied.
5. A wait for one user response.

Routine collection must not emit the Explicit Status Contract, the Completion Dashboard, the five phrases in the Verification Prohibited Vocabulary, or readiness, stage-selection, owner-selection, or orchestration explanations. Owner-selection reasoning is allowed only in response to an explicit request for implementation details.

## Status Mode

Verification selects the Explicit Status Contract only when:

- the user explicitly requests status;
- setup is blocked;
- setup is declined; or
- setup is aborted.

Owner questions, summaries, outputs, blocking reasons, and next actions remain owner-owned content. They appear only when supplied by the owner workflow and applicable to the current interaction outcome.

## Completion Mode

Successful completion is not a status response. Verification selects the Completion Dashboard instead of the Explicit Status Contract and confirms that no collection question is emitted. Existing ownership routes and governance destinations remain unchanged.

## Prohibited Vocabulary

Routine collection rejects this closed exact list:

- `first incomplete stage`
- `owner contract`
- `workflow routing`
- `forwarding response`
- `repository initialization state`
