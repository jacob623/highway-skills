# Data Model: Experience Conversational Presence

This feature introduces no runtime data model, persistence schema, API payload, or migration. The model below describes the governed document entities and their relationships so the amendment can be validated without treating conversational guidance as retained user data.

## Experience Standard

- **Purpose**: Authoritative shared contract for user-visible Highway interaction.
- **Attributes**: version, ratified date, last amended date, X-rule identifiers, rule text, Observables, non-normative guidance, interaction model, examples, and amendment metadata.
- **Lifecycle**: authoritative 7.0.0 baseline -> applicable MINOR amendment after non-normative Presence guidance is added.
- **Validation**: preserved rule and Observable text remains unchanged; new guidance is explicitly non-normative; version metadata matches the existing versioning policy.

## Conversational Voice

- **Purpose**: Defines whose perspective Highway speaks from.
- **Relationship**: Peer non-normative guidance section alongside Conversational Presence and Constructive Advisory.
- **Validation**: heading is level four; existing guidance remains substantively unchanged; no new X-rule is created.

## Conversational Presence

- **Purpose**: Defines the room Highway has to explain, reflect, acknowledge, connect ideas, and converse naturally.
- **Attributes**: useful conversational depth, natural conclusion, adaptive detail, multiple short paragraphs when useful, and anti-filler guardrails.
- **Relationship**: Sits after Conversational Voice and before Constructive Advisory; does not replace X2.8 or authorize implementation detail, progress narration, machine results, or unnecessary rationale.
- **Validation**: guidance is non-normative, contains no numeric verbosity quota, and supports turns without a question when no unresolved need exists.

## Constructive Advisory

- **Purpose**: Governs conditional intellectual contribution.
- **Attributes**: implications, recommendations, alternatives, tradeoffs, concerns, inconsistencies, downstream consequences, and relevant connections.
- **Relationship**: Uses demonstrated understanding and connected context; remains optional and distinct from conversational room supplied by Presence.
- **Validation**: commentary may have conversational, explanatory, or decision value; filler and manufactured disagreement remain excluded.

## Preserved X-rule Contract

- **Purpose**: Protects existing normative interaction boundaries.
- **Members**: X1.7, X2.3, X2.4, X2.5, X2.6, X2.8, X2.9, X2.26, X2.33, X2.34, and X2.35.
- **Relationship**: Conversational Presence may explain how these rules coexist but cannot alter their rule text or Observables.
- **Validation**: focused contracts and the full repository suite pass with no protected-rule drift.

## Retention Boundary

Conversational Presence is user-visible guidance only. No acknowledgment prose, first-person framing, conversational reflection, or unadopted advisory commentary becomes a persisted organizational record through this feature.
