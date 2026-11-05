# Quickstart: Codify Feature Wording, Governance, and Plan

Prerequisites: the repo root. The phrases to expect are in [contracts/feature-steps.md](contracts/feature-steps.md). The plan sections and the resume rules are in [data-model.md](data-model.md).

1. `bash .highway/tools/tests/codify-feature-wording.test.sh` prints `PASS: codify plans the feature before coding`.
2. `bash .highway/tools/validate-skill.sh .highway/skills/highway-codify` prints OK.
3. `bash .highway/tools/validate-library.sh` prints OK for `codify-record.md`, `codify-tasks.md`, and `codify-plan.md`.
4. `bash .highway/tools/tests/run-all.sh` reports 0 failed. The passing count is the baseline plus this test.
