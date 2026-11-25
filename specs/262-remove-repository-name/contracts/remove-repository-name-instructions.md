# Contract: Remove Repository Name Instructions

Static checks must find these instructions (or exact equivalents locked below) in the named files.

## Profile (`skills/highway-profile/SKILL.md`)

- Order includes organization name before `offer`, and does not include a repository-name step or a post-offer `organization-name` step.
- First question emits `**What is the organization's name?**`
- Store the reply as Organization Name.
- Decline and unknown on that question re-ask and stay.
- Offer uses `[Organization Name]`.
- Offer routes go to `identity.review` or `identity.ask` without `organization-name`.
- Write includes Organization Name and does not write Repository Name.
- No instruction to use Repository Name.

## Profile record (`skills/highway-profile/assets/profile-record.md`)

- Context children include `### Organization Name`, `### Organization URL`, and `### Organizational Context`.
- No `### Repository Name`.

## Naming skills

- `skills/highway-onboarding/references/proposal.md`: `[Name]` is the accepted Organization Name. No Repository Name fallback.
- `skills/highway-objectives/SKILL.md`: Use the accepted Organization Name from the Profile. No Repository Name fallback.
- `skills/highway-controls/SKILL.md`: same.
- `skills/highway-nfrs/SKILL.md`: same.

## Versions

- Profile skill `14.7.0`
- Profile record template `3.2.0`
- Onboarding `10.15.0`
- Objectives `8.10.0`
- Controls `8.9.0`
- NFRs `9.10.0`
- Plugin source `0.1.4`
