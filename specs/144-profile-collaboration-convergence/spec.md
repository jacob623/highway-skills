# Feature Specification: Profile Collaboration Convergence

**Feature Branch**: `144-profile-collaboration-convergence`

**Created**: 2026-10-06

**Status**: Draft

**Input**: User description: "Improve highway-profile so domain completeness does not cause premature artifact convergence, and add generalized transcript-based behavioral evaluations for collaborative Profile development while preserving existing governance ownership, persistence, readiness, and acceptance contracts."

## Clarifications

### Session 2026-10-06

- Q: Should the eight behavioral transcript fixtures be required to run automatically as part of the repository's full validation suite? → A: Yes. All eight fixtures will run through the development validation workflow; Profile saving remains unchanged and the fixtures remain outside runtime dependencies.

## User Scenarios & Testing

### User Story 1 - Develop meaningful Profile understanding before convergence (Priority: P1)

As a person describing an organization, I want newly supplied evidence to be reconsidered with what is already known so that the Profile reflects meaningful relationships and implications rather than a polished list of facts.

**Why this priority**: Premature convergence can preserve an incomplete or misleading organizational understanding, while unsupported interpretation can create false organizational facts.

**Independent Test**: Provide a complete active domain, then introduce evidence that could materially change its meaning. Verify that the response either develops a grounded provisional Working Idea before proposing convergence or proceeds directly when no useful development remains.

**Acceptance Scenarios**:

1. **Given** an active Profile domain with newly introduced organizational evidence, **When** the evidence reveals a supported relationship, implication, distinction, tension, alternative, opportunity, concern, or recommendation that could change the domain, **Then** the response develops that material provisionally before the domain's Converged Proposal.
2. **Given** new evidence that does not expose a supported substantive relationship or consequential ambiguity, **When** the domain is otherwise complete, **Then** the workflow may proceed toward the existing Converged Proposal without manufacturing another exploratory exchange.
3. **Given** an apparent relationship unsupported by active or accepted evidence, **When** the domain is evaluated, **Then** Profile does not present the relationship as organizational fact merely to appear collaborative.

### User Story 2 - Preserve user authority during collaborative development (Priority: P1)

As a person reviewing an organizational interpretation, I want model-originated connections and implications to remain provisional until I can meaningfully change or reject them.

**Why this priority**: The retained Profile must contain accepted organizational knowledge, not silent model assumptions.

**Independent Test**: Supply evidence that supports a grounded interpretation, then provide a correction, narrowing, rejection, or redirection. Verify that the next response reflects the person's substantive change and that only accepted content can enter the retained Profile.

**Acceptance Scenarios**:

1. **Given** Highway materially shaped a Working Idea, **When** no equivalent contribution opportunity has already occurred, **Then** the person receives a genuine opportunity to add, correct, remove, redirect, narrow, reject, or extend the substance before final convergence.
2. **Given** the person corrects or redirects a provisional interpretation, **When** the next response is produced, **Then** the response reflects the correction and does not retain the superseded interpretation as accepted fact.
3. **Given** a cross-domain implication is identified, **When** it belongs to another unresolved domain, **Then** Profile preserves it for the appropriate later domain rather than forcing it into the active domain.

### User Story 3 - Resolve ambiguity without ritualized questioning (Priority: P1)

As a person contributing Profile information, I want clear input handled directly and consequential ambiguity resolved with one focused question so that collaboration is neither mechanical nor presumptive.

**Why this priority**: Clarification should address user-owned uncertainty without asking for repetition or silently choosing a meaning that only the person can decide.

**Independent Test**: Run one clear-input transcript and one materially ambiguous transcript. Verify direct incorporation in the first and one focused clarification before advancement in the second.

**Acceptance Scenarios**:

1. **Given** the contribution has one responsible interpretation in context, **When** Profile processes it, **Then** Profile incorporates or develops it without ceremonial clarification.
2. **Given** two or more interpretations would materially change the resulting domain and only the person can resolve the difference, **When** Profile processes the contribution, **Then** Profile asks one focused clarification question before advancing.
3. **Given** accepted evidence is already available, **When** a new domain question is considered, **Then** Profile does not ask the person to repeat that evidence.

### User Story 4 - Evaluate collaborative behavior across varied transcripts (Priority: P2)

As a maintainer evaluating Profile behavior across executing agents, I want reusable synthetic transcript fixtures and a semantic rubric so that behavioral regressions can be detected without requiring exact response wording or model-specific branches.

**Why this priority**: Static phrase checks cannot reliably detect premature convergence, unsupported inference, missing contribution opportunities, or manufactured collaboration.

**Independent Test**: Execute the generalized fixture set against Profile behavior and evaluate each applicable rubric dimension. A fixture passes only when all applicable dimensions pass, with specified governance violations treated as hard failures.

**Acceptance Scenarios**:

1. **Given** fixture scenarios spanning new Identity evidence, changed relationships, mature input, model-shaped Working Ideas, ambiguity, cross-domain evidence, unsupported connections, and hidden mechanics, **When** the behavioral evaluation runs, **Then** each scenario records its context, stimulus, observable expectations, failure conditions, rubric dimensions, and governance references.
2. **Given** a transcript response, **When** it is evaluated, **Then** semantic behavior is scored rather than stylistic similarity to a golden response.
3. **Given** a hard governance violation such as unsupported accepted fact, premature acceptance, missing required contribution opportunity, silent resolution of consequential ambiguity, or unnecessary internal-mechanics disclosure, **When** the fixture is evaluated, **Then** the fixture fails regardless of other passing dimensions.

### User Story 5 - Preserve existing Profile contracts (Priority: P1)

As a Highway maintainer, I want the convergence behavior and behavioral evaluations to preserve existing Profile ownership, persistence, readiness, acceptance, and artifact contracts.

**Why this priority**: Collaborative improvements must not change retained Profile structure or transfer ownership from the Experience Standard or Constitution.

**Independent Test**: Run existing Profile validation, readiness, persistence, migration, and adapter correspondence checks alongside the new behavioral fixtures.

**Acceptance Scenarios**:

1. **Given** a valid mature Profile contribution, **When** it is processed, **Then** the existing short path toward direct capture or Converged Proposal remains available.
2. **Given** a Profile mutation, **When** it is accepted, **Then** existing mutation ordering and persistence behavior remain unchanged.
3. **Given** the feature is installed, **When** Profile is used, **Then** no new retained schema fields or readiness dimensions are required for Working Ideas, development triggers, convergence, Contribution Opportunities, reasoning, tensions, implications, or alternatives.
4. **Given** Profile is orchestrated by Setup, **When** normal guided interaction occurs, **Then** user-visible output does not expose persistence, readiness, routing, owner-result, state-transition, orchestration, catalog, or file-mutation mechanics unless needed for the person to act.

### Edge Cases

- A newly introduced activity or capability may be relevant but not materially change the active domain; the workflow must not force development solely because it is new.
- A cohesive paragraph may be writable while consequential ambiguity or a useful grounded connection remains; domain completeness alone must not force convergence.
- Highway may identify a useful cross-domain implication while the target domain is unresolved; evidence must be reused later without being accepted prematurely.
- A model-originated interpretation may be accepted, modified, rejected, narrowed, redirected, or extended; each outcome must preserve authority boundaries.
- A clear contribution must not trigger a ceremonial clarification, while materially different user-owned interpretations must not be silently resolved.
- Further interaction may add only optional detail or repetition; the workflow must be able to converge without an endless exploratory loop.
- Fixture execution must remain development-time evaluation and must not become a runtime input or dependency of the shipped skill.
- Transcript evaluation must not pass by averaging away a hard governance violation.

## Requirements

### Functional Requirements

- **FR-001**: `highway-profile` MUST define an ordered semantic decision for deciding whether a complete active domain proceeds to its Converged Proposal or remains a Working Idea.
- **FR-002**: The decision MUST evaluate complete active evidence and relevant accepted Profile context after substantive evidence changes the active understanding.
- **FR-003**: The decision MUST prioritize consequential user-owned ambiguity or contradiction, then grounded substantive development, then an applicable Contribution Opportunity, then domain-specific convergence, and finally available evidence or a grounded Working Idea before an unresolved-domain question.
- **FR-004**: The decision MUST state that it is semantic rather than based on turn counts, mandatory questions, new nouns, or mandatory exploration categories.
- **FR-005**: Profile MUST describe useful development affordances without exposing them as workflow stages, mandatory categories, persisted fields, or generic Experience Standard rules.
- **FR-006**: Model-originated relationships and implications MUST remain provisional Working Idea material until accepted through the existing Profile domain acceptance path.
- **FR-007**: Profile MUST support a mature direct-contribution path when no consequential ambiguity or useful supported development remains.
- **FR-008**: Profile MUST preserve supported cross-domain implications for the appropriate unresolved domain and reuse accepted evidence without asking the person to repeat it.
- **FR-009**: Profile MUST extend its Verification section with checks for convergence independence from completeness, useful re-evaluation, mature short-path convergence, unchanged retained structure/readiness, and transient Working Ideas.
- **FR-010**: Development-time behavioral fixtures MUST cover at least the eight required scenarios: new Identity evidence, changed relationships among known activities, mature direct contribution, materially model-shaped Working Idea, clear versus consequentially ambiguous input, useful cross-domain connection, unsupported apparent connection, and hidden internal mechanics, and all eight MUST run through the repository's full development validation workflow.
- **FR-011**: Each fixture MUST record an identifier, scenario, starting accepted context, active transient context, user stimulus, observable passing behaviors, failing behaviors, applicable evaluation dimensions, and governance references.
- **FR-012**: The behavioral evaluation rubric MUST assess contextual re-evaluation, constructive contribution, convergence timing, contribution opportunity, clarification discipline, authority boundary, conversational presence, implementation-detail leakage, and non-manufactured collaboration.
- **FR-013**: Fixture evaluation MUST use semantic assertions, must not require exact wording except for existing exact contracts, and MUST fail on every applicable dimension rather than averaging away a governance violation.
- **FR-014**: The following MUST be hard failures when applicable: unsupported organizational fact promoted to accepted content, premature acceptance while substantive Working Idea development remains, missing required Contribution Opportunity after material model shaping, silent resolution of consequential ambiguity, and unnecessary internal owner/persistence/orchestration disclosure.
- **FR-015**: Fixtures and the rubric MUST remain development governance/testing artifacts, not runtime dependencies or Profile Inputs, and MUST not contain model-specific branches.
- **FR-016**: The implementation MUST preserve Constitution ownership, Experience Standard ownership of generic collaboration rules, existing Profile persistence/readiness/acceptance behavior, and the retained Profile schema.
- **FR-017**: The `highway-profile` semantic version MUST receive the minor capability increment required by the Skill Versioning Policy; the retained Profile schema version MUST remain unchanged.
- **FR-018**: Existing validation, adapter generation, persistence/readiness checks, and the new behavioral fixture suite MUST all pass before the feature is considered complete.

### Key Entities

- **Profile Domain Candidate**: A complete or incomplete transient understanding for Identity, Vision, Competitive Path, or Guiding Principles, including relevant accepted context but not necessarily accepted retained content.
- **Working Idea**: Transient model-originated or jointly developed material that may change the substantive meaning of a domain and remains unretained until accepted.
- **Converged Proposal**: A domain-complete candidate that has also satisfied the applicable conversational convergence behavior and is ready for the existing Profile-specific validation boundary.
- **Contribution Opportunity**: A meaningful chance for the person to change a materially Highway-shaped Working Idea before convergence, as governed by the Experience Standard.
- **Transcript Fixture**: A synthetic, organization-neutral multi-turn scenario with semantic expectations and hard-failure conditions.
- **Evaluation Rubric**: The reusable semantic dimensions used to assess transcript fixtures consistently across executing agents or language models.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of the eight required behavioral fixture categories are present, executable or reviewable as defined by the repository's development test harness, and include all required fixture-level acceptance fields.
- **SC-002**: 100% of fixture evaluations apply every marked rubric dimension and report any hard governance violation as a failure without averaging it away.
- **SC-003**: 100% of existing Profile validation, persistence, readiness, migration, adapter, and schema checks continue to pass after implementation.
- **SC-004**: In mature direct-contribution evaluations, 100% of passing traces reach the existing direct-capture or Converged Proposal path without an unnecessary exploratory question introduced solely for turn-count or collaboration appearance.
- **SC-005**: In consequential-ambiguity evaluations, 100% of passing traces ask one focused clarification before advancing and do not silently select a model-authored interpretation.
- **SC-006**: In materially model-shaped Working Idea evaluations, 100% of passing traces provide a meaningful contribution opportunity unless an equivalent opportunity is already evidenced, and the next response reflects any substantive user change.
- **SC-007**: In unsupported-connection evaluations, 100% of passing traces avoid promoting an unsupported relationship, implication, tension, or organizational purpose into accepted Profile content.
- **SC-008**: In cross-domain evaluations, 100% of passing traces reuse accepted evidence later without asking the person to repeat it and without forcing it into the wrong domain.
- **SC-009**: The retained Profile schema and readiness dimensions remain byte-for-byte compatible in structure with their pre-feature contracts, with no fields added for transient collaboration concepts.
- **SC-010**: The final repository validation reports zero failures, and the resulting `highway-profile` skill version reflects the minor capability increment required by the governing versioning policy.

## Assumptions

- The existing Experience Standard and Constitution are authoritative for generic collaboration, clarification, contribution opportunities, convergence, implementation-detail hiding, persistence failure handling, and versioning policy.
- The feature is a Profile-specific capability addition and therefore uses the next minor semantic version for `highway-profile`; no breaking contract or retained schema change is intended.
- The current retained Profile schema and four domain model remain the source of truth for persisted organization knowledge.
- Development-time fixtures may be expressed as repository test/evaluation artifacts and may use synthetic transcripts, but they will not be loaded by the shipped skill at runtime.
- The repository's existing validation conventions and generated adapter process remain the validation mechanism for shipped artifacts; the specification does not prescribe a new runtime architecture.
- All eight behavioral fixtures run through development validation. Human or model-assisted semantic review may still be used where exact deterministic assertions cannot capture transcript quality, but the fixture invocation and hard-failure rules remain part of the repeatable validation workflow.
- No model-specific behavior is required; the same semantic expectations apply across executing agents.
- User-visible wording remains Profile-specific only where an existing Profile contract requires it; generic interaction mechanics continue to be referenced through the Experience Standard.
- Constitution changes are out of scope unless implementation reveals an irreconcilable governance contradiction.
- No clarification markers are required because the requested scope and governance boundaries are explicit.
