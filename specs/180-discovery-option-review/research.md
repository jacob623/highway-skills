# Research: Discovery Option Review and Implementation Exploration

## Decision: Keep exploration in Discovery as a read-only advisory interaction

**Rationale**: Discovery already owns candidate generation, comparison, scoring, recommendation, and the advisory ADR handoff. Adding review and exploration to that owner preserves one coherent interaction surface and prevents a second workflow from duplicating option context.

**Alternatives considered**:
- Create a separate option-review skill: rejected because it would split the Discovery conversation and require another routing and evidence contract.
- Move exploration into ADR: rejected because ADR owns explicit selection and commitment, while review must remain available before a decision.

## Decision: Use explicit review intents for one option, two-option comparison, examples, and costs

**Rationale**: The requested forms (`Describe`, `Review`, `Compare`, `Show implementation examples`, and `Show implementation costs`) are recognizable, independently testable user interactions. Each intent can resolve option identifiers against the active Discovery without changing the retained record.

**Alternatives considered**:
- Treat every follow-up as a new Discovery analysis: rejected because it would risk score and recommendation drift.
- Accept an unqualified option name: rejected because Discovery identifiers provide deterministic, cross-record-safe resolution.

## Decision: Store optional implementation evidence in the shared Discovery record structure

**Rationale**: The feature explicitly adds optional record sections for Example Reference Implementations, Example Realization Matrix, and Example Cost Considerations. Keeping them in the shared template makes retained evidence structurally consistent while allowing the sections to be absent when no reliable evidence exists.

**Alternatives considered**:
- Persist evidence in a separate catalog: rejected because examples and costs are evidence attached to an option, not independently allocated governance artifacts.
- Make the sections mandatory: rejected because the specification allows evidence to be unavailable and requires `Unknown` rather than invention.

## Decision: Keep implementation examples and costs outside scoring and ranking

**Rationale**: Examples and cost evidence improve explainability and practical evaluation but can be incomplete, stale, or commercially biased. Treating them as advisory preserves existing score identity, recommendation determinism, and ADR ownership.

**Alternatives considered**:
- Add cost or product availability to recommendation scores: rejected because it would change the established scoring contract and make evidence quality a hidden decision criterion.
- Use examples as a tie-break: rejected because the feature explicitly prohibits recommendation tie-breaking by implementation evidence.

## Decision: Represent missing or uncertain evidence explicitly

**Rationale**: `Unknown`, unavailable, and qualified cost ranges let the person distinguish absent evidence from a low estimate. The workflow must not infer prices, commitments, or organizational suitability from product names alone.

**Alternatives considered**:
- Omit all missing fields: rejected because omission hides the evidence gap and weakens review completeness.
- Estimate costs automatically: rejected because the first release has no requirement for live pricing or a trusted pricing source.

## Decision: Validate supported review interactions through static and fixture-based contract tests

**Rationale**: The repository is a skill and template authoring framework. The highest-risk behaviors are ownership, no-write invariants, deterministic presentation, shared-template correspondence, and generated adapter freshness; existing shell tests are the established validation surface.

**Alternatives considered**:
- Add an executable service: rejected because no runtime service or dependency is required.
- Rely only on prose review: rejected because byte preservation, score invariance, and unsupported-option handling need executable checks.
