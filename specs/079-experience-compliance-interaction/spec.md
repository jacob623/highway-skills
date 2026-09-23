# Feature Specification: Experience Compliance and Interaction Guidance

**Feature Branch**: `079-experience-compliance-interaction`

**Created**: 2026-09-23

**Status**: Draft

**Input**: User description: "Amend the Highway Skills Constitution with Experience Compliance and extend the Experience Standard with interaction rules for next-action focus, implementation-detail avoidance, single-question collection, progress disclosure, and activity-focused progress messages."

## Clarifications

### Session 2026-09-23

- Q: Should X2.2-X2.6 apply to workflows meeting the Interactive Workflow definition, with X2.5-X2.6 only when a long-running activity exists and otherwise N/A? → A: Apply X2.2-X2.6 to workflows meeting the Interactive Workflow definition. X2.5 and X2.6 are N/A when no long-running activity exists.

## Definitions

### Interactive workflow

A workflow that emits user-visible messages and expects a user response, decision, confirmation, approval, rejection, or other input.

### Long-running activity

A workflow that performs multiple user-visible phases or emits one or more intermediate progress messages before the final completion result.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Experience Compliance Is Governed (Priority: P1)

As a maintainer reviewing a new or amended Highway skill, I want the governing constitution to require applicable Experience Standard compliance so that user-visible behavior is reviewed alongside correctness and portability.

**Why this priority**: Without an explicit constitutional obligation, Experience Standard rules remain advisory and a skill can pass existing review while violating user-facing interaction expectations.

**Independent Test**: Read the constitution and verify that Experience Standard is defined, Experience Compliance is inserted after Shared Output Contracts with P10.1 and P10.2, precedence assigns it rank 9, the Compliance Review Protocol requires applicable X-rule review and resolution of every FAIL, Governance requires both compliance protocols before merge, and the Compliance Review Protocol defines how applicable Experience Standard verdicts are reported alongside constitutional verdicts.

**Acceptance Scenarios**:

1. **Given** the constitution Definitions section, **when** a maintainer looks up Experience Standard, **then** it identifies the Highway Experience Standard and the X rule namespace.
2. **Given** a new or amended skill, **when** merge readiness is reviewed, **then** the skill must pass the existing Compliance Review Protocol and all applicable Experience Standard rules.
3. **Given** a skill cannot satisfy an applicable Experience Standard rule, **when** the exception is reviewed, **then** the skill names the X rule and the exception condition explicitly.
4. **Given** correctness, portability, and experience requirements appear to conflict, **when** precedence is applied, **then** the documented rank ordering and security override determine the governing rule.
5. **Given** a review evaluates constitutional and experience rules, **when** the review output is generated, **then** applicable X-rule results appear using the same verdict vocabulary and evidence requirements as constitutional review output.

### User Story 2 - Interactive Workflows Prioritize the Next User Action (Priority: P1)

As a person using a Highway workflow, I want the opening response and each collection step to focus on what I need to do next, without exposing internal processing details or future stages I have not reached.

**Why this priority**: The first interaction determines whether the workflow is understandable, and premature implementation detail makes a guided workflow harder to complete.

**Independent Test**: Read the Experience Standard X2 Interaction section and its examples, then evaluate representative opening, collection, and progress messages against X2.2 through X2.6.

**Acceptance Scenarios**:

1. **Given** an interactive workflow that requests user action begins, **when** it emits its first content, **then** that content is a greeting, required question, required decision, or required error response.
2. **Given** an interactive workflow begins, **when** its opening response is reviewed, **then** it excludes workflow ownership, routing, validation logic, evaluation order, allocation logic, and internal processing unless the user requested those details.
3. **Given** a workflow is collecting information, **when** it asks for input, **then** it asks at most one unresolved collection question and does not introduce future workflow stages.
4. **Given** an operation is multi-stage or potentially lengthy, **when** it reports progress, **then** it identifies the current activity, phase, or step.
5. **Given** progress is reported, **when** the message is reviewed, **then** it describes work being performed and excludes reasoning, workflow mechanics, validation behavior, and internal orchestration.

### User Story 3 - Experience Guidance Is Concrete and Versioned (Priority: P2)

As a governance maintainer, I want the new interaction rules to be accompanied by rationale and representative compliant/non-compliant examples so that authors can apply them consistently and the amendment remains auditable.

**Why this priority**: Examples and rationale convert abstract interaction requirements into reviewable guidance while preserving the existing X namespace and versioning policy.

**Independent Test**: Inspect the Experience Standard amendment and verify X2.2 through X2.6, the rationale appended after X2.1, interactive-collection and long-running-activity examples, the minor version increment, and a synchronization record for the constitutional amendment.

**Acceptance Scenarios**:

1. **Given** the Experience Standard X2 section, **when** a maintainer reads it, **then** X2.2 through X2.6 each have an ID, one normative rule, an Observable, a tier, and the specified sample value.
2. **Given** the X2 rationale, **when** a maintainer reads it, **then** it explains next-action focus, implementation-detail boundaries, and why long-running progress is a permitted exception.
3. **Given** the illustrative examples, **when** an author compares compliant and non-compliant messages, **then** the examples demonstrate interactive collection and activity-focused progress without becoming normative rules.
4. **Given** the Experience Standard and constitution version histories, **when** the amendment is reviewed, **then** the Experience Standard receives a minor increment and the constitution records the requested additive principle change with an updated impact report.

## Edge Cases

- An opening response may include a required error response when prerequisites are invalid; it must not begin with internal processing narration.
- A collection prompt may contain supporting context, but it must contain no more than one unresolved question requiring an answer.
- A long-running operation may report progress more than once, but each update must name current activity rather than internal orchestration.
- A workflow requested specifically to explain its implementation may provide implementation details; X2.3 excludes them only unless requested.
- X2.2 through X2.6 apply to workflows meeting the Interactive Workflow definition; a workflow with no long-running activity records X2.5 and X2.6 as N/A.
- A workflow may contain multiple informational statements, but may present at most one unresolved collection question at a time while collecting evidence.
- Read-only, informational, inspection, readiness, status, and reporting workflows are not required to manufacture a next action solely to satisfy X2.2.
- The new principle must not duplicate rule text from the Experience Standard; it establishes constitutional compliance and exception-accountability obligations while the X document defines user-visible behavior.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Highway Skills Constitution MUST define **Experience Standard** as the Highway Experience Standard governing user-visible output and interaction behavior, with rule IDs in the X namespace.
- **FR-002**: The constitution MUST insert **X. Experience Compliance** after **IX. Shared Output Contracts**.
- **FR-003**: Principle X MUST contain P10.1 requiring every skill to comply with all applicable Experience Standard rules.
- **FR-004**: Principle X MUST contain P10.2 requiring a skill to identify any Experience Standard exception by X-rule and exception condition.
- **FR-005**: P10.1 and P10.2 MUST use the agent-checkable tier and MUST include the requested observables.
- **FR-006**: The constitution's Principle Precedence MUST assign Experience Compliance rank 9 and state that it governs user-visible behavior after correctness requirements are satisfied.
- **FR-007**: The Compliance Review Protocol MUST require review against every applicable X-rule and resolution of every FAIL before merge.
- **FR-007A**: The Compliance Review Protocol output shape MUST define how applicable Experience Standard rule results are reported alongside constitutional rule results.
- **FR-007B**: The Compliance Review Protocol MUST define how Experience Standard N/A determinations are reported, including X2.5 and X2.6 when no long-running activity exists.
- **FR-007C**: Applicable Experience Standard rules MUST use the same PASS, FAIL, and N/A verdict vocabulary defined by the Compliance Review Protocol.
- **FR-008**: Constitution Governance MUST require every new or amended skill to pass both the Compliance Review Protocol and all applicable Experience Standard rules before merge.
- **FR-009**: The Experience Standard X2 Interaction section MUST add X2.2 with the rule text "An Interactive Workflow MUST prioritize the user's next required action." Its Observable MUST state: "For Interactive Workflows, the first emitted content is a greeting, required question, required decision, or required error response. Read-only or informational workflows are N/A." The rule MUST use the agent-checkable tier and sample value `two`.
- **FR-010**: The Experience Standard X2 Interaction section MUST add X2.3 prohibiting an interactive workflow from beginning with implementation details unless requested, with the requested Observable, agent-checkable tier, and sample value `two`.
- **FR-011**: The Experience Standard X2 Interaction section MUST add X2.4 requiring a guided information-collection workflow to ask only the next required question, with the requested Observable, agent-checkable tier, and sample value `one`.
- **FR-012**: The Experience Standard X2 Interaction section MUST add X2.5 requiring a long-running activity to disclose current progress, with the requested Observable, agent-checkable tier, and sample value `one`.
- **FR-012A**: The Observable for X2.5 MUST explicitly state that the rule is N/A when no long-running activity exists.
- **FR-013**: The Experience Standard X2 Interaction section MUST add X2.6 requiring progress messages to describe activity rather than implementation, with the requested Observable, agent-checkable tier, and sample value `one`.
- **FR-013A**: The Observable for X2.6 MUST explicitly state that the rule is N/A when X2.5 is N/A.
- **FR-014**: The Experience Standard MUST append the requested X2.2-through-X2.6 rationale after the existing X2.1 rationale.
- **FR-015**: The Experience Standard MUST include non-normative examples for interactive collection and long-running activity, including compliant and non-compliant examples matching the specified content boundaries. The examples MUST include at least one N/A example demonstrating a workflow where X2.5 and X2.6 do not apply.
- **FR-016**: The Experience Standard amendment MUST use a minor version increment under its existing version policy.
- **FR-017**: The constitutional amendment MUST include an updated Sync Impact Report, record the version increment required by the authoritative versioning policy, and preserve repository version history.
- **FR-018**: The constitutional amendment MUST not restate the Experience Standard's X2 rule text; it may reference the standard and establish compliance/exception obligations only.
- **FR-019**: The feature MUST preserve existing X namespace uniqueness, tier vocabulary, precedence semantics, and non-goal boundaries unless a directly required amendment is recorded.
- **FR-020**: Focused validation MUST verify every requested constitution insertion, every X2.2-through-X2.6 field, rationale/example placement, required N/A example coverage, version impact record, and absence of stale or contradictory wording.
- **FR-020A**: Focused validation MUST verify that applicability, N/A conditions, and rule scope are internally consistent across definitions, assumptions, requirements, and examples.

### Key Entities *(include if feature involves data)*

- **Experience Standard Amendment**: A versioned Layer 2 governance document change adding interaction rules, rationale, examples, and its minor version impact.
- **Constitution Amendment**: A versioned governing document change adding the Experience Standard definition, Experience Compliance principle, precedence rank, review obligations, and governance wording.
- **Interaction Rule**: One of X2.2 through X2.6, each identified by stable X namespace ID, normative rule, Observable, tier, and sample count.
- **Exception Declaration**: A skill-level statement naming an applicable X-rule and the condition that displaces it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the requested constitution additions are present exactly once: the definition, Principle X, P10.1, P10.2, precedence rank 9, Compliance Review Protocol additions, and Governance replacement.
- **SC-001A**: 100% of applicable Experience Standard rules can be reported using the review protocol output format.
- **SC-001B**: 100% of applicable Experience Standard N/A outcomes can be reported using the review protocol output format.
- **SC-001C**: 100% of Experience Standard review results use the constitutional review verdict vocabulary without introducing additional verdict types.
- **SC-002A**: 100% of implementations of X2.5 and X2.6 define their N/A conditions explicitly.
- **SC-002**: 100% of X2.2 through X2.6 rows contain the specified ID, rule, Observable, `[agent-checkable]` tier, and sample value.
- **SC-003**: 100% of the specified X2 rationale and illustrative examples are present in the correct sections and are excluded from normative rule tables.
- **SC-003A**: The illustrative examples contain at least one valid N/A scenario for long-running activity rules.
- **SC-004**: 100% of applicable review samples can identify the user's next required action without reading internal workflow details.
- **SC-005**: 0 constitutional rule sentences duplicate the normative X2.2-through-X2.6 rule text.
- **SC-005A**: P10.1 and P10.2 reference Experience Standard compliance and exception accountability without reproducing normative X2 rule text.
- **SC-006**: The Experience Standard and Constitution version histories record the increments required by their respective versioning policies, and the Constitution Sync Impact Report records the additive amendment and baseline reconciliation.
- **SC-007**: Focused governance validation reports zero missing, duplicate, stale, or contradictory Feature 079 contract elements.
- **SC-008**: The full repository validation suite passes with no Feature 079-specific failures and no whitespace errors.
- **SC-009**: Unmodified existing skills remain valid without amendment solely due to Feature 079, while newly created or amended skills are evaluated against applicable Experience Standard requirements.
- **SC-010**: No Experience Standard rule has contradictory applicability, trigger, or N/A conditions across Feature 079 artifacts.

## Assumptions

- The existing `.highway/governance/experience-standard.md` remains the authoritative Experience Standard and receives the X2 amendment in place.
- The existing `.highway/governance/constitution.md` remains the authoritative Highway Skills Constitution and receives the Principle X amendment in place.
- Version increments are determined exclusively by the authoritative Constitution Versioning Policy and Experience Standard Versioning Policy.
- Existing X namespace IDs, precedence ordering, tier definitions, and non-goal statements remain authoritative unless explicitly amended by this feature.
- Applicability is determined using the Experience Standard trigger conditions, scope statements, and N/A rules rather than by skill category.
- X2.2 through X2.6 apply to workflows meeting the Interactive Workflow definition; X2.5 and X2.6 are N/A when no long-running activity exists.
- Existing readiness, inspection, dashboard, and informational outputs remain valid when they do not request user action.
- Existing unchanged skills are grandfathered and are not required to be modified solely because Experience Compliance becomes constitutionally governed.
- Grandfathering affects required modifications only. Existing unchanged skills may continue to exist without amendment, but newly reviewed or amended skills are evaluated against applicable Experience Standard requirements.
- Long-running activity classification is based on observable workflow behavior rather than artifact type or skill category.
- The new rules govern user-visible workflow form and progress communication, not the substantive content of user-owned governance artifacts.
- Examples are non-normative and are included to make the rules reviewable without creating additional rule IDs.
- No new runtime dependency, skill runner, persistence model, or user-owned governance artifact is introduced.

## Out of Scope

- Implementing a skill runner or automatically observing live agent conversations.
- Adding a second enforcement mechanism separate from the existing governance review and validation approach.
- Rewriting existing unchanged skills solely to conform to the new interaction rules. Compliance is required for newly created skills and skills amended after adoption of this feature. Existing unchanged skills remain valid until modified.
- Changing the substantive content, identifiers, priorities, or policies in user-owned governance artifacts.
- Renaming existing X rules or changing the existing Experience Standard namespace.
