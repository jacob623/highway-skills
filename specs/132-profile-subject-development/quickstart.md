# Quickstart: Profile Subject Transition and Working-Idea Development

## Scope

This feature changes the shipped `highway-profile` guidance and directly affected Profile contract
assertions. It does not change the Profile record template, Experience Standard, other skills, schema,
readiness, persistence, or completion behavior.

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

No `.specify/extensions.yml` hooks are registered.

## 1. Inspect subject-transition anchors

```sh
grep -n 'The synthesized subject headings are\|After accepted Profile knowledge is persisted\|Vision evaluates\|A Vision Working Idea\|Competitive Path begins\|Guiding Principles uses' .highway/skills/highway-profile/SKILL.md
```

Expected outcome: the existing Profile subject and re-evaluation anchors are present before the
Feature 132 wording is applied.

## 2. Validate visible headings and focused development wording

```sh
grep -Fq 'When Profile moves from one unresolved subject to another, visibly introduce the new subject' .highway/skills/highway-profile/SKILL.md
grep -Fq 'When an unresolved Profile subject remains, open that subject with its defined heading before developing it.' .highway/skills/highway-profile/SKILL.md
grep -Fq 'When a Working Idea exists, the next question should develop that Working Idea rather than restart the domain.' .highway/skills/highway-profile/SKILL.md
grep -Fq 'When a Competitive Path Working Idea exists but is incomplete' .highway/skills/highway-profile/SKILL.md
grep -Fq 'When a Guiding Principles Working Idea exists but is incomplete' .highway/skills/highway-profile/SKILL.md
grep -Fq 'When Profile presents multiple Working Idea directions' .highway/skills/highway-profile/SKILL.md
grep -Fq 'User-visible contextual re-evaluation expresses what accepted information means' .highway/skills/highway-profile/SKILL.md
```

Expected outcome: the Profile skill describes visible subject openings, focused Working-Idea
questions, grounded alternatives, and suppression of internal-state narration.

## 3. Run focused Profile validation

```sh
bash .highway/tools/tests/feature-092-contract.test.sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/feature-122-profile-experience-synchronization.test.sh
```

Expected outcome: existing Profile contracts pass while preserving prior acceptance and schema rules.

## 4. Regenerate and validate distributed adapters

```sh
.highway/tools/generate-agent-adapters.sh
bash .highway/tools/tests/adapter-coverage.test.sh
```

Expected outcome: the four declared Profile adapters and adapter manifest match the source skill.

## 5. Run shared UX and full validation

```sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: the full repository suite exits 0 with zero failures.

## 6. Verify protected boundaries

```sh
git diff --name-only -- .highway/library/templates/output/profile-record.md .highway/governance/experience-standard.md
bash .highway/tools/validate-profile.sh .highway/library/templates/output/profile-record.md
```

Expected outcome: the protected-file diff is empty and the Profile template remains structurally valid.

## 7. Review final scope

```sh
git diff --check -- .highway/skills/highway-profile .highway/tools/tests specs/132-profile-subject-development .github/skills/highway-profile .claude/skills/highway-profile .cursor/skills/highway-profile .agents/skills/highway-profile
```

Review that only Profile source, directly affected Profile contracts, generated Profile adapters, the
adapter manifest, and Feature 132 planning artifacts changed.
