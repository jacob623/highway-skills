# Data Model: Unified Recommendation Exploration Refactor

This feature does not introduce a new persisted data model. The entities below describe existing owner records and transient interaction concepts needed to validate the contract.

## Recommendation

A grounded Working Idea presented by an Objective or Control owner.

- **Source context**: accepted Profile evidence for Objectives; accepted Objectives and existing owner context for Controls.
- **Status**: transient until selected, modified, accepted as a proposal, or discarded.
- **Persistence**: no record is created by recommendation generation.
- **Constraint**: a recommendation under evaluation is not a queue member.

## Active Objective Queue

The ordered set of Objective recommendations selected by the person during exploration.

- **Membership**: selected recommendations only.
- **Ordering**: determines later development order.
- **Growth**: may continue while recommendation exploration remains active.
- **Persistence**: transient interaction state; membership does not allocate identifiers, begin proposal development, or capture an Objective.

## Active Control Queue

The ordered set of Control recommendations selected by the person during exploration.

- **Membership**: selected recommendations only.
- **Ordering**: determines later development order.
- **Growth**: may continue while recommendation exploration remains active.
- **Persistence**: transient interaction state; membership does not allocate identifiers, begin proposal development, or capture a Control.

## Recommendation Exploration

The phase in which the owner presents grounded recommendations, accepts selections into the active queue, and evaluates whether useful non-duplicate recommendations remain.

- **Entry**: recommendation presentation or a user-provided Objective/Control that requires normal proposal development.
- **Continuation**: additional recommendation sets may be presented while useful opportunities remain.
- **Exit**: recommendation exhaustion, a user-provided Objective/Control, or an explicit queue-processing request.
- **Freeze**: once queue processing begins, exploration remains closed until processing completes.

## Converged Objective or Control Proposal

A developed owner proposal containing the title, operational or safeguard statement, and rationale needed for explicit acceptance.

- **Precondition**: the item is selected for processing or directly provided by the person.
- **Acceptance**: only explicit user acceptance permits capture.
- **Correction**: revision invalidates prior acceptance and requires a new correction or acceptance opportunity.

## Captured Objective or Control

An accepted, persisted record owned by its respective owner skill.

- **Creation**: only after proposal presentation and explicit acceptance.
- **Identity**: existing permanent identifier allocation remains unchanged.
- **Relationships**: existing relationship and catalog behavior remains unchanged.
- **Exclusions**: upstream Profile or Objective acceptance does not automatically create downstream records.

## State Transition Contract

```text
Recommendation under evaluation
↓ selection
Queued Working Idea
↓ recommendation exhaustion or explicit queue start
Processing queue member
↓ proposal development
Converged proposal
↓ explicit acceptance
Captured owner record
```

Recommendation exploration and queue membership are transient interaction concepts, not new persisted lifecycle records.
