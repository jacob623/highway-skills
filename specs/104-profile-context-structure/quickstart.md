# Quickstart: Validate the Profile Context Change

Run these from the repository root. The record is in [contracts/profile-record.md](./contracts/profile-record.md). The skill behavior is in [contracts/profile-skill.md](./contracts/profile-skill.md). Field rules are in [data-model.md](./data-model.md).

## Prerequisites

- The skill edit is `.highway/skills/highway-profile/SKILL.md`.
- The template edit is `.highway/library/templates/output/profile-record.md`.
- `.highway/tools/lib/profile.sh` and `.highway/tools/validate-profile.sh` stay unchanged.
- The Experience Standard, the Skills Constitution, and other skills stay unchanged.
- Run `.highway/tools/tests/run-all.sh` with unrestricted filesystem access.

## 1. Suite before the edit

Run the suite before the first edit of this feature. Expect exit 0.

## 2. Tests fail on the current text

Update `.highway/tools/tests/feature-092-contract.test.sh` and `.highway/tools/tests/output-template.test.sh` as [contracts/profile-skill.md](./contracts/profile-skill.md) describes. Run them before editing the skill and the template. Expect a non-zero exit that names the missing Experience sentence, the old authority sentence, or the missing Context headings.

## 3. Implementation files

Confirm the diff is the Profile skill, the shared template, and those two tests, plus regenerated adapter copies of the skill. Confirm it does not include the Experience Standard, the Skills Constitution, the development constitution, the Profile helper, or another skill.

## 4. Versions and Experience

Confirm the skill metadata version is still 4.0.0. Confirm the template schema and metadata version are still 3.0.0. Confirm the Experience section is exactly `User-visible interaction follows the Highway Experience Standard.`

## 5. Context and behavior

Confirm the template guidance contains `## Context` and the four child headings, and the default body does not emit an empty Context section. Confirm Acquisition states the eight-step order, the opening question, the website path, and the four canonical questions. Confirm enrichment category names remain and are not retained. Confirm readiness still uses the four domains.

## 6. Generated copies

Regenerate agent copies after the source edit. A second generation leaves those copies unchanged. Do not hand-edit the generated copies.

## 7. Suite after the edit

Run the suite again. Expect exit 0.
