# Feature Specification: Discovery Architecture Analysis

**Feature Branch**: `049-discovery-architecture-analysis`

**Created**: 2026-09-19

**Status**: Draft

**Input**: User description: "Transform highway-discovery from a passive research-summary artifact into an active architectural analysis artifact that generates deterministic candidate solution options, matches governance and Reference Architectures, and recommends a best-fit option for ADR evaluation while keeping ADR authoritative for decisions."

## Clarifications

### Session 2026-09-19

- Q: Must Version 1 include Complexity, Governance Impact, and Operational Overhead in every Candidate Solution Comparison Matrix, or may an implementation omit one or more categories? → A: Include all three categories in every Version 1 matrix.
- Q: When multiple Reference Architectures satisfy the deterministic matching rules, should Discovery report every matching Reference Architecture or only the first match found by precedence order? → A: Report every matching Reference Architecture and record each match's highest-precedence reason.
- Q: When equally scored options are all linked to Reference Architectures, how should Discovery break the remaining tie? → A: Prefer the Reference Architecture with the highest matching Reference Implementation count, then the lower Discovery-scoped `OPT` identifier.
- Q: If the authoritative Reference Implementation catalog is absent or unreadable during a tie-break, should Discovery treat every matching Reference Architecture as having zero Reference Implementations and use the lower `OPT` identifier? → A: Treat all unavailable counts as zero, then choose the lower `OPT` identifier.
- Q: If one Candidate Solution Option matches multiple Reference Architectures, which Reference Implementation count should Discovery use for the tie-break? → A: Use the highest Reference Implementation count among that option's matched Reference Architectures, then the lower Discovery-scoped `OPT` identifier.

## User Scenarios & Testing

### User Story 1 - Generate architectural solution options (Priority: P1)

A repository owner runs Discovery for a valid completed Request and receives a structured architectural analysis containing findings, risks, assumptions, unknowns, and distinct candidate solution options.

**Why this priority**: Candidate options are the core value of active Discovery and give ADR a bounded set of alternatives to evaluate.

**Independent Test**: Given one valid completed Discovery input with evidence that supports at least three viable strategies, run Discovery and verify that three distinct options are produced with stable identifiers, complete fields, and deterministic ordering.

**Acceptance Scenarios**:

1. **Given** a completed Request and closed repository baselines, **When** Discovery analysis runs, **Then** it preserves the existing analysis sections and adds between two and five distinct Candidate Solution Options whenever viable options exist.
2. **Given** three viable options, **When** options are sorted, **Then** sorting gives precedence to Desired Change alignment, Objective alignment, constraint alignment, and alphabetical title order.
3. **Given** identical Discovery inputs, **When** analysis is repeated, **Then** option content, ordering, and `OPT` identifiers are byte-identical.
4. **Given** fewer than two viable options, **When** analysis runs, **Then** it aborts with the reason and preserves existing Discovery and catalog bytes.

### User Story 2 - Match architecture context and recommend an option (Priority: P1)

A repository owner receives advisory matches to existing governance artifacts and optional Reference Architectures, plus a deterministic recommendation that explains how each option scored.

**Why this priority**: The recommendation connects evidence and repository context to ADR review without transferring decision authority from ADR.

**Independent Test**: Given Objectives, Controls, NFRs, Profile context, and at least one Reference Architecture, run Discovery and verify matching confidence, score components, tie-breaking, recommendation rationale, and unchanged source baselines.

**Acceptance Scenarios**:

1. **Given** an available Reference Architecture with matching objectives, controls, NFRs, or capabilities, **When** Discovery runs, **Then** it records the Reference Architecture identifier, confidence, and match reasons.
2. **Given** two options with equal scores, **When** one option has a Reference Architecture match and the other does not, **Then** Discovery recommends the matched option.
3. **Given** two equally scored options with no Reference Architecture match, **When** Discovery recommends an option, **Then** it chooses the lower Discovery-scoped `OPT` identifier.
4. **Given** an absent or unreadable optional Reference Architecture baseline, **When** Discovery runs, **Then** it continues with an empty match set and does not fail the analysis.
5. **Given** an option score, **When** the recommendation is rendered, **Then** it includes Objective Alignment 30, NFR Alignment 30, Control Alignment 20, Profile Alignment 10, Risk Reduction 10, and a total no greater than 100.

### User Story 3 - Hand analysis to ADR without making a decision (Priority: P1)

An ADR workflow consumes the completed Discovery, including its options, recommendation, rationale, and Reference Architecture matches, while retaining authority to accept or reject the recommendation and select any option.

**Why this priority**: Discovery must improve architectural decision preparation without silently becoming the decision record.

**Independent Test**: Given a completed Discovery, inspect the handoff contract and verify that ADR receives the complete analysis and must record selected and rejected options, recommendation acceptance, rejection rationale when applicable, and consequences in the ADR artifact.

**Acceptance Scenarios**:

1. **Given** a completed Discovery, **When** ADR consumes it, **Then** ADR receives the Discovery identifier, all option identifiers, recommendation rationale, and Reference Architecture matches without repeating Discovery analysis.
2. **Given** an ADR reviewer rejects the recommendation, **When** ADR is recorded, **Then** ADR records the selected option, rejected option identifiers, rejection rationale, and consequences.
3. **Given** a Discovery recommendation, **When** the Discovery artifact is written, **Then** it labels the recommendation advisory and contains no selected option, rejected option, approval, or architecture decision.
4. **Given** a failed option or recommendation calculation, **When** Discovery aborts, **Then** no partial output is written and existing bytes remain unchanged.

### Edge Cases

- A Request has explicit strategies but only one viable distinct option after deduplication; Discovery aborts because at least two options are required.
- Desired Change contains no strategy; options are derived from Objectives, Controls, NFRs, Research Findings, and available Reference Architectures in the defined precedence order.
- More than five viable options are discovered; only the deterministically preferred five are retained and the truncation is recorded as an analysis boundary.
- Two source strategies normalize to the same option; they produce one deduplicated option with combined supporting evidence.
- A Reference Architecture has a malformed identifier or duplicate catalog entry; it is excluded from matches and the analysis records the invalid-baseline reason without mutating the baseline.
- A Reference Architecture match operation fails; Discovery continues with an empty match set.
- A recommendation score component cannot be calculated; Discovery aborts and preserves existing bytes.
- Sensitive data appears in Request, governance, Profile, or Reference Architecture input; it is excluded before option or recommendation output is constructed.
- An ADR chooses an option other than the recommendation; Discovery remains unchanged and ADR records the divergence.

## Requirements

### Functional Requirements

- **FR-001**: The `highway-discovery` workflow MUST preserve its existing explicit completed-Request resolution and deterministic analysis behavior.
- **FR-002**: The workflow MUST remain authoritative for invocation behavior, analysis behavior, deterministic option generation, recommendation generation, and ADR handoff behavior.
- **FR-003**: The workflow MUST treat Request lifecycle completion as owned by the Request workflow; Discovery MUST consume the resolved Request without defining or changing its completion state.
- **FR-004**: The workflow MUST load optional closed inputs in this order: Profile, Objective, Control, NFR, and Reference Architecture.
- **FR-005**: Missing optional Reference Architectures MUST produce an empty match set and MUST NOT fail Discovery.
- **FR-006**: Discovery MUST generate Research Findings, Assumptions, Risks, Unknowns, Candidate Solution Options, a Candidate Solution Comparison Matrix, a Recommendation, Objective Relationships, Control Relationships, NFR Relationships, and Reference Architecture Matches.
- **FR-007**: Discovery MUST generate candidate options from explicit Desired Change strategies first, then strategies implied by Objectives, Controls, NFRs, Research Findings, and available Reference Architectures.
- **FR-008**: Each generated option MUST represent a distinct architecture approach and MUST contain an option identifier, title, summary, benefits, risks, assumptions, dependencies, and supporting evidence.
- **FR-009**: Each option identifier MUST use the format `OPT` followed by exactly six digits.
- **FR-010**: Discovery-scoped option identifiers MUST remain stable within the Discovery record and MUST be assigned only after deterministic option sorting.
- **FR-011**: For identical closed inputs, Discovery MUST produce identical option content, ordering, identifiers, Reference Architecture matches, and recommendation output.
- **FR-012**: Discovery MUST produce exactly three options when three viable options exist.
- **FR-013**: Discovery MUST produce between two and five options when the number of viable options differs from three but is at least two.
- **FR-014**: Discovery MUST sort options by Desired Change alignment, Objective alignment, constraint alignment, and alphabetical title order, in that precedence order.
- **FR-015**: Discovery MUST retain no more than five options and MUST record when viable options were excluded by the bound.
- **FR-016**: Discovery MUST abort when fewer than two viable distinct options can be generated and MUST preserve existing bytes.
- **FR-017**: Discovery MUST match each Reference Architecture candidate using the deterministic rules defined in Reference Architecture Match Evaluation and MUST report every candidate that matches at least one rule.
- **FR-018**: Each Reference Architecture match MUST include its identifier, confidence, and match reason or reasons.
- **FR-019**: Reference Architecture matching MUST be advisory and MUST NOT create, modify, approve, or remove a Reference Architecture.
- **FR-020**: Discovery MUST calculate recommendation scores using Objective Alignment 30, NFR Alignment 30, Control Alignment 20, Profile Alignment 10, and Risk Reduction 10, for a maximum of 100.
- **FR-021**: Discovery MUST recommend exactly one option when at least two viable options exist.
- **FR-022**: Discovery MUST include the score components, total score, confidence, rationale, and Reference Architecture match identifiers in the Recommendation section.
- **FR-023**: When option scores tie, Discovery MUST prefer the option linked to an existing Reference Architecture.
- **FR-024**: When tied options have no Reference Architecture match, Discovery MUST prefer the lower Discovery-scoped option identifier. When tied options are all linked to Reference Architectures, Discovery MUST prefer the option whose matched Reference Architecture has the highest matching Reference Implementation count; for an option with multiple matches, its tie-break count is the highest count among those matches. If the counts are equal, Discovery MUST prefer the lower Discovery-scoped option identifier.
- **FR-025**: Discovery MUST label the recommendation advisory and MUST NOT record an architecture decision, selected option, rejected option, approval, or implementation authorization.
- **FR-026**: ADR handoff MUST provide the Discovery identifier, Candidate Solution Options, option identifiers, Recommendation, recommendation rationale, and Reference Architecture Matches.
- **FR-027**: ADR MUST remain responsible for recording the selected option, rejected option identifiers, whether the recommendation was accepted, rejection rationale when applicable, and consequences.
- **FR-028**: ADR MUST be allowed to select any candidate option regardless of the Discovery recommendation.
- **FR-029**: Discovery MUST preserve its existing privacy-first redaction, deterministic serialization, catalog-authoritative allocation, bounded retry, and no-partial-write behavior.
- **FR-030**: Discovery MUST NOT create or modify Requests, Objectives, Controls, NFRs, Reference Architectures, ADRs, Reference Implementations, or governance relationships.
- **FR-031**: Discovery MUST use the complete shared Discovery record and catalog templates and add the Candidate Solution Options, Candidate Solution Comparison Matrix, Recommendation, and Reference Architecture Matches sections in the defined order.
- **FR-032**: Every successful Discovery record MUST contain between two and five unique `OPT` identifiers and exactly one recommended `OPT` identifier.
- **FR-033**: Every successful Discovery record MUST reference exactly one `REQ` identifier and remain eligible for exactly one future ADR handoff.
- **FR-034**: Recommendation generation MUST abort and preserve existing bytes when any required score component cannot be calculated.
- **FR-035**: Reference Architecture evaluation MUST treat an absent or unreadable Reference Architecture as an empty match set, exclude a malformed artifact and continue, and continue with an empty match set while recording the blocking reason in Discovery findings when the Reference Architecture catalog is internally inconsistent.
- **FR-036**: Reference Architecture matching MUST use only the deterministic matching rules defined in Reference Architecture Match Evaluation.
- **FR-037**: Discovery MUST derive recommendation confidence from the total recommendation score using the defined Recommendation Confidence table.
- **FR-038**: Objective, NFR, Control, Profile, and Risk scores MUST be calculated using the Score Calculation formulas.
- **FR-039**: The recommendation total MUST equal the sum of the five calculated scores.
- **FR-040**: Discovery-scoped `OPT` identifiers MUST remain stable within the generated Discovery artifact that contains them.
- **FR-041**: The recommended `OPT` identifier MUST exist within the Discovery record's Candidate Solution Options section.
- **FR-042**: Discovery recommendations are advisory analysis outputs and MUST NOT authorize implementation, Architecture Decisions, Reference Architectures, or governance changes.
- **FR-043**: When a score component has no applicable source artifacts, the score component MUST evaluate to zero.
- **FR-044**: Objective Alignment Score calculations MUST use the Objective Alignment Matching rules.
- **FR-045**: Control Alignment Score calculations MUST use the Control Alignment Matching rules.
- **FR-046**: NFR Alignment Score calculations MUST use the NFR Alignment Matching rules.
- **FR-047**: Profile Alignment Score calculations MUST use the Profile Alignment Matching rules.
- **FR-048**: Risk Reduction Score calculations MUST use the Risk Reduction Matching rules.
- **FR-049**: Recommendation scores MUST remain within the range 0 through 100 inclusive.
- **FR-050**: Discovery MUST generate a Candidate Solution Comparison Matrix.
- **FR-051**: The Candidate Solution Comparison Matrix MUST include every generated Candidate Solution Option.
- **FR-052**: The Candidate Solution Comparison Matrix MUST include every score component used to generate the Recommendation.
- **FR-053**: The Candidate Solution Comparison Matrix MUST include the total score for every Candidate Solution Option.
- **FR-054**: The Candidate Solution Comparison Matrix MUST identify Reference Architecture matches.
- **FR-055**: The Recommendation section MUST reference the same score values shown in the Candidate Solution Comparison Matrix.
- **FR-056**: Informational comparison categories MUST be calculated using the Deterministic Informational Categories rules.
- **FR-057**: Complexity classifications MUST be derived only from Dependency Count.
- **FR-058**: Governance Impact classifications MUST be derived only from matched governance artifacts.
- **FR-059**: Operational Overhead classifications MUST be derived only from operational dependency categories.
- **FR-060**: Informational comparison categories MUST NOT contribute to Recommendation scoring.
- **FR-061**: Exactly one Candidate Solution Option MUST be marked Recommended within the Candidate Solution Comparison Matrix.
- **FR-062**: Candidate Solution Comparison Matrix option columns MUST appear in the same deterministic order used by Candidate Solution Options.

### Reference Architecture Match Evaluation

Reference Architecture matching MUST evaluate candidates using the following precedence order:

1. Explicit Reference Architecture identifier reference.
2. Exact normalized title match.
3. Exact capability identifier match.
4. Exact Objective identifier match.
5. Exact Control identifier match.
6. Exact NFR identifier match.

If none of the above produce a match, no match exists.

Discovery MUST evaluate each Reference Architecture candidate independently. When a candidate matches more than one rule, its match MUST record the highest-precedence matching reason. All candidates with at least one match MUST be included in Reference Architecture Matches.

### Recommendation Tie-Break Evaluation

When equally scored options are all linked to Reference Architectures, Discovery MUST compare the number of Reference Implementations associated with each matched Reference Architecture in the authoritative Reference Implementation catalog. For an option with multiple matched Reference Architectures, its tie-break count MUST be the highest Reference Implementation count among those matches. If the catalog is absent or unreadable, each count MUST be treated as zero. The option with the highest tie-break count MUST be preferred. If the counts are equal, Discovery MUST prefer the lower Discovery-scoped `OPT` identifier.

### Recommendation Confidence

Recommendation confidence is derived from the final recommendation score:

| Total score | Confidence |
| --- | --- |
| 90-100 | High |
| 70-89 | Medium |
| 0-69 | Low |

### Score Calculation

**Objective Alignment Score**

30 x (matched Objectives / total Objectives), rounded down to whole numbers.

**NFR Alignment Score**

30 x (matched NFRs / total NFRs), rounded down to whole numbers.

**Control Alignment Score**

20 x (matched Controls / total Controls), rounded down to whole numbers.

**Profile Alignment Score**

10 x (matched Profile categories / evaluated Profile categories), rounded down to whole numbers.

**Risk Reduction Score**

10 x (mitigated Risks / identified Risks), rounded down to whole numbers.

### Score Calculation Defaults

When a score denominator is zero, the corresponding score component evaluates to zero:

- Objective Alignment Score = 0
- NFR Alignment Score = 0
- Control Alignment Score = 0
- Profile Alignment Score = 0
- Risk Reduction Score = 0

Division by zero MUST NOT occur.

### Objective Alignment Matching

An Objective matches a Candidate Solution Option when one or more of the following conditions are true:

1. The Objective identifier is explicitly referenced within the option.
2. The Objective appears within the option Supporting Evidence section.
3. The Objective identifier is referenced by a matching Reference Architecture.

### Control Alignment Matching

A Control matches a Candidate Solution Option when one or more of the following conditions are true:

1. The Control identifier is explicitly referenced within the option.
2. The option explicitly states that the Control is satisfied.
3. A matching Reference Architecture references the Control.

### NFR Alignment Matching

An NFR matches a Candidate Solution Option when one or more of the following conditions are true:

1. The NFR identifier is explicitly referenced within the option.
2. The option explicitly states that the NFR is satisfied.
3. A matching Reference Architecture references the NFR.

### Profile Alignment Matching

Profile Alignment evaluates the following categories when present:

- approved technologies
- architecture principles
- strategic directions
- operating model

A category is matched when the option explicitly aligns with the category.

### Risk Reduction Matching

A Discovery Risk is considered mitigated when the option explicitly identifies the risk and explicitly describes a mitigation.

Unmentioned risks are not mitigated.

### Recommendation Score Range

The recommendation score range is 0 through 100 inclusive. A recommendation score MUST NOT be negative and MUST NOT exceed 100.

### Reference Architecture Matching Scope

Version 1 Reference Architecture matching is intentionally limited to deterministic exact-match evaluation. Semantic matching, similarity matching, and inference-based matching are excluded from Version 1.

### Key Entities

- **Candidate Solution Option**: A distinct architecture approach with a Discovery-scoped `OPT` identifier, descriptive fields, evidence, and deterministic alignment metadata.
- **Recommendation**: An advisory selection of one `OPT` identifier with deterministic score components, total, confidence, rationale, and Reference Architecture evidence.
- **Reference Architecture Match**: An advisory relationship to an existing Reference Architecture with confidence and one or more deterministic match reasons.
- **Candidate Solution Comparison Matrix**: An advisory side-by-side comparison of every Candidate Solution Option, its scoring data, total score, Reference Architecture matches, and recommendation status.
- **ADR Handoff**: The complete Discovery payload consumed by ADR without repeating analysis.
- **Discovery Analysis Boundary**: The boundary that keeps Discovery advisory and prevents it from recording architecture decisions or governance mutations.

## Candidate Solution Comparison Matrix

The Candidate Solution Comparison Matrix provides a side-by-side comparison of all Candidate Solution Options and the scoring data used to generate the Recommendation.

The matrix is advisory. The matrix does not make an architecture decision.

The Discovery output order is:

Candidate Solution Options

Candidate Solution Comparison Matrix

Recommendation

The Candidate Solution Comparison Matrix MUST include:

- every Candidate Solution Option
- every Recommendation scoring category
- score values
- total scores
- Reference Architecture matches
- recommendation indication

The matrix MUST be generated before the Recommendation section.

The matrix MUST include the following metadata for every option:

- Option Identifier
- Option Title
- Total Score
- Reference Architecture Match
- Recommendation Status

Recommendation Status MUST be either `Recommended` or `Not Recommended`.

The matrix MUST include Complexity, Governance Impact, and Operational Overhead in every Version 1 matrix. It MAY also include informational categories such as Dependency Count and Existing Reference Architecture Alignment. All informational categories MUST be calculated using the Deterministic Informational Categories rules and MUST NOT influence Recommendation score, Recommendation confidence, Recommendation ranking, Recommendation selection, or option ordering.

The matrix MUST use the same score values as the Recommendation section. The matrix and Recommendation MUST contain identical score values.

Example matrix structure:

| Criteria | Weight | OPT000001 | OPT000002 | OPT000003 |
| --- | --- | --- | --- | --- |
| Objective Alignment | 30 | 20 | 30 | 10 |
| NFR Alignment | 30 | 30 | 25 | 15 |
| Control Alignment | 20 | 10 | 20 | 15 |
| Profile Alignment | 10 | 5 | 10 | 10 |
| Risk Reduction | 10 | 5 | 10 | 0 |
| Reference Architecture Match | Advisory | None | RA000014 | None |
| Total Score | 100 | 70 | 95 | 50 |

Recommended: `OPT000002`.

### Deterministic Informational Categories

Informational comparison categories are advisory and are intended to assist ADR reviewers in comparing Candidate Solution Options. Informational categories MUST NOT contribute to Recommendation scoring.

Informational categories MUST be derived exclusively from data contained within the Discovery artifact. No informational category may use subjective judgment, semantic inference, randomness, time-dependent values, or environment-dependent values.

#### Complexity Classification

Complexity is derived from Dependency Count. Dependency Count equals the number of unique dependencies listed within the Candidate Solution Option.

| Dependency Count | Complexity |
| --- | --- |
| 0-2 | Low |
| 3-5 | Medium |
| 6 or more | High |

Complexity classifications MUST use this table.

#### Governance Impact Classification

Governance Impact is derived from the number of unique governance artifacts matched by the option. Governance artifacts are Objectives, Controls, NFRs, and Reference Architectures.

Governance Impact Count equals the total number of unique matched governance artifacts.

| Governance Impact Count | Governance Impact |
| --- | --- |
| 0-2 | Low |
| 3-5 | Medium |
| 6 or more | High |

Governance Impact classifications MUST use this table.

#### Operational Overhead Classification

Operational Overhead is derived from operational dependencies explicitly identified within the option. Operational dependency categories are Monitoring, Logging, Backup, Recovery, Scaling, Secrets Management, Identity Management, Networking, and Deployment Operations.

Operational Overhead Count equals the number of operational dependency categories referenced by the option.

| Operational Overhead Count | Operational Overhead |
| --- | --- |
| 0-2 | Low |
| 3-5 | Medium |
| 6 or more | High |

Operational Overhead classifications MUST use this table.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of successful Discovery records contain between two and five distinct Candidate Solution Options.
- **SC-002**: 100% of successful option identifiers match `OPT` followed by exactly six digits, are unique within the record, and remain stable across repeated identical analysis.
- **SC-003**: 100% of successful Discovery records contain exactly one Recommendation referencing one valid option identifier.
- **SC-004**: Repeated analysis of identical closed inputs produces byte-identical option ordering, option identifiers, Reference Architecture matches, recommendation scores, and recommendation rationale.
- **SC-005**: 100% of recommendation totals equal the sum of the five defined score components and do not exceed 100.
- **SC-006**: 100% of tie cases follow the Reference Architecture preference and lower-option-identifier fallback rules.
- **SC-007**: 100% of Discovery failures caused by insufficient options or incomplete recommendation scoring preserve existing Discovery and catalog bytes.
- **SC-008**: 100% of Reference Architecture matches are advisory and leave Reference Architecture, governance, Request, and Profile source bytes unchanged.
- **SC-009**: 100% of ADR handoffs expose the Discovery identifier, every option identifier, the recommendation, its rationale, and Reference Architecture matches without requiring repeated Discovery analysis.
- **SC-010**: 100% of Discovery records contain no selected option, rejected option, approval, or architecture decision.
- **SC-011**: 100% of Discovery recommendations reference exactly one `OPT` identifier present within the same Discovery artifact.
- **SC-012**: 100% of Discovery ADR handoffs expose:
	- Discovery identifier
	- Candidate Solution Options
	- `OPT` identifiers
	- Recommendation
	- Recommendation rationale
	- Reference Architecture Matches
- **SC-013**: 100% of successful Discovery artifacts contain a Candidate Solution Comparison Matrix.
- **SC-014**: 100% of Recommendation scores shown in the Candidate Solution Comparison Matrix match the scores used to generate the Recommendation.
- **SC-015**: 100% of generated Candidate Solution Options appear in the Candidate Solution Comparison Matrix.
- **SC-016**: 100% of Recommendations identify the same recommended `OPT` identifier in both the Recommendation section and the Candidate Solution Comparison Matrix.
- **SC-017**: 100% of Complexity classifications match the defined Dependency Count thresholds.
- **SC-018**: 100% of Governance Impact classifications match the defined governance artifact thresholds.
- **SC-019**: 100% of Operational Overhead classifications match the defined operational dependency thresholds.
- **SC-020**: 100% of Recommendation scores remain unchanged when informational comparison categories are added or removed.
- **SC-021**: 100% of Candidate Solution Comparison Matrices contain exactly one Recommended Candidate Solution Option.
- **SC-022**: 100% of Comparison Matrix option ordering matches Candidate Solution Option ordering.

## Verification Expectations

- Confirm every Candidate Solution Option appears in the Candidate Solution Comparison Matrix.
- Confirm every Recommendation scoring category appears in the matrix.
- Confirm matrix score totals equal the Recommendation totals.
- Confirm the recommended `OPT` identifier is identified in the matrix.
- Confirm Reference Architecture matches shown in the matrix match those shown elsewhere in the Discovery artifact.
- Confirm repeated identical inputs generate byte-identical matrices.
- Confirm Complexity classifications match Dependency Count thresholds.
- Confirm Governance Impact classifications match governance artifact thresholds.
- Confirm Operational Overhead classifications match operational dependency thresholds.
- Confirm informational categories do not affect Recommendation scoring.
- Confirm exactly one Candidate Solution Option is marked Recommended.
- Confirm matrix option ordering matches Candidate Solution Option ordering.
- Confirm repeated identical inputs produce identical informational classifications.

## Assumptions

- A completed Discovery artifact and its existing deterministic transaction behavior are available before this enhancement is implemented.
- Reference Architectures, when present, are repository-owned baseline artifacts with stable `RA` identifiers and a catalog or equivalent authoritative index; the exact storage convention will follow the repository's future Reference Architecture contract.
- Reference Architecture absence is a valid repository state and is not an error.
- Each option identifier MUST use the format `OPT` followed by exactly six digits. Option identifiers are stable within the Discovery artifact that generated them. A later Discovery execution may generate a different set of Candidate Solution Options and therefore a different set of `OPT` identifiers.
- Profile, Objective, Control, and NFR content remains advisory context for scoring and does not become mutable through Discovery.
- A viable option is one that is distinct, supported by at least one closed evidence domain, and has enough information to populate all required option fields.
- The score components are normalized deterministic assessments over closed evidence, not requester-authored numeric inputs.
- ADR is a later owning workflow and will define the persistent ADR record structure separately.
- Version 1 Reference Architecture matches are advisory only. A later workflow may introduce explicit Reference Architecture reuse decisions. Discovery does not make reuse decisions.
- Future versions may introduce semantic Reference Architecture matching. Version 1 intentionally restricts evaluation to deterministic exact matches.
- Recommendation acceptance tracking is owned by the future ADR workflow and will be validated by ADR requirements.
- Reference Architecture and Reference Implementation generation remain outside this feature.

## Scope Boundaries

### Included in Version 1

- Extension of `highway-discovery` from research summary to architectural analysis.
- Deterministic Candidate Solution Option generation and Discovery-scoped `OPT` identifiers.
- Candidate Solution Comparison Matrix generation with complete option and scoring coverage.
- Deterministic recommendation scoring, confidence, rationale, and tie-breaking.
- Advisory matching of existing Objectives, Controls, NFRs, Profile context, and optional Reference Architectures.
- Expanded Discovery output structure and complete ADR handoff contract.
- Preservation of existing privacy, transaction, deterministic-output, and governance-ownership boundaries.

### Excluded from Version 1

- ADR creation, approval, rejection, or decision recording.
- Creation, modification, or approval of Reference Architectures.
- Reference Implementation generation.
- Governance baseline mutation or relationship approval.
- Runtime architecture deployment or implementation.
- Human override of deterministic option ordering or recommendation scoring inside Discovery.

## Non-Goals

Discovery does not:

- make an architecture decision
- select or approve an implementation
- record selected or rejected options as an ADR
- create or modify Reference Architectures
- create or modify governance baselines
- authorize implementation
- replace ADR review
- replace Reference Architecture definition
