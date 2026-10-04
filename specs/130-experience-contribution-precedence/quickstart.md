# Quickstart: Experience Contribution Precedence

## Scope

This feature amends only `.highway/governance/experience-standard.md`. It makes the shared interaction
precedence explicit:

`Converged Proposal -> useful Working Idea -> focused unresolved question`

Do not modify Profile, Objectives, Controls, NFRs, retained artifact templates, X2.18, X2.19, X2.21,
X2.22, X2.25, X2.7, X2.11, X2.24, X2.29, X2.30, Constitution P11.3, or Constitution P11.4.

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

No `.specify/extensions.yml` hooks are registered for this feature.

## 1. Inspect the current anchors

```sh
grep -n 'X2.2\|X2.13\|X2.25' .highway/governance/experience-standard.md
grep -n 'Interaction model\|Collaborative Development\|Context Awareness\|Interaction Examples\|Recommendation sets' .highway/governance/experience-standard.md
```

Expected outcome: all named sections exist before implementation.

## 2. Validate the contribution precedence

After implementation, verify the shared standard contains the three decision states and their order:

```sh
grep -Fq 'a useful grounded choice is shown instead of the question. It then evaluates available relevant context in order: Converged Proposal, useful Working Idea, then focused unresolved question.' .highway/governance/experience-standard.md
grep -Fq 'An Interactive Workflow MUST contribute a grounded Converged Proposal or useful Working Idea before asking when available relevant context supports either.' .highway/governance/experience-standard.md
grep -Fq 'Converged Proposal when understanding is complete, or a useful Working Idea when it is not.' .highway/governance/experience-standard.md
```

Expected outcome: X2.2/X2.13 and the Interaction model distinguish complete convergence, useful
incomplete contribution, and focused-question fallback.

## 3. Validate guidance and examples

```sh
grep -Fq 'Insufficient grounding for a Converged Proposal does not imply insufficient grounding for a Working Idea.' .highway/governance/experience-standard.md
grep -Fq 'Working Idea before fallback question' .highway/governance/experience-standard.md
grep -Fq 'Useful contribution then question' .highway/governance/experience-standard.md
grep -Fq 'Immediate Converged Proposal' .highway/governance/experience-standard.md
grep -Fq 'must not skip directly to a' .highway/governance/experience-standard.md
```

Expected outcome: the standard explains useful Working Ideas, appropriate fallback questions, immediate
convergence, and the non-normative examples without requiring internal category labels in conversation.

## 4. Validate protected boundaries and scope

```sh
for rule in 'X2.18' 'X2.19' 'X2.21' 'X2.22' 'X2.25' 'X2.7' 'X2.11' 'X2.24' 'X2.29' 'X2.30'; do
  grep -Fq "$rule" .highway/governance/experience-standard.md
 done
test "$(git diff --name-only -- .highway/skills .highway/library | wc -l | tr -d ' ')" -eq 0
! grep -n 'X2.36' .highway/governance/experience-standard.md | grep -q 'MUST NOT narrate' || true
```

Expected outcome: protected rules remain present, no individual skill or retained schema changes, and
X2.36 is not duplicated or redefined.

## 5. Run focused and full validation

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/run-all.sh
```

Validated outcome: the focused Experience Standard contract and the full repository suite exit `0`
(`63 passed, 0 failed` for the full suite).

## 6. Review final scope

```sh
git diff --check -- .highway/governance/experience-standard.md specs/130-experience-contribution-precedence
```

Review that the only implementation file changed is `experience-standard.md`, X-rule IDs were not
renumbered, X2.36 remains the sole workflow-narration owner, and Profile synchronization remains
deferred to a later feature.
