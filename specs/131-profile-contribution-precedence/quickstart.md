# Quickstart: Profile Contribution-First Synchronization

## Scope

This feature changes the `highway-profile` skill guidance and directly affected Profile contract
assertions only. It does not change `profile-record.md`, the Experience Standard, other skills,
schema version `3.0.0`, readiness, persistence, or retained Profile states.

The expected precedence is:

`Converged Proposal -> useful Working Idea -> focused unresolved question`

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

No `.specify/extensions.yml` hooks are registered for this feature.

## 1. Inspect the Profile anchors

```sh
grep -n '### Acquisition\|### Enrichment\|### Operations\|### Verification' .highway/skills/highway-profile/SKILL.md
grep -n 'X2.13\|Converged Proposal\|Working Idea\|canonical question' .highway/governance/experience-standard.md .highway/skills/highway-profile/SKILL.md
```

Expected outcome: the Profile skill cites the shared Experience Standard and the four domain-specific
sections are present.

## 2. Validate Acquisition precedence

```sh
grep -Fq 'follow the Highway Experience Standard contribution precedence by presenting a Converged Proposal when supported, otherwise contributing a useful Working Idea when supported, and otherwise asking the focused canonical question' .highway/skills/highway-profile/SKILL.md
grep -Fq 'Lack of grounding for a complete Profile-domain proposal does not by itself justify asking the canonical question.' .highway/skills/highway-profile/SKILL.md
grep -Fq 'Before each unresolved canonical question, accepted evidence is evaluated in the shared contribution order: Converged Proposal, useful Working Idea, then focused question.' .highway/skills/highway-profile/SKILL.md
```

Expected outcome: incomplete proposal grounding no longer directly triggers the canonical question.

## 3. Validate domain-specific compounding

```sh
grep -Fq 'Apply the shared contribution precedence before asking the Vision canonical question' .highway/skills/highway-profile/SKILL.md
grep -Fq 'Apply the shared contribution precedence before asking the Competitive Path canonical question' .highway/skills/highway-profile/SKILL.md
grep -Fq 'Apply the shared contribution precedence before asking the Guiding Principles canonical question' .highway/skills/highway-profile/SKILL.md
grep -Fq 'After accepted Identity is available, unresolved Vision is evaluated for a grounded Converged Proposal or useful Working Idea before the Vision canonical question is asked.' .highway/skills/highway-profile/SKILL.md
grep -Fq 'After accepted Vision is available, unresolved Competitive Path is evaluated using accumulated accepted Profile context' .highway/skills/highway-profile/SKILL.md
grep -Fq 'After accepted Competitive Path is available, unresolved Guiding Principles is evaluated using accumulated accepted Profile context' .highway/skills/highway-profile/SKILL.md
```

Expected outcome: Vision, Competitive Path, and Guiding Principles use accumulated accepted context
before their canonical fallback.

## 4. Validate ownership and protected structure

```sh
grep -Fq 'schema version: `3.0.0`' .highway/skills/highway-profile/SKILL.md
grep -Fq 'A Working Idea remains transient' .highway/skills/highway-profile/SKILL.md
grep -Fq 'Agreement with a Working Idea does not trigger Profile persistence' .highway/skills/highway-profile/SKILL.md
git diff --name-only -- .highway/library/templates/output/profile-record.md .highway/governance/experience-standard.md
```

Expected outcome: the first three checks pass and the final command produces no output.

## 5. Run focused Profile validation

```sh
bash .highway/tools/tests/feature-092-contract.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: focused Profile contracts and the full suite exit 0.

Validation result: `feature-092-contract.test.sh`, `feature-122-profile-experience-synchronization.test.sh`,
`profile-behavior.test.sh`, `highway-ux-alignment.test.sh`, and the full suite pass; the full suite
reports `63 passed, 0 failed`.

## 6. Review final scope

```sh
git diff --check -- .highway/skills/highway-profile/SKILL.md .highway/tools/tests specs/131-profile-contribution-precedence
git status --short
```

Review that the shipped implementation change is limited to `highway-profile/SKILL.md`, directly
affected contract assertions and generated Profile adapters are the only related validation/distribution
changes, and protected schema/governance files remain unchanged.
