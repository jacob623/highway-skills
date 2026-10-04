# Research: Experience Standard Collaborative Development

## Decision 1: Keep the implementation to one shipped governance document

**Decision**: Modify only `.highway/governance/experience-standard.md` during implementation. Do not
modify skills, retained schemas, tests, generated artifacts, the Constitution, or user-owned
governance baselines.

**Rationale**: The feature explicitly separates shared interaction behavior from domain ownership
and retained artifact structure. The target document is the owning layer for user-visible output;
individual workflows will be synchronized in later features.

**Alternatives considered**:

- Updating individual skills together: rejected because it expands the feature beyond the stated
  proof of the shared interaction model.
- Updating test assertions in the same feature: rejected because the explicit implementation scope
  is one file. Existing stale assertions are recorded as compatibility findings instead.

## Decision 2: Revise X2.8 without requiring a fixed acknowledgment phrase

**Decision**: Replace the current X2.8 obligation with the requested requirement that the next
response reflect changed understanding, interpretation, recommendation, or next user-relevant
action using newly accepted information and relevant accumulated context. Retain the
`[agent-checkable]` tier and prohibit mere repetition and workflow narration in the Observable.

**Rationale**: This preserves the existing requirement to respond when accepted information changes
Highway's understanding while making interpretation and useful contribution the preferred behavior.
It also permits a simple acknowledgment when contextual re-evaluation reveals nothing useful.

**Alternatives considered**:

- Requiring a literal acknowledgment phrase: rejected because it would make a conversational
  behavior depend on ceremonial wording.
- Removing the response requirement entirely: rejected because changed understanding still needs to
  be visible before the workflow advances.

## Decision 3: Add collaborative guidance as non-normative interaction guidance

**Decision**: Place Collaborative Development, Active Reasoning Context, Contextual Re-evaluation,
readability, ownership, artifact-completeness, and Evolution-Aware guidance near the existing
Conversational Voice, Conversational Presence, and Constructive Advisory guidance. Replace the
explanatory interaction model and acknowledgment pattern with inner and outer collaborative loops.

**Rationale**: The Experience Standard governs what the person sees and how interaction proceeds;
the Constitution and owning skills remain authoritative for acceptance, completeness, persistence,
and retained structure. Non-normative guidance can express adaptive collaboration without creating
new retained state or duplicating domain rules.

**Alternatives considered**:

- Adding new Experience Standard rules for every conceptual state: rejected because the requested
  states are reasoning concepts, not required user-facing labels or retained artifact types.
- Exposing Active Reasoning Context as a visible workflow state: rejected because it would narrate
  internal processing and conflict with the no-workflow-narration boundary.

## Decision 4: Retain X2.36 and strengthen its surrounding guidance

**Decision**: Preserve the existing X2.36 rule and its `[agent-checkable]` tier when present, then
add the requested collaborative commentary guidance and examples around it. Do not create a second
X2.36 row.

**Rationale**: The current Experience Standard already contains X2.36. The amendment should
strengthen its application to collaborative reasoning while preserving stable rule identity.

**Alternatives considered**:

- Renumbering or duplicating X2.36: rejected because rule IDs are stable across Experience Standard
  amendments and retired IDs are not reused.

## Decision 5: Apply MAJOR version classification if the X2.8 compatibility review confirms impact

**Decision**: Use the Experience Standard versioning policy rather than assuming a MINOR change.
The current document is version `7.2.0`. Because the requested X2.8 wording changes the normative
obligation and may make previously conforming acknowledgment behavior fail, the implementation
will use `8.0.0` if the compatibility review confirms that effect.

**Rationale**: The policy classifies a redefined rule or strengthened obligation that invalidates
previously conforming work as MAJOR. The non-normative additions alone would not justify a major
bump. No separate unreleased-version convention is declared in the active Experience Standard, so
its stated policy remains the authoritative decision source.

**Alternatives considered**:

- MINOR `7.3.0`: rejected if the revised X2.8 invalidates prior conforming behavior.
- Deferring the version decision: rejected because the amendment must leave an explicit, policy-
  grounded version result and the feature's success criteria require traceability.

## Decision 6: Treat the existing full-suite failure as an out-of-scope compatibility finding

**Decision**: Run focused validation for the changed document and run the full suite for evidence,
but do not modify `constitution-inventory.test.sh` or any other test. Report the existing failure
separately from Feature 126 requirement coverage.

**Rationale**: The current suite has a known failure asserting the former Constitution precedence.
Feature 126 explicitly permits only the Experience Standard implementation file, and changing that
test would violate the feature boundary.

**Alternatives considered**:

- Repairing the stale test: rejected as out of scope.
- Claiming the full suite passes: rejected because it would be false and would violate verification
  honesty.

## Decision 7: No external contracts or persisted data model

**Decision**: Do not create a `contracts/` directory. Model the conceptual collaboration entities
only in `data-model.md`, and validate the document through static content, scope, cross-reference,
and repository checks.

**Rationale**: The feature changes a shared Markdown governance contract, not an API, command
schema, storage format, or runtime interface.

**Alternatives considered**:

- Adding a runtime collaboration state contract: rejected because Active Reasoning Context is
  explicitly transient and must not become a persistent artifact type.
