# Feature 122 Data Model

Feature 122 changes conversational guidance around Profile evidence. It does not add a persisted entity, field, state, schema version, or workflow state.

## Profile

The retained organizational Profile owned by `highway-profile`.

- Schema version: `3.0.0`, unchanged.
- Readiness domains: `identity`, `vision`, `competitive_path`, `guiding_principles`.
- Domain states: `not_discussed`, `discussed`, `bounded`.
- Optional context: accepted Repository Name, Organization Name, Organization URL, and organizational context as defined by the shared Profile template.
- Ownership: Profile owns accepted evidence, persistence, readiness, and completion synthesis.

## Accepted Profile Evidence

User-provided or user-accepted organizational information that can ground recommendations and be retained.

- Establishes or updates one or more Profile domains.
- Is persisted before dependent readiness or owner results.
- Is reused across all four domains before unresolved canonical fallback questions.
- Website-derived facts remain proposed until accepted.

## Transient Conversational Context

User-visible context that supports a response but is not retained automatically.

- Acknowledgments required by X2.8 when applicable.
- Reflections, explanations, implications, opportunities, connections, tradeoffs, tensions, concerns, alternatives, and sharpening observations.
- Internal enrichment categories used to reason about domain grounding.
- Becomes retainable only when the person explicitly incorporates it into accepted Profile evidence.

## Domain Grounding

Accepted evidence used to synthesize a domain-specific recommendation.

- Vision: accepted Identity, accepted website-derived organizational evidence, existing accepted Vision evidence, and other accepted Profile context.
- Competitive Path: accepted Vision and accumulated accepted Profile evidence.
- Guiding Principles: accepted Competitive Path and accumulated accepted Profile evidence.
- Identity: existing Profile acquisition and accuracy-oriented validation behavior remain authoritative.
- Internal category names remain hidden and are never persisted.

## Domain Recommendation

A cohesive, evidence-grounded proposal for a Profile domain.

- Uses natural wording without a fixed recommendation sentence template or lead-in.
- May include useful Profile-specific advisory contribution when grounded context supports it.
- Preserves the existing accuracy-oriented validation and correction/replacement path.
- Accepted recommendation establishes the applicable unresolved domain as `discussed`.
- Insufficient grounding falls back to the applicable canonical question.

## Completion Synthesis

The concise user-relevant summary emitted after guided Profile completion.

- Uses accepted Profile understanding and the accepted Organization Name when available.
- May use first-person conversational identity under shared guidance.
- Contains no machine status fields, implementation details, or new question.
- Does not alter readiness or retained schema.

## State Boundary

No new state is introduced for acknowledgment, conversational presence, advisory contribution, or recommendation staging. Existing acceptance and persistence boundaries remain the only transition into retained Profile evidence.
