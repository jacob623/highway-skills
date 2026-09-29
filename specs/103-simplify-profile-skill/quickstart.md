# Quickstart: Validate the Simplified Profile Skill

Run these from the repository root. The record is in [contracts/profile-record.md](./contracts/profile-record.md). The skill behavior is in [contracts/profile-skill.md](./contracts/profile-skill.md). Field rules are in [data-model.md](./data-model.md).

## Prerequisites

- The skill edit is `.highway/skills/highway-profile/SKILL.md`.
- The template edit is `.highway/library/templates/output/profile-record.md`.
- The structural edits are `.highway/tools/lib/profile.sh` and `.highway/tools/validate-profile.sh`.
- Profile contract tests and `profile-092` fixtures are in scope.
- The Experience Standard, the Skills Constitution, and other skills stay unchanged.
- Run `.highway/tools/tests/run-all.sh` with unrestricted filesystem access.

## 1. Suite before the edit

Run the suite before the first edit of this feature. Expect exit 0.

## 2. Tests fail on the current contract

Update the tests listed in the skill contract. Run them before editing the skill and the template. Expect a non-zero exit that names the missing four-domain record, schema 3.0.0, or the removed validator instruction. Record that failure.

## 3. Implementation files

```sh
git diff --name-only -- .highway/skills/highway-profile/SKILL.md .highway/library/templates/output/profile-record.md .highway/tools .highway/governance .specify/memory/constitution.md
```

Expect the Profile skill, the template, the Profile helper, the validator, and the Profile tests and fixtures. Expect no Experience Standard diff, no Skills Constitution diff, and no development-constitution diff.

## 4. Versions and schema

Confirm the skill metadata version is 4.0.0. Confirm the template schema and metadata version are 3.0.0. Confirm a schema 2.0.0 record is rejected and is not rewritten. Confirm `highway_role` and How Highway Helps are absent from the template and the skill.

## 5. Behavior the skill states

Confirm the opening repository-name question, the four canonical questions, the optional headings, and the enrichment categories. Confirm the Experience section cites the Highway Experience Standard and does not restate its interaction rules. Confirm the skill does not name `.highway/tools/validate-profile.sh` and does not require a byte check. Confirm readiness still uses Status, Summary, Next Action, and Blocking Reason.

## 6. Generated copies

Regenerate agent copies and the library catalog after the source edits. A second generation leaves those outputs unchanged. Do not hand-edit the generated copies.

## 7. Suite after the edit

Run the suite again. Expect exit 0.
