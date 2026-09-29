# Quickstart: Validate the Objectives Rewrite

Run these from the repository root. Skill behavior is in [contracts/objectives-skill.md](./contracts/objectives-skill.md). The retained record is in [contracts/objectives-record.md](./contracts/objectives-record.md). Field rules are in [data-model.md](./data-model.md).

## Prerequisites

- The skill edit is `.highway/skills/highway-objectives/SKILL.md`.
- The only Setup edit is the quoted Objectives opening in `.highway/skills/highway-setup/SKILL.md`.
- `.highway/library/templates/output/objective-record.md` stays unchanged.
- The Experience Standard, the Skills Constitution, and the Profile skill stay unchanged.
- Run `.highway/tools/tests/run-all.sh` with unrestricted filesystem access.

## 1. Suite before the edit

Run the suite before the first edit of this feature. Expect exit 0.

## 2. Tests fail on the current text

Update `.highway/tools/tests/objective-management.test.sh`, `.highway/tools/tests/highway-ux-alignment.test.sh`, `.highway/tools/tests/experience-x23-contract.test.sh`, and `.highway/tools/tests/highway-setup.test.sh` as [contracts/objectives-skill.md](./contracts/objectives-skill.md) describes. Run them before editing the skills. Expect a non-zero exit that names the missing Experience sentence, the old Significance text, or the suggestion sentence.

## 3. Implementation files

Confirm the diff is the Objectives skill, the quoted Setup opening, and those tests, plus regenerated adapter copies. Confirm it does not include the Experience Standard, the Skills Constitution, the development constitution, the Objective record template, or the Profile skill.

## 4. Versions and Experience

Confirm the Objectives metadata version is 3.0.0. Confirm the Objective record template version is still 1.0.0. Confirm the Experience section is exactly `User-visible interaction follows the Highway Experience Standard.`

## 5. Discovery and continuation

Confirm Significance and the suggestion sentence are gone. Confirm a multi-selection during setup or configure asks `**Is there another objective you'd like to capture?**` once after the whole selection. Confirm add and new do not ask that question. Confirm the record contract still has Statement, Success Measures, and Rationale and has no Highway Relevance field.

## 6. Generated copies

Regenerate agent copies after the source edit. A second generation leaves those copies unchanged. Do not hand-edit the generated copies. Re-run the declared catalog generators. The highway-objectives catalog entry moves from 2.0.0 to 3.0.0.

## 7. Suite after the edit

Run the suite again. Expect exit 0.
