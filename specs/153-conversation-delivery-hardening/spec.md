# Feature Specification: Conversation Delivery Hardening

**Feature Branch**: `153-conversation-delivery-hardening`

**Created**: 2026-10-09

**Status**: Draft

**Input**: User description: "create a new spec covering Pass A and Pass B"

Pass A and Pass B are defined in `evidence/setup-assessment.md` §7, which records six observed setup
conversations across three agent hosts against Experience Standard `11.0.0` and
`highway-profile` `11.0.0`. Pass A is items 1, 4, 5, 6, 7, 9, 10 and 11 — correctness and
deterministic delivery. Pass B is items 2a, 2b and 3 — generative behavior. Item 8 is **not** in
scope; it is recorded as Phase 18 in `governance-plan.md`.

The two passes are carried in one feature because §4.3 established that the narration defect
(Pass A) and the continuity requirement (Pass B) are the same vacuum seen from two sides.

**This feature delivers text; it does not evaluate conversations.** Every requirement below is
satisfied by the presence and shape of a delivery site. No recorded setup conversation is part of
this feature's acceptance. Whether the delivered text changes what agents actually do is assessed
in a separate round after implementation, and any findings become their own spec.

## Clarifications

### Session 2026-10-09

- Q: How many worked exemplars should the Profile workflow carry for the new contribution behavior? (FR-011) → A: Three, each a different move, drawn from the recorded runs
- Q: Which workflows should receive the continuity-signal text in this feature? (FR-013) → A: `highway-profile` only — the four Profile domain handoffs
- Q: Should a reviewer's reading of recorded conversations block completion? (SC-007) → A: No recorded conversations in this feature; conversational evaluation is a separate follow-up spec
- Q: Should this feature repair the per-section word limit so it decides the Profile workflow? (FR-017) → A: Measure and record sizes only; change no check, and record the gap for a later feature
- Q: Where should the wording for soliciting reaction where nothing has been captured live? (FR-002) → A: A second shared emitted literal, reusable by any workflow

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Nothing is recorded that I did not accept (Priority: P1)

A person completing their Profile sees each domain's finished wording presented back to them
before anything is kept. When they approve a list of possibilities rather than a finished
candidate, the workflow presents the candidate first and keeps nothing until that candidate is
accepted. The validation question appears only where an actual candidate is on the screen, so its
presence always means the same thing.

**Why this priority**: This is the only correctness defect in the round. In one observed run two
of four Profile domains were written from material the person never saw in final form. Everything
else in this feature is quality; this one produces a record that misrepresents the person.

**Independent Test**: Inspect the Profile workflow's delivery sites for the four domains: each
requires a presented candidate before retention, and the shared validation question is restricted
to moments when a candidate exists.

**Acceptance Scenarios**:

1. **Given** the workflow has offered several possibilities for a domain, **When** the person
   replies with a general approval of those possibilities, **Then** the workflow presents a single
   finished candidate for that domain and retains nothing until the person accepts that candidate.
2. **Given** a domain's candidate has been accepted, **When** the workflow continues, **Then** it
   does not ask a second time for acceptance of the same content.
3. **Given** the workflow is opening a domain and has captured nothing yet, **When** it offers a
   direction for the person to react to, **Then** it does not use the validation question reserved
   for accepted candidates.

---

### User Story 2 - The workflow carries my words forward instead of narrating itself (Priority: P2)

Between domains, and at the handoff out of Profile, the person reads a sentence built from what
they just said — not an announcement of what the workflow is doing next. Internal vocabulary
(persistence, readiness, domain state, acceptance boundaries, next actions) never appears.

**Why this priority**: Internal narration failed in four of six runs across all three hosts and is
the single most common defect observed. §4.3 established the two as one problem: the agent reaches
for continuity, finds nothing specified, and narrates its own workflow state instead.

**Independent Test**: Inspect the Profile workflow for continuity text at each of its three domain
handoffs, and for narration-prohibition coverage naming persistence, progression and domain state.

**Acceptance Scenarios**:

1. **Given** a domain has been accepted, **When** the next domain opens, **Then** the opening text
   names substance the person already supplied and connects it to the question being asked.
2. **Given** the workflow is retaining accepted content, **When** it responds, **Then** it does not
   describe the retention, the sequence, the current domain state, or what it will do next.

---

### User Story 3 - The workflow adds something to my thinking (Priority: P3)

When the person supplies something substantial, the workflow responds with one grounded addition —
either a distinction already latent in what they said, named for the first time, or a reachable
option they had not articulated — attributed as the workflow's own and offered without being
written into any candidate until the person adopts it.

**Why this priority**: This is the difference between a workflow that records thinking and one that
extends it, and the person named it as the experience they want. It is ranked below the two above
because it cannot be verified by the test suite and because an incorrect implementation
manufactures novelty, which is worse than flatness.

**Independent Test**: Inspect the Experience Standard for the contribution rule and its bound, and
the Profile workflow for the three exemplars — each concrete, each a different move, each closing on
a question that invites contribution.

**Acceptance Scenarios**:

1. **Given** the person supplies substantial new information, **When** the threshold for materially
   improving the working idea is met, **Then** the response offers exactly one grounded addition.
2. **Given** the threshold is not met, **When** the workflow responds, **Then** it offers no
   addition rather than padding with low-value detail.
3. **Given** an addition has been offered and not adopted, **When** a candidate is next presented,
   **Then** the addition's wording does not appear in that candidate.
4. **Given** an addition is offered, **When** the person reads it, **Then** it is attributed to the
   workflow and closes on a question that invites contribution rather than a yes or no.

---

### User Story 4 - Each domain stays on its own subject (Priority: P4)

When the person describes the future they want, the workflow keeps that answer to the future and
explicitly carries any method or sequencing they mention into the later domain that owns it,
without re-presenting an unchanged candidate.

**Why this priority**: Failed in four of six runs, and the two passing runs show the behavior is
achievable. It degrades the record's usefulness rather than its honesty.

**Independent Test**: Inspect the future-oriented domain's delivery site for an emitted cue
excluding approach and sequencing and naming the domain that owns them.

**Acceptance Scenarios**:

1. **Given** the person supplies approach or sequencing while a future-oriented domain is open,
   **When** the workflow responds, **Then** it states that the material will be taken up in the
   domain that owns it and keeps the current domain's wording free of it.
2. **Given** a candidate's wording has not changed, **When** the workflow continues, **Then** it
   does not present that candidate again.

---

### User Story 5 - The small literal corrections (Priority: P5)

The validation question is followed by an unemphasized reassurance that names "I don't know" as a
legitimate answer; an amendment to an accepted candidate is marked inline within the candidate
rather than appended as a separate block; and the agent grounding files name the moment at which
the Experience Standard is to be read.

**Why this priority**: Low severity, low risk, and each is independently useful. They are listed
last so they are not used as evidence that the feature succeeded.

**Independent Test**: Inspect the emitted validation block for the unemphasized reassurance, the
Experience Standard for the inline amendment form, and the four grounding files for the named
trigger.

**Acceptance Scenarios**:

1. **Given** a candidate is presented, **When** the validation question is shown, **Then** an
   unemphasized reassurance follows it and the question remains the only emphasized element.
2. **Given** an accepted candidate is amended, **When** it is re-presented, **Then** the change is
   marked within the candidate's own text and the unchanged wording is preserved.

---

### Edge Cases

- The person approves a list of possibilities with wording that is unambiguous approval but does
  not name a candidate. The workflow must present a candidate without treating the approval as a
  reservation and without asking the same question twice.
- The person answers "I don't know" to a validation question. The reassurance invites this, so the
  workflow must have a next move that does not require them to produce substance.
- The person supplies nothing substantial for several turns. US3's requirement must not fire, and
  the absence of an addition must not be treated as a defect.
- The person rejects an offered addition. Its wording must not reappear, including as a synonym, in
  any later candidate.
- A host emits a domain opening with no preceding accepted substance — the first domain of the
  first workflow. The continuity requirement must have a defined behavior there rather than forcing
  a fabricated carry-forward.
- A recorded run satisfies every document contract in this feature and still reads as procedural.
  Per §6 of the assessment this is possible, and nothing in this feature would detect it. It is the
  expected subject of the follow-up round rather than a defect in this one.

## Requirements *(mandatory)*

### Functional Requirements

**Pass A — correctness and deterministic delivery**

- **FR-001**: The Profile workflow MUST have point-of-use text requiring a finished candidate to be
  presented for a domain before any of that domain's substance is retained.
- **FR-002**: The Profile workflow MUST have point-of-use text restricting the shared validation
  question to moments when a candidate has been presented. A second shared emitted literal MUST
  exist for soliciting reaction where nothing has been captured, available to any workflow rather
  than written locally per skill.
- **FR-003**: The Profile workflow's delivery of the no-internal-narration rule MUST cover
  persistence, progression and domain state, not readiness vocabulary alone.
- **FR-004**: The Profile workflow MUST carry an emitted cue keeping the future-oriented domain's
  retained wording free of approach and sequencing, and naming the domain those belong to.
- **FR-005**: *Withdrawn 2026-10-09.* This requirement asked the setup workflow to change the
  heading level of the workflow opening following Profile. The heading level is not the cause of
  the observed confusion at that seam, so no heading is changed by this feature. The identifier is
  retired rather than reused, and the numbering of FR-006 onward is unchanged.
- **FR-006**: The emitted validation block MUST include an unemphasized reassurance naming "I don't
  know" as a legitimate answer, with the validation question remaining the only emphasized element.
- **FR-007**: The Experience Standard rule governing amendment marking MUST name the inline form —
  the change marked within the candidate's own text — and MUST remain consistent with the existing
  requirement that accepted content retains its original form.
- **FR-008**: The agent grounding files MUST name the moment at which the Experience Standard is to
  be read, rather than advising that it be consulted.

**Pass B — generative behavior**

- **FR-009**: The Experience Standard MUST require an Interactive Workflow to contribute one useful
  addition to the person's thinking — a latent distinction or a reachable extension — when grounded
  non-redundant reasoning would materially improve the relevant working idea.
- **FR-010**: FR-009's requirement MUST be bounded to exactly one addition per qualifying
  contribution, and MUST exclude optional detail, repetition, unsupported speculation, manufactured
  alternatives, ceremony and low-value addition.
- **FR-011**: The Profile workflow MUST carry exactly three worked exemplars of FR-009's behavior,
  using concrete domain content rather than placeholder structure, each demonstrating a different
  move, and each closing on a question that invites contribution rather than approval. The three
  moves are: a distinction drawn out of a single word the person used; latent structure named as an
  organizing principle; and a stated preference reframed as a decision criterion.
- **FR-012**: A shared contract MUST require the text opening a domain or workflow to carry
  accepted substance forward from what preceded it, and MUST define the behavior where nothing has
  yet been accepted.
- **FR-013**: FR-012's contract MUST be delivered as point-of-use text in `highway-profile`,
  covering each handoff between its four domains, and MUST NOT be satisfied by a generic transition
  sentence that names no accepted substance. Delivery to other workflows is out of scope.

**Constraints the above work operates under**

- **FR-014**: No requirement owned by the Experience Standard may be restated in a skill; delivery
  is limited to emitted literals, skill-owned procedure, and Verification entries.
- **FR-015**: The Profile workflow MUST remain free of MUST-level keywords, preserving the existing
  contract that its conversational guidance is not expressed as obligations on the person.
- **FR-016**: Every agent tree's copy of a changed skill MUST be regenerated and MUST remain
  identical to its source.
- **FR-017**: Added normative text MUST be measured against the per-section word limit, and any
  section the limit does not currently decide MUST have its measured size recorded rather than
  assumed acceptable.

**Evidence**

- **FR-018**: No requirement in this feature may be recorded as evidence that a behavior occurs in
  conversation. Every check here is a document contract over delivered text.
- **FR-019**: The completion report MUST state requirement coverage separately from check results,
  and MUST state that every requirement's evidence is document-contract only.
- **FR-020**: The feature MUST record that conversational evaluation is deferred, so a later reader
  does not mistake a delivered site for an observed behavior.

### Key Entities

- **Candidate**: a domain's finished wording presented for acceptance. Retention depends on it.
- **Addition**: the single grounded distinction or extension required by FR-009. Attributed to the
  workflow, offered outside any candidate, and barred from a candidate until adopted.
- **Continuity signal**: the text opening a domain or workflow, made of accepted substance from
  what preceded it.
- **Delivery site**: the place in a skill where a Standard rule reaches the agent — an emitted
  literal, a procedure step, or a Verification entry. The unit this feature delivers and checks.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All four Profile domains carry a delivery site requiring a presented candidate before
  any of that domain's substance is retained; currently zero do.
- **SC-002**: The shared validation question's delivery names the condition under which it may be
  used, and a second shared literal exists for soliciting reaction where nothing has been captured.
- **SC-003**: The narration prohibition's delivery in the Profile workflow names persistence,
  progression and domain state; it currently names readiness vocabulary only.
- **SC-004**: All three handoffs between the four Profile domains carry continuity text requiring
  accepted substance to be named; currently zero do.
- **SC-005**: The Experience Standard carries the contribution requirement, bounded to one addition
  per qualifying contribution and carrying an exclusion list.
- **SC-006**: The Profile workflow carries exactly three exemplars, each demonstrating a different
  move and each closing on a question that invites contribution rather than approval.
- **SC-007**: The Profile workflow contains zero MUST-level keywords after the change, unchanged
  from before it.
- **SC-008**: Every agent tree's copy of every changed skill is identical to its source.
- **SC-009**: The test suite exits 0 and the added runtime is measured.
- **SC-010**: The completion report names every requirement whose evidence is document-contract
  only — which, in this feature, is all of them.

## Assumptions

- **Item 8 is out of scope.** The rule-coverage report is recorded as Phase 18 in
  `governance-plan.md` with a prerequisite on this feature, because a coverage map produced before
  these delivery sites settle would map a surface that is about to move.
- **The Profile → Objectives opening receives one of its three candidate fixes.** The observed
  confusion at that seam was originally attributed to three causes: a heading level inconsistent
  with the Profile domains, a validation question used where nothing had been captured, and no
  continuity carrying accepted substance forward. The heading level has since been ruled out as a
  cause and FR-005 is withdrawn. FR-002 addresses the validation question. Continuity at this seam
  is deliberately excluded by FR-013 and remains open after this feature. What actually produces
  the confusion, beyond the validation question, is not established by this feature and is left to
  the conversational evaluation that follows it.
- **The Standard rule is defined for all Interactive Workflows; exemplars are delivered only to the
  workflows this feature touches.** Defining the rule narrowly would create the per-skill divergence
  §6 warns about; delivering exemplars everywhere is a larger change than the evidence supports.
- **Conversational evaluation is out of scope and is a separate spec.** This feature's acceptance is
  the presence and shape of delivered text. A round of recorded setup conversations follows
  implementation, and any findings become their own feature. The practical consequence is that
  **none of the behaviors this feature targets is known to occur when it closes** — only that the
  text intended to produce them exists where an agent will read it.
- **The assessment's conformance counts are not rates.** Six conversations, one organization, one
  cooperative person, the same source material each time. They are counts of what happened and are
  used here to rank work, not to predict it.
- **Perceived quality has no automated oracle**, which is why the evaluation round is separate
  rather than folded in as a success criterion here.
- **The per-section word limit does not currently decide the Profile workflow.** The limit applies
  only to sections carrying MUST-level keywords, and FR-015 keeps the Profile workflow free of them.
  Its largest section already measures well above the limit without being checked. FR-017 therefore
  requires measurement and recording rather than relying on a check that will not fire. Repairing
  the check is left to a later feature, because it would amend a shipping constitution rule and
  force every skill to be re-measured against the new reading.
