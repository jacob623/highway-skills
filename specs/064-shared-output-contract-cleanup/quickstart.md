# Quickstart: Final Shared Output Contract Cleanup

Run from the repository root.

## 1. Inspect Feature 064 artifacts

```bash
ls specs/064-shared-output-contract-cleanup
```

Expected design artifacts are `spec.md`, `plan.md`, `research.md`, `data-model.md`, and
`quickstart.md`. No `contracts/` directory is required because this feature exposes no external
interface. Features 061 and 062 must remain unchanged.

## 2. Validate the canonical skills and shared templates

```bash
.highway/tools/validate-library.sh .highway/library/templates/output/control-catalog.md
.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md
.highway/tools/validate-library.sh .highway/library/templates/output/discovery-catalog.md
.highway/tools/validate-skill.sh .highway/skills/highway-controls
.highway/tools/validate-skill.sh .highway/skills/highway-discovery
```

The skills must cite the complete shared templates and retain their behavioral contracts.

## 3. Run focused contract checks

```bash
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/highway-discovery.test.sh
```

The focused checks must independently reject missing citations, reintroduced structural
duplication, removed behavioral tokens, stale generated artifacts, and disposable-fixture residue.
They must leave canonical and user-owned bytes unchanged.

## 4. Regenerate derived adapters

```bash
.highway/tools/generate-agent-adapters.sh
```

Generated GitHub Copilot, Claude Code, and Cursor adapters must come from the two canonical skills;
do not hand-edit generated files.

## 5. Verify correspondence and packaging

```bash
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/distribution-packaging.test.sh
```

All six affected adapter forms must correspond to their canonical sources.

## 6. Run the complete validation suite

```bash
.highway/tools/tests/run-all.sh
git diff --check
```

Expected outcome: all applicable checks pass, with no changed paths under `specs/061-*` or
`specs/062-*` and no user-owned Control or Discovery artifacts modified.

## Expected completion evidence

- `highway-controls` cites `control-catalog.md` and no longer declares its complete catalog shape.
- `highway-discovery` cites both complete templates and no longer declares complete record/catalog
  shape in Inputs or Verification.
- Control versioning, allocation, transaction, readiness, and NFR proposal behavior remains.
- Discovery filtering, scoring, recommendation, traceability, determinism, no-write, and ADR
  handoff behavior remains.
- Six derived adapters are current, packaging validation passes, and the full suite is green.
