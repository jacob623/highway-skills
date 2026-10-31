# Quickstart: Codify Suggestions

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `200-codify-suggestions`

## Confirm the list

1. Compare the skill's suggestion step with [contracts/suggestion-list.md](contracts/suggestion-list.md).
2. A start with an implementation and no action shows at most five titles and summaries, then the explore question.
3. A start that already names an action does not show that list.

## Confirm the proposal

1. Compare the proposal and `codify-record.md` with [contracts/proposal-shape.md](contracts/proposal-shape.md).
2. The selected title and summary are the proposal title and summary.
3. The proposal contains one flowchart, at least one acceptance criterion, and a responsibility and a boundary for each component.

## Confirm the suite

Run `.highway/tools/validate-library.sh` on `.highway/library/templates/output/codify-record.md`, `.highway/tools/validate-skill.sh` on `.highway/skills/highway-codify`, and `.highway/tools/tests/run-all.sh`. Each is expected to exit 0.
