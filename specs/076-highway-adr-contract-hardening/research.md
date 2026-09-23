# Research: Highway ADR Contract Hardening

## Decision 1: Keep the canonical ADR workflow declarative

**Decision**: Express the hardening in the canonical skill, output templates, focused Bash fixtures, and existing generators. Do not add a runtime service or dependency.

**Rationale**: Feature 075 already owns the ADR workflow and the repository distributes Markdown skills. The requested behavior is contract validation, deterministic projection, and atomic publication semantics. Existing Bash harnesses and generators are the established enforcement surface.

**Alternatives considered**:
- Add a new parser or package: rejected because it violates the repository dependency/toolchain boundary and is unnecessary for the existing Markdown contracts.
- Hand-edit generated agent copies: rejected because generated trees are derived artifacts and the constitution requires regeneration from canonical inputs.

## Decision 2: Treat the ADR catalog as the single allocation and uniqueness authority

**Decision**: Read the catalog's `Next ID` and existing ADR index entries before assembling the commit; reject duplicate Discovery identifiers before writes; advance `Next ID` once only after validation succeeds; retry catalog conflicts at most three times.

**Rationale**: The catalog already owns allocation and direct index entries. Reusing that authority prevents collisions and makes duplicate Discovery detection deterministic across agent adapters.

**Alternatives considered**:
- Infer the next identifier from filenames: rejected because filesystem order and filenames are explicitly non-authoritative.
- Allocate first and detect duplicates later: rejected because it permits partial state and violates the no-write-on-failure contract.

## Decision 3: Preserve source evidence literally where the specification requires projection

**Decision**: Copy the Discovery Comparison Matrix verbatim after the fixture's LF normalization and canonical serialization comparison; copy confidence and recorded Reference Architecture matches without rescoring or recomputation.

**Rationale**: ADR owns selection and decision content, while Discovery owns recommendation, scores, matrix evidence, matches, and confidence. Projection keeps those ownership boundaries intact.

## Decision 4: Make output shape explicit for absent optional evidence

**Decision**: Always render Decision Confidence with both fields. Use scalar `None` under Clarification Inputs when no contributing Clarification exists. Render Recommendation Override only for divergent selection.

**Rationale**: Stable section presence makes downstream validation and review deterministic while preserving the distinction between unavailable evidence and an empty collection.

## Decision 5: Constrain alternative vocabulary semantically

**Decision**: Permit exactly `Selected`, `Rejected`, and `Evaluated`; require exactly one Selected option; define Evaluated as viable but not selected and Rejected as invalid or unsuitable. Fixtures cover both contradictory semantic pairings.

**Rationale**: The vocabulary is already present in the baseline but its meanings are not enforced. Semantic fixtures prevent a superficially valid label from carrying the opposite meaning.

## Validation strategy

1. Update canonical skill and templates.
2. Add focused positive and negative fixtures for all new contract rules, including byte-preservation checks.
3. Regenerate catalogs and distributed adapters.
4. Run ADR/template validators and adapter correspondence tests.
5. Run `.highway/tools/tests/run-all.sh` and inspect `git diff --check`.
