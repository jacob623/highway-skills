# Feature Specification: Experience Rule Table Alignment

**Feature Branch**: `080-experience-rule-table-alignment`

**Created**: 2026-09-23

**Status**: Draft

**Input**: User description: "Create a new spec to convert Experience Standard X2.2-X2.6 into actual table rows, define guided information-collection workflow and implementation details, and improve the N/A example structure."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Reviewers Can Parse Every X2 Rule Consistently (Priority: P1)

As a governance reviewer, I want X2.2 through X2.6 represented as ordinary rows in the X2 rule table so that every interaction rule has the same visible structure and can be reviewed without interpreting free-form text.

**Why this priority**: Inconsistent rule representation makes the Experience Standard ambiguous and weakens reviewability of the newly adopted interaction requirements.

**Independent Test**: Inspect the Experience Standard X2 section and verify that X2.1 through X2.6 occur exactly once as rows under one table with ID, Rule, Observable, Tier, and Sample columns, and that no duplicate inline definitions remain outside the table.

**Acceptance Scenarios**:

1. **Given** the X2 Interaction section, **when** a reviewer reads the rule table, **then** X2.2, X2.3, X2.4, X2.5, and X2.6 appear as table rows alongside X2.1.
2. **Given** a rule row for X2.2 through X2.6, **when** its fields are reviewed, **then** the row preserves the approved rule text, Observable, `[agent-checkable]` tier, and sample value.
3. **Given** the Experience Standard contains explanatory prose after the X2 table, **when** the document is checked for duplicate definitions, **then** no second normative X2.2-X2.6 definition exists outside the table.

### User Story 2 - Applicability Terms Are Defined (Priority: P1)

As an agent or maintainer applying X2.3 and X2.4, I want the workflow classes and implementation-details boundary defined so that applicability decisions do not depend on interpretation of examples alone.

**Why this priority**: X2.3 and X2.4 use terms that currently lack formal definitions, creating inconsistent review outcomes across interactive workflows.

**Independent Test**: Read the Definitions subsection and verify exact definitions for Guided information-collection workflow and Implementation details, then confirm the X2.3 and X2.4 Observables use those concepts consistently.

**Acceptance Scenarios**:

1. **Given** an X2.4 review, **when** the workflow's purpose is evaluated, **then** evidence collection, answers, decisions, approvals, confirmations, and other required inputs are covered by the Guided information-collection workflow definition.
2. **Given** an X2.3 review, **when** a message contains internal mechanics, **then** ownership, routing, validation logic, evaluation order, allocation logic, processing, orchestration, and similar mechanics are within the Implementation details definition.
3. **Given** a workflow is interactive but does not primarily collect required user inputs, **when** applicability is assessed, **then** it is not classified as a Guided information-collection workflow solely because it accepts a response.

### User Story 3 - N/A Outcomes Are Reported Without Mislabeling (Priority: P2)

As a reviewer, I want the no-long-running-activity example separated from compliant and non-compliant examples so that N/A is reported as a distinct verdict rather than treated as either conformance state.

**Why this priority**: The current example table places N/A content in compliant/non-compliant columns, which conflicts with the Constitution's PASS/FAIL/N/A review model.

**Independent Test**: Inspect the interaction examples and verify that the no-long-running-activity case uses a two-column Scenario/Example form, explicitly records X2.5=N5 and X2.6=N5, and does not label the N/A example compliant or non-compliant.

**Acceptance Scenarios**:

1. **Given** a read-only status workflow with no intermediate activity, **when** its example is reviewed, **then** the example states that X2.5 and X2.6 are N/A and names N5.
2. **Given** the interaction examples, **when** a reviewer compares example categories, **then** compliant/non-compliant examples remain available for applicable behavior while the N/A scenario has its own Example column.
3. **Given** the Constitution's verdict vocabulary, **when** the Experience Standard examples are checked, **then** N/A is not presented as PASS or FAIL and no new verdict is introduced.

## Edge Cases

- X2.2 through X2.6 must not appear twice if existing explanatory prose is retained around the table.
- A workflow can be Interactive without being a Guided information-collection workflow; the definition must preserve that distinction.
- A prompt may include context and one unresolved question without becoming non-compliant under X2.4.
- Implementation details remain permitted when the user explicitly requests an implementation explanation under X2.3.
- X2.5 and X2.6 remain N/A when a workflow has no long-running activity; the example must not imply that every workflow requires progress updates.
- N/A examples must not be placed in compliant or non-compliant columns.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST represent X2.2, X2.3, X2.4, X2.5, and X2.6 as rows in the existing X2 Interaction table.
- **FR-002**: Each X2.2-X2.6 row MUST contain exactly one stable ID, one normative Rule, one Observable, one tier, and one Sample value under the existing table headers.
- **FR-003**: The X2.2-X2.6 row text MUST preserve the approved rule text, Observable wording, `[agent-checkable]` tier, and sample values from Feature 079.
- **FR-004**: The Experience Standard MUST NOT retain duplicate normative X2.2-X2.6 definitions outside the X2 table.
- **FR-005**: The Definitions subsection MUST define Guided information-collection workflow as an Interactive Workflow whose primary purpose is collecting user-provided evidence, answers, decisions, approvals, confirmations, or other required inputs.
- **FR-006**: The Definitions subsection MUST define Implementation details as information describing workflow ownership, routing, validation logic, evaluation order, allocation logic, internal processing, orchestration, or similar internal mechanics.
- **FR-007**: X2.3 and X2.4 Observables MUST use terminology consistent with their new definitions without expanding or narrowing the approved rule obligations.
- **FR-008**: The interaction examples MUST retain applicable compliant and non-compliant examples for interactive collection and long-running activity.
- **FR-009**: The no-long-running-activity example MUST use the N/A Scenario/Example structure rather than the compliant/non-compliant columns.
- **FR-010**: The N/A example MUST state that a read-only status workflow emits no intermediate activity and MUST record `X2.5=N5` and `X2.6=N5`.
- **FR-011**: The N/A example MUST remain non-normative and MUST NOT introduce a new verdict token, rule ID, or applicability condition.
- **FR-012**: The amendment MUST preserve the existing X namespace, X2.1 rule, N5 condition, versioning policy, and non-goal boundaries.
- **FR-013**: Focused validation MUST detect missing, duplicate, malformed, or out-of-table X2.2-X2.6 rows and MUST verify the new definitions and N/A example structure.
- **FR-014**: The feature MUST preserve unchanged skill behavior and MUST NOT require user-owned governance artifacts to change.

### Key Entities *(include if feature involves data)*

- **X2 Interaction Rule Row**: A stable X2.2-X2.6 table record containing ID, Rule, Observable, Tier, and Sample fields.
- **Workflow Definition**: A named applicability definition for Interactive Workflow, Guided information-collection workflow, Long-running activity, or Implementation details.
- **N/A Example**: A non-normative interaction example that records a permitted N/A condition without presenting N/A as PASS or FAIL.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of X2.1-X2.6 rules appear exactly once as rows in the X2 Interaction table.
- **SC-002**: 100% of X2.2-X2.6 rows contain the approved ID, Rule, Observable, `[agent-checkable]` tier, and Sample value.
- **SC-003**: 0 duplicate normative X2.2-X2.6 definitions remain outside the X2 table.
- **SC-004**: Both required workflow concepts have one definition each, and 100% of their references in X2.3/X2.4 use consistent terminology.
- **SC-005**: 100% of N/A examples place N/A in a distinct Example field and record both required N5 outcomes.
- **SC-006**: 0 new verdict tokens, X rule IDs, or N/A condition IDs are introduced by the amendment.
- **SC-007**: Focused governance validation reports zero missing, duplicate, malformed, or misplaced X2.2-X2.6 rows.
- **SC-008**: The existing repository validation suite passes without failures attributable to the table, definition, or example changes.

## Assumptions

- The authoritative source remains `.highway/governance/experience-standard.md`.
- Feature 079's approved X2.2-X2.6 wording, N5 condition, version policy, and constitutional review contract remain authoritative.
- This feature is a corrective documentation and validation amendment; it does not add a new runtime evaluator.
- Existing compliant and non-compliant examples remain useful and are retained unless their structure conflicts with the revised N/A example format.
- The Constitution's PASS/FAIL/N/A vocabulary and N5 condition remain unchanged.
- Unchanged skills are not rewritten solely because the Experience Standard's presentation is corrected.

## Out of Scope

- Changing the normative meaning of X2.2-X2.6.
- Adding new Experience Standard rules or N/A conditions.
- Implementing live conversation observation or automatic semantic classification of workflows.
- Rewriting existing skills or user-owned governance content.
- Changing the distribution manifest or packaging classification.
