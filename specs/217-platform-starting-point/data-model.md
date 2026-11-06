# Data Model: Platform Starting Point and Automation Grounding

## Use entry

- Fields: text (five words or fewer, one condition or one outcome), Why it matters (one sentence, proposal only).
- Rules: one thing per entry. No "and", "or", comma, or slash joining two things. At least one per list. Grounded in best practice for the platform or standard type in automation.
- Saved form: the text only, joined with `; ` in one cell. No Why it matters line.

## Platform type

- Source: a platform's implementation Technology Choice and `current`. A standard's language or platform.
- Values: pipeline, orchestrator, self-service platform, desired-state or GitOps tool, agent, or the type a standard names.

## New realized capability

- Fields: Title, Realized By, Evidence.
- Source: an automation capability `current` captured that the implementation's Realized Capabilities do not list.
- Lifecycle: marked in `current`, listed in `platform proposal`, edited there before acceptance, recorded by `add capabilities` after the platform write.
- Written to: `implementations/[RI id].md` Realized Capabilities, and this Parent's rows in `implementations/capabilities.md` (ID, Parent, Title, Realized By).

## Return step

- Fields: skill, step name. For this feature: `platform written` in `highway-codify-config`.
- Held by `add capabilities` for one visit. Every exit from `add capabilities` goes to it.

## State flow

`platforms` → `current` → `platform proposal` (follows `use entries`) → `accept` writes the row → new capabilities listed: transition, then `add capabilities` → `platform written`. None listed: `platform written`.
