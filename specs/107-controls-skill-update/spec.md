# Feature Specification: Controls Skill Update

**Feature Branch**: `107-controls-skill-update`

**Created**: 2026-09-30

**Status**: Draft

**Input**: User description: "Rewrite highway-controls around Control-specific semantics, persistence, readiness, recommendation grounding, and the Control-to-NFR ownership boundary. Simplify the interaction contract, remove duplicated governance and development material, add external benchmark grounding, make discovery evidence-first, preserve Control/NFR classification and persistence safeguards, define recommendation and continuation behavior, and simplify verification and error handling."

## Clarifications

### Session 2026-09-30

- Q: Should the Controls collection result remove `Created Control IDs` and require corresponding Setup contract updates? → A: Remove the field and update Setup to rely only on collection status and fresh readiness.
- Q: Should this MAJOR contract change bump the `highway-controls` skill metadata version from `3.0.0` to `4.0.0`? → A: Set `highway-controls` metadata to `4.0.0`; preserve unrelated template versions.
- Q: Where should recommendation grounding and provenance be retained so future traceability can identify why a safeguard was recommended? → A: Add an optional provenance section to the Control record body; do not put provenance in frontmatter.

## User Scenarios & Testing

### User Story 1 - Evidence-first Control discovery (Priority: P1)

As a person establishing governance, I want to describe a safeguard in ordinary language and be asked only for missing information, so that Highway can capture a valid Control without forcing a fixed Concern, Condition, and Obligation questionnaire.

**Why this priority**: Evidence-first discovery is the primary user-facing behavior and prevents the skill from collecting formal phrasing that the person has already communicated.

**Independent Test**: Provide complete, partial, and mixed Control evidence to `setup`, `configure`, and `add`; verify that the workflow evaluates all supplied evidence, asks at most one necessary question, and proceeds to capture when a Control can be constructed without inventing policy.

**Acceptance Scenarios**:

1. **Given** the person supplies an enforceable, auditable, or checkable safeguard, **When** Controls evaluates the response, **Then** it proceeds to capture or review without requiring separate Concern, Condition, and Obligation answers.
2. **Given** the person supplies incomplete evidence, **When** Controls evaluates it, **Then** it asks for missing information rather than missing formal phrasing.
3. **Given** the person supplies an outcome, quality, or operational desire, **When** the intent remains NFR-shaped, **Then** Controls routes it to the NFR owner rather than persisting it as a Control.
4. **Given** the person provides wording that Highway can faithfully normalize, **When** Controls prepares a Control, **Then** it preserves the user's meaning without requiring formal Control language.
5. **Given** classification remains unresolved after evaluating the evidence, **When** Controls needs to distinguish Control from NFR, **Then** it asks one bounded classification question and preserves the user's ability to retain their own Control wording.

### User Story 2 - Grounded recommendations and acceptance (Priority: P1)

As a person establishing Controls, I want relevant safeguards suggested from accepted context and declared expertise, so that I receive useful guidance without Highway inventing organizational policy or implying external applicability.

**Why this priority**: Recommendations reduce effort while the grounding boundary protects user ownership and prevents unsupported compliance claims.

**Independent Test**: Run `setup` and `configure` with relevant Profile, Business Objective, existing Control, and declared external benchmark context, then verify recommendation grounding, bounded presentation, direct selection, and the user-authored alternative.

**Acceptance Scenarios**:

1. **Given** useful grounded recommendations exist, **When** `setup` or `configure` begins, **Then** Controls presents a small relevant set before asking the broad Control question.
2. **Given** no useful grounded recommendation exists and no usable Control evidence was supplied, **When** discovery begins, **Then** Controls asks **What concerns should future technology decisions take into account?** with concise recognizable safeguard examples.
3. **Given** a recommendation is grounded in an external security, industry, regulatory, or governance source, **When** it is shown, **Then** the source is treated as recommendation grounding and not as user-owned policy, applicability, certification, or compliance.
4. **Given** the person selects one, several, or all displayed recommendations, **When** selection is accepted, **Then** Controls captures the selected Controls directly without another proposal-confirmation cycle.
5. **Given** a selected recommendation lacks information needed for a valid retained Control, **When** creation continues, **Then** Controls asks only for that missing information.
6. **Given** recommendations are shown, **When** the person does not select one, **Then** a user-authored alternative remains available.

### User Story 3 - Review, continuation, and ownership boundaries (Priority: P1)

As a person reviewing and establishing multiple Controls, I want materially interpreted user-authored Controls presented clearly and collection to continue until I explicitly finish, so that I retain ownership while building a usable governance baseline.

**Why this priority**: Review and continuation define the acceptance boundary and prevent readiness from being mistaken for conversation completion.

**Independent Test**: Exercise user-authored review, recommendation selection, continuation after one successful Control, explicit finish, direct `add`, and interruption; verify the exact user-facing wording and that transient evidence is not persisted.

**Acceptance Scenarios**:

1. **Given** Highway materially interprets, classifies, normalizes, or synthesizes user-authored input, **When** it presents the Control, **Then** it uses:

   **Here's what I've captured as your Control:**

   **Title:**  
   [Title]

   **Statement:**  
   [Statement]

   **Why it matters:**  
   [Rationale]

   **Would you like to accept this Control?**

   The acceptance request is the only response-demanding element at the bottom.
2. **Given** the person explicitly selects a displayed recommendation, **When** the recommendation is captured, **Then** the captured-Control review is not shown redundantly.
3. **Given** a Control is captured during `setup` or `configure`, **When** collection continues, **Then** Controls asks exactly:

   **Are there any other concerns or safeguards you'd like to establish?**

   If you'd like additional suggestions or help working through them, just let me know.
4. **Given** the person supplies another safeguard after the continuation prompt, **When** Controls receives it, **Then** it processes that evidence immediately.
5. **Given** the person explicitly finishes collection, **When** the active collection ends, **Then** Controls stops even if readiness is Complete.
6. **Given** the person uses direct `add`, **When** one Control is created or the action ends, **Then** the operation remains single-Control and does not open the continuation cycle.
7. **Given** the person abandons, cancels, rejects, or interrupts before acceptance, **When** the interaction ends, **Then** no transient discovery evidence, proposal, or partial Control is persisted.

### User Story 4 - Durable Control baseline and readiness (Priority: P1)

As an organization maintaining governance, I want accepted Controls to retain existing records, catalogs, identifiers, readiness, duplicate handling, and mutation safeguards, so that the simplified interaction does not weaken durable governance.

**Why this priority**: The skill update changes the interaction contract but must preserve the authoritative Control baseline and safe mutation behavior.

**Independent Test**: Exercise valid, missing, malformed, duplicate, overlapping, destructive, and failed-mutation states; verify retained record/catalog structure, readiness, identifier rules, deterministic output, and atomic persistence.

**Acceptance Scenarios**:

1. **Given** no valid Control exists, **When** readiness is requested, **Then** the result is Missing.
2. **Given** at least one valid Control exists with a consistent baseline, **When** readiness is requested, **Then** the result is Complete, independently of active collection completion.
3. **Given** the Control record, catalog, or allocation state is malformed or inconsistent, **When** a Control action evaluates readiness or mutation, **Then** the result is Blocked without mutation.
4. **Given** an exact duplicate or decision-affecting overlap is found before persistence, **When** Controls revalidates the authoritative baseline, **Then** it identifies the existing Control and requires the applicable user decision without silently creating a duplicate.
5. **Given** a destructive Remove or Set action is requested, **When** impact is determined, **Then** the Experience Standard's destructive-confirmation behavior applies.
6. **Given** an accepted mutation fails, **When** Controls reports the result, **Then** it does not claim success and preserves the existing common failure model.

### User Story 5 - Control-derived NFR handoff (Priority: P2)

As a downstream NFR workflow owner, I want Controls to invoke the declared candidate-generation boundary after a new Control is successfully created, so that Controls owns the handoff without duplicating NFR candidate state or review behavior.

**Why this priority**: The handoff preserves the ownership boundary while ensuring newly created Controls remain useful to downstream NFR work.

**Independent Test**: Create a new Control successfully, exercise candidate-generation success, zero-candidate, and Blocked results, and verify that Controls consumes only the declared result while NFRs owns candidate state, classification, review, identifiers, readiness, and completion.

**Acceptance Scenarios**:

1. **Given** a new Control is successfully created, **When** the mutation completes, **Then** Controls invokes NFR-owned candidate generation once.
2. **Given** candidate generation is Blocked, **When** Controls consumes the result, **Then** the successfully created Control remains valid, no partial NFR relationship is created, and the downstream result is preserved.
3. **Given** collection is still active, **When** a new Control is created, **Then** NFR candidate review remains deferred until Controls collection is explicitly finished if that is the NFR owner's declared contract.
4. **Given** Controls invokes candidate generation, **When** the result is returned, **Then** Controls does not describe or own candidate internals, counts, classification, review, NFR identifiers, readiness, or NFR persistence.

### Edge Cases

- Concern, Condition, and Obligation evidence is uneven, combined, or absent; Controls evaluates what is present and does not require every category.
- The person asks for suggestions, asks for help, or says they do not know; the Experience Standard governs the interaction while Controls supplies only grounded recommendations.
- Profile is accepted, unavailable, malformed, or Profile-owned Blocked; Profile-dependent actions preserve the owner's Blocked result, while optional unavailable context does not become invented evidence.
- Business Objectives or existing Controls are absent or irrelevant; Controls uses remaining valid grounding and does not fabricate context.
- An external framework informs a recommendation but its applicability, certification, or compliance status is not established.
- A recommendation is selected but cannot yet produce a valid Control record; only the missing Control information is requested.
- A user-authored Control has a concise rationale available from accepted evidence; Controls synthesizes it and does not ask a separate rationale question.
- A selected recommendation is accepted without redundant confirmation; materially interpreted user-authored input receives the captured-Control review.
- Readiness becomes Complete after the first Control while setup/configure collection remains active; Controls continues until explicit finish.
- A new Control is created and NFR candidate generation returns Blocked or no candidates; Controls consumes the declared result without duplicating NFR ownership.
- A direct `add` request must not enter multi-Control continuation.
- An unresolved update/remove target, malformed baseline, unsafe allocation state, or destructive mutation follows its Control-specific exception without mutation.

## Requirements

### Functional Requirements

- **FR-001**: The Controls skill MUST be rewritten around Control-specific semantics, persistence, readiness, recommendation grounding, and the Control-to-NFR ownership boundary.
- **FR-002**: The `### Experience` section MUST contain exactly `User-visible interaction follows the Highway Experience Standard.` and MUST NOT locally restate generic Experience Standard behavior.
- **FR-003**: The runtime skill MUST remove development-only compliance, Security Gate, Maintainability Gate, historical P/X inventory, step-to-error, and post-write verification material.
- **FR-004**: Controls MUST use accepted Profile, accepted Business Objectives, existing Controls, declared Highway framing sources, and declared external expertise only in their stated grounding roles.
- **FR-005**: Existing Controls MUST remain the source for exact duplicate, semantic overlap, and reuse detection.
- **FR-006**: External sources MAY ground recommendations, but MUST NOT become user-owned policy or imply organizational applicability, certification, or compliance without separate evidence. Recommendation provenance MUST remain available for future traceability through an optional body section in the retained Control record, never through frontmatter.
- **FR-007**: Concern, Condition, and Obligation MUST remain transient evidence categories, not mandatory questions, persisted fields, or user-visible progress dimensions.
- **FR-008**: Controls MUST apply the rule `Ask for missing information, not missing phrasing.` and evaluate all accumulated evidence before each follow-up.
- **FR-009**: When accepted evidence is sufficient to construct a Control without inventing policy, Controls MUST stop discovery and proceed to capture or review.
- **FR-010**: Controls MUST preserve the distinction that an enforceable, auditable, or checkable safeguard is a Control, while a desired quality or operational outcome is an NFR.
- **FR-011**: Controls MUST ask at most one bounded Control-versus-NFR classification question when classification remains unresolved after evidence evaluation.
- **FR-012**: For `setup` and `configure`, Controls MUST evaluate grounded recommendations before asking the broad Control question, using accepted Profile, accepted Business Objectives, existing Controls, and applicable declared benchmark/framework expertise.
- **FR-013**: Recommendation sets MUST be small, relevant, grounded, and accompanied by a user-authored alternative; Controls MUST NOT generate generic recommendations solely to keep a loop active.
- **FR-014**: Selection of displayed recommendations MUST count as acceptance and MUST create selected Controls without redundant proposal confirmation. Missing information required for a valid selected Control MUST be the only follow-up.
- **FR-015**: When no useful grounded recommendation or usable Control evidence exists, Controls MUST use the exact broad question `What concerns should future technology decisions take into account?` with concise recognizable safeguard examples.
- **FR-016**: The materially interpreted user-authored review MUST use the exact captured-Control structure stated in User Story 3, with acceptance only at the bottom.
- **FR-017**: Rationale MUST be synthesized from accepted Control evidence, applicable accepted Profile or Objective context, and declared grounding sources; Controls MUST NOT ask a separate rationale question solely because the retained record contains rationale.
- **FR-018**: `setup` and `configure` MUST use the exact continuation wording stated in User Story 3, process supplied safeguards immediately, allow grounded suggestions or help, and continue until explicit finish or no useful grounded recommendations remain.
- **FR-019**: Direct `add` MUST remain a single-Control operation without the continuation cycle.
- **FR-020**: Controls MUST preserve Control records at `library/governance/controls/CTLXXXXXX.md`, the catalog at `library/governance/controls.md`, and the structural authority of control-record.md and the Control catalog template.
- **FR-021**: The four-field Controls Readiness Result MUST remain intact, with Missing for no valid Control, Complete for at least one valid Control with a consistent baseline, and Blocked for malformed or inconsistent state.
- **FR-022**: Readiness MUST remain separate from active collection completion, and Complete MUST NOT end setup/configure collection.
- **FR-023**: Controls MUST preserve pre-write baseline validation, exact duplicate and semantic-overlap handling, permanent identifier allocation and non-reuse, deterministic catalog generation, atomic record/catalog mutation, existing version semantics, destructive impact analysis, and the common failure model.
- **FR-024**: Controls MUST remove all post-write persistence-verification requirements, including `verified`, `persistence-verified`, byte-preservation verification, generated shell checks, and equivalent historical terminology whose sole purpose is confirming a successful write.
- **FR-025**: Workflow Step 6 MUST be named `Revalidate and persist`.
- **FR-026**: After a successfully created new Control, Controls MUST invoke the NFR-owner candidate-generation action once.
- **FR-027**: Controls MUST own the originating Control and invocation boundary only; NFRs MUST own candidate state, classification, review, accepted NFR artifacts, NFR identifiers, NFR readiness, and NFR completion. Controls MUST consume only the declared NFR result.
- **FR-028**: Controls MUST preserve the NFR owner's declared deferred-review timing and MUST not describe NFR candidate internals, counts, review mechanics, or persistence rules beyond the consumed contract.
- **FR-029**: The numbered workflow MUST be replaced with this ordered flow: classify action and authoritative baseline; load relevant accepted grounding; reuse Controls and recommend for setup/configure/add; process user-authored evidence; route NFR-shaped evidence; capture recommendations directly or review interpreted user-authored Controls; revalidate and persist; invoke NFR candidate generation after successful new creation; continue setup/configure until explicit finish; terminate direct add after one Control.
- **FR-030**: The Outputs section MUST preserve Control records, the Control catalog, the four-field readiness result, and a distinct setup/configure collection result only when required for continuation. The setup/configure collection result MUST remove `Created Control IDs` and expose only fields needed for the next owner action. Setup MUST rely on collection status and fresh readiness rather than cumulative transient identifiers.
- **FR-031**: The skill MUST preserve distinct setup/configure collection completion and readiness semantics: Complete means the persisted baseline is usable, while explicit user finish ends active collection.
- **FR-032**: The Verification section MUST contain concise checks for templates, readiness, transient evidence, evidence-first discovery, grounded recommendations, external grounding limits, direct recommendation capture, user-authored review, synthesized rationale, continuation, persistence, NFR handoff, and absence of generic Constitution or Experience Standard restatements.
- **FR-033**: The per-step Error Handling table MUST be deleted. Only Control-specific exceptions may remain: malformed baseline/allocation → Blocked without mutation; unresolved target → identify the target; unresolved classification → bounded question; destructive mutation → Experience Standard behavior; NFR-generation Blocked → preserve the new Control and consume the result.
- **FR-034**: The Controls skill MUST remain the owner of Control readiness, Control persistence, and the originating Control handoff while deferring NFR-owned lifecycle details to NFRs.
- **FR-035**: The change MUST be treated as a MAJOR controls.md contract change, and the `highway-controls` skill metadata version MUST change from `3.0.0` to `4.0.0`. Unrelated record and catalog template versions MUST remain unchanged.
- **FR-036**: `control-record.md` MUST remain unchanged unless its retained structure or rationale ownership semantics are intentionally changed.
- **FR-037**: The retained Control record MUST support an optional provenance section in its body for recommendation grounding. Provenance MUST NOT be stored in frontmatter and MUST NOT be required for a user-authored Control without grounding evidence.
- **FR-038**: Generated agent adapters and other generated artifacts MUST remain aligned with the canonical Controls skill.

### Key Entities

- **Control evidence**: Transient Concern, Condition, and Obligation information used to determine whether a Control can be constructed.
- **Grounded recommendation**: A proposed safeguard supported by accepted repository context or declared external expertise, with provenance and no implied policy applicability.
- **Control record**: The retained Control artifact with its existing identifier, title, status, relationships, statement, and rationale.
- **Control provenance**: Optional body content identifying the accepted repository context or declared external expertise that grounded a recommendation; it is absent when no grounding source applies and is never frontmatter.
- **Control baseline**: The persisted records, catalog, allocation state, and readiness result.
- **Collection result**: The setup/configure-specific indication of whether active collection should continue or has explicitly finished; it is distinct from readiness.
- **NFR handoff result**: The declared result consumed after successful creation of a new Control, without transferring NFR ownership to Controls.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of Control discovery fixtures ask for missing information rather than missing phrasing, and complete Control-ready evidence reaches capture without requiring all three transient evidence categories.
- **SC-002**: 100% of recommendation fixtures use accepted context or declared external expertise as grounding, preserve applicable provenance in an optional Control-record body section, retain a user-authored alternative, and make no unsupported applicability, certification, or compliance claim.
- **SC-003**: 100% of selected displayed recommendations are captured without redundant confirmation; 100% of materially interpreted user-authored Controls use the exact captured-Control review.
- **SC-004**: 100% of setup/configure continuation fixtures use the exact continuation wording, continue after readiness becomes Complete, and stop only on explicit finish or exhaustion of useful grounded recommendations; direct add remains single-Control.
- **SC-005**: 100% of valid, missing, and malformed baseline fixtures preserve Missing, Complete, and Blocked readiness semantics independently of active collection completion.
- **SC-006**: 100% of mutation fixtures preserve duplicate/overlap handling, permanent non-reused identifiers, deterministic catalogs, atomic mutation, destructive safeguards, and the common failure model.
- **SC-007**: 0 runtime requirements retain post-write persistence verification language or duplicate generic Experience Standard, Constitution, or development-governance rules.
- **SC-008**: 100% of successful new Control fixtures invoke NFR-owned candidate generation exactly once, while Controls does not own candidate state, review, NFR identifiers, readiness, or completion.
- **SC-009**: 100% of candidate-generation Blocked fixtures preserve the successfully created Control and create no partial NFR relationship.
- **SC-010**: The canonical Controls skill remains MAJOR-versioned, provenance appears only in the optional Control-record body section and never frontmatter, and all generated adapters match the canonical skill byte-for-byte.

## Assumptions

- The existing Control record and catalog templates remain authoritative; the Control record template is extended only with the optional provenance body section.
- The Experience Standard remains authoritative for generic user-visible interaction, recommendation acceptance, questions, confirmations, progress, examples, and external-grounding boundaries.
- The Highway Skills Constitution remains authoritative for shared context, ownership, persistence, and failure rules; the Controls skill will cite rather than restate those generic rules.
- Existing Control mutation semantics, readiness field shape, identifier allocation, catalog generation, destructive safeguards, and version rules remain unless explicitly changed above.
- The NFR owner exposes a stable candidate-generation result sufficient for Controls to invoke and consume without reproducing NFR internals.
- Setup and related owner contracts can be updated to remove `Created Control IDs` without requiring cumulative identifier state for completion routing.
- A MAJOR skill contract version is represented by the `highway-controls` metadata version, while the retained Control record and catalog template versions remain independently governed.
- The feature may update related setup/NFR contract references only where required to preserve the declared ownership boundary; broader setup or NFR redesign is out of scope.
- Generated adapters are regenerated from the canonical Controls skill rather than hand-edited.
- No unresolved product decision materially changes the requested scope, so no clarification marker is required.
