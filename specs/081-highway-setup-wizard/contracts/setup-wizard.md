# Highway Setup Wizard Contract

## Entry Point

`/highway-setup` is the single user-facing entry point for initial setup. It actively delegates collection and assesses owner readiness in this order:

1. Profile
2. Objectives
3. Controls
4. NFRs

If all applicable owners are terminally successful, Setup emits `Highway Setup Complete` followed by the existing administration dashboard.

After each terminal owner result, Setup automatically advances to the next stage without requiring a separate downstream command.

## Progress Contract

While incomplete, Setup reports:

- `Step`: `1`, `2`, `3`, or `4`
- `Stage`: the corresponding stage from FR-009A
- `Completed Stages`
- `Current Stage`
- `Remaining Stages`
- `Current Activity`

Setup asks exactly one unresolved owner question at a time. Owner questions and examples are byte-identical to the owner output; Setup-owned progress framing may surround them.

## Owner Delegation Contract

Setup forwards each response to the active owner workflow and consumes its response. Setup does not create, update, remove, replace, allocate identifiers for, regenerate catalogs for, or repair relationships among owner artifacts.

Owner workflows remain authoritative for:

- Profile artifact and identity
- Objective records and catalog
- Control records, catalog, and NFR candidate generation
- Accepted NFR records and relationships
- Proposal, confirmation, cancellation, rejection, duplicate, validation, and no-write semantics

## Terminality Decision Table

| Owner response | Classification | Setup behavior |
|---|---|---|
| `Complete` | Terminal success | Mark the stage complete and advance. |
| Applicable `Not Applicable` | Terminal success | Mark the stage not applicable and advance. |
| `Missing` or `In Progress` | Non-terminal | Remain at the stage and present the next owner action or question. |
| `Blocked` | Non-terminal | Pause and report the owner blocking reason and next action. |
| Declined or aborted | Non-terminal | Stop or pause without advancing or reporting completion. |
| Malformed or unknown | Non-terminal | Report `Setup: Blocked` and do not invoke downstream owners. |

## Resume and Cancellation Contract

A later `/highway-setup` invocation re-reads persisted owner readiness and resumes at the first incomplete owner. It does not restore an exact unanswered question, cancellation marker, or separate Setup checkpoint. An explicit user pause or cancellation ends the current interaction without advancing the stage.

## Completion Contract

The existing administration dashboard remains the terminal output. Setup preserves its fields, ordering, ownership routes, and availability.
