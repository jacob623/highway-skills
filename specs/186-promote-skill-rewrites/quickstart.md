# Quickstart: Promote Rewritten Skills

Validate this promotion after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `186-promote-skill-rewrites`
- Drafts present in the sibling folder `highway-skills-v2`
- Declared generators available under `.highway/tools/`

## Confirm the sources

1. Compare each draft named in [contracts/skill-promotion.md](contracts/skill-promotion.md) with its source skill. The source contains that draft.
2. Compare each draft named in [contracts/catalog-templates.md](contracts/catalog-templates.md) with its template. Columns and statuses match [data-model.md](data-model.md).
3. Open `.highway/skills/highway-new/SKILL.md` and confirm it does not collect a request.
4. Confirm `.highway/skills/highway-clarify/SKILL.md`, `highway-help`, `highway-relationships`, and `highway-inquiry` are unchanged.

## Confirm publishing

Run `.highway/tools/validate-skill.sh` for each promoted skill and for `highway-new`. Then run the declared generators. A second generator run produces no diff aside from a recorded generation timestamp. Each declared agent tree contains `highway-request` and matches the source skills.

## Confirm checks

1. Read [contracts/check-retirement.md](contracts/check-retirement.md) and `retirements.md`. Every removed assertion names a superseded behavior from that contract.
2. Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.
3. Confirm the Highway constitution, the Spec Kit constitution, and `.highway/governance/experience-standard.md` have no content diff from before this promotion.

## Confirm the invariants by hand

Use a temporary Highway repository, then remove it.

1. Invoke Discovery, the Decision skill, the architecture skill, and the implementation skill with no identifier. Each shows a numbered list. Each line has an identifier and a title. Saying the number selects that row. An empty list says nothing is waiting.
2. Create two records with the same title and confirm they share an identifier. Create a colliding different title and confirm the skill asks for a title change without explaining the derivation.
3. Record a second Decision for one Discovery and confirm the existing Decision is shown and nothing new is written.
4. Read a new Reference Architecture and confirm it names no platform, product, vendor, or specific technology.
