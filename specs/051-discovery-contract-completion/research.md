# Research: Discovery Contract Completion

## Decision 1: Replace the Outputs section with the approved user-owned contract

**Decision**: Define the Discovery record at `discoveries/DISCXXXXXX.md`, the catalog at
`discoveries/discoveries.md`, the required record sections, the completion response fields, the
shared catalog template dependency, and the no-output-on-failure boundary.

**Rationale**: The current section is syntactically incomplete and omits the contract needed by
later workflows and validators. The approved Feature 051 specification supplies the exact output
shape and preserves existing byte-safety behavior.

**Alternatives considered**:
- Retain the partial section: rejected because it cannot identify valid output paths or required
  content.
- Infer output fields from implementation behavior: rejected because the skill contract must be
  explicit and independently reviewable.

## Decision 2: Use explicit Reference Architecture references for matching

**Decision**: Match a Reference Implementation only when it explicitly references a matching
Reference Architecture or its identifier. Treat all other cases as non-matches.

**Rationale**: Explicit references are auditable and deterministic. Semantic similarity,
inference, approximation, and similarity scoring would make evidence depend on interpretation and
could alter recommendations outside the approved boundary.

**Alternatives considered**:
- Semantic similarity: rejected because it is not an explicit, reproducible relationship.
- Content inference: rejected because it creates an unbounded matching rule.

## Decision 3: Deduplicate by stable implementation identity and preserve zero-count fallbacks

**Decision**: Count unique matching Reference Implementations once per stable identifier. Missing,
unreadable, malformed, and affected inconsistent catalog entries contribute zero according to their
failure class, while blocking reasons are recorded when applicable.

**Rationale**: Stable identity prevents multiple paths from inflating evidence. Zero-count
fallbacks keep optional implementation evidence from failing Discovery.

**Alternatives considered**:
- Count every matching path: rejected because representation would change the result.
- Abort on optional implementation data failure: rejected because absence and unavailable evidence
  are valid Discovery states.

## Decision 4: Apply tie-break criteria in an explicit order and stop at the first winner

**Decision**: For equal Recommendation scores, evaluate Reference Architecture Match, then unique
Reference Implementation Count, then the lowest Discovery-scoped `OPT` identifier. Stop when one
option remains.

**Rationale**: The ordered criteria preserve score and confidence semantics while making the only
permitted recommendation effect deterministic and bounded.

**Alternatives considered**:
- Add implementation count to scoring: rejected because Feature 050 excludes score and confidence
  mutation.
- Evaluate all criteria after a winner exists: rejected because it violates the early-stop rule.

## Decision 5: Keep the change at the Discovery skill-contract boundary

**Decision**: Update the existing `discovery.md` contract and its existing shell validation
surface; add no runtime dependency, external interface, generator, or packaging change.

**Rationale**: The requested behavior is a documentation and contract completion for an already
partially updated skill. Limiting the change preserves the repository's governance architecture
and minimizes unrelated risk.

**Alternatives considered**:
- Introduce a new runtime evaluator: rejected because the feature request is for skill-contract
  completion and the existing Discovery workflow remains authoritative.
- Modify ADR ownership: rejected because ADR remains the sole owner of decisions and authorization.
