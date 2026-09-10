# Contract: Migration Contract Enforcement

## Distribution Manifest Provenance

The distribution manifest is a canonical maintained declaration.

| Surface | Required behavior |
|---|---|
| `.highway/tools/.distribution-manifest` | Stores the authoritative include/exclude classifications. |
| `generate-distribution.sh` | Reads the manifest; does not generate or rewrite it. |
| Feature 028 documentation | Describes the manifest as canonical input, not generated output. |
| Provenance check | Fails when these surfaces contradict one another. |

Generated catalogs and agent adapters remain governed by their existing generators and manifests;
this contract does not relabel those artifacts.

## Allowlist Format and Policy

The canonical allowlist is `.highway/tools/.objective-rename-allowlist`.

- Each nonblank, non-comment line is one repository-relative path entry.
- A comment begins with `#` after optional leading whitespace.
- Duplicate entries are invalid.
- Absolute paths, parent traversal, malformed paths, and prohibited path classes are invalid.
- Feature 029 permits zero entries, so any valid entry is also a policy failure.
- The active planning directory `specs/029-migration-contract-enforcement/` is an explicit scan
  boundary and is not represented as an allowlist entry.

## Migration Audit Contract

The audit MUST:

1. Fail if the allowlist is missing or malformed.
2. Fail if the allowlist contains any entry, duplicate, or prohibited path.
3. Scan all repository surfaces outside the planning boundary for the exact singular token and stale
   singular paths.
4. Report every offending path in deterministic order.
5. Snapshot root-level `library/objectives/` and `library/governance/objectives.md` before checks and
   verify bytes/existence after checks.
6. Use temporary probes for negative cases and remove them on success, failure, or interruption.
7. Exit zero only when provenance, allowlist, stale-reference, user-data, and cleanup checks pass.

## Traceability Contract

Feature 028 must reference `.highway/tools/tests/objective-management.test.sh` exactly. The old
`objectives-management.test.sh` spelling is invalid. Feature 028 remains a separate record and no
objective workflow or deterministic-output behavior is changed by this correction.
