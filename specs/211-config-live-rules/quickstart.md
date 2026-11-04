# Quickstart: Current Proposal Rules

Prerequisites: the repo root, with `.highway/skills/highway-codify-config/SKILL.md` at version `3.0.0` and `.highway/library/templates/output/coding-standard.md` at version `3.0.0`. The phrases to expect are in [contracts/proposal-rules.md](contracts/proposal-rules.md). The saved and unsaved fields are in [data-model.md](data-model.md).

1. `bash .highway/tools/tests/config-live-rules.test.sh` prints `PASS: config proposals read current documentation and save the rule only`.
2. `bash .highway/tools/validate-skill.sh .highway/skills/highway-codify-config` prints OK.
3. `bash .highway/tools/validate-library.sh .highway/library/templates/output/coding-standard.md` prints OK.
4. `bash .highway/tools/tests/run-all.sh` reports 0 failed. The passing count is the baseline plus this test.
