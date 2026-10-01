# Feature 122 Research

## Decision: Keep the change in the Profile skill layer

**Rationale**: The requested behavior concerns Profile-specific evidence grounding, validation, persistence, readiness, and scope. Highway Identity and Experience Standard 7.1.0 already own generic conversational identity, presence, advisory behavior, and X2.8. The Profile skill should cite and defer to those authorities rather than create competing rules.

**Alternatives considered**:
- Amend Highway Identity: rejected because the identity model is already finalized and is outside Feature 122 scope.
- Amend the Experience Standard: rejected because Feature 121 already established the shared 7.1.0 behavior.
- Add runtime conversation state: rejected because acknowledgments, presence, and advisory contribution are transient behavior, not retained Profile state.

## Decision: Collapse duplicated Enrichment guidance into one Profile-specific model

**Rationale**: The current skill describes Acknowledge/Build/Recommend/Validate twice, makes acknowledgment optional, and restricts advisory value to decision value. One concise model can preserve Profile-specific grounding while delegating generic response composition to shared guidance.

**Alternatives considered**:
- Keep both paragraphs and revise each independently: rejected because duplication would continue to drift.
- Remove all enrichment guidance: rejected because Profile still needs domain-specific grounding and validation behavior.

## Decision: Preserve the existing retained-versus-transient boundary

**Rationale**: The shared conversational update must not turn acknowledgments, reflections, advisory observations, or internal category names into organizational facts. Only accepted organizational narrative and accepted optional Profile Context remain retained.

**Alternatives considered**:
- Add persisted acknowledgment or advisory states: rejected because the feature explicitly preserves Profile persistence ownership and schema 3.0.0.
- Persist all generated recommendation context: rejected because it would violate accepted-evidence ownership.

## Decision: Preserve the current four-domain and acquisition contracts

**Rationale**: Identity, Vision, Competitive Path, and Guiding Principles remain the only readiness domains. Recommendation-first acquisition, canonical fallback, acceptance, persistence-before-result, website scope, brownfield exclusion, and completion ownership are existing contracts and are explicitly protected.

**Alternatives considered**:
- Add a fifth conversational domain or readiness state: rejected because conversation is shared behavior, not Profile evidence.
- Change the Profile record template: rejected because the requested synchronization is presentation guidance only.

## Decision: Use existing shell contract validation with no new external contract

**Rationale**: The repository is a documentation-led skill suite. Existing focused Profile and UX contracts can assert changed and preserved wording, scope, persistence, readiness, and template behavior. No public API, CLI wire format, service, dependency, or contract directory is introduced.

**Alternatives considered**:
- Add an external contract artifact: rejected because no external interface changes.
- Add a new test framework or runtime fixture: rejected because existing Bash 3.2-compatible contracts cover the change.

## Decision: Preserve `highway-profile` version 5.1.0

**Rationale**: The current skill metadata is already 5.1.0. This work synchronizes guidance within that version's intended Profile capability without changing the retained schema or public operations. Any version-policy decision found during implementation must be recorded rather than silently changed.

**Alternatives considered**:
- Bump the skill version again: rejected absent a version-policy trigger or new public capability.
- Change the retained Profile schema version: rejected because conversational synchronization is transient and schema-neutral.

## Resolved Unknowns

- No new runtime, storage, integration, scale, or performance design is required.
- The implementation surface is the authoritative Profile skill plus directly affected Profile-specific checks.
- Generated adapters and catalogs are not hand-edited; regeneration is considered only if the repository's established source-change workflow requires it.
- `profile-record.md`, Highway Identity, Experience Standard, retained Profile artifacts, and unrelated skills remain protected.
