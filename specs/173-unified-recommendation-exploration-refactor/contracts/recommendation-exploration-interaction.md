# Recommendation Exploration Interaction Contract

## Scope

This contract covers the user-visible Objective and Control setup/configure interaction. It applies the same exploration and queue behavior to both owners while allowing each owner to use its own accepted recommendation context.

## Lineage

```text
Accepted Profile evidence
↓
Objective recommendation

Accepted Objectives
↓
Control recommendation
```

Upstream context informs recommendations. It does not create downstream records, transfer ownership, or begin downstream capture.

## Shared Phase Contract

```text
Recommendation Exploration
↓
Queue Construction
↓
Recommendation Exhaustion
or Explicit Queue Start
↓
Queue Processing
↓
Proposal Development
↓
Acceptance
↓
Capture
```

## Queue Start

Queue processing begins only when recommendation exploration is exhausted or the person explicitly requests queue processing. Examples include:

- `Process the queue.`
- `Let's start with these.`
- `Review the queue.`
- `Capture the queue.`

Selection alone does not begin queue processing, proposal development, or capture.

## Queue Membership

- Recommendations currently under evaluation are not queue members.
- Queued recommendations are recommendations the person has selected.
- Only queued recommendations are eligible for queue processing.
- The active queue may continue growing while exploration remains active.
- Queue membership does not begin proposal development or imply capture.

## Exploration Exit and Freeze

Recommendation exhaustion occurs when no useful grounded non-duplicate recommendation remains, or remaining recommendations would primarily repeat existing coverage, overlap accepted artifacts, or restate already queued recommendations.

Recommendation exploration ends when recommendation exhaustion occurs, the person provides an Objective or Control, or the person explicitly requests queue processing.

Once queue processing begins, recommendation exploration is closed until processing completes.

## Continuation

Recommendation exploration may continue across multiple recommendation sets before queue processing begins. `Collection Result: Continue` does not require queue processing to have started.

A user-provided Objective or Control follows the normal proposal and acceptance path and does not silently process the queue.
