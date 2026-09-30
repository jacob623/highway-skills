# Feature Specification: Final Objectives Cleanup

**Feature Branch**: `106-final-objectives-cleanup`

**Created**: 2026-09-29

**Status**: Draft

**Input**: User description: "Complete the highway-objectives 3.0.0 contract by correcting Profile input wording, removing remaining Outcome and Significance discovery terminology, synthesizing Rationale from accepted evidence, making Business Objective and Success sufficient for proposal readiness, correcting the Objective review, and ensuring recommendation-created Objectives need no redundant confirmation or separate Rationale question. Keep objectives.md at 3.0.0 and objective-record.md unchanged."

## Background

The Objectives skill was recently rewritten to version 3.0.0, but a small set of legacy discovery terms and contradictory Rationale rules remain. The skill still describes a blocked Profile too narrowly, still contains some Outcome and Significance wording, and can imply that Rationale is a fourth discovery requirement.

The retained Objective record must continue to contain Statement, Success Measures, and Rationale. Rationale is a retained field, but it should be synthesized from accepted evidence rather than collected through a separate question. Business Objective and Success are required for proposal readiness. Highway Relevance is optional downstream context: it may improve the Objective, but it does not independently block creation.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Profile and discovery terminology are consistent (Priority: P1)

As a person using Objectives with a Profile, I want blocked and unavailable Profile states described accurately and all discovery dimensions to use the current terms, so that the skill does not imply that Significance is still required.

**Why this priority**: Terminology controls how the skill routes evidence and determines whether a question is needed.

**Independent Test**: The skill distinguishes a Profile-owned Blocked result from an unavailable Profile, describes Profile context using recommendations and Highway Relevance, and contains no legacy Outcome/Significance discovery requirement.

**Acceptance Scenarios**:

1. **Given** the Profile result is Profile-owned and Blocked, **When** Objective behavior depends on accepted Profile evidence, **Then** the skill says `A Profile-owned Blocked result blocks Objective behavior that depends on accepted Profile evidence.`
2. **Given** Profile is unavailable but not Blocked, **When** Objectives runs, **Then** the skill keeps that state distinct and does not treat it as a Profile-owned Blocked result.
3. **Given** the skill describes Profile context, **When** its context roles are read, **Then** it uses recommendations, Highway Relevance, and Rationale rather than suggestions, Significance, and Rationale.
4. **Given** action selection or direct invocation mentions evidence, **When** the wording is read, **Then** it says Business Objective evidence rather than Outcome evidence.
5. **Given** overlap revalidation is described, **When** staged evidence is re-evaluated, **Then** the terms are Business Objective, Success, and Highway Relevance.

---

### User Story 2 - Business Objective and Success make an Objective review-ready (Priority: P1)

As a person capturing an Objective, I want Highway to review it once Business Objective and Success are established, so that optional Highway Relevance does not become an unnecessary creation blocker.

**Why this priority**: This defines the required evidence boundary for Objective creation.

**Independent Test**: A Statement and at least one Success Measure produce the Objective review. Highway Relevance is asked only when unresolved information would improve downstream Highway use. If no such question is warranted, Rationale is synthesized and review proceeds.

**Acceptance Scenarios**:

1. **Given** Business Objective evidence supports a Statement and Success evidence supports at least one Success Measure, **When** no additional Highway Relevance question is warranted, **Then** Highway synthesizes Rationale and presents the Objective review.
2. **Given** Highway Relevance remains unresolved and would improve downstream Highway use, **When** Business Objective and Success are complete, **Then** Highway asks only the unresolved Highway Relevance question before review.
3. **Given** Highway Relevance is unresolved but would not improve downstream Highway use, **When** Business Objective and Success are complete, **Then** Highway does not ask a relevance question and does not block creation.
4. **Given** the retained record is created, **When** its fields are read, **Then** it contains Statement, Success Measures, and Rationale, with no persisted Highway Relevance field.
5. **Given** Rationale evidence is concise, **When** it is synthesized, **Then** Highway uses the concise rationale rather than asking another question.

---

### User Story 3 - Rationale is synthesized and presented correctly (Priority: P1)

As a person reviewing an Objective, I want Rationale to explain the captured Objective using accepted evidence, so that `Why it matters` is a presentation of the retained field rather than another discovery requirement.

**Why this priority**: Rationale is required by the record contract, but collecting it separately creates the legacy Significance behavior.

**Independent Test**: Materially interpreted user-authored Objectives use the exact captured-content review. Rationale is synthesized from accepted evidence and does not introduce unsupported organizational facts. `Why it matters` does not trigger a separate question.

**Acceptance Scenarios**:

1. **Given** Highway materially interprets user-authored Objective input, **When** it presents the review, **Then** it uses exactly:
   - `**Here's what I've captured as your objective:**`
   - `[Objective Title]`
   - `[Statement]`
   - `**Success looks like:**`
   - `- [Success Measure]`
   - `**Why it matters:**`
   - `[Rationale]`
   - `**Does this objective look right?**`
2. **Given** accepted Business Objective, Success, Highway Relevance, or applicable accepted Profile evidence is available, **When** Rationale is synthesized, **Then** only that accepted evidence may inform it.
3. **Given** Highway Identity, Highway Vision, or Highway Platform Objectives are available, **When** Rationale is synthesized, **Then** those sources are not treated as organizational facts.
4. **Given** `Why it matters` appears in the review, **When** the person responds, **Then** it does not represent a fourth discovery requirement or cause a separate Rationale question.
5. **Given** the prior malformed `**Why it matters:**[` formatting is present, **When** the review is updated, **Then** the malformed formatting is removed.

---

### User Story 4 - Recommendation-created Objectives use accepted evidence (Priority: P1)

As a person selecting a displayed Objective recommendation, I want the selected Objective captured from the recommendation and its grounding evidence, so that Highway does not ask for redundant confirmation or a separate Rationale answer.

**Why this priority**: Recommendation selection is already acceptance under the Experience Standard.

**Independent Test**: A selected recommendation creates Statement, Success Measures, and synthesized Rationale only from evidence already contained in or grounding that recommendation. If a required Success Measure is missing, Highway asks only the unresolved Success question.

**Acceptance Scenarios**:

1. **Given** the person selects a displayed Objective recommendation, **When** Highway creates the retained content, **Then** Statement, Success Measures, and Rationale come only from the recommendation and its grounding evidence.
2. **Given** a selected recommendation lacks enough accepted evidence for a required Success Measure, **When** Objective creation continues, **Then** Highway asks only for the unresolved Success information.
3. **Given** a selected recommendation has enough accepted evidence for Business Objective and Success, **When** it is captured, **Then** no confirmation question and no separate Rationale question is asked.
4. **Given** recommendations are displayed, **When** the person does not select one, **Then** the user-authored alternative remains available under the Highway Experience Standard.

---

### Edge Cases

- A Profile-owned Blocked result prevents Profile-dependent Objective behavior, while an unavailable Profile remains distinct and does not become a Blocked result.
- No available accepted evidence supports a Rationale beyond a concise statement; Highway uses the concise statement and does not ask why the Objective matters.
- Highway Relevance may be absent from the retained record even when the Objective is review-ready.
- A selected recommendation can require one Success follow-up but never a Rationale follow-up.
- Accepted Profile evidence can support Rationale, but Highway Identity, Highway Vision, and Highway Platform Objectives cannot supply organizational facts.
- Existing Objective overlap revalidation continues using Business Objective, Success, and Highway Relevance terminology.
- The record template remains unchanged and continues to require Rationale.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The skill MUST describe a blocked Profile as `A Profile-owned Blocked result blocks Objective behavior that depends on accepted Profile evidence.` It MUST keep unavailable Profile distinct from a Profile-owned Blocked result.
- **FR-002**: The Profile context description MUST use recommendations, Highway Relevance, and Rationale. It MUST remove Significance from that description.
- **FR-003**: Every discovery dimension and evidence-routing reference MUST use Business Objective, Success, and Highway Relevance. Legacy Outcome and Significance terms MUST NOT remain as discovery requirements.
- **FR-004**: Action selection and direct invocation MUST use Business Objective evidence instead of Outcome evidence.
- **FR-005**: Pre-write overlap revalidation MUST use the exact terminology Business Objective, Success, and Highway Relevance.
- **FR-006**: The skill MUST NOT require Significance to be collected or supported and MUST NOT ask why an Objective is meaningful, important, or significant solely because the retained record contains Rationale.
- **FR-007**: The retained Objective MUST continue to contain Statement, Success Measures, and Rationale. `objective-record.md` MUST remain unchanged.
- **FR-008**: Rationale MUST be synthesized from accepted Business Objective, Success, Highway Relevance, and applicable accepted Profile evidence. It MUST NOT introduce unsupported organizational facts.
- **FR-009**: Highway Identity, Highway Vision, and Highway Platform Objectives MUST NOT be treated as organizational facts when synthesizing Rationale.
- **FR-010**: When Business Objective evidence supports a Statement and Success evidence supports at least one Success Measure, Highway MUST present the Objective review unless it asks one unresolved Highway Relevance question that would improve downstream Highway use.
- **FR-011**: Highway Relevance MUST NOT independently block Objective creation. If it is unresolved and no useful question is warranted, Highway MUST synthesize Rationale and proceed to review.
- **FR-012**: If accepted evidence supports only a concise Rationale, Highway MUST use it without asking another question.
- **FR-013**: The materially interpreted user-authored Objective review MUST use the exact captured-content structure in User Story 3 and MUST render `**Why it matters:**` followed by the synthesized Rationale.
- **FR-014**: `Why it matters` MUST present Rationale and MUST NOT become a fourth discovery dimension.
- **FR-015**: A selected recommendation MUST create Statement, Success Measures, and Rationale only from evidence contained in or grounding that recommendation.
- **FR-016**: A selected recommendation MUST NOT receive redundant confirmation or a separate Rationale question.
- **FR-017**: If a selected recommendation lacks enough accepted evidence for a required Success Measure, Highway MUST ask only for the unresolved Success information.
- **FR-018**: The user-authored alternative MUST remain available when recommendations are presented.
- **FR-019**: Verification MUST confirm the absence of a Significance discovery requirement; Business Objective and Success as required retained-content evidence; non-persisted Highway Relevance; non-blocking Highway Relevance; synthesized Rationale; no unsupported facts in Rationale; `Why it matters` as presentation only; no redundant recommendation confirmation; Success-only follow-up for an incomplete recommendation; and corrected overlap terminology.
- **FR-020**: The highway-objectives skill MUST remain version 3.0.0. The Objective record template MUST remain unchanged.

### Key Entities

- **Business Objective evidence**: Accepted evidence supporting the retained Statement.
- **Success evidence**: Accepted evidence supporting at least one retained Success Measure.
- **Highway Relevance evidence**: Accepted downstream context that is not persisted as a record field.
- **Synthesized Rationale**: Accepted-evidence explanation retained in `## Rationale` and presented as `**Why it matters:**`.
- **Profile result**: The Profile-owned result that may be Blocked, unavailable, or usable for accepted organizational evidence.
- **Selected recommendation**: A displayed Objective recommendation whose selection is already acceptance.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 0 Objective discovery requirements collect or require Significance. 100% of discovery dimensions use Business Objective, Success, and Highway Relevance terminology.
- **SC-002**: 100% of Objective reviews become ready when Business Objective supports a Statement and Success supports at least one Success Measure, unless one useful unresolved Highway Relevance question remains. 0 reviews are blocked solely by absent Highway Relevance.
- **SC-003**: 100% of retained Objectives contain Statement, Success Measures, and synthesized Rationale. 0 retained records contain a Highway Relevance field. 0 Rationale values contain unsupported organizational facts.
- **SC-004**: 100% of materially interpreted user-authored reviews use the exact captured-content structure. 0 reviews use malformed `**Why it matters:**[` formatting or treat `Why it matters` as a fourth discovery requirement.
- **SC-005**: 100% of selected recommendations receive no redundant confirmation and no separate Rationale question. 100% of selected recommendations missing required Success evidence ask only for unresolved Success information.
- **SC-006**: The skill remains version 3.0.0 and the Objective record template remains unchanged.

## Assumptions

- This feature completes the existing 3.0.0 Objectives contract and does not introduce another version change.
- `objective-record.md` remains the authoritative retained structure and is not edited.
- Highway Relevance remains useful optional context and is never persisted as a record field.
- The Experience Standard continues to govern recommendation selection as acceptance and the user-authored captured-content review.
- Existing Objective duplicate, overlap, identifier, catalog, and atomic mutation behavior remains unchanged except for terminology and Rationale synthesis wording.
- The Profile skill, Experience Standard, Skills Constitution, development constitution, Objective catalog template, and Setup orchestration remain out of scope unless a live check quotes the corrected Objectives wording.
- Generated copies of the Objectives skill remain aligned with the source.
