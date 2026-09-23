# Feature Specification: Clarification Contract Consistency

**Feature Branch**: `074-clarification-contract-consistency`

**Created**: 2026-09-22

**Status**: Draft

**Input**: User description: "Create a new spec for removing the retired combined conflict state, aligning Evidence Sources examples with the contract, adding explicit conflict-state and duplicate-history validation, removing duplicate explanatory text, and documenting the empty evidence-source state."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Distinguish Recommendation States (Priority: P1)

As a repository maintainer, I want clarification guidance to use separate evidence-gap and conflict states so that users and validators can interpret recommendations deterministically.

**Why this priority**: The retired combined state contradicts the current contract and can cause consumers to mistake missing evidence for conflicting evidence.

**Independent Test**: Search the canonical Clarification guidance and record template for the retired combined value, then inspect conflict and evidence-gap examples and validation rules.

**Acceptance Scenarios**:

1. **Given** authoritative evidence conflicts, **When** recommendation guidance is rendered, **Then** the result is `Escalate for Decision` with `Recommendation Basis: conflict`.
2. **Given** authoritative evidence is unavailable, **When** recommendation guidance is rendered, **Then** the result is `Unknown` with `Recommendation Basis: evidence-gap`.
3. **Given** any clarification artifact, **When** its contract text and examples are inspected, **Then** `Unknown / Escalate for Decision` does not appear anywhere.
4. **Given** validation rules are applied, **When** a basis/state pairing is invalid, **Then** validation rejects it and preserves all pre-operation bytes.

### User Story 2 - Represent Evidence Sources Consistently (Priority: P1)

As a repository maintainer, I want single and multiple evidence-source examples to use the same list-item structure as the contract so that source traceability is unambiguous.

**Why this priority**: A nested wrapper in examples contradicts the documented structure and makes generated records harder to validate consistently.

**Independent Test**: Inspect every Evidence Sources example in the canonical record template and verify each source is a separate list item with the three required fields.

**Acceptance Scenarios**:

1. **Given** one evidence source, **When** the example is read, **Then** it contains Source Type, Source Identifier, and Reason Used directly under one source list item.
2. **Given** multiple evidence sources, **When** the example is read, **Then** each source is a separate list item with the same three fields and no nested Source wrapper.
3. **Given** no evidence sources, **When** the contract is read, **Then** it provides the deterministic example `Evidence Sources: None`.

### User Story 3 - Enforce History and Contract Validation (Priority: P1)

As a repository maintainer, I want validation guidance to detect duplicate history identifiers and invalid recommendation pairings so that malformed clarification records cannot be retained partially.

**Why this priority**: Duplicate history entries and inconsistent state rules undermine traceability and make retained records non-deterministic.

**Independent Test**: Inspect the Clarification skill's Outputs, Verification, and Error Handling sections for explicit basis/state checks, conflict-state checks, combined-state checks, duplicate-history checks, and no-partial-write behavior.

**Acceptance Scenarios**:

1. **Given** two Resolution History entries use the same Finding identifier, **When** validation runs, **Then** it aborts and preserves all pre-operation bytes.
2. **Given** a record uses `authoritative`, `evidence-gap`, or `conflict`, **When** its recommendation is validated, **Then** only the corresponding valid state is accepted.
3. **Given** a conflict recommendation is rendered, **When** verification runs, **Then** it confirms the result never renders `Unknown` and never uses a combined state.
4. **Given** the canonical template and Clarification skill are updated, **When** dependent generated artifacts are refreshed, **Then** they preserve the same conflict, evidence, and validation model.

### Edge Cases

- The retired combined value appears in prose, an example, a generated adapter, or a catalog-derived copy.
- A source list contains a nested `Source:` wrapper or omits one of the three traceability fields.
- A record has zero evidence sources and lacks an explicit `Evidence Sources: None` representation.
- A Resolution History section repeats a Finding identifier while all other fields differ.
- Recommendation Basis is valid but Recommended Option uses the wrong state, including conflict rendered as `Unknown` or evidence-gap rendered as `Escalate for Decision`.
- The same explanatory contract sentence appears more than once in the record template.
- A validation failure occurs after some output has been produced; the original bytes must remain unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Clarification guidance MUST replace every use of `Unknown / Escalate for Decision` with the distinct conflict state `Escalate for Decision` and `Recommendation Basis: conflict`.
- **FR-002**: The clarification-record contract MUST describe conflict guidance as `Escalate for Decision` with `Recommendation Basis: conflict` while retaining conflicting values, evidence sources, and explicit selection.
- **FR-003**: The repository MUST contain no remaining occurrence of the retired combined value in canonical artifacts or their generated copies.
- **FR-004**: Every Evidence Sources example MUST represent each source as a separate list item containing Source Type, Source Identifier, and Reason Used without a nested Source wrapper.
- **FR-005**: The clarification-record contract MUST provide `Evidence Sources: None` as the deterministic zero-source example.
- **FR-006**: Clarification Outputs MUST require valid Recommendation Basis and Recommendation State pairings: `authoritative` to evidence-backed recommendation, `evidence-gap` to `Unknown`, and `conflict` to `Escalate for Decision`.
- **FR-007**: Clarification Verification MUST confirm the valid basis/state pairing, that conflict never renders `Unknown`, that evidence-gap never renders `Escalate for Decision`, and that the two states never appear combined.
- **FR-008**: Clarification Verification MUST confirm that Resolution History contains no duplicate Finding identifiers.
- **FR-009**: Clarification Error Handling MUST abort validation and preserve all pre-operation bytes when a duplicate Resolution History Finding identifier is detected.
- **FR-010**: The clarification-record template MUST contain the explanatory contract sentence about text outside Findings, Resolution History, Source, and Status exactly once.
- **FR-011**: The canonical Clarification guidance and clarification-record contract MUST express the same conflict-handling model and valid basis/state vocabulary.
- **FR-012**: Validation and generated-artifact checks MUST preserve source immutability and prevent partial writes for invalid state pairings, duplicate history identifiers, and malformed evidence-source structures.
- **FR-013**: Existing clarification behavior for finding detection, privacy filtering, source immutability, revision handling, response capture, ownership boundaries, and supported artifact types MUST remain unchanged.
- **FR-014**: Generated catalogs and agent adapters MUST be refreshed whenever their canonical Clarification inputs change and MUST remain consistent with those inputs. A canonical input change includes modification of:
	- `clarify.md`
	- `clarification-record.md`
	- generated schema inputs
	- generated validation inputs
- **FR-015**: Generated artifacts include catalogs, adapters, validation outputs, generated examples, and any retained artifact derived from the canonical Clarification skill or clarification-record template.
- **FR-016**: Any violation of FR-001 through FR-019 MUST result in validation failure, no retained write, and preservation of all pre-operation bytes.
- **FR-017**: Generated clarification records MUST use the same Evidence Sources structure defined by FR-004.
- **FR-018**: The only non-authoritative recommendation states are `Unknown` and `Escalate for Decision`. No additional conflict, uncertainty, escalation, or combined states are valid.
- **FR-019**: Duplicate Finding identifiers are prohibited within a single Resolution History section regardless of differing Response, Actor, Revision, or other fields.

## Key Entities *(include if feature involves data)*

- **Recommendation Basis/State Pair**: The deterministic relationship between evidence condition and Recommended Option value.
- **Evidence-Backed Recommendation**: Any Recommended Option value derived from authoritative evidence and not equal to `Unknown` or `Escalate for Decision`.
- **Evidence Source Entry**: A traceability list item containing Source Type, Source Identifier, and Reason Used.
- **Resolution History Finding Identifier**: The unique finding reference used to ensure each retained history entry is traceable and non-duplicated.
- **Clarification Contract Text**: Explanatory rules governing retained clarification records and validation behavior.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of canonical and generated clarification artifacts contain zero occurrences of `Unknown / Escalate for Decision`.
- **SC-002**: 100% of recommendation examples and validation rules use only the three valid basis/state pairings defined by the contract.
- **SC-003**: 100% of Evidence Sources examples use separate list items with all three required traceability fields, including the explicit zero-source example.
- **SC-004**: 100% of duplicate Resolution History Finding identifiers are detected before any write and leave pre-operation bytes unchanged.
- **SC-005**: The explanatory contract sentence appears exactly once in the canonical clarification-record template.
- **SC-006**: The focused Clarification and output-template contract tests, validators, generators, generated-artifact tests, and full repository suite pass with zero failures after implementation.
- **SC-007**: Reviewers can identify the same conflict-handling model in clarify.md and clarification-record.md without encountering contradictory vocabulary or structure.
- **SC-008**: A full repository and generated-artifact search for the literal string `Unknown / Escalate for Decision` returns zero matches outside historical version-control records.
- **SC-009**: clarify.md and clarification-record.md express the same recommendation vocabulary, recommendation basis/state mappings, evidence-source structure, and duplicate-history rules with no contradictory statements.
- **SC-010**: 100% of generated clarification records use the same Evidence Sources structure required by FR-004 and contain no nested Source wrapper.
- **SC-011**: Validation tests include fixtures for conflict rendered as `Unknown`, evidence-gap rendered as `Escalate for Decision`, duplicate Resolution History Finding identifiers, nested Source wrappers, and missing `Evidence Sources: None` representation.
- **SC-012**: Every Recommendation Basis value appears in exactly one valid basis/state mapping, and every mapping appears identically in Functional Requirements, Acceptance Scenarios, Success Criteria, and generated artifact validation.

## Assumptions

- The canonical inputs are the Clarification skill and shared clarification-record output template; generated adapters and catalogs remain derived artifacts.
- The existing Clarification contract version remains authoritative except where explicitly superseded by this specification.
- `Unknown`, `Escalate for Decision`, `authoritative`, `evidence-gap`, and `conflict` remain the stable contract vocabulary.
- Validation uses disposable fixtures where needed and must not mutate user-owned source artifacts.
- No new runtime service, persistence mechanism, or external dependency is required.
