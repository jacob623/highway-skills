# Feature Specification: Objectives Advisory Collection

**Feature Branch**: `159-objectives-advisory-collection`

**Created**: 2026-10-11

**Status**: Draft

**Input**: User description: "Align highway-objectives with Highway contextual intelligence and Profile collaboration patterns by centralizing response support text, strengthening grounded advisory and portfolio assessment, processing selected recommendations sequentially, and requiring Success Measures before capture."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review objectives with consistent response support (Priority: P1)

As a person reviewing a Business Objective, I want consistent validation wording and applicable reassurance so that I can correct, accept, or continue developing the Objective without being pushed into agreement or uncertainty that the interaction does not require.

**Why this priority**: Review and reassurance wording is the shared interaction surface that determines whether objective development feels collaborative and clear.

**Independent Test**: Present an Objective proposal, a discovery question, a recommendation, and an interaction where either acceptance or not knowing is reasonable; verify that the applicable support text appears in the correct context and that the Validation Question is the only emphasized element in an Objective review.

**Acceptance Scenarios**:

1. **Given** an Objective proposal is ready for review, **When** the owner presents it, **Then** the review uses the default or sharper Validation Question, and the applicable Acceptance Reassurance appears beneath it.
2. **Given** the person is being asked to originate objective information without a grounded recommendation, interpretation, or Working Idea, **When** the owner asks the discovery question, **Then** it may use the Discovery Reassurance.
3. **Given** either confirming a grounded proposal or saying "I don't know" is a reasonable response, **When** the owner asks for a response, **Then** it may use the Combined Reassurance.
4. **Given** recommendations are shown, **When** the owner presents them, **Then** the Recommendation Reassurance and user-authored path remain available.
5. **Given** recommendations, captured Objectives, a portfolio assessment, and active collection all remain possible, **When** the interaction closes the current step, **Then** the Additional Suggestions Reassurance explicitly keeps future recommendations available.

### User Story 2 - Receive grounded Objective advisory and portfolio assessment (Priority: P1)

As a person developing Objectives, I want the owner to reveal grounded relationships, coverage, gaps, tensions, and focus observations so that the Objective baseline becomes more useful than a list of isolated statements.

**Why this priority**: Contextual advisory reasoning is the primary quality improvement and aligns Objective behavior with Highway's increasingly informed advisor model.

**Independent Test**: Provide accepted Profile evidence and multiple accepted Objectives with overlapping, reinforcing, or missing areas; verify that the owner offers one grounded observation at a time and may provide a concise advisory portfolio assessment without rejecting, blocking, or silently changing Objectives.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence and accepted Objectives support a useful relationship, overlap, duplication, coverage observation, gap, tension, reinforcement, or focus observation, **When** the owner selects its next contribution, **Then** it may present one grounded advisory observation before asking an unnecessary exploratory question.
2. **Given** multiple Objectives have been accepted, **When** the owner provides a portfolio assessment, **Then** the assessment may describe overlap, duplication, strategic concentration, focus fragmentation, meaningful coverage, or missing business areas.
3. **Given** a portfolio assessment is provided, **When** the person responds, **Then** the assessment remains advisory, does not reject Objectives, does not force completion, does not block additional Objectives, and leaves the person authoritative.
4. **Given** accepted evidence does not support a useful observation or recommendation, **When** the owner evaluates whether to contribute, **Then** it does not manufacture insight merely to keep the interaction moving.

### User Story 3 - Develop selected recommendations sequentially (Priority: P1)

As a person selecting several grounded recommendations, I want each selected recommendation to become an active Objective queue processed one at a time so that each Objective receives complete statement, Success Measures, rationale, review, and capture treatment.

**Why this priority**: Sequential processing prevents a multi-select action from implying that unresolved Success Measures or incomplete Objective development are already complete.

**Independent Test**: Select several recommendations and verify that the owner processes the first recommendation through Objective statement, Success Measures, rationale, required review, and capture before beginning the next selected recommendation.

**Acceptance Scenarios**:

1. **Given** the person selects several recommendations, **When** selection is accepted, **Then** the selected recommendations become an active Objective queue rather than one combined capture.
2. **Given** the queue contains multiple selected recommendations, **When** the owner processes the queue, **Then** it establishes the first Objective statement, Success Measures, synthesized rationale, and required review before moving to the next recommendation.
3. **Given** a selected recommendation already contains sufficient accepted evidence for its required Success Measures, **When** the owner develops it, **Then** it derives those measures rather than skipping them.
4. **Given** a selected recommendation lacks sufficient accepted evidence for a required Success Measure, **When** the owner develops it, **Then** it asks only the unresolved Success question and does not capture the Objective yet.
5. **Given** the person asks for an explanation or more information about a recommendation, **When** the owner responds, **Then** the request does not count as adoption or completion.
6. **Given** the person modifies a recommendation before adoption, **When** the owner continues, **Then** it re-evaluates the staged Objective evidence and preserves the existing acceptance and overlap rules.

### User Story 4 - Manage recommendation lifecycle and exhaustion (Priority: P2)

As a person collecting Objectives, I want recommendation choices, exhaustion explanations, and future suggestion availability to be explicit so that I can select, modify, decline, or revisit recommendations without guessing what remains possible.

**Why this priority**: Clear lifecycle behavior prevents transactional dead ends while preserving the user-authored path and the owner's responsibility not to manufacture recommendations.

**Independent Test**: Exercise one, several, and all recommendation selection; request additional recommendations after broad coverage; and finish the current set; verify explicit choice wording, grounded exhaustion explanations, and future suggestion availability.

**Acceptance Scenarios**:

1. **Given** recommendations are presented, **When** the owner asks for a response, **Then** the wording explicitly supports selecting one, several, or all, modifying recommendations, or providing a user-authored outcome.
2. **Given** no useful grounded non-duplicate recommendation remains, **When** the person asks for more suggestions, **Then** the owner may explain current coverage, overlap, or focus fragmentation and stops manufacturing recommendations.
3. **Given** recommendations are exhausted or Objectives have been captured, **When** collection remains active, **Then** the owner explicitly offers future recommendation support.
4. **Given** the person says they are satisfied with the current Objectives, **When** collection remains active, **Then** the owner may synthesize current coverage, offer future suggestions, and ask whether another Objective should be captured.
5. **Given** the person explicitly finishes Objective collection, **When** the owner closes the workflow, **Then** future suggestion support does not override the explicit finish.

### Edge Cases

- A single selected recommendation follows the existing direct-selection acceptance behavior but still requires unresolved Success Measures before capture.
- Several selected recommendations become a queue in user-selected order; one recommendation's unresolved Success question does not cause another queued recommendation to be captured early.
- A selected recommendation is modified before adoption; stale staged interpretations are discarded and the existing re-evaluation and acceptance rules apply.
- Multiple Objectives overlap or duplicate existing outcomes; the owner names the relevant existing Objective and preserves the existing duplicate/overlap decision boundary.
- A portfolio assessment identifies a gap but no grounded recommendation exists; the owner may state the gap without inventing an Objective.
- Accepted Profile evidence is unavailable or Profile is blocked; the owner preserves its existing handling and does not treat unavailable context as organizational fact.
- No useful grounded recommendations remain, but the person wants to continue; the owner explains exhaustion and leaves the user-authored path and explicit continuation choice available.
- An explanation request, comparison, or request for more information is not treated as adoption.
- Recommendation or portfolio language is model-originated; it remains advisory, attributable where required, and outside accepted Objective content until the existing boundary is crossed.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Objectives MUST define one reusable Response Support Text section containing the Validation Question, Acceptance Reassurance, Discovery Reassurance, Combined Reassurance, Recommendation Reassurance, and Additional Suggestions Reassurance.
- **FR-002**: The default Objective Validation Question MUST be "What would you add, correct, or remove?" and a sharper question MUST still invite correction rather than agreement.
- **FR-003**: Objectives MUST replace "Does this objective look right?" with the default or sharper Validation Question, and the Validation Question MUST remain the only emphasized element in an Objective review.
- **FR-004**: Objectives MUST use Acceptance Reassurance when reviewing an Objective proposal, Discovery Reassurance when originating unresolved objective information without a grounded starting point, and Combined Reassurance when either response is reasonable.
- **FR-005**: Recommendations MUST include the Recommendation Reassurance and retain a user-authored alternative; recommendation adoption MUST never be required.
- **FR-006**: Objectives MUST use Additional Suggestions Reassurance after recommendations, captured Objectives, portfolio assessments, or other active collection steps when future recommendations remain available.
- **FR-007**: Objectives MUST provide concise grounded contribution guidance that permits relationships, overlap, duplication, strategic coverage, meaningful gaps, tensions, reinforcement, implications, focus observations, and portfolio observations when supported by accepted Profile evidence and accepted Objectives.
- **FR-008**: Objective advisory guidance MUST contribute no more than one grounded observation at a time when one observation materially improves the active Working Idea and MUST prefer useful interpretation over an unnecessary exploratory question.
- **FR-009**: After multiple Objectives are accepted, Objectives MAY provide a concise advisory portfolio assessment describing overlap, duplication, strategic concentration, focus fragmentation, meaningful coverage, or missing business areas.
- **FR-010**: A portfolio assessment MUST NOT reject Objectives, force completion, block additional Objectives, or replace the person's authority over the Objective baseline.
- **FR-011**: Selecting several recommendations MUST create an active Objective queue and MUST process selected recommendations sequentially rather than capturing them together as one completed operation.
- **FR-012**: For each queued recommendation, Objectives MUST establish the Objective statement, establish required Success Measures, synthesize rationale, complete review when required, capture the Objective, and then continue to the next queued recommendation.
- **FR-013**: Selection MUST count as acceptance of the recommendation itself but MUST NOT imply completion of unresolved Success Measures or completion of the Objective.
- **FR-014**: When a selected recommendation contains sufficient accepted evidence for required Success Measures, Objectives MUST derive those measures; otherwise it MUST ask only the unresolved Success question before capture.
- **FR-015**: Explanation requests, comparisons, and requests for more information MUST NOT count as recommendation adoption or Objective completion.
- **FR-016**: Recommendation wording MUST explicitly support selecting one, several, or all recommendations, modifying recommendations before adoption, and providing a user-authored outcome.
- **FR-017**: When no useful grounded non-duplicate recommendation remains, Objectives MAY explain the reason, MUST stop manufacturing recommendations, and MUST leave the person an explicit choice to continue or provide their own outcome.
- **FR-018**: After recommendations are exhausted or Objectives are captured, Objectives MUST explicitly keep future recommendation support available until the person explicitly finishes Objective collection.
- **FR-019**: The feature MUST preserve Objective ownership, persistence, catalog behavior, permanent identifier allocation, duplicate detection, overlap detection, atomic mutation requirements, setup orchestration boundaries, and Repository Context declaration.
- **FR-020**: The feature MUST preserve existing Objective readiness and mutation output contracts, including non-write behavior for declined, interrupted, malformed, or unresolved operations.
- **FR-021**: Objective recommendations and portfolio assessments MUST remain grounded in accepted Profile evidence and accepted Objectives, remain advisory until accepted, and preserve existing attribution and acceptance boundaries.

## Key Entities *(include if feature involves data)*

- **Response Support Text**: Objective-owned reusable validation, reassurance, recommendation, and future-suggestion wording selected according to the active interaction.
- **Grounded Objective Observation**: One provisional relationship, overlap, implication, coverage, gap, tension, reinforcement, focus, or portfolio observation traceable to accepted Profile evidence and accepted Objectives.
- **Objective Portfolio Assessment**: A concise advisory view of multiple accepted Objectives that describes coverage, overlap, duplication, concentration, fragmentation, or gaps without mutating or blocking the baseline.
- **Objective Recommendation**: A grounded provisional outcome presented for reaction or selection while retaining a user-authored alternative.
- **Active Objective Queue**: The ordered set of selected recommendations awaiting sequential statement, Success Measure, rationale, review, and capture processing.
- **Success Measure**: Accepted evidence describing how the Objective's outcome will be recognized; unresolved required measures block capture of that queued Objective.
- **Accepted Objective**: A user-owned Objective that crossed the existing acceptance boundary and became eligible for the owner's existing persistence behavior.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of focused Objective review examples use the default or sharper correction-oriented Validation Question instead of "Does this objective look right?", with no other emphasized element in the review.
- **SC-002**: 100% of focused support-text examples select the applicable Acceptance, Discovery, Combined, Recommendation, or Additional Suggestions Reassurance according to the stated interaction context.
- **SC-003**: 100% of focused advisory examples present at most one grounded Objective observation at a time and preserve the user-authored path.
- **SC-004**: 100% of focused portfolio-assessment examples preserve Objective authority and do not reject, force completion, block additional Objectives, or mutate the baseline.
- **SC-005**: 100% of focused multi-select examples process selected recommendations as an ordered queue, completing the current recommendation's required Success Measure handling before starting the next.
- **SC-006**: 100% of focused selected-recommendation examples prevent Objective capture when a required Success Measure remains unresolved.
- **SC-007**: 100% of focused recommendation-lifecycle examples support one, several, all, modification, and user-authored alternatives, while treating explanation requests as non-adoption.
- **SC-008**: 100% of focused exhaustion examples stop unsupported recommendation generation, explain grounded coverage or overlap when useful, and leave an explicit continue or own-outcome path.
- **SC-009**: 100% of focused active-collection examples explicitly communicate future recommendation availability until the person finishes collection.
- **SC-010**: 0% of focused regression checks report changes to Objective ownership, persistence, catalog behavior, identifier allocation, duplicate or overlap detection, atomic mutation, setup orchestration, or Repository Context declaration.
- **SC-011**: Existing Objective and full repository verification suites remain passing after implementation.

## Assumptions

- The current Objective owner remains authoritative for Objective meaning, completeness, acceptance, persistence, identifiers, catalog mutation, duplicate handling, overlap handling, and readiness.
- Existing Profile evidence and accepted Objectives are sufficient grounding sources; this feature does not add a new repository context document or external source.
- Recommendation selection may accept the recommendation while leaving its Objective statement, Success Measures, rationale, or review incomplete.
- The active queue preserves the person's selected order and remains transient until each Objective crosses the existing acceptance and persistence boundaries.
- Portfolio assessment is advisory Working Idea material and is not an Objective record or a mutation proposal.
- Additional Suggestions Reassurance indicates capability availability and does not itself ask for or imply adoption.
- Static document checks can verify delivery wording and protected contracts, but cannot alone establish runtime conversational quality.

## Out of Scope

- Changing Objective ownership, record schema, persistence, catalog generation, permanent identifiers, baseline versions, duplicate detection, overlap detection, or atomic mutation.
- Changing readiness output fields, mutation report fields, destructive confirmation, or non-write behavior.
- Changing Setup orchestration boundaries or Repository Context declaration.
- Changing the Highway Experience Standard or Profile behavior.
- Adding new Objective dimensions beyond Business Objective, Success, and Highway Relevance.
- Treating portfolio assessments or recommendations as accepted Objectives without the existing acceptance boundary.
