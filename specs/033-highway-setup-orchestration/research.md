# Feature 033 Research: Highway Setup

## Decision: Model `highway-setup` as a Markdown orchestration skill

- **Decision**: Implement the feature as `.highway/skills/highway-setup/SKILL.md`, with no new runtime, package, or interpreter dependency.
- **Rationale**: Existing Highway capabilities are agent-facing Markdown skills. The requested behavior is workflow routing, state evaluation, and deterministic output rather than a standalone executable.
- **Alternatives considered**: A shell implementation was rejected because it would duplicate agent workflow invocation and owner interaction semantics already expressed by the existing skills.

## Decision: Delegate all artifact mutations to owner skills

- **Decision**: `highway-setup` reads readiness state and invokes `/highway-profile`, `/highway-objectives`, `/highway-controls`, and the Control-owned NFR proposal path; it never authors foundational records.
- **Rationale**: Existing skills own their records, confirmation gates, versions, catalogs, and malformed-input handling. Direct writes would create a second artifact store and violate ownership.
- **Alternatives considered**: Shared setup helpers and direct record creation were rejected because they would either bypass owner confirmation or duplicate owner contracts.

## Decision: Use strict ordered state evaluation with a blocking boundary

- **Decision**: Evaluate Profile, Objectives, Controls, then NFRs. Stop evaluation at the first incomplete or blocked prerequisite and mark later states `Not Evaluated`.
- **Rationale**: The user request makes the ordering intentional, and downstream status cannot be trusted when prerequisite context is absent.
- **Alternatives considered**: Evaluating all four areas eagerly was rejected because it could expose misleading downstream status and invoke workflows out of order.

## Decision: Treat accepted NFR artifacts, not proposals, as completion

- **Decision**: When Controls exist and NFRs are missing, invoke the Control-owned proposal workflow, pause for author acceptance, and resume only after the NFR owner recognizes accepted artifacts as present and valid.
- **Rationale**: The existing Controls contract states that a derived proposal is not an NFR until the author decides what to accept. This preserves NFR ownership and prevents false completion.
- **Alternatives considered**: Automatically creating proposals as NFRs was rejected because it bypasses author confirmation. Requiring a fresh setup invocation was rejected because the clarified requirement says setup resumes after acceptance.

## Decision: Keep dashboards as exact output contracts

- **Decision**: Define literal complete and in-progress dashboard blocks in the skill contract and validate labels, ordering, current activity, and ownership routes with focused fixtures.
- **Rationale**: Dashboard wording is user-facing behavior and is explicitly required to be exact; prose-only validation would allow drift.
- **Alternatives considered**: A flexible table or generated status format was rejected because it would not satisfy the exact-output requirement.

## Decision: Validate behavior with disposable repository fixtures

- **Decision**: Add a focused shell test that creates temporary repository trees, stubs owner workflow outcomes, verifies ordered calls and dashboard output, and asserts no direct artifact writes.
- **Rationale**: The repository's existing tests use Bash-compatible disposable trees and focused behavioral checks. This provides deterministic coverage without changing user-owned governance files.
- **Alternatives considered**: Testing only `validate-skill.sh` was rejected because structural validation cannot prove orchestration order, continuation, stopping, or exact output.

## Decision: Regenerate all derived registration artifacts

- **Decision**: After adding the skill, run the repository's catalog, adapter, and distribution generation workflow and validate correspondence.
- **Rationale**: Constitution rules D4.5-D4.7 require every source skill to have current generated artifacts and prohibit stale generated registration.
- **Alternatives considered**: Hand-editing generated files was rejected by the repository's generator integrity rules.
