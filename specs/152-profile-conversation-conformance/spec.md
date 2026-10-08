# Feature Specification: Profile Conversation Conformance

**Feature Branch**: `152-profile-conversation-conformance`

**Created**: 2026-10-08

**Status**: Draft

**Input**: User description: "Fix the Profile setup conversation so the behaviors the Highway Experience Standard already requires actually occur, and add the behaviors it is missing. Evidence is six recorded Profile setup runs — two each on Codex, Cursor, and Copilot — plus the repository owner's observations on those runs."

## Context

Feature 150 amended the Experience Standard and the Profile skill together. Six recorded Profile
conversations were then captured across three agent runtimes. The amendment held unevenly, and the
pattern in what held is the premise of this feature.

The domain validation question introduced by Feature 150 behaved correctly in all six runs. Its
literal text was written into the Profile skill at each of the four places a domain is validated.

Three rules the Experience Standard already carried did not hold: X2.21, X2.51, and X2.53. None of
them appears as literal text anywhere in the Profile skill; each exists only in governance. The test
suite passes in both cases, because the suite asserts document contents rather than conversational
behavior.

The conclusion this feature is built on: a rule holds when its literal text sits at the point in the
skill where the output is composed. A rule stated only in governance is a rule the agent must recall
while writing, and across six runs recall was not reliable.

## Clarifications

### Session 2026-10-08

- Q: Does this feature include conducting the Profile conversation runs that evidence its behavioral success criteria, or does it ship the documents and leave the runs to a follow-up? → A: Evidence deferred entirely. The Success Criteria are document-conformance criteria and this feature makes no claim that the specified behaviors occur at runtime.
- Q: Should the tool concern be handled by stating where operations are authorized — at readiness and at persistence — instead of adding a prohibition the model has to apply to unknown cases? → A: Authorization at point of use only. The Readiness instruction states that completeness is obtained by reading the retained artifact, the persistence instruction names the write, and no general permission or prohibition is added anywhere.
- Q: When FR-018 and FR-019 say acknowledgment happens for a "meaningful contribution", should that reuse the Experience Standard's existing defined term, or is it deliberately narrower? → A: Reuse Substantive Contribution unchanged, with no added exclusion. Acknowledgment occurs for every Substantive Contribution and for nothing else.
- Q: When FR-008 says a validation request may be suppressed only if the candidate is "textually identical" to confirmed text, what counts as identical? → A: Identical after whitespace and line wrapping are normalized. Any difference in wording or structure denies suppression.
- Q: How should FR-006's requirement of exactly one acceptance boundary per domain apply when a person revisits a domain they already accepted? → A: Drop the exact count. A domain requires at least one explicit acceptance boundary, and the ceiling rule prevents repeats. This resolves the contradiction with re-arming after a revisit.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A domain is accepted explicitly, and not re-asked (Priority: P1)

A person describing their organization reaches a point where they agree with what the workflow has
written. The workflow recognizes that agreement, records the domain, and moves on. It does not ask
again about substance the person already confirmed, and it does not record a domain the person never
explicitly accepted. If the person later revisits the domain, they get to accept the change too.

**Why this priority**: This is the most damaging observed defect and it fails in both directions.
Cursor asked three times on Guiding Principles after clear acceptance, in both runs. Codex-1 recorded
Guiding Principles with no review block and no acceptance request at all, asserting that acceptance
had already happened when it had not. One direction wastes the person's time visibly; the other puts
unaccepted content into a persisted record silently.

**Independent Test**: Confirm the acceptance obligation appears in all four domain instructions and
that removing it from any one of them fails this feature's test by name. The runtime behavior it
encodes is specified by the scenarios below and validated separately.

**Acceptance Scenarios**:

1. **Given** a candidate has been presented for a domain, **When** the person responds with
   unambiguous approval in words other than a fixed phrase, **Then** the workflow treats the domain
   as accepted and does not present the same substance for review again.
2. **Given** a domain's substance was explicitly confirmed, **When** the workflow would present a
   candidate whose text is identical to the confirmed text, **Then** no validation request is issued.
3. **Given** a domain's candidate has materially changed since the last confirmation, **When** it is
   presented again, **Then** the change is named as part of presenting it.
4. **Given** the person agreed with an exploratory idea rather than a candidate, **When** the
   workflow proceeds, **Then** the domain is not recorded as accepted on the strength of that
   agreement.
5. **Given** no explicit acceptance has occurred for a domain, **When** the workflow attempts to
   record it, **Then** it does not, and acceptance is requested.
6. **Given** it is unclear whether a candidate developed since the last confirmation, **When** the
   workflow must choose, **Then** it presents the candidate rather than suppressing the request.
7. **Given** a domain was accepted earlier, **When** the person volunteers information that changes
   it, **Then** the amended candidate requires its own explicit acceptance before it is recorded.

---

### User Story 2 - Every capture looks the same (Priority: P1)

Across all four domains and every agent runtime, the person sees the same shape: a labelled capture
block containing the complete candidate, followed by one clearly marked question asking what they
would change.

**Why this priority**: Shape inconsistency was pervasive and it is the cheapest class of defect to
eliminate, because every element is a fixed literal. Codex-2 omitted the capture heading on all four
domains and bolded the candidate paragraph instead. Codex-1 inverted emphasis, marking its own
interpretation while leaving the question unmarked. The four validation questions were four
different strings, which is how divergence begins.

**Independent Test**: Confirm four capture headings, four emphasis instructions, and one shared
question definition referenced by all four domains, and confirm no superseded question or suffix
string survives anywhere in the tree. All counts are exact.

**Acceptance Scenarios**:

1. **Given** a materially interpreted candidate for any domain, **When** it is presented, **Then** it
   appears under the capture heading required by X2.21, with the complete candidate beneath it.
2. **Given** a capture block, **When** the acceptance request follows it, **Then** the question is
   the marked element and no competing emphasis appears on the workflow's own interpretation.
3. **Given** any of the four domains, **When** validation is requested, **Then** the question is the
   single question string this feature defines, with no trailing qualifier and no domain-specific
   object.
4. **Given** the question string is defined, **When** a domain references it, **Then** it resolves to
   one definition rather than a separately maintained copy.

---

### User Story 3 - A correction is honored as given (Priority: P2)

When the person corrects something, the correction lands exactly as they expressed it: in the form
they were working in, without reintroducing language they rejected, and with an honest answer when
the workflow cannot find what they asked it to change.

**Why this priority**: Corrections are the person's primary instrument of control. Observed failures
undermine it in three distinct ways. Cursor had "laboratory" and "codify" rejected and returned
"testing ground" for the same concept, then used "Codify" in a later title. Cursor-2 answered a
single-bullet correction with flowing prose, discarding the bulleted structure. Codex-2 claimed to
have removed a clause that was never present, emitting byte-identical text.

**Independent Test**: Confirm the vocabulary, form-preservation, and non-location obligations each
appear where a candidate is amended, each carry a gate, and each fail this feature's test when
removed.

**Acceptance Scenarios**:

1. **Given** the person rejected a term, **When** a later candidate is composed, **Then** neither
   that term nor a synonym standing for the same rejected concept appears.
2. **Given** a candidate presented as bullets, **When** the person corrects one bullet, **Then** the
   amended candidate is returned as bullets.
3. **Given** the person asks for a removal, **When** the material cannot be located in the candidate,
   **Then** the workflow says so rather than reporting a change it did not make.
4. **Given** an amendment is made, **When** the amended candidate is presented, **Then** the
   previously accepted text is unchanged and the changed material is distinguishable.

---

### User Story 4 - The conversation adds something (Priority: P2)

The person contributes an idea and gets back more than a restatement of it. Where their contribution
carries real ambiguity, the workflow helps sharpen it. Where it does not, the workflow acknowledges
and moves on without manufacturing a question.

**Why this priority**: This is the difference between the best and worst observed runs and it is what
the repository owner explicitly asked for. Codex probed and produced depth. Copilot restated and
moved fast, and the owner reported getting little from it. Acknowledgments that merely summarize read
as obligatory and add nothing.

**Independent Test**: Confirm the acknowledgment and sharpening obligations appear at each point of
use in every skill they govern, and that the reconciliation recorded in Assumptions is stated in
governance rather than left for the agent to infer.

**Acceptance Scenarios**:

1. **Given** the person made a Substantive Contribution, **When** it is acknowledged, **Then** the
   acknowledgment contains something beyond a restatement of what they said.
2. **Given** the person's turn was not a Substantive Contribution, **When** the workflow responds,
   **Then** no acknowledgment is manufactured.
3. **Given** a contribution with material ambiguity, **When** the workflow proceeds, **Then** it
   reduces that ambiguity before converging.
4. **Given** a contribution with no material ambiguity, **When** the workflow proceeds, **Then** it
   acknowledges and continues without a ceremonial question.

---

### User Story 5 - Nothing leaks from behind the curtain (Priority: P3)

The person sees a conversation about their organization. They do not see the workflow's internal
vocabulary or its description of what it is about to do. The workflow does not improvise an
operation, because every operation it needs is stated where that operation is performed.

**Why this priority**: Present in every run and worst in Copilot, which invented and executed a
command, failed, and then explained the failure to the person in implementation terms. The invented
command traces to an under-specified instruction: Readiness says domain completeness is determined
but never says that it is obtained by reading the retained artifact, and the gap was filled. It
damages credibility without affecting the recorded outcome, which is why it ranks below the
correctness stories.

**Independent Test**: Confirm the concealment obligations appear in the Profile instructions, that
Readiness states how completeness is obtained, that the persistence instruction names the operation
it authorizes, and that no general permission or prohibition covering operations appears anywhere in
the skill.

**Acceptance Scenarios**:

1. **Given** the workflow transitions between domains, **When** it addresses the person, **Then** it
   does not narrate the transition or describe what it is about to do.
2. **Given** any user-visible turn, **When** it is composed, **Then** it contains no internal-state
   vocabulary, including the terms used to describe domain resolution and record state.
3. **Given** the workflow needs to know whether a domain is complete, **When** it determines
   readiness, **Then** it obtains that from the retained artifact as the Readiness instruction
   states, rather than deriving a way to obtain it.
4. **Given** an operation the workflow performs fails, **When** it continues, **Then** the failure is
   not explained to the person in implementation terms.

---

### User Story 6 - Where you're going and how you'll get there stay distinct (Priority: P3)

The person's Vision describes an intended future. Their Competitive Path describes something they
could not have written in the Vision block. The two do not restate each other.

**Why this priority**: The two domains were distinguishable in only one of six runs, and only because
the person volunteered sequencing unprompted. Codex-1 produced near-identical sentences for both.
This is a real defect, but it is ranked last because the fix is bounded and its deeper cause is
deferred to a separate feature.

**Independent Test**: Confirm the Vision boundary against mechanism and the cross-domain
preservation obligation both appear in the Vision instructions, and that neither survives only in a
Verification section.

**Acceptance Scenarios**:

1. **Given** the Vision domain is being composed, **When** the available material includes mechanism
   or approach, **Then** that material is preserved for the unresolved domain that owns it rather
   than absorbed into the Vision.
2. **Given** both domains are resolved, **When** their recorded text is compared, **Then** neither
   reads as a paraphrase of the other.
3. **Given** the Vision instructions are read in isolation, **When** composition begins, **Then** the
   boundary against mechanism is stated there rather than only in a verification checklist.

---

### Edge Cases

- A domain is accepted, and the person later volunteers information that changes it. The acceptance
  boundary must re-arm rather than treating the domain as permanently settled.
- A candidate differs from confirmed text only in line wrapping. Normalization resolves this: without
  it, suppression is denied while re-presentation requires naming a change that does not exist, and
  both paths are blocked.
- The person responds to a validation request with a question instead of an answer. This is not
  acceptance, and the domain remains open.
- The person gives a vague or self-contradicting answer. The acceptance floor is the behavior most
  likely to fail first here, because all six recorded runs involved one cooperative person.
- The person rejects a term and later uses that term themselves. Their own adoption releases the
  prohibition; the workflow's reintroduction does not.
- The person makes no substantive contribution to a domain at all. Interaction with the existing
  contribution-opportunity obligation must be resolved rather than producing a second opportunity
  with no new substance available.
- The person supplies a complete, mature description that needs no interpretation. The short path
  must remain available without a ceremonial exploration step.
- The person asks the workflow to change something in a domain that is not currently active.
- Two corrections arrive in one turn, one locatable and one not.

## Requirements *(mandatory)*

### Functional Requirements

#### Delivery pattern

- **FR-001**: Each behavior in this feature MUST be expressed as a rule in the Highway Experience
  Standard, with an Observable stating a testable condition.
- **FR-002**: Each behavior MUST additionally appear as literal instruction text at every point in
  the skill where that behavior applies, rather than once in a preamble or only in governance.
- **FR-003**: Each behavior MUST be asserted by a gate in the owning skill's Verification section.
- **FR-004**: Each behavior MUST be covered by a test that asserts the rule row exists, the gate text
  exists, and the point-of-use text appears at every applicable site, counted rather than merely
  present somewhere in the file.
- **FR-005**: A behavior that cannot be reduced to point-of-use literal text MUST instead carry a
  decision procedure that can be applied without the agent assessing its own conduct.

#### Acceptance

- **FR-006**: Each Profile domain MUST cross at least one explicit acceptance boundary before it is
  recorded, and acceptance MUST NOT be inferred, assumed, or carried forward from another domain or
  artifact.
- **FR-007**: Acceptance MUST be recognized by meaning rather than by matching a fixed phrase.
- **FR-008**: Suppressing a validation request MUST require the candidate to be identical to
  previously confirmed text once whitespace and line wrapping are normalized; any difference in
  wording or structure MUST deny suppression, and similarity MUST NOT qualify.
- **FR-009**: Presenting a candidate again after a confirmation MUST require naming what changed.
- **FR-010**: Where it is unclear whether a candidate developed, the workflow MUST present it.

#### Shape and wording

- **FR-011**: Every materially interpreted candidate MUST be presented under the capture heading
  X2.21 requires, at each of the four Profile domains.
- **FR-012**: The acceptance request MUST be the emphasized element of the turn, and the workflow's
  own interpretation MUST NOT carry competing emphasis.
- **FR-013**: All four domain validation questions MUST be the single string
  `**What would you add, correct, or remove?**`, with no trailing qualifier and no domain-specific
  object.
- **FR-014**: The validation question MUST be defined once and referenced by each domain rather than
  maintained as four separate literals.

#### Corrections

- **FR-015**: A term the person rejected MUST NOT reappear in a candidate, including as a synonym
  standing for the same rejected concept.
- **FR-016**: An amended candidate MUST be returned in the form the person was working in.
- **FR-017**: A requested amendment that cannot be located MUST be reported to the person, and the
  workflow MUST NOT report a change it did not make.

#### Contribution

- **FR-018**: An acknowledgment MUST add something beyond restating the person's contribution.
- **FR-019**: An acknowledgment MUST occur for each Substantive Contribution, and MUST NOT occur for
  a response that is not one. The term is the Experience Standard's; this feature does not redefine
  or narrow it.
- **FR-020**: The workflow MUST reduce material ambiguity in a contribution before converging, and
  MUST acknowledge and proceed when no material ambiguity exists.

#### Concealment

- **FR-021**: User-visible output MUST NOT narrate workflow transitions or describe intended next
  actions.
- **FR-022**: User-visible output MUST NOT contain internal-state vocabulary.
- **FR-023**: A failed operation MUST NOT be explained to the person in implementation terms.

#### Operation authorization

- **FR-024**: The Readiness instruction MUST state that domain completeness is obtained by reading
  the retained Profile artifact.
- **FR-025**: The persistence instruction MUST name the operation it authorizes.
- **FR-026**: Authorization to perform an operation MUST appear only where that operation is
  performed, and the skill MUST NOT carry a general permission or a general prohibition covering
  operations.

#### Domain boundaries

- **FR-027**: The Vision domain MUST carry an explicit boundary against mechanism and approach,
  stated in its own instructions.
- **FR-028**: Material belonging to an unresolved domain MUST be preserved for that domain rather
  than absorbed by the domain currently being composed, with this obligation stated where
  composition occurs.

#### Scope of amendment

- **FR-029**: Behaviors added to the Experience Standard MUST be written to govern every Interactive
  Workflow rather than shaped around Profile.
- **FR-029a**: Point-of-use text for those behaviors MUST be delivered in `highway-profile`, and this
  feature MUST NOT modify any other skill. Point-of-use delivery for the remaining skills is a
  separate feature.
- **FR-030**: Superseded wording MUST be removed rather than deprecated.
- **FR-031**: The retained Profile record schema and readiness dimensions MUST NOT change.

### Key Entities

- **Profile domain**: One of Identity, Vision, Competitive Path, or Guiding Principles. Each is
  composed, presented, accepted, and recorded independently.
- **Candidate**: The workflow's interpreted proposal for a domain, presented for the person's
  response. Not yet retained.
- **Acceptance boundary**: An explicit point at which a domain's candidate becomes retained content.
  A domain crosses at least one; a revisit that changes accepted content crosses another.
- **Confirmed substance**: Text the person explicitly accepted, against which a candidate is
  compared — with whitespace and line wrapping normalized — when deciding whether a validation
  request may be suppressed.
- **Point-of-use site**: A location in a skill document where an obligation applies and its literal
  text must appear. Countable per obligation.
- **Behavioral validation**: A recorded Profile conversation on one agent runtime, used as evidence
  that a specified behavior occurs at runtime. Out of scope for this feature; named here so the
  boundary is explicit rather than implied.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every behavior in this feature is represented by a rule with an Observable in the
  Highway Experience Standard, and the rule inventory recorded in governance matches the rules
  present.
- **SC-002**: Every behavior's literal instruction text appears at each point in the skill where it
  applies, and for each behavior the number of sites its test asserts equals the number of sites
  where it applies.
- **SC-003**: Every behavior is asserted by a gate in the Verification section of each skill that
  carries it.
- **SC-004**: Every behavior's test fails when its rule row is removed, when its gate text is
  removed, or when any single one of its point-of-use sites is removed.
- **SC-005**: All four Profile domain validation questions resolve to one definition emitting one
  identical string, and no superseded question text or suffix survives anywhere in the tree.
- **SC-006**: The Vision boundary against mechanism and the cross-domain preservation obligation both
  appear in the instructions where composition occurs, and neither survives only in a Verification
  section.
- **SC-007**: Every defect recorded in the 2026-10-08 six-run assessment maps to at least one
  requirement in this feature or to an exclusion named in Assumptions.
- **SC-008**: The generated Profile adapters are byte-identical to the source skill, and the retained
  Profile record schema and readiness dimensions are unchanged.
- **SC-009**: The full test suite passes before the first edit and after the final edit.

**Evidence boundary**: these are document-conformance criteria. This feature does not claim that the
specified behaviors occur in a running conversation, and per D3.8 none of its tests may be recorded
as evidence that they do. Behavioral validation is separate work and gates release.

## Assumptions

- Behavioral validation is out of scope. The behaviors specified by the acceptance scenarios are
  requirements on the running workflow, but this feature claims only that they are correctly
  expressed in the documents that govern it. Recorded conversations across agent runtimes are
  separate work.
- That boundary carries a known risk, accepted deliberately. The preceding feature was
  document-complete with a fully passing suite while three of the rules it relied on were being
  violated in practice. The point-of-use delivery pattern in FR-002 is the mitigation for that
  failure, and the mitigation is itself unproven until behavioral validation runs.
- Backward compatibility is not a constraint. This work is pre-release, so superseded wording is
  removed outright and version bumps are unconstrained.
- Redefining Competitive Path from route to differentiation is deferred to a separate feature. The
  finding is accepted: the person's competitive content consistently landed in Guiding Principles
  because the domain's name promises differentiation while its question asks for a route. It is
  excluded here because it also narrows Guiding Principles and changes what both domains retain.
- FR-020 takes a position on a genuine conflict. The existing restriction on asking only about
  consequential uncertainty is what produced the shallowest observed run. This feature assumes the
  sharpening obligation governs within an Interactive Workflow's composition of a domain, and that
  the existing restriction continues to govern elsewhere. If that reconciliation is rejected, one of
  the two must be amended rather than left to coexist.
- `highway-setup` behavior is out of scope beyond what Profile contributes to it.
- The four generated Profile adapters are regenerated from the source skill and remain byte-identical
  to it.
- Self-reported transcripts are unreliable evidence. Both Codex runs silently dropped turns during
  capture, and one dropped turn produced a false finding during assessment. A run is verified
  complete — four capture blocks and four acceptances — before it is analyzed.
- The six recorded runs involve one organization and one cooperative person. Acceptance recognition
  is the behavior most likely to fail first against a vaguer or self-contradicting person, so
  behavioral validation should include at least one such conversation when it is undertaken.
- Existing retired rule identifiers are not reused; new rules continue from the next unused
  identifier.
- Amending the Experience Standard requires a version bump and corresponding updates to every test
  carrying a hardcoded version string or rule count.
