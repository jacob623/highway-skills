# Feature 034 Research

## Decision: Use executable disposable-tree behavior fixtures

- **Decision**: Extend the existing `highway-setup` focused test with temporary repository trees, deterministic owner-workflow doubles, event logs, output captures, and artifact hashes.
- **Rationale**: Feature 033 is an instruction artifact, so behavior must be represented by deterministic fixtures that model repository state and owner outcomes. Static prose checks cannot establish call ordering, continuation, stopping, or idempotence.
- **Alternatives considered**: A second runtime implementation was rejected because it would duplicate the Markdown skill contract. Static-only validation was rejected because it cannot observe behavior claims.

## Decision: Preserve the original exact dashboard bytes

- **Decision**: Treat the tab-indented dashboard in Feature 033's `spec.md` as canonical and compare complete and in-progress output byte-for-byte, including line endings, indentation, and blank lines.
- **Rationale**: The original feature explicitly required exact content and ordering. Choosing one source contract removes the existing tabs-versus-spaces ambiguity.
- **Alternatives considered**: Normalizing whitespace before comparison was rejected because it would permit contract drift. Adopting the implementation's spaces was rejected because the original user-facing exact contract is the higher-authority requirement.

## Decision: Separate NFR missing and pending states

- **Decision**: `Missing` means no proposal has started; `In Progress` means a Control-owned proposal is pending author acceptance; `Complete` requires accepted valid artifacts; `Blocked` covers malformed or owner-reported unsafe states.
- **Rationale**: These states represent different next actions and must produce different guidance without conflating absence with a pending decision.
- **Alternatives considered**: One generic incomplete state was rejected because it cannot tell the user whether to start proposal work or make an author decision.

## Decision: Define a 20-case routing matrix with a 19/20 threshold

- **Decision**: Version the matrix as five readiness entry states crossed with four owner-result conditions: success, declined, failed, and incomplete/malformed. The complete entry state has no owner call and is represented by explicit no-mutation cases in the behavior fixtures. A route is successful when the first owner call or deliberate stop exactly matches the matrix row's expected result. At least 19 of 20 applicable rows must pass.
- **Rationale**: A fixed denominator makes SC-008 reproducible and prevents selective scenario counting. The four result classes cover the owner outcomes named by Feature 033.
- **Alternatives considered**: A percentage without a denominator was rejected because it cannot be independently reproduced. A single happy-path row per owner was rejected because it omits safe-stop behavior.

## Decision: Keep evidence categories separate

- **Decision**: Report executable suite results, routing coverage, requirement coverage, and ownership review as separate records.
- **Rationale**: A passing test suite does not prove exact requirement coverage or manual ownership review. Separate records make each claim auditable under D7.3.
- **Alternatives considered**: One aggregate compliance verdict was rejected because it hides which evidence category is incomplete.
