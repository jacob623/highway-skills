# Contract: Organization and offering instructions

Added text is an instruction. Do not add a sentence that explains why.

## Experience Standard

File: `skills/highway-experience/references/experience-standard.md`

Add one row after X2.72:

| ID | Rule | Observable |
| --- | --- | --- |
| X2.73 | When the organization name contains an offering's distinguishing name, an organizational sentence MUST use the full organization name. | The short name appears only for the offering. |

Set both version lines to `11.2.0`. Last Amended `2026-11-23`. Provenance names X2.73 and retires no identifier.

## Profile

File: `skills/highway-profile/SKILL.md`

- Ask `**What is the organization's name?**` once before Identity when Organization Name is not accepted. Do not store Repository Name as Organization Name.
- One Identity finding for who the organization is. One Identity finding per offering. Do not add a finding to reach a count.
- Offering name: person's words for the kind of thing. Drop the product proper name, feature list, and how it is built. One kind, one offering. Different kinds, separate offerings. No category word: ask once. Do not coin a category.
- Do not store a product as the organization or as the offering unless the person says they are the same subject.
- Future State names the organization. Do not infer Vision from offering language alone.
- When the organization and an offering are mixed and the subject is neither one alone, ask one question and emit no proposal in that message. Then resume with the organization as the subject unless the person said they are the same subject.
- When the organization name contains an offering's distinguishing name, put the full organization name in an organizational sentence. Put the short name only on the offering.
- Before write, restate who the organization is and each offering. Accept writes. A merge that is not an explicit same-subject statement does not write.
- `metadata.version` `14.6.0`.

## Onboarding, objectives, assessment

- When the person separates the organization from an offering the accepted Profile fuses, stop. Do not add a record that depends on the fused subject. Offer to revise the Profile. On accept, stop this skill and run highway-profile review before any other record. On decline, stay stopped.

Versions: onboarding `10.14.0`, objectives `8.9.0`, assessment `5.6.0`.

## Onboarding capabilities

In `skills/highway-onboarding/SKILL.md` and `skills/highway-onboarding/references/proposal.md`:

- Do not propose a product behavior, feature, or packaging choice as a capability unless the person says the organization operates it.

## Other skills

Do not restate X2.73.
