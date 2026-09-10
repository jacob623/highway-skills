# Implementation Plan: Migration Contract Enforcement

**Branch**: `029-migration-contract-enforcement` | **Date**: 2026-09-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/029-migration-contract-enforcement/spec.md`

## Summary

Clarify the ownership contract for `.highway/tools/.distribution-manifest`, add a machine-checked
empty migration allowlist and explicit planning-document boundary, and repair Feature 028's test-path
traceability. The implementation uses the existing Bash tooling and test harness, adds no objective
workflow behavior, and preserves Feature 028 as a separate historical record.

## Technical Context

**Language/Version**: Bash 3.2-compatible shell scripts and Markdown

**Primary Dependencies**: Existing Highway distribution library, validators, test runner, and packaging checks

**Storage**: Repository-tracked manifest, allowlist, test fixtures, and Feature 028 documentation; root-level objective data remains user-owned

**Testing**: Focused provenance/audit shell test, adapter coverage, distribution packaging, validators, full suite, and `git diff --check`

**Target Platform**: macOS and GNU/Linux development environments using the distributed Highway tree

**Project Type**: Repository governance and distribution tooling

**Performance Goals**: Focused audit and full suite remain within the existing shell-test execution envelope

**Constraints**: The allowlist has zero entries; Feature 029 planning documents are excluded by explicit scan scope, not by allowlist; no root-level objective files may be created or modified; Bash 3.2 compatibility is required

**Scale/Scope**: One manifest ownership contract, one empty allowlist, one focused audit, Feature 028 path correction, and corresponding validation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Verdict | Evidence |
|---|---|---|
| Layer separation and shippability | PASS | The allowlist and audit are development tooling; `.distribution-manifest` remains the canonical declaration consumed by packaging. |
| Toolchain discipline | PASS | Uses existing Bash 3.2-compatible scripts and no new runtime dependency. |
| Verification before and after | PASS | Positive and negative audit cases, packaging, correspondence, validators, and full-suite checks are required. |
| Generated artifact integrity | PASS | The plan does not misclassify `.distribution-manifest` as generated; generated catalogs/adapters remain governed by existing generators. |
| Specification record integrity | PASS | Feature 029 is sequential and Feature 028 remains a separate record. |
| Documentation currency | PASS | Feature 028's incorrect test path and unsupported manifest-generation claim are corrected explicitly. |

## Project Structure

### Documentation (this feature)

```text
specs/029-migration-contract-enforcement/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/tools/.distribution-manifest
.highway/tools/.objective-rename-allowlist
.highway/tools/audit-objective-rename.sh
.highway/tools/tests/objective-rename-contract.test.sh
.highway/tools/tests/fixtures/objective-rename/
specs/028-objectives-rename-cleanup/plan.md
specs/028-objectives-rename-cleanup/spec.md
specs/029-migration-contract-enforcement/
```

**Structure Decision**: Keep the existing shell-tool and specification layout. The canonical
distribution manifest remains hand-maintained; the new audit script validates its provenance,
checks the empty allowlist and planning boundary, and exercises temporary negative cases through
the existing test harness. Feature 028 documentation receives only the required path/provenance
corrections.

## Implementation Sequence

1. Record the current distribution-manifest ownership, Feature 028 path mismatch, and root-level
  objective-data state without modifying user-owned files.
2. Add the empty `.objective-rename-allowlist` and document its newline-delimited format plus the
  separate Feature 029 planning-document boundary.
3. Add the focused provenance and migration audit with clean, stale-reference, malformed,
  duplicate, prohibited-path, and cleanup checks.
4. Correct Feature 028's `objectives-management.test.sh` reference and remove its unsupported
  claim that the distribution manifest is regenerated.
5. Run focused checks, existing correspondence/packaging checks, validators, the full suite, and
  user-data/diff verification.

## Phase 0: Research Summary

- `.highway/tools/.distribution-manifest` is consumed by `generate-distribution.sh` and is not
  written by that script; it is therefore treated as a canonical maintained declaration.
- Existing tests use temporary probes and cleanup traps, so the migration audit will follow the
  same pattern for negative cases and must leave the worktree unchanged.
- Feature 028's active planning directory is explanatory scope, not an allowlist entry; the audit
  will scan all other repository surfaces for exact legacy tokens and stale paths.
- Feature 028's actual test path is `.highway/tools/tests/objective-management.test.sh`.

## Phase 1: Design Decisions

### Distribution Manifest Ownership

The `.distribution-manifest` remains the canonical source declaration. Packaging consumes it, while
the provenance test verifies that documentation does not describe it as generated. Existing
catalogs and agent adapters continue to use their established generators and manifests.

### Allowlist and Scan Boundary

`.highway/tools/.objective-rename-allowlist` is a newline-delimited file. Blank lines and comments
are ignored; any remaining line is an entry and must fail this feature because the allowed set is
empty. The audit excludes only `specs/029-migration-contract-enforcement/` from explanatory-token
scanning, and that exclusion is code/configuration, not an allowlist entry.

### Negative-Test Isolation

The focused test copies or temporarily probes only disposable paths, asserts failure and actionable
output, and removes every probe with a cleanup trap. Existing root-level objective paths are
snapshotted and never created by the test.

## Constitution Re-check

| Gate | Verdict | Evidence |
|---|---|---|
| Layer separation and shippability | PASS | Development-only audit artifacts stay outside the shipped distribution; the canonical manifest remains the packaging input. |
| Toolchain discipline | PASS | No dependency or non-portable shell feature is introduced. |
| Verification before and after | PASS | The design includes clean and negative audit scenarios plus existing repository checks. |
| Generated artifact integrity | PASS | Only artifacts with existing generators are regenerated; the distribution manifest is explicitly not one of them. |
| Specification record integrity | PASS | Feature 028 is corrected in place only for traceability/provenance and remains separate. |
| Documentation currency | PASS | Ownership and path references are aligned across Feature 028 and Feature 029. |

## Complexity Tracking

No constitution violations or new abstractions are required. The feature adds one focused audit
around an existing canonical manifest and one empty policy file, using the repository's established
shell-test conventions.
