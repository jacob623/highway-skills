# Quickstart: Highway New Shared Output Contract Migration

Run from the repository root.

## 1. Inspect Feature 063 artifacts

```bash
ls specs/063-highway-new-output-contract
```

Expected design artifacts are `spec.md`, `plan.md`, `research.md`, `data-model.md`, and
`quickstart.md`. Features 061 and 062 must remain unchanged.

## 2. Validate the authoritative templates and canonical skill

```bash
.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md
.highway/tools/validate-library.sh .highway/library/templates/output/request-catalog.md
.highway/tools/validate-skill.sh .highway/skills/highway-new
```

The skill must cite both complete Request templates and retain its behavioral contract.

## 3. Run focused highway-new contract checks

Use the repository's existing focused test surface, if present, or the focused output-contract test
extended for Feature 063:

```bash
.highway/tools/tests/highway-new.test.sh
```

The focused checks must independently reject missing record citation, missing catalog citation,
duplicated structural declarations, and removed behavioral tokens. Disposable probes must leave
canonical and user-owned bytes unchanged.

## 4. Regenerate derived adapters

```bash
.highway/tools/generate-agent-adapters.sh
```

Generated adapters must come from `.highway/skills/highway-new/SKILL.md`; do not hand-edit them.

## 5. Verify adapter correspondence and packaging

```bash
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/distribution-packaging.test.sh
```

The generated GitHub Copilot, Claude Code, and Cursor forms must correspond to the canonical skill.

## 6. Run the complete validation suite

```bash
.highway/tools/tests/run-all.sh
git diff --check
```

Expected outcome: all applicable checks pass, with no changed paths under `specs/061-*` or
`specs/062-*` and no user-owned Request artifacts modified.

## Expected completion evidence

- Both Request output templates are cited as complete authoritative structures.
- Duplicated Request record/catalog structure checks are gone and template-conformance checks exist.
- Evidence, privacy, determinism, allocation, retry, transaction, status, Solution Constraints, and
  Discovery handoff behavior remains detectable.
- Derived adapters are current and packaging validation passes.
- The full suite passes and `git diff --check` reports no whitespace errors.
