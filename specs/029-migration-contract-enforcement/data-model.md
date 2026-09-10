# Data Model: Migration Contract Enforcement

## Distribution Manifest Ownership Model

- **Path**: `.highway/tools/.distribution-manifest`
- **Role**: Canonical, maintained classification of repository paths for packaging.
- **Consumers**: `generate-distribution.sh`, distribution library helpers, adapter coverage, and packaging tests.
- **Invariant**: Documentation and tests must not claim that the packaging generator writes or regenerates this file.

## Empty Migration Allowlist

- **Path**: `.highway/tools/.objective-rename-allowlist`
- **Format**: UTF-8 newline-delimited relative paths with optional blank lines and comment lines beginning with `#`.
- **Allowed entries for Feature 029**: None.
- **Validation**: Missing, malformed, duplicate, prohibited-path, or non-comment entries fail the audit.
- **Ownership**: Framework-owned development policy; it is excluded from the shipped distribution.

## Planning-Document Boundary

- **Path**: `specs/029-migration-contract-enforcement/`
- **Role**: Explicit explanatory scan boundary for the active specification's legacy-token descriptions.
- **Relationship to allowlist**: This is scan configuration, not an allowed legacy reference and not a migration exception.
- **Invariant**: No shipped, active, generated, test, manifest, fixture, or live-documentation path may be added to this boundary.

## Migration Audit

- **Path**: `.highway/tools/audit-objective-rename.sh`
- **Inputs**: Canonical source tree, generated surfaces, manifests, allowlist, planning boundary, and user-data baseline.
- **Outputs**: Exit 0 for a clean migration; actionable `FAIL:` output and nonzero exit for each injected violation.
- **Checks**:
  - exact singular token absence outside planning scope;
  - singular source, adapter, catalog, manifest, fixture, test, and documentation path absence;
  - allowlist existence, syntax, uniqueness, and zero-entry policy;
  - user-owned objective path existence and byte preservation;
  - cleanup of temporary negative-test probes.

## Traceability Correction

- **Canonical Feature 028 test**: `.highway/tools/tests/objective-management.test.sh`
- **Incorrect historical reference**: `objectives-management.test.sh`
- **Invariant**: Feature 028's plan and implementation record reference the canonical test path and preserve Feature 028 as a separate directory.
