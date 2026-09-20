# Feature Specification: Request Solution Constraints

**Feature Branch**: `053-request-solution-constraints`

**Created**: 2026-09-20

**Status**: Draft

**Input**: User description: "Create a new spec to update the highway-new skill with a Solution Constraints evidence domain, intake questions, request-record fields, completeness behavior, and verification updates while leaving Discovery and ADR workflows unchanged."

## User Scenarios & Testing

### User Story 1 - Capture permitted solution classes and constraints (Priority: P1)

A requester describing a business need can state which broad solution classes may be considered and
which existing platforms, hosting environments,
vendors, procurement conditions, or regulatory conditions constrain the solution space, without
choosing an architecture or technology.

**Why this priority**: Discovery needs constraint evidence to exclude invalid candidates, while the
Request intake must remain focused on business requirements rather than recommendations.

**Independent Test**: Conduct an intake that reaches Solution Constraints and verify that the
requester receives one question at a time for permitted solution classes, existing platforms,
hosting, vendors, and regulatory or data-handling restrictions, with all supplied values recorded
as constraint evidence rather than preferences.

**Acceptance Scenarios**:

1. **Given** a request reaches the Solution Constraints domain, **when** the requester answers which solution classes are permitted, **then** the intake records one or more allowed solution classes from the user's list.
2. **Given** the requester has platform, hosting, vendor, or regulatory restrictions, **when** those answers are collected, **then** the intake records each restriction without converting it into a recommended solution or architecture.
3. **Given** the requester does not know a constraint value, **when** the answer is recorded, **then** `unknown` is accepted as valid evidence.
4. **Given** a requester identifies a preferred platform rather than a required platform, **when** the information is recorded, **then** it is stored as a preference and not as a requirement.
5. **Given** a requester identifies one or more relevant business systems, **when** the request is recorded, **then** those systems are preserved as known systems without inferring solution architecture.
6. **Given** a requester allows custom development and use of existing licensed products, **when** the requester prohibits new product purchases, **then** the restriction is recorded as a procurement constraint without eliminating custom-development candidates.

### User Story 2 - Complete and publish a constrained Request record (Priority: P1)

A repository owner receives a complete Request record whose evidence order includes Solution
Constraints after Business Constraints, with explicit fields that preserve empty arrays and unknown
values and make the constraints available to future Discovery work.

**Why this priority**: Durable, ordered evidence is necessary for later analysis and traceability;
unknown constraints must not prevent a business request from reaching Complete status.

**Independent Test**: Validate a Request containing all seven evidence domains, including empty
arrays and `unknown` values, and verify the record is structurally valid, marked complete, and
contains no Discovery recommendation or ADR decision.

**Acceptance Scenarios**:

1. **Given** the existing six evidence domains are complete and the Solution Constraints section exists, **when** each Solution Constraints field contains a value, an empty array, or `unknown`, **then** the Request may be marked Complete.
2. **Given** one or more Solution Constraints fields contain `unknown`, **when** completeness is evaluated, **then** the Request is not blocked solely by those unknown values.
3. **Given** the Request record is written, **when** its evidence sections are reviewed, **then** the seven domains appear in the defined order and no solution recommendation, architecture decision, or ADR authorization is added.
4. **Given** a list-shaped Solution Constraints field, **when** the requester explicitly states that no values apply, **then** the field is recorded as an empty array; **when** the requester cannot determine the value, **then** the field is recorded as `unknown`.

### Edge Cases

- A requester permits multiple solution classes; all allowed solution classes are retained without ranking them.
- A requester supplies no existing platform, hosting, vendor, or regulatory restriction; the corresponding field is represented by an empty array rather than omitted.
- A requester supplies `unknown` for any Solution Constraints field; the field remains valid and does not block completion.
- A requester names a preferred architecture, implementation pattern, or technology instead of a constraint; the intake records only constraint-shaped evidence and routes recommendation or architecture analysis to Discovery or ADR.
- A requester may permit custom development and use of existing products while prohibiting purchase of new products; procurement constraints preserve that distinction.
- A requester may name a preferred product or platform. The preference is captured as business context and MUST NOT be interpreted as a solution decision, recommendation, architecture selection, or ADR.
- A requester provides a sensitive regulatory or data-handling detail; the existing privacy rules continue to prevent secrets or regulated personal data from being written as request evidence.
- A malformed or incomplete Solution Constraints value is supplied; the intake asks for a replacement value or `unknown` without creating a partial record.

## Requirements

### Functional Requirements

- **FR-001**: The Request intake MUST collect a seventh evidence domain named `Solution Constraints` after `Business Constraints`.
- **FR-002**: The Solution Constraints domain MUST record one or more allowed solution classes from a user-owned list.
- **FR-002a**: The Solution Constraints domain MUST support multiple allowed solution classes without ranking them.
- **FR-002b**: The specification MUST treat allowed solution classes as an extensible list rather than a fixed set of boolean fields.
- **FR-003**: The Solution Constraints domain MUST record existing enterprise platforms that are required, when any are named.
- **FR-003a**: The Solution Constraints domain MUST distinguish required enterprise platforms from preferred enterprise platforms.
- **FR-004**: The Solution Constraints domain MUST record hosting restrictions, vendor restrictions, and regulatory or data-handling restrictions.
- **FR-004a**: The Solution Constraints domain MUST record procurement-related constraints that limit acquisition of products or services.
- **FR-004b**: The Solution Constraints domain MUST allow identification of known business systems relevant to the request.
- **FR-004c**: Known Systems are descriptive business context and MUST NOT be interpreted as architecture, implementation, integration, or platform decisions.
- **FR-005**: Each Solution Constraints field MUST accept a value, an empty array where the field is list-shaped, or `unknown`.
- **FR-005a**: The specification MUST treat empty arrays and unknown values as distinct evidence states. An empty array indicates no applicable values are known to exist. `unknown` indicates the requester cannot currently determine the value.
- **FR-006**: The intake MUST ask one natural-language question at a time for the Solution Constraints evidence.
- **FR-007**: The intake MUST preserve all permitted solution classes and restrictions without ranking, recommending, or selecting one.
- **FR-008**: A Request MUST be eligible for Complete status when the existing six domains are complete, the Solution Constraints section exists, and every Solution Constraints field contains a valid value, empty array, or `unknown`.
- **FR-009**: The Request record MUST render Solution Constraints after Business Constraints and before Completeness.
- **FR-010**: The Request record MUST represent the Solution Constraints fields as allowed solution classes, required platforms, preferred platforms, known systems, hosting restrictions, vendor restrictions, procurement constraints, and regulatory restrictions.
- **FR-011**: The Request workflow and examples MUST explain that Solution Constraints restrict Discovery's candidate space and do not express a preferred architecture, implementation, solution category, or technology.
- **FR-012**: The Request completeness validation and focused examples MUST cover populated, empty-array, and `unknown` Solution Constraints values.
- **FR-013**: The change MUST NOT modify Discovery recommendation logic, candidate classification, architecture generation, or tie-break behavior.
- **FR-014**: The change MUST NOT create or modify ADR decisions, selected solutions, selected architectures, rationale, consequences, or implementation authorization.
- **FR-015**: Existing Request identifier, catalog allocation, privacy, transaction, and byte-preservation behavior MUST remain unchanged.
- **FR-016**: Allowed solution classes and constraints define what Discovery may consider and MUST NOT be interpreted as recommendations, rankings, or preferred candidate solutions.
- **FR-017**: The absence of a Solution Constraint MUST NOT be interpreted as a preference, recommendation, ranking, or selection criteria by Request intake or downstream consumers.

### Key Entities

- **Solution Constraints Evidence**: The seventh ordered Request evidence domain describing permitted solution classes and explicit solution-space restrictions.
- **Solution Constraint Field**: One named field containing a scalar value, an empty array, or `unknown`.
- **Allowed Solution Classes**: A user-owned extensible list of solution classes permitted for consideration, without ranking.
- **Request Record**: The durable user-owned business request containing seven ordered evidence domains and completeness state.
- **Known Systems**: Systems currently involved in, affected by, referenced by, or participating in the business process described by the Request. Examples include Salesforce, SAP, SharePoint, Workday, and ServiceNow. Known Systems are descriptive business context, not architecture or implementation decisions.
- **Discovery Candidate Space**: The future consumer boundary that may use constraints to exclude invalid alternatives; this feature does not implement that evaluation.
- **ADR Decision**: The later decision artifact that owns selection, rationale, consequences, and authorization; this feature does not change it.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of newly completed Request records contain seven evidence headings in the prescribed order, including Solution Constraints after Business Constraints.
- **SC-002**: 100% of Solution Constraints intake cases preserve allowed solution classes, required platforms, preferred platforms, known systems, hosting restrictions, vendor restrictions, procurement constraints, and regulatory restrictions without requiring a recommendation or architecture choice.
- **SC-003**: 100% of Solution Constraints fields preserve the distinction between populated values, empty arrays, and `unknown` values, with zero completion failures caused solely by `unknown`.
- **SC-004**: 100% of focused Request validation examples cover populated restrictions, empty arrays, unknown values, and multiple permitted solution classes.
- **SC-005**: 100% of Request records produced by this change contain no Discovery recommendation, architecture selection, ADR decision, or implementation authorization.
- **SC-006**: 100% of existing Request allocation, privacy, transaction, catalog, and byte-preservation checks continue to pass after the enhancement.

## Assumptions

- The existing six Request evidence domains, question ordering, privacy rules, catalog allocation, and transaction behavior remain the baseline.
- Solution Constraints is required as a record section but its individual values may be unknown or empty arrays.
- The stable contract fields are `allowed_solution_classes`, `existing_platforms_required`, `existing_platforms_preferred`, `known_systems`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and `regulatory_restrictions`.
- Empty list-shaped fields are represented as empty arrays, while scalar or boolean fields may use `unknown`.
- Empty arrays and unknown values have distinct meanings. An empty array means the requester knows no values apply. Unknown means the requester does not know whether values apply.
- Solution Constraints are exclusionary constraints rather than selection criteria.
- Discovery will consume these constraints in a later feature; this feature only captures and validates the evidence.
- ADR remains the sole owner of solution and architecture decisions.

## Future Discovery Consumption

Future Discovery workflows may consume Solution Constraints to exclude invalid candidate solutions.

Allowed solution classes and constraints define eligibility, not preference.

Examples:

Allowed Solution Classes:
	- SaaS
	- Custom Development

means Discovery may evaluate both. It does not indicate either is preferred.

Similarly:

Hosting Restrictions:
	- Self Hosted

excludes cloud-only candidates. It does not rank remaining candidates.

Discovery retains ownership of candidate generation, classification, comparison, scoring,
recommendation, and architecture analysis.

## Scope Boundaries

### Included in Version 1

- Add the Solution Constraints evidence domain and its defined fields to Request intake, completeness validation, examples, and record output.
- Add the Solution Constraints question areas while preserving one-question-per-turn intake behavior.
- Preserve unknown and empty-array values as valid, non-blocking evidence.
- Add focused validation for the new domain and confirm existing Request behavior remains unchanged.

### Excluded from Version 1

- Discovery candidate generation, solution classification, recommendation scoring, tie-breaking, or architecture evaluation.
- Automatic ranking or prioritization of candidate solutions based on allowed solution classes.
- Interpreting absence of a hosting restriction as a cloud preference, absence of a vendor restriction as a vendor preference, or absence of a platform preference as a platform preference.
- ADR creation, decision recording, solution selection, architecture selection, rationale, consequences, or authorization.
- Questions about monoliths, microservices, event-driven architecture, domain-driven design, messaging patterns, API strategies, cloud implementation design, or database technologies.
- Ranking permitted solution classes or interpreting restrictions as preferences.
