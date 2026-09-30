# Data Model: NFR Skill Contract Simplification

## NFR record

The retained artifact remains `library/governance/nfrs/NFRXXXXXX.md`.

| Area | Contract |
|---|---|
| Frontmatter | `id`, `title`, `status`, and identifier-only `controls`; direct records use `controls: []`. |
| Accepted statement | `<accepted NFR statement>` may be directly authored, materially interpreted and accepted, or selected from a Highway recommendation. |
| Accepted rationale | `<accepted evidence-grounded rationale>` is retained accepted content synthesized from accepted evidence or recommendation grounding. |
| Control relationship | Zero or more immutable originating `CTLXXXXXX` identifiers for accepted Control-derived NFRs. |

## Durable candidate state

Framework-owned state remains `.highway/catalog/nfr-candidate-state.md`. It contains one record per
successfully created originating Control:

| Field | Validation |
|---|---|
| Originating Control ID | Required immutable `CTLXXXXXX`; source Control must exist. |
| Generation Attempt | Exactly `1`; no repeated derivation for the same Control. |
| Candidate Classification / Readiness State | `Not Applicable`, `In Progress`, `Complete`, or `Blocked`. |
| Candidate-Generation Action Result | `Succeeded` or `Blocked`; blocked state has a non-empty reason. |
| Candidate Entries | Stable ordered candidate payloads; count must equal entry count. |
| Review Status | `Pending`, `In Progress`, `Complete`, or `Cancelled`. |
| Blocking Reason | Required only for blocked state. |

Each Candidate Entry retains stable accepted recommendation content and:

| Field | Allowed values |
|---|---|
| Decision | `Pending`, `Accept`, `Modify`, `Replace`, `Reject`, or `Cancel`. |
| Approved Title | Accepted title or `None`. |
| Approved Statement | Accepted statement or `None`. |
| Approved Rationale | Accepted evidence-grounded rationale or `None`. |

Review resumes at the first `Decision: Pending` entry. Candidate state is durable and is not
reconstructed from prompts, conversation state, candidate counts, or `Created Control IDs`.

## Owner results

### Readiness result

```text
Status: Complete|In Progress|Blocked|Not Applicable
Summary: <NFR readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

### Collection result

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Finished` requires explicit user finish. Neither readiness nor collection results contain created
NFR identifier lists.

## State transitions

- Candidate generation: absent → one immutable Control-keyed state record.
- Candidate review: `Pending` → one final decision per entry.
- Review completion: all entries final → accepted NFR records and relationships persist atomically.
- Review cancellation/interruption: durable decisions remain; unresolved entries remain pending.
- Readiness: valid zero candidates/no accepted NFRs → `Not Applicable`; unresolved candidates →
  `In Progress`; accepted valid NFRs → `Complete`; malformed/unavailable required state → `Blocked`.
- Collection: active collection remains `Continue` until explicit finish, then returns `Finished`
  independently of readiness.
