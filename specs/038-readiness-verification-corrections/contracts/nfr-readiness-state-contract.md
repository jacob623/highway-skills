# NFR Readiness State Contract

## Ordered Evaluation

Evaluate the rows in the order shown and stop at the first matching row:

| Order | Condition | Status | Next Action | Blocking Reason |
|---:|---|---|---|---|
| 1 | Candidate generation is unavailable | `Blocked` | Repair candidate generation | Required and non-empty |
| 2 | Candidate generation is malformed or contradictory | `Blocked` | Repair candidate generation | Required and non-empty |
| 3 | Generation succeeds with zero candidates and no accepted artifacts | `Not Applicable` | `None` | `None` |
| 4 | Candidates exist and none are accepted | `In Progress` | Author review | `None` |
| 5 | Accepted valid artifacts exist | `Complete` | `None` | `None` |

NFR `Missing` is excluded from this contract. It MUST NOT appear in the NFR owner contract,
Setup routing table, NFR fixture matrix, or Feature 038 coverage record.

## Response Contract

Every evaluated state emits exactly four ordered fields:

```text
Status: <status from the table>
Summary: <non-empty state explanation>
Next Action: <table action>
Blocking Reason: <table reason or None>
```

## Contradictory Inputs

A zero candidate count with one or more candidate entries is `Blocked`. Any input that matches
multiple rows after ordered evaluation is `Blocked` with a non-empty contradiction reason.
