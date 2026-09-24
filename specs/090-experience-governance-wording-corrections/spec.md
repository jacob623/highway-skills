# Feature Specification: Experience Governance Wording Corrections

**Feature Branch**: `090-experience-governance-wording-corrections`

**Created**: 2026-09-24

**Status**: Draft

**Input**: User description: Correct Experience Standard UX Contract authority wording, align X2.9 trigger wording with its Observable, remove orphaned amendment rationale text, move Principle XII to the requested precedence position, and remove the duplicate Principle XI bump rationale from the Highway Constitution.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Clear Experience Contract Authority (Priority: P1)

As a governance maintainer, I want the Interactive Workflow UX Contract to state clearly that the X2 rules remain the normative authority, so that interpretive guidance cannot be mistaken for a second rule source or a restriction on only part of the X2 namespace.

**Why this priority**: Ambiguous authority wording can cause inconsistent reviews and accidental creation of duplicate obligations.

**Independent Test**: Inspect the Experience Standard and confirm both targeted authority passages state that the X2 rules remain the sole normative interaction authority, while the contract only interprets and organizes their application.

**Acceptance Scenarios**:

1. **Given** the Interactive Workflow UX Contract is reviewed, **when** its authority statement is read, **then** it identifies the X2 rules as the sole normative interaction authority.
2. **Given** the contract's scope disclaimer is reviewed, **when** it describes what the contract does not create or modify, **then** it refers to normative rule text generally and does not imply that only X2.2-X2.6 are protected.
3. **Given** the Experience Standard amendment history is reviewed, **when** orphaned rationale text is searched, **then** no incomplete Repository Context/X2.7-X2.8 bump rationale remains.

### User Story 2 - Precise Decision Context Applicability (Priority: P1)

As a reviewer of guided information collection, I want X2.9 to use the same downstream-outcome vocabulary as its Observable, so that applicability decisions are consistent and testable.

**Why this priority**: A narrower rule trigger than its Observable creates uncertainty about when Decision Context is required.

**Independent Test**: Compare the X2.9 rule and Observable and confirm that both cover downstream recommendations, decisions, artifacts, governance interpretations, and workflow actions.

**Acceptance Scenarios**:

1. **Given** a requested answer affects a downstream recommendation, **when** X2.9 applicability is evaluated, **then** Decision Context applies.
2. **Given** a requested answer affects a downstream decision, artifact, governance interpretation, or workflow action, **when** X2.9 applicability is evaluated, **then** Decision Context applies.
3. **Given** a requested answer affects none of the listed downstream outcomes, **when** X2.9 applicability is evaluated, **then** the rule may be recorded N/A under the existing N7 condition.

### User Story 3 - Correct Constitutional Precedence and History (Priority: P1)

As a governance maintainer, I want the Constitution's precedence ordering and amendment history to be unambiguous, so that Persistence and Completion Integrity has the intended rank and historical metadata does not contain duplicated rationale.

**Why this priority**: Precedence determines which principle governs conflicts, while duplicate history weakens auditability and makes the document appear internally inconsistent.

**Independent Test**: Inspect the Constitution's Principle Precedence section and Sync Impact Report, then verify Principle XII appears directly after Principle V and the duplicate Principle XI rationale is removed.

**Acceptance Scenarios**:

1. **Given** the Principle Precedence table is read in order, **when** Principle V is followed, **then** Principle XII appears next and Principle VIII follows after it.
2. **Given** the Constitution amendment history is searched for the Principle XI bump rationale, **when** duplicate consecutive copies are compared, **then** only one authoritative rationale remains.
3. **Given** existing principles, rule identifiers, tiers, and normative obligations are reviewed, **when** these corrections are applied, **then** none are added or removed, and X2.9 changes only by the explicitly specified wording alignment that preserves its intended applicability boundary.

### Edge Cases

- The X2.9 rule and Observable may already use near-equivalent wording but must still be aligned to the same enumerated downstream outcomes.
- The orphaned rationale may be split across line breaks and must be removed as one incomplete historical entry without disturbing the following amendment.
- Principle XII may appear in a precedence table with rank numbers that require the affected rows to be renumbered consistently.
- The duplicate Principle XI rationale may occur as identical consecutive text and only one copy should remain.
- Existing references to X2.2-X2.6, X2.7-X2.8, and P12 must remain intact unless directly required by the precedence correction.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST state that the X2 rules remain the sole normative interaction authority.
- **FR-002**: The Experience Standard MUST state that the Interactive Workflow UX Contract interprets and organizes application of the X2 rules without creating additional normative obligations.
- **FR-003**: The Experience Standard MUST state that the contract itself does not create additional X-rule obligations, modify normative rule text, or introduce X rule identifiers.
- **FR-004**: The Experience Standard MUST remove the orphaned incomplete bump rationale beginning with "Bump rationale: adds Repository Context definitions" and ending before the complete preceding amendment record.
- **FR-005**: The X2.9 trigger MUST name downstream recommendations, decisions, artifacts, governance interpretations, and workflow actions as the outcomes that make Decision Context applicable.
- **FR-006**: The X2.9 trigger and Observable MUST express the same applicability boundary without narrowing or expanding the existing intended rule.
- **FR-007**: The Highway Constitution MUST place Principle XII directly after Principle V and before Principle VIII in the Principle Precedence section.
- **FR-008**: Any affected precedence ranks MUST remain sequential and preserve the relative order of all unaffected principles.
- **FR-009**: The Highway Constitution MUST retain exactly one complete Principle XI bump rationale in its amendment history.
- **FR-010**: The feature MUST NOT add or remove any principle, rule identifier, tier, N/A token, or normative obligation; X2.9 remains X2.9: its Tier remains unchanged, its Sample classification remains unchanged unless validation conventions explicitly require otherwise, its Observable may receive only the minimum wording alignment necessary to express the same five outcome categories, and N7 remains its N/A condition.
- **FR-011**: Existing references to the Experience Standard, P12, X2.1-X2.10, and N7-N9 MUST remain valid after the corrections.
- **FR-012**: Validation MUST detect the corrected authority wording, X2.9 alignment, orphan removal, precedence placement, duplicate-rationale removal, and preservation of unaffected identifiers.
- **FR-013**: The feature MUST modify only the two governing documents and validation artifacts required to prove these corrections; individual skill files and user-owned governance records are out of scope.
- **FR-014**: The amendment history MUST record the resulting semantic version, rationale, changed elements, unchanged boundaries, and self-application review consistently with the actual corrections.
- **FR-015**: The Constitution amendment MUST classify the Principle XII precedence change under the Constitution Versioning Policy based on its effect on conflict-resolution behavior, independently from the Experience Standard wording corrections.

### Key Entities *(include if feature involves data)*

- **Interactive Workflow UX Contract**: The reusable interpretive and organizational guidance section in the Experience Standard.
- **X2.9 Decision Context rule**: The Experience Standard rule governing contextual explanation for downstream-impacting answers.
- **Principle Precedence**: The ordered section of the Highway Constitution that determines precedence among principles.
- **Sync Impact Report**: The amendment history and metadata recorded at the beginning of each governing document.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: One automated or scripted validation run confirms all three corrected Experience Standard wording conditions with zero failures.
- **SC-002**: One automated or scripted validation run confirms X2.9's trigger and Observable contain the same five downstream outcome categories with zero failures.
- **SC-003**: One automated or scripted validation run confirms Principle XII is immediately after Principle V and before Principle VIII, with sequential affected ranks.
- **SC-004**: A complete-text search finds zero orphaned incomplete Repository Context/X2.7-X2.8 bump-rationale fragments and exactly one complete Principle XI bump rationale.
- **SC-005**: All existing X2.1-X2.10 and P12 identifiers remain present and unchanged in count; their tiers and applicable N/A conditions remain unchanged, and X2.9 retains its existing Sample classification unless an existing validation convention requires otherwise.
- **SC-006**: Reviewers can identify the governing authority, X2.9 applicability, and Principle XII precedence without encountering contradictory or duplicated amendment metadata.
- **SC-007**: The corrected X2.9 normative rule contains no more than 25 words and satisfies the existing constitutional normative-rule shape requirements.
- **SC-008**: The Constitution Sync Impact Report explicitly states the semantic-version classification of the Principle XII precedence change and its rationale under the Constitution Versioning Policy.

## Assumptions

- The requested corrections apply to the current governing documents at `.highway/governance/experience-standard.md` and `.highway/governance/constitution.md`.
- The feature is a documentation and validation correction, not a migration of individual skills.
- Existing versioning policy determines each document's semantic version increment; the Principle XII precedence change is assessed independently under the Constitution Versioning Policy because it may change conflict-resolution behavior, while no new principle or rule is introduced.
- Existing focused validators are the preferred validation surface, with additional assertions added only if current checks cannot prove the corrections.
- No extension hooks are registered because `.specify/extensions.yml` is absent.
