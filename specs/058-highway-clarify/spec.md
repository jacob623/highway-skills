# Feature Specification: Highway Clarify

**Feature Branch**: `058-highway-clarify`

**Created**: 2026-09-21

**Status**: Draft

**Input**: User description: "Create spec for a new skill called highway-clarify that manages clarification findings and responses for Highway artifacts through deterministic analysis, colocated clarification records, and stable generate, update, inspect, read, and status contracts."

## Clarifications

### Session 2026-09-21

- Q: What format should the colocated clarification artifact use? → A: Markdown with YAML frontmatter and structured body sections.
- Q: When two updates target the same clarification artifact concurrently, how should the skill handle the conflict? → A: Use optimistic concurrency with revision validation; abort conflicting updates without partial writes or automatic merging, and allow at most three retries.
- Q: Should unresolved clarification findings block downstream workflows from consuming the source artifact? → A: Never block downstream use; clarification is always advisory.
- Q: Which roles should be authorized to create or update clarification artifacts? → A: Any repository user may write and read.
- Q: Should supported artifact identifiers be case-sensitive? → A: Require case-sensitive uppercase identifiers exactly as declared.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Generate deterministic clarification findings (Priority: P1)

A Highway maintainer can request clarification for a supported source artifact and receive a colocated clarification artifact that records actionable findings without changing the authoritative source.

**Why this priority**: Reliable clarification generation is the core value of the skill and establishes the artifact and contract model used by every other command.

**Independent Test**: Run Generate against representative REQ, DISC, ADR, and RA artifacts containing each supported finding category, then verify deterministic findings, stable ordering, correct colocation, and unchanged source content.

**Acceptance Scenarios**:

1. **Given** a supported artifact identifier resolves through an identifier, catalog, or declared-path lookup, **when** Generate runs, **then** it analyzes the resolved source, creates one colocated clarification artifact, and returns the Generate response contract.
2. **Given** the same source artifact and governing clarification inputs are analyzed repeatedly, **when** Generate runs, **then** the finding categories, ordering, identifiers, and output path are identical.
3. **Given** a finding could match more than one category, **when** the evidence is evaluated, **then** only the highest-priority category is emitted.
4. **Given** source content is analyzed, **when** the clarification artifact is written, **then** the source artifact remains byte-for-byte unchanged.

### User Story 2 - Resolve findings without losing history (Priority: P1)

A maintainer can record responses to open findings and retain a complete resolution history while preserving existing findings and the source artifact.

**Why this priority**: Clarification is useful only when responses become durable, auditable state rather than disappearing after a single review.

**Independent Test**: Generate an artifact with multiple findings, update one or more responses, and verify that prior findings, response history, status, and source content are all preserved as specified.

**Acceptance Scenarios**:

1. **Given** a valid clarification artifact has open findings, **when** Update receives responses, **then** it records the responses, appends resolution history, updates the clarification status, and preserves every existing finding.
2. **Given** some findings remain unresolved after an update, **when** status is recalculated, **then** the clarification artifact is `in-progress` and identifies the remaining open findings.
3. **Given** every finding has a valid resolution, **when** status is recalculated, **then** the clarification artifact is `complete`.
4. **Given** the source artifact has been changed independently, **when** Update runs, **then** it does not rewrite, override, or merge changes into the source artifact.

### User Story 3 - Consume clarification state through stable read-only views (Priority: P1)

A downstream Highway workflow can inspect complete clarification details or retrieve a lightweight status without mutating any artifact.

**Why this priority**: Stable read-only contracts allow owning skills and orchestration to use clarification state without coupling to the full artifact format or risking source mutation.

**Independent Test**: Exercise Inspect, Read, and Status against not-started, in-progress, complete, and malformed cases and verify their documented fields, read-only behavior, and blocking semantics.

**Acceptance Scenarios**:

1. **Given** no clarification artifact exists for a supported source artifact, **when** Inspect or Status runs, **then** it reports `not-started` and the deterministic expected path.
2. **Given** a valid clarification artifact exists, **when** Inspect runs, **then** it returns status, open findings, resolved findings, total findings, path, and blocking reason.
3. **Given** a valid clarification artifact exists, **when** Read runs, **then** it returns the complete clarification artifact without writing.
4. **Given** a valid clarification artifact exists, **when** Status runs, **then** it returns the lightweight consumer contract without writing.
5. **Given** a clarification artifact is malformed, **when** a read-only command runs, **then** it reports `blocked` with a non-empty blocking reason and does not silently repair the artifact.

### Edge Cases

- An unsupported or malformed artifact identifier is rejected without scanning for a best match.
- A lowercase or mixed-case identifier is rejected because supported identifiers are case-sensitive and must use their declared uppercase form.
- Multiple possible source paths exist; identifier, catalog, or declared-path precedence resolves the source deterministically, while filesystem order, timestamps, recency, and newest-file selection are never used.
- A supported future identifier such as `PLAN######`, `ARCH######`, or `TASK######` is not accepted until its resolution and contract rules are explicitly declared; adding it later must not change existing identifier behavior.
- A source artifact has no declared required structure; no `missing_input` finding is emitted solely because content is absent.
- A field contains an explicitly declared unknown marker; it produces `unknown_value`, while an absent field does not.
- A contradiction is emitted only when an explicit source, profile, or repository contradiction rule matches; general knowledge, semantic similarity, preferences, and model inference do not create contradictions.
- The same evidence appears to support more than one category; exactly one finding is created using the category priority order.
- An update references an unknown finding or supplies an invalid response; the existing artifact and source remain unchanged and the response identifies the correction needed.
- Two updates begin from the same artifact revision; the later write detects the changed revision, aborts without writing or appending history, and returns the expected and actual revisions with a retry instruction.
- Three consecutive revision conflicts occur; the update aborts and returns the conflict response without automatic merging.
- A valid clarification artifact has zero findings; status is `complete` because there are no open findings to resolve.
- A clarification artifact is absent; read-only commands do not create it.
- Open findings remain available to downstream consumers as advisory information and do not prevent source-artifact consumption.
- Any repository user may invoke Generate, Update, Inspect, Read, or Status, subject to the repository's existing access controls.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The skill MUST support Generate with `/highway-clarify <ARTIFACT-ID>` and MUST analyze the resolved source artifact, create one colocated clarification artifact, and return a documented Generate response contract.
- **FR-002**: The skill MUST support Update, Inspect, Read, and Status commands using the forms `/highway-clarify update <ARTIFACT-ID>`, `/highway-clarify inspect <ARTIFACT-ID>`, `/highway-clarify read <ARTIFACT-ID>`, and `/highway-clarify status <ARTIFACT-ID>`.
- **FR-003**: Inspect, Read, and Status MUST be read-only; Generate and Update MUST never modify, override, rewrite, replace, or update source artifact content.
- **FR-004**: The initial supported identifier families MUST be `REQ######`, `DISC######`, `ADR######`, and `RA######`; identifier matching MUST be exact and case-sensitive, and lowercase or mixed-case forms MUST be rejected.
- **FR-005**: Artifact resolution MUST be deterministic and MUST use only identifier lookup, artifact catalog lookup, or declared artifact paths; it MUST NOT depend on filesystem ordering, timestamps, recency, or newest-file selection.
- **FR-006**: A clarification artifact MUST be colocated with its source artifact and named using the source identifier plus `-clarification`, such as `REQ000001-clarification.md`; a centralized clarification directory MUST NOT be used.
- **FR-007**: The clarification artifact MUST preserve source ownership and MUST contain sufficient state to represent findings, responses, resolution history, status, source path, and blocking reason where applicable.
- **FR-008**: Clarification analysis MUST evaluate categories in this exact order: `contradiction`, `missing_input`, `unknown_value`, `ambiguity`, and `unresolved_assumption`.
- **FR-009**: When multiple categories match the same evidence, the skill MUST emit only the highest-priority category, and one evidence source MUST produce exactly one finding.
- **FR-010**: Contradiction findings MUST be produced only by explicit rules from the source artifact, Clarification Profile, or repository contradiction catalog; the skill MUST NOT infer contradictions from general knowledge, semantic similarity, architectural preferences, or model reasoning.
- **FR-011**: Missing-input findings MUST be derived only from declared artifact templates, artifact contracts, owning skill outputs, owning skill workflow contracts, or required fields/sections, and no finding MUST be emitted when no required structure is declared.
- **FR-012**: Unknown-value findings MUST recognize `unknown`, `UNKNOWN`, `Unknown`, and other explicitly declared unknown markers; absence alone MUST NOT be treated as unknown.
- **FR-013**: Ambiguity findings MUST use the default vocabulary `modern`, `scalable`, `appropriate`, `reasonable`, `adequate`, `sufficient`, `robust`, `flexible`, `user-friendly`, `efficient`, `best practice`, `future-proof`, `enterprise-grade`, `simple`, `easy`, and `optimized`, while allowing an explicitly declared vocabulary to extend or replace the default according to the contract.
- **FR-014**: Update MUST preserve all existing findings, append resolution history, record responses against the relevant finding, and derive status as `not-started`, `in-progress`, `complete`, or `blocked` according to the artifact contract.
- **FR-015**: `not-started` MUST mean no clarification artifact exists, `in-progress` MUST mean one or more findings remain open, `complete` MUST mean all findings are resolved including the valid zero-finding case, and `blocked` MUST mean the clarification artifact is malformed.
- **FR-016**: Inspect MUST return status, open findings, resolved findings, total findings, path, and blocking reason; Read MUST return the complete clarification artifact; Status MUST return the documented lightweight consumer contract.
- **FR-017**: Read-only commands MUST report malformed clarification artifacts as `blocked` with a non-empty blocking reason and MUST NOT silently repair, rewrite, or delete them.
- **FR-018**: Adding future identifier families MUST be additive and MUST NOT change the behavior, resolution, artifact locations, statuses, or response contracts of the initially supported families.
- **FR-019**: Generate and Update MUST fail without partial clarification output when source resolution, validation, or response processing cannot complete, and MUST preserve the source artifact in every failure case.
- **FR-020**: The skill MUST publish stable contracts for command inputs, artifact resolution, clarification artifact structure, finding categories, statuses, Generate response, Inspect response, Read response, and Status response.
- **FR-021**: A clarification artifact MUST use Markdown with YAML frontmatter and structured body sections so that its metadata, findings, responses, resolution history, status, source path, and blocking reason are machine-validatable and maintainer-readable.
- **FR-022**: Each clarification artifact MUST maintain an internal integer revision, and every successful Update MUST increment that revision by exactly one.
- **FR-023**: Update MUST read and record the artifact revision before staging changes, revalidate that the revision is unchanged immediately before writing, and abort without partial writes when the revision has changed.
- **FR-024**: A conflict response MUST report action `update`, status `conflict`, artifact identifier, expected revision, actual revision, message, and artifact path.
- **FR-025**: The skill MUST NOT automatically merge competing responses, findings, history entries, statuses, or metadata; callers MAY reload the latest artifact, reapply the intended update, and retry no more than three times.
- **FR-026**: History entries MUST be written only after a successful revision-validated commit, and conflicting updates MUST NOT append history records.
- **FR-027**: Open clarification findings MUST remain advisory and MUST NOT block downstream workflows from consuming the source artifact, regardless of finding severity or clarification status.
- **FR-028**: Status and consumer contracts MUST expose open findings and clarification status to downstream workflows even when those workflows continue to consume the source artifact.
- **FR-029**: The skill MUST permit any repository user to invoke Generate, Update, Inspect, Read, and Status, while continuing to honor existing repository access controls and write-safety rules.
- **FR-030**: The skill MUST NOT require a separate governance role, maintainer role, or approval gate for clarification artifact creation or updates.

### Key Entities *(include if feature involves data)*

- **Source Artifact**: The authoritative Highway artifact identified by a supported identifier and resolved through an allowed deterministic mechanism.
- **Clarification Artifact**: A colocated supplement that records findings, responses, resolution history, status, path, and blocking information without becoming authoritative over the source.
- Clarification artifacts use Markdown with YAML frontmatter and structured body sections, consistent with existing Highway artifact conventions.
- **Finding**: One categorized piece of evidence requiring clarification, with stable identity, source location or evidence reference, severity, state, and resolution information.
- **Clarification Response**: A recorded answer or disposition associated with one finding and appended to its resolution history.
- **Artifact Revision**: The integer version stored in clarification metadata and used to detect changes between Update read and commit.
- **Clarification Profile**: An explicit set of rules and vocabularies that governs contradiction, unknown-value, ambiguity, and related analysis behavior.
- **Contradiction Catalog**: A repository-owned collection of explicit contradiction rules that may produce contradiction findings.
- **Artifact Resolution Record**: The deterministic mapping from an artifact identifier to its source path and owning artifact type.
- **Clarification Status**: One of `not-started`, `in-progress`, `complete`, or `blocked`, exposed through consumer contracts.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of supported artifact identifiers resolve through an allowed deterministic mechanism, and repeated resolution of unchanged inputs returns the same source path.
- **SC-002**: 100% of Generate and Update cases leave source artifacts unchanged, including successful writes, validation failures, malformed inputs, and response errors.
- **SC-003**: 100% of analysis cases evaluate the five finding categories in the declared priority order and emit no more than one finding for each evidence source.
- **SC-004**: 100% of explicit contradiction matches produce a contradiction finding, while 0% of contradiction findings are produced from non-explicit inference sources.
- **SC-005**: 100% of missing-input findings trace to a declared required structure, and 0% are emitted when no required structure is declared.
- **SC-006**: 100% of explicitly marked unknown values are detected and 0% of absent values are classified as unknown without an explicit marker.
- **SC-007**: 100% of generated clarification artifacts are colocated with their source and use the deterministic identifier-based name; 0% are written to a centralized clarification directory.
- **SC-008**: 100% of Update cases preserve all pre-existing findings and append resolution history; every resulting status matches the declared open, resolved, or malformed state.
- **SC-009**: 100% of Inspect responses contain status, open findings, resolved findings, total findings, path, and blocking reason, and 100% of Read and Status calls perform no writes.
- **SC-010**: All initial identifier families and all five command forms pass contract validation, and adding a future identifier fixture causes no regression in existing-family results.
- **SC-011**: 100% of concurrent update conflicts are detected and reported with expected and actual revisions, 0% produce partial writes, silent overwrites, automatic merges, or conflict history entries, and every successful update increments the revision by exactly one.
- **SC-012**: 100% of downstream-consumption cases proceed without a clarification gate, while 100% of open findings and their status remain available through the consumer contracts.
- **SC-013**: 100% of repository-user command cases can read clarification state and validly create or update clarification artifacts without role-based rejection, while invalid identifiers, malformed artifacts, and unsafe writes remain rejected deterministically.
- **SC-014**: 100% of uppercase supported identifiers resolve according to their declared family, and 100% of lowercase or mixed-case variants are rejected without filesystem fallback or normalization.

## Assumptions

- Highway artifacts have owning skills, catalogs, templates, and contracts available when they are declared as inputs to analysis.
- A clarification artifact is supplemental governance state and is not itself a source artifact for the initial version.
- Severity defaults to `high` for contradiction and missing-input findings and `medium` for unknown-value findings; ambiguity and unresolved-assumption severity are declared by the governing profile or contract rather than inferred.
- The active clarification profile and repository contradiction catalog are explicit inputs whose paths and precedence will be defined during planning.
- Responses are associated with stable finding identifiers, and an update that cannot identify a target finding is rejected without partial writes.
- Concurrent updates use optimistic concurrency control with revision validation; the implementation does not rely on timestamps, wall-clock time, thread scheduling, filesystem ordering, agent choice, or randomness.
- Clarification findings are advisory governance information; downstream workflows decide independently whether and how to act on them.
- Repository access controls remain the only authorization boundary for clarification commands; the skill adds no role-specific permission model.
- Existing Highway artifact ownership and output-template conventions remain authoritative; this feature adds clarification state without changing those artifacts.
- Future identifier support is additive and requires explicit resolution and contract coverage before activation.
- No extension hooks are registered for this specification invocation.

## Scope Boundaries

### Included in Version 1

- The `highway-clarify` skill and its Generate, Update, Inspect, Read, and Status command contracts.
- Deterministic resolution for REQ, DISC, ADR, and RA artifacts.
- Colocated clarification artifacts with stable finding, response, history, and status state.
- Explicit contradiction, missing-input, unknown-value, ambiguity, and unresolved-assumption analysis rules.
- Read-only consumer views and non-mutation guarantees for source artifacts.

### Excluded from Version 1

- Automatic modification, rewriting, replacement, or overriding of source artifacts.
- Implicit contradiction inference from general knowledge, semantic similarity, architectural preference, or model reasoning.
- Candidate generation, solution selection, architecture decisions, or ownership changes in REQ, DISC, ADR, or RA workflows.
- A centralized clarification directory.
- Activation of future identifier families before their resolution and contract rules are declared.
- Unbounded natural-language interpretation beyond explicit profiles, catalogs, templates, contracts, and declared vocabularies.
