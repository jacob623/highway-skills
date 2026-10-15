# Research: Highway Architecture and Implementation Invocation Guards

## Decision 1: Keep the guard in the two owning skill contracts

- **Decision**: Add the direct-invocation behavior to `.highway/skills/highway-architecture/SKILL.md` and `.highway/skills/highway-implementation/SKILL.md`; amend their focused onboarding tests.
- **Rationale**: Those files already own invocation shape, source resolution, ownership boundaries, validation-before-persistence, and error handling. The existing tests already validate each skill's contract.
- **Alternatives considered**: A shared orchestration skill was rejected because it would duplicate or transfer ownership of source-specific behavior; a new runtime executable was rejected because the repository ships Markdown skill guidance and Bash validation rather than a service runtime.

## Decision 2: Use explicit source identifiers and never infer a source

- **Decision**: Architecture accepts exactly one uppercase `ADR######`; implementation accepts exactly one uppercase `ARCH######`.
- **Rationale**: Existing Feature 175 and 176 contracts already define identifier-based catalog resolution, accepted-source status, uniqueness, deterministic ordering, and no-write failure behavior. The new missing-input prompts make that contract usable for direct invocation without changing source ownership.
- **Alternatives considered**: Selecting the only or newest record, using filesystem order, timestamps, recency, context, or session state was rejected because each can select a different source without an explicit user decision.

## Decision 3: Reuse canonical completeness and readiness validators

- **Decision**: Both guards call or reference the existing canonical completeness and readiness validation behavior and its established failure outcomes.
- **Rationale**: The clarification recorded in `spec.md` explicitly selects reuse. This avoids competing definitions between Feature 177 and the existing architecture, ADR, and implementation contracts.
- **Alternatives considered**: Feature-specific validators were rejected as duplicate ownership; manual-only review was rejected because the existing workflows already require deterministic pre-persistence validation.

## Decision 4: Preserve the existing write boundary

- **Decision**: Missing, invalid, unresolved, duplicate, ambiguous, malformed, incomplete, or not-ready input produces no allocation and no artifact/catalog write. Successful processing continues to the existing owning workflow.
- **Rationale**: Both existing workflows already state validation before persistence, atomic publication, byte preservation, and deterministic traceability. Feature 177 adds the entry guard and exact user-facing prompts only.
- **Alternatives considered**: Allocating an identifier before source validation was rejected because it would create observable state for an invalid or incomplete request.

## Decision 5: Regenerate all derived outputs

- **Decision**: After source skill edits, run the existing catalog and adapter generators and verify the generated surfaces and focused tests.
- **Rationale**: The Development Constitution requires generated artifact correspondence and prohibits hand-editing generated artifacts. The affected surfaces are `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, and `.cursor/rules/`.
- **Alternatives considered**: Editing adapters or catalog files directly was rejected because it would violate generated-artifact ownership and leave drift risk.

## Decision 6: Validate on macOS Bash 3.2.57

- **Decision**: Keep implementation and test additions within the existing Bash 3.2-compatible toolchain and Markdown contract style.
- **Rationale**: macOS is the target environment, and the Development Constitution explicitly prohibits newer Bash-only constructs and unlisted runtime dependencies.
- **Alternatives considered**: Introducing a Python or package-based validator was rejected because it adds a dependency and is unnecessary for the existing static contract tests.
