# Quickstart: Validate the Final Objectives Cleanup

Run these commands from the repository root. The skill contract is in [contracts/objectives-skill.md](./contracts/objectives-skill.md). The retained record contract is in [contracts/objectives-record.md](./contracts/objectives-record.md). Evidence rules are in [data-model.md](./data-model.md).

## Prerequisites

- Source skill: `.highway/skills/highway-objectives/SKILL.md`
- Existing record template: `.highway/library/templates/output/objective-record.md`
- Run the suite with unrestricted filesystem access.

## 1. Baseline

Run `.highway/tools/tests/run-all.sh` before editing the source skill. Expect exit 0.

## 2. Red tests

Amend focused tests to require the corrected Profile-owned Blocked wording, Business Objective terminology, synthesized Rationale, the Business Objective + Success review boundary, and the recommendation Success-only follow-up. Require absence of Significance as a discovery requirement and malformed `Why it matters` formatting. Run the focused tests before the skill edit and expect them to fail.

## 3. Source validation

Confirm:

- the skill remains version 3.0.0;
- the Profile context says recommendations, Highway Relevance, and Rationale;
- the blocked Profile wording distinguishes Profile-owned Blocked from unavailable;
- Business Objective and Success make the review ready;
- Highway Relevance is optional and non-persisted;
- Rationale is synthesized from accepted evidence;
- the exact Objective review is present;
- selected recommendations receive no redundant confirmation or separate Rationale question;
- `objective-record.md` remains unchanged at version 1.0.0.

Run `.highway/tools/validate-skill.sh .highway/skills/highway-objectives`.

## 4. Generated copies

Run `.highway/tools/generate-agent-adapters.sh` twice. The second run must be byte-stable. Run the declared catalog generators and confirm the existing highway-objectives version remains 3.0.0.

## 5. Final suite

Run `.highway/tools/tests/run-all.sh`. Expect exit 0.
