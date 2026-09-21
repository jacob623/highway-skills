# Feature Specification: Discovery Solution Constraints

**Feature Branch**: `060-discovery-solution-constraints`

**Created**: 2026-09-21

**Status**: Draft

**Input**: User description: "Integrate Request Solution Constraints into highway-discovery so candidate generation, filtering, scoring, comparison, and recommendation respect explicitly declared solution boundaries while preserving Discovery and ADR ownership."

## Clarifications

### Session 2026-09-21

- Q: Should a candidate that does not use an `existing_platforms_required` platform be excluded before scoring, or remain eligible with a required-platform score of 0? → A: A candidate MUST be excluded before scoring when it does not satisfy one or more values in `existing_platforms_required`; excluded candidates appear in the Candidate Elimination Log. `existing_platforms_preferred` influences scoring only and MUST NOT eliminate a candidate.

## Discovery Inputs

Request Solution Constraints loaded from the completed Request:

- `allowed_solution_classes`
- `existing_platforms_required`
- `existing_platforms_preferred`
- `known_systems`
- `hosting_restrictions`
- `vendor_restrictions`
- `procurement_constraints`
- `regulatory_restrictions`

## User Scenarios & Testing

### User Story 1 - Generate candidates within declared solution boundaries (Priority: P1)

A requester can complete a Discovery analysis using a Request that declares allowable solution
classes and receive only candidates that belong to those classes, while an unknown allowable-class
value preserves the current unconstrained behavior.

**Why this priority**: Preventing invalid candidates at the point of generation is the primary value
of consuming Request Solution Constraints.

**Independent Test**: Run Discovery with known allowed classes, with `unknown`, and with an empty
allowed-class value; verify constrained generation, legacy behavior for `unknown`, and safe failure
for invalid input.

**Acceptance Scenarios**:

1. **Given** a completed Request with `allowed_solution_classes` containing SaaS and Workflow Platform, **when** Discovery generates candidates, **then** every generated candidate belongs to one of those classes and custom-application or infrastructure-buildout candidates are not generated.
2. **Given** a completed Request with `allowed_solution_classes` containing Custom Application, **when** Discovery generates candidates, **then** custom application variants may be generated and SaaS or commercial-package candidates are not generated.
3. **Given** a completed Request with `allowed_solution_classes` equal to `unknown`, **when** Discovery generates candidates, **then** candidate generation follows the existing unconstrained behavior.
4. **Given** `allowed_solution_classes` is empty or malformed, **when** Discovery starts, **then** it aborts before output allocation and preserves existing bytes.

### User Story 2 - Remove candidates that violate mandatory restrictions (Priority: P1)

A requester can see that hosting, vendor, procurement, and regulatory restrictions are applied
before scoring, so the comparison and recommendation contain only viable candidates.

**Why this priority**: Mandatory restrictions must prevent invalid options from reaching recommendation
rather than merely lowering their score.

**Independent Test**: Provide one candidate violating each restriction type and verify that each is
excluded with a specific reason and constraint in the Candidate Elimination Log.

**Acceptance Scenarios**:

1. **Given** an On Premises Only hosting restriction, **when** an Azure SaaS candidate is normalized and evaluated, **then** it is excluded for Hosting Restriction before scoring.
2. **Given** a No Google Cloud vendor restriction, **when** a Google SaaS candidate is evaluated, **then** it is excluded for Vendor Restriction before scoring.
3. **Given** a No New Purchases procurement constraint, **when** a new commercial product candidate is evaluated, **then** it is excluded for Procurement Constraint before scoring.
4. **Given** a Data Must Remain In Country regulatory restriction, **when** a cross-border SaaS candidate is evaluated, **then** it is excluded for Regulatory Restriction before scoring.
5. **Given** all generated candidates violate mandatory restrictions, **when** Discovery completes filtering, **then** it aborts without writing a record or catalog update.

### User Story 3 - Compare and recommend candidates with constraint traceability (Priority: P1)

A requester can review how required platforms, preferred platforms, and known systems affected
candidate evaluation, and can trace each retained candidate's satisfied and unsatisfied
constraints through the comparison and advisory recommendation.

**Why this priority**: Constraint-aware scoring improves the usefulness of viable alternatives while
preserving a transparent, non-authorizing Discovery recommendation.

**Independent Test**: Provide candidates with different platform and system alignment, then verify
constraint alignment scores, traceability fields, matrix columns, deterministic ordering, and an
advisory recommendation that excludes all violating candidates.

**Acceptance Scenarios**:

1. **Given** a candidate satisfies all required existing platforms, **when** constraint alignment is scored, **then** its required-platform match is 100; a candidate with partial or no required-platform satisfaction is excluded before scoring and appears in the Candidate Elimination Log.
2. **Given** a candidate uses a preferred existing platform, **when** constraint alignment is scored, **then** its preferred-platform score is 100; otherwise it scores 50, and the preference does not eliminate the candidate.
3. **Given** a candidate reuses a known system, **when** constraint alignment is scored, **then** reuse increases its score without eliminating candidates that do not reuse known systems.
4. **Given** a retained candidate, **when** the Discovery record is rendered, **then** it includes Constraint Alignment, Satisfied Constraints, and Unsatisfied Constraints, and the comparison matrix includes allowed class, constraint alignment, required-platform match, preferred-platform match, and Constraint Compliance.
5. **Given** multiple viable candidates, **when** Discovery recommends one, **then** the recommendation uses the updated weights Objective 25, NFR 25, Control 20, Constraint Alignment 20, and Risk Reduction 10, remains advisory, and never selects a candidate that violated a mandatory restriction.

### Edge Cases

- An optional Solution Constraint is unknown; it is treated as unspecified and does not create a violation.
- `allowed_solution_classes` contains multiple values; all values are treated as permitted without ranking them.
- A candidate matches a permitted class but violates a hosting, vendor, procurement, or regulatory restriction; the mandatory restriction wins and the candidate is excluded.
- A candidate does not satisfy one or more required platforms; it is excluded before scoring and appears in the Candidate Elimination Log with the required-platform constraint.
- A preferred platform is absent; the candidate remains eligible and receives the lower preferred-platform score.
- A known system is not reused; the candidate remains eligible and receives lower constraint alignment evidence.
- Constraint evidence includes sensitive values; existing privacy filtering redacts retained content before generation, scoring, comparison, or serialization.
- Constraint inputs are malformed, contradictory, or unreadable; Discovery aborts and preserves existing bytes.
- Identical Request Solution Constraints and other closed inputs produce identical candidate sets, scores, ordering, elimination logs, and recommendation output.
- No viable candidates remain after filtering; Discovery does not create a partial record, catalog row, recommendation, or ADR decision.

## Constraint Alignment Composition

Constraint Alignment Score is calculated only for retained candidates.

Mandatory constraints determine candidate eligibility. Constraint Alignment Score evaluates
surviving candidates and does not restore eliminated candidates.

## Requirements

### Functional Requirements

- **FR-001**: Discovery MUST consume these Request Solution Constraints fields: `allowed_solution_classes`, `existing_platforms_required`, `existing_platforms_preferred`, `known_systems`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and `regulatory_restrictions`.
- **FR-002**: Discovery MUST evaluate `allowed_solution_classes` before candidate generation; when the value is `unknown`, it MUST preserve existing unconstrained candidate-generation behavior.
- **FR-003**: When `allowed_solution_classes` is known, Discovery MUST generate only candidates belonging to an allowed class and MUST NOT treat the class list as a selection, ranking, approval, or recommendation.
- **FR-004**: Discovery MUST execute candidate processing in this order: generate candidate, normalize candidate, evaluate Solution Constraints, filter invalid candidates, then score remaining candidates.
- **FR-005**: Discovery MUST exclude any candidate violating `existing_platforms_required`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, or `regulatory_restrictions` before scoring, comparison, or recommendation.
- **FR-006**: Discovery MUST record every excluded candidate in a Candidate Elimination Log placed after Unknowns and before Candidate Solution Options, including candidate identity, excluded status, reason, and triggering constraint.
- **FR-006a**: Candidate Elimination Log entries MUST be ordered by candidate identifier, constraint category, then constraint identifier or value.
- **FR-007**: Discovery MUST abort with no output and preserve existing bytes when Solution Constraints are malformed, `allowed_solution_classes` is empty, or filtering leaves no viable candidates.
- **FR-008**: Discovery MUST calculate a dedicated Constraint Alignment Score in the range 0-100 for each retained candidate.
- **FR-009**: Required-platform alignment MUST score 100 for a retained candidate that satisfies the required-platform set; a candidate with partial or no required-platform satisfaction MUST be excluded before scoring and recorded in the Candidate Elimination Log.
- **FR-010**: Preferred-platform alignment MUST score 100 when a preferred platform is used and 50 when it is not used; preferred platforms MUST remain advisory and MUST NOT eliminate candidates.
- **FR-011**: Known-system alignment MUST be scored as follows:
	- Candidate reuses all declared known systems: 100.
	- Candidate reuses one or more declared known systems: 75.
	- Candidate reuses none of the declared known systems: 50.
	Known systems MUST NOT eliminate candidates.
- **FR-012**: Discovery MUST use the scoring weights Objective 25, NFR 25, Control 20, Constraint Alignment 20, and Risk Reduction 10, totaling 100.
- **FR-013**: Discovery output MUST include a `Request Solution Constraints` section containing all eight consumed fields and their retained values after privacy filtering. The fields MUST render in this exact order: `allowed_solution_classes`, `existing_platforms_required`, `existing_platforms_preferred`, `known_systems`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, `regulatory_restrictions`.
- **FR-014**: Every retained candidate MUST include Constraint Alignment, Satisfied Constraints, and Unsatisfied Constraints.
- **FR-015**: The Candidate Solution Comparison Matrix MUST include Allowed Solution Class, Constraint Alignment Score, Required Platform Match, Preferred Platform Match, and Constraint Compliance columns. Required Platform Match reports whether the candidate satisfied all required platforms. Retained candidates always report a value of 100 because candidates that fail required-platform evaluation are excluded before scoring. Constraint Compliance MUST report `Fully Compliant` or `Satisfied`; violating candidates do not reach the matrix and remain represented in the Candidate Elimination Log.
- **FR-016**: Discovery MUST NOT recommend a candidate that violates a mandatory hosting, vendor, procurement, or regulatory restriction; such candidates must already have been eliminated.
- **FR-017**: Discovery MUST preserve deterministic candidate generation, normalization, filtering, scoring, ordering, allocation, privacy, transaction, and source-byte behavior for identical closed inputs.
- **FR-018**: Discovery MUST remain responsible for candidate generation, scoring, comparison, and advisory recommendation; Solution Constraints MUST constrain the candidate space but MUST NOT select, approve, or create a solution.
- **FR-019**: ADR MUST remain responsible for architecture selection, rationale, consequences, decision recording, and authorization; this feature MUST NOT create or alter ADR decisions.
- **FR-020**: Discovery MUST preserve existing Request, Profile, Objective, Control, NFR, Reference Architecture, Reference Implementation, catalog, identifier, handoff, and source-immutability behavior except where this feature explicitly strengthens candidate constraints and score composition.

### Key Entities

- **Request Solution Constraints**: The eight-field evidence set supplied by a completed Request and consumed as closed Discovery input.
- **Allowed Solution Class**: A permitted broad candidate category that limits generation when known; it does not rank or select candidates.
- **Mandatory Constraint**: A hosting, vendor, procurement, or regulatory restriction whose violation excludes a candidate before scoring.
- **Constraint Alignment Score**: A deterministic 0-100 score representing alignment with retained scoring constraints after mandatory constraint filtering.
- **Candidate Elimination Log**: Ordered evidence of candidates removed by Solution Constraint evaluation, including reason and triggering constraint.
- **Candidate Solution Option**: A retained Discovery alternative with class, constraint traceability, score components, and advisory comparison data.
- **Comparison Matrix**: The deterministic comparison of retained candidates, including constraint-specific columns and the updated score model.
- **Advisory Recommendation**: Discovery's deterministic recommendation among viable candidates, without architecture selection or authorization.

## Verification

- Confirm candidates that fail `existing_platforms_required` never reach scoring.
- Confirm candidates that fail `existing_platforms_required` appear in the Candidate Elimination Log.
- Confirm retained candidates always report Required Platform Match = 100.
- Confirm known-system alignment uses the explicit 100/75/50 scoring table and known systems never eliminate candidates.
- Confirm Constraint Alignment Score is calculated only for retained candidates and cannot restore eliminated candidates.
- Confirm Request Solution Constraints fields render in the specified canonical order.
- Confirm Candidate Elimination Log entries use candidate identifier, constraint category, then constraint identifier or value ordering.
- Confirm the comparison matrix uses Constraint Compliance and reports only `Fully Compliant` or `Satisfied` for retained candidates.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of Discovery runs with known allowed solution classes generate no candidate outside the declared classes, while 100% of runs with `unknown` preserve the existing unconstrained candidate behavior.
- **SC-002**: 100% of candidates violating hosting, vendor, procurement, or regulatory restrictions are eliminated before scoring and appear in the Candidate Elimination Log with a reason and constraint.
- **SC-003**: 100% of retained candidates expose a Constraint Alignment Score from 0 through 100 plus satisfied and unsatisfied constraint traceability.
- **SC-004**: 100% of scoring results use weights Objective 25, NFR 25, Control 20, Constraint Alignment 20, and Risk Reduction 10, with totals from 0 through 100.
- **SC-005**: 100% of comparison matrices include Allowed Solution Class, Constraint Alignment Score, Required Platform Match, Preferred Platform Match, and Constraint Compliance, and the Request Solution Constraints section includes all eight consumed fields in canonical order.
- **SC-006**: 100% of recommendations exclude candidates that violate mandatory restrictions, and 0% of eliminated candidates appear as recommended options.
- **SC-007**: 100% of identical closed inputs produce identical candidate sets, elimination logs, scores, ordering, and recommendations.
- **SC-008**: 100% of malformed, empty-class, and zero-viable-candidate cases produce no partial Discovery output and preserve existing bytes.
- **SC-009**: 100% of focused verification cases confirm known-system influence is scoring-only using the explicit 100/75/50 table, preferred-platform influence is advisory, required-platform failures are eliminated before scoring and logged, retained Required Platform Match is 100, and ADR ownership is unchanged.

## Assumptions

- Feature 053 and the subsequent Request Solution Constraints cleanup define the authoritative field names and valid evidence states consumed here.
- A completed Request supplies the eight fields in closed, validated form; malformed present input is an error rather than an invitation to infer intent.
- An `unknown` optional constraint is equivalent to unspecified for the affected evaluation, while a known mandatory restriction is enforceable.
- Existing Discovery scoring, option bounds, reference matching, privacy filtering, catalog allocation, transaction behavior, and ADR handoff remain authoritative except for the explicit score-weight and candidate-filter changes in this feature.
- Constraint Alignment Score is derived deterministically from platform and known-system evidence; no semantic similarity, recency, randomness, or subjective interpretation is introduced.
- Existing source artifacts and governance baselines remain read-only, and all failure paths preserve existing bytes.
- No extension hooks are registered in `.specify/extensions.yml` for this invocation.

## Scope Boundaries

### Included in Version 1

- Consumption of the eight Request Solution Constraints fields by Discovery.
- Allowed-class-aware candidate generation and mandatory restriction filtering.
- Candidate Elimination Log and constraint-specific output traceability.
- Constraint Alignment Score, updated scoring weights, and comparison matrix columns.
- Recommendation exclusion guarantees, deterministic behavior, failure handling, and focused verification.

### Excluded from Version 1

- Selecting, approving, or authorizing a solution or architecture.
- Creating or changing ADR decisions, rationale, consequences, or implementation authorization.
- Changing Request intake or the Request Solution Constraints schema.
- Inferring unstated preferences from absent constraints or known systems.
- Replacing deterministic Discovery rules with semantic similarity, subjective interpretation, randomness, recency, or model preference.
- Mutating Request, Profile, Objective, Control, NFR, Reference Architecture, Reference Implementation, or other source baselines.
