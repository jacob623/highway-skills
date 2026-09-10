# Feature 038 Research

## Decision: Exclude NFR `Missing` from the owner state model

**Rationale**: Feature 037's clarification states that candidates exist and none are accepted must always be `In Progress`. The existing owner and data-model contracts already describe candidate generation with zero results as `Not Applicable`, accepted artifacts as `Complete`, and unavailable or malformed generation as `Blocked`. No distinct supported input remains for NFR `Missing`.

**Alternatives considered**:
- Retain NFR `Missing` as a pre-proposal state: rejected because it conflicts with the clarification and makes identical candidate inputs route differently.
- Add a persistent proposal-start marker: rejected because readiness is derived and FR-004 forbids a readiness artifact.

## Decision: Treat `.highway/skills/` as the only behavior-owning source tree

**Rationale**: The adapter generator reads `.highway/skills/` and writes GitHub, Claude, and Cursor outputs. Planning and task paths must name the source tree to prevent direct edits to generated artifacts.

**Alternatives considered**:
- Use `.github/skills/` as source: rejected because it is a generated adapter tree and the generator refuses drifted outputs.
- Maintain two source trees: rejected because it creates an untestable ownership split.

## Decision: Add executable fixture evaluation alongside static contract tests

**Rationale**: Static checks prove documentation and response-shape assertions, but cannot prove that owner state decisions derive from artifact inputs. Disposable fixtures, response parsing, before/after hashes, and three-run comparisons provide behavior evidence without mutating repository-owned artifacts.

**Alternatives considered**:
- Treat static grep and canned response checks as sufficient: rejected because they cannot detect an implementation that documents one state table but computes another.
- Add a new runtime dependency or service: rejected because the existing Bash and file-based toolchain is sufficient and the feature requires local deterministic validation.

## Decision: Report evidence classes separately

**Rationale**: Executable owner behavior, Setup routing, static contracts, generated correspondence, requirement coverage, and limitations answer different verification questions and must not be conflated in one passing result.

**Alternatives considered**:
- Use one aggregate test result as proof of all requirements: rejected because it hides evidence gaps.
