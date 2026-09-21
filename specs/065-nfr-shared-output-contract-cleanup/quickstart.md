# Quickstart: highway-nfrs Shared Output Contract Final Cleanup

Run from the repository root.

## 1. Inspect Feature 065 artifacts

```bash
ls specs/065-nfr-shared-output-contract-cleanup
```

Expected design artifacts are `spec.md`, `plan.md`, `research.md`, `data-model.md`, and
`quickstart.md`. No `contracts/` directory is required because this feature exposes no external
interface. Features 061 and 062, protected Request paths, and user-owned NFR outputs must remain
unchanged.

## 2. Validate the canonical skill and shared templates

```bash
.highway/tools/validate-library.sh .highway/library/templates/output/nfr-record.md
.highway/tools/validate-library.sh .highway/library/templates/output/nfr-catalog.md
.highway/tools/validate-skill.sh .highway/skills/highway-nfrs
```

The skill must cite both complete shared templates and retain its behavioral contract.

## 3. Run focused contract checks

```bash
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/nfr-management.test.sh
```

The focused checks must independently reject missing citations, restored record/catalog structure,
removed behavior, stale generated artifacts, and disposable-fixture residue. They must leave
canonical, generated, protected, and user-owned bytes unchanged.

## 4. Regenerate the derived adapters

```bash
.highway/tools/generate-agent-adapters.sh
```

Generated GitHub Copilot, Claude Code, and Cursor adapters must come from the canonical skill; do
not hand-edit generated files.

## 5. Verify correspondence and packaging

```bash
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/distribution-packaging.test.sh
```

All three `highway-nfrs` adapter forms must correspond to the canonical source.

## 6. Run the complete validation suite

```bash
.highway/tools/tests/run-all.sh
git diff --check
```

Expected outcome: all applicable checks pass, with no changed paths under `specs/061-*` or
`specs/062-*`, protected Request paths, or user-owned NFR records/catalogs.

## Expected completion evidence

- `highway-nfrs` cites `nfr-record.md` and `nfr-catalog.md` and no longer declares their complete
  retained structures.
- Record and catalog verification uses template conformance.
- Classification, routing, allocation, versioning, relationship, transaction, determinism,
  validation, and no-write behavior remains detectable.
- Three derived NFR adapters are current, packaging validation passes, and the full suite is green.
