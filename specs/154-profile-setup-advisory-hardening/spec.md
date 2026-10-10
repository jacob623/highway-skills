# Feature Specification: Profile and Setup Advisory Hardening

**Feature Branch**: `154-profile-setup-advisory-hardening`

**Created**: 2026-10-09

**Status**: Draft

**Input**: User description: "Create a new spec for Tier 1 updates to restore Profile reassurance wording, restore the proposed-starting-point heading, reframe domain-boundary language, remove the approval loop after proposal approval, suppress Setup preambles before the Highway welcome, and require grounded advisory reasoning before applicable Profile exploratory questions."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Validate a Profile proposal without ceremonial reassurance (Priority: P1)

As a person developing organizational Profile information, I want proposal validation to distinguish convergence from uncertainty so that I can approve an accurate candidate directly and ask for help when I do not yet know an answer.

**Why this priority**: The validation exchange is the Profile owner's main acceptance boundary. Ambiguous or unconditional reassurance can create an unnecessary approval loop or make uncertainty sound like a defect.

**Independent Test**: Review each Converged Proposal delivery site and each pre-candidate reaction site in the Profile contract. Confirm that the two messages have distinct scopes, remain unemphasized, and that the conditional message disappears after the first substantive contribution in the active domain.

**Acceptance Scenarios**:

1. **Given** a Converged Proposal is presented, **When** the validation guidance is rendered, **Then** it says `If this is accurate, just say so.` and does not use the conditional unknown-answer reassurance as proposal guidance.
2. **Given** the person has not made a Substantive Contribution in the active domain, **When** the Profile invites development, **Then** it says `If you don't know, say "I don't know" and we'll work through it together.` without emphasis.
3. **Given** the person has made a first Substantive Contribution in the active domain, **When** later Profile guidance is rendered, **Then** the conditional unknown-answer reassurance is absent for that domain.
4. **Given** imported website or other external evidence is available but the person has not supplied a Substantive Contribution, **When** Profile evaluates the active domain, **Then** that evidence does not suppress the conditional reassurance.

### User Story 2 - Move between domains without implying user error (Priority: P1)

As a person offering information that touches more than one Profile domain, I want the workflow to acknowledge useful material, carry it forward, and return to the active domain without being told that I placed it incorrectly.

**Why this priority**: Domain-boundary language directly shapes whether the person experiences the workflow as collaborative or corrective.

**Independent Test**: Inspect the Profile's boundary cue and verify that it acknowledges value, says the material will be carried forward, returns to the active domain, and contains none of the prohibited ownership or error phrases.

**Acceptance Scenarios**:

1. **Given** the person offers approach or sequencing information while developing Vision, **When** Profile responds, **Then** it acknowledges the value, says it will be carried forward to Competitive Path, and returns to Vision without saying the contribution belongs elsewhere or is wrong.
2. **Given** the person's contribution could inform a later domain, **When** the boundary cue is emitted, **Then** the contribution remains available as working material and is not silently discarded or promoted to accepted content.

### User Story 3 - Reach a candidate after unambiguous approval without a second review loop (Priority: P1)

As a person who clearly approves a proposed direction, I want Profile to present the candidate directly and then ask the validation question, rather than requiring another contribution-oriented review before showing the candidate.

**Why this priority**: A redundant approval sequence increases interaction cost after the person has already supplied the decision needed to advance.

**Independent Test**: Trace the Profile flow from proposed direction through unambiguous approval, candidate presentation, and validation. Confirm that no second contribution-oriented review question occurs between approval and the candidate.

**Acceptance Scenarios**:

1. **Given** a proposed direction is materially unchanged and the person gives unambiguous approval, **When** Profile continues, **Then** it proceeds directly to the Converged Proposal and its validation question.
2. **Given** the proposal and candidate are materially identical, **When** the candidate is presented, **Then** Profile may use `Anything you'd change before we keep this?` as the validation wording.
3. **Given** approval is ambiguous or includes new substantive information, **When** Profile receives it, **Then** the existing convergence and re-evaluation rules remain applicable rather than treating the response as an unqualified shortcut.

### User Story 4 - Understand the reasoning behind exploratory Profile questions (Priority: P1)

As a person answering a non-canonical Profile exploratory question, I want to see the grounded distinction, implication, tension, possibility, tradeoff, or criterion that makes the question useful so that I can answer the actual dilemma rather than infer it.

**Why this priority**: A grounded question can still feel abrupt when its reasoning is implicit. Making one advisory addition visible improves answerability without turning the addition into accepted Profile content.

**Independent Test**: For each applicable non-canonical exploratory question, inspect the preceding output and verify one grounded advisory addition appears before the question, the question is the only emphasized element, and the addition remains outside any candidate unless later adopted.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence supports a useful distinction, implication, tension, connection, possibility, tradeoff, or decision criterion, **When** Profile asks a non-canonical exploratory question, **Then** it presents one grounded advisory addition before the question.
2. **Given** accepted Profile evidence does not support useful non-redundant reasoning, **When** Profile asks a question, **Then** it does not manufacture advisory material merely to satisfy the pattern.
3. **Given** an advisory addition is presented, **When** the person responds, **Then** the addition remains a Working Idea outside the candidate unless the person adopts it, and the response can reshape it under existing attribution and grounding rules.
4. **Given** a canonical domain question, validation question, acceptance-boundary question, or direct clarification of consequential ambiguity, **When** Profile asks it, **Then** this advisory-scaffolding requirement does not apply.

### User Story 5 - Begin Setup with the Highway welcome (Priority: P1)

As a person starting Highway setup, I want the first user-visible output to welcome me before workflow narration so that the interaction begins with the product's purpose rather than internal procedure.

**Why this priority**: The first message establishes the interaction contract and currently varies by host because procedural preambles can appear before the welcome.

**Independent Test**: Start fresh Setup and inspect the first user-visible output. Confirm it begins with the existing Highway welcome and contains none of the listed procedural preambles before it.

**Acceptance Scenarios**:

1. **Given** Setup is beginning for the first time, **When** the first user-visible output is emitted, **Then** it begins with `Welcome to Highway` and no review, loading, supplied-website, checking, or setup-order narration precedes it.
2. **Given** Setup is resumed, **When** the interaction starts, **Then** the existing resumed-Setup behavior remains in force and the fresh welcome is not emitted again.
3. **Given** the welcome has been emitted, **When** Profile begins its first owner action, **Then** Setup does not expose internal workflow progression as a preamble unless the person needs it to act.

### Edge Cases

- The person supplies a domain-complete statement directly; Profile preserves the existing short path and does not add unnecessary advisory exploration.
- Imported website evidence exists without a substantive contribution from the person; it can inform working material but does not count as that contribution for conditional reassurance or convergence.
- A proposed direction is approved while also containing new substantive information; Profile must re-evaluate the new information instead of treating the entire response as simple approval.
- A non-canonical exploratory question has no useful grounded addition available; Profile asks without inventing a distinction or tradeoff.
- A boundary-crossing contribution has value for both the active and a later domain; Profile acknowledges it, carries it forward, and continues the active domain.
- Setup resumes from an existing owner state; the welcome and first-message contract for fresh Setup must not overwrite resumed behavior.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile MUST use `If this is accurate, just say so.` as the unemphasized validation reassurance for each Converged Proposal.
- **FR-002**: Profile MUST provide the unemphasized conditional reassurance `If you don't know, say "I don't know" and we'll work through it together.` only before the first Substantive Contribution in the active domain.
- **FR-003**: Profile MUST treat imported website evidence and other external material as insufficient to count as the person's Substantive Contribution.
- **FR-004**: Profile MUST remove the conditional reassurance after the person's first Substantive Contribution in that domain.
- **FR-005**: The Experience Standard MUST require the heading `**Here is a proposed starting point for your [domain]:**` for pre-candidate invitations to react where nothing has been captured.
- **FR-006**: Profile MUST use the proposed-starting-point heading for Identity, Vision, Competitive Path, and Guiding Principles while leaving the Converged Proposal capture heading unchanged.
- **FR-007**: Profile boundary guidance MUST acknowledge the value of cross-domain material, state that it will be carried forward, and return to the active domain.
- **FR-008**: Profile boundary guidance MUST NOT imply that the person's contribution belongs in the wrong domain, is not valid for the active domain, or is user error.
- **FR-009**: Profile MUST proceed directly from unambiguous approval of a proposed direction to candidate presentation without inserting a second contribution-oriented review question.
- **FR-010**: Profile MAY use `Anything you'd change before we keep this?` when a proposed direction and its candidate are materially identical.
- **FR-011**: Profile MUST preserve re-evaluation and convergence handling when approval is ambiguous or accompanied by new substantive information.
- **FR-012**: Profile MUST present one grounded advisory addition before a non-canonical exploratory question when accepted Profile evidence supports useful non-redundant reasoning.
- **FR-013**: Profile MUST keep the advisory addition outside the candidate unless the person adopts it and MUST preserve existing attribution and Working Idea handling.
- **FR-014**: Profile MUST leave the advisory addition requirement out of canonical questions, validation questions, acceptance-boundary questions, and direct clarification of consequential ambiguity.
- **FR-015**: The Setup owner MUST emit the existing Highway welcome as the first user-visible output of fresh Setup, without procedural preambles before it.
- **FR-016**: Setup MUST preserve the existing behavior that does not emit the fresh welcome on resumed Setup interactions.
- **FR-017**: Every changed delivery site MUST remain consistent with the Experience Standard, Profile ownership boundaries, and the existing capture and acceptance contracts.
- **FR-018**: The feature MUST provide document-level verification for every changed wording, heading, flow constraint, advisory-scaffolding condition, and welcome-order constraint.

## Key Entities *(include if feature involves data)*

- **Working Idea**: Non-authoritative material developed during interaction, including an advisory addition, before the person adopts it.
- **Substantive Contribution**: A person-supplied addition, change, correction, removal, redirection, or qualification that affects the active subject.
- **Converged Proposal**: A complete Profile candidate presented under the existing capture heading and subject to the owner's validation question.
- **Advisory Addition**: One grounded distinction, implication, tension, connection, possibility, tradeoff, or decision criterion presented before an applicable exploratory question.
- **Fresh Setup**: An initial Setup interaction before any resumed owner state exists.
- **Resumed Setup**: A Setup interaction continuing from existing owner readiness or interaction state.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of Profile Converged Proposal delivery sites use the restored validation reassurance, and 0% use the conditional unknown-answer reassurance as unconditional proposal guidance.
- **SC-002**: 100% of active domains suppress the conditional unknown-answer reassurance after the first Substantive Contribution, while imported external evidence alone suppresses it in 0% of cases.
- **SC-003**: 100% of pre-candidate no-capture invitations use the proposed-starting-point heading, and 0% use the retired reaction heading.
- **SC-004**: 100% of tested cross-domain boundary examples acknowledge value, carry material forward, and return to the active domain; 0% contain prohibited user-error framing.
- **SC-005**: 100% of unambiguous approval examples reach candidate presentation without an intervening contribution-oriented review question.
- **SC-006**: 100% of applicable exploratory-question examples contain exactly one grounded advisory addition before the question, with the question as the only emphasized element.
- **SC-007**: 100% of fresh Setup traces begin with the Highway welcome, with 0 procedural preambles preceding it; resumed Setup traces preserve the no-repeat behavior.
- **SC-008**: The existing full verification suite remains passing after the delivery sites are changed, with no reduction in existing Profile or Setup coverage.
- **SC-009**: A human review of representative fresh, resumed, direct-contribution, imported-evidence, approval, boundary, and exploratory-question traces rates the updated interactions as understandable and non-corrective in at least 90% of cases.

## Assumptions

- The requested `highway-setup/setup.md` refers to the repository's current Setup owner contract at `.highway/skills/highway-setup/SKILL.md`; no `setup.md` file exists in the current source tree.
- The proposed-starting-point heading is a user-visible Experience Standard rule and therefore requires an X2.72 amendment, while the other requested Profile and Setup wording remains owned by those skills.
- The existing Profile capture heading, acceptance boundary, attribution rules, Working Idea semantics, and resumed Setup behavior remain authoritative unless this feature explicitly changes them.
- External or imported evidence may inform Profile reasoning but is not the person's Substantive Contribution unless the person adopts or changes it.
- Document-level checks can establish delivery-site presence and shape; conversational quality and whether hosts follow the text require deferred human evaluation.
- No new persistence schema, artifact type, or cross-owner domain semantics are required.

## Out of Scope

- Changing the Profile capture heading or the meaning of Profile domain completeness.
- Changing generic Experience Standard rules beyond X2.72 unless implementation discovers a direct contract conflict that requires an explicit follow-up decision.
- Changing the content or ordering of Objectives, Controls, or NFR owner workflows.
- Proving runtime conversational behavior solely through static document checks.
