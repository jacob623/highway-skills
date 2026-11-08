# Data Model: Delivery Platform Handoff

No stored shape changes. `implementation-record.md` stays at its current version.

## Execution lines (implementation record)

| Line | Values |
|---|---|
| Deployed by | `<platform title> (<RI id>)` or `Needed` |
| Managed by | `<platform title> (<RI id>)` or `Needed` |
| Language | `<Standard Title>` or `None` |

Onboarding writes `Needed`, `Needed`, `None`. Only `delivery platforms` in `highway-implementation` rewrites these lines on an existing record. It changes no other byte.

## Held for one codify run (not stored)

| Value | Source | Effect |
|---|---|---|
| This-run Executor | A platform the person names at the stop | Replaces the record's Executor for this run |
| This-run Language | A listed coding standard the person names at the stop | Replaces the record's Language for this run |

## Flow

```text
provider ── Executor empty ──> message
  yes ──> "Let's set..." ──> implementation: delivery platforms
            accept ──> write Execution ──> "...are set. Picking up..." ──> provider
            decline ──> "Leaving... unset. Picking up..." ──> provider ──> message
  name ──> row: hold ──> provider
           no row: hold ──> configure or onboard ──> provider
  no ──> stop
```
