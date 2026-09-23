# Feature Specification: Experience Contract Authority Clarification

**Feature Branch**: `084-experience-contract-authority`

**Created**: 2026-09-23

**Status**: Draft

**Input**: User description: "Clarify that the Interactive Workflow UX Contract is an interpretive and organizational layer rather than a second source of normative requirements, while preserving X2.2-X2.6 as the sole normative interaction rules."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Reviewers Can Identify the Contract's Authority (Priority: P1)

As a reviewer of the Highway Experience Standard, I want the Interactive Workflow UX Contract to state exactly what authority it has, so that I can distinguish shared interpretation and organization from additional normative requirements.

**Why this priority**: Preventing a second normative system is the central risk of this clarification and affects every skill that references the contract.

**Independent Test**: Read the Interactive Workflow UX Contract and verify that it explicitly describes itself as reusable guidance, identifies X2.2-X2.6 as the behavior it organizes, disclaims additional X-rule obligations and new X identifiers, and preserves skill-owned workflow responsibilities.

**Acceptance Scenarios**:

1. **Given** a reviewer opens the Interactive Workflow UX Contract, **when** the authority statement is read, **then** it identifies the contract as reusable interaction guidance that organizes and applies X2.2-X2.6.
2. **Given** the authority statement is reviewed, **when** its boundaries are checked, **then** it states that it creates no additional X-rule obligations, does not modify X2.2-X2.6 normative text, and introduces no new X identifiers.
3. **Given** a skill references the contract, **when** ownership is reviewed, **then** the skill remains responsible for its own workflow contract, artifact ownership, progress fields, terminality rules, and domain-specific behavior.

### User Story 2 - Guidance Does Not Read Like Duplicate Requirements (Priority: P1)

As a maintainer, I want the contract's guidance phrased as interpretation of named Experience Standard rules, so that readers do not mistake explanatory bullets for a second set of mandatory requirements.

**Why this priority**: Wording that sounds independently normative can create contradictory governance and make future reviews inconsistent.

**Independent Test**: Compare the contract bullets with X2.2, X2.3, X2.4, X2.5, and X2.6 and verify that the bullets explicitly identify the applicable rule or concept while preserving the rule text unchanged.

**Acceptance Scenarios**:

1. **Given** the next-action guidance is reviewed, **when** it is compared with the Experience Standard, **then** it identifies workflows applying X2.2 rather than presenting an unscoped new obligation.
2. **Given** activity and implementation-detail guidance is reviewed, **when** it is compared with the Experience Standard, **then** it identifies X2.3 and X2.6 as the governing rules.
3. **Given** single-question guidance is reviewed, **when** it is compared with the Experience Standard, **then** it identifies X2.4 and preserves supporting context as non-conflicting guidance.
4. **Given** ownership guidance is reviewed, **when** it is read, **then** it describes conventions used by aligned workflows rather than creating a new ownership rule namespace.

### User Story 3 - Applicability and Examples Are Consistent (Priority: P1)

As a reviewer of different Highway workflows, I want progress, exits, outcomes, and resume examples clearly labeled as illustrative or applicability guidance, so that analytical and guided workflows are evaluated consistently.

**Why this priority**: The same contract spans guided collection, analytical activity, and decision workflows; explicit examples reduce false compliance findings and artificial wizard behavior.

**Independent Test**: Review the contract's progress and outcome sections and verify that meaningful ordered work controls progress reporting, no-ordered-work workflows do not manufacture progress, and example values are visibly non-normative.

**Acceptance Scenarios**:

1. **Given** a workflow has meaningful ordered work, **when** progress applicability is reviewed, **then** completed/remaining counts, position-based progress, or equivalent domain-specific fields may be exposed.
2. **Given** a workflow has no meaningful ordered work, **when** progress applicability is reviewed, **then** it does not manufacture progress solely to satisfy the contract and may use the existing N5 interpretation for X2.5/X2.6 where applicable.
3. **Given** exits, outcomes, and resume values are reviewed, **when** the examples are read, **then** User Exit values, Owner Outcome values, and Resume Applicability values are presented as illustrative examples rather than new rule identifiers.
4. **Given** a reviewer searches for authoritative copies, **when** the Experience Standard and skill files are inspected, **then** exactly one authoritative contract exists in the Experience Standard and skills reference rather than duplicate it.

## Edge Cases

- The authority statement must not alter the normative wording or identifiers of X2.2-X2.6.
- Rule references must remain accurate if contract bullets wrap across lines or are reformatted.
- A progress example must not imply that every workflow is long-running or requires numeric stages.
- Illustrative User Exit, Owner Outcome, and Resume Applicability values must not be interpreted as additional status or X-rule namespaces.
- Skill-specific progress fields and ownership remain domain-specific even when the shared contract supplies common interpretive guidance.
- No second authoritative contract may be introduced in a skill file, standalone library file, generated adapter, or other governance artifact.

## Requirements *(mandatory)*

### Contract Authority

- **FR-001**: The Interactive Workflow UX Contract MUST state that it is the single reusable interaction guidance section for Interactive Workflows.
- **FR-002**: The contract MUST state that it organizes, scopes, and applies behavior described by X2.2 through X2.6, N5 applicability, and the defined concepts `Interactive Workflow`, `Guided information-collection workflow`, `Long-running activity`, and `Implementation details`.
- **FR-003**: As a contract authority declaration, the contract MUST state that it does not create additional X-rule obligations, modify X2.2-X2.6 normative text, or introduce new X rule identifiers.
- **FR-004**: The contract MUST state that skills remain responsible for their own workflow contracts, artifact ownership, progress fields, terminality rules, and domain-specific behavior.

### Interpretive Guidance

- **FR-005**: The next-action guidance MUST identify workflows applying X2.2 and MUST not present the guidance as an unscoped additional normative rule.
- **FR-006**: The implementation-detail and activity guidance MUST identify workflows governed by X2.3 and X2.6.
- **FR-007**: The single-question guidance MUST identify guided collection workflows applying X2.4 and MUST allow supporting context and examples without activating future unresolved questions.
- **FR-008**: The ownership guidance MUST describe conventions used by aligned workflows and MUST preserve authority within the owning workflow without creating a new rule namespace.

### Applicability and Examples

- **FR-009**: Progress guidance MUST state that workflows with meaningful ordered work may expose completed/remaining counts, position-based progress, or equivalent domain-specific fields.
- **FR-010**: Progress guidance MUST state that workflows without meaningful ordered work do not manufacture progress reporting solely to satisfy the contract and may record the existing N5 applicability for X2.5/X2.6 where relevant.
- **FR-011**: The contract MUST include, within or immediately beneath the Interactive Workflow UX Contract section, a subsection labeled exactly `Illustrative Examples (Non-Normative)` containing examples for User Exit values `pause`, `cancel`, and `stop responding`; Owner Outcome values `declined`, `aborted`, and `blocked`; and Resume Applicability values `Persisted owner evidence`, `Transient interaction state`, `New interaction`, and `Not Applicable`.
- **FR-012**: The contract MUST state that exactly one authoritative Interactive Workflow UX Contract exists within the Highway Experience Standard and that skills may reference but not duplicate it as a skill-owned interaction standard.

### Preservation and Validation

- **FR-013**: X2.2-X2.6 normative text, rule identifiers, tiers, Observables, samples, and N5 applicability MUST remain unchanged.
- **FR-014**: Feature validation MUST verify the authority statement, rule-attributed guidance, illustrative examples, meaningful-ordered-work applicability, uniqueness statement, and absence of duplicate authoritative copies.
- **FR-015**: Feature validation MUST preserve existing skill output contracts, ownership boundaries, generated correspondence, distribution packaging, and existing Experience Standard authority.
- **FR-016**: The feature MUST not add runtime dependencies, hidden persistence, automatic conversation observation, or a second governance authority.

### Key Entities *(include if feature involves data)*

- **Interactive Workflow UX Contract**: The single reusable guidance section that interprets and organizes existing Experience Standard interaction rules.
- **Normative Interaction Rule**: One of X2.2-X2.6 whose rule text and identifier remain authoritative and unchanged.
- **Illustrative Applicability Example**: A non-normative example of progress, User Exit, Owner Outcome, or Resume Applicability used to support consistent review.
- **Authoritative Contract Copy**: The one contract section in the Experience Standard; skill references are not additional authoritative copies.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of authority statements in the Interactive Workflow UX Contract explicitly identify it as reusable guidance and disclaim additional X-rule obligations, normative-text changes, and new X identifiers.
- **SC-002**: 100% of contract guidance bullets for next action, implementation details/activity, single-question collection, and ownership identify the applicable Experience Standard rule or interpretive boundary.
- **SC-003**: 100% of contract progress guidance distinguishes meaningful ordered work from workflows with no meaningful ordered work, with no requirement to manufacture progress.
- **SC-004**: 100% of the illustrative User Exit value lists contain exactly `pause`, `cancel`, and `stop responding`; 100% of the illustrative Owner Outcome value lists contain exactly `declined`, `aborted`, and `blocked`; and 100% of the illustrative Resume Applicability value lists contain exactly `Persisted owner evidence`, `Transient interaction state`, `New interaction`, and `Not Applicable`.
- **SC-005**: Validation verifies all of the following: exactly one authoritative Interactive Workflow UX Contract section exists; no second authoritative copy exists; skill references are references only; and references do not reproduce the complete contract.
- **SC-006**: X2.2-X2.6 identifiers and normative rows remain byte-identical before and after the clarification update.
- **SC-007**: Focused validation passes with zero authority ambiguity, duplicate-contract, rule-attribution, progress-applicability, or preservation failures.
- **SC-008**: The full repository validation suite and whitespace checks pass with no failures attributable to this feature.

## Assumptions

- Feature 083 remains the baseline implementation; this feature clarifies its contract wording rather than expanding the UX scope.
- The authoritative document remains `.highway/governance/experience-standard.md`.
- X2.2-X2.6 remain the sole normative interaction rules in scope; no X2.7 or other new X rule is introduced.
- Skills continue to own their domain-specific workflow contracts, output fields, ownership, and terminality behavior.
- Existing N5 applicability remains the interpretation for X2.5 and X2.6 when no long-running activity exists, while progress reporting is separately governed by meaningful ordered work applicability.
- The examples are non-normative and exist to improve reviewer consistency.
- Generated catalogs and adapters are regenerated only when source inputs require correspondence refresh.
- No extension hooks are registered unless a future setup adds `.specify/extensions.yml`.

## Out of Scope

- Changing the normative text, identifiers, tiers, samples, or Observables of X2.2-X2.6.
- Adding X2.7 or any new X rule identifier.
- Changing the Feature 083 skill-specific progress fields, outcome vocabulary, resume behavior, or ownership model beyond clarifying their interpretation.
- Adding new wizard behavior, hidden persistence, runtime dependencies, or conversation observation.
- Moving the contract to a standalone library file or duplicating it in skill-owned standards.
- Rewriting unrelated Experience Standard rules or user-owned governance content.
