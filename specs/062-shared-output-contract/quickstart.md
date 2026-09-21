# Quickstart: Shared Output Contract Implementation

Run from the repository root.

## 1. Inspect the active feature artifacts

```bash
ls specs/062-shared-output-contract
```

Expected design artifacts are `spec.md`, `plan.md`, `research.md`, `data-model.md`, and
`quickstart.md`. Feature 061 must remain unchanged by Feature 062 planning.

## 2. Validate the shared template library

```bash
.highway/tools/validate-library.sh
```

This checks canonical shared-library structure and cross-references.

## 3. Run the focused output contract test

```bash
.highway/tools/tests/output-template.test.sh
```

The focused test should cover template-pair inventory, complete citations, structural authority,
behavior preservation, independent disposable invalid fixtures, generated correspondence, and
unchanged user-owned data.

## 4. Validate the migrated skills

Run the repository's existing skill validators for the five changed canonical skills. The exact
validator invocation should follow the current `.highway/tools/tests/` harness conventions so the
check remains Bash 3.2-compatible.

```bash
.highway/tools/tests/adapter-coverage.test.sh
```

## 5. Regenerate derived artifacts

```bash
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
```

Generated adapters and catalogs must come from canonical `.highway/` sources; do not hand-edit their
contents.

## 6. Verify correspondence and the full suite

```bash
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/run-all.sh

git diff --check
```

The full suite must pass. Any generated timestamp behavior must be handled by the repository's
existing deterministic comparison rules, and all user-owned baseline bytes must remain unchanged.

## Expected completion evidence

- Five retained record/catalog pairs have complete shared templates.
- All five emitting skills cite those templates and no longer restate complete structure.
- Focused disposable fixtures independently detect seeded defects.
- Generated adapters/catalogs are current and correspond to canonical sources.
- Full suite passes with `42 passed, 0 failed`, and `git diff --check` reports no whitespace errors.
