# Feature Specification: Organization and Offering Boundary

**Feature Branch**: `261-org-offering-boundary`

**Created**: 2026-11-23

**Status**: Draft

**Input**: User description: "create a new spec to implement your recommended updates. Ensure the updates to the actual skills remain instruction based, with little to no prose."

Keep the organization and each offering as separate subjects while a Profile is built, and stop later work when that split is contradicted. A product description must not become the organization's identity, vision, or operating capabilities. When the organization name and an offering name share a word, organizational sentences use the full organization name and the short name refers only to the offering. That naming rule lives in the Experience Standard and is applied by Profile. Other skills do not restate it.

Text added to a skill or to the Experience Standard for this feature is an instruction: a rule or a step. Do not add an explanation of why.

## Clarifications

### Session 2026-11-23

- Q: Should Profile record a generalized offering instead of each product described in detail? → A: Generalized offering only. A detailed product is evidence for the offering, not the stored offering and not the organization. The generalization must be grounded so the same evidence produces the same offering with little variation.
- Q: What should the generalized offering name be taken from so the same description produces the same offering? → A: The person's words for the kind of thing. Drop the product name, features, and how it is built. Ask once if no category word remains. Do not coin a category the person did not use.
- Q: Where should the stored Profile keep each generalized offering? → A: Separate Identity findings in the existing Profile. Who the organization is stays a separate finding. No new section.
- Q: When the person accepts an offer to revise the Profile, should that revision start before any other record? → A: Accepting starts the Profile revision immediately. Declining leaves the skill stopped, with no new objective, capability, or finding.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Identity keeps the organization and its offerings apart (Priority: P1)

A person describes a company by talking mostly about one product, or about a few products of the same kind. Profile treats the company as the organization. It records a generalized offering named with the person's words for that kind of thing. The product's proper name, feature list, and how it is built are left out. Identity states who the organization is in one finding and keeps each offering as its own finding. No new Profile section is added. The product description is not stored as the organization or as the offering.

**Why this priority**: Profile is the record every later skill must trust. Once the organization and a product are fused there, later skills cannot undo it.

**Independent Test**: Walk a new Profile twice from the same product-focused description. Confirm both passes name the same generalized offering, and that the product itself is not the organization or the offering.

**Acceptance Scenarios**:

1. **Given** a new Profile and a description that is mostly about a product, **When** Identity is proposed, **Then** the organization and each generalized offering appear as separate subjects, and the product description is not presented as who the organization is or as the offering.
2. **Given** the same description a second time, **When** Identity is proposed again, **Then** the offering name matches the first pass, and it uses the person's words for the kind of thing.
3. **Given** a product description with no word for the kind of thing, **When** Identity would name an offering, **Then** Profile asks one question and does not coin a category.
4. **Given** material that supports one or more offerings, **When** Identity is accepted, **Then** each accepted offering stays an offering, and the organization's identity can be read without that offering being the only subject.
5. **Given** the person explicitly says the organization and an offering are the same subject after seeing them apart, **When** they accept that statement, **Then** Profile may keep that explicit identity, and it does not infer the collapse on its own.

---

### User Story 2 - Vision does not inherit a product as the organization (Priority: P1)

Profile does not turn product language into a vision of the offering. The future state names the organization. When the organization and an offering are mixed and accepted context cannot say which subject the future belongs to, Profile asks one question and does not propose a vision in that same message.

**Why this priority**: The fused vision is what the person accepts next, and every later domain opens from that accepted substance.

**Independent Test**: Supply product-only language after a split Identity and confirm the vision either names the organization or is withheld for one disambiguating question.

**Acceptance Scenarios**:

1. **Given** accepted Identity that separates the organization from its offerings, **When** Vision is proposed, **Then** the future state names the organization, not an offering alone.
2. **Given** language that mixes the organization and an offering so the future's subject is unclear, **When** Profile would otherwise infer a vision, **Then** it asks one question that distinguishes the organization from the offering, and that message contains no vision proposal.
3. **Given** the person answers that question, **When** the subject is clear, **Then** Profile resumes a vision proposal grounded in the organization.

---

### User Story 3 - A shared name does not collapse the subject (Priority: P1)

When the organization name contains the offering's name, as with "Highway Systems" and "Highway", sentences about the organization use the full organization name. The short name is used only for the offering. The Experience Standard carries this rule. Profile follows it when it chooses the subject of a sentence. Other skills keep following the Experience Standard and the accepted Organization Name. They do not gain their own copy of the rule.

**Why this priority**: A shared word is how the organization and the product become the same subject in ordinary sentences, including sentences later skills repeat from the Profile.

**Independent Test**: Run Identity and Vision with an organization name that contains the offering name. Confirm organizational sentences use the full organization name and the short name appears only for the offering. Confirm no other skill text restates the rule.

**Acceptance Scenarios**:

1. **Given** an accepted organization name that shares a distinguishing word with an offering name, **When** Profile speaks about the organization, **Then** it uses the full organization name.
2. **Given** that same pair of names, **When** Profile speaks about the offering, **Then** it may use the short name, and that short name is not used as the organization.
3. **Given** skills other than Profile, **When** this feature completes, **Then** they do not contain a restatement of the shared-name rule, and they still follow the Experience Standard for user-visible wording.
4. **Given** an organization name and an offering name that share no distinguishing word, **When** Profile speaks about the organization, **Then** it uses the accepted organization name and the shared-name rule adds no extra constraint.

---

### User Story 4 - The split is accepted before the Profile is written (Priority: P1)

Before the Profile is stored, Profile restates the organization and each offering and waits for the person to accept that split. It does not store a Profile that still fuses them.

**Why this priority**: Acceptance of the written Profile is the point after which later skills must treat the text as fact.

**Independent Test**: Reach the end of a guided Profile with organization and offering still distinguished. Confirm nothing is stored until the person accepts that restatement, and confirm a rejection leaves the Profile unwritten.

**Acceptance Scenarios**:

1. **Given** held Identity, Vision, Competitive Path, and Guiding Principles, **When** Profile is ready to store them, **Then** it first restates the organization and each offering as separate subjects and asks the person to accept that split.
2. **Given** that restatement, **When** the person accepts it, **Then** the stored Profile keeps who the organization is as one Identity finding and each accepted offering as its own Identity finding.
3. **Given** that restatement, **When** the person rejects it or edits the subjects back together without explicitly saying they are the same, **Then** Profile does not store the record and stays until the split is accepted or the person explicitly makes them the same subject.

---

### User Story 5 - A later contradiction stops before more records (Priority: P2)

If the person later says the organization and an offering are different, and the accepted Profile treats them as one subject, onboarding, objectives, and assessment stop. They do not write further records that depend on the fused subject. They offer to revise the Profile. Accepting that offer starts the Profile revision before any other record. Declining leaves the skill stopped.

**Why this priority**: Those three skills are where a fused Profile becomes objectives, capabilities, and findings. Stopping there is the recovery short of starting over. They do not need the naming rule copied into them.

**Independent Test**: Start from an accepted Profile whose identity is the product. In each of onboarding, objectives, and assessment, have the person separate the company from the product. Confirm the skill stops and offers to revise the Profile. Accept the offer and confirm the Profile revision starts before any other record. Decline the offer and confirm the skill stays stopped.

**Acceptance Scenarios**:

1. **Given** an accepted Profile that fuses the organization and an offering, **When** the person tells onboarding, objectives, or assessment that those are different subjects, **Then** that skill stops, does not add records that depend on the fused subject, and offers to revise the Profile before continuing.
2. **Given** the person accepts that offer, **When** the skill responds, **Then** the Profile revision starts before any other objective, capability, or finding.
3. **Given** the person declines that offer, **When** the skill responds, **Then** it stays stopped and adds no objective, capability, or finding.
4. **Given** the person does not separate the subjects, **When** those skills run, **Then** they continue on the accepted Profile as they do today.

---

### User Story 6 - Onboarding does not turn the product into capabilities (Priority: P2)

Onboarding proposes capabilities the organization operates. It does not promote a product behavior, feature, or packaging choice into a capability unless the person says the organization operates it.

**Why this priority**: A fused Profile makes the product look like the company's operations. Onboarding then proposes those behaviors as capabilities, and rejecting them one by one does not repair the Profile.

**Independent Test**: Onboard with a Profile whose offerings describe product behavior the person has not claimed to operate. Confirm those behaviors are absent from the proposed capabilities until the person says the organization operates them.

**Acceptance Scenarios**:

1. **Given** a Profile that lists product behavior as an offering, **When** onboarding proposes capabilities, **Then** that behavior is not proposed as a capability unless the person has said the organization operates it.
2. **Given** the person says the organization does operate that behavior, **When** onboarding proposes capabilities, **Then** it may include that capability.
3. **Given** a capability the person says does not exist, **When** onboarding continues, **Then** that capability is removed and is not mapped, as it is today.

---

### Edge Cases

- The person has not accepted an organization name yet. Profile still must not invent one. Until an organization name is accepted, it does not treat the repository name as the organization name.
- Supplied material is only about the product. Identity still separates what can be supported about the organization from offerings, and asks who the organization is when the material does not support that.
- The person describes several products of one kind. Profile records one generalized offering for that kind. Products of different kinds stay separate offerings.
- The person declines to name an offering. Profile does not invent one. The same evidence produces the same offering name on a later pass.
- The description names a product and how it is built, and has no word for the kind of thing. Profile asks once for that kind. It does not coin a category.
- The person describes how the organization will get to the future, or names controls, safeguards, or sequencing. That material stays out of Vision, as it does today, and the organization-versus-offering question is separate from that deferral.
- An accepted Profile already fuses the subjects. This feature does not rewrite it unprompted. The stop-and-revise behavior applies when the person later separates them during onboarding, objectives, or assessment. Accepting the offer starts the Profile revision. Declining leaves that skill stopped. A person who opens Profile review can still correct the record directly.
- The person accepts the split and later edits the stored Profile back into one subject through Profile review. Later skills then treat the edited Profile as accepted until the person separates the subjects again.
- Names share a generic word such as "company" or "system" only. That is not a shared-name case. The distinguishing word is the offering's own name.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile Identity MUST state who the organization is and MUST list each generalized offering the organization provides as a separate subject.
- **FR-001a**: A detailed product MUST be evidence for an offering. Profile MUST NOT store that product as the offering or as the organization.
- **FR-001b**: The offering name MUST be the person's words for the kind of thing provided. Profile MUST drop the product's proper name, its feature list, and how it is built. The same evidence MUST produce the same offering name. When no category word remains, Profile MUST ask one question and MUST NOT coin a category.
- **FR-002**: Profile MUST NOT present or store a product or offering description as the organization's identity unless the person has explicitly accepted that the organization and that offering are the same subject.
- **FR-003**: A proposed Vision future state MUST name the organization. Profile MUST NOT infer that future from product or offering language alone.
- **FR-004**: When accepted context mixes the organization and an offering so the subject of Identity or Vision is ambiguous, Profile MUST suspend its proposal for that step and ask one question that distinguishes the organization from the offering. That message MUST NOT also contain the proposal.
- **FR-005**: After the person answers that question, Profile MUST resume the proposal using the organization as the subject, unless the person explicitly makes the organization and the offering the same subject.
- **FR-006**: The Experience Standard MUST require that, when the organization name and an offering name share the offering's distinguishing word, user-visible sentences about the organization use the full organization name, and the short name refers only to the offering.
- **FR-007**: Profile MUST apply that shared-name rule in Identity, Vision, Competitive Path, and Guiding Principles. Skills other than Profile MUST NOT be rewritten to restate the rule.
- **FR-008**: Before storing a new Profile, Profile MUST restate the organization and each offering and MUST obtain acceptance of that split.
- **FR-009**: Profile MUST NOT store a new Profile when the person rejects that split or merges the subjects without explicitly saying they are the same subject.
- **FR-010**: The stored Profile MUST keep who the organization is as one Identity finding and each accepted offering as its own Identity finding whenever the person has not explicitly made them the same subject. Profile MUST NOT add a new section for offerings.
- **FR-011**: Onboarding, objectives, and assessment MUST, when the person separates the organization from an offering that the accepted Profile fuses, stop without adding records that depend on the fused subject, and offer to revise the Profile. Accepting that offer MUST start the Profile revision before any other record. Declining it MUST leave the skill stopped, with no new objective, capability, or finding.
- **FR-012**: Onboarding MUST NOT propose a product behavior, feature, or packaging choice as a capability unless the person says the organization operates that capability.
- **FR-013**: This feature MUST NOT rewrite an already stored Profile on its own.
- **FR-014**: Profile MUST NOT invent an organization name, an offering name, or an offering the person did not supply or accept.
- **FR-015**: Text this feature adds to Profile, the Experience Standard, onboarding, objectives, or assessment MUST be an instruction: a rule or a step the skill carries out. It MUST NOT add an explanation of why the rule exists.

### Key Entities

- **Organization**: The company or other body the Profile is about. It has one accepted name once the person accepts it. It is the subject of Identity and Vision.
- **Offering**: A generalized category of what the organization provides, named with the person's words for that kind of thing. A detailed product is evidence for an offering, not the offering itself. An offering is not the organization unless the person explicitly says so. A Profile may record more than one when the evidence supports more than one kind.
- **Shared-name case**: The organization name contains the offering's distinguishing name. Organizational sentences then use the full organization name. The short name is only the offering.
- **Profile**: The accepted organizational record. Later skills ground on it. Who the organization is and each offering are separate Identity findings unless the person explicitly collapsed them. Offerings do not get a new section.
- **Capability**: An operation the organization runs and can onboard. Product behavior is not a capability until the person says the organization operates it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In a guided Profile that starts from product-focused description, the person can point to the organization and to each generalized offering as separate subjects before the Profile is stored, in one pass. Repeating that description produces the same offering name, taken from the person's words for the kind of thing. A description with no category word produces one question and no coined offering.
- **SC-002**: When the future's subject is ambiguous, the person receives exactly one distinguishing question and no vision proposal in that message.
- **SC-003**: In a shared-name walkthrough, every organizational sentence in the Profile conversation uses the full organization name, and every use of the short name refers to the offering.
- **SC-004**: A new Profile is stored only after the person accepts the organization-and-offerings restatement, and a rejection leaves no stored Profile from that pass.
- **SC-005**: In onboarding, objectives, and assessment, a person who separates a fused organization and offering is offered a Profile revision in that same turn, before any new dependent record. Accepting starts that revision. Declining leaves the skill stopped with no new objective, capability, or finding.
- **SC-006**: Onboarding proposes no capability that is only a product behavior unless the person has said the organization operates it.
- **SC-007**: Skills other than Profile contain no new copy of the shared-name rule.
- **SC-008**: Text added to Profile, the Experience Standard, onboarding, objectives, and assessment is instructions. None of it is an explanation of why.

## Assumptions

- The six recommended updates are in scope: Identity split, Vision subject and the one disambiguating question, the shared-name rule, acceptance of the split before the Profile is stored, stop-and-revise in later skills, and onboarding capability limits.
- An offering recorded by Profile is a generalized category named with the person's words for that kind of thing. Profile drops the product's proper name, feature list, and how it is built. A detailed product is evidence for that category. The same evidence yields the same offering name. When no category word remains, Profile asks once and does not coin one. Products of one kind become one offering. Products of different kinds stay separate offerings. Each offering is its own Identity finding. Who the organization is is a separate Identity finding. Profile adds no new section for offerings.
- The shared-name rule is user-visible wording, so it belongs in the Experience Standard. Which facts belong to the organization or to an offering remains Profile's domain. Other skills stay aligned by following the Experience Standard and the accepted organization name.
- Onboarding, objectives, and assessment change only for the stop-and-revise behavior. Onboarding also changes so product behavior is not promoted into capabilities. No other skill procedure changes for this feature.
- "Explicitly the same subject" means the person says so after seeing the organization and the offering apart. Inference from product-heavy language does not qualify.
- An already stored Profile is left as accepted history until the person edits it or a later skill hits the contradiction rule.
- Existing rules still hold: do not invent an organization name, do not treat the repository name as the organization name, keep method and sequencing out of Vision, and remove a capability the person says does not exist.
- A generic word shared by many names is not the offering's distinguishing word.
- Direct correction through Profile review remains available and is not replaced by the stop-and-revise offer.
- Accepting an offer to revise the Profile starts that revision before any other record. Declining the offer leaves onboarding, objectives, or assessment stopped, with no new objective, capability, or finding.
- Added skill text matches the instruction style already used in that skill. A new Experience Standard rule uses that standard's existing rule-and-observable row. A new Profile, onboarding, objectives, or assessment line is a step or a domain rule, not a paragraph.
