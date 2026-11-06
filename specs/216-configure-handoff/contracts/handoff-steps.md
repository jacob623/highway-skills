# Contract: Handoff Steps

## highway-onboarding

Procedure order sentence:

`Follow the steps in this order: \`overview\`, \`capabilities\`, \`map\`, \`mapping\`, \`orchestrate\`, \`lineage\`, \`configure\`, then \`summary\`.`

`orchestrate`, replacing "Do not emit the configure pointer here.":

- `A yes adds [Platform] to the platforms to configure, in the order asked.`
- `When \`highway-codify-config\` started this onboarding for [Platform], do not ask this for [Platform].`

`lineage` ends with `Then go to \`configure\`.`

New step, between `lineage` and `summary`:

```text
### configure

1. When no platform to configure remains, go to `summary`.
2. Take the first platform to configure. Remove it from the list.
3. Emit: Let's configure [Platform] for automation.
4. Follow `highway-codify-config` for [Platform], with the return step `configure` in `highway-onboarding`.
```

`summary` drops the line "Run `/highway-codify-config [Platform]` to configure it for automation." The finish-adding line stays.

Verification replaces the pointer bullet with the handoff and the return.

## highway-implementation

`platforms` gains, before "Otherwise write":

`When \`highway-onboarding\` follows this step, return to \`highway-onboarding\` after the write. Do not emit the included line or ask the question.`

The `accept` branch:

`- \`accept\`, or a yes: emit: Let's configure [Platform] for automation. Follow \`highway-codify-config\` for [Platform], with the return step \`close\` in \`highway-implementation\`.`

`decline` and `unknown` go to `close`, as today. Verification replaces the pointer with the handoff.

## highway-codify-config

Entry, as step 2:

`2. When the invocation names a return step, hold it for this visit.`

`menu`:

`- \`decline\`: when a return step is held, go to that step in its skill. Otherwise stop. Write nothing.`

Verification adds the return.

## Rejected

- `Run \`/highway-codify-config [Platform]\` to configure it for automation.` in onboarding
- `Run \`/highway-codify-config [Platform]\` to configure it.` in implementation
- `Do not emit the configure pointer here.` in onboarding
- so that, because, in order to, should, consider, prefer, usually, where appropriate in `configure`, implementation `platforms`, configuration Entry, and configuration `menu`

## Versions

`highway-onboarding` 10.1.0, `highway-implementation` 7.1.0, `highway-codify-config` 3.1.0.
