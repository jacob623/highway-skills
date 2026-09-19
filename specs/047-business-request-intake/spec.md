# Feature Specification: Business Request Intake

**Feature Branch**: `[047-business-request-intake]`

**Created**: 2026-09-19

**Status**: Draft

**Input**: User description: "Create the highway-new skill to collect complete business evidence and create durable request artifacts for new work."

## Clarifications

### Session 2026-09-19

- Q: When two requesters create requests at the same time, how must the catalog protect permanent request identifiers? → A: Treat catalog allocation and catalog update as one exclusive operation, retrying a request when the catalog has changed.
- Q: What privacy expectation should apply to business evidence stored in request records? → A: Store only business information needed for the request and exclude secrets and regulated personal data.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Start a Business Request (Priority: P1)

As a requester, I want to describe a business problem, idea, or desired change in my own words so that new work can enter the repository through a consistent intake path.

**Why this priority**: Every request begins with an initial business description, and the intake flow cannot provide value without preserving that starting context.

**Independent Test**: Provide an initial request description and verify that the skill reads repository context, preserves the request intent, and begins evidence collection with one conversational prompt rather than a questionnaire.

**Acceptance Scenarios**:

1. **Given** a requester provides a business problem, idea, request, or desired change, **When** intake begins, **Then** the skill treats it as initial business context and does not require a complete specification.
2. **Given** repository context is available, **When** intake begins, **Then** the skill uses that context only to tailor examples and does not record it as a user answer.
3. **Given** the initial description is incomplete, **When** the skill evaluates it, **Then** it asks one targeted question for the first incomplete evidence area.

---

### User Story 2 - Complete Evidence Conversationally (Priority: P1)

As a requester, I want to answer one targeted question at a time with relevant examples so that I can explain the business need naturally without completing a questionnaire.

**Why this priority**: The quality of the request record depends on complete evidence across all required business domains, while a conversational flow keeps the intake accessible.

**Independent Test**: Walk through an intake conversation and verify that each response updates the evidence model, that the next incomplete area is selected in the defined order, and that each prompt contains one to three contextual examples.

**Acceptance Scenarios**:

1. **Given** one or more evidence areas are incomplete, **When** the requester answers a prompt, **Then** the skill records the answer, re-evaluates completeness, and asks only the next targeted question.
2. **Given** multiple evidence areas are incomplete, **When** the next question is selected, **Then** the skill uses the order problem, actors, current process, desired change, success measure, and business constraints.
3. **Given** contextual examples are generated, **When** the next question is presented, **Then** there are between one and three examples and none is stored as a user response or silently converted into a requirement.
4. **Given** all six evidence areas satisfy the completeness rules, **When** completeness is re-evaluated, **Then** the skill stops asking evidence questions and proceeds to artifact generation.

---

### User Story 3 - Produce a Durable Request Record (Priority: P1)

As a repository owner, I want completed intake evidence recorded in a request artifact and catalog so that requests remain discoverable and traceable over time.

**Why this priority**: Durable records and stable identifiers are the primary repository outcome of the intake skill and enable later work to refer back to the original business evidence.

**Independent Test**: Complete an intake flow and verify that one request record and one catalog update are produced with a stable identifier, all six evidence sections, a deterministic title, and the correct completeness status.

**Acceptance Scenarios**:

1. **Given** all six evidence areas satisfy the completeness rules, **When** the request is generated, **Then** the skill creates one request record under `requests/REQXXXXXX.md` with status `proposed` and all six evidence sections.
2. **Given** the request catalog contains the next available identifier, **When** a request is created, **Then** the skill allocates that identifier from the catalog, advances the catalog state, and never derives or reuses an identifier from existing request filenames.
3. **Given** the request record is generated, **When** the catalog is updated, **Then** `requests/requests.md` preserves its version and next-ID information and adds the request to the index.
4. **Given** no `requests` directory or catalog exists, **When** the first request is created, **Then** the skill creates `requests/requests.md` with `Version: 1.0.0` and `Next ID: REQ000001`, then creates `requests/REQ000001.md`.

### Edge Cases

- When the initial input is empty, the skill reports that a feature description is required and creates no request artifact.
- When one or more evidence areas remain incomplete, the request record is marked `Incomplete` and the skill does not claim completion.
- When the catalog is missing or its next identifier is invalid, the skill does not infer an identifier from request filenames and reports that allocation cannot proceed.
- When concurrent request creation detects that the catalog changed during allocation, the skill retries the exclusive allocation and update rather than issuing a duplicate identifier or silently losing an update.
- When requester input contains secrets or regulated personal data, the skill excludes that content from the request record and prompts the requester to provide business-relevant information without it.
- When a request contains excluded privacy-sensitive content, the skill writes neither the secret nor the regulated personal data and replaces it with a prompt requesting business-relevant information.
- When repository context has no usable example source, the request remains valid and records no fabricated relationship.
- When contextual examples overlap with the request, the skill still keeps examples distinct from user responses and requirements.
- When the same repository context, request content, and answers are supplied again, the selected question, example set, and artifact content remain deterministic.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The skill MUST accept an initial business problem, idea, request, or desired change even when the description is incomplete.
- **FR-002**: The skill MUST read the repository Profile, Objectives, Controls, and NFRs as contextual guidance for examples only.
- **FR-003**: The skill MUST collect evidence for exactly six domains: Problem, Actors, Current Process, Desired Change, Success Measure, and Business Constraints.
- **FR-004**: The skill MUST evaluate evidence completeness after each requester response and select the first incomplete domain in the defined six-domain order.
- **FR-005**: The skill MUST ask one natural-language question at a time and MUST NOT present the evidence collection flow as a questionnaire.
- **FR-006**: The skill MUST include between one and three contextual examples with each evidence question.
- **FR-007**: The skill MUST keep generated examples separate from user responses and MUST NOT promote examples or repository context to requirements without explicit requester evidence.
- **FR-008**: The skill MUST continue evidence collection until every required domain satisfies the completeness rules or clearly mark the resulting request as incomplete.
- **FR-009**: The skill MUST allocate request identifiers from the catalog's next-ID value using the `REQ` prefix and six digits, performing allocation and catalog update as one exclusive operation.
- **FR-010**: The skill MUST never reuse or renumber an allocated request identifier and MUST never derive allocation state from existing request filenames.
- **FR-011**: The skill MUST create request records at `requests/REQXXXXXX.md` with the request identifier, proposed status, deterministic title, six evidence sections, and completeness status.
- **FR-012**: The skill MUST update `requests/requests.md` with the catalog version, next identifier, and request index entry when a request is created, retrying the exclusive operation if the catalog changed during allocation.
- **FR-013**: The skill MUST keep user-owned request artifacts outside `.highway`.
- **FR-014**: The skill MUST NOT recommend technologies, define architectures, generate NFRs, generate Controls, or generate implementation plans.
- **FR-015**: For identical repository context, request content, and requester answers, the skill MUST select the same evidence domain, question, examples, and artifact content without timestamps, randomness, or environment-derived values.
- **FR-016**: The skill MUST store only business information needed for the request and MUST exclude secrets and regulated personal data from request records.
- **FR-017**: The skill MUST generate a deterministic title for every request.
- **FR-018**: The skill MUST create `requests/requests.md` when it does not exist, initializing it with `Version: 1.0.0` and `Next ID: REQ000001` before allocating the first request identifier.
- **FR-019**: The skill MUST format every request identifier as `REQ` followed by exactly six digits.
- **FR-020**: The skill MUST perform request creation as one transaction in this order: read the catalog, allocate the identifier, build the request artifact, build the catalog update, validate both artifacts, and write both artifacts.
- **FR-021**: If any request creation step fails, the skill MUST write nothing and preserve the original bytes of every existing artifact.
- **FR-022**: The skill MUST evaluate all six evidence domains when a request description is supplied, mark satisfied domains, select the first incomplete domain, and generate one question, even when the initial description satisfies some domains.
- **FR-023**: The skill MUST verify that secrets and regulated personal data are not written to request records and that excluded content is replaced by a prompt requesting business-relevant information.

### Evidence Completeness Rules

An evidence domain is Complete when:

- **Problem**: Contains user-authored content.
- **Actors**: Contains at least one actor, role, team, stakeholder, consumer, or user group.
- **Current Process**: Contains user-authored content.
- **Desired Change**: Contains user-authored content.
- **Success Measure**: Contains user-authored content.
- **Business Constraints**: Contains user-authored content or an explicit statement of `None`, `No business constraints`, or `No known constraints`.

### Request Completeness

A Request is Complete only when Problem, Actors, Current Process, Desired Change, Success Measure, and Business Constraints are all Complete. Otherwise, the request MUST be marked `Completeness: Incomplete`.

### Allowed Completeness States

The only valid completeness states are `Complete` and `Incomplete`. No additional completeness values are valid.

### Deterministic Title Rules

Title generation MUST be evaluated in this order:

1. If the requester explicitly supplies a title, use the supplied title.
2. Otherwise, generate a concise title derived from the Problem evidence domain.
3. Identical Problem content MUST produce identical titles.
4. Title generation MUST NOT depend on timestamps, random values, agent preference, environment state, or repository state.

### Example Generation Order

Generate examples using these sources in order:

1. Existing request evidence
2. Profile context
3. Objectives
4. Controls
5. NFRs

Earlier sources take precedence over later sources. Identical inputs MUST produce identical examples. Examples MUST never be stored, become user responses, or become requirements automatically.

### Request Catalog Authority

The Request Catalog is authoritative for its version, next_id, and request index. The next identifier MUST never be derived from existing filenames, directory contents, the highest observed identifier, or the highest request number.

### Request Catalog Creation

When `requests/requests.md` does not exist, the skill MUST create the catalog before allocating any request. The new catalog MUST initialize with `Version: 1.0.0` and `Next ID: REQ000001`.

### Request Identifier Format

Every request identifier consists of `REQ` followed by exactly six digits. Valid examples are `REQ000001`, `REQ000002`, and `REQ000103`. Invalid examples are `REQ1`, `REQ001`, `REQ-000001`, and `REQ0000001`.

### Transaction Rules

Request creation MUST be performed as one transaction in this order:

1. Read the catalog.
2. Allocate the identifier.
3. Build the request artifact.
4. Build the catalog update.
5. Validate both artifacts.
6. Write both artifacts.

If any step fails, the skill MUST write nothing and preserve the original bytes of every existing artifact. No partial request creation is allowed.

### Allowed Status Values

Allowed request status values are `proposed`, `active`, `closed`, and `withdrawn`. Version 1 rule: highway-new creates requests only with status: proposed. Future skills may transition status values, but `highway-new` does not.

### Constraint Examples

Contextual examples for Business Constraints may include `Existing approval process`, `Regulatory obligations`, `Vendor commitments`, and `No business constraints`. Examples teach that an explicit absence of constraints is acceptable and are not user-authored evidence.

### Initial Evaluation Rule

When a request description is supplied, the skill MUST:

1. Evaluate all six evidence domains.
2. Mark satisfied domains.
3. Select the first incomplete domain.
4. Generate one question.

This rule applies even when the initial request description satisfies some evidence domains.

### Request Artifact Structure

Each request record contains the request identifier and status in its front matter, followed by a title, the six evidence sections, and the following terminal section:

```markdown
## Completeness

Complete | Incomplete
```

### Privacy Verification

The skill MUST verify that secrets are not written, regulated personal data is not written, and excluded content is replaced by a requester prompt requesting business-relevant information.

### Non-Normative Note

Version 1 collects business evidence only. Future skills may consume Problem, Actors, Current Process, Desired Change, Success Measure, and Business Constraints for additional analysis. This specification defines no downstream behavior.

### Key Entities *(include if feature involves data)*

- **Request Record**: A user-owned business request containing a permanent identifier, allowed status, deterministic title, six evidence domains, and completeness status.
- **Request Catalog**: The repository-owned index containing catalog version, next request identifier, and request entries.
- **Evidence Domain**: One of the six fixed business-information areas used to determine intake completeness.
- **Contextual Example**: Guidance shown during conversation to help a requester answer a question; it is not persisted as a user response.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: At least 95% of valid intake sessions select the next question from the first incomplete evidence domain in the prescribed order.
- **SC-002**: At least 95% of valid intake sessions present exactly one question and between one and three contextual examples at each conversational step.
- **SC-003**: 100% of completed requests contain all six evidence sections satisfying the completeness rules, a permanent `REQ` identifier, a deterministic title, and a matching catalog entry.
- **SC-004**: 100% of repeated runs with identical context and answers produce identical question selection, examples, request content, and catalog content apart from the intended next-ID advancement for a newly allocated request.
- **SC-005**: At least 90% of requesters can complete the intake flow without being shown a batch questionnaire and can identify the next action after each response.
- **SC-006**: 100% of generated request records keep contextual examples and repository context separate from user-authored evidence.

## Assumptions

- Requesters can provide business evidence in natural language and do not need to know repository governance terminology.
- The Profile, Objectives, Controls, and NFRs may be absent; the intake flow remains usable in that case.
- Completeness is determined solely by the Evidence Completeness Rules defined by this specification.
- The request catalog is the authoritative allocation state and is available for normal request creation.
- Request status begins as `proposed`; later lifecycle changes are outside this feature.
- Version 1 does not identify or infer Request-to-Objective, Request-to-Control, or Request-to-NFR relationships. Future versions may introduce repository-wide discovery and traceability matching.
- This feature defines intake and record creation only; architecture, implementation planning, NFR generation, Control generation, and relationship discovery occur elsewhere.
