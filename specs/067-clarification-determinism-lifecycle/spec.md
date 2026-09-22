# Feature Specification: Clarification Determinism and Lifecycle Contracts

**Feature Branch**: `067-clarification-determinism-lifecycle`

**Created**: 2026-09-22

**Status**: Draft

**Input**: User description: "Update highway-clarify and clarification-catalog to close the remaining determinism and lifecycle gaps."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Classify Ambiguity and Contradictions Deterministically (Priority: P1)

As a repository maintainer, I want ambiguity and contradiction findings to be based only on explicit contracts so that repeated clarification analysis produces explainable, reproducible results.

**Why this priority**: Ambiguous vocabulary and contradiction inference directly affect findings. Without explicit boundaries, identical artifacts can produce different results or findings that cannot be justified from repository data.

**Independent Test**: Analyze clarification inputs containing default ambiguity terms, profile-added terms, partial-word variants, and candidate contradiction cases. Confirm exact case-insensitive phrase matching and rule-only contradiction detection, with no findings from unsupported inference mechanisms.

**Acceptance Scenarios**:

1. **Given** a source value contains a default ambiguity term with different casing or surrounding whitespace, **When** clarification analysis runs, **Then** exactly one ambiguity finding is produced for the normalized phrase.
2. **Given** a source value contains a partial word, regular-expression pattern, semantically similar phrase, or a term removed from the default vocabulary, **When** clarification analysis runs, **Then** no ambiguity finding is produced from that value.
3. **Given** a Clarification Profile adds vocabulary terms, **When** analysis runs, **Then** the added terms extend the default vocabulary without removing or redefining any default term.
4. **Given** two referenced fields satisfy an explicitly declared contradiction rule, **When** analysis runs, **Then** one contradiction finding is produced from that rule.
5. **Given** no declared contradiction rule applies, **When** analysis runs, **Then** no contradiction finding is produced, regardless of general knowledge, semantic similarity, probability, architectural recommendation, or model judgment.

### User Story 2 - Preserve Finding Identity and Unambiguous Status (Priority: P1)

As a repository maintainer, I want clarification finding identifiers and record statuses to remain stable across revisions so that downstream references and catalog entries do not change merely because findings were reordered or removed.

**Why this priority**: Stable finding identity and an explicit status precedence are necessary for reliable lifecycle management, auditability, and deterministic catalog synchronization.

**Independent Test**: Analyze identical input repeatedly, reorder findings, remove an earlier finding, introduce a new finding, and evaluate absent, malformed, complete, and open records. Confirm identifier reuse, retired-identifier protection, and exactly one status selected by the declared precedence.

**Acceptance Scenarios**:

1. **Given** a finding fingerprint is unchanged between two analyses, **When** the clarification is regenerated, **Then** its existing `CLAR-<ARTIFACT-ID>-NNN` identifier is reused.
2. **Given** findings are reordered, **When** the clarification is regenerated, **Then** identifiers remain attached to their fingerprints rather than to their display positions.
3. **Given** finding `001` is removed while finding `002` remains, **When** the clarification is regenerated, **Then** finding `002` remains `002` and `001` is not reused for a later finding.
4. **Given** identical inputs are analyzed repeatedly, **When** findings are generated, **Then** the finding identifiers are identical across runs.
5. **Given** a clarification artifact is malformed or violates required structure, **When** status is derived, **Then** status is `blocked` even if other fields would otherwise indicate completion or progress.
6. **Given** a valid clarification has zero open findings, **When** status is derived, **Then** status is `complete`.
7. **Given** a valid clarification has one or more open findings, **When** status is derived, **Then** status is `in-progress`.
8. **Given** no clarification artifact exists, **When** status is derived, **Then** status is `not-started`.
9. **Given** any record state could satisfy more than one status condition, **When** status is derived, **Then** the precedence order `blocked`, `complete`, `in-progress`, `not-started` selects exactly one status.

### User Story 3 - Bootstrap and Maintain the Clarification Catalog Safely (Priority: P1)

As a repository maintainer, I want catalog creation and updates to use the authoritative template and preserve the same validation guarantees as existing catalogs so that the first clarification is handled exactly like later lifecycle operations.

**Why this priority**: A missing catalog is a normal first-use state. Treating bootstrap as a special, weaker path leaves the first catalog vulnerable to structural and determinism defects.

**Independent Test**: Start with a valid clarification and no catalog, construct the catalog from the authoritative template, validate it, write it only after all validations succeed, and verify the optional informational path column and byte-preserving failure behavior.

**Acceptance Scenarios**:

1. **Given** a valid clarification exists and the catalog is absent, **When** clarification generation succeeds, **Then** an in-memory catalog is constructed from the authoritative catalog template, validated using the existing-catalog rules, and written only after clarification and catalog validation succeed.
2. **Given** the bootstrap catalog would fail the same structural or reference checks applied to an existing catalog, **When** generation runs, **Then** the operation aborts without writing the catalog or clarification artifact.
3. **Given** an existing catalog is malformed or a catalog write fails, **When** maintenance runs, **Then** all pre-operation catalog and clarification bytes remain unchanged.
4. **Given** a valid catalog entry is rendered, **When** the catalog is generated, **Then** it includes the informational Clarification Path resolving directly to the authoritative clarification artifact.
5. **Given** catalog maintenance succeeds repeatedly with identical inputs, **When** output is compared, **Then** catalog bytes, ordering, paths, statuses, and identifiers are identical.

## Edge Cases

- An ambiguity term appears with leading or trailing whitespace, mixed casing, punctuation adjacency, or as part of a larger word.
- A profile extension repeats a default term, attempts to remove one, or supplies an empty phrase.
- A contradiction rule references a missing field, a field outside its declared artifact type scope, or a false condition.
- Multiple contradiction rules match the same pair of fields.
- A finding is reordered, removed, reintroduced, or replaced by a new fingerprint after its identifier has retired.
- A malformed clarification record also has `open_findings: 0`; it must remain `blocked`.
- A clarification artifact is absent, while a catalog is also absent or contains stale rows.
- A bootstrap catalog is constructed from a template with an invalid row, unsupported status, duplicate mapping, or missing clarification reference.
- The optional Clarification Path contains a path that does not resolve directly to the authoritative artifact.
- A failed clarification write occurs before a catalog write, or a failed catalog write occurs after clarification validation.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `highway-clarify` contract MUST define an authoritative Ambiguity Vocabulary Contract immediately after `Inputs`.
- **FR-002**: The default ambiguity vocabulary MUST contain exactly these default terms: `TBD`, `TBA`, `unknown`, `undecided`, `unspecified`, `not defined`, `not determined`, `pending`, `future decision`, and `future work`.
- **FR-003**: Ambiguity matching MUST be case-insensitive, use exact normalized phrase comparison, ignore leading and trailing whitespace, and reject partial-word matching, regular expressions, and semantic similarity.
- **FR-004**: Clarification Profile extensions MUST append terms without removing or redefining default terms and MUST preserve the same matching behavior.
- **FR-005**: Each match against an ambiguity term MUST produce one ambiguity finding.
- **FR-006**: The `highway-clarify` contract MUST define a Contradiction Rule Contract immediately after the Ambiguity Vocabulary Contract.
- **FR-007**: A contradiction rule MUST define a Rule Identifier, Artifact Type Scope, Source Field A, Source Field B, Contradiction Condition, and Finding Summary Template.
- **FR-008**: A contradiction finding MUST be generated only when both referenced fields exist and the declared contradiction condition evaluates true.
- **FR-009**: Contradiction detection MUST NOT use general knowledge, architectural recommendations, semantic inference, probability, similarity scoring, or model judgment.
- **FR-010**: The `highway-clarify` contract MUST define a Finding Identity Contract before `Workflow`.
- **FR-011**: Finding identifiers MUST use the format `CLAR-<ARTIFACT-ID>-NNN` and MUST be based on deterministic fingerprints composed of category, source field or section, and evidence reference.
- **FR-012**: Unchanged finding fingerprints MUST reuse their prior identifiers; reordering MUST preserve identifiers; new fingerprints MUST receive the next unused sequence number; retired identifiers MUST never be reused.
- **FR-013**: The status derivation contract MUST use the precedence order `blocked`, `complete`, `in-progress`, `not-started`, selecting exactly one status.
- **FR-014**: `blocked` MUST apply to existing malformed or structurally invalid clarification artifacts, `complete` to valid records with zero open findings, `in-progress` to valid records with open findings, and `not-started` only when the clarification artifact does not exist.
- **FR-015**: Clarification catalog bootstrap MUST construct an in-memory catalog from the authoritative clarification-catalog template when no catalog exists.
- **FR-016**: A bootstrap catalog MUST be validated exactly as an existing catalog before any catalog write occurs.
- **FR-017**: The catalog MUST be written only after clarification validation and catalog validation succeed; failed validation or writes MUST preserve all pre-operation bytes.
- **FR-018**: The clarification catalog template MUST add a `Clarification Path` column and document that the path resolves directly to the authoritative clarification artifact.
- **FR-019**: The clarification catalog MUST retain supported artifact types `REQ`, `DISC`, `ADR`, and `RA`, supported statuses, one-row-per-clarification identity, deterministic ordering, and existing ownership boundaries.
- **FR-020**: The `highway-clarify` Verification section MUST include checks for exact ambiguity matching, prohibited matching methods, profile extension behavior, rule-only contradiction findings, stable finding identity, retired identifiers, status precedence, bootstrap validation, and byte preservation.
- **FR-021**: The `highway-clarify` workflow wording MUST state that only declared contradiction rules are used for contradiction findings.
- **FR-022**: The shared clarification-catalog metadata version MUST remain `1.0.0`, while the `highway-clarify` skill metadata version MUST advance from `1.2.0` to `1.3.0`.
- **FR-023**: The feature MUST NOT change command syntax, artifact ownership, supported artifact types, Discovery behavior, ADR behavior, clarification analysis ordering, findings outside the declared identity rules, or scoring.

### Key Entities *(include if feature involves data)*

- **Ambiguity Vocabulary**: The authoritative default phrases plus append-only Clarification Profile extensions used for exact matching.
- **Contradiction Rule**: A declared rule identifying an artifact scope, two source fields, a condition, and a finding summary template.
- **Finding Fingerprint**: The deterministic identity inputs consisting of category, source field or section, and evidence reference.
- **Clarification Finding**: A categorized, evidence-backed ambiguity or contradiction result with a stable sequence identifier.
- **Clarification Status**: One lifecycle state selected by the declared precedence rules.
- **Clarification Catalog**: The repository index of clarification identity, source artifact, type, status, and informational path.
- **Clarification Path**: The informational catalog value resolving to the authoritative clarification artifact.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Repeated analysis of identical clarification inputs produces byte-identical finding identifiers and findings, with zero identifiers changed by ordering alone.
- **SC-002**: All ten default ambiguity terms match case-insensitively after trimming, while partial-word, regular-expression, and semantic-similarity cases produce zero ambiguity findings.
- **SC-003**: Every contradiction finding in verification scenarios can be traced to one declared rule with both source fields present and a true declared condition; unsupported inference produces zero contradiction findings.
- **SC-004**: Across lifecycle scenarios, exactly one status is selected and the declared precedence correctly classifies malformed, complete, in-progress, and absent artifacts in 100% of cases.
- **SC-005**: Removing an earlier finding preserves every later finding identifier, and no retired identifier is allocated again in 100% of identity lifecycle tests.
- **SC-006**: A missing catalog is bootstrapped from the authoritative template and passes the same validation suite as an existing catalog in 100% of valid bootstrap cases.
- **SC-007**: Malformed bootstrap catalogs, existing catalogs, clarification failures, and catalog write failures preserve every affected pre-operation byte in 100% of failure-path tests.
- **SC-008**: Every generated catalog row includes a directly resolvable Clarification Path, and identical valid inputs produce byte-identical catalog output including paths and ordering.
- **SC-009**: The `highway-clarify` skill metadata reports version `1.3.0`; command syntax, ownership, supported artifact types, Discovery behavior, analysis ordering, and scoring remain unchanged.

## Assumptions

- Feature 066 remains the baseline contract for clarification catalog identity, supported artifact types, supported statuses, catalog location, and transaction behavior unless this specification explicitly changes a point.
- A Clarification Profile is an existing or future profile input owned by the clarification workflow; this feature defines only its append-only vocabulary extension behavior.
- Contradiction rules are supplied as explicit declared structures; this feature does not define a new rule authoring interface.
- Prior finding fingerprints and identifiers are available to the clarification update workflow when preserving identity across revisions.
- The authoritative clarification-catalog template remains under `.highway/library/templates/output/clarification-catalog.md` and the maintained catalog remains at `clarifications/clarifications.md`.
- The optional Clarification Path is informational and does not replace the authoritative clarification artifact.
- No command syntax, external dependency, new storage system, or Discovery integration is required.
- Feature numbering is explicitly `067` for this request.
