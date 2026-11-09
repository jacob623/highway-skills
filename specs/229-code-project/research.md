# Research: Code Project

## R1. Where the record check lives

- Decision: A new `record check` step in highway-codify, entered from Entry step 8 and from `choose`. It routes to `code project`, `draft`, or `rank`. `provider` sends an Executor with no row back to it. `highway-implementation` returns to it.
- Rationale: One owner for completeness (P7.3). The check runs once per selection and once per return.
- Alternatives considered: Keeping `platforms needed` and calling it from Entry. Rejected: its one-run replies are removed, so nothing of it remains.

## R2. Section organization for the code project

- Decision: `code project` holds the trigger, the Establish gate, and the suggestions. `code tasks` holds the proposal shape: Language line, Establish skeleton, pipeline tasks, Standards order, file placement, diagram, product title and join, README, and the close line. `draft`, `standards`, `join`, `folder`, `layout`, `propose`, `code`, and `close` each gain one pointer sentence to `code tasks`.
- Rationale: `code project` alone exceeds 250 words. FR-012 allows one further section. Pointers keep each rule in one place.
- Alternatives considered: Rules inline in each owning step. Rejected by FR-012.

## R3. Establish recorded

- Decision: An Establish feature is recorded when an accepted `code/code.md` row lists this implementation and a Features entry's `<action>` starts with `establish`.
- Rationale: `index` keeps the feature that starts a product, so the Establish entry stays. No product folder is opened.

## R4. The Executor of a code project

- Decision: `provider` step 1 reads "The Executor is Deployed by when the action is establishing or the product is a code project." `provider` keeps "Do not copy the Executor onto a task's Provider."
- Rationale: FR-019. Pipeline tasks name Deployed by as their own Provider through `code tasks`.

## R5. Language unset in the view

- Decision: Language is unset when `Needed`, empty, or naming a standard with no row. A stored `None` shows as stored.
- Rationale: FR-008, aligned with FR-001. A title with no row would otherwise be accepted, return to `record check`, and stop.

## R6. Word limit of `delivery platforms`

- Decision: The Why it matters lines sit inline in the view. Decline moves to a new `delivery decline` step. `delivery platforms` is capped at 400 words.
- Rationale: The view gains about 100 words of user-supplied text. 400 is the step limit. Inline lines keep the view in one place.

## R7. Onboarding return step

- Decision: Remove "When the caller named the return step `provider` in `highway-codify`, go to that step after the platform row is written."
- Rationale: highway-codify no longer hands off to onboarding. The `execution` return stays.

## R8. Moved pins (D3.5)

- `delivery-platform-handoff.test.sh`: the `provider` and `platforms needed` pins become `record check` pins. The decline pin becomes the `delivery decline` pins. The onboarding pin reads `Language: Needed`. The `provider` return pin becomes a reject. `delivery platforms` cap moves to 400.
- `delivery-platform-proposal.test.sh`: step 3 and the Verification bullet read the new Language rule. `delivery platforms` cap moves to 400.
- `codify-platform-catalog.test.sh` and `establish-from-record.test.sh`: "does not list preferred delivery platforms" becomes the missing critical detail line.
- `codify-deterministic-steps.test.sh`: the step order adds `record check`, `code project`, and `code tasks`.
- `establish-from-record.test.sh` and `record-purpose-titles.test.sh`: `implementation-record.md` `version: 2.2.0` becomes `2.3.0`.
- Every test pinning `version: 12.3.0`, `7.7.0`, `10.5.0`, or `9.0.0` moves to `13.0.0`, `7.8.0`, `10.6.0`, or `9.1.0`. Each number belongs to one file only.
