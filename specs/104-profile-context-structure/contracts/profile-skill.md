# Contract: Profile Skill

Source: `.highway/skills/highway-profile/SKILL.md`

## Version and citation

| Field | Value |
|---|---|
| metadata.version | 4.0.0, unchanged |
| Experience | `User-visible interaction follows the Highway Experience Standard.` |
| Removed from Experience | `The Experience Standard remains the normative authority for user-visible interaction.` |
| Behavior sections | `## Profile model`, `## Acquisition`, `## Enrichment`, `## Operations` |
| Removed section | `## Evidence` |

The skill cites the shared template for the Context skeleton and does not repeat those headings. It cites the Highway Experience Standard and does not restate one-question behavior, why-it-matters presentation, example behavior, recommendation-selection acceptance, redundant confirmation, or destructive-confirmation presentation.

## Profile model

Four readiness domains remain: `identity`, `vision`, `competitive_path`, `guiding_principles`. Outcomes remain `not_discussed`, `discussed`, and `bounded`. Schema 2.0.0 stays Blocked and unchanged. Optional context does not affect readiness. Profile owns its evidence, artifact, domain state, and readiness.

## Acquisition order

1. Classify the retained Profile.
2. Establish Repository Name when it is missing, using `**What would you like to call your Highway repository?**` and `If you're using Highway for a company or organization, its name is usually a good choice.`
3. Use supported existing-information or website acquisition when available.
4. Reuse accepted or accepted-discovered evidence across all four domains.
5. Ask the first unresolved canonical domain question.
6. Use optional grounded enrichment where useful.
7. Persist accepted evidence.
8. Report readiness.

A user-provided Organization URL is accepted context. Website-derived Organization Name and other website-derived facts stay proposed until accepted. Unavailable retrieval continues with ordinary acquisition and is not mentioned.

Unresolved questions stay: Identity `**What does [Organization Name] do?**`; Vision `**What is the future vision of [Organization Name]?**`; Competitive Path `**How does [Organization Name] plan to get there?**`; Guiding Principles `**What principles or values guide decisions at [Organization Name]?**`. When Organization Name is not accepted, the accepted Repository Name is used where it reads naturally. A domain with accepted or active evidence is not asked.

## Enrichment

Vision: Future State, Impact, Reach / Scale, Position, and Experience / Reputation. Competitive Path: Customer / Participant, Offering, Market / Reach, Differentiation, Operations, and Capability Development. Guiding Principles: People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy. Those names are not retained. Enrichment does not block completion. Coverage of every category is not required. The skill does not say that selecting a recommendation is accepted without a second confirmation.

## Operations and failure

`setup`, `configure`, `readiness`, `view`, `show`, `describe`, `add`, `update`, `remove`, and `reset` remain. The skill does not describe destructive-confirmation presentation.

Failure text stays:

- An unsupported schema, including schema 2.0.0, is Blocked and is not mutated.
- An obsolete YAML Profile is ignored and is never a fallback or a migration input.
- A malformed retained Profile is Blocked and is not mutated.

## Tests that follow this contract

Update these tests. Comment each replaced assertion with the superseded authority sentence, recommendation-acceptance sentence, or sibling optional heading.

- `.highway/tools/tests/feature-092-contract.test.sh`
- `.highway/tools/tests/output-template.test.sh`

`feature-092-contract.test.sh` requires the new Experience sentence and does not require `Experience Standard remains the normative authority` or `a selected recommendation is accepted without a second confirmation`. It still requires the opening question, the website path, the four canonical questions, the enrichment category names, `those names are not retained`, and `enrichment does not block completion`.

`output-template.test.sh` requires `## Context` and the four `###` children, and does not require the former sibling headings `## Repository Name`, `## Organization Name`, `## Organization URL`, and `## Organizational Context`.
