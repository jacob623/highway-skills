# Quickstart: Static Highway Capability

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `192-static-highway-capability`
- The onboarding skill source is available for a manual pass

## Confirm the capability

1. Read `.highway/skills/highway-onboarding/SKILL.md` and confirm the capability starting point includes the line in [contracts/highway-capability.md](contracts/highway-capability.md).
2. Confirm the person can remove that line, and a removed line is not mapped.
3. Confirm a known agent platform is the provider for Highway only.
4. Confirm an unknown platform uses the existing unable-to-infer prompt.
5. Confirm a second Highway line is omitted when that provider already has an accepted Highway decision.
6. Confirm the skill does not authorize the agent platform to act on its own.

## Confirm the suite

Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.

Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-onboarding`. The expected result is exit 0.
