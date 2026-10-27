# Quickstart: Guided Flow Refinements

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `194-guided-flow-refinements`
- The four skill sources are available for a manual pass

## Confirm Profile

1. Read `.highway/skills/highway-profile/SKILL.md`. Confirm the Vision, Competitive Path, and Guiding Principles starting points match [contracts/guided-flow-copy.md](contracts/guided-flow-copy.md).

## Confirm Objectives, Controls, and NFRs

1. Confirm every recommendation item uses the numbered form, and `select` accepts numbers.
2. Confirm every set closes with the copy in the contract, including the set shown when the queue already has items.
3. Confirm "If none of these fit" and "just let me know" no longer appear.
4. Confirm each ready-to-review question in `more` and `queue` is followed by its add-another line.
5. Confirm NFR `recommend` lists Controls first, holds Profile, Objectives, and uncovered areas until every Control is reflected, and keeps **No system hosting** and **Direct purchase** unchanged.

## Confirm the suite

Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.

Run `.highway/tools/validate-skill.sh` on each of the four skills. The expected result is exit 0.
