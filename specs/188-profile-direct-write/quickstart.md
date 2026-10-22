# Quickstart: Profile Direct Write

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `188-profile-direct-write`
- A repository whose root is the person's project

## Confirm the conversation

1. Read `.highway/skills/highway-profile/SKILL.md` and confirm the three fallback questions and the capture paragraph in [contracts/profile-file.md](contracts/profile-file.md) are absent.
2. Confirm Vision, Competitive Path, and Guiding Principles still include **What would you add, correct, or remove?**
3. Confirm Competitive Path still includes Important Tradeoff, and Guiding Principles still ask for 3 to 5 principles.

## Confirm the file

1. Confirm Profile, Setup, Objectives, Controls, and NFRs name `library/knowledge/profile.md` and do not name `.highway/library/knowledge/profile.md` as the profile to read or write.
2. Confirm `.highway/tools/lib/profile.sh` returns `library/knowledge/profile.md`.
3. Confirm `.highway/library/templates/output/profile-record.md` describes accepted bullets under each domain heading.
4. Confirm the Highway Skills Constitution rationale names `library/knowledge/profile.md`.

## Confirm the suite

Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.

Run `.highway/tools/validate-skill.sh` on `highway-profile`, `highway-setup`, `highway-objectives`, `highway-controls`, and `highway-nfrs`. Each exits 0.
