# Research: Configure Handoff

## R1. Pattern

- Decision: Follow the delegation in `highway-setup`. The caller emits one transition, follows the owner, and continues at a named step when the owner returns.
- Rationale: The repository already uses this to run Profile, Objectives, Controls, and NFRs in order and emit one conclusion.
- Alternatives considered: Keeping the closing pointer. Rejected by the request.

## R2. Return step

- Decision: The caller names a return step in the handoff: a skill and one of its step names. `highway-codify-config` holds it from a new Entry step. The menu decline goes to it. With none held, the decline stops, as today.
- Rationale: A named step is one deterministic target. Every other decline in configuration already returns to `menu`, so the menu decline is the single exit.
- Alternatives considered: Returning after the platform write. Rejected, because the person may still configure coding standards.

## R3. Onboarding `configure`

- Decision: A new step after `lineage`. It takes the first platform to configure, removes it, emits the transition, and follows configuration with the return step `configure`. With none left, it goes to `summary`.
- Rationale: Returning to `configure` handles any number of platforms with one loop and emits `summary` once.
- Alternatives considered: Handing off inside `orchestrate`. Rejected, because the request places the handoff after every record exists.

## R4. Paths that do not hand off

- Decision: Onboarding does not ask the configure question for the platform `highway-codify-config` started it for. Implementation's `platforms` returns to onboarding after the write when onboarding follows it, and does not emit its own line or question.
- Rationale: The first keeps the finish-adding line as the only instruction for that platform. The second makes the existing onboarding path explicit, so implementation's handoff runs only on a direct implementation.
- Alternatives considered: Asking and skipping. Rejected, because a yes with no visit misleads the person.

## R5. Pins and moved assertions

Pins that move:

- `highway-onboarding` 10.0.0 to 10.1.0: `codify-platform-catalog.test.sh`, `onboarding-technology-capabilities.test.sh`
- `highway-implementation` 7.0.0 to 7.1.0: `codify-platform-catalog.test.sh`, `record-purpose-titles.test.sh`
- `highway-codify-config` 3.0.0 to 3.1.0: `config-live-rules.test.sh`, `codify-file-layout.test.sh`, `codify-config-skill.test.sh`

Moved assertions:

- `codify-config-skill.test.sh` stops requiring "Run `/highway-codify-config [Platform]` to configure it." in implementation. Reason: R2 replaces the pointer with the handoff. It requires the handoff sentence instead.
- `codify-config-skill.test.sh` stops requiring "Run `/highway-codify-config [Platform]` to configure it for automation." in onboarding. Reason: R3 removes it from `summary`. It requires the `configure` handoff sentence instead. The finish-adding assertion stays.
