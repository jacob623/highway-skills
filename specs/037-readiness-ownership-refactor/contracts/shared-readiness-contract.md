# Shared Readiness Contract

## Invocation

Each owner skill supports the explicit read-only action:

```text
/highway-profile readiness
/highway-objectives readiness
/highway-controls readiness
/highway-nfrs readiness
```

## Response

The owner MUST emit exactly four plain-text lines, in this order:

```text
Status: <allowed status>
Summary: <non-empty explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

Allowed statuses are `Complete`, `Missing`, `In Progress`, `Blocked`, and `Not Applicable`.

`Blocking Reason` MUST be non-empty for `Blocked` and MUST be `None` for every other status. Readiness MUST not write files, allocate identifiers, invoke mutation workflows, or accept proposals.
