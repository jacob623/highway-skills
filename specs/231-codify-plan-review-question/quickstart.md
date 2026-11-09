# Quickstart: Codify Plan Review Question

## Prerequisites

Bash, run from the repository root.

## Validate

1. `bash .highway/tools/tests/codify-plan-review.test.sh` prints `PASS: a plan review asks what to add, correct, or remove before the menu`.
2. `bash .highway/tools/validate-skill.sh .highway/skills/highway-codify` exits 0.
3. `bash .highway/tools/tests/run-all.sh` reports 0 failed.

## Walkthrough

Run `/highway-codify` through an accepted proposal until the plan menu appears.

| Reply at the menu | Then | Expected |
|---|---|---|
| `1` | | Every plan section, then the review question and "If this is accurate, just say so." No menu in that message |
| `1` | "looks good" or "no" | The menu, unchanged |
| `1` | A change to a story | One consequence sentence, the updated plan, any gap questions, then the menu |
| `1` | A question | An answer, then the review question again |
| `2` | | The building sentence, with no review question |

Wording: [contracts/wording.md](contracts/wording.md). States: [data-model.md](data-model.md).
