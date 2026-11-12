# Contract: Onboarding Entry Steps

Each owner exposes a `### onboarding` step reached from a sentence before its Entry list. The
step is the only path by which highway-onboarding creates that owner's record.

## Common

- Reached only when `highway-onboarding` hands off. A person's invocation never reaches it.
- Writes the record as `accepted` through the owner's own `write` (and catalogs), reusing `identifier`.
- Emits no proposal, starting point, or acceptance request.
- Returns its id to `highway-onboarding`. Does not go to `close`.
- A failed write leaves the owner's existing bytes unchanged and returns the failure to
  highway-onboarding; the retry is onboarding's.

## highway-adr

- Inputs: provider, capabilities, decision, alternatives, rationale, limitations.
- Title: the decision sentence. Same title with the derived id → return that id, write nothing.
  Id taken by a different title → add the provider name to the title, derive again, do not ask.
- Values: `request: onboarding`, `discovery: highway`, `status: accepted`, `supersedes`/`superseded_by`
  `None`; Discovery-only sections `None`; no Recommendation Override; Selection Source
  `Accepted onboarding mapping`; alternatives headed by name, no option id; handoff Reference
  Architecture `None`, no implementation entry; catalog Discovery ID `highway`, Request ID
  `onboarding`, Architecture ID `None`.
- Does not ask whether a decision replaces or runs beside another. Changes no architecture.
- Catalog rule: one Discovery ID per row, except `highway`.

## highway-architecture

- Input: accepted ADR id. When the ADR already names an architecture, return that id; write nothing.
- Builds as `start` does without emitting it. Current Decisions is this ADR. No Key Technologies.
- Title and id as `identifier` does. Asks only: the purpose question when the purpose would be empty
  or name a product; the `title` question when the id is taken by a different title or the same title
  for a different ADR. A `decline` returns to onboarding with no architecture.
- Writes as `write` does, then `name` (which sets the ADR field and catalog Architecture ID), then
  returns the `RA` id. A failed `name` returns the failure.

## highway-implementation

- Inputs: accepted `RA` id, provider, capabilities.
- Builds as `start` does without emitting it and without `execution`. Execution is `Deployed by: Needed`,
  `Managed by: Needed`, `Language: Needed`. Capability titles follow `capability title`.
- Title and id as `identifier` does. Asks only the `title` question when the id is taken by a different
  title. Same title under this architecture → reuse it. A `decline` returns with no implementation.
- Writes as `write` does, then `platforms` (no included line, no question), then returns the `RI` id and
  whether the platform was included.
- Returns only to highway-onboarding. Does not go to a step another `highway-implementation` visit holds.

## highway-onboarding

- `orchestrate` hands each provider to highway-adr, then highway-architecture, then
  highway-implementation, once each, and asks nothing itself.
- A failed handoff is followed once more. A second failure or a decline: keep earlier records, name the
  record, do not claim completion.
- After the implementation returns: return step `execution` → go to `execution` in highway-implementation,
  no configure question, queue not continued. Otherwise, when included, emit the included line and the
  configure question (unchanged).
- Names no record template. Review edits update the person's record in its existing structure.
