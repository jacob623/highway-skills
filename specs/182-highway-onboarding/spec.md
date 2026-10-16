# Feature Specification: Highway Onboarding

**Feature Branch**: `182-highway-onboarding`

**Created**: 2026-10-16

**Status**: Draft

**Input**: User description: "Create proposal-first highway-onboarding to bring existing organizational technology into Highway as accepted architecture knowledge through business capability discovery, platform mapping, validated ADRs, and downstream Reference Architecture and Reference Implementation generation without technology inventories or substitute Request/Discovery artifacts."

## Clarifications

### Session 2026-10-16

- Q: Should onboarding support multiple platforms or processes for one business capability, and one platform or process for multiple capabilities? → A: Support many-to-many mappings, with an optional primary mapping when the requester identifies one.
- Q: Which external information sources should Feature 182 support in its first release? → A: Use accepted repository knowledge and conversational user input, and also accept manually provided organization websites and imported materials; defer live enterprise integrations.
- Q: When ADR creation succeeds but a downstream Architecture or Implementation mutation fails, should onboarding resume from the failed owner boundary without repeating successful mutations? → A: Retry the failed owner automatically up to three times, then require manual resume from that failed owner boundary while preserving earlier successful mutations.
- Q: Should onboarding delegate ADR creation to a new mode of `highway-adr`, or create the ADR directly from the shared ADR output template? → A: `highway-onboarding` creates the standard ADR directly from the shared ADR output structures; the existing Discovery-based `highway-adr` path remains unchanged.
- Q: How should onboarding provenance values be represented when an ADR has both onboarding context and one or more related identifiers? → A: Use a scalar when one value applies and a list when multiple provenance values must be retained.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Understand Existing Capability Coverage (Priority: P1)

As an organization owner, I want Highway to summarize the business capabilities already represented by accepted repository knowledge so that onboarding begins from what is known rather than asking me to describe the environment from scratch.

**Why this priority**: Reusing accepted context is the foundation for efficient onboarding and prevents the workflow from creating a parallel technology inventory.

**Independent Test**: Provide accepted Profile, Objective, Control, NFR, ADR, Architecture, and Implementation context and verify that onboarding produces one narrative capability summary before asking for new environment details.

**Acceptance Scenarios**:

1. **Given** accepted repository artifacts describe existing business capabilities, **When** the requester starts `/highway-onboarding`, **Then** Highway presents a concise narrative summary of that accepted capability coverage.
2. **Given** the repository contains no accepted evidence for a capability, **When** onboarding evaluates the known coverage, **Then** Highway does not present the missing capability as accepted organizational knowledge.
3. **Given** accepted evidence supports a reasonable interpretation of a capability, **When** onboarding presents that interpretation, **Then** it identifies the interpretation as provisional and invites correction rather than treating it as fact.

### User Story 2 - Discover and Confirm Missing Business Capabilities (Priority: P1)

As an organization owner, I want Highway to propose likely missing business capabilities in recognizable business language so that I can identify what exists without needing to translate technical categories into business meaning.

**Why this priority**: Capability discovery determines the scope of onboarding before platform mapping and gives the requester a meaningful opportunity to correct Highway's understanding.

**Independent Test**: Start with accepted knowledge that leaves capability gaps, review proposed capabilities with explanatory context, and confirm that a correction-oriented contribution opportunity precedes any platform question.

**Acceptance Scenarios**:

1. **Given** accepted architecture knowledge leaves likely capability gaps, **When** onboarding evaluates those gaps, **Then** Highway presents proposed capabilities with a short business-language explanation for each.
2. **Given** proposed capabilities are presented, **When** the requester adds, corrects, or removes capabilities, **Then** Highway updates the active capability understanding and retains only the requester-validated onboarding scope.
3. **Given** a proposed capability has no grounded supporting context, **When** onboarding evaluates whether to present it, **Then** Highway states that no grounded possibility is available or asks for the missing evidence rather than manufacturing a capability.
4. **Given** a requester does not know whether a proposed capability exists, **When** they respond with uncertainty, **Then** Highway preserves the uncertainty as unknown and continues without treating the capability as accepted.

### User Story 3 - Map Capabilities to Existing Platforms (Priority: P1)

As an organization owner, I want to review each accepted business capability and identify the platform or process that currently provides it so that Highway can understand the existing landscape through accepted relationships.

**Why this priority**: Platform mapping connects recognized business needs to existing organizational practice without creating a separate platform inventory.

**Independent Test**: Confirm a capability, identify its current platform or process, and verify that onboarding records the mapping as accepted onboarding evidence before consolidating capabilities by platform.

**Acceptance Scenarios**:

1. **Given** a business capability has entered the accepted onboarding queue, **When** Highway processes it, **Then** Highway presents the capability purpose and asks which platform or process currently provides it.
2. **Given** the requester names a platform, service, or custom process, **When** Highway records the response, **Then** the response becomes accepted onboarding evidence associated with that capability.
3. **Given** one platform provides several capabilities, **When** onboarding consolidates the accepted mappings, **Then** Highway groups the capabilities under that platform for review without creating a standalone platform artifact.
4. **Given** the requester cannot identify the current provider, **When** Highway requests platform mapping, **Then** Highway records the provider as unknown and does not infer a platform as accepted.

### User Story 4 - Validate a Proposed Pre-existing Architecture Decision (Priority: P1)

As an organization owner, I want Highway to explain a likely historical architecture decision and invite correction before creating an ADR so that inferred rationale is validated rather than silently promoted into repository knowledge.

**Why this priority**: The value of onboarding is accepted architecture knowledge, and the rationale behind existing platforms must remain accountable to the owner.

**Independent Test**: Review a consolidated platform proposal with likely alternatives and rationale, provide a correction or acceptance, and verify that only the validated proposal proceeds to standard ADR creation.

**Acceptance Scenarios**:

1. **Given** a platform has one or more accepted capability mappings, **When** onboarding processes the platform, **Then** Highway presents a proposed pre-existing ADR including the platform, supported capabilities, likely alternatives, and a grounded reason.
2. **Given** Highway presents a proposed ADR rationale, **When** the requester corrects, qualifies, or removes an assumption, **Then** Highway updates the proposal and keeps the unaccepted rationale provisional.
3. **Given** the proposal has stabilized and the requester accepts it, **When** onboarding creates the decision artifact, **Then** it uses the standard ADR structure and identifier rather than an alternate onboarding-specific artifact type.
4. **Given** the requester asks for more information or examples about the proposed rationale, **When** onboarding responds, **Then** it provides refinement support without treating the request as acceptance.

### User Story 5 - Continue Through Architecture and Implementation Owners (Priority: P1)

As an organization owner, I want accepted onboarding decisions to continue through the existing Architecture and Implementation workflows so that the resulting knowledge remains traceable from platform to ADR to Reference Architecture to Reference Implementation.

**Why this priority**: Onboarding must produce durable connected knowledge while preserving the ownership and validation boundaries of downstream workflows.

**Independent Test**: Accept one onboarding ADR, verify that ADR creation succeeds before the next handoff, then verify that Architecture and Implementation are invoked in order and their owner results are summarized without exposing internal processing details.

**Acceptance Scenarios**:

1. **Given** an onboarding ADR has been accepted, **When** ADR persistence succeeds, **Then** onboarding invokes the Architecture owner for that accepted ADR.
2. **Given** Architecture persistence succeeds, **When** the downstream handoff continues, **Then** onboarding invokes the Implementation owner for the resulting Architecture.
3. **Given** any owner mutation fails, **When** onboarding evaluates the handoff, **Then** it stops before invoking the next owner and reports an actionable user-facing outcome without claiming completion.
4. **Given** the onboarding cycle completes successfully, **When** Highway summarizes the result, **Then** it presents the relationship Platform to ADR to Reference Architecture to Reference Implementation without exposing catalog, allocation, or internal state details.

### Edge Cases

- Accepted repository knowledge may cover some capabilities but not others; the summary must distinguish accepted coverage from proposed gaps.
- No grounded missing capability may be available; onboarding must say so rather than inventing a candidate.
- A requester may provide a complete capability or platform mapping immediately; onboarding must reuse it without adding unnecessary turns.
- A requester may correct or reject a proposed capability, platform mapping, alternative, or rationale; rejected material must not reappear as accepted knowledge.
- A platform may support multiple capabilities, and a capability may require more than one platform or custom process; onboarding must preserve many-to-many relationships and any requester-identified primary mapping without flattening them into an inventory.
- A requester may not know the current platform or historical rationale; unknown values remain provisional and do not authorize ADR creation.
- Manually provided organization websites and imported materials may be unavailable, contradictory, or incomplete; onboarding must identify the limitation and continue only with supported evidence. Live enterprise discovery integrations are out of scope for the first release.
- A proposed rationale may have several plausible alternatives; Highway must keep the alternatives grounded and must not present speculation as historical fact.
- ADR, Architecture, or Implementation creation may fail after earlier owner mutations succeed; onboarding must retry the failed owner up to three times, then report the last successful durable outcome and offer manual resume from the failed owner boundary without repeating successful mutations.
- Requests for architecture generation, implementation generation, Controls, NFRs, or relationships outside the onboarding flow must route to their owning workflows without substitute artifacts.
- Onboarding must never create a fake Request, fake Discovery record, synthetic DISC record, or parallel landscape catalog.
- The existing Discovery-based ADR path remains available and unchanged; onboarding uses a distinct ADR-owner mode rather than fabricating Discovery or option identifiers.

## ADR Provenance Representation

Onboarding-originated ADRs distinguish why the ADR exists from how Highway learned the information.
Every onboarding ADR has exactly one scalar `request: onboarding` value and one scalar
`discovery: highway` value. Neither field accepts a list or additional provenance identifier.

Future permitted discovery-source values may include `github`, `servicenow`, and `cmdb` after the
applicable owner contract supports them. These values do not create synthetic Discovery records.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Highway MUST invoke onboarding without requiring a command argument or an environment description in the initial invocation.
- **FR-002**: Highway MUST reuse accepted Profile, Objective, Control, NFR, ADR, Architecture, and Implementation knowledge when assessing existing capability coverage.
- **FR-003**: Highway MUST summarize accepted existing capability coverage in one concise narrative sentence before requesting new environment evidence.
- **FR-004**: Highway MUST distinguish accepted repository knowledge, observed evidence, proposed findings, user validation, and accepted onboarding findings.
- **FR-005**: Highway MUST propose likely missing business capabilities only when accepted context supports a responsible interpretation, and MUST include a business-language explanation for every proposed capability.
- **FR-006**: Highway MUST present a correction-oriented Contribution Opportunity before a proposed capability or inferred rationale becomes eligible for acceptance.
- **FR-007**: Highway MUST use the validation question "What would you add, correct, or remove?" for capability and ADR proposal review, with appropriate acceptance and uncertainty reassurance.
- **FR-008**: Highway MUST keep proposed capabilities, platform mappings, alternatives, and rationale as Working Ideas until the applicable user-validation boundary is crossed.
- **FR-009**: Highway MUST maintain a queue of requester-validated business capabilities without treating queue membership as architecture acceptance or artifact creation.
- **FR-010**: Highway MUST process one accepted capability at a time and present its business purpose before asking which platform or process currently provides it.
- **FR-011**: Highway MUST retain the requester's platform or process response as accepted onboarding evidence for the relevant capability, including a custom process or explicit unknown value, and MUST support multiple mappings in either direction with an optional primary mapping.
- **FR-012**: Highway MUST consolidate accepted capability mappings by platform for review without creating a separate platform, provider, application, or technology inventory.
- **FR-013**: Highway MUST process one platform at a time and present its accepted business capabilities before developing a proposed pre-existing ADR.
- **FR-014**: Highway MUST ground proposed ADR alternatives and rationale in accepted Profile, Objectives, Controls, NFRs, onboarding evidence, and other permitted repository context.
- **FR-015**: Highway MUST label unsupported historical claims as unknown or provisional and MUST NOT invent organizational facts, historical rationale, or alternatives.
- **FR-016**: Highway MUST allow the requester to add, correct, remove, qualify, or redirect proposed capability and ADR content, and MUST re-evaluate the active proposal after each substantive contribution.
- **FR-017**: `highway-onboarding` MUST create a normal ADR directly from the shared ADR record and catalog output structures after the requester accepts a stabilized proposed pre-existing decision, without requiring or fabricating Discovery or option identifiers; the existing Discovery-based `highway-adr` path remains unchanged.
- **FR-018**: Highway MUST support onboarding-originated ADR provenance values that distinguish why the ADR exists from how Highway learned it, including `request: onboarding` and `discovery: highway`, and MUST use a scalar when one value applies or a list when multiple values must be retained.
- **FR-019**: Highway MUST allow future permitted discovery-source provenance values such as `github`, `servicenow`, and `cmdb` without creating synthetic Discovery records.
- **FR-020**: Highway MUST NOT create fake Request artifacts, fake Discovery artifacts, synthetic DISC records, alternate ADR artifact types, or parallel artifact families for onboarding.
- **FR-021**: Highway MUST wait for successful ADR mutation before invoking Architecture and MUST wait for successful Architecture mutation before invoking Implementation.
- **FR-022**: Highway MUST assign onboarding ADR acceptance, shared-template rendering, identifier allocation, and ADR/catalog persistence to `highway-onboarding`, while preserving `highway-adr` ownership of the separate Discovery-based ADR path, Architecture ownership of Architecture generation, and Implementation ownership of Implementation generation.
- **FR-023**: Highway MUST retry a failed Architecture or Implementation owner mutation no more than three times, then stop downstream orchestration, preserve earlier successful mutations, report the actionable outcome without claiming successful completion, and support manual resume from the failed owner boundary.
- **FR-024**: Highway MUST summarize a successful cycle as Platform to ADR to Reference Architecture to Reference Implementation without exposing owner results, catalog mechanics, allocation state, or internal processing.
- **FR-025**: Highway MUST preserve accepted findings and relationships as durable repository knowledge only after the applicable owner acceptance and persistence boundaries succeed.
- **FR-026**: Highway MUST route requests for unrelated architecture, implementation, Control, NFR, or relationship behavior to the owning workflow without downstream mutation by onboarding.
- **FR-027**: The first release MUST accept accepted repository context, conversational user input, manually provided organization websites, and imported organizational materials, and MUST NOT require or implement live enterprise discovery integrations.

### Key Entities *(include if feature involves data)*

- **Accepted Repository Context**: Existing user-owned Profile, Objective, Control, NFR, ADR, Architecture, and Implementation knowledge available to ground onboarding.
- **Observed Evidence**: Information discovered from accepted repository context or permitted imported sources before user validation.
- **Proposed Capability**: A provisional business-language interpretation of a capability that may be missing from accepted architecture knowledge.
- **Accepted Capability**: A business capability the requester has validated for onboarding scope.
- **Capability Mapping**: An accepted relationship between a business capability and the platform or process that currently provides it.
- **Platform Queue**: A transient review sequence grouping accepted capability mappings by platform without becoming a platform inventory.
- **Proposed Pre-existing ADR**: A Working Idea describing an existing platform decision, likely alternatives, and grounded rationale before standard ADR acceptance.
- **Onboarding Provenance**: The reason an ADR exists and the source or workflow through which Highway learned it.
- **Owner Mutation Result**: The user-relevant outcome of ADR, Architecture, or Implementation persistence that controls whether the next owner may be invoked.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of representative onboarding sessions with accepted repository context, Highway presents the existing capability summary before requesting new environment information.
- **SC-002**: In at least 90% of usability evaluations, requesters can identify the business meaning of each proposed capability without needing a technical category explanation.
- **SC-003**: In 100% of proposed capability and ADR review scenarios, the requester receives a correction-oriented Contribution Opportunity before the proposal becomes eligible for acceptance.
- **SC-004**: In 100% of representative mapping scenarios, accepted capability-to-platform relationships are available for platform consolidation without a separate inventory artifact being created.
- **SC-005**: In 100% of proposed ADR scenarios, unsupported historical facts remain provisional or unknown and are not persisted as accepted rationale without user validation.
- **SC-006**: In 100% of accepted onboarding cycles, the durable owner sequence is ADR, then Reference Architecture, then Reference Implementation, with no downstream owner invoked before the preceding mutation succeeds.
- **SC-007**: In 100% of failed owner-mutation scenarios, onboarding stops at the failed boundary and makes no false completion claim.
- **SC-008**: In 100% of onboarding runs, no fake Request, fake Discovery, synthetic DISC, alternate ADR, or parallel landscape artifact is created.
- **SC-009**: At least 90% of representative onboarding evaluations report that the final Platform to ADR to Reference Architecture to Reference Implementation relationship is understandable without exposing internal workflow mechanics.
- **SC-010**: Existing ADR, Architecture, and Implementation owner validation scenarios retain their current pass rate after onboarding orchestration is introduced.

## Assumptions

- Existing accepted Profile, Objective, Control, NFR, ADR, Architecture, and Implementation artifacts remain the authoritative sources of repository context.
- The onboarding workflow owns its direct ADR creation path, including acceptance, shared-template rendering, identifiers, and persistence, while `highway-adr` retains the separate Discovery-based path unchanged.
- Business capability discovery and platform mapping are onboarding evidence and do not create a durable landscape catalog.
- The existing ADR structure can represent a pre-existing platform decision with onboarding provenance values without creating a new ADR artifact type.
- `request: onboarding` and `discovery: highway` are valid provenance values for onboarding-originated ADRs, while future source values require the applicable owner contract before use.
- Manually provided organization websites and imported materials are optional enrichment and do not block progress when they are unavailable unless a required owner contract says otherwise; live enterprise discovery integrations are deferred beyond the first release.
- Architecture and Implementation owner workflows can be invoked sequentially after successful upstream persistence and provide user-relevant success or failure outcomes. A failed downstream owner can be retried up to three times and manually resumed from its failed boundary without repeating successful upstream mutations.
- A platform may support multiple capabilities and a capability may map to multiple platforms or processes, with an optional requester-identified primary mapping; onboarding preserves these relationships as accepted evidence rather than normalizing them into an inventory.
- Unknown platform or rationale evidence remains explicit and does not by itself satisfy acceptance or authorize ADR creation.
- The first release covers proposal-first onboarding, manually provided source material, and owner orchestration; bulk import, automated external-source synchronization, live enterprise integrations, and independent inventory management are out of scope.
