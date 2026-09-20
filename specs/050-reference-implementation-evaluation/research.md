# Research: Reference Implementation Evaluation

## Decision 1: Use explicit Reference Architecture references only

**Decision**: A Reference Implementation matches an option only through an explicit reference to a matching Reference Architecture or its identifier.

**Rationale**: Explicit references are deterministic, auditable, and consistent with Discovery's existing exact-match boundary. They prevent implementation presence from becoming an opaque semantic score.

**Alternatives considered**:
- Semantic similarity: rejected because it would make matching non-transparent and could change recommendation behavior without an explicit reference.
- Inference from implementation content: rejected because it would introduce an unbounded interpretation layer and violate the advisory-only boundary.

## Decision 2: Define malformed artifacts structurally

**Decision**: An implementation is malformed only when it is unparseable, lacks a valid stable identifier, or lacks required fields. An unresolved Reference Architecture reference is a valid non-match; duplicate catalog identifiers are catalog inconsistencies.

**Rationale**: Separating structural validity from matching keeps failure handling predictable. Valid artifacts remain available for future catalog correction without being misclassified as malformed.

**Alternatives considered**:
- Treat unresolved references as malformed: rejected because unresolved references are a matching result, not a structural defect.
- Treat duplicate identifiers as ordinary duplicates: rejected because stable identity cannot be trusted when the authoritative catalog is inconsistent.

## Decision 3: Count unique implementations and use the highest matched-architecture count

**Decision**: Count each matching stable implementation identifier once. If an option matches multiple Reference Architectures, use the highest implementation count among those architectures.

**Rationale**: Unique counting prevents multiple evidence paths from inflating tie-break evidence, while the highest per-architecture count preserves the specified option-level comparison rule.

**Alternatives considered**:
- Count every matching path: rejected because the result would depend on representation details.
- Sum counts across architectures: rejected because it would reward options with more architecture matches rather than implementation evidence for the strongest match.

## Decision 4: Keep implementation evidence outside scoring and confidence

**Decision**: Evaluate Reference Implementation counts only after Recommendation scoring and Reference Architecture tie-breaking, then stop as soon as a criterion selects one option.

**Rationale**: This preserves Recommendation score comparability and keeps ADR as the exclusive decision owner.

**Alternatives considered**:
- Add implementation count as a weighted score component: rejected by the feature boundary and would change existing Recommendation semantics.
- Always evaluate all tie-break criteria: rejected because it creates unnecessary coupling and violates the immediate stop rule.

## Decision 5: No new runtime dependency or external interface

**Decision**: Implement the feature through existing Markdown artifacts, Discovery workflow conventions, and the current Bash-compatible validation harness. Contracts are repository-internal documentation contracts rather than network APIs.

**Rationale**: The repository is a distributed governance skill suite, and the feature changes document behavior rather than introducing an application runtime.

**Alternatives considered**:
- Introduce a parser or service dependency: rejected because it would add runtime and packaging risk for a deterministic document workflow.
