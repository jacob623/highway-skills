# Research: Feature Completeness and Behavioral Evidence Enforcement

## Decision 1: Use the existing completion-coverage grammar

**Decision**: Add one `coverage.md` record to each historical feature, with exactly one row per functional requirement and an outcome of `satisfied` or `deferred`.

**Rationale**: The repository already has a mechanical D7.2 check and established coverage records. Reusing that grammar fixes the missing accountability evidence without inventing a second reporting format. Coverage rows will identify whether evidence is executable, structural, documentation-only, or deferred.

**Alternatives considered**:

- Treat checked tasks as sufficient evidence: rejected because task completion and requirement coverage are separate claims under D7.1-D7.3.
- Add a new repository-wide coverage registry: rejected because it duplicates the existing per-feature authority and would increase drift risk.

## Decision 2: Extend the existing Bash fixture harness for behavioral evidence

**Decision**: Implement focused behavioral validation in the existing Feature 030 and 031 test scripts using disposable repository trees and the declared Bash-compatible utility set.

**Rationale**: The project is distributed as a shell-and-Markdown skill suite, already has fixture-driven tests, and cannot assume a runtime package or interpreter beyond the declared toolchain. This keeps validation runnable in both development and packaged-tree contexts.

**Alternatives considered**:

- Keep phrase and fixture assertions only: rejected because they cannot observe writes, review decisions, graph parsing, or rollback.
- Introduce a new language runtime: rejected because it violates the no-new-dependency constraint and is unnecessary for the record formats and workflows in scope.

## Decision 3: Define atomicity by complete byte preservation on injected failure

**Decision**: Snapshot every affected record and catalog before an approved operation, inject failures at validation, allocation/staging, and commit points, and require exact byte restoration.

**Rationale**: The user-facing guarantee is no partial write. Byte comparison is directly observable, deterministic, and stronger than checking only relationship membership. It also catches accidental catalog or formatting changes.

**Alternatives considered**:

- Assert only that the final graph is reciprocal: rejected because unrelated content or catalogs could still have been changed.
- Rely on prose saying writes are staged: rejected because staging semantics are not evidence of rollback behavior.

## Decision 4: Canonicalize duplicate relationship membership

**Decision**: Treat repeated occurrences of the same immutable identifier in one relationship field as a duplicate finding. An approved repair retains one occurrence, preserves identifier membership, and changes no non-relationship field.

**Rationale**: Relationship fields represent set membership, while duplicate entries add no governance meaning. One canonical occurrence produces deterministic output and avoids inventing intent.

**Alternatives considered**:

- Treat duplicates as valid: rejected because repeated values undermine deterministic graph interpretation.
- Remove all occurrences: rejected because that would discard a valid relationship rather than normalize representation.

## Decision 5: Make baseline-replacement impact input explicit

**Decision**: Impact analysis compares the current baseline with an explicit proposed artifact set. It reports removed Controls and NFRs and every relationship edge that would be lost, once per immutable source/target pair, including titles.

**Rationale**: A replacement cannot be analyzed from a vague operation label. An explicit proposed set makes the comparison deterministic and allows tests to prove that every affected artifact is listed before confirmation.

**Alternatives considered**:

- Report only counts: rejected because counts do not identify what will be lost.
- Infer the replacement from a future catalog: rejected because it makes impact dependent on unrelated generated ordering and hides the user's proposed state.

## Decision 6: Keep lifecycle status honest during remediation

**Decision**: Features 030 and 031 remain Draft while behavioral evidence is absent; status may move to the repository's completed convention only after coverage records and executable evidence are complete.

**Rationale**: Status must agree with evidence. This avoids converting a structural pass into a claim of behavioral completion.

**Alternatives considered**:

- Mark both features complete immediately because all tasks are checked: rejected because the assessment identified unverified behavior and missing D7.2 coverage.
- Leave status unspecified: rejected because ambiguity is the finding being remediated.
