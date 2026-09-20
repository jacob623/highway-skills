# Feature Specification: Discovery Analysis

**Feature Branch**: `048-discovery-artifact`

**Created**: 2026-09-19

**Status**: Draft

**Input**: User description: "Create a new Highway skill named highway-discovery to transform a completed business request into a durable Discovery artifact containing research findings, assumptions, risks, unknowns, candidate approaches, and advisory repository relationships."

## Clarifications

### Session 2026-09-19

- Q: Which completed Request should `highway-discovery` analyze when multiple completed Requests exist? → A: The invocation must identify exactly one completed Request by explicit `REQ` identifier.
- Q: How should Discovery derive its analysis sections from the Request and baselines? → A: Discovery must use deterministic rule-based analysis.

## User Scenarios & Testing

### User Story 1 - Create a Discovery from a completed request (Priority: P1)

A repository owner provides a completed business request to create a durable Discovery record that preserves the request as its business-evidence source and adds structured research-oriented analysis.

**Why this priority**: Discovery is the required stage between a completed request and later architecture decision work.

**Independent Test**: Given one completed `REQXXXXXX` request and an empty or bootstrapped Discovery catalog, invoke `highway-discovery` and verify that exactly one `DISCXXXXXX` record and one catalog entry are produced.

**Acceptance Scenarios**:

1. **Given** a completed request and no Discovery catalog, **When** Discovery analysis runs, **Then** it bootstraps `discoveries/discoveries.md`, allocates `DISC000001`, and writes one Discovery record and one catalog entry.
2. **Given** a completed request and an existing valid catalog, **When** Discovery analysis runs, **Then** it allocates the catalog's `Next ID`, advances it exactly once, and preserves the request's authoritative business evidence.
3. **Given** the same completed request and unchanged repository context, **When** Discovery analysis is repeated, **Then** the generated analysis and catalog content are deterministic.

### User Story 2 - Reject requests that are not ready (Priority: P1)

A repository owner attempts to create Discovery from an incomplete request and receives a clear refusal without any Discovery artifact or catalog mutation.

**Why this priority**: Discovery must not bypass business-request completion or create analysis from insufficient evidence.

**Independent Test**: Provide an incomplete request, invoke Discovery analysis, and compare the bytes and file set of the Discovery output location before and after the attempt.

**Acceptance Scenarios**:

1. **Given** an incomplete request, **When** Discovery analysis runs, **Then** it aborts, reports that a completed request is required, and writes neither a Discovery record nor a catalog update.
2. **Given** a missing or invalid request, **When** Discovery analysis runs, **Then** it aborts, identifies the actionable input problem, and leaves existing Discovery files unchanged.

### User Story 3 - Record advisory relationships and boundaries (Priority: P2)

A repository owner receives a Discovery that identifies potentially related Objectives, Controls, and NFRs while keeping those relationships advisory and leaving governance baselines unchanged.

**Why this priority**: Discovery should inform later decisions without taking ownership of governance or architecture changes.

**Independent Test**: Run Discovery against a completed request in a repository containing candidate Objectives, Controls, and NFRs, then verify that the Discovery records relationship candidates and rationale or confidence without modifying any governance artifact or creating a relationship.

**Acceptance Scenarios**:

1. **Given** matching repository Objectives, Controls, or NFRs, **When** Discovery analysis is completed, **Then** it records advisory relationship candidates in the corresponding sections.
2. **Given** no matching governance records, **When** Discovery analysis is completed, **Then** it preserves empty relationship sections without inventing governance records.
3. **Given** any Discovery relationship candidate, **When** the artifact is written, **Then** it is clearly advisory and does not mutate the relationship or its source baseline.

### Edge Cases

- The Discovery catalog is absent and must be bootstrapped with `Version: 1.0.0` and `Next ID: DISC000001`.
- The catalog `Next ID` is missing, malformed, or does not match `DISC` followed by exactly six digits; allocation aborts without writes.
- The catalog changes between allocation and validation; the exclusive allocation operation retries at most three times, then aborts without writes.
- Discovery artifact validation succeeds but catalog validation fails, or vice versa; neither output is written.
- A write failure occurs after output construction; existing request, Discovery, and catalog bytes remain unchanged.
- The request contains secrets or regulated personal data; those values are excluded from Discovery output and business-relevant replacement evidence is required.
- A request references architecture, ADR, Control, NFR, or Objective creation; Discovery analysis remains within its scope and does not create those artifacts.

## Requirements

### Functional Requirements

- **FR-001**: The `highway-discovery` skill MUST require exactly one explicit REQ identifier in the form REQ followed by exactly six digits as its source input, and that identifier MUST resolve to exactly one completed Request.
- **FR-002**: The skill MUST abort without writes when the explicit REQ followed by exactly six digits source identifier is missing, ambiguous, malformed, nonexistent, non-unique, incomplete, or otherwise cannot be resolved to exactly one completed Request.
- **FR-003**: The skill MUST treat the completed request as the authoritative source of business evidence.
- **FR-004**: The skill MUST create a Discovery record at `discoveries/DISCXXXXXX.md`.
- **FR-005**: The skill MUST create or update the authoritative catalog at `discoveries/discoveries.md`.
- **FR-006**: The catalog MUST bootstrap with `Version: 1.0.0` and `Next ID: DISC000001` when absent.
- **FR-007**: Discovery identifiers MUST use `DISC` followed by exactly six digits and MUST be allocated from the catalog's `Next ID`.
- **FR-008**: The Discovery record MUST contain sections for Request, Research Findings, Assumptions, Risks, Unknowns, Candidate Approaches, Objective Relationships, Control Relationships, and NFR Relationships.
- **FR-009**: The skill MUST use deterministic rule-based analysis to generate research findings, assumptions, risks, unknowns, and candidate approaches from the completed Request and these baselines when present: Profile, Objective, Control, and NFR.
- **FR-010**: The skill MUST identify potentially related Objectives, Controls, and NFRs without treating those candidates as approved relationships.
- **FR-011**: The skill MUST preserve relationship rationale and relationship confidence when those are identified.
- **FR-012**: The skill MUST NOT create, modify, or delete Objectives, Controls, NFRs, ADRs, architectures, reference architectures, or reference implementations.
- **FR-013**: The skill MUST keep all identified relationships advisory only and MUST NOT mutate relationship records or governance baselines.
- **FR-014**: The skill MUST build the Discovery record and catalog update in memory before writing either output.
- **FR-015**: The transaction MUST read the catalog, allocate an identifier, build the Discovery record, build the catalog update, validate both outputs, and write both outputs in that order.
- **FR-016**: If allocation, construction, validation, or writing fails, the skill MUST write nothing and preserve the original bytes of every existing output.
- **FR-017**: The skill MUST retry an exclusive allocation operation no more than three times when the catalog changes during allocation.
- **FR-018**: The skill MUST produce identical Discovery output for identical request input and unchanged repository context.
- **FR-019**: The skill MUST exclude secrets and regulated personal data from the Discovery record and request business-relevant replacement evidence when such data is encountered.
- **FR-020**: Version 1 MUST exclude ADR creation, architecture generation, Control generation, NFR generation, Objective creation, relationship mutation, readiness-contract implementation, and reference implementation generation.
- **FR-021**: A successfully created Discovery MUST become the primary input artifact for later `highway-adr` work without creating an ADR itself.
- **FR-022**: Discovery relationship candidates MUST be advisory observations only and MUST NOT establish traceability links.
- **FR-023**: Approval, creation, mutation, repair, and removal of relationships MUST belong to future relationship-owning workflows.
- **FR-024**: For identical Request, Profile, Objective, Control, NFR, and catalog inputs, Discovery output MUST be byte-identical.
- **FR-025**: The Discovery title MUST be derived deterministically from the source Request title.
- **FR-026**: If the Request contains an explicit title, the Discovery title MUST match it.
- **FR-027**: If the Request does not contain an explicit title, the Discovery title MUST be derived from the Request title-generation rules.
- **FR-028**: The Discovery catalog MUST follow the Discovery Catalog Structure.
- **FR-029**: The Discovery catalog MUST contain `Version`, `Next ID`, and `Discovery Index` sections.
- **FR-030**: Discovery records MUST use the complete structure defined in `.highway/library/templates/output/discovery-record.md`.
- **FR-031**: Discovery catalogs MUST use the complete structure defined in `.highway/library/templates/output/discovery-catalog.md`.
- **FR-032**: Every Discovery record MUST reference exactly one `REQ` identifier.
- **FR-033**: A future ADR generated from Discovery MUST reference exactly one `DISC` identifier.
- **FR-034**: The Discovery catalog MUST contain exactly these top-level sections: `Version`, `Next ID`, and `Discovery Index`.
- **FR-035**: Every Discovery Index entry MUST contain a Discovery ID, Request ID, and Discovery Title.
- **FR-036**: Discovery analysis MUST use deterministic rule-based extraction and matching rather than requester-authored or discretionary analysis.

## Discovery Record Contract

Every Discovery record MUST use this structure:

```markdown
---
id: DISCXXXXXX
request: REQXXXXXX
status: proposed
---

# Title

## Request

## Research Findings

## Assumptions

## Risks

## Unknowns

## Candidate Approaches

## Objective Relationships

## Control Relationships

## NFR Relationships
```

Relationship confidence, when present, MUST be one of:

- High
- Medium
- Low

Confidence assignment MUST follow these rules:

- **High**: The relationship is supported by an explicit identifier reference.
- **Medium**: The relationship is supported by title or statement matching.
- **Low**: The relationship is supported only by keyword overlap or contextual similarity.

## Discovery Catalog Contract

The Discovery catalog is authoritative for:

- version
- next_id
- discovery index

Identifier allocation MUST be derived only from the catalog's `Next ID`. Identifiers MUST NOT be
derived from filenames.

## Discovery Catalog Structure

```markdown
Version: X.Y.Z

Next ID: DISCXXXXXX

## Discovery Index

| Discovery ID | Request ID | Discovery Title |
|--------------|------------|-----------------|
| DISC000001 | REQ000001 | Example Discovery |
```

The catalog MUST contain no other top-level sections.

## Ownership Boundaries

`highway-discovery` owns:

- Discovery records
- Discovery catalog
- Discovery analysis
- Discovery relationships

`highway-discovery` does not own:

- Requests
- Objectives
- Controls
- NFRs
- ADRs
- Architectures
- Implementations
- Relationship mutation

## ADR Handoff Contract

A completed Discovery becomes the authoritative input to `highway-adr`.

ADR generation may consume:

- Request
- Discovery

ADR generation MUST NOT require re-performing Discovery analysis.

## Traceability Chain

The authoritative artifact lineage is:

```text
REQ
 ↓
DISC
 ↓
ADR
 ↓
Reference Architecture
 ↓
Reference Implementation
```

Each downstream artifact references exactly one upstream artifact of the preceding stage.

### Key Entities

- **Completed Request**: The authoritative business request identified by `REQXXXXXX`, including its completion state and six business-evidence domains.
- **Discovery Record**: A durable `DISCXXXXXX` artifact containing the request reference, analysis sections, candidate approaches, and advisory relationship candidates.
- **Discovery Catalog**: The authoritative allocation and index record stored at `discoveries/discoveries.md`, including version and next identifier.
- **Relationship Candidate**: An advisory reference from the Discovery to an existing Objective, Control, or NFR, optionally including rationale and confidence.
- **Candidate Approach**: A possible direction identified during Discovery without constituting an architecture or ADR decision.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Every valid completed request creates exactly one Discovery record and exactly one corresponding catalog entry.
- **SC-002**: Every invalid, incomplete, or failed analysis attempt creates zero new Discovery records and leaves existing Discovery catalog bytes unchanged.
- **SC-003**: 100% of successfully created Discovery identifiers match `DISC` followed by exactly six digits and are allocated from the catalog.
- **SC-004**: Repeated analysis of identical request and repository inputs produces byte-identical Discovery content and the same advisory relationship candidates.
- **SC-005**: 100% of generated Discovery records contain all nine required artifact sections.
- **SC-006**: 100% of Discovery relationship candidates are labeled or structured as advisory and no governance baseline is modified by Discovery analysis.
- **SC-007**: 100% of secrets and regulated personal data encountered during analysis are absent from the written Discovery record.
- **SC-008**: Repository owners can use a completed Discovery as the primary input to subsequent ADR work without Discovery itself creating an ADR or architecture decision.
- **SC-009**: 100% of Discovery records contain sufficient information for ADR generation without re-performing Discovery analysis.

## Assumptions

- Completed requests already exist under the request artifact convention and expose an unambiguous completion state.
- Discovery records and the Discovery catalog are user-owned artifacts under `discoveries/`.
- The following templates exist before `highway-discovery` execution:
	- `.highway/library/templates/output/discovery-record.md`
	- `.highway/library/templates/output/discovery-catalog.md`
- The Profile, Objective, Control, and NFR baselines are the complete repository context used for Discovery analysis when present.
- Version 1 uses deterministic analysis rules and does not require a readiness contract.
- Candidate approaches are exploratory and do not authorize implementation or architecture work.
- The later `highway-adr` skill will consume the Discovery record through the ADR Handoff Contract.

## Scope Boundaries

### Included in Version 1

- Discovery artifact creation.
- Discovery catalog management and deterministic identifier allocation.
- Research findings, assumptions, risks, unknowns, and candidate approaches.
- Identification of advisory relationships to existing Objectives, Controls, and NFRs.
- Privacy exclusion and no-partial-write transaction behavior.

### Excluded from Version 1

- ADR creation or ADR decision recording.
- Architecture or reference architecture generation.
- Reference implementation generation.
- Objective, Control, or NFR creation or modification.
- Relationship creation, approval, repair, or mutation.
- Readiness-contract implementation.

## Non-Goals

Discovery does not:

- select architectures
- approve candidate approaches
- create ADRs
- create Controls
- create NFRs
- create Objectives
- generate implementation plans
- generate tasks
- generate code
