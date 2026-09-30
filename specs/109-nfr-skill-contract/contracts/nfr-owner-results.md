# NFR Owner Result Contracts

## Controls → NFRs candidate-generation request

This is an owner-internal request, not a user-facing NFR authoring interaction.

```text
Action: candidate-generation
Originating Control ID: CTLXXXXXX
Derived Candidate Input: <deterministic candidate payload>
```

Controls owns deterministic derivation and sends the request once after a successfully created new
Control. NFRs validates the originating Control and candidate input.

## NFRs → Controls candidate-generation result

```text
Candidate-Generation Action Result: Succeeded|Blocked
Originating Control ID: CTLXXXXXX
Candidate Count: <non-negative integer>
Candidates: [<validated candidate entries or empty list>]
Blocking Reason: <reason or None>
```

`Succeeded` with zero candidates uses `Candidates: []`. `Blocked` requires a non-empty reason,
preserves the successfully created Control, and creates no partial NFR relationship.

## NFR readiness result

```text
Status: Complete|In Progress|Blocked|Not Applicable
Summary: <NFR readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

Readiness is owner-controlled and does not expose candidate counts or require Setup to inspect
candidate state.

## Setup/configure collection result

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Continue` keeps collection active. `Finished` requires explicit user finish. This result is
separate from readiness and contains no created-NFR-ID list.

## Ownership rules

- Controls owns initial candidate derivation and invocation.
- NFRs owns durable candidate state, classification, review, accepted NFR persistence, identifiers,
  catalog, Control relationships, readiness, and collection completion.
- Setup consumes owner results and does not inspect candidate internals or counts.
