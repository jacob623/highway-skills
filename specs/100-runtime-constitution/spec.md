# Feature Specification: Revise the Runtime Skills Constitution

**Feature Branch**: `100-runtime-constitution`

**Created**: 2026-09-29

**Status**: Draft

**Input**: User description: "Amend the Highway Skills Constitution so it governs shipped skills at runtime. Remove development-only obligations, replace per-step error and persistence rules with a common failure model and an owner/orchestrator contract, and keep runtime safety, ownership, determinism, and experience compliance."

## Background

The Skills Constitution is the runtime governance for shipped Highway skills. Today it also carries development validation: source-code testing, linting, comment and complexity gates, a compliance review procedure, an authoring workflow, and a merge decision. Shipped skills are expected to satisfy those obligations, which makes them restate governance they do not execute and ties them to development material they do not consume at runtime.

This feature revises that constitution so a shipped skill is governed by runtime correctness, safety, portability, ownership, context, and contracts. User-visible interaction stays with the Experience Standard. Highway Identity, Vision, and Platform Objectives stay the sources of Highway behavior and direction. Shared templates stay the source of reusable artifact structure. Each skill stays the source of its own domain workflow. Development governance stays the source of authoring, testing, compliance review, feature verification, and release.

The current Skills Constitution is version 3.0.1. Removing and redefining principles is a major amendment under its own versioning policy.

## Clarifications

### Session 2026-09-29

- Q: Which artifacts should this amendment change? → A: The Skills Constitution only. Shipped skill text and development governance stay unchanged for a later change.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A shipped skill depends only on runtime governance (Priority: P1)

As a person using a shipped Highway skill, I want that skill governed only by rules it can follow while it runs, so that development constitutions, feature specifications, test inventories, fixtures, validation scripts, merge procedures, and authoring procedures are not part of using the skill.

**Why this priority**: The boundary between runtime governance and development governance is the change that makes every later reduction possible. Without it, skills keep carrying development obligations.

**Independent Test**: Read the amended Skills Constitution and confirm it states that it is runtime governance, that development material is not a runtime skill dependency, and that the named development procedures are absent from it. A shipped skill is not required to reference or include the development constitution.

**Acceptance Scenarios**:

1. **Given** the amended Skills Constitution, **When** a reader looks for what a shipped skill must consume, **Then** the constitution identifies itself as runtime governance and states that development constitutions, feature specifications, tests, fixtures, merge procedures, compliance tooling, and development-only scripts are not runtime skill dependencies.
2. **Given** the amended Skills Constitution, **When** a reader looks for the compliance review procedure, the skill authoring workflow, and the merge decision, **Then** those procedures are absent, and development governance is named as the place that validates a skill before release.
3. **Given** a shipped skill, **When** it is used at runtime, **Then** it is not required to reference or include the development constitution, a feature specification, a compliance test inventory, a test fixture, a development-only validation script, a merge procedure, or an authoring procedure.

---

### User Story 2 - Failure and completion follow one shared model (Priority: P1)

As a person following a Highway skill, I want ordinary failures and completion handled the same way in every skill, so that a skill stops safely, does not claim a failed change succeeded, and does not make me read a per-step error table to learn that.

**Why this priority**: The current per-step failure rules and post-write completion checks are the largest runtime burden on every skill. Replacing them is independently useful even before the citation and context rules are simplified.

**Independent Test**: Read the amended failure obligations and Principle XII. The six common failure situations are stated once. P5.1 through P5.5, P12.1 through P12.4, Persistence Verification, Verified Completion Claim, and N6 are gone. A failed change still cannot be reported as success. An orchestrator advances only from the owning skill's declared result.

**Acceptance Scenarios**:

1. **Given** missing or contradictory required input, **When** a skill is followed, **Then** the missing information is obtained before the skill continues.
2. **Given** malformed or unsafe authoritative state, **When** a skill is followed, **Then** the skill stops without changing that state and identifies the problem.
3. **Given** the user declines or exits, **When** a skill is followed, **Then** the skill stops without an unintended change.
4. **Given** a dependent owning skill returns a non-success result, **When** the calling skill continues, **Then** it preserves and consumes that result.
5. **Given** a change fails, **When** the skill reports the outcome, **Then** it does not claim success.
6. **Given** an unexpected failure, **When** a skill is followed, **Then** it stops safely and provides actionable user-facing context.
7. **Given** a skill whose failure handling matches this common model, **When** the skill is authored, **Then** it documents only the domain-specific failure handling that differs from the model, and it is not required to keep an error-handling table organized by workflow step.
8. **Given** an owning skill and an orchestrating skill, **When** the orchestrator needs the owner to continue, **Then** the owner determines its own readiness and domain state, supplies its next supported action when interaction is required, and the orchestrator delegates that action, consumes the owner's result, advances only from the owner's declared terminal result, and does not inspect or reconstruct the owner's internal state.

---

### User Story 3 - A skill cites shared governance instead of repeating it (Priority: P2)

As a skill author, I want the Skills Constitution to require a cross-reference where another authority already owns the rule, so that a skill states its domain workflow and does not repeat the constitution, the Experience Standard, a shared template, or another skill.

**Why this priority**: This is what makes a later skill shorter. It depends on the runtime boundary in User Story 1, because the authorities being cited have to stay the owners of their own text.

**Independent Test**: Compare the amended citation, quality, determinism, verification, template, experience, and repository-context obligations with the list in this story. External citations are required only for external assertions. Highway-owned workflow rules stand on Highway runtime governance and shared contracts. Advisory wording is not required to be identical on every run.

**Acceptance Scenarios**:

1. **Given** a skill rule that states Highway-owned workflow, ownership, artifact, or routing, **When** the rule is checked for authority, **Then** Highway runtime governance and the applicable shared contract are sufficient, and an external citation is not required.
2. **Given** a skill rule that asserts an external technical, security, regulatory, protocol, or standards requirement, **When** the rule is checked for authority, **Then** it cites the specific external source, section, control, or identifier.
3. **Given** the authority-source list, **When** a future framework or industry source is added, **Then** it can be cited with explicit provenance, and unrelated skill rules are still not required to cite an external standard.
4. **Given** a skill that does not itself test, lint, comment, or measure source code, **When** the skill is checked, **Then** it is not required to carry source-code testing, linting, comment, complexity, or development-validation instructions.
5. **Given** a skill that performs a security-affecting action, **When** the skill is checked, **Then** it still carries the runtime security obligations that apply to that action, including not disabling verification, not hardcoding credentials, not bypassing input validation, and reporting a suspected vulnerability rather than changing it silently.
6. **Given** a routing, ownership, classification, identifier, or other state-changing decision, **When** the skill is followed twice with the same inputs, **Then** it selects the same action both times.
7. **Given** a natural-language recommendation whose skill contract does not demand fixed wording, **When** the recommendation is given twice from the same accepted context, **Then** the skill is not required to use byte-for-byte identical phrasing, and it is not required to carry a decision table for that advisory language.
8. **Given** a skill that emits a file from a shared output template, **When** the skill declares that output, **Then** it names the template, the output location, and the domain-specific meaning the template does not own, and it does not repeat the template's structure or generic invariants.
9. **Given** user-visible questions, recommendations, confirmations, examples, transitions, progress, or other conversational behavior, **When** a skill is authored, **Then** the skill references the Experience Standard and keeps only the domain-specific interaction meaning that the skill owns.
10. **Given** repository context, **When** a skill can be influenced by it, **Then** the skill declares the context sources that can influence it, uses available relevant accepted context before context-dependent behavior, lets active workflow and user evidence override conflicting repository context for that interaction, and does not invent or silently substitute missing context.
11. **Given** an optional context source whose absence does not change the observable result, **When** the skill runs, **Then** the skill is not required to record that absence.

---

### User Story 4 - The amendment is complete and major (Priority: P2)

As a maintainer of Highway governance, I want this constitution change recorded as one major amendment whose internal counts, ranks, definitions, and cross-references agree with the rules that remain, so that a retired rule cannot still be cited from inside the constitution.

**Why this priority**: A partial edit would leave skills governed by contradictory obligations. The amendment is only safe once the document agrees with itself.

**Independent Test**: The version has advanced by a major increment from 3.0.1. The amendment record lists every removed, redefined, and retained obligation that changed. A search of the Skills Constitution finds no remaining obligation for a retired rule identifier, and no retired identifier is reused for a new rule.

**Acceptance Scenarios**:

1. **Given** the current version 3.0.1, **When** the amendment is adopted, **Then** the version advances by a major increment and the amendment record states why the change is major.
2. **Given** the amended constitution, **When** rule counts, tier counts, principle precedence, definitions, and N/A conditions are read, **Then** each one describes only the obligations that remain.
3. **Given** a retired rule identifier, **When** the Skills Constitution is searched, **Then** that identifier is not used as a current obligation and is not assigned to a replacement rule.
4. **Given** the obligations this feature keeps, **When** the amended constitution is read, **Then** those obligations are still present: a clear purpose, explicit runtime dependencies, explicit outputs, technology portability, semantic versioning, breaking-change classification, shared output templates, artifact ownership, safe destructive operations, deterministic state-changing decisions, stable identifier and relationship meaning where a domain contract requires it, no fabricated context, authority of active user and workflow evidence, owner boundaries, a ban on reporting a failed change as success, and Experience Standard compliance.
5. **Given** this amendment, **When** the changed artifacts are listed, **Then** the Skills Constitution is the only artifact changed. Shipped skill text and development governance are unchanged.
6. **Given** user-owned Objectives, Controls, Non-Functional Requirements, architectures, decisions, implementations, and organizational Profile, **When** a skill classifies, recommends, normalizes, or proposes, **Then** the proposal is not authoritative until the applicable user-acceptance boundary is satisfied, and the skill does not invent organizational facts or silently promote inferred or discovered information into that user-owned content.

---

### Edge Cases

- A skill that changes retained state and then fails the change reports the failure and does not claim success. It is not required to run a post-write existence or byte check before that report.
- A skill that performs no security-affecting action carries no security-gate obligations. A skill that does perform one carries only the obligations for the action it performs.
- A skill that asserts no external requirement carries no external authority citation. A skill that asserts one cites the specific source.
- A workflow whose order does not affect behavior, ownership, safety, change, or output does not have to number every step or declare an ordering dependency. A workflow whose order does affect one of those declares that order.
- Verification still exists and states a checkable outcome. A command is not required for an ordinary artifact workflow.
- Two or more triggering scenarios remain required for a skill, because that obligation is about when the skill applies, not about how a step fails.
- Automatic retry is not a runtime requirement. A skill that chooses to retry states that behavior as domain-specific failure handling.
- An optional context source that is missing and does not change the result is left unrecorded. A missing context source that would change the result is not invented or replaced.
- An orchestrator whose owner returns non-success does not reconstruct the owner's files or fields to decide what happened. It consumes the owner's declared result.
- An example or definition inside the constitution that teaches a removed obligation is removed or rewritten so it agrees with the remaining rules.
- A replacement obligation receives a new identifier. P12.5 keeps its identifier because it is retained and redefined, not retired.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Skills Constitution MUST identify itself as runtime governance for shipped Highway skills.
- **FR-002**: The Skills Constitution MUST state that development constitutions, feature specifications, tests, fixtures, merge procedures, compliance tooling, and development-only scripts are not runtime skill dependencies, and that development governance may validate a skill before release without being consumed by the skill at runtime.
- **FR-003**: A shipped skill MUST NOT be required to reference or include the development constitution, a feature specification, a compliance test inventory, a test fixture, a development-only validation script, a merge procedure, or an authoring procedure.
- **FR-004**: The universal requirement that every absolute skill rule cite an approved external authority source (P3.1) MUST be removed. An external citation MUST be required only when a skill asserts an external technical, security, regulatory, protocol, or standards requirement, and that citation MUST name the specific source and its section, control, or identifier.
- **FR-005**: Highway-owned workflow, ownership, artifact, and routing contracts MUST be governable by Highway runtime governance and shared contracts without an external citation.
- **FR-006**: The approved-authority model MUST allow a future framework or industry source to be cited with explicit provenance without requiring unrelated skill rules to cite an external standard.
- **FR-007**: The Code Generation, Testing, Maintainability, and Performance gates MUST be removed from the runtime Skills Constitution. The constitution MUST classify those checks as development concerns.
- **FR-008**: The Skills Constitution MUST NOT require a skill to carry source-code testing, linting, comment, complexity, or development-validation instructions unless the executing skill itself performs that operation.
- **FR-009**: Runtime security obligations MUST remain only for a security-affecting action the skill actually performs. Those obligations MUST include not disabling verification, not hardcoding credentials, not bypassing input validation, and reporting a suspected vulnerability rather than altering it silently. An external security citation MUST be required only when the skill asserts an external security requirement.
- **FR-010**: P5.1, P5.2, P5.3, P5.4, and P5.5 MUST be removed. The constitution MUST NOT require an error-handling table organized by workflow step, a failure token limited to retry, abort, escalate, or fall back, a retry attempt count, a fallback identifier, or a mapping from every numbered step to an error-handling entry.
- **FR-011**: The Skills Constitution MUST state one common failure model covering exactly these situations: missing or contradictory required input is obtained before continuing; malformed or unsafe authoritative state stops the skill without mutation and identifies the problem; user decline or exit stops the skill without unintended mutation; a dependent owner's non-success result is preserved and consumed; a failed mutation is not claimed as success; an unexpected failure stops the skill safely and provides actionable user-facing context.
- **FR-012**: A skill MUST be required to document failure handling only where its domain behavior differs from the common failure model.
- **FR-013**: P5.6 MUST remain, so a skill still applies to two or more triggering scenarios.
- **FR-014**: Deterministic decision requirements MUST remain for routing, ownership, classifications, identifiers, destructive operations, and other state-changing decisions.
- **FR-015**: Natural-language recommendations and conversational wording MUST NOT be required to use byte-for-byte identical phrasing unless the skill contract explicitly requires that wording. Advisory language whose domain constraints and accepted context already bound the recommendation MUST NOT require a decision table.
- **FR-016**: Purpose, semantic versioning, breaking-change versioning, and the existing skill-size protections MUST remain. The non-duplication obligation (P7.3) MUST expand so a skill does not restate a requirement owned by the Skills Constitution, the Experience Standard, a shared contract, or another owning skill, and MUST require a cross-reference instead of duplicated governance prose.
- **FR-017**: The requirement that every workflow step be numbered (P8.1) MUST be removed. Ordering MUST be declared only when order affects behavior, ownership, safety, mutation, or output.
- **FR-018**: A Verification section MUST remain. Verification MUST require a checkable outcome. It MUST NOT require a command for an ordinary artifact workflow, and it MUST NOT imply that a shell command is required for such a workflow.
- **FR-019**: A skill MUST still declare configuration and defaults where they materially affect runtime behavior.
- **FR-020**: The shared-output obligation (P9.1) MUST remain. A skill that uses a shared output template MUST declare the template, the output location, and the domain-specific meaning the template does not own, and MUST NOT repeat the template's structure or generic invariants.
- **FR-021**: Experience compliance MUST remain the bridge to the Experience Standard. The constitution MUST state that user-visible interaction, presentation, questions, recommendations, confirmations, examples, transitions, progress, and conversational behavior belong to the Experience Standard. A skill MUST reference that standard rather than restate its generic interaction rules, and MUST keep domain-specific interaction meaning in the owning skill.
- **FR-022**: Repository-context obligations P11.1 through P11.5 MUST be replaced by four runtime obligations: the skill declares the context sources that can influence its behavior; the skill uses available relevant accepted context before context-dependent behavior; active workflow and user evidence overrides conflicting repository context for the active interaction; missing or unavailable context is not invented or silently substituted.
- **FR-023**: A skill MUST NOT be required to record an unavailable optional context source unless that absence changes an observable result, and MUST NOT be required to carry a generic absent-context verification. Profile MUST remain user-owned organizational repository context. Highway Identity, Vision, Platform Objectives, and Profile MUST keep their roles without each skill restating those roles.
- **FR-024**: P12.1, P12.2, P12.3, P12.4, Persistence Verification, Verified Completion Claim, and N6 MUST be removed. The constitution MUST NOT require a post-write shell check, byte verification, file-existence verification, or any equivalent persistence verification before completion.
- **FR-025**: A failed mutation MUST still be prohibited from being reported as successful.
- **FR-026**: P12.5 MUST be retained, and Principle XII MUST be redefined around owner-controlled completion and orchestration: the owner determines its readiness and domain state; the owner supplies its next supported action when interaction is required; the orchestrator delegates that action; the orchestrator consumes the owner's result; the orchestrator advances only from the owner's declared terminal result; the orchestrator does not inspect or reconstruct owner-internal state.
- **FR-027**: The Compliance Review Protocol, the Skill Authoring Workflow, merge-decision procedures, development test requirements, and feature-specific compliance requirements MUST be removed from the runtime Skills Constitution where they exist only for development validation. The constitution MUST classify those concerns as development governance.
- **FR-028**: The amendment MUST preserve the rule that Highway does not invent organizational facts or silently promote inferred or discovered information into user-owned authoritative content. User ownership of Objectives, Controls, Non-Functional Requirements, architectures, decisions, implementations, and organizational Profile MUST remain. A skill MAY classify, recommend, normalize, and propose, and such a proposal MUST NOT become authoritative until the applicable user-acceptance boundary is satisfied.
- **FR-029**: The amendment MUST keep the runtime obligations for a clear skill purpose, explicit runtime dependencies, explicit outputs, technology portability, semantic versioning, breaking-change classification, shared output templates, artifact ownership, safe destructive operations, deterministic state-changing decisions, stable identifier and relationship meaning where a domain contract requires it, no fabricated context, authority of active user and workflow evidence, owner boundaries, the ban on reporting a failed mutation as success, and Experience Standard compliance.
- **FR-030**: The amendment MUST be a major version change from 3.0.1. Its amendment record MUST name the version change and every removed, redefined, or newly stated obligation, including updated rule counts, tier counts, principle precedence, definitions, and N/A conditions.
- **FR-031**: The Skills Constitution MUST contain no current obligation that cites a retired rule identifier, and a retired identifier MUST NOT be reused for a replacement rule. Examples, definitions, and precedence reasons that describe a removed obligation MUST be removed or rewritten so they agree with the remaining rules.
- **FR-032**: This amendment MUST NOT add a runtime rule whose only purpose is to preserve a historical test or a development implementation detail.
- **FR-033**: This amendment MUST change the Skills Constitution only. It MUST leave shipped skill text unchanged and MUST leave development governance unchanged.

### Key Entities

- **Skills Constitution**: Runtime governance for a shipped Highway skill. It states obligations the skill follows while it runs. It does not contain development validation, authoring procedure, or merge procedure.
- **Common failure model**: The single set of six failure situations every skill follows unless the skill documents a domain-specific difference.
- **Owner**: The skill that determines its own readiness, domain state, and next supported action.
- **Orchestrator**: The skill that delegates an owner-provided action and advances only from the owner's declared terminal result.
- **External authority**: A technical, security, regulatory, protocol, or standards source cited only when a skill asserts a requirement from that source.
- **Shared authority**: The Skills Constitution, the Experience Standard, a shared template or contract, or another owning skill. A skill cross-references shared authority instead of restating it.
- **Retired rule**: An obligation removed by this amendment. Its identifier stays unused.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the named removed obligations are absent from the Skills Constitution: P3.1 as a universal citation requirement, the four development quality gates, P5.1 through P5.5, P8.1, P12.1 through P12.4, Persistence Verification, Verified Completion Claim, N6, the Compliance Review Protocol, the Skill Authoring Workflow, and the merge decision.
- **SC-002**: The common failure model states all 6 situations, and a skill that does not differ from it has 0 required per-step error-handling entries.
- **SC-003**: 100% of the kept obligation categories in FR-029 are still present after the amendment.
- **SC-004**: The constitution version advances by one major increment from 3.0.1, and the amendment record accounts for every removed, redefined, and newly stated obligation.
- **SC-005**: A search of the Skills Constitution finds 0 remaining uses of a retired rule identifier as a current obligation, and 0 retired identifiers reused for a new rule.
- **SC-006**: A shipped skill has 0 required references to the development constitution, feature specifications, compliance test inventories, test fixtures, development-only validation scripts, merge procedures, or authoring procedures.
- **SC-007**: An external authority citation is required for 100% of skill rules that assert an external requirement, and for 0% of skill rules that only state Highway-owned workflow, ownership, artifact, or routing.
- **SC-008**: This amendment changes 1 governance artifact, the Skills Constitution, and 0 shipped skill files and 0 development-governance documents.

## Assumptions

- Shipped skills become free of the removed obligations when they are next changed under the amended constitution. That later reduction is a separate change.
- Development tooling and the development constitution are updated separately. This feature classifies the removed gates, review procedure, authoring workflow, and merge decision as development concerns inside the Skills Constitution. It does not copy those obligations into development governance.
- P5.6 stays because it governs when a skill applies. The common failure model does not replace it.
- Automatic retry does not remain a runtime requirement. P5.3 is removed with the other per-step failure rules. A skill that retries documents that behavior as a domain-specific difference.
- P8.5 and P8.6 stay, limited to configuration and defaults that materially affect runtime behavior.
- Existing skill-size limits stay. A later review may remove them. This feature does not.
- P1.7 is aligned with the common failure model where it currently requires escalation for absent or contradictory input, so the constitution does not state two different responses to the same situation.
- Security-gate review keeps the runtime prohibitions on disabling verification, hardcoding credentials, and bypassing input validation, plus the duty to report a suspected vulnerability, and only when the skill performs the relevant action.
- User ownership and the ban on inventing organizational facts already govern Highway skills. This amendment preserves that meaning. It does not add a second ownership system.
- Retired identifiers follow the constitution's existing rule that an identifier is not reused. New failure-model obligations and any new owner or orchestrator obligations receive new identifiers. P12.5 keeps its identifier because it is redefined in place.
- The major version that follows 3.0.1 is 4.0.0.
