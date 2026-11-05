# Quickstart: Codify Products

Prerequisites: the repo root. The phrases to expect are in [contracts/product-steps.md](contracts/product-steps.md). The rows and the placement table are in [data-model.md](data-model.md).

1. `bash .highway/tools/tests/codify-products.test.sh` prints `PASS: codify decides the product from the catalogs`.
2. `bash .highway/tools/validate-skill.sh .highway/skills/highway-codify` prints OK.
3. `bash .highway/tools/validate-skill.sh .highway/skills/highway-adr` prints OK.
4. `bash .highway/tools/validate-library.sh` prints OK for `codify-catalog.md`, `codify-record.md`, `codify-tasks.md`, `codify-metadata.md`, and `codify-integrations.md`.
5. `bash .highway/tools/tests/run-all.sh` reports 0 failed. The passing count is the baseline plus this test.
