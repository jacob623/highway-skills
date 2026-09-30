# NFR Candidate State

This framework-owned document defines the durable recovery shape for Control-derived NFR
candidates. It is not a user-owned NFR record, an accepted NFR, or a conversation transcript.

## Record

There is one record for each successfully created originating Control:

```text
Originating Control ID: CTLXXXXXX
Generation Attempt: 1
Candidate Classification / Readiness State: Not Applicable|In Progress|Complete|Blocked
Candidate-Generation Action Result: Succeeded|Blocked
Candidate Entries: [<stable ordered candidate payloads or empty list>]
Review Status: Pending|In Progress|Complete|Cancelled
Blocking Reason: <reason or None>
```

`Originating Control ID` is immutable. `Generation Attempt` is always `1`; candidate derivation is
never repeated for the same Control. Candidate entries preserve stable order and contain:

```text
Candidate Title: <title>
Candidate Statement: <statement>
Candidate Rationale: <rationale>
Originating Control Identifier: CTLXXXXXX
Originating Control Title: <title>
Decision: Pending|Accept|Modify|Replace|Reject|Cancel
Approved Title: <title or None>
Approved Statement: <statement or None>
Approved Rationale: <rationale or None>
```

The candidate count is the number of entries. Zero candidates use `Succeeded` and an empty entry
list. `Blocked` requires a non-empty reason and preserves the successfully created Control without
creating a partial NFR relationship.

## Recovery

Every candidate decision is persisted before the next candidate is presented. Review resumes at the
first `Decision: Pending` entry and does not restore prompts, conversation state, or candidate counts.
Cancellation or interruption preserves durable state and leaves unresolved entries pending.

## Readiness interpretation

- `Not Applicable`: valid zero candidates and no accepted NFRs.
- `In Progress`: valid unresolved candidates remain.
- `Complete`: accepted valid NFR artifacts exist.
- `Blocked`: required state is malformed or unavailable; the reason is non-empty.
