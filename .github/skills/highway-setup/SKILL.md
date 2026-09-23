---
name: highway-setup
description: "Orchestrates the initial Highway repository setup through the owning governance skills."
usage: "Invoke as `/highway-setup` to assess readiness and complete missing foundational setup in order."
compatibility: all
metadata:
	version: 2.0.0
---

## Purpose

Orchestrates the initial Highway repository setup through an active Guided Setup wizard that evaluates readiness in order, asks one owner-provided question at a time, forwards responses to the owning workflow, and continues until every owner reaches terminal success or a defined stop condition.

## When to use

- Use `/highway-setup` as the user-facing onboarding entry point for a repository without a complete Profile, Business Objective, Control, and NFR baseline.
- Use it to reassess setup after an owner workflow has completed or after an author accepts proposed NFRs.
- Use it to inspect whether setup is complete and display the ownership routes for later administration.
- Use it to resume at the first incomplete owner after an interrupted or cancelled interaction.

## When not to use

- Do not use this skill to create, update, remove, replace, or directly write a Profile, Objective, Control, or NFR artifact.
- Do not use it to repair relationships; route that work to `/highway-relationships`.
- Do not use it to answer skill discovery or questionnaire administration; route those requests to `/highway-help` or `/highway-inquiry`.

## Inputs

- The project root, found by locating `.highway/`; if it cannot be located, stop and ask for the project root.
- The Profile owner workflow and artifact contract at `/highway-profile`, including its required `organization.name` value.
- The Business Objective owner workflow and root-level `library/objectives/` record contract at `/highway-objectives`.
- The Control owner workflow and root-level `library/governance/controls/` baseline contract at `/highway-controls`.
- The NFR owner workflow and root-level `library/governance/nfrs/` baseline contract at `/highway-nfrs`.
- The output values and ownership routes defined in this skill are the user-facing contract; no second artifact store is introduced.

## Outputs

- A Guided Setup progress report with `Step`, `Stage`, `Completed Stages`, `Current Stage`, `Remaining Stages`, and `Current Activity` while setup is incomplete.
- The active owner's question, example, summary, output, and next action, presented verbatim except for Setup-owned progress framing.
- The exact complete dashboard when all four owner workflows recognize valid accepted baselines.
- An in-progress or blocked result when an owner is missing, pending, declined, malformed, blocked, or incomplete.
- Do not directly write Profile, Objective, Control, or NFR artifacts.
- When no owner mutation is required, preserve existing governance artifact bytes exactly.

## Workflow

1. Locate the project root by finding `.highway/`. If it cannot be located, stop and ask for the project root; otherwise continue to Step 2.
2. Request Profile readiness from `/highway-profile readiness` and consume its four fields. If Profile is not `Complete`, enter Guided Setup for Profile and ask the owner's next question or present its owner-provided `Summary`, `Next Action`, and `Blocking Reason`.
3. When the active owner requests input, present exactly one owner question and example verbatim, collect one response, forward it to the owning workflow, and continue the same stage until terminal success, user interruption, or an owner non-terminal stop condition.
4. Request Objectives readiness from `/highway-objectives readiness` after Profile terminal success. If Objectives is not `Complete`, enter Guided Setup for Objectives and preserve the owner workflow's guided collection and proposal semantics.
5. Request Controls readiness from `/highway-controls readiness` after Objectives terminal success. If Controls is not `Complete`, enter Guided Setup for Controls and preserve the owner workflow's guided collection semantics.
6. Request NFR readiness from `/highway-nfrs readiness` after Controls terminal success. If NFR setup is incomplete, enter Guided Setup for NFR review or author decision without recomputing candidate, acceptance, catalog, or artifact completeness in Setup.
7. Classify each owner response using the terminality decision table. `Complete` and applicable `Not Applicable` are terminal success; `Missing`, `In Progress`, `Blocked`, declined, aborted, malformed, and unknown responses are non-terminal and never fabricate completion.
8. For a non-terminal response, stop or pause at the first active owner, expose its owner-provided `Next Action` and `Blocking Reason` where supplied, and do not invoke downstream workflows. A user interruption or cancellation ends the current interaction without creating a cancellation marker or Setup checkpoint.
9. On a new invocation, re-read persisted owner readiness and resume at the first incomplete owner. Report `Step`, `Stage`, `Completed Stages`, `Current Stage`, `Remaining Stages`, and `Current Activity`; use `Step 1: Profile`, `Step 2: Objectives`, `Step 3: Controls`, and `Step 4: NFRs`.
10. If Profile, Objectives, Controls, and NFR are complete or not applicable as required, emit `Highway Setup Complete` followed by the exact completion dashboard; otherwise emit the Guided Setup progress report and the next owner activity.

## Guided Setup

Guided Setup is the active orchestration mode used whenever the first incomplete owner is found. It owns only progress framing, ordered routing, continuation, and dashboard output. It does not directly create, update, remove, replace, allocate identifiers for, regenerate catalogs for, or repair relationships among owner artifacts.

After each terminal owner result, Guided Setup automatically advance to the next owner stage in the fixed Profile, Objectives, Controls, and NFRs order.

### Progress Contract

FR-009A numeric step mapping is: Step 1 is Profile, Step 2 is Objectives, Step 3 is Controls, and Step 4 is NFRs.

| Field | Contract |
|---|---|
| `Step` | `1` Profile, `2` Objectives, `3` Controls, `4` NFRs |
| `Stage` | The stage represented by the step |
| `Completed Stages` | Ordered stages whose owners returned terminal success |
| `Current Stage` | `Profile`, `Objectives`, `Controls`, `NFRs`, or `Complete` |
| `Remaining Stages` | Ordered stages not yet terminally successful |
| `Current Activity` | The active owner's next action or question |

Guided Setup asks exactly one unresolved owner question at a time and waits for its response. Owner questions and examples are byte-identical to the owner workflow output; Setup may add only its own progress framing.

### Terminality Decision Table

The terminality decision table classifies every owner response before Setup advances.

Malformed and unknown responses produce a deterministic Setup `Blocked` result.

| Owner response | Classification | Setup behavior |
|---|---|---|
| `Complete` | Terminal success | Mark the stage complete and advance. |
| Applicable `Not Applicable` | Terminal success | Mark the stage not applicable and advance. |
| `Missing` or `In Progress` | Non-terminal | Remain at the stage and present the owner's next action or question. |
| `Blocked` | Non-terminal | Pause at the stage and present the owner's blocking reason and next action. |
| Declined or aborted | Non-terminal | End or pause Setup without advancing or fabricating completion. |
| Malformed or unknown | Non-terminal | Mark Setup blocked, identify the response-shape failure, and do not invoke downstream owners. |

### Resume and Cancellation

Setup conversation state exists only for the duration of the interaction and is not an independently persisted wizard checkpoint. After interruption, user cancellation, or a new invocation, Setup re-reads persisted owner readiness and resumes at the first incomplete owner. It does not restore an exact unanswered question, cancellation marker, or competing Setup checkpoint.

## Ordered Readiness Rules

| Evaluation order | State condition | Result | Next action |
|---|---|---|---|
| 1 | Profile owner returns `Complete` | Continue to Objectives readiness | `/highway-objectives readiness` |
| 2 | Objectives owner returns `Complete` | Continue to Controls readiness | `/highway-controls readiness` |
| 3 | Controls owner returns `Complete` | Continue to NFR readiness | `/highway-nfrs readiness` |
| 4 | NFR owner returns `Complete` or `Not Applicable` | Setup `Complete` | Step 10 |
| 5 | Any owner returns `Missing`, `In Progress`, or `Blocked`; NFR returns only `In Progress` or `Blocked` | Report owner response and stop at first non-complete owner | Owner-provided `Next Action` |
| 6 | Any response is malformed or has an unknown status | Setup `Blocked`; later owners `Not Evaluated` | Repair response contract |

The zero-candidate branch is valid only when the Control-owned candidate generation path explicitly succeeds with a count of zero. It is distinct from unavailable, malformed, pending, and accepted candidate results.

The active owner may remain `pending`, `declined`, or otherwise incomplete; Setup reports that the owner remains incomplete and does not fabricate completion. If an owner response fails or is malformed, abort setup at that owner. The NFR `In Progress` and `Blocked` routes remain distinct and preserve the owner-provided `Next Action`.

## Dashboard Contract

When complete, emit exactly this information and ordering:

```text
Highway Setup Status

Profile: Complete
Business Objectives: Complete
Controls: Complete
NFRs: Complete

Setup: Complete

Governance Management

Profile:
	/highway-profile

Business Objectives:
	/highway-objectives

Controls and NFRs:
	/highway-controls

Help:
	/highway-help

Advanced Administration

Relationships:
	/highway-relationships

Questionnaire:
	/highway-inquiry
```

When candidate generation succeeds with zero candidates, emit the same completion dashboard with `NFRs: Not Applicable`; do not invoke NFR authoring and do not create an NFR artifact.

When incomplete, emit the same heading and ordered status fields, with `Setup: In Progress` and a `Current Activity` naming the first incomplete or blocked owner workflow. Later areas remain `Not Evaluated`. For example:

The status labels include `Profile: Missing`, `Business Objectives: Missing`, `Controls: Missing`, and `NFRs: Not Evaluated` when those states apply.

```text
Highway Setup Status

Profile: Complete
Business Objectives: Missing
Controls: Not Evaluated
NFRs: Not Evaluated

Setup: In Progress

Current Activity:
Business Objective Setup
```

## Ownership Boundaries

- `/highway-profile` owns Profile setup, organization identity, Profile completeness, and the Profile artifact.
- `/highway-objectives` owns Business Objective records and catalog changes.
- `/highway-controls` owns Control records and its NFR proposal workflow.
- `/highway-nfrs` owns accepted NFR records and NFR baseline changes.
- `highway-setup` is orchestration only: it does not define owner readiness or mutate owner artifacts.
- `highway-setup` owns only ordered status evaluation, workflow routing, continuation, and dashboard output; Guided Setup adds progress framing without taking ownership of artifacts.

All direct mutation routes go to the owning skill. Setup forwards proposals and responses, then preserves the owner's confirmation, cancellation, rejection, duplicate handling, validation, and no-write semantics. Setup never writes Profile, Objectives, Controls, NFRs, catalogs, identifiers, candidates, or relationships itself.

## Verification

- Confirm Setup consumes Profile readiness and the other owner readiness responses without redefining their completeness rules.
- Confirm the terminality decision table treats NFR `Complete` and `Not Applicable` as terminal success, including the `NFRs: Not Applicable` zero candidates case.
- Confirm Guided Setup presents one unresolved question at a time, preserves owner question and example bytes byte-identical, and can re-read persisted owner readiness without creating a cancellation marker.
## Error Handling

- `.highway/` cannot be located: abort and ask for the project root.
- Profile, Objective, Control, or NFR input is malformed: abort the owning step, identify the file or field, and do not write an artifact from this skill.
- An owner workflow is declined, fails, or remains incomplete: abort setup, report the owner and blocking condition, and do not invoke downstream workflows.
- An NFR proposal is pending: escalate to the author for a decision, pause setup with `Setup: In Progress`, and do not display completion or treat the proposal as an accepted NFR.
- Candidate generation is unavailable or malformed: report NFRs `Blocked`, abort setup, and do not treat the result as zero candidates.
- An NFR proposal is declined: abort setup and report that no completion dashboard was emitted.
- A repository state does not match the ordered rules: abort and report the conflicting area rather than guessing.
- A suspected vulnerability is encountered in a workflow or artifact: escalate to the user, report it, and do not alter it silently.

## Example

```text
/highway-setup
```
