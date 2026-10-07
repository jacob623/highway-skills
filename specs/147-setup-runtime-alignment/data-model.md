# Data Model: Setup Runtime Architecture Alignment

This feature introduces no persisted data model. Setup remains a stateless orchestrator that consumes
owner-declared runtime results for the duration of an interaction and persists no checkpoint or owner
conversation state.

## Runtime Concepts

### Owner

A domain skill responsible for its own semantics, completeness, acceptance, persistence, and runtime
result contract. Owners are processed in this order:

1. Profile
2. Objectives
3. Controls
4. NFRs

### Owner Readiness

The current owner's declaration of whether Setup should advance, remain with the owner, stop because
of a block or decision, or delegate a supported action. Setup requests fresh readiness after active
owner work reports completion.

### Owner Result

The owner-specific outcome returned after delegated interaction. Controls and NFRs use Collection
Result contracts; Profile and Objectives use their own declared contracts. Setup consumes each
contract as declared and does not normalize them into a shared schema.

### Next Action

An action supplied by the active owner that Setup may delegate when it is supported. An unsupported
action is an orchestration failure and stops Setup before a later owner is invoked.

### Domain Transition

A short Setup-owned, outcome-oriented presentation emitted once when entering a new active owner
domain. It is separated from the preceding domain with `---`, does not appear for skipped terminal
owners, and does not repeat while the same owner continues.

### Domain Synthesis

A concise Setup-owned user-relevant summary shown when a guided owner domain completes and its
accepted context can be meaningfully summarized, unless the owner already supplied equivalent
user-facing synthesis. Machine readiness and result fields are excluded.

### Setup Lifecycle

```text
fresh readiness in owner order
  -> supported owner action and delegated interaction
  -> owner-specific result
  -> continued owner interaction OR fresh readiness
  -> next owner when permitted
  -> one final Setup conclusion after all owners permit advancement
```

Malformed results, blocked results, declined or aborted results, unsupported actions, and unexpected
orchestration failures terminate the current Setup progression without claiming completion.

## State Ownership

- Setup owns owner sequencing, delegated-action routing, Setup transitions, domain separation,
  optional domain synthesis, welcome timing, and final conclusion timing.
- Owners own domain interpretation, recommendations, completeness, acceptance, persistence, and
  owner-specific result meaning.
- The Highway Experience Standard owns generic user-visible interaction behavior.
- Setup owns no artifact mutation, checkpoint, owner conversational state, convergence decision,
  advisory reasoning, or clarification decision.
