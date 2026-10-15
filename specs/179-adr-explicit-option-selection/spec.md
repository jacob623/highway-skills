# Feature Specification: Explicit ADR Option Selection

**Feature Branch**: `179-adr-explicit-option-selection`

**Created**: 2026-10-15

**Status**: Draft

**Input**: User description: "Create a new specification for changing highway-adr so Discovery recommendations remain advisory and ADR requires an explicit option decision. ADR invocation must require exactly one DISC###### and one existing OPT######; missing or unsupported options must not create or allocate anything; ADR records the user's selected option; Discovery continues presenting recommendations, rationale, scores, and comparison information."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Make an Explicit Architecture Decision (Priority: P1)

As an architecture decision owner, I want to invoke ADR with one Discovery and one option that I explicitly chose, so the resulting decision records my decision rather than an inferred recommendation.

**Why this priority**: Explicit user ownership is the core governance boundary. Without it, a recommendation can silently become an architecture commitment.

**Independent Test**: Provide a valid Discovery identifier and an option identifier contained in that Discovery, then verify one ADR records the selected option, rationale, consequences, architecture commitment, and traceability.

**Acceptance Scenarios**:

1. **Given** an accepted Discovery containing `OPT000001` and `OPT000002`, **When** the owner invokes ADR with `DISC000001 OPT000002`, **Then** ADR records `Selected Option: OPT000002` and creates exactly one decision artifact.
2. **Given** a valid Discovery and selected option, **When** the ADR workflow completes, **Then** the record identifies the selection as user-provided and does not describe it as selected by score, recommendation, architecture match, or lower identifier.
3. **Given** a valid Discovery and selected option, **When** the ADR is created, **Then** the existing decision identifier, catalog entry, decision rationale, consequences, architecture commitment, and available traceability are preserved.

---

### User Story 2 - Choose from Discovery Options (Priority: P1)

As a decision owner who has supplied only a Discovery, I want to see every available option and the advisory recommendation before choosing, so I can make an informed decision without the system deciding for me.

**Why this priority**: The missing-option path is the primary protection against automatic decision inference and must be useful rather than merely rejecting the invocation.

**Independent Test**: Provide only `DISC000001` for a Discovery with multiple options and verify the decision prompt lists each option, its summary, the recommendation, and the choice request without creating or allocating an ADR.

**Acceptance Scenarios**:

1. **Given** a Discovery with multiple options, **When** the owner invokes ADR with only `DISC000001`, **Then** the response presents `Architecture Decision Required`, the Discovery identifier, all available options with summaries, the advisory recommended option, and asks which option to select.
2. **Given** a Discovery with one available option, **When** the owner invokes ADR without an option identifier, **Then** the response still requires explicit selection and does not infer the only option.
3. **Given** a missing-option response, **When** the owner does not yet select an option, **Then** no ADR identifier is allocated, no ADR record is created, and the ADR catalog is unchanged.

---

### User Story 3 - Reject Invalid or Ambiguous Decisions (Priority: P1)

As a governance owner, I want malformed, missing, duplicate, or out-of-Discovery inputs to stop before mutation, so invalid invocations cannot create an architecture commitment.

**Why this priority**: A decision boundary is only reliable when every invalid path preserves the pre-operation state.

**Independent Test**: Exercise missing Discovery, multiple Discoveries, missing option, multiple options, malformed identifiers, unknown identifiers, and an option belonging to another Discovery; verify actionable failure responses and byte-preserving no-write behavior.

**Acceptance Scenarios**:

1. **Given** `DISC000001` and `OPT999999` where the option is absent from that Discovery, **When** the owner invokes ADR, **Then** the workflow aborts with an unsupported-option response and performs no ADR write, catalog write, or identifier allocation.
2. **Given** an invocation with no Discovery or more than one Discovery identifier, **When** the owner invokes ADR, **Then** the workflow stops before processing and preserves all pre-operation ADR and catalog bytes.
3. **Given** an invocation with no option or more than one option identifier, **When** the owner invokes ADR, **Then** the workflow follows the missing-option prompt or rejects the ambiguous input without inferring a decision.
4. **Given** a valid Discovery and option but a Discovery that is unavailable or not accepted, **When** the owner invokes ADR, **Then** the existing readiness failure behavior applies and no ADR is created.

---

### User Story 4 - Preserve Advisory Discovery Guidance (Priority: P2)

As a decision owner, I want Discovery to continue showing recommendation evidence, so I can use candidate scoring and comparison without confusing those signals with the final decision.

**Why this priority**: Separating recommendation from decision preserves Discovery's value while preventing it from crossing the ownership boundary.

**Independent Test**: Review Discovery output for a recommendation, rationale, scores, and comparison matrix, then invoke ADR and verify those materials remain advisory context rather than selection logic.

**Acceptance Scenarios**:

1. **Given** a Discovery with evaluated candidates, **When** Discovery presents results, **Then** it includes the recommended option, recommendation rationale, scores, and comparison matrix.
2. **Given** a Discovery recommendation, **When** ADR receives an explicit user option, **Then** ADR records the explicit option even when it differs from the recommendation.
3. **Given** any Discovery recommendation, **When** ADR resolves an option, **Then** ADR does not rank, compare, or automatically replace the user's selected option.

### Edge Cases

- A Discovery contains no available options: ADR reports that no decision can be made and performs no writes.
- A Discovery contains options with duplicate identifiers or incomplete option details: ADR rejects the Discovery as invalid and preserves all bytes.
- The selected option exists in the repository but belongs to a different Discovery: ADR rejects it as unsupported for the supplied Discovery.
- The selected option matches the recommendation: ADR still requires and records explicit user selection.
- The selected option differs from the recommendation: ADR records the selected option and retains the recommendation only as advisory context.
- A valid invocation races with another ADR allocation: existing allocation-conflict retry and atomicity behavior remains unchanged.
- A malformed or unavailable recommendation is present: ADR may proceed from explicit valid selection without treating recommendation data as a decision requirement, while preserving the source condition as advisory context or risk according to existing rules.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The ADR invocation MUST contain exactly one explicit `DISC######` identifier.
- **FR-002**: The ADR invocation MUST contain exactly one explicit `OPT######` identifier when creating an ADR.
- **FR-003**: The selected option MUST exist within the supplied Discovery.
- **FR-004**: The ADR workflow MUST treat the user's selected option as the decision input.
- **FR-005**: The ADR workflow MUST record `Selected Option: OPT######` in the ADR record.
- **FR-006**: The ADR workflow MUST NOT infer an option from a Discovery recommendation, score, comparison, architecture match, or identifier ordering.
- **FR-007**: When only a valid Discovery is supplied, the workflow MUST present an explicit decision prompt instead of creating an ADR.
- **FR-008**: The missing-option prompt MUST identify the Discovery, list every available option and summary, identify the recommendation as advisory, and request a selection.
- **FR-009**: A missing-option path MUST allocate no ADR identifier and write no ADR or catalog bytes.
- **FR-010**: An unsupported option MUST abort without allocating an identifier or writing an ADR or catalog artifact.
- **FR-011**: Missing, duplicate, malformed, ambiguous, or unavailable Discovery input MUST preserve all pre-operation ADR and catalog bytes.
- **FR-012**: Missing, duplicate, malformed, or ambiguous option input MUST not produce an inferred decision.
- **FR-013**: Discovery MUST continue to provide a recommended option, recommendation rationale, scores, and comparison matrix.
- **FR-014**: ADR MUST preserve the distinction between advisory recommendation and explicit decision in its response and retained record.
- **FR-015**: ADR MUST retain existing accepted-Discovery validation, readiness validation, atomic persistence, ownership, identifier allocation, and traceability behavior except where this specification changes option selection.
- **FR-016**: ADR MUST NOT mutate the source Discovery or reinterpret its recommendation as a decision.
- **FR-017**: A selected option that differs from the recommendation MUST remain valid when it exists within the supplied Discovery.
- **FR-018**: The completion response MUST identify the ADR, source Discovery, selected option, record path, catalog path, and available upstream traceability.

### Key Entities

- **Discovery**: An accepted candidate set containing one or more options, candidate evidence, recommendation information, scoring, and comparison material.
- **Discovery Option**: A selectable candidate within a Discovery, identified by `OPT######` and described by a summary and supporting details.
- **ADR**: A durable architecture decision that records the user's selected option, decision rationale, consequences, architecture commitment, and traceability.
- **Recommendation**: Advisory Discovery output that helps the owner compare options but cannot establish an architecture decision.
- **Decision Selection**: The explicit option identifier supplied by the owner to ADR and retained as the selected option.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of ADR creation scenarios include exactly one user-supplied Discovery identifier and exactly one user-supplied option identifier.
- **SC-002**: 100% of missing-option and unsupported-option scenarios create zero ADR records, allocate zero ADR identifiers, and change zero ADR catalog bytes.
- **SC-003**: 100% of successfully created ADR records contain a `Selected Option` value matching the explicit option supplied by the owner.
- **SC-004**: 100% of tested cases where the selected option differs from the recommendation preserve the owner's selection without automatic replacement.
- **SC-005**: 100% of missing-option prompts list all available options, their summaries, the advisory recommendation, and the selection request.
- **SC-006**: At least 95% of reviewers can correctly distinguish Discovery recommendation from ADR decision ownership in a requirements walkthrough.
- **SC-007**: Existing valid ADR workflows retain their prior accepted-Discovery validation, traceability, atomicity, and completion response behavior, with no new invalid writes in regression coverage.

## Assumptions

- Discovery options have stable `OPT######` identifiers and are addressable within their source Discovery.
- A Discovery may contain one or many options; explicit selection is required even when only one option exists.
- Existing ADR validation and persistence behavior remains the baseline unless directly changed by the explicit-selection contract.
- Existing user-facing response conventions, identity context, and experience guidance continue to apply.
- Recommendation evidence may be displayed during decision prompting but is not required to be correct for a valid explicit option to remain user-owned; malformed source behavior follows existing source-validation rules.
- The first release changes ADR selection ownership and invocation behavior; it does not add a new option-generation or Discovery-scoring capability.
- No separate runtime service, datastore, deployment workflow, plan, task, or executable product artifact is part of this specification.

## Scope Boundaries

In scope:

- Explicit ADR invocation with one Discovery and one option.
- Missing-option decision prompting.
- Unsupported-option rejection and no-write behavior.
- ADR record language and traceability for user-owned selection.
- Preservation of Discovery recommendation outputs as advisory evidence.

Out of scope:

- Changing Discovery candidate generation, scoring, comparison, or recommendation algorithms.
- Adding new option types or changing option identity format.
- Allowing ADR to select an option automatically under any fallback rule.
- Redesigning accepted-Discovery readiness, ADR persistence, or architecture governance outside option ownership.
