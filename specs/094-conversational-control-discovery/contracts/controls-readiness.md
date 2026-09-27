# Controls Readiness Contract

Controls readiness is separate from the delegated collection action result and remains exactly four
lines:

```text
Status: <Complete, Missing, or Blocked>
Summary: <Control baseline explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

Readiness reads only verified persisted Control state. At least one valid Control with a consistent
baseline is `Complete`; no valid Control is `Missing`; malformed or inconsistent state is `Blocked`
with a non-empty reason. Readiness writes no files, identifiers, versions, relationships, or NFR
artifacts.

Setup sequence:

1. Request readiness before initial delegation.
2. If pre-delegation readiness is `Complete`, skip Controls.
3. If non-terminal, emit the Setup purpose transition and delegate `/highway-controls setup`.
4. Consume the Controls Action Result first.
5. On successful collection completion, request fresh readiness.
6. Advance only when both delegated action result and fresh readiness permit it.

A readiness transition to `Complete` after the first Control does not terminate an active collection.
