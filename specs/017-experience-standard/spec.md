# Feature Specification: Highway Experience Standard

**Feature Branch**: `017-experience-standard`

**Created**: 2026-09-08

**Status**: Draft

**Input**: User description: "I want a Highway Experience Standard at .highway/governance/experience-standard.md that governs what Highway skills produce at runtime and how they interact with the user, so that the content generated across the whole suite is consistent. It uses the X namespace for rule ids so they never collide with the P namespace of the Highway Skills Constitution or the D namespace of the development constitution, and it follows the same format: every rule carries a stable id, exactly one keyword, an Observable, and a Tier tag. It governs output structure, interaction protocol, terminology, artifact placement, provenance of generated content, and determinism of regenerated artifacts. It must not restate any rule from the Highway Skills Constitution; the Highway Skills Constitution outranks it wherever both could apply, and security-affecting rules outrank everything. It must state explicitly as a non-goal that it governs only the form of generated content and states no obligation about the content of a user's own governance artifacts, so that future nfrs and controls skills never judge a user's NFR text against Highway's rules. Start with only the rules I can write a concrete Observable for today. Each existing skill's Outputs section should cite the X rules it satisfies, the same way it cites P rules."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A third skill behaves like the first two without being told (Priority: P1)

Someone writes the next Highway skill. Today the only way to learn that a skill aborts rather than
guesses, or that it confirms before discarding something, is to read `highway-help` and
`highway-inquiry` and infer the pattern. Two skills currently agree on a great deal by
coincidence of authorship rather than by rule.

After this feature there is a document that states those shared behaviours, so the third skill
inherits them by reading rather than by imitation.

**Why this priority**: This is the whole purpose of the layer. Everything else is machinery.

**Independent test**: Read the standard and list the behavioural obligations a new skill must
meet, without consulting either existing skill.

**Acceptance Scenarios**:

1. **Given** the standard, **When** an author reads it, **Then** every rule carries a stable id, exactly one keyword, an Observable, and a tier.
2. **Given** a candidate behaviour with no writable Observable, **When** the standard is drafted, **Then** that behaviour is not admitted as a rule.
3. **Given** the standard, **When** an author looks for precedence, **Then** it states that the Highway Skills Constitution outranks it and that security-affecting rules outrank everything.

---

### User Story 2 - A user's own governance content is never judged by Highway's rules (Priority: P1)

A future `highway-nfrs` skill writes NFRs the user owns. The standard must be unable to be read as
licence to judge the *content* of those NFRs — only the form of what Highway generates.

**Why this priority**: This boundary leaks silently and is expensive to retract once skills have
been built against the wrong reading. Phase 7 depends on it being settled first.

**Independent test**: Read the standard's non-goal statement and confirm it forecloses judging a
user's NFR text.

**Acceptance Scenarios**:

1. **Given** the standard, **When** a reader looks for scope, **Then** a non-goal states it governs only the form of generated content and states no obligation about the content of a user's own governance artifacts.
2. **Given** that statement, **When** a future skill is designed, **Then** it cannot cite the standard as grounds for validating a user's NFR text.

---

### User Story 3 - Each skill declares which experience rules it satisfies (Priority: P2)

A skill's Outputs section already describes what it emits. It should also name the `X` rules that
shape it, the same way skills cite `P` rules, so the link between rule and behaviour is visible
from the skill rather than only from the standard.

**Why this priority**: Valuable but consequential — it edits both shipping skills, which triggers
regeneration and version bumps. Worth doing after the standard's content is settled.

**Independent test**: Open either skill and read which `X` rules it claims.

**Acceptance Scenarios**:

1. **Given** each existing skill, **When** its Outputs section is read, **Then** it cites the `X` rules it satisfies by id.
2. **Given** those edits, **When** the suite runs, **Then** the catalog and all adapters have been regenerated and `D4.7` passes.
3. **Given** a cited rule id, **When** it is looked up, **Then** it exists in the standard.

---

### Edge Cases

- **The interaction sample size is one, not two.** `highway-help` writes no file, asks the user nothing, and confirms nothing. Every candidate rule about interaction, confirmation, or artifact placement therefore generalises from `highway-inquiry` alone. The Gate required a second skill and got one, but it did not make every rule family two-sampled.
- **The two skills deliberately disagree about error messages.** `highway-help` prints an exact error string; `highway-inquiry` repairs framework-owned parts silently and states why — *"Loud about their content, quiet about the framework's."* A rule that mandates either behaviour universally would make one of them wrong. The disagreement is itself the material for a rule about *who the message is for*.
- **A rule with no Observable.** `highway-help` declares its listing cost as `O(n)`. Only one skill says anything about cost, and no check can observe it. It is a candidate, not a rule.
- **Editing both skills triggers the Correspondence Gate.** Adding citations changes a generator's input, so `D4.7` requires regeneration of the catalog and all three adapters per skill.
- **Version bumps.** Editing a shipping skill's content requires a version increment classified per the Skill Versioning Policy, and `P7.7` governs the MAJOR case.
- **Section length.** `P7.5` caps a normative section at 400 words. Verified 2026-09-08 that adding a citation line to `highway-inquiry`'s Outputs still validates, so the requirement is feasible.
- **A standard so thin it says nothing.** Starting thin is correct, but a document with two rules would not have justified a layer. The honest test is whether a third skill author would be meaningfully constrained by it.

## Requirements *(mandatory)*

### Functional Requirements

#### The document

- **FR-001**: A Highway Experience Standard MUST exist at `.highway/governance/experience-standard.md`.
- **FR-002**: Every rule MUST carry a stable id in the `X` namespace, exactly one keyword, an Observable, and a Tier tag, matching the format of the two existing constitutions.
- **FR-003**: `X` ids MUST NOT collide with the `P` or `D` namespaces, and a retired id MUST NOT be reused.
- **FR-004**: The standard MUST state that the Highway Skills Constitution outranks it wherever both could apply, and that security-affecting rules outrank everything.
- **FR-005**: The standard MUST NOT restate rule text defined in the Highway Skills Constitution; where the same discipline is wanted it cites the rule id, per `D1.4`.
- **FR-006**: The standard MUST state as an explicit non-goal that it governs only the form of generated content and states no obligation about the content of a user's own governance artifacts.
- **FR-007**: The standard MUST ship. It is Layer 2 and lives inside `.highway/`, so it MUST reference no development-only path, per `D1.1`.

#### What it governs

- **FR-008**: The standard MUST cover output structure, interaction protocol, terminology, artifact placement, provenance of generated content, and determinism of regenerated artifacts — admitting rules only where an Observable can be written today.
- **FR-009**: Every admitted rule MUST be traceable to behaviour already exhibited by at least one existing skill, rather than invented for the document.
- **FR-010**: Where a rule generalises from only one skill, the standard MUST record that, so a later reader knows which rules rest on a single example.
- **FR-011**: A candidate behaviour with no writable Observable MUST be recorded as a candidate rather than admitted as a rule.
- **FR-012**: The standard MUST NOT mandate a single error-reporting style that would make either existing skill wrong. The two differ deliberately, and the rule must be about who the message serves.

#### Tiers and enforcement

- **FR-013**: Each rule MUST be tagged `[auto]`, `[agent-checkable]`, or `[human-review]`, using the tier meanings already defined rather than inventing a fourth.
- **FR-014**: A rule MUST NOT be tagged `[auto]` unless something decides it. Enforcement machinery is Phase 6's work, so rules that will become `[auto]` later MUST be tagged honestly now.
- **FR-015**: The standard MUST state what each tier obliges *in this document*, because `[auto]` already means different things in the two existing constitutions.

#### Citations from skills

- **FR-016**: Each existing skill's Outputs section MUST cite the `X` rules it satisfies, by id, restating no rule text.
- **FR-017**: Every cited id MUST exist in the standard, and no skill may cite a rule it does not satisfy.
- **FR-018**: Both skills MUST be regenerated after editing, so the catalog and all adapters stay current per `D4.7`.
- **FR-019**: Each edited skill MUST carry a version increment classified against the Skill Versioning Policy.

### Key Entities

- **Experience Standard**: the Layer 2 governing document. Ships. Constrains what skills emit and how they interact.
- **X rule**: id, rule text, Observable, tier. The unit of obligation.
- **Skill Outputs section**: where a skill declares what it emits and, after this feature, which `X` rules shape that.
- **Candidate rule**: a behaviour worth governing for which no Observable can be written yet. Recorded, not admitted.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: An author can determine what a new skill must emit and how it must interact by reading one document, without inferring from existing skills.
- **SC-002**: Every rule in the standard has an Observable that a reader could apply by hand today.
- **SC-003**: No rule in the standard restates rule text from either constitution.
- **SC-004**: Both existing skills satisfy every rule in the standard, or a deliberate exception is recorded with its reason.
- **SC-005**: Every rule that rests on a single example is marked as such.
- **SC-006**: The non-goal forecloses judging a user's own governance content, and a reader tasked with building `highway-nfrs` reaches that conclusion unprompted.
- **SC-007**: The suite passes, the catalog and adapters are current, and both skills validate.

## Assumptions

- **The standard is authored before the tooling that enforces it.** Phase 6 adds enforcement; this phase writes the document. Tiers are therefore mostly `[agent-checkable]` at first, and that is honest rather than a shortfall.
- **Two skills is the sample.** For output structure and determinism both contribute. For interaction, confirmation, and artifact placement the effective sample is `highway-inquiry` alone.
- **The existing eight-section skill shape is stable.** Both skills use the same section order, so Outputs is a reliable place to put citations.
- **Adding citations is a MINOR change to each skill** unless a rule changes a skill's contract, in which case `P7.7` applies.
- **The `X` namespace is unused today.** Verified 2026-09-08: `.highway/governance/` contains only `constitution.md`.

## Dependencies

- The Gate is cleared: `highway-inquiry` exists and exercises interaction, file writing, and derived content.
- Feature 016's `D4.7`, which makes regeneration after these edits an enforced obligation rather than a remembered one.
- The tier vocabulary and Enforcement Map precedent from features 013 and 014.

## Out of Scope

- **Enforcing the standard.** Phase 6 registers `X` rules in the rule-check library and extends the inventory test. This phase writes no checker.
- **Building `highway-nfrs` or `highway-controls`.** Phase 7.
- **Changing what either skill does.** Only their Outputs sections gain citations; no behaviour changes.
- **A Highway glossary.** A terminology rule needs a term list to check against; if none can be written today, the rule is a candidate rather than a rule.
