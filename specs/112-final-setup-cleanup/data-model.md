# Data Model: Final Setup Contract Cleanup

Setup introduces no durable entities. It consumes these owner-provided transient contract values.

## Owner readiness

- **Owner**: Profile, Objectives, Controls, or NFRs.
- **Meaning**: The current owner's authoritative state and supported next action.
- **Lifecycle**: Requested, consumed, then used to advance, delegate, or stop.
- **Ownership**: The owner defines its fields and terminal meanings.

## Owner-specific action result

- **Owner**: The active delegated owner.
- **Meaning**: The result shape declared by that owner after interaction.
- **Controls/NFRs**: May include `Action Status`, `Collection Result`, `Next Action`, and
  `Blocking Reason`.
- **Profile/Objectives**: Use their own declared result shape.

## First-run welcome

- **Lifecycle**: Emitted once when initial Setup begins before the first Profile-owned action.
- **Resume rule**: Never emitted for a resumed Setup interaction.

## Domain transition

- **Fields**: A horizontal rule, concise domain context, and no owner opening.
- **Lifecycle**: Emitted once before the first active interaction in Objectives, Controls, or NFRs.
- **Invariant**: No transition is emitted for skipped or continuing domains.

## Relationships

- Owner order is Profile → Objectives → Controls → NFRs.
- Setup owns no owner artifact, catalog, relationship, checkpoint, or conversational state.
