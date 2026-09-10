# Quickstart: Migration Contract Enforcement

## Prerequisites

- macOS or GNU/Linux checkout at the repository root.
- Existing Highway tools under `.highway/tools/`.
- Feature 028 artifacts present and Feature 029 active in `.specify/feature.json`.
- Root-level objective paths may be absent or may contain user-owned files; do not create them.

## Inspect the Provenance Contract

```sh
sed -n '1,80p' .highway/tools/.distribution-manifest
sed -n '1,220p' .highway/tools/generate-distribution.sh
rg -n 'distribution-manifest|generated|canonical' specs/028-objectives-rename-cleanup .highway/tools
```

Expected result: `.distribution-manifest` is documented as canonical packaging input, and
`generate-distribution.sh` only reads it.

## Run the Focused Audit

```sh
/bin/bash .highway/tools/tests/objective-rename-contract.test.sh
```

Expected result: provenance, empty-allowlist, planning-boundary, stale-reference, traceability,
user-data, and probe-cleanup checks pass.

## Run the Existing Validation Surface

```sh
/bin/bash .highway/tools/tests/adapter-coverage.test.sh
/bin/bash .highway/tools/tests/distribution-packaging.test.sh
/bin/bash .highway/tools/validate-skill.sh .highway/skills/highway-objectives
/bin/bash .highway/tools/validate-library.sh .highway/library/templates/output/objective-record.md
/bin/bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: every command exits 0.

## Negative Audit Scenarios

The focused test must inject and remove disposable probes for each case:

- Add a non-comment line to `.highway/tools/.objective-rename-allowlist`; the audit fails and
  identifies the policy violation.
- Add a stale singular token or old path outside `specs/029-migration-contract-enforcement/`; the
  audit fails and reports the exact file.
- Replace the allowlist with duplicate, malformed, absolute, parent-traversal, or prohibited-path
  entries; the audit fails before cleanup restores the original file.
- Add a temporary stale `objectives-management.test.sh` reference to Feature 028 documentation; the
  traceability check fails and names the incorrect path.

After every scenario, verify the allowlist, Feature 028 files, root-level user-owned objective
paths, and working tree are restored byte-for-byte or remain absent.
