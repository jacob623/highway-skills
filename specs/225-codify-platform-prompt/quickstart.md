# Quickstart: Codify Platform Prompt

## Prerequisites

A clean baseline: `bash .highway/tools/tests/run-all.sh` ends with `0 failed`.

## Validate

1. Run the feature test:

   ```bash
   bash .highway/tools/tests/codify-platform-prompt.test.sh
   ```

   Expected: `PASS: platform prompts name how highway-codify uses the platform`

2. Confirm the old wording is gone from the three skills:

   ```bash
   rg -n 'that can start automation\.\*\*|configure \[Platform\] for automation|capable of executing automation|considers for automation and self-service' \
     .highway/skills/highway-onboarding .highway/skills/highway-implementation .highway/skills/highway-codify-config
   ```

   Expected: no output.

3. Validate each skill:

   ```bash
   for s in highway-onboarding highway-implementation highway-codify-config; do bash .highway/tools/validate-skill.sh .highway/skills/$s; done
   ```

4. Run the full suite. Expected: `0 failed`.

Wording for each line is in [contracts/wording.md](contracts/wording.md).
