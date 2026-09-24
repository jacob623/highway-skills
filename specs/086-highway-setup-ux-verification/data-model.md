# Feature 086 Data Model

Feature 086 introduces no persisted data model. It defines verification states and output-mode selection over the existing owner readiness and outcome values.

## Collection Experience

- **Inputs**: input-required state, active owner workflow, owner-provided informational context, and owner-provided next unresolved question.
- **Output order**: welcome or resume greeting, active owner introduction, preserved owner informational context, and owner question in the order supplied by the owner contract.
- **Validation**: no Explicit Status Contract, completion dashboard, readiness explanation, stage-selection explanation, owner-selection reasoning, or orchestration commentary during routine collection.
- **Transition**: waits for one user response and forwards it to the authoritative owner workflow without changing routing or readiness semantics.

## Status Experience

- **Applicability**: explicit status request, blocked setup, declined setup, or aborted setup.
- **Inputs**: applicable owner summary, output, blocking reason, next action, and outcome classification.
- **Validation**: uses the Explicit Status Contract only for these cases; owner content appears only when supplied by the owner workflow and applicable to the interaction outcome.

## Completion Experience

- **Applicability**: all required setup foundations are complete or not applicable.
- **Output**: existing Completion Dashboard, including ownership routes and governance destinations.
- **Validation**: does not emit a collection question and does not use the Explicit Status Contract.

## Verification Prohibited Vocabulary

The closed exact phrase set rejected during routine collection is:

- `first incomplete stage`
- `owner contract`
- `workflow routing`
- `forwarding response`
- `repository initialization state`

Readiness, stage-selection, owner-selection, and orchestration explanations are separately rejected as explanation categories. Owner-selection reasoning is permitted only when the user explicitly requests implementation details.

## Relationships and Invariants

- Profile, Objectives, Controls, and NFRs remain the authoritative owner order.
- The active owner remains authoritative for question wording, informational context, outcomes, and artifact ownership.
- Setup preserves owner-provided content ordering and does not fabricate questions or status fields.
- Complete, blocked, declined, and aborted outcomes retain existing terminality and safe-stop behavior.
- No new checkpoint, persistence, artifact, or orchestration authority is introduced.
