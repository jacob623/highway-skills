# Setup Owner-Specific Results Contract

## Owner order

Setup processes owners in this order:

```text
Profile → Objectives → Controls → NFRs
```

## Generic owner loop

1. Request readiness from the current owner.
2. Advance when readiness is terminal with `Next Action: None`.
3. Stop on `Blocked` with the owner-provided context.
4. For a supported `Next Action`, emit the applicable first-domain transition and delegate it.
5. Render the owner interaction unchanged and consume the result declared by that owner.
6. Remain with the owner when its result requires additional interaction.
7. Request fresh readiness when the owner reports active work finished.
8. Advance only when fresh readiness permits it.
9. Stop on malformed or unsupported output.

Controls and NFRs use their declared Collection Result contracts. Profile and Objectives use their
own declared owner results. Setup does not impose one shared collection-result shape.

## First-run welcome

Before the first Profile-owned action in initial Setup, emit:

```text
## Welcome to Highway

*Turn organizational knowledge into connected decisions.*

**Your context stays yours.**
Highway builds on information you choose to accept into your repository. Your repository remains the authoritative source of truth, and you retain ownership of the context and artifacts created through Highway.

---

Let's get started.
```

Do not emit this block on resumed Setup interactions.

## Domain transitions

Emit each block only before the first active interaction in that domain:

```text
---

**Let's identify some outcomes worth pursuing.**

These give Highway something concrete to connect future decisions back to.
```

```text
---

**Now let's establish the safeguards that should guide future technology decisions.**

These help Highway keep future recommendations aligned with what needs to remain true.
```

```text
---

**Now let's consider the operational expectations future solutions should meet.**

These help connect your safeguards to how solutions need to behave in practice.
```
