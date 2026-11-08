# Research: Delivery Platform Handoff

## R1. Where the stop lives

- **Decision**: Keep the stop in `highway-codify` `provider`, which already detects a `Needed`, empty, or rowless Executor. Replace its one-line message with the person's message and the reply handling.
- **Rationale**: `provider` is the first point that knows which field the action needs. Adding a new codify step would move the step-order pins in `codify-deterministic-steps.test.sh`.
- **Alternatives considered**: A new `platforms needed` codify step (more pin churn, same behavior).

## R2. Where the record is written

- **Decision**: A new `delivery platforms` step in `highway-implementation`, entered when an invocation names an accepted implementation and a return step without new capabilities. It holds the return step, shows the five-field view, uses `field` for names, writes only the Execution lines, emits the return line, and goes to the held step.
- **Rationale**: `highway-codify` must not change the implementation. `add capabilities` already sets the pattern for a held return step and a narrow write.
- **Alternatives considered**: Reuse `start` (shows the whole realization and creates a record).

## R3. The this-run platform

- **Decision**: A named platform is held as this run's Executor. A listed coding standard is held as this run's Language. A name with no row is held, then `highway-codify-config` or `highway-onboarding` runs with the return step `provider` in `highway-codify`. When the row still does not exist on return, the message shows again.
- **Rationale**: FR-011 and FR-014. Holding before the detour lets `provider` pick it up on return.
- **Alternatives considered**: Ask the person to repeat the name after configuration (an extra turn).

## R4. Onboarding

- **Decision**: An onboarding implementation stores `Deployed by: Needed`, `Managed by: Needed`, and `Language: None`. Add a return rule for `provider` in `highway-codify` beside the existing `execution` rule.
- **Rationale**: FR-004. The existing `return step \`execution\`` text stays, so its pins hold.

## R5. Moved pins

- `codify-platform-catalog.test.sh`: `'[Field] is needed. Name it on the implementation.'` becomes `"**[Product Title]'s implementation record does not list preferred delivery platforms.**"`. `version: 7.5.0` → `7.6.0`, `10.4.0` → `10.5.0`, `12.2.0` → `12.3.0`.
- `establish-from-record.test.sh`: same message move and the same three version moves.
- `configure-handoff.test.sh`, `record-purpose-titles.test.sh`, `platform-starting-point.test.sh`, `onboarding-technology-capabilities.test.sh`, `propose-edit-lines.test.sh`: version moves only.

## R6. A no on the message

- **Decision**: A no stops the run and writes nothing.
- **Rationale**: Codify cannot propose without the Executor. The spec does not ask for another path.
