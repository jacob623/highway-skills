# Quickstart: Onboarding and Assessment Guidance

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `195-onboarding-assessment-guidance`
- Both skill sources are available for a manual pass

## Confirm onboarding

1. Read `.highway/skills/highway-onboarding/SKILL.md`. Confirm `overview` sits between `Classify` and `capabilities` and matches [contracts/guidance-copy.md](contracts/guidance-copy.md).
2. Confirm the capability starting point is numbered, single-capability, and includes AI-Assisted Engineering and Planning with its inclusion rule.
3. Confirm `map` emits the transition once and separates each label from its value.
4. Confirm the provider rule names AI-Assisted Engineering and Planning.

## Confirm assessment

1. Read `.highway/skills/highway-assessment/SKILL.md`. Confirm `open` is gone and `list of findings` sits before `finding`.
2. Confirm the opening, list, question, and additional-findings line match the contract.
3. Confirm new findings are written as Open before the list, and Open findings from earlier runs come first.
4. Confirm `back`, `accept`, and `dismiss` return to the list, and `explore` is unchanged.

## Confirm the suite

Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.

Run `.highway/tools/validate-skill.sh` on both skills. The expected result is exit 0.
