# Contract: Profile Skill

Source: `.highway/skills/highway-profile/SKILL.md`

## Version and citation

| Field | Value |
|---|---|
| metadata.version | 4.0.0 |
| Experience | Profile responses follow the Highway Experience Standard. The Experience Standard remains the normative authority for user-visible interaction. |
| Removed from that section | Current Question, Domain Progress, Current Activity, and the restated exit, ownership, and implementation-detail prose |
| Removed workflow | The numbered eight-step workflow and the per-step failure table |
| Removed input | `.highway/tools/validate-profile.sh` |
| Persistence name | Persist |

The skill cites the shared template, Highway Identity, Highway Vision, and Highway Platform Objectives. It does not restate Experience Standard interaction rules or the common failure model.

## Opening and canonical questions

First-time setup begins with:

```text
**What would you like to call your Highway repository?**

If you're using Highway for a company or organization, its name is usually a good choice.
```

The answer is accepted Repository Name context and is reused in the next prompt.

Unresolved domains use:

| Domain | Question |
|---|---|
| Identity | `**What does [Organization Name] do?**` |
| Vision | `**What is the future vision of [Organization Name]?**` |
| Competitive Path | `**How does [Organization Name] plan to get there?**` |
| Guiding Principles | `**What principles or values guide decisions at [Organization Name]?**` |

When Organization Name is not accepted, the accepted Repository Name is used where it reads naturally. A response is read across all four domains before another canonical question is chosen. A domain with accepted or active evidence is not asked.

When public-website retrieval is available, Profile asks for the public website using the accepted Repository Name before ordinary domain questioning. The supplied URL is accepted. The organization name and other website-derived information stay proposed until accepted. When retrieval is unavailable, Profile continues and does not mention the missing capability.

## Enrichment

A domain may be `discussed` or `bounded` and still receive optional enrichment. Enrichment does not block Complete. A grounded recommendation is preferred. Selecting it accepts the evidence with no second confirmation. Another question is asked only when available evidence cannot support a useful recommendation.

Vision grounding categories are Future State, Impact, Reach / Scale, Position, and Experience / Reputation. Competitive Path grounding categories are Customer / Participant, Offering, Market / Reach, Differentiation, Operations, and Capability Development. Guiding Principles grounding categories are People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy, used for how a principle should influence later decisions. These names are not written into the record. Coverage of every category is not required.

Profile does not store a small-business, enterprise, maturity, persona, or advisory classification.

## Readiness and failure

Readiness prints Status, Summary, Next Action, and Blocking Reason. The four conditions and routes are in [data-model.md](../data-model.md).

Failure text records only:

- An unsupported schema, including schema 2.0.0, is Blocked and is not mutated.
- An obsolete YAML Profile is ignored and is never a fallback or a migration input.
- A malformed retained Profile is Blocked and is not mutated.

A failed mutation is not reported as success, under the common failure model, without a second procedure in this skill.

## Verification section

The Verification section confirms the retained record follows the template, readiness uses the four domains, Highway Role is outside Profile, the three named optional values do not affect readiness, only user-provided or user-accepted organizational evidence is retained, website-derived information stays proposed until accepted, canonical questions are limited to unresolved domains, accepted evidence prevents a repeated question, enrichment categories are not persisted, a selected recommendation needs no second confirmation, material interpretation follows the Experience Standard, no validator run or byte check is required, and Profile ownership and readiness stay with Profile.

## Operations

`setup`, `configure`, `readiness`, `view`, `show`, `describe`, `add`, `update`, `remove`, and `reset` remain. Destructive confirmation follows the Experience Standard. An action that standard already counts as acceptance does not gain another confirmation.

## Tests that follow this contract

Update these tests and the `profile-092` fixtures. Comment each replaced assertion with the superseded five-domain, schema 2.0.0, validator-instruction, or persist-and-verify behavior.

- `.highway/tools/tests/output-template.test.sh`
- `.highway/tools/tests/feature-092-contract.test.sh`
- `.highway/tools/tests/profile-structure.test.sh`
- `.highway/tools/tests/profile-migration.test.sh`
- `.highway/tools/tests/profile-markdown-contract.test.sh`
- `.highway/tools/tests/profile-lifecycle.test.sh`
- `.highway/tools/tests/profile-behavior.test.sh`
- `.highway/tools/tests/highway-ux-alignment.test.sh` for the removed Profile presentation labels

`highway-ux-alignment.test.sh` still requires `Highway Experience Standard` on one line in the Profile skill. `feature-092-contract.test.sh` still requires `Experience Standard remains the normative authority` and the two Next Action routes.
