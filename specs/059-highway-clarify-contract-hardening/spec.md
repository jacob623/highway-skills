# Feature Specification: Highway Clarify Contract Hardening

**Feature Branch**: `059-highway-clarify-contract-hardening`

**Created**: 2026-09-21

**Status**: Draft

**Input**: User description: "Apply contract, determinism, privacy, profile-discovery, regeneration, and template-authority updates to the highway-clarify skill and clarification-record template."

## Clarifications

### Session 2026-09-21

- Q: Which clarification record content must be privacy-filtered before it is retained? → A: Redact sensitive values everywhere in retained clarification content, including findings, responses, history, metadata, and copied evidence.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Consume stable clarification metadata and responses (Priority: P1)

A repository user can invoke `highway-clarify` through precise command forms and rely on stable clarification artifact identifiers, consumer fields, statuses, revisions, and conflict responses.

**Why this priority**: Stable contracts are the foundation for every caller and prevent downstream workflows from breaking as clarification records evolve.

**Independent Test**: Validate skill metadata, command usage, deterministic `CLAR-<ARTIFACT-ID>` identifiers, stable consumer fields, status derivation, revision rules, and conflict response fields across Generate, Update, Inspect, Read, Status, absent, and blocked cases.

**Acceptance Scenarios**:

1. **Given** a supported source artifact, **when** a clarification record is generated, **then** its identifier is exactly `CLAR-<ARTIFACT-ID>` and remains stable for repeated processing of that source.
2. **Given** any supported command response, **when** a consumer reads the response, **then** `artifact_id`, `exists`, `status`, `open_findings`, `resolved_findings`, `total_findings`, `path`, and `blocking_reason` remain present with unchanged names and data types.
3. **Given** a malformed or absent clarification artifact, **when** Status or Inspect runs, **then** it returns `blocked` or `not-started` using the documented deterministic status rules.
4. **Given** an update revision conflict, **when** the conflict response is returned, **then** it includes the update action, artifact identifier, conflict status, expected revision, actual revision, message, and path without changing the artifact.

### User Story 2 - Regenerate clarification records without losing valid state (Priority: P1)

A maintainer can regenerate a clarification record after its source changes while preserving valid finding responses, resolution history, and stable finding identities for unchanged evidence.

**Why this priority**: Regeneration is necessary for current findings, but losing accepted responses or audit history would make clarification state unsafe to maintain.

**Independent Test**: Generate a record, resolve findings, modify the source, regenerate it, and verify preserved identities, valid responses, resolution history, recalculated findings, source immutability, and deterministic output.

**Acceptance Scenarios**:

1. **Given** no clarification artifact exists, **when** Generate runs, **then** it creates the deterministic colocated artifact.
2. **Given** an existing clarification artifact with unchanged evidence and valid responses, **when** Generate runs again, **then** it preserves those finding identifiers and responses.
3. **Given** an existing clarification artifact with resolution history, **when** Generate recalculates findings, **then** it preserves the history and does not discard valid entries.
4. **Given** identical source and governing inputs, **when** Generate runs repeatedly, **then** finding count, identifiers, ordering, severity, and generated artifact bytes are identical.

### User Story 3 - Apply explicit profiles, deterministic ordering, and privacy protection (Priority: P1)

A repository user can rely on explicit profile discovery, category and within-category finding ordering, an extensible-only ambiguity vocabulary, and privacy filtering before any clarification state is produced or written.

**Why this priority**: These rules constrain analysis inputs and output safety, making clarification behavior reproducible and preventing sensitive values from entering retained records.

**Independent Test**: Exercise each profile discovery location and precedence rule, category and within-category ordering, default ambiguity terms, explicit profile extensions, and secret/PII redaction before generation and updates.

**Acceptance Scenarios**:

1. **Given** multiple resolvable profiles, **when** clarification processing begins, **then** the first profile in artifact-local, artifact-type, global order is used; absent profiles do not fail processing.
2. **Given** findings in multiple categories and source locations, **when** the record is generated, **then** findings use the required category order followed by source order, field name, and finding identifier.
3. **Given** an explicit profile, **when** ambiguity terms are loaded, **then** it may extend the default vocabulary but cannot remove default entries.
4. **Given** a password, token, credential, connection string, secret, or regulated personal value in input, **when** processing occurs, **then** it is redacted before finding generation, artifact generation, updates, or writes.

### Edge Cases

- A source artifact has no resolvable profile at any discovery location; processing continues with defaults.
- A source explicitly declares an artifact-local profile that cannot be read; lower-precedence profiles are not selected silently if the local declaration is the selected first resolvable source.
- A source changes so an existing finding no longer has unchanged evidence; its prior response is not incorrectly applied to unrelated evidence.
- A record contains missing required metadata or invalid template structure; status is `blocked` and the record is not silently repaired.
- An update fails validation or conflicts; revision, history, and artifact bytes remain unchanged.
- A finding contains equal category priority and equal source location; field name and then finding identifier break ties deterministically.
- Sensitive values appear in source evidence, responses, history, or metadata; privacy filtering redacts them before retained output.
- A profile attempts to remove a default ambiguity term; the default term remains active.
- Environment values, timestamps, filesystem order, recency, randomness, model preference, semantic similarity, and architectural preference vary between runs; results remain unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The skill MUST use the description `Generates, updates, validates, and serves deterministic clarification records for Highway artifacts.`.
- **FR-002**: The skill MUST publish usage covering Generate, Update, Inspect, Read, and Status with the exact `<ARTIFACT-ID>` command forms.
- **FR-003**: Every source artifact MUST map to the deterministic and stable identifier `CLAR-<ARTIFACT-ID>`.
- **FR-004**: The skill MUST discover optional Clarification Profiles in this order: artifact-local declaration, `.highway/library/clarification/<artifact-type>.yaml`, then `.highway/library/clarification/profile.yaml`.
- **FR-005**: The first resolvable profile MUST be loaded, and absent profiles MUST NOT fail clarification processing.
- **FR-006**: The stable consumer contract MUST guarantee `artifact_id`, `exists`, `status`, `open_findings`, `resolved_findings`, `total_findings`, `path`, and `blocking_reason`.
- **FR-007**: Future versions MAY add consumer fields but MUST NOT remove, rename, or change the data types of existing guaranteed fields.
- **FR-008**: Generate MUST create a new clarification artifact when none exists and MUST deterministically regenerate an existing artifact when one exists.
- **FR-009**: Regeneration MUST preserve finding identifiers when evidence is unchanged, preserve valid responses, preserve resolution history, and recalculate findings from the current source.
- **FR-010**: Generate MUST NOT discard valid responses or resolution history during regeneration.
- **FR-011**: `revision` MUST be an integer initialized to 1, incremented exactly once by each successful Update, unchanged by failed Updates and conflicts, and monotonically increasing.
- **FR-012**: Conflict responses MUST contain action `update`, the artifact identifier, status `conflict`, expected and actual integer revisions, the exact conflict message, and the artifact path.
- **FR-013**: Conflict responses MUST perform no write, append no history, and modify no revision.
- **FR-014**: Findings MUST be ordered by category priority: contradiction, missing_input, unknown_value, ambiguity, unresolved_assumption.
- **FR-015**: Findings within each category MUST be ordered by source artifact order, source field name, and finding identifier.
- **FR-016**: Identical inputs MUST produce identical finding count, identifiers, ordering, severity values, and generated artifact bytes.
- **FR-017**: Clarification processing MUST NOT depend on timestamps, filesystem ordering, recency, environment values, randomness, model preference, semantic similarity, or architectural preference.
- **FR-018**: The default ambiguity vocabulary MUST remain active, and Clarification Profiles MAY extend it but MUST NOT remove any default entry.
- **FR-019**: The skill MUST redact passwords, credentials, tokens, connection strings, secrets, and regulated personal data before finding generation, artifact generation, artifact updates, and artifact writes, including all retained findings, responses, history, metadata, and copied evidence.
- **FR-020**: Detected sensitive values MUST be replaced with `<secret-redacted>` or `<pii-redacted>` according to the detected value type.
- **FR-021**: Status MUST be `not-started` when no clarification artifact exists, `in-progress` when an artifact exists with open findings greater than zero, `complete` when an artifact exists with zero open findings, and `blocked` when the artifact is malformed, required metadata is missing, or required template structure is invalid.
- **FR-022**: The clarification-record template MUST be authoritative for frontmatter, body, findings, resolution history, status, revision, and source metadata structures.
- **FR-023**: Generated clarification artifacts MUST follow the clarification-record template exactly.
- **FR-024**: The template MUST expose frontmatter fields for identifier, source metadata, status, revision, open findings, resolved findings, total findings, and blocking reason.
- **FR-025**: The template MUST contain the required body sections `Findings`, `Resolution History`, `Source`, and `Status`, with standardized status field formatting.
- **FR-026**: The skill MUST publish verification rules for stable consumer fields, response/history preservation during regeneration, privacy filtering before writes, deterministic finding identifiers and ordering, conflict no-write behavior, and monotonic revisions.
- **FR-027**: Existing supported identifier families, source ownership, advisory semantics, and no-source-mutation guarantees MUST remain unchanged unless explicitly strengthened by this feature.

### Key Entities *(include if feature involves data)*

- **Clarification Artifact Identifier**: Stable `CLAR-<ARTIFACT-ID>` identity derived from a supported source artifact.
- **Clarification Profile**: Optional rule set discovered through the declared precedence chain.
- **Stable Consumer Contract**: Version-compatible fields exposed by all command response views.
- **Regenerated Clarification Artifact**: Existing record recalculated from current source while retaining valid state.
- **Revision and Conflict Record**: Integer revision state and conflict response data used for optimistic concurrency.
- **Ordered Finding Set**: Findings ordered by category, source position, field name, and identifier.
- **Privacy-Filtered Evidence**: Source, response, and metadata values after secret and PII replacement.
- **Authoritative Clarification Template**: Shared structure governing all generated clarification records.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of supported source artifacts produce the same `CLAR-<ARTIFACT-ID>` identifier across repeated processing.
- **SC-002**: 100% of Generate and Update responses expose all eight stable consumer fields without field removal, renaming, or type changes.
- **SC-003**: 100% of regeneration cases preserve valid unchanged-evidence responses and all prior resolution history entries.
- **SC-004**: 100% of identical-input runs produce identical finding counts, identifiers, ordering, severity values, and artifact bytes.
- **SC-005**: 100% of profile-resolution cases follow the declared precedence order, while 100% of absent-profile cases continue successfully.
- **SC-006**: 100% of finding lists satisfy category and within-category ordering rules.
- **SC-007**: 100% of detected secrets and regulated personal data are replaced before any finding, artifact, update, or write operation retains them.
- **SC-008**: 100% of revision conflicts report expected and actual revisions and produce zero artifact, history, or revision changes.
- **SC-009**: 100% of successful Updates increment revision by exactly one, and no failed Update decreases or changes revision.
- **SC-010**: 100% of malformed records are reported as `blocked` with required metadata or template-structure reasons, without silent repair.
- **SC-011**: 100% of generated records conform to the shared template's frontmatter and required body sections.

## Assumptions

- Feature 058 remains the baseline implementation and its existing supported identifiers, advisory behavior, source immutability, and command names remain in scope.
- Clarification Profiles are YAML documents when present at the declared library locations or explicitly declared by a source artifact.
- The artifact-local profile declaration identifies a resolvable path; an absent declaration means the library precedence chain is considered.
- Profile discovery is advisory configuration loading and does not introduce a role-based authorization model.
- Privacy filtering applies to all retained clarification content, including findings, responses, history, metadata, and copied evidence. Privacy detection uses explicit repository-approved rules and conservative redaction; the redaction markers are retained as literal placeholders rather than the original values.
- Generated artifact bytes exclude non-semantic volatile metadata; deterministic byte equality applies to the defined generated record output.
- Existing repository validators, generators, and focused fixture tests remain the validation mechanisms for this follow-on feature.

## Scope Boundaries

### Included in Version 1

- Metadata and usage contract corrections for `highway-clarify`.
- Stable clarification identifiers and consumer response fields.
- Profile discovery precedence and absent-profile behavior.
- Generate regeneration preservation rules.
- Revision, conflict, status, finding ordering, ambiguity vocabulary, privacy, and deterministic guarantees.
- Authoritative clarification-record template frontmatter and body requirements.
- Verification coverage for all added contracts.

### Excluded from Version 1

- New source artifact identifier families.
- Automatic modification of authoritative source artifacts.
- Automatic merging of conflicting updates.
- Removal of default ambiguity vocabulary entries.
- A centralized clarification directory.
- Role-specific authorization beyond existing repository access controls.
- Replacing explicit contradiction rules with inferred semantic or architectural judgments.
