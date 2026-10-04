# Feature 119 Research

## Decision: Use the existing Profile skill as the only shipped implementation surface

**Rationale**: The request changes Profile-specific conversational composition and validation wording. The existing skill already owns acquisition, enrichment, persistence, readiness, completion, and scope boundaries. No new service or runtime abstraction is needed.

**Alternatives considered**: A new conversational orchestration layer was rejected because it would duplicate the shared Experience Standard and create a second owner for Profile interaction behavior.

## Decision: Treat Acknowledge and Build as optional presentation composition

**Rationale**: Accepted evidence must still be persisted, all domains re-evaluated, and recommendations attempted before canonical fallback. Acknowledgment and advisory contribution surround an already-selected recommendation; neither becomes a discovery stage or readiness state.

**Alternatives considered**: Making both parts mandatory was rejected because the requirements explicitly prefer omission over manufactured commentary and do not impose fixed length.

## Decision: Use accuracy-oriented Profile-specific validation prompts

**Rationale**: The supplied wording validates Highway's understanding rather than framing the interaction as transactional approval. Identity, Vision, Competitive Path, and Guiding Principles each receive a domain-specific prompt and quiet correction/replacement path, while natural acceptance and clarification handling remain owned by the Experience Standard.

**Alternatives considered**: Reusing generic `accept/change/provide your own` wording was rejected because it is the behavior being replaced.

## Decision: Retain one cohesive recommendation as the only candidate domain narrative

**Rationale**: Acknowledgment and advisory commentary are conversational context. Only the accepted cohesive paragraph or explicit user-authored alternative may become retained domain evidence. This preserves the existing four-domain schema and prevents commentary from silently changing the Profile.

**Alternatives considered**: Persisting the whole conversational turn was rejected because it would mix transient reasoning with user-owned organizational evidence.

## Decision: Keep the current version and shared boundaries

**Rationale**: The repository is already at `highway-profile` version `5.1.0`. This feature refines the existing guarantee and therefore preserves `5.1.0`, leaves `profile-record.md` unchanged, and keeps the Experience section as the single shared-standard sentence.

**Alternatives considered**: A version bump or template amendment was rejected because neither is required by the requested behavior.

## Decision: Validate with focused Bash contract checks and the full suite

**Rationale**: Existing Profile contracts can assert exact validation wording, hidden/transient content, recommendation sequencing, persistence ordering, readiness, and scope. Bash 3.2 compatibility and the repository's full suite are existing project requirements.

**Alternatives considered**: Introducing a new test framework was rejected because it would add dependencies without improving validation of Markdown skill contracts.

## Resolved Unknowns

- No external API, CLI protocol, storage format, or retrieval service is introduced.
- No `contracts/` directory is required.
- No changes are needed to the shared Profile template, Experience Standard, Highway identity, or Constitution.
- Generated adapters and catalog outputs must be refreshed after the source skill changes.
