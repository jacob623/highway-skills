# Feature 081 Data Model

## Setup Wizard State

Transient state for the active interaction. It is not persisted as a separate Setup artifact.

| Field | Meaning | Validation |
|---|---|---|
| `Current Stage` | Active stage in the fixed sequence | Exactly `Profile`, `Objectives`, `Controls`, `NFRs`, or `Complete` |
| `Current Activity` | The active owner's next question or action | Derived from owner output; never invented when an owner value exists |
| `Completed Stages` | Stages that returned terminal success | Ordered subset of Profile, Objectives, Controls, and NFRs |
| `Remaining Stages` | Stages not yet terminally successful | Ordered complement of Completed Stages |
| `Active Owner Outcome` | Most recent owner response | Must conform to the owner response contract or produce `Setup: Blocked` |
| `Step` | User-facing wizard step | `1` Profile, `2` Objectives, `3` Controls, `4` NFRs |

## Owner Workflow Response

The owner-provided response consumed by Setup.

| Field | Meaning | Validation |
|---|---|---|
| `Question` | The next unresolved owner question | Presented byte-identically when supplied |
| `Example` | The owner-provided example | Presented byte-identically when supplied |
| `Status` | Owner readiness or collection outcome | Recognized statuses are `Complete`, `Not Applicable`, `Missing`, `In Progress`, and `Blocked`; declined, aborted, malformed, and unknown outcomes are non-terminal |
| `Summary` | Owner explanation of current state | Preserved in Setup output |
| `Next Action` | Owner's requested next user action | Used for `Current Activity` and stop output |
| `Blocking Reason` | Owner explanation of a block | Required for blocked output when supplied by the owner contract |
| `Output` | Owner proposal, review, or completion content | Presented without Setup rewriting; mutations remain owner-owned |

## Setup Stage

The ordered owner stages are:

1. Profile
2. Objectives
3. Controls
4. NFRs

A stage is terminally successful only when its owner returns `Complete` or an applicable `Not Applicable`. All other responses are non-terminal and stop or pause Setup according to the decision table in FR-013A.

## Setup Progress Report

A user-facing report composed of Setup-owned framing and owner-provided content. It identifies the numeric step, stage, completed stages, current stage, remaining stages, and next required action. Owner questions and examples are byte-identical to their source output.

## Completion Dashboard

The existing terminal dashboard emitted after all applicable stages succeed. Setup does not alter its fields, ordering, ownership routes, or availability.

## State Transitions

```text
Readiness assessment
  -> first incomplete stage
  -> ask one owner question
  -> owner response
     -> Complete / applicable Not Applicable -> mark stage complete -> next stage
     -> Missing / In Progress -> remain at stage -> next owner action/question
     -> Blocked -> pause at stage -> report reason/action
     -> Declined / Aborted -> stop or pause -> no completion
     -> Malformed / Unknown -> Setup Blocked -> no downstream owner
  -> all stages terminally successful -> Complete -> existing dashboard
```

On a later invocation, Setup re-reads persisted owner readiness and re-enters at the first incomplete stage. No exact unanswered question, cancellation marker, or competing wizard checkpoint is restored.
