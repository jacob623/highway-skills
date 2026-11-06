# Research: Platform Starting Point and Automation Grounding

## R1. Shared entry step

- Decision: A new step, `use entries`, builds When to use and When not to use for both proposals. It sits after `standard write` and before `conflicts`.
- Rationale: `standard proposal` is 383 words today. Adding grounding, entry rules, and the Why it matters lines inside it passes 400. One shared step also states the rules once for platforms and standards. Placing it after `standard write` keeps the existing word-range checks in `config-live-rules.test.sh` intact.
- Alternatives considered: Inline rules in each proposal. Rejected for the word limit and the duplication.

## R2. Return step for the capabilities handoff

- Decision: The after-write questions in `platform proposal` move into a new step, `platform written`. After a write, the handoff to `highway-implementation` names the return step `platform written` in `highway-codify-config`. With no new capability, `accept` goes straight to `platform written`.
- Rationale: The return pattern from spec 216 needs a named step. The after-write order stays the same: conflicts question, coding-standards question, then `platforms`.
- Alternatives considered: Returning to `platforms`. Rejected, because it skips the conflicts and coding-standards questions.

## R3. Transition placeholder

- Decision: The transition reads "Let's record the new capabilities for [Platform]." The spec's [Implementation] is the same value, since Platform is the implementation title.
- Rationale: `highway-codify-config` already defines [Platform]. A second placeholder for the same value adds nothing.
- Alternatives considered: Adding an [Implementation] placeholder. Rejected.

## R4. `add capabilities` in `highway-implementation`

- Decision: Entry step 1 sends an invocation naming an accepted implementation, new realized capabilities, and a return step to `add capabilities`. That step holds the return step, appends the passed capabilities to Realized Capabilities, rewrites this Parent's rows in `implementations/capabilities.md` by the `write` id rules, writes both together, says what it wrote, and goes to the held step. It asks no question. A capability whose id `write` would send to a wording question is left out and named.
- Rationale: The clarification records exactly what the person accepted in the platform proposal. The `write` id rules stay the single source for capability ids.
- Alternatives considered: Asking again. Rejected by clarification.

## R5. Versions of written files

- Decision: The implementation record has no version field, so none changes. `implementations/implementations.md` is not written, since no implementation is added. `implementations/capabilities.md` keeps its version line.
- Rationale: The catalog version rule increments only when an implementation is added.
- Alternatives considered: Incrementing the capability catalog version. Rejected, as no rule asks for it.

## R6. Starting-point line placement

- Decision: The proposal shape carries the line as a bracketed condition: "[On an add or update with no edit yet: **Here is a proposed starting point for configuring [Platform] as a platform capable of executing automation**]". The `edit` branch re-emits the proposal without it.
- Rationale: The shape states the condition in place, as onboarding's summary does for its conditional lines.
- Alternatives considered: A separate numbered step. Rejected, because the line belongs to the emitted shape.

## R7. Pins and moved assertions

Pins that move:

- `highway-codify-config` 3.1.0 to 3.2.0: `config-live-rules.test.sh`, `codify-file-layout.test.sh`, `codify-config-skill.test.sh`, `configure-handoff.test.sh`
- `highway-implementation` 7.1.0 to 7.2.0: `codify-platform-catalog.test.sh`, `record-purpose-titles.test.sh`, `configure-handoff.test.sh`

Moved assertions:

- `config-live-rules.test.sh` stops requiring "The catalog view, a conflict quote, and the saved cell keep the rule only." Reason: entries are no longer rules. FR-024 replaces the sentence form. It requires "The catalog view, a conflict quote, and the saved cell keep the entry only." instead, which `use entries` states.
