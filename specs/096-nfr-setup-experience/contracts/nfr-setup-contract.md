# NFR Setup and Collection Contract

## Active collection result

For `/highway-nfrs setup` and `/highway-nfrs configure`, the owner returns this result in exact field order:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Continue` means active NFR collection remains open. `Finished` is terminal for active collection only
when the user explicitly finishes. `Declined` and `Aborted` do not represent successful collection
completion. `Blocked` requires a non-empty blocking reason. No created-NFR-ID list is included.

This result is separate from the read-only readiness response:

```text
Status: <Complete, In Progress, Blocked, or Not Applicable>
Summary: <NFR readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

Readiness describes persisted NFR/candidate state and never substitutes for the active collection
result.

## Candidate review presentation

Review one unresolved candidate at a time using:

```text
Based on your [Control subject] [descriptor], Highway recommends:

[NFR statement]

Why it matters:
[candidate rationale expressed as user-relevant significance]

Would you like to accept it, change it, replace it, or skip it?
```

The subject and descriptor are transient presentation language. The user-facing decisions map to the
existing durable candidate decisions: `accept` to acceptance, `change` to modification, `replace` to
replacement, and `skip` to final non-acceptance. Cancel, pause, and interruption exit the workflow;
they do not mark the candidate skipped.

## Open discovery

After all derived candidates have been decisioned and the review persistence boundary succeeds, and
immediately when zero derived candidates exist, ask:

> **Are there any qualities or operational expectations you'd like future solutions to meet?**
>
> For example, you might care about reliability, availability, scalability, performance, security, compliance, maintainability, or operability.
>
> If you'd like some suggestions based on what Highway already knows, just let me know. **If you're not sure, just say "I don't know," and we'll work through it together.**

The same question is used for direct `setup`/`configure` with no usable evidence. A direct Add with
usable evidence evaluates that evidence before the generic opening.

## User-authored proposal

Use the existing proposal pattern:

```text
Here's the expectation I've captured:

[NFR statement]

Why it matters:
[user-approved or evidence-grounded rationale]

Does this reflect what you need?
```

After every verified user-authored creation, ask whether to define another NFR, request suggestions,
or finish. Suggestions remain transient until the user adopts or restates one. Direct user-authored
records persist with `controls: []`.

## Setup consumption boundary

Setup renders NFR-owned interaction unchanged and consumes only the declared owner result. It does not
inspect candidate content, counts, NFR records, relationships, or internal readiness logic.

The active completion sequence is:

```text
explicit user finish
  -> NFR collection result: Succeeded / Finished
  -> fresh NFR readiness
  -> Setup advances only on the owner's terminal-success readiness
```

A `Continue`, `Declined`, `Aborted`, `Blocked`, malformed, or non-terminal result does not permit the
successful Setup conclusion. Zero candidates and zero accepted NFRs may still finish collection
explicitly; fresh readiness independently reports the persisted-state outcome.
