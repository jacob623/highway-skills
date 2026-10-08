# Feature Specification: Collaborative Convergence

**Feature Branch**: `150-collaborative-convergence`

**Created**: 2026-10-07

**Status**: Draft

**Input**: User description: "Amend the Highway Experience Standard and the Profile skill so that
Highway explores possibilities with a person in a grounded way before converging, rather than
presenting an authored candidate for yes/no approval."

## Context

Nine captured `/highway-setup` conversations (three agents, three runs each) were read directly.
The findings in `setup-assessment.md` and the target conversation in `setup-model.md` are the
evidence behind this specification. Three observations drive it:

- A closed acceptance question at the bottom of a confident paragraph produces assent, not
  verification. In one captured run the person answered "yes" to an organizational identity that
  was entirely wrong.
- Terms the person never used ("cold chain", "product integrity", "freight pooling") were returned
  to them under a possessive heading as their own self-description.
- The collaborative behavior this feature restores already exists in the Standard as X2.37, but
  every clause attached to it is an exit, so it fired in none of the nine conversations.

## Clarifications

### Session 2026-10-07

- Q: Should the new "Development Turn" be a brand-new concept in the Standard, or should it replace and strengthen the Contribution Opportunity that X2.37 already defines? → A: No new concept. Strengthen X2.37's Contribution Opportunity in place by narrowing its exemption and prescribing its shape. "Development Turn" does not enter the Standard.
- Q: What fact should decide whether Highway owes the person a Contribution Opportunity before it converges on a Profile domain? → A: Trigger on the conversation — owed whenever the person has not yet made a Substantive Contribution to that domain, with approval and selection explicitly excluded. No self-assessed "materially shaped" trigger.
- Q: Which words in Highway's output have to be marked as Highway's rather than the person's? → A: Only introduced domain/industry vocabulary and substantive claims the person did not make. Ordinary paraphrase of their meaning is exempt.
- Q: Should Profile mandate an exact sentence for the open acceptance request, or only require that the request be open-ended? → A: Mandate a literal default sentence per domain, and permit substituting a more specific open question when Highway has one.
- Q: Do the new Experience Standard rules bind every Highway skill immediately, or only Profile until the other skills are brought into conformance? → A: Repository-wide immediately, with no skill-specific exemption clause, and a follow-up specification registered to bring the remaining skills into conformance.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Shape the substance before it is captured (Priority: P1)

A person describing their organization encounters Highway's interpretation while it is still
changeable, as discussable material rather than as a finished paragraph awaiting approval. They
can add to it, correct it, or reject its premise, and what is finally captured reflects that
exchange.

**Why this priority**: This is the defect. Everything else in this feature is a refinement of it.
Without this, the person's only move is to approve or correct prose they did not write.

**Independent Test**: Run a setup conversation in which Highway materially interprets the person's
input for a Profile domain. Verify that interpretation appears in a Contribution Opportunity
carrying no capture heading and no acceptance request, and that the person's response to it changes
what is subsequently captured.

**Acceptance Scenarios**:

1. **Given** Highway has materially interpreted the person's input for a Profile domain, **When**
   that interpretation is ready to show, **Then** it appears without a capture heading and without
   an acceptance request, and the person is invited to change it.
2. **Given** the person has responded to that interpretation, **When** Highway converges, **Then**
   the captured text reflects the response rather than restating the pre-response interpretation.
3. **Given** the person has contributed nothing to a domain beyond approving or selecting, **When**
   Highway would converge on that domain, **Then** convergence does not occur and a Contribution
   Opportunity is given.
4. **Given** a person supplies a domain-ready contribution that Highway does not materially
   reshape, **When** Highway proceeds, **Then** no exploratory turn is interposed.

---

### User Story 2 - Never face a blank strategic question (Priority: P2)

When Highway reaches Vision, Competitive Path, or Guiding Principles, the person is given grounded
possibilities to react to rather than an open question they must answer from nothing.

**Why this priority**: The captured conversations show that a bare "What future would you like to
create?" either stalls the person or prompts a one-line answer that Highway then inflates. Offering
grounded starting material is what turns the exchange into a conversation. It depends on P1 being
in place, because the possibilities must be offered without becoming candidates.

**Independent Test**: Run a setup conversation to Vision, Competitive Path, and Guiding Principles.
Verify each opens with possibilities traceable to already-accepted material, framed as material to
react to, and that the person is not required to choose from them.

**Acceptance Scenarios**:

1. **Given** Highway opens Vision, Competitive Path, or Guiding Principles, **When** the first turn
   of that domain appears, **Then** it contains grounded possibilities before any question.
2. **Given** possibilities are shown, **When** the person reads them, **Then** it is explicit that
   they are material to react to rather than a set to choose from.
3. **Given** the person's own direction differs from every possibility shown, **When** they state
   it, **Then** their direction is taken without Highway re-offering its own.
4. **Given** Highway has grounded reasoning that would materially help, **When** the person has not
   asked for advice, **Then** Highway offers it anyway.

---

### User Story 3 - Acceptance that requires a real answer (Priority: P3)

When Highway asks the person to accept materially interpreted content, the question has no
cooperative default, so agreement has to be deliberate.

**Why this priority**: Independently valuable — it improves every capture even with no other change
— but it is a smaller effect than P1 and P2, because an open question on authored prose is still a
question about prose the person did not write.

**Independent Test**: Reach any materially interpreted capture and verify the acceptance request
cannot be satisfied by agreeing, whether the default sentence or a substitution is used, and that a
partial response is interrogated rather than guessed at.

**Acceptance Scenarios**:

1. **Given** a materially interpreted Converged Proposal, **When** the acceptance request appears,
   **Then** it asks what is wrong rather than whether it is right.
2. **Given** Highway has a sharper open question for the content at hand, **When** it replaces the
   default sentence, **Then** the replacement still cannot be answered by agreement alone.
3. **Given** the person responds with partial agreement, **When** Highway continues, **Then** it
   asks which part is wrong rather than inferring.
4. **Given** the person has already explicitly confirmed the substance, **When** Highway captures
   it, **Then** no second review is requested.
5. **Given** the person refers to content that is not present, **When** Highway responds, **Then**
   it says so rather than agreeing.

---

### User Story 4 - Know whose words these are (Priority: P4)

Introduced domain vocabulary, and claims the person did not make, are visibly marked as Highway's
at the point they are used, so the person can reject the framing and not merely the conclusion.
Ordinary paraphrase is left unmarked so the marking stays meaningful.

**Why this priority**: This is what makes the loosening in P1 and P2 safe. Exploration can be bold
as long as its authorship is visible. Prioritized below them because marking is worthless if there
is no exploratory turn to mark.

**Independent Test**: Run a conversation in which Highway introduces domain vocabulary the person
did not use, and verify the introduction is attributed where it appears, that ordinary paraphrase
carries no marking, and that the term does not enter the captured record unless the person adopts
it.

**Acceptance Scenarios**:

1. **Given** Highway introduces domain vocabulary or a claim the person did not make, **When** that
   term or claim appears, **Then** its authorship is stated at that point.
2. **Given** a marked term is not adopted by the person, **When** Highway converges, **Then** the
   term does not appear in the captured record.
3. **Given** Highway offers a set of recommendations, **When** one is not grounded in the person's
   evidence, **Then** it is marked speculative.

---

### User Story 5 - Review only what changed (Priority: P5)

When a person adds a single fact to content they already accepted, Highway amends rather than
rewrites, and shows what changed.

**Why this priority**: Narrowest scope, but it closes the remaining route for unattributed material
to enter — a full regeneration gives drift somewhere to hide.

**Independent Test**: Accept a candidate, supply one additional fact, and verify the previously
accepted text is unchanged and the addition is distinguishable.

**Acceptance Scenarios**:

1. **Given** the person adds a fact to accepted content, **When** Highway re-presents it, **Then**
   the previously accepted text is unchanged.
2. **Given** content has been amended, **When** it is re-presented, **Then** the change is
   distinguishable from the unchanged text.

---

### Edge Cases

- **Person arrives domain-ready.** A complete, well-formed contribution requiring no material
  interpretation must proceed without an exploratory turn. Existing X2.22 governs this; the
  feature must not narrow it.
- **Person says "I don't know."** Possibilities are already on screen under P2, so this becomes a
  reaction rather than a dead end.
- **Person selects a displayed Converged Proposal.** Existing X2.18 makes selection acceptance; no
  second confirmation is added.
- **No evidence of any kind.** With nothing accepted, there is nothing to ground possibilities in;
  Highway asks rather than inventing starting material.
- **Sources contradict.** Convergence stops, Highway asks which source governs, and the superseded
  source is discarded rather than retained as supporting context.
- **Person asks Highway to decide.** A recommendation set is offered; a request for a decision does
  not transfer authorship of the result.
- **Person refers to content that is not present.** Highway states the discrepancy rather than
  agreeing, and does not act on a false premise.
- **A domain where no grounded possibility exists.** The requirement to open with possibilities
  cannot be satisfied by manufacturing them; Highway says it has none and asks.

## Requirements *(mandatory)*

### Functional Requirements

**Contribution Opportunity**

- **FR-001**: X2.37's Contribution Opportunity MUST be given a prescribed shape: materially
  interpreted substance, no capture heading, no acceptance request.
- **FR-002**: Content presented in a Contribution Opportunity MUST NOT be treated as a candidate
  for acceptance.
- **FR-003**: A Contribution Opportunity MUST end with an invitation to change the substance.
- **FR-004**: An exploratory move within a Contribution Opportunity MUST name the person's own
  words that prompted it.
- **FR-005**: An exploratory move MUST target something a downstream domain will have to decide.
  Vocabulary-only questions MUST NOT satisfy this.
- **FR-027**: This feature MUST NOT introduce a second term for Contribution Opportunity.
- **FR-028**: A Contribution Opportunity MUST be owed whenever the person has made no Substantive
  Contribution to the domain under development.
- **FR-029**: The obligation in FR-028 MUST NOT depend on Highway assessing its own
  interpretation.

**Convergence test**

- **FR-006**: X2.41's convergence test MUST be stated as a condition about whether the person has
  made a Substantive Contribution to the domain, not as a judgement by Highway about its own
  candidate.
- **FR-007**: Approval or selection alone MUST NOT count as a Substantive Contribution.
- **FR-008**: X2.37's exemption for a prior equivalent opportunity MUST be narrowed so that an
  ordinary response to a candidate does not discharge it.
- **FR-030**: The trigger in FR-028 and the convergence test in FR-006 MUST state the same
  condition.

**Opening with possibilities**

- **FR-009**: Vision, Competitive Path, and Guiding Principles MUST each open with grounded
  possibilities before any question.
- **FR-010**: Those possibilities MUST be identified as material to react to rather than a set to
  choose from.
- **FR-011**: Highway MUST offer grounded reasoning without being asked for it first.
- **FR-012**: Where no grounded possibility exists, Highway MUST say so rather than manufacture
  one.

**Acceptance**

- **FR-013**: A materially interpreted Converged Proposal MUST carry an acceptance request that
  asks what is wrong rather than whether it is right.
- **FR-033**: Profile MUST specify a literal default acceptance sentence for each of Identity,
  Vision, Competitive Path, and Guiding Principles.
- **FR-034**: A more specific open question MAY replace the default acceptance sentence.
- **FR-035**: A replacement acceptance question MUST NOT be answerable by agreement alone.
- **FR-014**: A partial acceptance MUST be resolved by asking which part is wrong.
- **FR-015**: Content the person has already explicitly confirmed MUST NOT be re-reviewed.
- **FR-016**: Profile MUST stop mandating the closed acceptance sentences currently fixed for
  Identity, Vision, Competitive Path, and Guiding Principles.

**Attribution**

- **FR-017**: Introduced domain or industry vocabulary MUST be attributed to Highway at the point
  it is used.
- **FR-031**: A substantive claim the person did not make MUST be attributed to Highway at the
  point it is used.
- **FR-032**: Ordinary paraphrase of the person's stated meaning MUST NOT require attribution.
- **FR-018**: An unadopted attributed term MUST NOT appear in a captured record.
- **FR-019**: A recommendation not grounded in the person's evidence MUST be marked speculative.

**Amendment**

- **FR-020**: An increment to accepted content MUST preserve the accepted text unchanged.
- **FR-021**: An amended candidate MUST present its change distinguishably.

**Scope control**

- **FR-022**: At most one Contribution Opportunity per Profile domain is required, unless the
  person's response opens substance not previously available.
- **FR-023**: The existing short path for domain-ready direct contributions MUST remain available
  and MUST NOT be narrowed.
- **FR-024**: Each new or amended rule MUST satisfy the constitution's rule-clarity limits: one
  keyword, one obligation, 25 words or fewer, plus an observable and a tier.
- **FR-025**: This feature MUST NOT reuse a retired rule identifier.
- **FR-026**: Profile and the Experience Standard MUST NOT restate each other's rule text.
- **FR-036**: New and amended Standard rules MUST apply to every skill without a skill-specific
  exemption.
- **FR-037**: This feature MUST register a follow-up specification covering the remaining skills'
  conformance.
- **FR-038**: Only `highway-profile` is verified against the new rules within this feature.

### Key Entities

- **Contribution Opportunity**: Already defined in the Standard. This feature gives it a shape — it
  carries materially interpreted substance, cannot be accepted, and holds possibilities,
  attributions, and one open invitation.
- **Convergence Turn**: A turn carrying a Converged Proposal under its capture heading with one
  acceptance request. Contains only what the person said or accepted.
- **Grounded Possibility**: A direction offered for reaction, traceable to accepted material, not a
  choice in a set.
- **Attribution Mark**: An inline statement that an introduced domain term or an unstated claim
  originated with Highway rather than the person.
- **Contribution**: Substance the person added, corrected, removed, or redirected. The Standard's
  existing *Substantive Contribution* is reused; approval and selection are excluded from it.

## Success Criteria *(mandatory)*

These are decided by a human reading a conversation. No check in this repository can decide them,
and none will be recorded as doing so.

### Measurable Outcomes

- **SC-001**: In a conversation where Highway materially interprets, every Profile domain receives
  at least one Substantive Contribution from the person that is not an approval or a selection,
  before that domain is captured.
- **SC-002**: Every domain term and substantive claim in a captured Profile record is traceable to
  something the person said or explicitly adopted.
- **SC-003**: Vision, Competitive Path, and Guiding Principles each open with at least one grounded
  possibility, in every conversation where prior accepted material exists.
- **SC-004**: No acceptance request on materially interpreted content can be satisfied by agreeing.
- **SC-005**: A person supplying a domain-ready contribution reaches capture with no exploratory
  turn interposed.
- **SC-006**: Re-running the `setup-model.md` stimulus sequence against the amended skills produces
  a conversation a reviewer judges materially closer to `setup-model.md` than to
  `setup-cursor-gemini-2.md`.
- **SC-007**: The captured Profile record from that run contains at least three facts about the
  organization that none of the nine baseline conversations obtained.

## Assumptions

Each of the following resolves a question the feature description left open. They are recorded as
decisions rather than raised as clarifications because the evidence or the requester already
settled them.

- **Contribution Opportunities are conditional for Identity, unconditional from Vision onward.**
  Identity is usually driven by the person's own description, so an exploratory turn there depends
  on whether material interpretation occurred. The requester stated that Vision, Competitive Path,
  and Guiding Principles should always open with possibilities.
- **Attribution is a MUST, not a SHOULD.** Unmarked invention is the central harm in the captured
  conversations, and a SHOULD reproduces the escapability that neutralized X2.37. Its scope is
  narrowed to introduced vocabulary and unstated claims so that the obligation stays usable.
- **The Contribution Opportunity budget is per domain, not per run.** A per-run budget would starve
  the later domains, which are the ones the requester identified as most in need.
- **Process narration is out of scope.** The captured conversations violate it, but X2.36 already
  prohibits it. This feature adds no rule for it.
- **Convergence instrumentation is out of scope.** Mechanical scoring of agent transcripts was
  attempted and abandoned; success here is human-evaluated by design.
- **Objectives, Controls, and NFRs are out of scope for verification, not for applicability.** The
  amendment is written in the Experience Standard and so binds every skill from the moment it
  merges; no exemption clause is added. Only Profile is changed and verified here, and a follow-up
  specification carries the remaining skills' conformance.
- **The Standard's existing structure is retained.** Rules are added and amended in place; no
  renumbering or restructuring of the document is undertaken.

## Dependencies

- Amends `.highway/governance/experience-standard.md` and `.highway/skills/highway-profile/SKILL.md`.
  Both are on the repository's protected-file audit list and are modified only under this
  specification.
- At least nine existing test suites assert exact Standard or Profile text, or assert rule-ID
  presence and retirement. Each will require amendment alongside the rule changes.
- Agent adapter trees are generated from the skill sources and must be regenerated.
- Evidence inputs are `setup-assessment.md` and `setup-model.md`, held outside the repository
  alongside the nine captured conversations.
