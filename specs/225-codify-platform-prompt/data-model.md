# Data Model: Codify Platform Prompt

No stored data changes. The entities are lines a person sees.

| Entity | Shown by | When | Effect of an answer |
|---|---|---|---|
| Included line | `highway-onboarding` `orchestrate`, `highway-implementation` `platforms` | After a platforms catalog row is written for a platform that can start automation | None |
| Question | Same as the included line | Right after it | Onboarding: a yes queues the platform, any answer continues. Implementation: a yes goes to `highway-codify-config`, a no or unknown goes to `close` |
| Configure line | `highway-onboarding` `configure`, `highway-implementation` `platforms` | When a yes starts configuration | Follows `highway-codify-config` for the platform |
| Proposal heading | `highway-codify-config` `platform proposal` | Add or update with no edit yet | None |
| Menu option | `highway-codify-config` menu | Opened without a platform | Opens the platforms view |

Wording for each entity is in [contracts/wording.md](contracts/wording.md).
