# Feature Specification: Remove Repository Name

**Feature Branch**: `262-remove-repository-name`

**Created**: 2026-11-25

**Status**: Draft

**Input**: User description: "create a new spec to remove the repository name from highway-profile and the profile record. Move the organization name question in highway-profile to the first question, in place of the repository name question. Every skill that used repository name should now use organization name."

Remove Repository Name from Profile acquisition and from the stored Profile record. The first guided Profile question asks for the organization's name. Every skill that previously used Repository Name as a name or as a fallback uses the accepted Organization Name instead.

## Clarifications

### Session 2026-11-25

- Q: When the person declines or says they do not know the organization's name on the first Profile question, what should Profile do? → A: Stay on the first question until the person supplies a name. Decline and unknown re-ask.
- Q: When Profile review opens an existing Profile that has no accepted Organization Name, should it collect one before returning Finished? → A: No. Backward compatibility is not required. Review gains no migration path for older Profiles.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Profile opens with the organization name (Priority: P1)

A person starts a new Profile. The first question asks for the organization's name. That reply is stored as Organization Name. The offer that follows uses that name. Profile does not ask what to call the Highway repository.

**Why this priority**: The opening question is what every later naming sentence depends on. Keeping a separate repository label asks for a second name that Profile no longer needs.

**Independent Test**: Start a guided Profile with no stored Profile. Confirm the first question asks for the organization's name, the reply is treated as Organization Name, and no repository-name question appears.

**Acceptance Scenarios**:

1. **Given** no stored Profile, **When** guided Profile begins, **Then** the first question asks for the organization's name and no repository-name question is emitted.
2. **Given** the person answers that question, **When** Profile continues, **Then** that reply is the accepted Organization Name and the next offer uses that name.
3. **Given** Organization Name is already accepted in the same guided pass, **When** Profile reaches Identity, **Then** it does not ask for the organization's name again.
4. **Given** the person declines or says they do not know on the first question, **When** Profile responds, **Then** it stays on that question, re-asks for the organization's name, and does not advance.

---

### User Story 2 - The Profile record keeps no Repository Name (Priority: P1)

A written Profile record has no Repository Name field. Organization Name is the name Context child guided Profile stores from the first question. Optional Context children that are not Repository Name stay as they are today.

**Why this priority**: The stored record is what later skills and reviews read. Leaving Repository Name in the skeleton keeps the removed concept alive.

**Independent Test**: Complete a new guided Profile and confirm the written record has no Repository Name heading or value, and that Organization Name holds the accepted first-question reply.

**Acceptance Scenarios**:

1. **Given** a successful guided write, **When** the stored Profile is inspected, **Then** it contains no Repository Name heading or value.
2. **Given** a successful guided write, **When** the stored Profile is inspected, **Then** Organization Name holds the accepted first-question reply.
3. **Given** the person supplied or accepted an Organization URL or other permitted Context child that is not Repository Name, **When** the Profile is written, **Then** those children still appear under Context when accepted.

---

### User Story 3 - Later skills name the organization only (Priority: P1)

Onboarding, objectives, controls, NFRs, and any other skill that previously used Repository Name when no Organization Name was accepted now use the accepted Organization Name. They do not fall back to Repository Name, and they do not invent an organization name.

**Why this priority**: Spec 261 already made Organization Name the subject of organizational sentences. A leftover Repository Name fallback reintroduces a second label.

**Independent Test**: Inspect every skill that currently mentions Repository Name. Confirm each naming fallback or template uses Organization Name, and that none still direct the skill to use Repository Name.

**Acceptance Scenarios**:

1. **Given** an accepted Organization Name in the Profile, **When** onboarding, objectives, controls, or NFRs emit a named sentence, **Then** that sentence uses the Organization Name.
2. **Given** a Profile with no accepted Organization Name, **When** those skills would fill a name, **Then** they invent no organization name and they do not use Repository Name.

---

### User Story 4 - Profile review stays ordinary (Priority: P2)

Profile review keeps its current behavior. It does not add a path that asks for Organization Name only because an older Profile lacked one. This project does not require backward compatibility for Repository Name.

**Why this priority**: Without a compatibility obligation, review must not grow a migration step that the product no longer needs.

**Independent Test**: Open Profile review on an existing readable Profile and confirm review still shows the body and validation question without a new organization-name migration prompt.

**Acceptance Scenarios**:

1. **Given** an existing readable Profile, **When** Profile review runs, **Then** it shows the body and the ordinary validation question without a dedicated migration prompt for Organization Name.
2. **Given** the person accepts that review unchanged, **When** Profile responds, **Then** it returns Finished under the same review rules it uses today.

---

### Edge Cases

- The person declines or says they do not know on the first organization-name question. Profile stays on that question, re-asks, invents no Organization Name, and does not substitute a repository label.
- The person answers the first question with a name that matches a product or offering. Spec 261 rules still apply: the reply is Organization Name; offerings stay separate; the shared-name rule still uses the full organization name when required.
- Setup welcome and owner order stay unchanged. Removing Repository Name does not change when Profile, Objectives, Controls, or NFRs run.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Guided Profile MUST begin with the organization-name question as its first question when no stored Profile exists.
- **FR-002**: Profile MUST store the reply to that first question as Organization Name.
- **FR-002a**: On the first organization-name question, decline and unknown MUST keep Profile on that question and MUST re-ask for the organization's name. Profile MUST NOT advance until the person supplies a name.
- **FR-003**: Profile MUST NOT ask what to call the Highway repository.
- **FR-004**: Profile MUST NOT ask for, store, or use Repository Name.
- **FR-004a**: A successful guided write MUST include the accepted Organization Name.
- **FR-005**: The Profile record skeleton MUST omit Repository Name.
- **FR-006**: After Organization Name is accepted in the guided flow, the offer and later Profile templates MUST use that Organization Name.
- **FR-007**: Profile MUST NOT repeat the organization-name question in the same guided pass once Organization Name is accepted.
- **FR-008**: Every skill that previously used Repository Name as a name or as a fallback MUST use the accepted Organization Name instead.
- **FR-009**: Skills MUST NOT invent an organization name when none is accepted.
- **FR-010**: Skills MUST NOT use Repository Name.
- **FR-011**: Whenever Profile writes or rewrites the Profile, it MUST omit Repository Name.
- **FR-012**: Profile review MUST keep its ordinary show-and-validate behavior and MUST NOT add a migration prompt that collects Organization Name only because an older Profile lacked one.
- **FR-013**: Organization URL and other permitted non-name Context children MUST keep their existing optional behavior.
- **FR-014**: Spec 261 organization-versus-offering rules, the shared-name rule, and the ban on inventing an organization name MUST remain in force.
- **FR-015**: Text this feature adds or revises in skills and the Profile record MUST remain an instruction: a rule or a step. It MUST NOT add an explanation of why.
- **FR-016**: This feature MUST NOT add backward-compatible behavior for Repository Name or for older Profiles that relied on it.

### Key Entities

- **Organization Name**: The accepted name of the organization the Profile is about. It is collected by the first guided Profile question and is the only name skills use in organizational sentences.
- **Repository Name**: Removed from Profile acquisition, from the Profile record skeleton, and from skill naming instructions. No compatibility path keeps it.
- **Profile Context**: Optional stored context after the domain narratives. It may still hold Organization Name, Organization URL, and Organizational Context when accepted. It does not hold Repository Name.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In a new guided Profile, the first question asks for the organization's name, and the person never sees a repository-name question in that pass. Decline or "I don't know" on that question leaves Profile on the same question with the organization-name question re-asked.
- **SC-001a**: A successful guided write always includes an accepted Organization Name.
- **SC-002**: A written Profile contains Organization Name and contains no Repository Name heading or value.
- **SC-003**: Onboarding, objectives, controls, NFRs, and Profile itself contain no instruction to use Repository Name as a name or fallback.
- **SC-004**: With an accepted Organization Name, named sentences in those skills use that Organization Name in one walkthrough without substituting any other label.
- **SC-005**: With no accepted Organization Name, those skills invent no organization name.
- **SC-006**: Skill and record text changed for this feature is instructions only.
- **SC-007**: Profile review has no new migration prompt that exists only to repair a missing Organization Name on an older Profile.

## Assumptions

- The first-question wording is the existing organization-name question already used by Profile: ask for the organization's name. The former repository-name question and its "often a good choice" hint are removed rather than rewritten into a second prompt.
- Decline and unknown on the first organization-name question re-ask that question. Profile does not advance, invent a name, or end Setup from that reply alone.
- The guided order becomes: organization name, then offer, then Identity, Vision, Competitive Path, Guiding Principles, split, then write. The separate post-offer organization-name step is removed because the name is already accepted.
- "Every skill that used repository name" means every highway skill instruction that currently tells the agent to use Repository Name, including Profile, onboarding, objectives, controls, and NFRs. Generated adapter and plugin copies are regenerated from those sources as part of finishing the change, not as a separate product behavior.
- Backward compatibility is not required. This feature does not migrate or specially support older Profiles that stored Repository Name or lacked Organization Name.
- Readiness, Setup delegation order, domain narratives, and optional non-name Context children are unchanged.
- The Experience Standard keeps its ban on inventing an unaccepted organization name. No new Experience Standard rule is required solely to delete Repository Name.
- Instruction style matches the current skills: steps and domain rules, not explanatory prose.
