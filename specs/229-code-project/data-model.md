# Data Model: Code Project

## Execution (implementation record)

| Field | Values | Complete when |
|---|---|---|
| Deployed by | `<platform title> (<RI id>)` or `Needed` | It names a platforms-catalog row |
| Managed by | `<platform title> (<RI id>)` or `Needed` | It names a platforms-catalog row |
| Language | `<Standard Title>`, `None`, or `Needed` | It is `None` or names a coding-standards row |

Onboarding writes all three as `Needed`. `highway-implementation` writes them on accept.

## Code project

- Trigger: Language names a coding standard. That standard is the Language standard.
- State: Establish not recorded, or Establish recorded (R3).
- Not recorded: one suggestion, `Establish [implementation title]`.
- Recorded: suggestions from Realized Capabilities, Realized Interfaces, covered Coverage rows, then NFR Realization, at most five after `codified`.

## Proposal task

| Kind | Line | Standards | Placed by |
|---|---|---|---|
| Code task | **Language:** [Language standard] | Language standard, its inherited standards, then standards named in the Technology Choice | Language standard |
| Pipeline task | **Provider:** [Deployed by] | `standards` | Pipeline's platform standard, pipeline files only |
| Other task | **Provider:** [platform] | `standards` | `layout` |

## Flow

Selection → `record check` → incomplete: `highway-implementation` `delivery platforms` → back to `record check` → complete: `code project` or `rank`/`draft`.
