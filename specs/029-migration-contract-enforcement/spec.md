# Feature Specification: Migration Contract Enforcement

**Feature Branch**: `029-migration-contract-enforcement`

**Created**: 2026-09-09

**Status**: Draft

**Input**: User description: "Create a follow-up specification for the Feature 028 compliance findings: clarify distribution-manifest provenance, implement and test the empty migration allowlist, and correct the Feature 028 test-path reference."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Make distribution metadata provenance explicit (Priority: P1)

As a Highway maintainer, I want the distribution manifest's ownership and regeneration contract to be explicit and verifiable so that packaging metadata cannot be described as generated when it is actually maintained as a source declaration.

**Why this priority**: Ambiguous ownership creates false compliance claims and can allow source, packaging metadata, and validation expectations to drift apart.

**Independent Test**: Inspect the distribution metadata contract and run its focused correspondence test; the test must identify the authoritative declaration, the permitted update mechanism, and any stale or contradictory generated-artifact claim without changing unrelated distribution paths.

**Acceptance Scenarios**:

1. **Given** the current distribution manifest and packaging generator, **When** the contract is reviewed, **Then** exactly one ownership model is documented: either the manifest is generated from a canonical source or it is the canonical hand-maintained declaration.
2. **Given** the chosen ownership model, **When** the focused distribution correspondence check runs, **Then** it verifies that the manifest, packaging behavior, and documentation agree and reports the affected path when they do not.
3. **Given** Feature 028's rename requirements, **When** the corrected contract is applied, **Then** its manifest-related requirement and implementation record no longer claim an unsupported generation step.

### User Story 2 - Enforce an empty migration allowlist (Priority: P1)

As a Highway reviewer, I want the migration allowlist to be an explicit, machine-checked empty set so that no stale singular objective reference can be hidden as an undocumented exception.

**Why this priority**: Feature 028's zero-reference promise depends on distinguishing intentional scan scope from silently ignored legacy references.

**Independent Test**: Run the focused migration audit against the repository, then inject one temporary allowlist entry and one temporary stale reference; the audit must fail with actionable paths before cleanup restores the unchanged repository.

**Acceptance Scenarios**:

1. **Given** the Feature 028 migration contract, **When** `.highway/tools/.objective-rename-allowlist` is inspected, **Then** it exists as a newline-delimited file with zero non-comment entries for active, shipped, generated, test, manifest, and live documentation paths, and declares the scan boundary for the active Feature 029 planning directory separately from the allowlist.
2. **Given** a stale singular token or old adapter/source/manifest path outside the declared planning-document boundary, **When** the migration audit runs, **Then** it fails and names the offending path.
3. **Given** a non-empty allowlist entry is introduced temporarily, **When** the migration audit runs, **Then** it fails because this feature permits no shipped, active, generated, test, manifest, or live-documentation exception.
4. **Given** the repository starts with no root-level user-owned objective records or catalog, **When** the audit and packaging checks run, **Then** those paths remain absent and the audit leaves no probe files behind.

### User Story 3 - Restore Feature 028 traceability (Priority: P2)

As a maintainer reading the Feature 028 design record, I want every named test path to resolve to a real repository file so that the plan, tasks, and validation evidence can be followed without guesswork.

**Why this priority**: Incorrect paths weaken future maintenance and make completed-task claims difficult to verify.

**Independent Test**: Resolve every repository-relative path named by Feature 028's plan and task record; the path audit must report no missing test or fixture path and must preserve Feature 028's separate record.

**Acceptance Scenarios**:

1. **Given** Feature 028's plan names the objective-management test, **When** the traceability audit runs, **Then** it resolves to `.highway/tools/tests/objective-management.test.sh` exactly.
2. **Given** Feature 028's task and validation records are otherwise complete, **When** the correction is applied, **Then** no unrelated Feature 024-026 or objective behavior changes are introduced.

### Edge Cases

- A manifest is both described as generated and edited as a source declaration; the contract check must reject the contradiction.
- The allowlist file is absent, malformed, duplicated, or contains a path under a shipped or active directory; the audit must fail rather than silently widen scan scope.
- A stale reference appears in a generated artifact, adapter manifest, distribution manifest, fixture, or live documentation file; the audit must report its exact path.
- The current feature's planning documents need to describe legacy tokens; those documents are excluded by an explicit planning-scope boundary, not by an allowlist entry.
- Feature 027's directory name remains historical and separate; its implementation references must remain traceable without being merged into Feature 029.
- Root-level `library/objectives/` or `library/governance/objectives.md` exists before validation; its bytes must remain unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST define one authoritative ownership model for `.highway/tools/.distribution-manifest` and document whether it is generated output or a canonical maintained declaration.
- **FR-002**: The system MUST provide a focused correspondence check that verifies the distribution manifest, packaging generator behavior, and Feature 028 documentation agree with the ownership model.
- **FR-003**: The system MUST provide `.highway/tools/.objective-rename-allowlist` as a newline-delimited, machine-readable migration allowlist whose active, shipped, generated, test, manifest, and live-documentation entry set is empty; blank lines and comment lines are permitted but do not constitute entries.
- **FR-004**: The system MUST define the planning-document scan boundary separately from the migration allowlist so excluding the active feature record cannot hide a shipped or active exception.
- **FR-005**: The system MUST fail the migration audit when any exact singular objective token or singular source, adapter, catalog, manifest, fixture, test, or documentation path appears outside the declared planning-document boundary.
- **FR-006**: The system MUST fail the migration audit when `.highway/tools/.objective-rename-allowlist` is missing, malformed, non-empty, duplicated, or contains an entry in a prohibited path class.
- **FR-007**: The system MUST test both positive clean-migration behavior and negative stale-reference and non-empty-allowlist cases without leaving probes in the working tree.
- **FR-008**: The system MUST correct Feature 028's `objectives-management.test.sh` reference to the actual `.highway/tools/tests/objective-management.test.sh` path in its plan or associated implementation record.
- **FR-009**: The system MUST preserve Feature 028 as a separate specification and MUST NOT implement deferred objective workflow behavior or deterministic-output improvements.
- **FR-010**: The system MUST preserve root-level user-owned objective records and catalogs byte-for-byte, or preserve their absent state, during all focused audits and packaging checks.
- **FR-011**: The system MUST pass the focused provenance and migration-audit checks, existing adapter and packaging checks, and the full repository test suite.

### Key Entities

- **Distribution Manifest Ownership Model**: The single documented rule identifying whether distribution classifications are canonical source declarations or generated outputs.
- **Migration Allowlist**: `.highway/tools/.objective-rename-allowlist`, a newline-delimited machine-readable set of permitted legacy references; for this feature its prohibited-scope entry set is empty.
- **Planning-Document Boundary**: The explicit set of current feature documentation paths excluded from the active-tree explanatory scan without becoming migration exceptions.
- **Migration Audit**: A repeatable check covering exact tokens, stale paths, allowlist validity, user-data preservation, and cleanup of temporary probes.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The distribution provenance check reports one consistent ownership model and zero contradictions across the manifest, packaging generator, Feature 028 plan, and related documentation.
- **SC-002**: The migration audit reports zero prohibited allowlist entries and rejects 100% of injected non-empty, malformed, duplicate, or prohibited-path allowlist cases.
- **SC-003**: A clean repository audit reports zero exact singular objective tokens and zero singular source, adapter, catalog, manifest, fixture, test, or live-documentation paths outside the explicit planning-document boundary.
- **SC-004**: Every Feature 028 plan and task path referenced by the audit resolves successfully, including the objective-management test path.
- **SC-005**: Existing adapter, packaging, validator, and full-suite checks pass with 0 failures after the contract correction.
- **SC-006**: Root-level user-owned objective files remain byte-identical, or remain absent, in 100% of focused audit and packaging runs.
- **SC-007**: Temporary negative-test probes are removed after every audit run, leaving no migration-specific files in the working tree.

## Assumptions

- `.highway/tools/.distribution-manifest` will use the existing repository convention that a manifest may be a canonical maintained declaration; this feature will remove any claim that the packaging generator regenerates it unless a separate generator is explicitly introduced.
- `.highway/tools/.objective-rename-allowlist` is the canonical allowlist location; its format is newline-delimited relative paths with optional blank/comment lines, and its prohibited path classes and planning-document boundary must be explicit and validated.
- The active Feature 029 planning directory is allowed to describe the superseded identity for requirements traceability, but that explanatory scope is not an allowlist exception for shipped or active repository content.
- Feature 028 remains the historical rename record; Feature 029 corrects its compliance contract and traceability without reimplementing Feature 028's rename.
- Existing validators, adapter checks, packaging checks, and full-suite tests remain the baseline validation surface.
- No root-level user-owned objective record or catalog will be created by this feature.
