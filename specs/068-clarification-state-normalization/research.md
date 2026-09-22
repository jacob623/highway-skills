# Research: Clarification State and Fingerprint Normalization

## Decision 1: Extend the existing Clarify identity contract

**Decision**: Add the Fingerprint Normalization Contract inside the existing Finding Identity Contract in `.highway/skills/highway-clarify/SKILL.md`, before fingerprint generation rules.

**Rationale**: Feature 067 already makes the Clarify skill authoritative for finding identity. Keeping normalization beside identity prevents a second source of truth and ensures every identifier-reuse path applies the same ordered transformations.

**Alternatives considered**: A separate normalization template or external helper would create another contract surface and could allow generation paths to disagree.

## Decision 2: Normalize each fingerprint input in the declared order

**Decision**: Normalize line endings to LF, trim outer whitespace, lowercase values, collapse consecutive whitespace, and canonicalize source-field identifiers before composing a fingerprint.

**Rationale**: The order is explicit, deterministic, and makes equivalent representations converge before identity comparison. Canonical source-field names prevent aliases from creating duplicate identities.

**Alternatives considered**: Normalizing only evidence, hashing raw values, or applying fuzzy matching would leave identity-sensitive differences unresolved or introduce unsupported interpretation.

## Decision 3: Keep finding state as a two-state, one-way lifecycle

**Decision**: Permit only `open` and `resolved`; new findings start open, accepted responses move findings to resolved, and resolved findings cannot reopen.

**Rationale**: Feature 067 already preserves finding identity and response history. A one-way lifecycle protects auditability while avoiding unsupported intermediate states or implicit reopening semantics.

**Alternatives considered**: Adding `dismissed`, `ignored`, or `reopened` would expand the public contract and require new status, history, and catalog semantics not requested by the feature.

## Decision 4: Validate count invariants before deriving status

**Decision**: Treat `total_findings = open_findings + resolved_findings` as a structural invariant. Reject non-negative-integer violations as malformed and derive `blocked` before any count-based status.

**Rationale**: Status precedence must not allow an inconsistent record with zero open findings to appear complete. Structural validation is the smallest deterministic rule that protects all consumers.

**Alternatives considered**: Recomputing totals silently would conceal corruption; deriving status from open count first would violate the blocked precedence contract.

## Decision 5: Version templates according to schema ownership

**Decision**: Advance the clarification catalog template to `1.1.0`, the clarification record template to `1.2.0`, and the Clarify skill to `1.4.0`.

**Rationale**: The catalog path column is a schema addition, the record gains state/count identity fields, and the skill gains normalization and lifecycle behavior. Command syntax, supported artifact types, and ownership remain unchanged.

**Alternatives considered**: Keeping template versions unchanged would hide schema changes from consumers; changing command or artifact versions would overstate the scope.

## Decision 6: Keep Clarification Path derived and informational

**Decision**: Verify that every Clarification Path resolves directly to the row's authoritative clarification artifact, while retaining the clarification artifact as the authority for content, findings, identity, history, and status.

**Rationale**: This closes the consistency gap without creating a second identity source. Catalog maintenance can validate stale, duplicate, missing, or mismatched relationships transactionally.

**Alternatives considered**: Making the path authoritative or permitting unresolved paths would allow catalog state to override or obscure the retained artifact.

## Decision 7: Apply consistency checks to bootstrap and maintenance

**Decision**: Validate one-to-one catalog relationships, artifact existence, status agreement, and direct paths for both missing-catalog bootstrap and existing-catalog maintenance before writing either artifact.

**Rationale**: First-use and subsequent updates must provide identical guarantees. Reusing the existing validation path preserves byte safety and avoids a weaker bootstrap mode.

**Alternatives considered**: Validating only existing catalogs would leave first-use output weaker; repairing stale rows automatically would conceal ownership or identity errors.

## Decision 8: Use existing static and disposable behavioral checks

**Decision**: Extend `.highway/tools/tests/highway-clarify.test.sh` and `.highway/tools/tests/output-template.test.sh` with static contract assertions and disposable fixtures/probes, then regenerate adapters and indexes serially.

**Rationale**: The repository has no runtime implementation layer for this skill suite. Existing Bash 3.2.57 tests already validate contracts, generated correspondence, and byte-preserving disposable behavior.

**Alternatives considered**: Introducing a new runtime test framework or persistent fixtures would add dependencies and conflict with the established toolchain and cleanup conventions.

## Validation baseline

- `.highway/tools/validate-skill.sh .highway/skills/highway-clarify`
- `.highway/tools/validate-library.sh .highway/library/templates/output/clarification-catalog.md`
- `.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md`
- `.highway/tools/tests/highway-clarify.test.sh`
- `.highway/tools/tests/output-template.test.sh`
- `.highway/tools/tests/adapter-coverage.test.sh`
- Serialized full suite using `perl -e '$SIG{ALRM}=sub { exit 124 }; alarm 200; exec @ARGV' .highway/tools/tests/run-all.sh`
