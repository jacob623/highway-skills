# Profile Readiness Contract

## Request

`/highway-profile readiness`

Readiness is read-only and evaluates the persisted authoritative Profile at `.highway/library/knowledge/profile.md`.

## Response

Emit exactly these fields in this order:

```text
Status: <Complete, Missing, or Blocked>
Summary: <owner-authored explanation>
Next Action: <declared owner route or None>
Blocking Reason: <reason or None>
```

## Classification

1. If the authoritative Profile is absent, return `Missing`.
2. Otherwise validate the retained artifact.
3. If validation fails, return `Blocked`.
4. If validation succeeds and any domain is `not_discussed`, return `Missing`.
5. Otherwise return `Complete`.

## Profile action mapping

| State | Status | Next Action | Blocking Reason |
|---|---|---|---|
| Absent | Missing | `/highway-profile setup` | None |
| Valid incomplete | Missing | `/highway-profile configure` | None |
| Complete | Complete | None | None |
| Malformed or unsupported schema | Blocked | None | Specific structural failure |

Schema `2.0.0` is the supported version for this feature. Missing, malformed, or unsupported schema values are Blocked and are not silently migrated.

## Ownership boundary

Profile owns artifact validation, domain classification, evidence semantics, and readiness. Setup may validate only the response shape and declared status/action combination; it must not inspect or recompute Profile state.
