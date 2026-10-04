# Feature 119 Quickstart

## Prerequisites

Run from the repository root on macOS. No package installation or external service is required. The source skill is `.highway/skills/highway-profile/SKILL.md`.

Do not edit `.highway/library/templates/output/profile-record.md`.

## Baseline and Focused Validation

Run the current Profile contracts before implementation:

```sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-structure.test.sh
bash .highway/tools/tests/profile-lifecycle.test.sh
bash .highway/tools/tests/feature-092-contract.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected result: every command exits 0. Focused Feature 119 assertions should cover:

- accuracy-oriented Identity, Vision, Competitive Path, and Guiding Principles validation;
- explicit correction/replacement paths and no second confirmation;
- clarification requests remaining non-acceptance;
- optional acknowledgment connected to accepted Profile context;
- zero or one grounded advisory contribution when useful;
- no manufactured agreement or commentary;
- one cohesive recommendation followed by exactly one validation question;
- transient acknowledgment/advisory commentary and hidden enrichment categories;
- accepted recommendation establishing `discussed` and preventing the fallback canonical question;
- recommendation-first ordering and persistence-before-dependent-result behavior;
- unchanged readiness, brownfield scope, completion synthesis, and Experience Standard boundary.

Validate the source skill:

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-profile
```

## Correspondence and Protected Template Checks

After editing the source skill, regenerate declared outputs:

```sh
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/generate-library-catalog.sh
```

Then verify correspondence and the protected template:

```sh
bash .highway/tools/tests/feature-092-correspondence.test.sh
before=$(git hash-object .highway/library/templates/output/profile-record.md)
after=$(git hash-object .highway/library/templates/output/profile-record.md)
test "$before" = "$after"
test -z "$(git diff --name-only -- .highway/library/templates/output/profile-record.md)"
```

Expected result: generated Profile adapters and catalog entries match the source, and the shared Profile template has no diff.

## Full Validation

```sh
bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the full suite exits 0, all tests pass, and no whitespace errors are reported.

## Scope Review

Review the final diff and confirm it contains only Feature 119 design records, Profile-specific source and focused contract changes, and required generated Profile dependents. Confirm that no changes were made to `profile-record.md`, the Experience Standard, Highway identity, Constitution, Setup, or unrelated skills.

## Feature 119 Execution Evidence

- Baseline full suite: 62 passed, 0 failed.
- Source validator: Profile skill valid, 10 rules checked, 0 unchecked.
- Focused contracts: behavior, lifecycle, structure, Feature 092, UX alignment, Markdown, migration, and Experience Standard all passed.
- User Story 1: all four accuracy-oriented prompts and correction/replacement paths pass; the seeded pre-edit assertions failed as expected.
- User Story 2: optional acknowledge/build/recommend/validate composition, grounded advisory boundaries, hidden conceptual labels, and one-question validation contract pass.
- User Story 3: accepted cohesive narrative, `discussed` transition, readiness stability, transient commentary, and save-before-result boundaries pass.
- User Story 4: generated adapter/catalog correspondence passes; version `5.1.0`, schema `3.0.0`, four readiness domains, recommendation-first flow, brownfield scope, completion synthesis, and Experience Standard delegation remain intact.
- Protected template: `.highway/library/templates/output/profile-record.md` unchanged.
- Final checks: `git diff --check` passed; final full suite was 62 passed, 0 failed.
- Scope review: changes are limited to Feature 119 records, Profile source/tests, and generated dependents; no unrelated skills or shared contracts were changed.
