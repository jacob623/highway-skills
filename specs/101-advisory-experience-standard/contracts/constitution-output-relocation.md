# Contract: Skills Constitution Output Relocation

Target file: `.highway/governance/constitution.md`

Version footer after the amendment: `4.1.0`, ratified date unchanged at 2026-09-06, last amended 2026-09-29. Prepend a sync impact report that lists P9.2 through P9.8, states that precedence is unchanged, and records the self-application review against P1.1, P1.2, P1.3, P1.4, P6.4, P6.6, and P7.3. Keep the existing reports.

The file must not contain `.specify/` or `specs/`.

## Added rows

Add these rows to Principle IX, after P9.1. Each rule has one keyword, one obligation, and no more than 25 words. Tag P9.5 `[auto]`. Tag the other added rows `[agent-checkable]`.

| ID | Rule | Observable |
|---|---|---|
| P9.2 | A skill MUST declare the shape of what it emits. | The Outputs section states the fields, sections, or file structure produced. |
| P9.3 | A skill MUST emit content in its declared shape. | Every field and ordering in the output appears in the Outputs declaration. |
| P9.4 | An empty result MUST have a declared form. | The Outputs section states the content emitted when there is nothing to report. |
| P9.5 | A specimen MUST agree with the metadata it repeats. | Every value the Example section shares with the skill frontmatter matches it. |
| P9.6 | A retained file artifact MUST include frontmatter. | Each retained emitted file begins with frontmatter. Transient messages are excluded. |
| P9.7 | A skill that writes a file MUST declare its path. | The Outputs section names each path written. |
| P9.8 | A retained artifact MUST derive its content from declared inputs. | The artifact contains no timestamp, random value, or environment-dependent content. |

Retarget the existing specimen check so it reports under P9.5. Do not add a second specimen check. Do not tag P9.2, P9.3, P9.4, P9.6, P9.7, or P9.8 `[auto]`.

## Unchanged

P9.1 stays. Principle IX's precedence rank stays. P6.6 stays the rule for which action is selected. P10.1 and P10.2 stay. P12.5 through P12.12 stay. The owner and orchestrator contract is not copied again.

## Out of this contract

The Experience Standard edit is in [experience-standard-amendment.md](./experience-standard-amendment.md). Tests, the specimen check, and live citations of the removed contract or retired identifiers are in scope. Shared templates and the development constitution are not modified. Skill domain workflows are not rewritten.
