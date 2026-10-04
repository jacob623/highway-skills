# Quickstart: Contribution Opportunity Before Convergence

## Scope

This feature amends only the shared Experience Standard guidance and its directly affected static contract
expectations. It does not change Profile, Objectives, Controls, NFRs, Setup, Constitution, templates,
retained artifact structures, persistence, or runtime state.

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

No `.specify/extensions.yml` hooks are registered.

## 1. Run the focused baseline

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected outcome: the current Experience Standard baseline passes before the X2.37 amendment.

## 2. Inspect the amendment anchors

```sh
grep -nE 'Contribution Opportunity|X2\.37|X2\.21|X2\.22|X2\.25|Collaborative Development|Recommendation sets|Working Idea versus Converged Proposal' .highway/governance/experience-standard.md
```

Expected outcome: the new definition, rule, interaction guidance, examples, exemptions, and preserved
acceptance anchors are visible in the shared standard.

## 3. Validate the focused amendment

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/rule-checks.test.sh
```

Expected outcome: X2.37 is present without renumbering, X2.21 and existing contribution precedence remain
present, the standard's version/inventory checks pass, and no protected owner artifact changed.

## 4. Check the boundary language

```sh
grep -Fq 'A Contribution Opportunity occurs while the content remains a Working Idea.' .highway/governance/experience-standard.md
grep -Fq 'Do not combine a Contribution Opportunity with a separate artifact-acceptance question' .highway/governance/experience-standard.md
grep -Fq 'The person should not have to review substantially identical final-form prose twice' .highway/governance/experience-standard.md
grep -Fq 'A direct domain-complete statement or explicitly selected Converged Proposal MUST be captured without an additional interpretation review.' .highway/governance/experience-standard.md
grep -Fq 'Before an unresolved question, the workflow evaluates available relevant context in order' .highway/governance/experience-standard.md
```

Expected outcome: Contribution Opportunity remains transient, distinct from acceptance, adaptive, and
subordinate to existing contribution-first behavior.

## 5. Run full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: the full repository suite exits 0 with zero failures.

## 6. Verify scope and formatting

```sh
git diff --check
git diff --name-only -- .highway/skills/highway-profile .highway/library/templates/output/profile-record.md .highway/governance/constitution.md .highway/skills/highway-objectives .highway/skills/highway-controls .highway/skills/highway-nfrs .highway/skills/highway-setup
```

Expected outcome: no protected owner or governance dependency is changed; only the Experience Standard
and its directly necessary contract expectation are in the implementation diff.
