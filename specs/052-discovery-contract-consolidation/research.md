# Research: Discovery Contract Consolidation

## Decision 1: Keep the authoritative source and generated adapter workflow

**Decision**: Edit `.highway/skills/highway-discovery/SKILL.md`, validate it with the existing Discovery test, and regenerate `.github/skills/highway-discovery/SKILL.md`, `.claude/skills/highway-discovery/SKILL.md`, and `.cursor/rules/highway-discovery.mdc` with `.highway/tools/generate-agent-adapters.sh`.

**Rationale**: The repository declares `.highway/skills/` as the authoritative source and the generator enforces adapter currency and drift protection. Editing an adapter directly would violate that ownership boundary.

**Alternatives considered**:
- Edit only an agent adapter: rejected because adapters are generated artifacts and the focused test reads the authoritative source.
- Add a new adapter mechanism: rejected because the existing generator already covers all supported agents.

## Decision 2: Merge by requirement preservation, not by rewriting semantics

**Decision**: Keep one `## Verification` section and one `## Error Handling` section, moving all Expectations-only requirements into those sections without changing matching, counting, fallback, ordering, no-output, byte-preservation, or ADR rules.

**Rationale**: The feature removes duplicate contract boundaries while preserving Feature 051 as the behavioral baseline. The focused test can assert both unique headings and representative requirements from each former section.

**Alternatives considered**:
- Delete the Expectations sections and their unique content: rejected because it loses contract requirements.
- Reword all surrounding Discovery rules: rejected because the feature excludes semantic changes.

## Decision 3: Delegate Workflow tie handling to the existing authority

**Decision**: Replace Workflow step 10's embedded `prefer a matched architecture` wording with a direct reference to `Recommendation Tie-Break Evaluation`, while retaining the complete Comparison Matrix before Recommendation sequence.

**Rationale**: One detailed tie-break source prevents drift and preserves score, confidence, ranking, and ADR ownership semantics.

**Alternatives considered**:
- Repeat the tie-break algorithm in Workflow: rejected because it recreates the duplication this feature removes.
- Change tie-break criteria or scoring: rejected because those are explicitly outside scope.

## Decision 4: Use existing validation and no new interface

**Decision**: Extend `.highway/tools/tests/highway-discovery.test.sh` with assertions for exact section counts, absent Expectations headings, direct tie-break reference, forbidden wording removal, and matrix ordering. Run the focused test, adapter coverage/generation checks, and the full suite.

**Rationale**: This is an internal Markdown contract change. Existing shell checks are the repository's established executable validation surface; no runtime API, dependency, or external contract is introduced.

**Alternatives considered**:
- Introduce a Markdown parser or new test framework: rejected because it adds dependencies for assertions already expressible by the existing shell harness.
- Rely on manual review alone: rejected because the requirements include exact counts, synchronization, and repeatable pass/fail checks.
