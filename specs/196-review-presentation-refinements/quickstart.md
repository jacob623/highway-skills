# Quickstart: Review Presentation Refinements

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `196-review-presentation-refinements`
- The six skill sources are available for a manual pass

## Confirm capture reviews

1. Read the `capture` step of `highway-objectives`, `highway-controls`, and `highway-nfrs`. Confirm the numbered form in [contracts/presentation-copy.md](contracts/presentation-copy.md) and that `---` still separates items.

## Confirm onboarding

1. Confirm the AI-Assisted Engineering and Planning description matches the contract, and the old description is gone.

## Confirm assessment

1. Confirm each listed finding opens with a derived title and uses **Solution Complexity:**.
2. Confirm the two dismiss lines and when each appears.
3. Confirm `dismiss` from the list updates the rows and re-emits the list.
4. Confirm the finding details end with the new closing line.

## Confirm request

1. Confirm `capture` is gone and `start` uses the contract layout and lead-in.
2. Confirm `accept` goes to `identifier`.
3. Confirm readable names, None for `unknown` or `[]`, and the "none" holding rule.

## Confirm the suite

Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.

Run `.highway/tools/validate-skill.sh` on all six skills. The expected result is exit 0.
