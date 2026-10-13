# Feature Specification: Identity Discovery Contribution Opportunity

**Feature Branch**: `165-identity-discovery-review`

**Created**: 2026-10-13

**Status**: Draft

**Input**: User description: "Update highway-profile to include a structured Identity Discovery Contribution Opportunity for website content, imported material, or discovery evidence before Identity convergence, using evidence-grounded organizational expressions and preserving proposed-evidence, acceptance, and retained-narrative boundaries."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review discovered organizational expressions (Priority: P1)

As a person developing organizational Identity, I want Highway to show what it believes the organization meaningfully does before Identity convergence so that omissions in website, imported, or discovery evidence are easy to detect.

**Why this priority**: The review is the primary value of the feature: it gives the person a structured opportunity to notice important organizational expressions before they become part of the accepted Identity narrative.

**Independent Test**: Provide website content, imported material, or discovery evidence containing several organizational expressions; verify that Highway presents a structured Identity review before the Identity Converged Proposal and asks what to add, correct, or remove.

**Acceptance Scenarios**:

1. **Given** website content materially contributes to Identity development, **When** Identity is ready to converge, **Then** Highway presents a structured Identity review before the existing Identity Converged Proposal.
2. **Given** imported material materially contributes to Identity development, **When** Identity is ready to converge, **Then** the review includes meaningful expressions supported by that material and does not present them as accepted Profile content.
3. **Given** discovery evidence materially contributes to Identity development, **When** Highway presents the review, **Then** the person can add, correct, or remove findings before normal Identity convergence continues.
4. **Given** no website, imported material, or discovery evidence materially contributes to Identity development, **When** Identity converges, **Then** Highway may continue the existing Identity flow without manufacturing a review.

### User Story 2 - Understand meaningful expressions rather than labels (Priority: P1)

As a person reviewing Identity evidence, I want each finding to explain a meaningful organizational expression in evidence-grounded language so that I can evaluate substance rather than react to isolated category labels.

**Why this priority**: Concise titles paired with summaries make omission detection useful while avoiding a fixed taxonomy or unsupported classification of the organization.

**Independent Test**: Inspect review findings derived from representative evidence and verify that each has a concise meaningful title and a one-sentence evidence-grounded summary, while isolated nouns and labels are excluded.

**Acceptance Scenarios**:

1. **Given** evidence supports retail craft kits, **When** Highway presents the finding, **Then** it uses a meaningful title and explains the offering in one evidence-grounded sentence rather than showing only "Craft Kits."
2. **Given** evidence supports curriculum, classes, or workshops, **When** Highway presents findings, **Then** each finding explains the organizational expression and does not rely on an isolated noun or label.
3. **Given** evidence spans products, services, programs, activities, audiences, communities, delivery models, or revenue-generating offerings, **When** Highway selects findings, **Then** it may include any significant supported expression without requiring a fixed taxonomy.
4. **Given** a proposed finding is weakly supported or only a generic category label, **When** Highway evaluates it for review, **Then** it omits or reframes the finding rather than presenting unsupported organizational fact.

### User Story 3 - Preserve Identity convergence and ownership boundaries (Priority: P1)

As a person accepting organizational Identity, I want the discovery review to remain proposed evidence and lead into the existing convergence and acceptance flow so that the review improves validation without changing what is retained or which workflow owns it.

**Why this priority**: The review must improve omission detection without becoming a second acceptance mechanism, a new Profile schema, or a replacement for the retained Identity narrative.

**Independent Test**: Trace a review through correction, Identity convergence, proposal presentation, and acceptance; verify that only the existing accepted Identity narrative crosses the existing acceptance boundary and that no new readiness or ownership behavior appears.

**Acceptance Scenarios**:

1. **Given** the review is complete, **When** Identity development continues, **Then** Highway proceeds with normal Identity convergence and presents the existing Identity Converged Proposal.
2. **Given** the person adds, corrects, or removes a review finding, **When** Identity convergence continues, **Then** the response informs working Identity development without being retained before the existing Identity proposal is accepted.
3. **Given** the person accepts the Identity Converged Proposal, **When** Profile persists Identity, **Then** the retained content uses the existing accepted narrative representation and existing persistence boundary.
4. **Given** the review contains proposed evidence, **When** readiness is assessed, **Then** the review does not create a new readiness dimension or independently establish Identity completeness.
5. **Given** the person adds, corrects, removes, combines, splits, or otherwise changes a presented finding, **When** Profile receives the response, **Then** it treats the response as a modification to proposed Identity evidence, re-synthesizes the review, and presents the updated review again.
6. **Given** the person supplies a correction to a finding, **When** meaningful contribution changes may still continue, **Then** Profile remains in the Identity Discovery Contribution Opportunity rather than transitioning immediately to the Identity Converged Proposal.
7. **Given** the person indicates the findings are accurate or no longer provides substantive additions, corrections, removals, combinations, or splits, **When** Profile continues, **Then** it transitions to normal Identity convergence and produces the Identity Converged Proposal from the accepted discovery-contribution understanding.

### Edge Cases

- Website content supports several expressions that overlap; Highway may present distinct meaningful expressions but should avoid redundant findings.
- Imported material includes a product or program name without enough evidence to explain what the organization does; Highway keeps it proposed or omits it rather than treating the name as an organizational expression.
- Discovery evidence supports an audience or community but not a distinct offering; Highway may include it when it is a significant organizational expression and can be summarized accurately.
- Evidence contributes to Identity and another Profile domain; the review remains Identity-owned while existing cross-domain reasoning continues to apply.
- The person rejects or removes a finding; Highway does not reintroduce the rejected substance as accepted Identity without new supporting evidence and the existing acceptance flow.
- A review is unnecessary because no material external or discovery evidence contributes; the existing Identity convergence path remains available.
- Evidence is ambiguous, contradictory, or unavailable; Highway presents uncertainty or omits the finding rather than inventing organizational facts.
- The person provides a domain-complete Identity contribution directly; the review does not add redundant ceremony where no material discovery evidence requires omission detection.
- The person changes several findings in one response; Profile treats the response as one updated proposed-evidence understanding and re-presents the review without creating a second acceptance boundary.
- The person corrects a finding but other omissions or meaningful changes remain; Profile stays in the review loop until the findings stabilize.
- The findings are unchanged after review and further material changes are unlikely; Profile may transition to normal convergence.

## Proposed Identity Discovery Contribution Opportunity Contract

###### Identity Discovery Contribution Opportunity

When website content, imported material, or discovery evidence materially contributes to Identity development,
present a structured Identity review before Identity convergence.

The purpose of this review is omission detection rather than categorization.

The review remains proposed evidence and is not retained Profile content.

Each finding must contain:

- a concise, visually distinct title representing a meaningful organizational expression;
- a one-sentence evidence-grounded summary explaining what Highway believes it found.

Do not emit isolated nouns or labels.

Prefer:

**Retail Craft Kits:**
Studio-tested craft projects are packaged with materials and instructions so customers can complete the creative experience outside the studio.

**Homeschool Curriculum:**
Lessons proven through real studio instruction are organized into curriculum that homeschool families can implement independently.

**Studio Classes:**
The organization delivers instructor-led classes that serve both as educational offerings and as a proving ground for future curriculum and products.

**Community Workshops:**
Hands-on workshops bring participants together to learn, share skills, and contribute to a growing creative community.

Avoid:

- Craft Kits
- Curriculum
- Classes
- Workshops

The review may include:

- products;
- services;
- programs;
- activities;
- audiences;
- communities served;
- delivery models;
- revenue-generating offerings;
- other significant organizational expressions.

A fixed taxonomy is not required.

Identity review should resemble:

Here's what Highway believes [Organization Name] does.

When Organization Name has not been accepted, use the accepted Repository Name where natural.

**Retail Craft Kits:**
<one-sentence summary>

**Homeschool Curriculum:**
<one-sentence summary>

**Studio Classes:**
<one-sentence summary>

**Community Workshops:**
<one-sentence summary>

What would you add, correct, or remove?

The purpose is to make missing organizational expressions easy to detect before synthesis into the
accepted Identity narrative.

The Identity Discovery Contribution Opportunity is a Contribution Opportunity rather than a Converged Proposal.

When the person adds, corrects, removes, combines, splits, or otherwise changes the presented
findings, treat the response as modifications to proposed Identity evidence.

Re-synthesize and re-present the Identity Discovery Contribution Opportunity using the updated understanding.

Do not transition immediately to the Identity Converged Proposal merely because the person supplied
a correction.

Remain within the Identity Discovery Contribution Opportunity while:

- omissions are being identified;
- findings are being corrected;
- findings are being expanded;
- meaningful discovery-contribution changes continue occurring.

Transition to normal Identity convergence only after the person indicates the findings are accurate,
or no longer provides substantive additions, corrections, removals, combinations, or splits.

The discovery-contribution representation and the final Identity Converged Proposal are separate artifacts.

Identity Discovery Contribution Opportunity
-> User Validation and Correction
-> Updated Identity Discovery Contribution Opportunity
-> Convergence
-> Identity Converged Proposal

The Identity Converged Proposal is produced from the accepted discovery-contribution understanding rather
than replacing the first discovery-contribution correction cycle.

After review stabilizes, continue normal Identity convergence and present the existing Identity Converged Proposal.

#### Existing Profile Setup Prompt

The existing Profile setup guidance remains:

#### Let's get to know your organization

Then ask:

**What would you like to call your Highway repository?**

Directly beneath that question, add this plain-text guidance:

Using your organization's name is often a good choice.

This guidance helps a person who is unsure what to call the repository without changing the
repository-name acceptance boundary.

###### Review Boundary

The discovery review:

- exists only to improve validation;
- does not introduce new Profile fields;
- does not create new readiness dimensions;
- does not change domain ownership;
- does not replace the retained narrative structure;
- remains proposed evidence until accepted.

Retained Profile content continues to use the existing accepted narrative representation defined by the Profile owner contract.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile MUST provide an optional structured Identity Discovery Contribution Opportunity when website content, imported material, or discovery evidence materially contributes to Identity development.
- **FR-002**: Profile MUST present the Identity Discovery Contribution Opportunity before Identity convergence and before presenting the existing Identity Converged Proposal.
- **FR-003**: The review MUST state or otherwise preserve that its purpose is omission detection rather than categorization.
- **FR-004**: Each review finding MUST contain a concise, visually distinct title representing a meaningful organizational expression and a one-sentence evidence-grounded summary of what Highway believes it found.
- **FR-005**: Profile MUST NOT present isolated nouns or labels as review findings without an explanatory evidence-grounded summary.
- **FR-006**: The review MAY include products, services, programs, activities, audiences, communities served, delivery models, revenue-generating offerings, and other significant organizational expressions when supported by evidence.
- **FR-007**: Profile MUST NOT require or imply a fixed taxonomy for Identity Discovery Contribution Opportunity findings.
- **FR-008**: The review MUST include a correction-oriented invitation equivalent to "What would you add, correct, or remove?" so the person can identify omissions and inaccuracies.
- **FR-009**: Review findings MUST remain proposed evidence and MUST NOT become retained Profile content before the existing Identity Converged Proposal is presented and accepted.
- **FR-010**: After the review, Profile MUST continue normal Identity convergence and present the existing Identity Converged Proposal under the existing Identity capture contract.
- **FR-011**: The review MUST NOT introduce new Profile fields, new readiness dimensions, new domain ownership, or a replacement for the retained Identity narrative structure.
- **FR-012**: The review MUST preserve existing Profile acceptance, persistence, attribution, cross-domain reasoning, readiness, and user-authority boundaries.
- **FR-013**: Profile MUST omit or qualify findings that are unsupported, materially ambiguous, or reducible to an isolated label rather than presenting them as organizational fact.
- **FR-014**: When no discovery evidence materially contributes to Identity development, Profile MUST preserve the existing Identity convergence flow without requiring a discovery review.
- **FR-015**: Profile MUST place the plain-text guidance "Using your organization's name is often a good choice." directly beneath the existing Highway repository-name question under "Let's get to know your organization".
- **FR-016**: The Identity Discovery Contribution Opportunity MUST be a Contribution Opportunity and MUST NOT be presented as a Converged Proposal or acceptance request.
- **FR-017**: When the person adds, corrects, removes, combines, splits, or otherwise changes presented findings, Profile MUST treat the response as a modification to proposed Identity evidence.
- **FR-018**: After a material contribution modification, Profile MUST re-synthesize and re-present the updated Identity Discovery Contribution Opportunity before proceeding to normal Identity convergence.
- **FR-019**: Profile MUST NOT transition immediately to the Identity Converged Proposal merely because the person supplied a correction.
- **FR-020**: Profile MUST remain within the Identity Discovery Contribution Opportunity while omissions are being identified, findings are being corrected or expanded, or meaningful discovery-contribution changes continue.
- **FR-021**: Profile MAY transition to normal Identity convergence only after the person indicates the findings are accurate, or no longer provides substantive additions, corrections, removals, combinations, or splits.
- **FR-022**: The discovery-contribution representation and final Identity Converged Proposal MUST remain separate artifacts, and the final proposal MUST be produced from the accepted discovery-contribution understanding.

## Key Entities *(include if feature involves data)*

- **Identity Discovery Contribution Opportunity**: A transient, structured presentation of proposed organizational expressions used to detect omissions before Identity convergence.
- **Review Finding**: A proposed meaningful organizational expression with a concise title and one-sentence evidence-grounded summary.
- **Discovery Evidence**: Website content, imported material, or other evidence that materially contributes to Identity development while remaining proposed until accepted through the existing boundary.
- **Identity Converged Proposal**: The existing complete Identity candidate presented after normal convergence and subject to the existing Identity acceptance boundary.
- **Accepted Identity Narrative**: The existing user-owned Identity representation retained only after the existing proposal has been presented and accepted.
- **Identity Review Contribution Opportunity**: The transient invitation to add, correct, remove, combine, split, or otherwise change proposed Identity findings before convergence; it is not a candidate or acceptance request.
- **Updated Discovery Review**: A re-synthesized proposed-evidence representation produced after a material change to the prior review.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of representative cases where website, imported, or discovery evidence materially contributes to Identity present the Identity Discovery Contribution Opportunity before the existing Identity Converged Proposal.
- **SC-002**: 100% of review findings contain both a meaningful title and exactly one concise evidence-grounded summary sentence.
- **SC-003**: 0% of representative review outputs present an isolated noun or label as a finding without an explanatory summary.
- **SC-004**: 100% of representative review outputs support adding, correcting, or removing findings through the existing correction-oriented interaction.
- **SC-005**: 100% of representative review traces keep findings proposed until the existing Identity Converged Proposal is accepted; 0% retain review findings through a separate acceptance path.
- **SC-006**: 100% of representative post-review traces continue normal Identity convergence and use the existing Identity proposal and acceptance contract.
- **SC-007**: 0% of representative checks identify new Profile fields, readiness dimensions, domain ownership changes, or replacement retained-narrative structures caused by the review.
- **SC-008**: 100% of representative cases without materially contributing discovery evidence preserve the existing Identity convergence flow without mandatory review ceremony.
- **SC-009**: At least 90% of human reviewers judge representative review findings understandable, evidence-grounded, and useful for detecting omissions rather than categorizing the organization.
- **SC-010**: Existing Profile and full repository verification suites remain passing after the Identity Discovery Contribution Opportunity guidance is added.
- **SC-011**: 100% of representative fresh Profile setup traces place the exact plain-text repository-name guidance directly beneath the repository-name question.
- **SC-012**: 100% of representative material corrections, additions, removals, combinations, or splits re-present an updated Identity Discovery Contribution Opportunity before convergence.
- **SC-013**: 0% of representative correction traces transition directly from a changed review finding to the Identity Converged Proposal while meaningful review changes remain.
- **SC-014**: 100% of representative stable-review traces transition through normal convergence to the existing Identity Converged Proposal, with the discovery review and final proposal represented separately.
- **SC-015**: At least 90% of human reviewers identify the review as a correction-oriented Contribution Opportunity rather than an acceptance request or final Identity candidate.

## Assumptions

- The current Profile owner remains authoritative for Identity meaning, completeness, convergence, acceptance, persistence, readiness, and retained narrative representation.
- Website content and imported material remain proposed evidence until the person accepts the resulting Identity proposal; external material alone is not a user Substantive Contribution.
- The review is optional and is invoked only when discovery evidence materially contributes to Identity development.
- The existing validation question remains the correction-oriented interaction used after a candidate or proposal is presented.
- A one-sentence summary may contain multiple clauses when needed to explain the evidence-grounded organizational expression clearly.
- Static document checks can verify required wording, ordering, finding shape, and protected boundaries; human review remains necessary for evidence quality and conversational usefulness.
- The repository-name guidance is explanatory only and does not imply acceptance of Organization Name or any other organizational fact.
- No new persistence schema, artifact type, or readiness calculation is required.

## Out of Scope

- Changing the Profile record schema or retained Identity narrative representation.
- Creating a separate persisted Identity Discovery Contribution Opportunity artifact.
- Adding new Profile readiness dimensions or changing Profile domain ownership.
- Replacing Identity convergence, the existing Identity Converged Proposal, the existing validation question, or the existing acceptance boundary.
- Defining a fixed taxonomy or classifying organizations into mandatory categories.
- Changing Objective, Control, NFR, ADR, Setup, or Highway Identity ownership.
- Treating website, imported, or discovery evidence as accepted organizational fact without the existing acceptance boundary.
