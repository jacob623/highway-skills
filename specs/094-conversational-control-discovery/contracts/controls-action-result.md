# Controls Action Result Contract

## Scope

This contract applies to delegated `setup` and `configure` collection only. Direct `add` returns the
existing verified Add mutation result and does not open multi-Control collection.

## Owner-only fields

Every setup/configure collection result uses this order:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Created Control IDs: [CTLXXXXXX, ...]
Next Action: ...
```

`Created Control IDs` is cumulative for the current active interaction and contains only immutable
IDs allocated by successful, persistence-verified new Control creations. Reuse, update, rejection,
failure, and pre-existing Controls are excluded. The field is machine-consumable and is not routine
user-facing prose.

## Semantics

- `Succeeded` means the current owner step completed safely.
- `Continue` is non-terminal and follows a verified new Control while collection remains active.
- `Finished` is terminal only after explicit user intent.
- `Declined` and `Aborted` write no new Control and do not permit Setup completion.
- `Blocked` requires a non-empty reason and does not permit Setup to invoke a later owner.
- Zero-Control explicit finish returns `Action Status: Succeeded`, `Collection Result: Finished`,
  `Created Control IDs: []`, the declared next action, and a reason explaining that readiness remains
  Missing.

User-facing copy remains natural, such as the continuation question, and does not expose status
bookkeeping unless an existing owner contract requires machine-readable output.
