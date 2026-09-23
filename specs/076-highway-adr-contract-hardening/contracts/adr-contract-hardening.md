# ADR Contract Hardening Contract

## Canonical invariants

1. An ADR consumes one completed `DISC######` and the ADR catalog is authoritative for Discovery uniqueness.
2. The catalog `Next ID` is the only allocation source. A successful publication advances it once and adds one direct index row.
3. All validation occurs before any ADR or catalog write. Duplicate, malformed, or conflicting input preserves every pre-operation byte; catalog conflicts retry no more than three times.
4. Every output contains `## Decision Confidence` with `Discovery Confidence` and `Confidence Considerations`; unavailable values are `None`.
5. Alternatives use exactly `Selected`, `Rejected`, or `Evaluated`. Exactly one is Selected. Evaluated means viable but not selected; Rejected means invalid or unsuitable.
6. `supersedes` and `superseded_by` are authoritative frontmatter fields only. The body and Reference Architecture Handoff contain neither field nor value.
7. No contributing Clarification renders scalar `None` immediately after `## Clarification Inputs`.
8. The Comparison Matrix is projected from Discovery without recalculation, reordering, or semantic transformation.
9. Recommendation Override is absent when recommendation and selection agree. On divergence it immediately follows Decision and contains recommendation, selection, and rationale.
10. Reference Architecture authorization does not authorize implementation.

## Verification obligations

The canonical `Verification` section must explicitly check:

- mandatory Decision Confidence and both fields;
- Recommendation Override absence on agreement or complete presence on divergence;
- catalog-based ADR-to-Discovery uniqueness;
- scalar Clarification `None` rendering when no evidence contributes;
- allocation from the catalog `Next ID`.

## Required fixture classes

- confidence present and unavailable;
- missing/incomplete confidence rejection with byte preservation;
- duplicate Discovery rejection;
- catalog allocation success, malformed state, and three-conflict exhaustion;
- selected, rejected, evaluated, and both semantic contradiction cases;
- frontmatter-only supersession;
- scalar Clarification `None`;
- verbatim Comparison Matrix projection with LF/canonical normalization;
- Recommendation Override agreement and divergence;
- generated adapter and template correspondence.
