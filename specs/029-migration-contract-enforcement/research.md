# Research: Migration Contract Enforcement

## Decision: Treat `.distribution-manifest` as a canonical maintained declaration

**Decision**: Keep `.highway/tools/.distribution-manifest` as the authoritative source declaration
for distribution classifications. `generate-distribution.sh` consumes it and must not be described as
regenerating it.

**Rationale**: The existing packaging script reads the manifest and copies paths according to its
classification. There is no canonical source-to-manifest generator, and introducing one would add a
second declaration surface without being required to fix the compliance finding.

**Alternatives considered**:

- Generate the distribution manifest from a new source file: rejected for this focused follow-up
  because it duplicates the current source of truth and expands the feature beyond the finding.
- Continue describing the manifest as generated: rejected because the claim is false and cannot be
  validated by the current toolchain.

## Decision: Use a tracked empty allowlist with a separate planning boundary

**Decision**: Add `.highway/tools/.objective-rename-allowlist` as a newline-delimited policy file.
Blank and comment lines are ignored; every other line is an entry, and this feature rejects all
entries. Exclude the active Feature 029 planning directory through the audit's explicit scan boundary,
not through the allowlist.

**Rationale**: A named artifact and explicit parser make the zero-exception policy inspectable and
allow negative tests to prove that non-empty or malformed policy cannot silently widen the scan.
Separating planning scope from migration exceptions avoids conflating explanatory requirements text
with shipped compatibility.

**Alternatives considered**:

- Hard-code the scan exclusion with no policy artifact: rejected because it was the compliance gap
  identified in Feature 028.
- Allow legacy references in Feature 027: rejected because Feature 028's contract requires those
  implementation references to remain current.

## Decision: Reuse existing temporary-probe test conventions

**Decision**: Implement the focused audit and its test using the repository's existing Bash 3.2
patterns, cleanup traps, temporary directories, and actionable `FAIL:` output.

**Rationale**: Existing packaging and migration tests already prove that negative cases can be
injected and removed without leaving worktree residue. Reusing those conventions avoids new runtime
dependencies and preserves macOS compatibility.

**Alternatives considered**:

- Add a Python test dependency: rejected because the repository's authoritative validation is shell
  based and no new runtime is needed.
- Validate only the final clean tree: rejected because it would not prove stale-reference and policy
  failures are detectable.

## Decision: Correct Feature 028 documentation in place

**Decision**: Update Feature 028's plan and associated implementation record to use
`.highway/tools/tests/objective-management.test.sh` and to describe `.distribution-manifest` as a
canonical declaration rather than generated output.

**Rationale**: The correction repairs traceability and the unsupported provenance claim without
reopening Feature 028's rename implementation or deferred objective behavior.
