# Contract: Codify platform wording

## `highway-onboarding` (version 10.4.0) and `highway-implementation` (version 7.5.0)

| Line | Replaced | New |
|---|---|---|
| Included line | `**[Platform] is included as a platform that can start automation.**` | `**[Platform] is included as a platform highway can use in highway-codify proposals**` |
| Question | `**Would you like to configure [Platform] for automation?**` | `**Would you like to configure how highway-codify uses [Platform]?**` |
| Configure line | `Let's configure [Platform] for automation.` | `Let's configure how highway-codify uses [Platform].` |

Onboarding `configure` step 3 becomes `3. Emit: Let's configure how highway-codify uses [Platform].`

Implementation `platforms` accept line becomes ``- `accept`, or a yes: emit: Let's configure how highway-codify uses [Platform]. Follow `highway-codify-config` for [Platform], with the return step `close` in `highway-implementation`.``

Verification lines that quote the configure line or say "configure it for automation" use the new wording.

## `highway-codify-config` (version 3.5.0)

| Line | Replaced | New |
|---|---|---|
| Proposal heading | `[On an add or update with no edit yet: **Here is a proposed starting point for configuring [Platform] as a platform capable of executing automation**]` | `[On an add or update with no edit yet: **Here is a proposed starting point for configuring how highway-codify uses [Platform]**]` |
| Menu option | `1. **View or Update Platforms** highway considers for automation and self-service.` | `1. **View or Update Platforms** highway-codify can use in proposals.` |

## Rejected after the change

- `that can start automation.**`
- `configure [Platform] for automation`
- `capable of executing automation`
- `considers for automation and self-service`
