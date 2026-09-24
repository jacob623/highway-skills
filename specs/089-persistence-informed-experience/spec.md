# Feature Specification: Persistence and Informed Experience

**Feature Branch**: `089-persistence-informed-experience`

**Created**: 2026-09-24

**Status**: Draft

**Input**: User description: Establish a global contract for verified retained-output completion and an informed, scan-friendly Highway interaction experience through amendments to the Highway Skills Constitution and Highway Experience Standard.

## Clarifications

### Session 2026-09-24

- Q: Do Persistence and Completion Integrity rules apply immediately to existing skills? → A: No. They apply to new skills and to existing skills when those skills are amended. Existing unchanged skills remain grandfathered until migration, so the constitutional amendment is not treated as a breaking change solely because it adds these obligations.
- Q: May Feature 089 modify validation tooling and tests required to recognize the new governing rules? → A: Yes. Feature 089 may modify repository validation tooling and tests required to validate the new governing rules, identifiers, N/A conditions, counts, and metadata, but it must not modify individual skill files.
- Q: Where are N6-N9 registered? → A: The Constitution's Compliance Review Protocol is the single authoritative registration point for the closed permitted N/A vocabulary. The Experience Standard references applicable IDs without defining competing N6-N9 entries; this feature does not expand the historical N3/N5 duplication.
- Q: Should FR-039 create a new Experience Standard rule? → A: No. The requirement is implemented through the existing Interactive Workflow UX Contract, which explains that Decision Context and Relevant Examples support the one unresolved question, Presentation Labels affect presentation only, and Contextual Acknowledgment continues under X2.8 without creating another response-demanding decision.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Trustworthy Retained-Output Completion (Priority: P1)

As a Highway maintainer, I want successful completion claims to require verified retained state, so that a workflow cannot report that approved work exists when the owning skill did not persist or verify it.

**Why this priority**: Persistence correctness is the foundation for trustworthy orchestration. User approval and a write attempt are not evidence that a retained artifact exists.

**Independent Test**: Review the amended Highway Skills Constitution against hypothetical retained-output contracts and confirm deterministic results for verified output, failed verification, multiple outputs, no Retained Output, and grandfathered unchanged skills.

**Acceptance Scenarios**:

1. **Given** the amended Constitution applies to a new or amended skill declaring Retained Output, **when** it creates or changes that output, **then** it performs Persistence Verification after the write and before making a Verified Completion Claim.
2. **Given** Persistence Verification fails for any output covered by a claim, **when** the workflow reaches its completion decision, **then** it produces a non-success outcome naming the missing or invalid Retained Output and does not claim successful completion.
3. **Given** a new or amended workflow declares no Retained Output, **when** its contract is reviewed, **then** the Constitution records the persistence rules as N/A under N6, meaning no Retained Output is declared.
4. **Given** an unchanged existing skill has not been amended, **when** the new principle is introduced, **then** it remains grandfathered until migration.
5. **Given** an orchestrating workflow receives an owner result, **when** owner persistence is not verified, **then** orchestration consumes the non-success completion result and does not infer persistence from approval, confirmation, review acceptance, identifier proposal, or mutation attempt.

### User Story 2 - Informed Contextual Collection (Priority: P1)

As a Highway user, I want questions to explain why requested information matters and provide relevant illustrative examples when useful, so that I can make informed decisions without being asked extra questions or being given hidden defaults.

**Why this priority**: Context and examples improve decision quality while preserving the existing one-unresolved-question interaction contract.

**Independent Test**: Review the amended Experience Standard and its illustrative cases to confirm deterministic applicability for Decision Context, Relevant Examples, anti-ceremony, and one-question collection.

**Acceptance Scenarios**:

1. **Given** the amended Experience Standard applies to a guided information-collection workflow and the requested answer can affect a downstream outcome, **when** the prompt is presented, **then** it provides concise Decision Context unless the implication was explicitly established immediately before.
2. **Given** the amended Experience Standard applies and an example clarifies the expected response kind or form, **when** the prompt is presented, **then** it provides a concise Relevant Example without presenting it as a required answer, default, policy, or user-content constraint.
3. **Given** Decision Context and Relevant Examples are included, **when** the prompt is presented, **then** exactly one unresolved collection question remains and supporting guidance introduces no additional decision.
4. **Given** no downstream implication or explanatory value exists, **when** a prompt is presented, **then** the applicable rule is recorded N/A under N7 or N8 rather than adding ceremony.
5. **Given** repository context already contains information needed for the decision, **when** the workflow asks its next question, **then** it does not recollect that context and asks only for the next missing user input.

### User Story 3 - Scan-Friendly and Honest Workflow Status (Priority: P1)

As a Highway user, I want structured information and completion or failure status to be easy to scan and honest about approval, persistence, verification, and completion, so that I can understand what happened and what action is available next.

**Why this priority**: Clear presentation is the user-facing counterpart to persistence correctness and prevents ambiguous success language.

**Independent Test**: Review the amended Experience Standard and its illustrative cases for Structured Information, persistence failure, and verified completion output.

**Acceptance Scenarios**:

1. **Given** two or more named fields are presented together for review or decision-making, **when** the output is rendered, **then** each field's Presentation Label is visually distinct from its adjacent value.
2. **Given** emitted content contains no Structured Information, **when** the Presentation Label rule is evaluated, **then** the rule is recorded N/A under N9 and ordinary conversational prose remains unchanged.
3. **Given** an owner reports persistence failure, **when** the workflow communicates the result, **then** it presents a non-success status naming the expected output and an actionable next step.
4. **Given** every Retained Output covered by a claim has been verified, **when** a completion message confirms the result, **then** it may identify the saved artifact or persisted state without conflating approval with persistence.
5. **Given** a user answer produces a Material Influence, **when** the workflow continues, **then** it uses the existing contextual-acknowledgment rule concisely; ordinary answers do not receive acknowledgments solely for conversational ceremony.

### Edge Cases

- A write succeeds technically but the expected retained file or repository state is absent, invalid, or at the wrong declared location.
- User approval exists without a successful write, or a write attempt exists without successful persistence.
- A workflow changes multiple retained outputs and only a subset can be verified.
- A workflow emits no Retained Output and therefore has no persistence state to verify.
- A repository context document is unavailable while a prompt could otherwise use context.
- The significance of a question was explained immediately before the current prompt.
- An example could be mistaken for a required framework, default, policy, architecture, technology, objective, Control, or NFR.
- Structured information contains long values that should remain adjacent to short labels without bolding the complete value.
- A failure must distinguish user approval, attempted mutation, persistence, verification, and overall completion.
- A contextual acknowledgment could become unrelated product promotion or implementation-detail exposition.
- Conversational prose is clearer than field formatting for a short, ordinary response.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Highway Skills Constitution MUST define Retained Output as an artifact or repository state that a skill contract declares will remain after successful completion.
- **FR-002**: The Highway Skills Constitution MUST define Persistence Verification as a post-write check confirming declared Retained Output exists at its declared location or satisfies its declared persisted-state condition and applicable output-state contract.
- **FR-003**: The Highway Skills Constitution MUST define Completion Claim as a user-visible or machine-consumable statement that a mutation, workflow, stage, or retained-output operation completed successfully.
- **FR-004**: The Highway Skills Constitution MUST define Verified Completion Claim as a Completion Claim made only after every Retained Output covered by the claim passes Persistence Verification.
- **FR-005**: The Highway Skills Constitution MUST add a Persistence and Completion Integrity principle after Repository Context.
- **FR-006**: Persistence and Completion Integrity rules MUST apply to new skills and existing skills when amended, while existing unchanged skills remain grandfathered until migration.
- **FR-007**: A skill that creates or changes Retained Output MUST perform Persistence Verification before making a Verified Completion Claim.
- **FR-008**: A skill MUST NOT make a Completion Claim when Persistence Verification fails.
- **FR-009**: A failed Persistence Verification MUST produce a non-success outcome naming the expected Retained Output that could not be verified.
- **FR-010**: When one Completion Claim covers multiple Retained Outputs, Persistence Verification MUST succeed for every output covered by that claim.
- **FR-011**: A workflow MUST NOT make a successful Completion Claim when any Retained Output covered by that claim fails Persistence Verification.
- **FR-012**: An orchestrating workflow MUST consume the owning workflow's completion result rather than infer persistence from approval, confirmation, review acceptance, identifier proposal, or mutation attempt.
- **FR-013**: Persistence Verification rules MUST be recorded N/A under constitutional condition N6 when a reviewed workflow declares no Retained Output.
- **FR-014**: Applicable constitutional reviews MUST verify Retained Output identification, post-write verification, completion dependency, failure blocking, named failure state, and multi-output coverage.
- **FR-015**: The constitutional amendment MUST preserve the distinct responsibilities of shared output templates, emitted path declarations, owner transactions, persistence correctness, and Experience Standard compliance.
- **FR-016**: The Highway Experience Standard MUST define Decision Context as a concise explanation of how requested information can affect a downstream recommendation, decision, artifact, governance interpretation, or workflow behavior.
- **FR-017**: The Highway Experience Standard MUST define Relevant Example as a concise example illustrating the expected kind or form of an answer without constraining the user's choice.
- **FR-018**: The Highway Experience Standard MUST define Presentation Label as a short user-facing label identifying the meaning or role of an adjacent value.
- **FR-019**: The Highway Experience Standard MUST define Structured Information as two or more named fields, properties, statuses, relationships, options, or values presented together for review or decision-making.
- **FR-020**: A guided information-collection workflow MUST provide Decision Context when the requested answer can affect a downstream recommendation, decision, artifact, governance interpretation, or workflow action.
- **FR-021**: A guided information-collection workflow MUST provide a Relevant Example when an example clarifies the expected response kind or form.
- **FR-022**: Decision Context and Relevant Examples MUST remain supporting information rather than additional unresolved collection questions.
- **FR-023**: Relevant Examples MUST be presented as illustrative.
- **FR-024**: Relevant Examples MUST NOT constrain user-owned content.
- **FR-025**: A structured user-facing field MUST visually distinguish its Presentation Label from its value under the applicable X1 output-structure rule.
- **FR-026**: The Experience Standard MUST include non-normative guidance for labels, identity, origin, implication, decisions, next actions, emphasis, and conversational prose in Structured Information.
- **FR-027**: The Experience Standard MUST preserve X2.8 as the authority for contextual acknowledgment after information produces a Material Influence.
- **FR-028**: The Experience Standard amendment MUST preserve the existing Material Influence applicability boundary for Contextual Acknowledgment.
- **FR-029**: The Experience Standard amendment MUST preserve the existing no-promotion boundary for Contextual Acknowledgment.
- **FR-030**: Persistence failure guidance MUST make the non-success status, expected output, problem, and next action understandable without duplicating constitutional Persistence Verification rules.
- **FR-031**: Completion guidance MUST distinguish approval, persistence, verification, and overall completion without requiring every successful interaction to display all four states.
- **FR-032**: The constitutional and Experience Standard amendments MUST preserve user-owned governance content and MUST NOT require a specific compliance framework, architecture, technology, objective, Control, or NFR.
- **FR-033**: The feature MUST NOT modify individual skill files; governing-document validation tooling may change only when required to validate this amendment, and migrations for Profile, Objectives, Controls, NFRs, Setup, and other skills remain follow-up work.
- **FR-034**: The amendments MUST update Sync Impact Reports, semantic versions, rule counts, tier counts, added definitions, added principles or rules, precedence, self-application, and non-restatement records.
- **FR-035**: New constitutional rules MUST use the next available P identifiers and satisfy the existing one-keyword, one-obligation, Observable, Tier, and normative-length constraints.
- **FR-036**: New Experience Standard rules MUST use the next available identifier in the X section matching the rule's subject.
- **FR-037**: Existing X2.1-X2.8 identifiers and normative semantics MUST remain unchanged.
- **FR-038**: The Experience Standard MUST define N/A conditions N7 for Decision Context when no downstream implication exists or the implication was explicitly established immediately before the prompt, N8 for Relevant Example when no example clarifies the response form, and N9 for Structured Information when emitted content contains no Structured Information.
- **FR-039**: The Interactive Workflow UX Contract MUST state that Decision Context and Relevant Examples support the one unresolved question, Presentation Labels affect presentation only, and Contextual Acknowledgments continue under X2.8 without introducing an additional user decision unless independently required by the workflow.
- **FR-040**: The constitutional amendment MUST explicitly state that owner workflows write and verify Retained Output before producing a Verified Completion Claim and orchestrators consume that result to advance or stop.
- **FR-041**: Feature 089 MUST reconcile the Constitution's current-version declaration with its latest completed amendment metadata before calculating the amendment version increment.
- **FR-042**: The Constitution's Compliance Review Protocol MUST be the sole authoritative registration point for N6-N9, while the Experience Standard references applicable IDs without redefining them.

### Key Entities *(include if feature involves data)*

- **Retained Output**: An artifact or repository state declared by a skill contract to remain after successful completion.
- **Persistence Verification**: The post-write check that confirms Retained Output exists at its declared location or satisfies its declared persisted-state condition and applicable output-state contract.
- **Completion Claim**: A user-visible or machine-consumable successful-completion statement.
- **Verified Completion Claim**: A Completion Claim made only after every Retained Output covered by the claim has passed Persistence Verification.
- **Decision Context**: Concise information explaining a downstream implication of requested input.
- **Relevant Example**: An illustrative response-form example that does not constrain user choice.
- **Presentation Label**: A short label identifying the role of an adjacent value.
- **Structured Information**: Multiple named values presented together for review or decision-making.
- **Contextual Acknowledgment**: A concise acknowledgment governed by X2.8 when information has Material Influence.

## Non-Normative Experience Guidance

When both Decision Context and a Relevant Example apply, the preferred informed-question pattern
is:

```markdown
**Question:** <one unresolved question>

**Why it matters:** <concise downstream implication>

**Examples:** <one or more representative examples>
```

Decision Context and Relevant Examples support the one unresolved question; they are not additional
questions or decisions. They should help the user answer without making every prompt longer. Context
already known from the repository should not be recollected.

The interaction lifecycle is:

```text
Existing Repository Context
	↓
Decision Context
	↓
Relevant Example when applicable
	↓
Only the next missing user input
	↓
Contextual Acknowledgment when X2.8 applies
	↓
Clearly presented next state
```

Decision Context, Relevant Examples, Presentation Labels, and Contextual Acknowledgments do not add
an independent user decision. Avoid ceremony such as asking whether the user understands the
explanation or wants another example when neither is required by the workflow.

For Structured Information, prefer short labels adjacent to values, emphasize labels rather than
bolding complete long values, and include identity, origin, implication, available decision, and
next action when those elements exist. Preserve ordinary conversational prose when field formatting
would make the response less natural.

Illustrative patterns:

```markdown
**Question:** What compliance requirements should Highway consider?

**Why it matters:** Compliance requirements can influence downstream governance, architecture, and implementation guidance.

**Examples:** CIS Benchmarks, NIST standards, internal governance standards.
```

```markdown
**Candidate:** Availability and resilience
**Originating Control:** CTL000001 - Multi-zone availability
**Statement:** Platforms must provide active-active operation across multiple availability zones.
**Decision:** Accept, Modify, Replace, or Reject
```

```markdown
- **Profile:** Complete
- **Business Objectives:** Complete
- **Controls:** Complete
- **NFRs:** Complete
```

Avoid treating an example as a constraint:

```markdown
Use CIS Benchmarks.
```

Prefer:

```markdown
**Examples:** CIS Benchmarks, NIST standards, internal governance standards.
```

For persistence failure, the Experience Standard may present enough structure to make the result
actionable without duplicating constitutional completion rules:

```markdown
**Status:** Blocked
**Expected Output:** library/governance/controls/CTL000001.md
**Problem:** The approved Control could not be verified after persistence.
**Next Action:** Retry the owning Control workflow.
```

When a Verified Completion Claim is useful to the user, a concise confirmation may distinguish the
state from approval:

```markdown
**Status:** Complete
**Saved:** CTL000001 - Multi-zone availability
**Location:** library/governance/controls/CTL000001.md
```

These examples are not additional rules and do not require every successful interaction to show all
approval, persistence, verification, and completion states.

## Applicability Conditions

The specification maps the new review conditions as follows:

- **N6**: The reviewed workflow declares no Retained Output; this condition applies to the new
	Persistence and Completion Integrity rules.
- **N7**: No downstream implication exists, or the applicable implication was explicitly established
	immediately before the current prompt; this condition applies to Decision Context.
- **N8**: No example clarifies the expected response kind or form; this condition applies to Relevant
	Example.
- **N9**: The emitted content contains no Structured Information; this condition applies to
	Structured Information presentation.

For implementation mapping, N6 applies to the Persistence Verification obligations for P12.1
through P12.4 when the reviewed workflow declares no Retained Output. The owner/orchestrator
obligation is evaluated according to its orchestration trigger rather than inheriting N6 solely
because an orchestrator may not declare Retained Output.

The persistence obligations remain atomic during rule decomposition. Implementation may assign
separate P12 rules for verification before a Verified Completion Claim, blocking claims after
failed verification, naming the unverified Retained Output, verifying every output covered by a
multi-output claim, and consuming the owner's completion result. Each rule must satisfy the
Constitution's one-keyword, one-obligation, Observable, Tier, and normative-length constraints.

## Follow-up Migration Expectations

These are roadmap expectations for later skill amendments, not completion criteria for Feature 089:

- Retained-output owners perform Persistence Verification before successful completion.
- Owners verify every Retained Output covered by a Verified Completion Claim.
- Owners report non-success when verification fails.
- Orchestrators consume owner completion rather than infer persistence.
- Guided collection provides Decision Context when applicable.
- Guided collection provides Relevant Examples when applicable.
- Structured Information uses distinct Presentation Labels.
- Material Influence continues to use X2.8.
- Existing Repository Context is not unnecessarily recollected.

Recommended migration order: `highway-profile`, `highway-objectives`, `highway-controls`,
`highway-nfrs`, then `highway-setup`. Owners migrate before the orchestrator so Setup can depend on
verified owner completion rather than recreate owner persistence checks.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of required persistence definitions appear in the Highway Skills Constitution.
- **SC-002**: 100% of new persistence rules have a unique ID, one keyword, one obligation, an Observable, and a valid Tier.
- **SC-003**: The Constitution explicitly defines applicability for existing unchanged skills versus new or amended skills.
- **SC-004**: The Constitution explicitly defines N6 for workflows declaring no Retained Output, and no Experience condition reuses N6.
- **SC-005**: The Constitution explicitly defines completion semantics for one Verified Completion Claim covering multiple Retained Outputs.
- **SC-006**: The Constitution explicitly distinguishes owner verification from orchestrator consumption of owner completion state and gives Persistence and Completion Integrity an explicit Principle Precedence rank.
- **SC-007**: 100% of required Experience definitions appear in the Highway Experience Standard.
- **SC-008**: Every new Experience rule has an explicit applicability condition or permitted N/A condition, using N7 for Decision Context, N8 for Relevant Example, and N9 for Structured Information.
- **SC-009**: The Presentation Label rule is assigned to X1 and informed-collection rules are assigned to X2.
- **SC-010**: Existing X2.1-X2.8 identifiers and normative semantics remain unchanged.
- **SC-011**: 100% of amendment metadata, precedence including the explicit Persistence and Completion Integrity rank, rule counts, tier counts, self-application, and non-restatement records are updated after the Constitution version conflict is reconciled.
- **SC-012**: 0 individual skill files are changed by this governing-document feature.
- **SC-013**: 100% of validation-tooling changes made by Feature 089 are attributable to the new governing rules, identifiers, N/A conditions, counts, precedence, or amendment metadata, and 0 individual skill files are modified.

## Assumptions

- The authoritative amendment targets are `.highway/governance/constitution.md` and `.highway/governance/experience-standard.md`.
- Existing owner skills remain responsible for their domain-specific artifact schemas, write transactions, declared paths, and verification details.
- The existing Experience Standard X2.4 one-unresolved-question contract and X2.8 contextual-acknowledgment contract remain the compatibility baseline.
- The constitutional amendment uses N6 for a reviewed workflow that declares no Retained Output; the Experience Standard uses N7 for Decision Context, N8 for Relevant Example, and N9 for Structured Information without reusing N6.
- The Constitution's Compliance Review Protocol is the sole authoritative registration point for N6-N9; the Experience Standard references those IDs without defining competing entries.
- The new Persistence and Completion Integrity rules remain atomic when decomposed into P12 rules, with N6 mapped only to the Retained Output-dependent verification obligations and orchestration evaluated by its own trigger.
- FR-039 is implemented through the Interactive Workflow UX Contract and does not require a new X rule.
- The next available constitutional and Experience Standard identifiers can be determined from the current governing documents during planning.
- Repository validation tooling and tests may be extended only when required to recognize and validate this amendment's new rules, identifiers, N/A conditions, counts, metadata, and precedence; such changes must not modify individual skill files.
- Before applying the Feature 089 version increment, implementation must reconcile the Constitution footer version with its latest completed Sync Impact Report amendment and calculate the new version from that authoritative result; it must not silently choose between conflicting values.
- Markdown is an illustrative rendering for current repository documents; future interfaces may provide equivalent visual hierarchy through native presentation mechanisms.
- Repository Context behavior established by Feature 088 remains available to this feature, but this feature does not rewrite existing skills.
- A workflow may present only the states relevant to the current interaction; the feature does not require ceremony or redundant status reporting.
- Existing unchanged skills remain grandfathered; new and amended skills inherit the new constitutional and Experience Standard obligations when applicable.

## Out of Scope

- Modifying Profile, Objectives, Controls, NFRs, Setup, or any other individual skill file.
- Changing user-owned governance records or requiring a particular compliance framework, architecture, technology, objective, Control, or NFR.
- Adding a persistence database, indexing service, external integration, or new storage mechanism.
- Replacing owner-specific artifact schemas, transaction semantics, path declarations, or domain verification checks.
- Requiring Decision Context or Relevant Examples when they have no explanatory value.
- Turning examples into defaults, policy, governance requirements, or constraints on user-owned content.
- Requiring Markdown as the only future presentation technology.
- Requiring every answer to receive a Contextual Acknowledgment.
- Duplicating constitutional Persistence Verification rules in the Experience Standard.
- Changing existing X2.1-X2.8 semantics except where the explicit additive informed-collection and structured-presentation amendment requires it.
