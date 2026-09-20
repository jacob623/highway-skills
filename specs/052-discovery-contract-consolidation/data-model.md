# Data Model: Discovery Contract Consolidation

This feature changes retained Markdown contracts and their validation evidence. It introduces no
runtime data model, persistence schema, or user-owned output format.

## Verification Contract

The single `## Verification` section in the authoritative Discovery skill.

| Property | Validation |
|---|---|
| Section cardinality | Exactly one `## Verification` heading exists. |
| Preserved requirements | Explicit matching, unique counting, malformed exclusion, zero-count fallbacks, score and confidence preservation, tie-break order, immediate stopping, deterministic repetition, and ADR ownership remain present. |
| Expectations consolidation | No `## Verification Expectations` heading exists. |

## Error Handling Contract

The single `## Error Handling` section in the authoritative Discovery skill.

| Property | Validation |
|---|---|
| Section cardinality | Exactly one `## Error Handling` heading exists. |
| Preserved failure behavior | Malformed, unreadable, duplicate-path, absent-catalog, unreadable-catalog, inconsistent-catalog, match-failure, source-failure, no-output, byte-preservation, and ADR-boundary behavior remain present. |
| Expectations consolidation | No `## Error Handling Expectations` heading exists. |

## Workflow Tie-Break Reference

Workflow step 10 renders the complete Comparison Matrix before Recommendation and directly names
`Recommendation Tie-Break Evaluation` for equal-score handling. It does not define a second
algorithm or use `prefer a matched architecture`.

## Generated Adapter Set

The generated Discovery copies are:

- `.github/skills/highway-discovery/SKILL.md`
- `.claude/skills/highway-discovery/SKILL.md`
- `.cursor/rules/highway-discovery.mdc`

Each adapter is derived from `.highway/skills/highway-discovery/SKILL.md`; identity-copy
adapters must remain byte-identical and the Cursor transform must remain generator-current.

## State and Ownership

The change is valid only when the authoritative source, focused assertions, and generated adapters
agree. The feature does not create an ADR, record a decision, authorize implementation, or mutate
any governance baseline.
