# Data Model: Standard Alignment Onboarding Handoffs

## Onboarding handoff

What highway-onboarding passes to an owner's `onboarding` step, and what it gets back.

| Owner | Passes | Returns | May ask |
|---|---|---|---|
| highway-adr | provider, capabilities, decision, alternatives, rationale, limitations | ADR id, or a failure | nothing |
| highway-architecture | accepted ADR id | `RA` id, a failure, or a decline | `identifier` purpose question, `title` question (FR-021 cases only) |
| highway-implementation | accepted `RA` id, provider, capabilities | `RI` id and whether the platform was included, a failure, or a decline | `title` question (FR-021 case only) |

Order per provider: ADR → RA → RI. A failure is retried once by onboarding. A second failure or a decline
stops that provider and keeps earlier records; onboarding does not claim completion.

## Record templates

| Template | Owner | Location after |
|---|---|---|
| `adr-record.md` | highway-adr | `skills/highway-adr/assets/adr-record.md` |
| `architecture-record.md` | highway-architecture | `skills/highway-architecture/assets/architecture-record.md` |
| `implementation-record.md` | highway-implementation | `skills/highway-implementation/assets/implementation-record.md` |

Content is byte-identical. `hw_template <name>` resolves each.

## ADR catalog row (`adrs/adrs.md`)

| Field | Onboarding ADR | Set by |
|---|---|---|
| ADR ID | derived `ADR` id | highway-adr `onboarding` |
| Discovery ID | `highway` (may repeat across rows) | highway-adr `onboarding` |
| Request ID | `onboarding` | highway-adr `onboarding` |
| Architecture ID | `None`, then the `RA` id | highway-adr, then highway-architecture `name` |
| Status | `accepted` | highway-adr `onboarding` |

State transition for Architecture ID: `None` → `RA…` when `name` succeeds. A direct
`/highway-architecture` run moves the same cell the same way (SC-004).

## Execution chain visits

```text
highway-implementation (outer)  field → holds `execution`
  └─ highway-onboarding (return step `execution`)
       ├─ highway-adr onboarding        → ADR id
       ├─ highway-architecture onboarding → RA id
       └─ highway-implementation onboarding (inner) → platforms → RI id   # returns to onboarding only
  ← onboarding goes to `execution` in the outer visit; no configure question; queue not continued
```
