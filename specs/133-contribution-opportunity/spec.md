# Feature Specification: Contribution Opportunity Before Convergence

**Feature Branch**: `133-contribution-opportunity`

**Created**: 2026-10-02

**Status**: Draft

**Input**: User description: "Update only `experience-standard.md` to add a shared Contribution Opportunity before convergence when Highway materially shaped a Working Idea, while preserving mature-contribution exemptions, acceptance semantics, and owner-specific workflow boundaries."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Give the Person a Substantive Contribution Opportunity (Priority: P1)

As a person collaborating with Highway on a developing idea, I want an opportunity to add, correct,
remove, or extend the substantive content before Highway turns it into a final proposal, so that
Highway's synthesis does not close the meaning before I have had a meaningful chance to shape it.

**Why this priority**: This is the missing interaction boundary. Highway may understand the shape of
an idea through interpretation, synthesis, recommendations, or cross-context connections before the
person has contributed to that developed shape.

**Independent Test**: Review a materially Highway-shaped Working Idea that is approaching convergence;
confirm the person can contribute to the substance before the Converged Proposal unless a prior
interaction already provided that opportunity.

**Acceptance Scenarios**:

1. **Given** Highway has materially shaped a Working Idea and no equivalent opportunity has occurred,
   **When** the idea approaches convergence, **Then** the person receives a Contribution Opportunity
   before the Converged Proposal.
2. **Given** a Contribution Opportunity is presented, **When** the person adds, corrects, removes, or
   extends substance, **Then** the Working Idea remains active and Highway incorporates and re-evaluates
   that contribution.
3. **Given** the person indicates nothing else is needed, **When** the response is processed, **Then**
   Highway may synthesize the Converged Proposal without treating that response as artifact acceptance.
4. **Given** Highway has not materially shaped the substantive result, **When** the person supplied the
   domain content directly, **Then** no ceremonial Contribution Opportunity is required.

---

### User Story 2 - Keep Substance and Final Representation Distinct (Priority: P1)

As a person reviewing a developing idea, I want the Contribution Opportunity to show provisional
substance rather than repeat the final artifact, so that I can complete the meaning once and review the
final representation once.

**Why this priority**: The Contribution Opportunity is not another acceptance step. Its value depends
on distinguishing substantive completeness from the final artifact representation.

**Independent Test**: Compare a compliant interaction with a duplicate-prose interaction; confirm the
Contribution Opportunity uses decomposed or provisional substance and the Converged Proposal synthesizes
that result once under the existing acceptance boundary.

**Acceptance Scenarios**:

1. **Given** a Working Idea has substantial Highway-authored framing, **When** Highway presents a
   Contribution Opportunity, **Then** it may show themes, bullets, distinctions, alternatives,
   implications, or other provisional substantive pieces.
2. **Given** the person has responded to the provisional substance, **When** Highway converges,
   **Then** it synthesizes the complete artifact representation once rather than repeating substantially
   identical final-form prose.
3. **Given** an artifact acceptance boundary is presented, **When** the person reviews it, **Then** the
   existing Converged Proposal heading and single acceptance request remain unchanged.

---

### User Story 3 - Preserve Adaptive Depth and One-Question Discipline (Priority: P1)

As a person using an adaptive conversational workflow, I want Contribution Opportunities only when they
add substantive value, so that Highway does not impose a recurring "anything else?" prompt or combine
two response-demanding boundaries in one interaction.

**Why this priority**: The shared behavior must strengthen participation without making every workflow
longer or ceremonial.

**Independent Test**: Exercise mature contributions, prior contribution opportunities, explicitly
selected proposals, and incomplete collaboratively developed ideas; confirm only applicable paths receive
the opportunity and no Contribution Opportunity is combined with artifact acceptance.

**Acceptance Scenarios**:

1. **Given** the person's contribution is domain-complete and Highway is not materially changing it,
   **When** convergence is available, **Then** Highway may proceed without another contribution turn.
2. **Given** the immediately preceding collaboration already invited additions, corrections, omissions,
   or extensions, **When** the idea approaches convergence, **Then** Highway does not ask a duplicate
   Contribution Opportunity.
3. **Given** a Contribution Opportunity is needed, **When** Highway presents it, **Then** it is the
   response-demanding question for that interaction and is not combined with artifact acceptance.
4. **Given** the person explicitly wants to proceed or indicates they are finished contributing,
   **When** the workflow continues, **Then** Highway does not add a ceremonial opportunity.

---

### User Story 4 - Preserve Existing Authority and Owner Boundaries (Priority: P1)

As an owner of knowledge managed by an Interactive Workflow, I want Contribution Opportunity to remain
transient shared guidance, so that it does not create new artifact state, change acceptance authority,
or make Setup and individual owners responsible for a shared interaction rule.

**Why this priority**: The amendment must improve collaboration without changing persistence, ownership,
or the existing contribution-first lifecycle.

**Independent Test**: Review the Experience Standard against existing acceptance and persistence rules;
confirm Contribution Opportunity remains inside Working Idea development and does not alter Profile,
Objectives, Controls, NFRs, Setup, or Constitution artifacts.

**Acceptance Scenarios**:

1. **Given** a Contribution Opportunity is presented, **When** the person responds, **Then** the content
   remains transient Working Idea material unless a later Converged Proposal crosses the existing
   acceptance boundary.
2. **Given** the person responds "No, that's everything," **When** Highway continues, **Then** that
   response means no further substantive contribution is needed and does not itself authorize persistence.
3. **Given** a workflow already has a complete Converged Proposal, **When** it follows existing
   acceptance behavior, **Then** Contribution Opportunity does not redefine X2.18, X2.21, X2.22, X2.25,
   or the Artifact Acceptance Boundary.
4. **Given** an owner workflow determines domain completeness, **When** it applies the shared standard,
   **Then** Setup does not manufacture or independently decide whether to show a Contribution Opportunity.

### Edge Cases

- A mature user-supplied domain contribution must not receive an unnecessary opportunity merely because
  the shared behavior exists.
- A person may add, correct, remove, extend, redirect, or reject part of the developing substance; the
  Working Idea remains active while Highway incorporates and re-evaluates the response.
- A preceding interaction may already have provided an equivalent opportunity, so a second one is skipped.
- An explicitly selected Converged Proposal follows existing acceptance behavior without a redundant
  Contribution Opportunity.
- A Contribution Opportunity may be useful after recommendations, alternatives, inferred implications,
  cross-context synthesis, or substantial Highway-authored framing, but it is not required after every
  collaborative turn.
- A Contribution Opportunity response must not be treated as artifact acceptance unless the same response
  independently satisfies an already-presented acceptance boundary.
- One response-demanding Contribution Opportunity must not be combined with a separate acceptance question.
- Natural language examples remain non-prescriptive; no fixed phrase is required.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST define Contribution Opportunity as a conversational opportunity
  to add, correct, remove, or extend substantive elements of a developed Working Idea before synthesis
  into a Converged Proposal.
- **FR-002**: The definition MUST state that Contribution Opportunity is transient collaborative
  development and MUST NOT define it as retained state, provisional acceptance, artifact review,
  persistence approval, or workflow completion.
- **FR-003**: The Experience Standard MUST add the next unused X2 rule requiring a Contribution Opportunity
  when Highway materially shaped a Working Idea and no prior meaningful opportunity occurred.
- **FR-004**: The new X2 rule MUST identify that the person can add, correct, remove, or extend developed
  substance before convergence, with exemptions for domain-complete user contributions and prior equivalent
  opportunity.
- **FR-005**: The Interaction model MUST describe the lifecycle from Working Idea development through a
  Contribution Opportunity when applicable, incorporation and re-evaluation, Converged Proposal synthesis,
  and existing acceptance.
- **FR-006**: The Interaction model MUST allow a mature or user-supplied domain-complete contribution to
  converge without another contribution turn.
- **FR-007**: The Experience Standard MUST explain that Contribution Opportunity addresses substantive
  participation and is not another approval or completion step.
- **FR-008**: Contribution Opportunity guidance MUST allow provisional, decomposed substance such as
  themes, bullets, distinctions, alternatives, implications, or substantive components.
- **FR-009**: The guidance MUST distinguish Contribution Opportunity's substantive-completeness purpose
  from Converged Proposal's final-representation and artifact-acceptance purpose.
- **FR-010**: The guidance MUST discourage presenting substantially identical final-form prose at both
  boundaries when provisional substance can be synthesized once afterward.
- **FR-011**: The Experience Standard MUST provide non-prescriptive example language for inviting additions,
  corrections, removals, or extensions and MUST identify the examples as non-required templates.
- **FR-012**: The guidance MUST preserve the X2.21 Converged Proposal review heading and acceptance
  boundary, with Contribution Opportunity occurring before that boundary.
- **FR-013**: A response to Contribution Opportunity MUST keep the Working Idea active when the person adds,
  corrects, removes, or extends content, and Highway MUST re-evaluate that developed understanding.
- **FR-014**: A response indicating that nothing else is needed MAY allow synthesis without another
  development question but MUST NOT itself authorize persistence absent an independently satisfied acceptance
  boundary.
- **FR-015**: The guidance MUST identify circumstances where Contribution Opportunity is especially useful,
  including incomplete-input interpretation, accumulated-context synthesis, recommendations or alternatives,
  cross-context connections, inferred implications, and substantial Highway-authored framing.
- **FR-016**: The guidance MUST identify circumstances where a distinct Contribution Opportunity is skipped,
  including complete user contribution, prior equivalent opportunity, explicit completion of contribution,
  explicit desire to proceed, ceremonial questioning, and selected Converged Proposal processing.
- **FR-017**: Contribution Opportunity MUST remain subject to existing one-question constraints and MUST NOT
  be combined with a separate artifact-acceptance question in the same interaction block.
- **FR-018**: The Experience Standard MUST include interaction examples for Contribution Opportunity before
  convergence, substance versus representation, and mature contribution exemptions.
- **FR-019**: The existing Working Idea versus Converged Proposal example MUST be updated to show optional
  Contribution Opportunity after Highway materially shapes substance and before final synthesis.
- **FR-020**: Recommendation-set guidance MUST explain that positive reactions may develop a Working Idea,
  substantial later synthesis may warrant Contribution Opportunity, and explicitly displayed Converged
  Proposals retain existing behavior without redundant confirmation.
- **FR-021**: The amendment MUST remain shared Interactive Workflow guidance and MUST NOT scope Contribution
  Opportunity to Setup, Profile, Objectives, Controls, or NFRs.
- **FR-022**: The amendment MUST NOT add persistence, artifact lifecycle, workflow checkpoint, or marker
  state for Contribution Opportunity.
- **FR-023**: The amendment MUST preserve Working Idea authority, Converged Proposal authority, acceptance
  semantics, owner mutation, persistence, Accepted Knowledge, and Contextual Re-evaluation.
- **FR-024**: The amendment MUST preserve contribution-first behavior, including Converged Proposal when
  already supported, otherwise useful Working Idea, otherwise focused unresolved question.
- **FR-025**: The amendment MUST preserve adaptive depth and MUST NOT make "Anything else?" a mandatory
  pre-acceptance prompt.
- **FR-026**: The version change MUST follow the current Experience Standard Versioning Policy and document
  its rationale without renumbering existing X rules.
- **FR-027**: The implementation scope MUST modify only `experience-standard.md`; Profile, Objectives,
  Controls, NFRs, Setup, Constitution, templates, and retained artifact structures remain unchanged.

### Key Entities

- **Working Idea**: A transient, developing understanding that may be interpreted, sharpened, compared,
  connected, challenged, or extended before it is complete.
- **Contribution Opportunity**: A transient conversational boundary within Working Idea development where
  the person can add, correct, remove, or extend substantive content before convergence.
- **Converged Proposal**: The complete artifact representation synthesized after applicable development and
  subject to the existing acceptance boundary.
- **Artifact Acceptance Boundary**: The existing authority boundary where acceptance authorizes the owner's
  established mutation and persistence behavior.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of reviewed scenarios where Highway materially shaped a Working Idea and no equivalent
  prior opportunity occurred, a person can contribute to the developed substance before the Converged Proposal.
- **SC-002**: In 100% of reviewed mature-contribution and prior-opportunity scenarios, Highway does not add a
  ceremonial Contribution Opportunity.
- **SC-003**: In 100% of reviewed interactions containing a Contribution Opportunity, it is distinct from
  artifact acceptance and no separate acceptance question is combined in the same interaction block.
- **SC-004**: In 100% of reviewed compliant examples, the Contribution Opportunity uses provisional substance
  where appropriate and the complete final-form representation is synthesized no more than once afterward.
- **SC-005**: 100% of reviewed Contribution Opportunity responses preserve transient Working Idea semantics
  until an existing Converged Proposal acceptance boundary is independently satisfied.
- **SC-006**: The existing X2.21 heading, acceptance behavior, contribution-first order, mature-contribution
  exemption, and owner authority remain unchanged in contract review.
- **SC-007**: No new persisted Contribution Opportunity, provisional, completion-pending, or workflow-checkpoint
  state appears in the shared guidance or retained artifact model.
- **SC-008**: Focused Experience Standard validation passes with zero failures, and protected owner-specific
  artifacts remain unchanged.

## Assumptions

- The Experience Standard remains the authoritative owner of generic conversational boundaries for Interactive
  Workflows.
- Existing X2 identifiers are stable; the amendment adds the next unused identifier without renumbering rules.
- The current development-versioning policy governs the Experience Standard version update.
- A meaningful opportunity may be expressed naturally; the standard does not require one literal phrase.
- Owner workflows remain responsible for domain completeness and their existing acceptance and persistence behavior.
- The amendment is documentation and contract guidance only; no new runtime, storage, or retained artifact state
  is required.
