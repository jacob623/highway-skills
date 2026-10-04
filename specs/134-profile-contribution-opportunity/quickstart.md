# Feature 134 Quickstart: Profile Contribution Opportunity

## Prerequisites

Run from the repository root with the existing macOS shell/toolchain:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The working tree should contain the Feature 134 artifacts and the current Profile source. Do not modify `.highway/governance/experience-standard.md`, `.highway/governance/constitution.md`, `.highway/library/templates/output/profile-record.md`, or Setup for this feature.

## Focused validation

Run the focused Feature 134 contract after implementation:

```sh
bash .highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh
```

Expected result:

```text
OK: Feature 134 Profile Contribution Opportunity contract passes
```

The contract should verify:

- Profile consumes the shared Contribution Opportunity rather than defining a competing local rule.
- Vision, Competitive Path, and Guiding Principles use provisional substantive pieces before convergence when applicable.
- Mature/domain-complete contributions and complete discovered Identity retain their skip paths.
- Additive responses update transient Working Idea content and "nothing else" does not authorize persistence.
- Contribution Opportunity, domain acceptance, and unresolved discovery questions remain separate.
- Existing subject headings, acceptance wording, schema/readiness boundaries, and protected files remain intact.

Run the adjacent Profile and experience contracts:

```sh
bash .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-lifecycle.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

## Generated artifact validation

After changing `.highway/skills/highway-profile/SKILL.md`, regenerate the declared dependent artifacts using the repository's existing generator workflow. The generated adapters, catalog entries, library catalog, and instruction outputs must remain synchronized with the source.

Then inspect for whitespace errors:

```sh
git diff --check
```

## Full validation

Run the complete suite:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result:

```text
Summary: 63 passed, 0 failed
```

The final change must also confirm that no protected owner, shared governance, retained-template, or Setup path changed outside the Feature 134 scope.
