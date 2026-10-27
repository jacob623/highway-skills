# Quickstart: Setup Welcome Overview

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `193-setup-welcome-overview`
- The setup skill source is available for a manual pass

## Confirm the welcome

1. Read `.highway/skills/highway-setup/SKILL.md` and confirm the Welcome ends with the overview in [contracts/welcome-overview.md](contracts/welcome-overview.md).
2. Confirm the Welcome instruction names "During setup we'll:" as a level-3 heading, and the source has no literal `###` line for it.
3. Confirm no standalone "Let's get started." line remains.
4. Confirm the heading, tagline, and ownership text above the overview are unchanged.
5. Confirm the welcome is still emitted only when `library/knowledge/profile.md` is absent, and Profile follows with no added transition.

## Confirm the suite

Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.

Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-setup`. The expected result is exit 0.
