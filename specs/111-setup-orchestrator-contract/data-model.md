# Data Model: Setup Orchestrator Contract Simplification

Setup does not introduce durable entities. The following transient contract values are consumed
from owner skills and are never persisted by Setup.

## Owner readiness result

- **Owner**: Profile, Objectives, Controls, or NFRs.
- **Fields**: owner-declared status, summary, next action, and blocking reason according to that
  owner's contract.
- **Lifecycle**: requested for the current owner, consumed, then either delegated, stopped, or
  used to advance.
- **Ownership**: the owner determines the status and readiness meaning.

## Owner collection result

- **Fields**: `Action Status`, `Collection Result`, `Next Action`, and `Blocking Reason`.
- **Lifecycle**: returned after a delegated collection action; `Continue` keeps the current owner
  active, while `Finished` triggers fresh readiness.
- **Ownership**: the active owner determines the result and its domain meaning.

## Setup domain transition

- **Fields**: a concise user-facing transition for Objectives, Controls, or NFRs.
- **Lifecycle**: emitted once when Setup enters a new domain that requires owner interaction.
- **Ownership**: Setup owns only the transition wording and placement; the owner owns the following
  interaction.

## Relationships and invariants

- Owner order is Profile → Objectives → Controls → NFRs.
- Setup owns no artifact, catalog, candidate state, relationship, or checkpoint entity.
- Setup advances only from an owner-declared terminal result with no active next action.
- A new interaction re-requests fresh owner readiness and restores no conversational state.
