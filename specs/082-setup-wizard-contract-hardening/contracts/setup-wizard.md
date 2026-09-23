# Feature 082 Setup Wizard Contract

## Active Stage and Completion

Setup enters Guided Setup at the first non-terminal owner and automatically advances to the next owner stage after each terminal owner result in this order:

1. Profile
2. Objectives
3. Controls
4. NFRs

While an owner stage is active, the progress report may include `Step`, `Stage`, `Completed Stages`, `Current Stage`, `Remaining Stages`, and `Current Activity`. When `Current Stage` is `Complete`, no numeric `Step` is emitted.

## Owner Output Ordering

When an owner response contains informational output and a next question, Setup presents the informational output first and the owner question afterward. Setup does not reorder, rewrite, summarize, or normalize owner content. Owner questions and examples are byte-identical to owner workflow output except for Setup-owned progress framing.

## Outcome Classification Table

| Classification | Values | Setup behavior |
|---|---|---|
| User Exit | `pause`, `cancel`, `stop responding` | End the current interaction without persisting wizard state or advancing the stage |
| Owner Outcome | `declined`, `aborted`, `blocked` | Report the owner outcome and remain non-terminal; do not label it as a User Exit |
| Terminal Owner Result | `Complete`, applicable `Not Applicable` | Mark the stage terminally successful and advance |
| Non-terminal Owner Result | `Missing`, `In Progress` | Remain at the stage and present the owner action or question |
| Invalid Owner Result | malformed or unknown | Produce deterministic Setup `Blocked` output and do not invoke downstream owners |

## Resume and Persistence

Guided Setup never persists owner collection state, unanswered questions, draft responses, cancellation markers, or wizard checkpoints. A later invocation re-reads persisted owner readiness and resumes at the first incomplete owner.

## Ownership Verification

Setup never allocates identifiers, writes catalogs, writes owner artifacts, writes candidate state, or writes relationship state. All governed mutations originate from the owning workflow.

## Verification Scenarios

- Provide informational owner output followed by a question and verify the output precedes the question byte-for-byte.
- Complete all owner stages and verify `Current Stage: Complete` is reported without a numeric `Step`.
- Pause, cancel, or stop responding and verify no wizard state is created.
- Return `declined`, `aborted`, or `blocked` from an owner and verify the result is classified as an Owner Outcome.
- Start with each possible first incomplete owner and verify Guided Setup begins at that owner rather than terminating after readiness reporting.
- Attempt to identify Setup-created identifiers, catalogs, owner artifacts, candidates, or relationships and verify no such mutations occur.
