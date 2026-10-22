# Feature Specification: Profile Direct Write

**Feature Branch**: `188-profile-direct-write`

**Created**: 2026-10-22

**Status**: Draft

**Input**: User description: "Remove the three fallback questions for Vision, Competitive Path, and Guiding Principles so those domains always offer a proposal. Remove the capture template and write the accepted bullet list to the output file. Create that file in the user's space at library/knowledge/profile.md from the repository root."

## Clarifications

### Session 2026-10-22

- Q: What should happen when a profile already exists only under the skill framework tree and `library/knowledge/profile.md` does not? → A: Backward compatibility is unnecessary. Ignore the old file.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Always receive a proposal (Priority: P1)

A person setting up their Profile is shown a proposal for Vision, Competitive Path, and Guiding Principles. They are not asked a fallback question that blocks the proposal when evidence for one slot feels thin.

**Why this priority**: The fallback question stops the person in front of an empty prompt even when a useful proposal can be inferred. Asking for a suggestion afterward produced a good proposal, so the question is an unnecessary stop.

**Independent Test**: Run Profile with accepted Identity and no separate statement of vision, path, or principles. Each of those three domains opens with a proposal and the correction question. None opens with a question that asks the person to supply the domain from scratch.

**Acceptance Scenarios**:

1. **Given** accepted Identity and no stated vision, **When** Vision begins, **Then** the person sees a proposed Vision inferred from accepted context and is asked what they would add, correct, or remove.
2. **Given** an accepted Vision and no stated path, **When** Competitive Path begins, **Then** the person sees a proposed path, including a tradeoff, inferred from accepted context.
3. **Given** an accepted Competitive Path and no stated principles, **When** Guiding Principles begins, **Then** the person sees 3 to 5 proposed principles inferred from accepted context.
4. **Given** any of those three proposals, **When** the person says they do not know, **Then** the proposal stays available for correction and is not replaced by a fallback question.

---

### User Story 2 - Accept once, then store the bullets (Priority: P2)

After the person accepts a domain proposal, Profile does not show that domain again as a paragraph and ask them to accept it a second time. The accepted bullets are what gets stored.

**Why this priority**: The second acceptance repeats work the person already finished and rewrites their wording into prose that can add a claim.

**Independent Test**: Accept a Vision proposal without edits. Profile moves on without a "here's what I've captured" paragraph. The stored Vision section contains the same bullets the person accepted.

**Acceptance Scenarios**:

1. **Given** a Vision, Competitive Path, or Guiding Principles proposal, **When** the person says it is accurate, **Then** that domain is held as those bullets and Profile does not ask them to accept a rewritten paragraph.
2. **Given** an edit to a proposal, **When** the person then accepts it, **Then** the held domain is the edited bullets, including a rejected term left out.
3. **Given** an answer to the Identity question, **When** that answer is accepted as the domain, **Then** it is held as the Identity bullets without a second acceptance of a paragraph.

---

### User Story 3 - Store the profile in the person's repository (Priority: P3)

The Profile file is created in the person's repository, at `library/knowledge/profile.md` from the repository root. Later reads use that same file.

**Why this priority**: The profile is the person's organizational context. It belongs in their repository, not in the skill framework's own tree.

**Independent Test**: Finish Profile. The file exists at `library/knowledge/profile.md` from the repository root. A later Profile review reads that file. No second profile file is written under the skill framework tree.

**Acceptance Scenarios**:

1. **Given** Guiding Principles has been accepted or declined, **When** Profile writes, **Then** it writes once to `library/knowledge/profile.md` from the repository root.
2. **Given** that file already exists, **When** Profile runs again, **Then** it shows that file for review.
3. **Given** a stored domain, **When** the file is read, **Then** that domain's section contains the accepted bullets under the domain heading.

---

### Edge Cases

- One slot in a proposal, including the Competitive Path tradeoff, has no direct statement from the person. The proposal still includes an inference the person can correct.
- The person declines a domain. That domain is stored as bounded, and its narrative section is omitted.
- The person rejects a term during the proposal. The held bullets omit that term.
- Identity still asks what the organization does when no supported starting point exists. The answer is formed into bullets and held without a capture paragraph.
- The repository root has no `library/knowledge/` folder yet. The write creates that folder and the profile file.
- A profile that exists only under the skill framework tree is ignored. Profile does not read it, copy it, or review it.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Vision, Competitive Path, and Guiding Principles MUST each open with a proposal inferred from accepted context.
- **FR-002**: Those three domains MUST NOT ask a fallback question that replaces the proposal when a slot lacks a direct statement.
- **FR-003**: Each of those proposals MUST still ask what the person would add, correct, or remove, and MUST tell them they can say the proposal is accurate or that they do not know.
- **FR-004**: Competitive Path MUST include an inferred tradeoff in the proposal. Guiding Principles MUST include 3 to 5 inferred principles.
- **FR-005**: Profile MUST NOT show a capture paragraph, and MUST NOT ask the person to accept a domain a second time after they accepted its proposal.
- **FR-006**: The accepted bullets MUST be the stored narrative for that domain. A rejected term MUST be omitted.
- **FR-007**: An answer to the Identity question MUST be held as Identity bullets without a capture paragraph.
- **FR-008**: Profile MUST write the file once, after Guiding Principles is accepted or declined, at `library/knowledge/profile.md` from the repository root.
- **FR-009**: A later Profile run MUST read and review that same file.
- **FR-010**: Profile MUST NOT write a second profile file under the skill framework tree.
- **FR-011**: A profile that exists only under the skill framework tree MUST be ignored. Profile MUST NOT read, copy, or review it.
- **FR-012**: Identity MAY still ask what the organization does when no supported starting point exists.
- **FR-013**: A declined domain MUST be stored as bounded, and its narrative section MUST be omitted.

### Key Entities *(include if feature involves data)*

- **Domain proposal**: The bullets shown for Vision, Competitive Path, or Guiding Principles. Acceptance of these bullets is the only acceptance for that domain.
- **Stored profile**: The person's profile at `library/knowledge/profile.md` from the repository root. Each accepted domain is stored as its bullets under that domain's heading.
- **Identity answer**: The person's reply when no Identity starting point exists. It becomes the Identity bullets that are stored.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In a setup with no stated vision, path, or principles, all 3 of those domains show a proposal and 0 of them show a fallback question.
- **SC-002**: Accepting a domain takes one confirmation. The person is not shown a rewritten paragraph of that domain.
- **SC-003**: The stored domain text matches the accepted bullets, with no added claim and no rejected term.
- **SC-004**: After a completed Profile, exactly one profile file exists for that run, at `library/knowledge/profile.md` from the repository root.
- **SC-005**: A second Profile run reviews that file and does not create another profile file.

## Assumptions

- Identity keeps its question for the case where no supported starting point exists. Vision, Competitive Path, and Guiding Principles do not.
- The correction question remains "What would you add, correct, or remove?"
- The profile is still written once, after the last domain, rather than after every domain.
- The domain headings in the profile stay Who We Are, Where We're Going, How We Plan to Get There, and What Guides Our Decisions. The content under them becomes the accepted bullets.
- "The user's space" means the repository root the person owns, and the path from that root is `library/knowledge/profile.md`.
- Setup and any later skill that reads the profile use this same path. An older profile under the skill framework tree is not a source.
- Other skills are unchanged except where they locate the profile file.
