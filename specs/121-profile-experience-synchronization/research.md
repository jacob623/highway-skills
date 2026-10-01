# Research: Experience Conversational Presence

## Decision: Keep the amendment in the Experience Standard layer

- **Decision**: Modify only `.highway/governance/experience-standard.md` and directly affected repository verification or version records.
- **Rationale**: The feature explicitly adds shared non-normative interaction guidance. Individual skills and Highway Identity already own their respective contracts and are protected from this amendment.
- **Alternatives considered**: Updating Profile, Objectives, Controls, NFRs, or Setup now was rejected because it would broaden the feature and duplicate a later synchronization responsibility.

## Decision: Preserve existing normative rules and Observables byte-for-byte

- **Decision**: Treat X2.8, X1.7, X2.4, X2.3, X2.5, X2.6, X2.9, X2.26, X2.33, X2.34, and X2.35 as protected text and Observable contracts.
- **Rationale**: Conversational Presence is explanatory, not a replacement for acknowledgment, question-limit, rationale, progress, completion, or machine-result rules.
- **Alternatives considered**: Rewording X2.8 or adding a new X-rule was rejected because the specification requires continuity to remain owned by X2.8 and the new guidance to remain non-normative.

## Decision: Use no runtime or external interface design

- **Decision**: Represent the feature as Markdown guidance, examples, version metadata, and deterministic repository checks.
- **Rationale**: The repository has no runtime state, API, migration, or external integration for this behavior. The observable outcome is the governed user-visible standard and its validation evidence.
- **Alternatives considered**: Adding a runtime conversation engine, configuration schema, or new dependency was rejected as out of scope and inconsistent with the existing governance architecture.

## Decision: Apply the existing versioning policy as a MINOR amendment

- **Decision**: Start from authoritative version 7.0.0 and use the applicable MINOR increment because the requested changes add and rationalize non-normative guidance without redefining an existing rule or Observable.
- **Rationale**: The specification explicitly preserves all named normative contracts. The exact resulting version and amendment metadata remain governed by the Experience Standard's existing policy.
- **Alternatives considered**: A MAJOR increment was rejected unless implementation reveals a normative or Observable redefinition.

## Decision: Validate natural conclusion and no-question turns explicitly

- **Decision**: Add focused checks for Presence guidance, the three-concept distinction, no-question examples, preserved interaction boundaries, and absence of numeric verbosity quotas.
- **Rationale**: These are the highest-risk interpretation points: the new section must permit useful conversation without accidentally requiring verbosity, a question, or advisory contribution.
- **Alternatives considered**: Relying only on broad full-suite checks was rejected because they may not distinguish the new guidance from the preserved contracts.
