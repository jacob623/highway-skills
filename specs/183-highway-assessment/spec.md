# Feature Specification: Highway Assessment

**Feature Branch**: `183-highway-assessment`

**Created**: 2026-10-16

**Status**: Draft

**Input**: User description: Create an MVP `highway-assessment` workflow that analyzes accepted repository knowledge, surfaces advisory findings, persists reviewed findings, and supports architecture, implementation, and portfolio assessment without creating architecture, implementation, dependency, or other substitute artifact families.

## Clarifications

### Session 2026-10-16

- Q: Should a finding's `F###` identifier remain stable by being derived from its deterministic fingerprint, or should `F###` be a sequential display ID with the fingerprint stored separately? → A: Option B - Use a sequential `F###` display ID and store the deterministic fingerprint separately for duplicate detection.
- Q: What should happen when two assessment sessions attempt to update the findings record at the same time? → A: Option A - Reject the stale update and require reload before retrying.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review Existing Findings (Priority: P1)

As a repository owner, I want to see the findings that are already open before new analysis begins so that I can review existing observations and avoid rediscovering the same issues.

**Why this priority**: Existing findings are the durable memory of assessment work and must be visible before the workflow proposes additional observations.

**Independent Test**: Seed the findings record with open, accepted, dismissed, resolved, and superseded findings, invoke assessment without a domain, and verify that only open findings are presented first in a concise bullet list containing each finding ID and summary.

**Acceptance Scenarios**:

1. **Given** the findings record contains open findings, **When** the requester starts assessment, **Then** the workflow presents every open finding before offering new analysis.
2. **Given** the findings record contains no open findings, **When** the requester starts assessment, **Then** the workflow states that no open findings are available and offers assessment analysis.
3. **Given** the requester does not provide a domain, **When** assessment starts, **Then** portfolio assessment is used by default.

### User Story 2 - Assess Accepted Knowledge (Priority: P1)

As a repository owner, I want assessment to analyze accepted organizational knowledge across selected domains so that relationships and gaps that are not explicitly recorded become visible for review.

**Why this priority**: Cross-artifact analysis is the core value of the workflow and provides the observations that can improve future context.

**Independent Test**: Provide accepted artifacts containing at least one coverage gap, inconsistency, dependency, opportunity, reuse pattern, or risk, run each supported domain, and verify that grounded findings are proposed with a category, domain, summary, and advisory framing.

**Acceptance Scenarios**:

1. **Given** accepted architectures and implementations are available, **When** the requester runs `/highway-assessment architectures`, **Then** the workflow analyzes architecture coverage, consistency, dependencies, opportunities, reuse, and risks that are supported by accepted knowledge.
2. **Given** accepted implementations are available, **When** the requester runs `/highway-assessment implementations`, **Then** the workflow analyzes implementation relationships and patterns without creating or changing implementation artifacts.
3. **Given** accepted repository knowledge spans multiple artifact types, **When** the requester runs `/highway-assessment portfolio`, **Then** the workflow correlates the accepted knowledge across Objectives, Controls, NFRs, ADRs, Architectures, and Implementations.
4. **Given** no accepted evidence supports a possible finding, **When** assessment evaluates that relationship, **Then** it does not manufacture the finding and leaves the subject unknown.

### User Story 3 - Review and Disposition Findings (Priority: P1)

As a repository owner, I want to accept, dismiss, resolve, supersede, or request more information about findings so that assessment observations remain under human review and their current meaning is durable.

**Why this priority**: Findings are advisory and must not become accepted knowledge without an explicit user disposition.

**Independent Test**: Present a finding and exercise each supported disposition, then reload the findings record and verify that the selected status and disposition persist without changing unrelated findings.

**Acceptance Scenarios**:

1. **Given** an open finding is presented, **When** the requester accepts it, **Then** its status becomes Accepted and the observation remains distinguishable from ordinary accepted repository knowledge.
2. **Given** an open finding is presented, **When** the requester dismisses it, **Then** its status becomes Dismissed and it is not presented as open on the next run.
3. **Given** an open finding is addressed by accepted repository knowledge, **When** the requester marks it resolved, **Then** its status becomes Resolved and its disposition identifies the addressing knowledge where available.
4. **Given** a finding has been replaced by a newer observation, **When** the requester marks it superseded, **Then** its status becomes Superseded and its disposition identifies the replacement where available.
5. **Given** the requester asks for more information, **When** the finding is not yet dispositioned, **Then** the workflow provides relevant explanation without treating the request as acceptance or changing the status.

### User Story 4 - Reuse Findings as Context (Priority: P2)

As a downstream workflow, I want reviewed assessment findings to be available as repository context so that future decisions can account for known gaps, conflicts, dependencies, and opportunities without rerunning the same analysis blindly.

**Why this priority**: Durable findings compound the value of assessment and improve future workflows while preserving ownership boundaries.

**Independent Test**: Persist findings with different statuses, load them as repository context in a consuming workflow, and verify that the consuming workflow can distinguish open, accepted, resolved, dismissed, and superseded findings.

**Acceptance Scenarios**:

1. **Given** findings have been persisted, **When** a future workflow loads assessment context, **Then** it can consume findings with their category, domain, status, and disposition.
2. **Given** a finding has been reviewed, **When** assessment runs again with equivalent accepted inputs, **Then** the equivalent finding is reused rather than duplicated.
3. **Given** assessment findings exist, **When** a downstream workflow uses them, **Then** the findings inform decisions without automatically creating architecture, implementation, dependency, capability, or other artifacts.

### Edge Cases

- The findings record is absent or empty when assessment starts; the workflow treats it as having no existing findings and continues to analysis.
- A findings record contains malformed rows, unknown statuses, duplicate IDs, or incomplete required fields; the workflow reports the invalid entries and does not silently convert them into accepted findings.
- Two assessment sessions attempt to update the findings record concurrently; the stale update is rejected, the latest record is reloaded, and the reviewer retries without overwriting the newer change.
- Equivalent findings are discovered with different wording; deterministic normalization identifies the equivalent finding and prevents a duplicate.
- A finding is supported by both architecture and implementation evidence; the workflow retains the relevant domain and describes the relationship without creating a dependency artifact.
- A source artifact is missing, unresolved, or outside the accepted repository context; assessment does not infer a fact from its absence alone.
- A requester asks assessment to create architecture, implementation, or a dependency; the workflow routes the request to the owning workflow or explains that assessment is advisory.
- A new finding cannot be grounded in accepted knowledge; it remains uncreated rather than being presented as organizational fact.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provide the `/highway-assessment` workflow with `architectures`, `implementations`, and `portfolio` domains.
- **FR-002**: The system MUST use portfolio assessment when no domain is provided.
- **FR-003**: The system MUST load the retained assessment findings before generating or presenting new findings.
- **FR-004**: The system MUST present all Open findings before new analysis as concise bullets containing the finding ID and a single-sentence summary.
- **FR-005**: The system MUST analyze accepted Profile, Objectives, Controls, NFRs, ADRs, Reference Architectures, and Reference Implementations when they are relevant to the selected domain.
- **FR-006**: The system MUST support findings in the categories Coverage, Consistency, Dependency, Opportunity, Reuse, and Risk.
- **FR-007**: The system MUST keep every assessment finding advisory and distinguish it from accepted organizational knowledge until the requester explicitly accepts it.
- **FR-008**: The system MUST support the finding statuses Open, Accepted, Dismissed, Resolved, and Superseded.
- **FR-009**: The system MUST persist status changes and dispositions without changing unrelated findings.
- **FR-010**: The system MUST reject an update based on a stale findings record and require the requester to reload the latest record before retrying.
- **FR-011**: The system MUST generate a deterministic fingerprint from Category, Domain, and normalized Finding Text.
- **FR-012**: The system MUST assign a sequential human-readable `F###` display ID to a genuinely new finding and reuse the existing finding and display ID when a newly discovered finding has an equivalent fingerprint.
- **FR-013**: The system MUST persist reviewed findings in `.highway/library/knowledge/assessment-findings.md` using the defined finding fields: ID, Category, Domain, Finding, Status, and Disposition.
- **FR-014**: The system MUST persist only genuinely new findings during analysis.
- **FR-015**: The system MUST offer the requester the actions Accept, Dismiss, Resolve, and Request More Information for presented findings, and MUST support Superseded when a finding is replaced.
- **FR-016**: The system MUST provide a correction-oriented Contribution Opportunity for each finding under review and MUST not present the finding as accepted before the requester disposition.
- **FR-017**: The system MUST analyze relationships across accepted artifacts without mutating Profile, Objective, Control, NFR, ADR, Architecture, or Implementation artifacts.
- **FR-018**: The system MUST NOT create architecture, implementation, dependency, capability, inventory, or other new assessment artifact families.
- **FR-019**: The system MUST NOT create a new repository-wide assessment identifier family; finding identity MUST use the documented F-series form such as `F001`.
- **FR-020**: The system MUST expose findings as reusable repository context with their category, domain, status, and disposition.
- **FR-021**: The system MUST preserve uncertainty when accepted evidence cannot support a finding and MUST NOT manufacture organizational facts.
- **FR-022**: The system MUST keep assessment logic centralized in `highway-assessment` rather than adding assessment behavior to other artifact-owner workflows.
- **FR-023**: The system MUST explain or route requests for architecture, implementation, dependency, or other owner mutations to the responsible workflow without performing those mutations.

### Key Entities

- **Assessment Finding**: An advisory observation derived from relationships across accepted repository knowledge; includes a sequential `F###` display ID, deterministic fingerprint, category, domain, finding text, status, and disposition.
- **Finding Status**: The review state of a finding: Open, Accepted, Dismissed, Resolved, or Superseded.
- **Finding Disposition**: The optional explanation or reference describing why a finding was accepted, dismissed, resolved, or superseded.
- **Assessment Domain**: The scope of analysis: Architectures, Implementations, or Portfolio.
- **Accepted Repository Context**: User-owned Profile, Objectives, Controls, NFRs, ADRs, Reference Architectures, and Reference Implementations available to assessment as evidence.
- **Finding Fingerprint**: The deterministic equivalence key formed from category, domain, and normalized finding text.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of assessment runs, all persisted Open findings are presented before new findings are generated or proposed.
- **SC-002**: In 100% of repeated runs with equivalent accepted inputs, no duplicate finding is persisted for an existing deterministic identity.
- **SC-003**: In 100% of reviewed finding transitions, the selected status and disposition remain after the findings record is reloaded.
- **SC-004**: In 100% of concurrent update conflicts, the stale update is rejected without overwriting the newer findings record.
- **SC-005**: In acceptance testing, reviewers can identify the finding ID, category, domain, status, and disposition for every persisted finding without consulting another artifact.
- **SC-006**: In 100% of assessment runs, no Architecture, Implementation, dependency, capability, inventory, or new assessment artifact family is created by the assessment workflow.
- **SC-007**: At least 90% of reviewers can correctly distinguish an advisory finding from accepted organizational knowledge in a usability review.
- **SC-008**: A requester can review the existing open findings and choose a disposition or request more information for each one without restarting the assessment workflow.
- **SC-009**: A downstream workflow can consume findings in all five supported statuses and preserve their category, domain, and disposition in its decision context.

## Assumptions

- The repository already contains accepted artifacts in the owner formats that assessment can read.
- The findings record is a single durable Markdown knowledge artifact for the MVP; no separate finding catalog or identifier allocation workflow is required.
- Findings use a zero-padded sequential F-series display ID and a separate deterministic fingerprint for equivalence; the display ID is not regenerated when findings are reordered or rediscovered.
- Portfolio is the default user-facing domain when the requester does not specify a domain.
- Assessment is invoked interactively by a repository owner; access control, scheduling, live enterprise integrations, and automated remediation are outside the MVP.
- Future workflows may consume findings as context, but accepting a finding does not authorize architecture or implementation creation.
- The MVP supports manual review and imported repository materials already available to Highway; it does not require live external discovery integrations.
- Concurrent reviewers use stale-record rejection and reload-before-retry rather than last-write-wins updates.
