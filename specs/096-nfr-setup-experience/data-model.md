# Data Model: Highway NFR Setup Experience

Feature 096 preserves retained NFR record shape and adds no new persisted fields to Controls or NFR records. The collection result is an owner response, not a durable artifact.

## Control-Derived Candidate

- **Owner**: `highway-nfrs` candidate-state contract; derivation remains Control-owned.
- **Identity**: immutable originating Control identifier plus stable derivation order.
- **Retained state**: existing candidate payload, generation state, review status, durable decision, and approved values.
- **Decision vocabulary**: existing durable values remain authoritative. User-facing `accept`, `change`, `replace`, and `skip` map to existing acceptance, modification, replacement, and final non-acceptance behavior. `cancel`, `pause`, and interruption exit the workflow and do not mark a candidate skipped.
- **Ordering**: persisted originating Control identifier, followed by existing derivation order.
- **Transitions**: pending -> one durable decision; review resumes from the first pending entry; all entries must be decisioned before the existing review write boundary succeeds.

## Contextual Recommendation

- **Owner**: `highway-nfrs` presentation layer.
- **Persistence**: transient only; no new Control type, descriptor field, classification enum, or candidate-state field.
- **Inputs**: accepted Control evidence, candidate statement, and candidate rationale.
- **Output language**: concise Control subject plus one descriptor from `requirements`, `safeguards`, `obligations`, `constraints`, or `conditions`, with `requirements` as fallback.
- **Constraints**: routine output omits candidate titles, Control identifiers/titles, candidate-generation terminology, and internal candidate-state terminology.

## User-Authored NFR Proposal

- **Owner**: `highway-nfrs`.
- **Persistence**: transient until explicit user approval and verified existing Add persistence.
- **Retained relationship**: direct authoring persists with `controls: []`; conversational proximity to a Control does not infer a relationship.
- **Lifecycle**: evidence -> one unresolved question or proposal -> user confirmation -> verified Add or transient discard -> continuation prompt.

## NFR Collection Result

Separate from readiness and used for active `setup`/`configure` only.

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

- `Succeeded` plus `Continue`: the active conversation remains open.
- `Succeeded` plus `Finished`: the user explicitly ended collection, including when zero NFRs were accepted.
- `Declined` or `Aborted`: no successful collection completion and no false Setup advancement.
- `Blocked`: no successful completion and a non-empty blocking reason is required.
- No created-NFR-ID list is added.
- The result is transient and is consumed by Setup; it is not persisted or restored as conversational state.

## NFR Readiness Result

Existing four-field read-only contract, unchanged by this feature:

```text
Status: <Complete, In Progress, Blocked, or Not Applicable>
Summary: <NFR readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

Readiness evaluates persisted candidate-generation state and accepted NFR artifacts. It does not infer active collection completion. After collection `Finished`, Setup requests fresh readiness and advances only on the owner's valid terminal-success result.

## Setup Handoff State

- **Owner**: Setup owns only the transition presentation and orchestration sequencing.
- **Persistence**: non-persisted; never restored on New interaction.
- **Boundary**: Controls completion -> NFR readiness -> optional Setup transition -> NFR collection result -> fresh NFR readiness -> existing Setup conclusion.
- **Inspection rule**: Setup consumes owner fields and does not inspect candidates, records, relationships, or NFR internals.
