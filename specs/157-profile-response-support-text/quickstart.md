# Feature 157 Quickstart Validation

## Prerequisites

- Run from the repository root: `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`.
- Use the repository's default macOS shell/toolchain.
- Ensure the Feature 157 source and generated adapters are present.

## Validate the static contract

Run the focused Feature 157 check:

```sh
.highway/tools/tests/feature-157-profile-response-support-text.test.sh
```

Expected result:

```text
OK: Feature 157 Profile response support text contract passes
```

The check must identify itself as a static-document-contract check. A passing result verifies source-document wording, ordering, centralized ownership, preserved literal examples, protected Profile boundaries, and source/generated adapter correspondence. It does not establish runtime conversational behavior.

## Regenerate adapters

After changing `.highway/skills/highway-profile/SKILL.md`, regenerate the declared agent adapters:

```sh
.highway/tools/generate-agent-adapters.sh
```

Expected result: the Profile adapters under `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/` are regenerated from the source without drift.

## Run the full suite

```sh
.highway/tools/tests/run-all.sh
```

Expected result: all checks pass, including the Feature 157 focused check. Static-document checks remain separate from runtime behavior evidence.

## Manual review scenarios

1. Inspect the Profile source and confirm the domain-completeness definition appears first, followed by the self-contained `##### Response Support Text` subsection and then the existing `#### Advisory question scaffolding` heading.
2. Confirm a candidate review is described as capture heading, Validation Question, then applicable reassurance, with only the Validation Question emphasized.
3. Confirm Discovery Reassurance is not selected merely because no user Substantive Contribution exists when a grounded Working Idea is available.
4. Confirm literal support wording remains in examples while behavioral definitions use canonical labels.
5. Confirm the Experience Standard, advisory scaffolding, structure-revealing contribution guidance, possibility-list guidance, convergence, acceptance boundaries, and domain reasoning remain unchanged.
