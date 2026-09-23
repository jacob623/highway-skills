# Feature Specification: Highway ADR Decision Workflow

**Feature Branch**: `075-highway-adr`

**Created**: 2026-09-22

**Status**: Draft

**Input**: User description: "Implement `highway-adr` as the authoritative architecture decision workflow that consumes one completed Discovery artifact and converts advisory analysis into an approved architectural decision."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Decide From One Discovery Artifact (Priority: P1)

As an architecture decision authority, I want `highway-adr` to consume exactly one valid Discovery artifact and its candidate analysis so that one approved architectural decision is produced without changing Discovery's advisory work.

**Why this priority**: Selecting and authorizing one architectural option is the central value of the ADR workflow and the required transition from Discovery to Reference Architecture.

**Independent Test**: Provide one valid `DISC######` artifact containing a recommendation, candidate options, comparison matrix, and Reference Architecture matches; verify that one accepted ADR selects exactly one existing option, records rationale and rejected options, and leaves Discovery unchanged.

**Acceptance Scenarios**:

1. **Given** exactly one explicit `DISC######` identifier resolves to a valid Discovery record, **When** ADR generation runs, **Then** it creates one `ADR######` record with Discovery ID, Request ID, recommendation, selected option, rationale, consequences, and Reference Architecture handoff.
2. **Given** Discovery contains multiple candidate options, **When** the decision is evaluated, **Then** only Discovery options may be selected or rejected and no new candidate is created or candidate definition modified.
3. **Given** the Discovery recommendation and comparison evidence identify one acceptable option, **When** ADR generation completes, **Then** that option is selected and the decision authority, decision statement, and authorization to proceed are recorded.
4. **Given** several options remain acceptable after evaluation, **When** tie-breaks are applied, **Then** the workflow uses Discovery recommendation, higher Discovery score, more Reference Architecture matches, and lower `OPT` identifier in that order until one option is selected.
5. **Given** ADR selects an option different from the Discovery recommendation, **When** the ADR is generated, **Then** it records the Discovery recommendation, selected option, and rationale for overriding the recommendation.

---

### User Story 2 - Consume Clarification and Governance Evidence (Priority: P1)

As an architecture decision authority, I want ADR to consume Clarification and governance evidence without owning those artifacts so that uncertainty, constraints, and relationships inform the decision while ownership remains with their source workflows.

**Why this priority**: ADR decisions must account for resolved evidence and unresolved risk while preserving the boundaries between Clarification, Discovery, governance baselines, and architectural decision ownership.

**Independent Test**: Supply Discovery, optional request and clarification records, profile, objectives, controls, and NFRs in each supported clarification status; verify the specified resolution order and evidence treatment without any source artifact mutation.

**Acceptance Scenarios**:

1. **Given** Clarification is `complete`, **When** ADR consumes it, **Then** resolved findings and responses may inform context, rationale, constraints, alternatives, and consequences.
2. **Given** Clarification is `in-progress`, **When** ADR consumes it, **Then** resolved findings are consumed while open findings become assumptions and risks and cannot select or reject an option.
3. **Given** Clarification is `not-started` or missing, **When** ADR runs, **Then** it continues without clarification evidence and does not create a clarification artifact.
4. **Given** Clarification is `blocked` or malformed, **When** ADR runs, **Then** it records the condition as a risk or falls back to Discovery evidence without changing Clarification status, findings, responses, or history.
5. **Given** optional profile, objectives, controls, or NFRs are present, **When** ADR evaluates options, **Then** they provide advisory context or relationships and do not transfer decision ownership from ADR.

---

### User Story 3 - Publish a Deterministic ADR Handoff (Priority: P1)

As a Reference Architecture owner, I want a complete ADR and catalog entry with a stable handoff so that the approved decision can be implemented without reconstructing the Discovery analysis.

**Why this priority**: The ADR is the authoritative boundary between advisory Discovery and Reference Architecture; incomplete or nondeterministic output would make the decision unsafe to consume.

**Independent Test**: Generate an ADR twice from identical valid inputs and compare the output and catalog behavior; verify required sections, one selected option, status, relationships, handoff, and no-write failure behavior.

**Acceptance Scenarios**:

1. **Given** a valid decision, **When** the ADR is written, **Then** `adrs/ADRXXXXXX.md` contains Discovery Reference, Clarification Inputs, Context, Decision, Alternatives Considered, Assumptions, Risks, Consequences, Constraints, Objective Relationships, Control Relationships, NFR Relationships, and Reference Architecture Handoff.
2. **Given** an ADR is generated successfully, **When** its catalog is updated, **Then** `adrs/adrs.md` advances exactly once and references the generated ADR directly.
3. **Given** identical inputs are processed repeatedly, **When** output is compared, **Then** the ADR content and decision ordering are identical and no volatile selection is introduced.
4. **Given** Discovery is missing, malformed, ambiguous, or does not contain the selected option, **When** generation fails, **Then** no ADR or catalog bytes are partially written and all existing source bytes are preserved.
5. **Given** a valid accepted decision, **When** Reference Architecture consumes the handoff, **Then** it receives the selected option, matching architectures, architecture direction, required architecture work, and explicit authorization to proceed.

### Edge Cases

- No `DISC######` identifier is supplied, more than one is supplied, or the identifier is not exact uppercase syntax; ADR generation aborts without writing.
- The identifier resolves to zero, multiple, or invalid Discovery records; ADR generation aborts without modifying the catalog or Discovery.
- Discovery has no candidate options, a missing recommendation, malformed comparison data, changed scores, or missing Reference Architecture matches; validation aborts or records only the permitted absence without inventing evidence.
- The selected option is not present in Discovery, more than one option would be selected, or a rejected option is not present in Discovery; validation aborts without partial output.
- Clarification is missing, `not-started`, `in-progress`, `complete`, `blocked`, or malformed; handling follows the declared status and fallback rules without Clarification mutation.
- A governance baseline is missing or malformed; missing optional evidence is omitted, while malformed governance input aborts and preserves bytes.
- A catalog allocation conflicts with another writer; the workflow retries up to three times, then aborts without a partial write.
- Repeated execution encounters an existing ADR; it must not silently create a second decision or alter an immutable Discovery source.
- An ADR already exists for the same Discovery identifier; generation aborts without creating a second ADR or changing the existing ADR or catalog entry.
- A generated ADR omits a required decision, consequence, rationale, relationship, or handoff field; validation fails before writing.
- ADR selects an option different from the Discovery recommendation; the Recommendation Override section is required rather than inferred from general rationale.
- Objective, Control, or NFR relationship inputs have equal precedence; relationship ordering uses identifier type, numeric identifier, then title.
- Clarification contains conflict guidance or open findings; ADR records the conflict or finding references without allowing Clarification to select an option.
- An existing ADR has supersession metadata absent; creation uses `Supersedes: None` and `Superseded By: None`.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The workflow MUST require exactly one explicit identifier matching `DISC######` before resolving Discovery.
- **FR-002**: The workflow MUST resolve exactly one valid Discovery artifact and abort when the identifier is missing, ambiguous, duplicated, or malformed.
- **FR-003**: The Discovery Reference section MUST contain the source Discovery recommendation, rationale, candidate solution options, comparison matrix, Reference Architecture matches, and Request identifier.
- **FR-004**: The workflow MUST use Discovery options only and MUST NOT generate candidates, modify candidate definitions, recalculate scores, re-rank candidates, or modify Discovery.
- **FR-005**: The generated ADR MUST contain the selected option, rejected options, decision rationale, consequences, and authorization to proceed to Reference Architecture as ADR-owned values.
- **FR-006**: The Decision Rationale MUST contain traceable consideration of Discovery recommendation, Discovery rationale, comparison matrix, Clarification evidence, objectives, controls, NFRs, and Reference Architecture compatibility.
- **FR-007**: When multiple options remain acceptable, the workflow MUST apply tie-breaks in this order: Discovery recommended option, higher Discovery score, more Reference Architecture matches, then lower `OPT` identifier.
- **FR-008**: The workflow MUST select exactly one option and the selected option MUST exist in Discovery.
- **FR-009**: The workflow MUST record every non-selected Discovery option as rejected or otherwise evaluated, and every recorded option MUST exist in Discovery.
- **FR-010**: The workflow MUST consume Clarification as a consumer only and MUST NOT create, modify, resolve, or change the status, responses, findings, or resolution history of any Clarification artifact.
- **FR-011**: The evidence-resolution record MUST show first-match precedence in this order: Discovery, CLAR-DISC######, Request, CLAR-REQ######, Profile, Objectives, Controls, then NFRs; it MUST contain no filesystem-order, newest-file, or timestamp-based selection.
- **FR-012**: When resolved Clarification findings are present, the generated ADR MUST identify their contribution to context, rationale, constraints, alternative analysis, or consequences.
- **FR-013**: Open Clarification findings MAY inform assumptions, risks, unknowns, and required follow-up work, but MUST NOT select or reject an option or change decision ownership.
- **FR-014**: Clarification status handling MUST be: ignore `not-started`; consume resolved findings and treat open findings as assumptions and risks for `in-progress`; consume resolved findings for `complete`; and record `blocked` as a risk while continuing execution.
- **FR-015**: Malformed Clarification MUST fall back to Discovery evidence, while missing Clarification MUST allow ADR generation to continue without creating a Clarification artifact.
- **FR-016**: The workflow MUST preserve Discovery, Request, Clarification, profile, objectives, controls, and NFR bytes on successful and failed operations unless the workflow's own ADR and catalog outputs are being created or updated.
- **FR-017**: Every ADR MUST contain Discovery Reference, Clarification Inputs, Context, Decision, Decision Confidence, Alternatives Considered, Assumptions, Risks, Consequences, Constraints, Objective Relationships, Control Relationships, NFR Relationships, and Reference Architecture Handoff sections.
- **FR-018**: The Decision section MUST contain exactly one selected `OPTXXXXXX` option, a decision statement, and a decision authority.
- **FR-019**: Alternatives Considered MUST contain an identifier, outcome, selection status, and reason for every Discovery option.
- **FR-020**: The Consequences section MUST contain separately labeled positive, negative, operational, and governance consequences.
- **FR-021**: Reference Architecture Handoff MUST contain the selected option, Reference Architecture matches, architecture direction, required architecture work, and authorization to proceed.
- **FR-022**: The generated ADR status MUST be `accepted` on initial creation, and the status field MUST accept only `proposed`, `accepted`, `rejected`, or `superseded`.
- **FR-023**: Successful creation MUST produce exactly one ADR at `adrs/ADRXXXXXX.md` and exactly one corresponding catalog entry in `adrs/adrs.md`.
- **FR-024**: The ADR catalog MUST advance exactly once per successful creation and MUST resolve directly to the generated ADR.
- **FR-025**: Catalog allocation conflicts MUST retry at most three times; catalog write failure, validation failure, malformed Discovery, malformed governance baseline, and any other failure MUST preserve all existing bytes.
- **FR-026**: Before reporting success, the verification result MUST confirm unchanged Discovery recommendation and scores, unchanged Clarification and Request, unchanged governance baselines, one ADR decision, one selected option, present rationale and consequences, and a complete Reference Architecture handoff.
- **FR-027**: Two successful executions with identical inputs MUST produce byte-identical ADR content and identical option ordering, relationship ordering, and catalog result.
- **FR-028**: The Reference Architecture Handoff MUST authorize work to proceed to Reference Architecture and MUST exclude authorization to implement.
- **FR-029**: When the selected option differs from the Discovery recommended option, the ADR MUST contain a Recommendation Override section immediately after the Decision section with the Discovery recommended option, selected option, and override rationale.
- **FR-030**: The workflow MUST NOT add, remove, or modify relationship data in Discovery.
- **FR-031**: Objective, Control, and NFR relationships MUST be ordered first by identifier type, then by numeric identifier, then by title.
- **FR-032**: When Clarification contains conflict guidance, the ADR MUST record the conflict in Risks and Decision Rationale, and the conflict guidance MUST NOT directly select an option.
- **FR-033**: When open Clarification findings contribute to an ADR, the ADR MUST include an Open Clarification Findings section listing each finding identifier, including findings from `CLAR-DISC######` or `CLAR-REQ######`.
- **FR-034**: ADR generation MUST consume only `CLAR-REQ######` and `CLAR-DISC######`; Clarification of an ADR is a post-generation activity and `CLAR-ADR######` MUST NOT be consumed during ADR generation.
- **FR-035**: The ADR MUST contain `Supersedes: None` and `Superseded By: None` on initial creation; future ADR lifecycle workflows own replacement and supersession updates.
- **FR-036**: ADR MUST consume Discovery Reference Architecture matches, including their recorded confidence and match reasons, and MUST NOT recompute matching.
- **FR-037**: Every ADR MUST contain a Decision Confidence section with Discovery Confidence and Confidence Considerations; the workflow MUST consume confidence without rescoring Discovery options.
- **FR-038**: ADR generation MUST create status `accepted` only; transitions to `proposed`, `rejected`, or `superseded` are owned by future ADR lifecycle workflows.
- **FR-039**: Generated ADR content MUST NOT contain timestamps, creation dates, modification dates, environment identifiers, random values, or user-session identifiers.
- **FR-040**: The Discovery identifier MUST be the ADR uniqueness key; if an ADR already exists for that identifier, generation MUST abort without creating a second ADR or changing the existing ADR or catalog entry.
- **FR-041**: Every Reference Architecture Handoff field MUST be populated with a valid value or explicitly recorded as `None` before ADR generation reports success.

### Key Entities *(include if feature involves data)*

- **Discovery Artifact**: The single immutable advisory source containing recommendation, candidate options, comparison evidence, Request identity, and Reference Architecture matches.
- **ADR**: The authoritative decision record containing one selected option, rejected options, rationale, consequences, constraints, relationships, status, and handoff.
- **Candidate Solution Option**: A Discovery-owned option identified by an `OPTXXXXXX` identifier and evaluated without modification.
- **Clarification Input**: A consumer-only source of findings, responses, status, blocking reason, and resolution history.
- **Decision Catalog**: The ordered ADR index that advances once and directly references each ADR artifact.
- **ADR Catalog**: The authoritative allocation source for ADR identifiers and ADR index entries; it owns the next identifier and index, but does not own ADR content, status transitions, or decisions.
- **Reference Architecture Handoff**: The decision boundary containing the selected option, compatible architecture matches, direction, required work, and authorization to proceed.
- **Governance Relationship**: An advisory relationship between the ADR and an objective, control, or NFR.
- **Recommendation Override**: The traceability record explaining why ADR selected an option other than Discovery's recommendation.
- **Open Clarification Finding Reference**: A retained identifier for an unresolved clarification finding carried into ADR risks, assumptions, or follow-up work.
- **Decision Confidence**: Discovery-provided confidence and the considerations that affect confidence without changing Discovery scores.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of valid generation attempts consume exactly one Discovery identifier and produce exactly one selected option that exists in Discovery.
- **SC-002**: 100% of generated ADRs contain all 14 required sections, one decision, one selected option, rationale, consequences, and a complete Reference Architecture Handoff.
- **SC-003**: 100% of invalid, ambiguous, malformed, or missing Discovery inputs fail before changing Discovery, Request, Clarification, governance, ADR, or catalog bytes.
- **SC-004**: 100% of Clarification status fixtures follow the declared handling rules, and zero fixtures cause ADR to mutate Clarification artifacts or allow open findings to select or reject options.
- **SC-005**: 100% of acceptable-option tie cases resolve using the declared four-step tie-break order and terminate with exactly one selection.
- **SC-006**: 100% of successful catalog updates advance exactly once and point directly to the corresponding ADR artifact.
- **SC-007**: 100% of repeated runs with identical inputs produce byte-identical ADR content and stable ordering of options, relationships, and handoff data.
- **SC-008**: 100% of catalog conflicts stop after at most three retries and preserve all pre-operation bytes on exhaustion or write failure.
- **SC-009**: 100% of ADR outputs preserve Discovery recommendation and scores, Request content, Clarification content, and governance baseline content byte-for-byte.
- **SC-010**: At least 95% of representative Reference Architecture consumers can identify the selected option, rationale, consequences, constraints, and required architecture work without consulting Discovery source text.
- **SC-011**: 100% of ADRs that override the Discovery recommendation contain all three Recommendation Override values: recommended option, selected option, and override rationale.
- **SC-012**: 100% of relationship sections are byte-stably ordered by identifier type, numeric identifier, and title across repeated runs.
- **SC-013**: 100% of Clarification conflict fixtures appear in ADR Risks and Decision Rationale without selecting an option or mutating Clarification.
- **SC-014**: 100% of ADRs with open Clarification findings retain every contributing finding identifier in Open Clarification Findings.
- **SC-015**: 100% of initial ADRs contain `Supersedes: None`, `Superseded By: None`, and status `accepted`; no initial generation creates another status.
- **SC-016**: 100% of ADR outputs preserve Discovery Reference Architecture match confidence and reasons without recomputing matches or scores.
- **SC-017**: 100% of generated ADRs omit timestamps, environment identifiers, random values, and user-session identifiers.

## Assumptions

- Discovery, Request, Clarification, governance baselines, ADR templates, and catalogs already have authoritative repository contracts that this workflow consumes.
- The shared ADR output and catalog templates define the exact retained structure; this specification defines the workflow behavior and required sections.
- ADR creation is the only write owned by this workflow, aside from its catalog entry; all upstream and downstream artifacts retain their existing ownership boundaries.
- A valid Discovery recommendation may be advisory, but ADR remains responsible for the final selection and rationale.
- Missing optional Clarification or governance evidence is permitted according to the handling rules; malformed governance baselines remain fatal.
- Initial ADR creation uses status `accepted`; later lifecycle operations and supersession are outside this feature unless an existing ADR contract requires them.
- The Discovery identifier is the uniqueness key for an ADR; duplicate generation is rejected rather than treated as an update.
- Every Reference Architecture Handoff field has either a valid value or an explicit `None` representation.
- ADR generation consumes only Request and Discovery clarification artifacts; ADR clarification occurs after ADR generation and is outside this workflow's inputs.
- Relationship ordering is a stable presentation rule and does not change relationship ownership or advisory meaning.
- Discovery Reference Architecture match confidence and reasons are authoritative inputs; ADR does not derive a replacement confidence score.
- Initial supersession fields are placeholders for future lifecycle workflows and do not imply that this feature implements supersession.
- `OPTXXXXXX`, `DISC######`, `REQ######`, `CLAR-REQ######`, and `CLAR-DISC######` identifiers are stable repository vocabulary.
- Determinism excludes volatile metadata such as timestamps from decision content and ordering.
- Reference Architecture creation and implementation authorization remain outside the scope of this workflow.
- No new external service, persistence mechanism, or runtime dependency is required.
