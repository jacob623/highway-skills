# Feature Specification: Experience Profile Presentation Rhythm

**Feature Branch**: `123-experience-profile-presentation-rhythm`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: Establish a global no-workflow-narration rule in the Experience Standard and adopt a subject-oriented presentation rhythm in highway-profile while preserving Profile data, persistence, readiness, and validation behavior.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Keep Internal Workflow Mechanics Silent (Priority: P1)

As a person interacting with Highway, I want responses to discuss what my information means rather than what Highway is saving, evaluating, routing, or processing, so that the conversation feels focused on my organization and decisions.

**Why this priority**: Internal workflow narration is a global experience concern and affects every interactive workflow, including Profile.

**Independent Test**: Review the Experience Standard rule table, interaction model, conversational guidance, and examples; confirm internal persistence, state, routing, evaluation, and progression are not narrated unless the person needs that information to act.

**Acceptance Scenarios**:

1. **Given** an Interactive Workflow has accepted information and must persist or evaluate it, **When** it responds, **Then** the response discusses the person's meaning, situation, choices, implications, or outcome without announcing internal mechanics.
2. **Given** a person needs implementation or workflow information to act, **When** that information is necessary, **Then** the workflow may disclose the relevant information without treating the global rule as an absolute concealment requirement.
3. **Given** a response includes useful conversational depth, **When** it is reviewed, **Then** the commentary focuses on the person's context rather than describing workflow machinery.
4. **Given** a response illustrates acknowledgment after accepted organizational information, **When** it is compared with the workflow-narration example, **Then** it describes what Highway learned rather than persistence or progression.

### User Story 2 - Guide Profile Subjects Naturally (Priority: P1)

As a person building an organizational Profile, I want each synthesized domain to open with a clear subject and a grounded recommendation before validation, so that I understand what Highway is helping me shape without seeing internal domain mechanics.

**Why this priority**: The Profile presentation rhythm is the primary user-facing change and must make the sequence of Vision, Competitive Path, and Guiding Principles understandable.

**Independent Test**: Exercise or inspect Profile synthesis for Vision, Competitive Path, and Guiding Principles; confirm each uses its subject heading, natural introduction, grounded recommendation, domain validation question, and user-authored alternative.

**Acceptance Scenarios**:

1. **Given** accepted Identity and sufficient grounding support a Vision recommendation, **When** Profile advances after Identity acceptance, **Then** the next response acknowledges the accepted understanding when X2.8 applies, opens `### Where you're going`, introduces the future-direction subject naturally, and presents the Vision recommendation and validation question.
2. **Given** accepted Vision and sufficient grounding support a Competitive Path recommendation, **When** Profile advances after Vision acceptance, **Then** it acknowledges what the accepted Vision establishes, opens `### How you'll get there`, and presents the Competitive Path recommendation and validation question without narrating persistence or state transitions.
3. **Given** accepted Competitive Path and sufficient grounding support Guiding Principles, **When** Profile advances after Competitive Path acceptance, **Then** it acknowledges what the accepted path establishes, opens `### What will guide your decisions`, and presents the Guiding Principles recommendation and validation question.
4. **Given** accepted Guiding Principles completes the Profile domains, **When** Profile responds, **Then** it acknowledges the accepted principles when X2.8 applies, emits the existing concise completion synthesis, and returns control to Setup without another Profile heading or question.
5. **Given** an introduction or acknowledgment is generated, **When** it is reviewed, **Then** it does not expose internal readiness-domain names, enrichment categories, persistence, readiness, unresolved-domain, or workflow-progression mechanics.

### User Story 3 - Preserve Grounding, Acceptance, and Retention (Priority: P1)

As an organization owner, I want the richer Profile presentation to preserve accepted-evidence grounding and transient-versus-retained boundaries, so that conversational framing does not become organizational fact without my adoption.

**Why this priority**: The presentation change must not alter Profile data semantics or silently persist headings, introductions, acknowledgments, or advisory commentary.

**Independent Test**: Review Profile enrichment, operations, verification, and retained-record expectations; confirm the subject rhythm changes presentation only and preserves acceptance, persistence ordering, readiness, and fallback behavior.

**Acceptance Scenarios**:

1. **Given** accepted evidence supports a useful recommendation, **When** Profile presents a subject introduction and recommendation, **Then** the recommendation contains only accepted-evidence claims and the subject introduction remains transient.
2. **Given** a person accepts a recommendation, **When** Profile returns a dependent readiness or owner result, **Then** the accepted Profile mutation is persisted before that result and persistence is not narrated merely because acknowledgment follows acceptance.
3. **Given** an acknowledgment, explanation, reflection, advisory observation, implication, opportunity, tradeoff, concern, alternative, or internal category is not explicitly adopted, **When** Profile persists, **Then** it is not retained as organizational evidence.
4. **Given** evidence cannot support a useful recommendation, **When** a domain remains unresolved, **Then** Profile preserves the existing canonical-question fallback and does not manufacture a recommendation to preserve the preferred rhythm.
5. **Given** optional enrichment is added to a `discussed` or `bounded` domain, **When** Profile continues, **Then** readiness and canonical-question behavior remain unchanged.

### User Story 4 - Amend the Shared Standard Without Breaking Profile Scope (Priority: P2)

As a governance maintainer, I want the global narration rule and Profile rhythm to have clear ownership boundaries, so that generic experience behavior is centralized while Profile retains only domain-specific acquisition, grounding, validation, and persistence responsibilities.

**Why this priority**: The change spans two authoritative documents and must avoid competing rules or retained-artifact changes.

**Independent Test**: Review the Experience Standard and highway-profile together with their focused checks; confirm X2.36 is global, Profile cites and applies it without duplicating it, and protected Profile artifacts remain unchanged.

**Acceptance Scenarios**:

1. **Given** the Experience Standard is amended, **When** its version and rule inventory are reviewed, **Then** it is version 7.2.0 with X2.36 after X2.35, required amendment metadata, and no changes to X2.3, X2.5, X2.6, X2.8, X2.33, X2.34, or X2.35.
2. **Given** Profile is updated, **When** its scope is reviewed, **Then** its four readiness domains, schema version 3.0.0, website scope, brownfield exclusion, canonical questions, persistence ordering, completion synthesis, and Experience sentence remain intact.
3. **Given** generated or focused verification runs, **When** the implementation is validated, **Then** Profile-specific checks cover X2.36 adoption, subject headings, transient presentation, acceptance flow, and no-workflow-narration behavior without modifying protected shared artifacts.
4. **Given** the combined change is complete, **When** the repository suite runs, **Then** the applicable full suite exits successfully with no regression attributable to the new standard or Profile rhythm.

### Edge Cases

- X2.8 applies after acceptance, but no next Profile subject remains; the response acknowledges the accepted meaning and proceeds to existing completion synthesis without announcing that no subject remains.
- A recommendation is unavailable because accepted evidence is insufficient; the subject introduction may orient the person, but the canonical question remains the fallback.
- The person asks why Highway is saving, routing, or evaluating information; the workflow may explain what is needed to act while avoiding unnecessary internal narration.
- A subject introduction would repeat an internal readiness or enrichment category; the user-visible heading remains the prescribed plain-language subject heading.
- Website-derived organizational information is available but not accepted; it remains proposed and cannot silently ground retained Profile evidence.
- A person corrects or replaces a recommendation; the existing acceptance boundary and persistence-before-dependent-result behavior remain authoritative.
- Profile completion lacks an accepted Organization Name; the completion synthesis remains natural without inventing one.
- Existing Profile records use schema version 3.0.0; no migration or new retained field is introduced.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST add X2.36 after X2.35 with the rule that an Interactive Workflow must not narrate internal workflow progression, persistence, state transitions, or processing unless the person needs that information to act.
- **FR-002**: X2.36 MUST define the observable that user-visible commentary concerns the person's information, meaning, choices, implications, or outcome and does not announce saving, retained state, unresolved workflow parts, evaluation, routing, or advancement unless needed for action.
- **FR-003**: X2.36 MUST be classified as `[agent-checkable]` and MUST leave X2.3, X2.5, X2.6, X2.8, X2.33, X2.34, and X2.35 unchanged.
- **FR-004**: Experience Standard Conversational Presence guidance MUST state that conversational commentary focuses on the person's meaning, situation, choices, implications, or outcomes rather than internal Highway activity.
- **FR-005**: Experience Standard Conversational Presence guidance MUST prohibit conversational language used merely to describe persistence, workflow state, unresolved internal dimensions, evaluation, routing, or progression unless the person needs the information to act.
- **FR-006**: The Experience Standard interaction model MUST state that internal persistence, state evaluation, routing, and progression occur without narration unless the person needs the information to act, while preserving natural conclusion behavior.
- **FR-007**: The Experience Standard MUST include a Workflow narration example with the specified non-compliant persistence/progression narration and compliant organization-focused acknowledgment.
- **FR-008**: The Experience Standard MUST increment from version 7.1.0 to 7.2.0, classify the amendment as MINOR, update Last Amended and required amendment metadata, and preserve the existing rule inventory apart from X2.36.
- **FR-009**: Profile enrichment MUST replace its generic recommendation-flow paragraph with guidance to introduce the organizational subject, present one cohesive accepted-evidence recommendation, end with the domain validation question and user-authored alternative, and generate introduction and recommendation prose naturally.
- **FR-010**: Profile MUST define the synthesized Vision, Competitive Path, and Guiding Principles rhythm as introduction to subject, grounded recommendation, and validation.
- **FR-011**: After recommendation acceptance, Profile MUST acknowledge what the accepted information established when X2.8 applies, then introduce the next unresolved Profile subject when one remains.
- **FR-012**: Profile MUST define the repeating conceptual flow as `Introduce → Suggest → Validate`, followed after acceptance by `Acknowledge → Introduce next subject → Suggest → Validate` when another subject remains.
- **FR-013**: Profile MUST state that acknowledgment closes the accepted subject, introduction opens the next subject, and acknowledgment MUST NOT narrate persistence, readiness, domain state, or workflow progression.
- **FR-014**: Vision synthesis MUST use the user-visible heading `### Where you're going`, a natural future-direction introduction, a grounded cohesive recommendation, the existing Vision validation question, and the existing user-authored alternative.
- **FR-015**: Competitive Path synthesis MUST use the user-visible heading `### How you'll get there`, a natural practical-direction introduction, a grounded cohesive recommendation, the existing Competitive Path validation question, and the existing user-authored alternative.
- **FR-016**: Guiding Principles synthesis MUST use the user-visible heading `### What will guide your decisions`, a natural decision-principles introduction, a grounded cohesive recommendation, the existing Guiding Principles validation question, and the existing user-authored alternative.
- **FR-017**: Profile MUST preserve the first-time `#### Let's get to know your organization` heading, Repository Name acquisition, website acquisition, Identity validation wording, and Identity-to-Vision transition behavior.
- **FR-018**: After accepted Vision, Profile MUST preserve persistence-before-dependent-result ordering, avoid narrating persistence, acknowledge what Vision establishes, and introduce Competitive Path when grounded evidence supports it.
- **FR-019**: After accepted Competitive Path, Profile MUST preserve persistence-before-dependent-result ordering, avoid narrating persistence, acknowledge what the path establishes, and introduce Guiding Principles when grounded evidence supports it.
- **FR-020**: After accepted Guiding Principles, Profile MUST preserve persistence-before-dependent-result ordering, acknowledge what the principles establish when X2.8 applies, avoid another Profile subject, and proceed to existing completion synthesis.
- **FR-021**: Profile MUST state that acknowledgment closes the accepted subject by reflecting what the information establishes about the organization and MUST NOT describe Profile mechanics, persistence, retained state, readiness, grounding availability, unresolved domains, or future processing.
- **FR-022**: Profile MUST preserve optional Constructive Advisory behavior, allowing grounded observations around introduction or recommendation without requiring, counting, or manufacturing advisory commentary.
- **FR-023**: Profile MUST preserve the transient boundary for acknowledgment, subject introduction, explanation, reflection, advisory commentary, implications, opportunities, tradeoffs, concerns, alternatives, and internal enrichment categories unless explicitly adopted.
- **FR-024**: Profile MUST NOT persist the new H3 presentation headings unless the existing shared output template independently requires them, and `profile-record.md` MUST remain unchanged with schema version 3.0.0.
- **FR-025**: Profile MUST preserve canonical-question fallback when accumulated accepted evidence cannot support a useful recommendation and MUST NOT manufacture a recommendation to preserve the preferred rhythm.
- **FR-026**: Profile Verification MUST replace the generic acknowledgment bypass check with an X2.8-after-acceptance check for Identity, Vision, and Competitive Path before the next subject.
- **FR-027**: Profile Verification MUST cover the three subject headings, acknowledgment intent, transient introductions, and the absence of persistence, state-transition, and owner-result mechanics in acceptance responses.
- **FR-028**: Profile MUST preserve four readiness domains, `not_discussed`, `discussed`, and `bounded`, schema version 3.0.0, website scope, proposed-until-accepted web evidence, technology-platform exclusion, canonical fallback, save-before-dependent-result behavior, completion synthesis, ownership, and readiness.
- **FR-029**: The combined change MUST keep `highway-profile` at version 5.1.0 unless the Skill Versioning Policy requires a documented release classification.
- **FR-030**: The combined change MUST NOT modify `profile-record.md`, Highway Identity, the Highway Skills Constitution, or unrelated Profile data semantics.
- **FR-031**: Verification MUST demonstrate that no-workflow-narration behavior is globally owned by X2.36 and not duplicated as a generic Experience rule inside Profile.
- **FR-032**: The combined change MUST preserve accepted recommendation, correction/replacement, explanation-not-acceptance, readiness, persistence, error handling, and completion ownership behavior.

### Key Entities *(include if feature involves data)*

- **Interactive Workflow**: A user-visible Highway workflow that expects a response, decision, confirmation, approval, rejection, or other input.
- **Workflow narration rule**: The global X2.36 obligation governing when internal persistence, state, routing, evaluation, and progression may be visible.
- **Profile subject**: A user-facing plain-language heading and introduction for Vision, Competitive Path, or Guiding Principles.
- **Accepted Profile evidence**: User-provided or user-accepted organizational information that may be persisted and reused across Profile domains.
- **Transient Profile presentation**: Acknowledgment, subject introduction, explanation, reflection, advisory commentary, implications, tradeoffs, concerns, alternatives, and internal categories that are not retained unless explicitly adopted.
- **Profile domain**: One of Identity, Vision, Competitive Path, or Guiding Principles with existing readiness and validation semantics.
- **Completion synthesis**: The existing concise user-relevant summary emitted after final Profile acceptance before control returns to Setup.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The Experience Standard contains exactly one new X2.36 rule after X2.35, remains at version 7.2.0, and preserves all named protected rule texts byte-for-byte.
- **SC-002**: 100% of reviewed Workflow narration examples and Profile acceptance responses contain no internal persistence, state-transition, routing, evaluation, or progression narration unless needed for the person's action.
- **SC-003**: 100% of reviewed Vision, Competitive Path, and Guiding Principles synthesis paths use the prescribed subject heading before recommendation and validation while exposing no internal domain or enrichment-category names.
- **SC-004**: 100% of reviewed accepted Profile transitions apply X2.8 before introducing the next unresolved subject when one remains, without requiring an exact acknowledgment sentence.
- **SC-005**: 100% of reviewed retained Profile outputs contain only accepted organizational evidence; subject headings, introductions, acknowledgments, and unadopted advisory context appear in 0% of retained narratives.
- **SC-006**: 100% of reviewed fallback cases preserve canonical questions when evidence cannot support a useful recommendation, with no manufactured recommendation added solely to preserve presentation rhythm.
- **SC-007**: 100% of reviewed accepted mutations preserve save-before-dependent-result ordering, four-domain readiness, schema version 3.0.0, and existing error handling.
- **SC-008**: 100% of focused Experience Standard and Profile contracts pass, including amendment metadata, X2.36, subject headings, transient presentation, acceptance transitions, and adapter or distribution checks.
- **SC-009**: The complete applicable repository validation suite exits successfully with no regression attributable to the combined Experience Standard/Profile update.
- **SC-010**: A reviewer can distinguish global no-workflow-narration ownership in the Experience Standard from Profile-specific subject, grounding, validation, and persistence ownership without finding duplicate generic rules.

## Assumptions

- The current Experience Standard is version 7.1.0 and the requested X2.36 addition is a MINOR amendment to version 7.2.0 with the current date as Last Amended.
- The current `highway-profile` version is 5.1.0 and remains unchanged because this work continues the unreleased Profile presentation update.
- Highway Identity and the Experience Standard remain authoritative for generic voice, presence, advisory behavior, X2.8, implementation-detail suppression, machine-result suppression, and the new X2.36 narration boundary.
- Profile remains authoritative for the four organizational domains, accepted evidence, grounding, validation, acquisition, persistence ordering, readiness, completion synthesis, website scope, and technology-platform exclusion.
- Subject headings and introductions are presentation-only and are not retained in the shared Profile output template.
- Existing acceptance, correction/replacement, explanation-not-acceptance, canonical fallback, and error-handling behavior remains authoritative.
- No new Profile schema field, readiness state, storage migration, external integration, dependency, or public runtime interface is introduced.
- Protected artifacts include `profile-record.md`, `highway-identity.md`, the Highway Skills Constitution, and unrelated governance or skill files.
