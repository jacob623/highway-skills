# Discovery Contract Consolidation Contract

## Contract Scope

This contract governs the retained Discovery skill text and its generated agent-facing copies.
It is a static-document contract; no runtime API or new persisted schema is exposed.

## Authoritative Source

- Source: `.highway/skills/highway-discovery/SKILL.md`
- Generator: `.highway/tools/generate-agent-adapters.sh`
- Focused validator: `.highway/tools/tests/highway-discovery.test.sh`

## Required Section Shape

The source MUST contain exactly one `## Verification` section and exactly one `## Error Handling`
section. It MUST NOT contain `## Verification Expectations` or `## Error Handling Expectations`.
The merged sections MUST retain all requirements listed in FR-002 and FR-005 of `spec.md`.

## Required Workflow Shape

Workflow step 10 MUST preserve the complete Comparison Matrix before Recommendation ordering and
MUST directly reference `Recommendation Tie-Break Evaluation` for equal-score handling. It MUST
NOT contain `prefer a matched architecture` or introduce a second tie-break algorithm.

## Synchronization Contract

The generator MUST be run after the source change. The three generated adapters MUST pass adapter
currency and correspondence validation. No generated adapter may be hand-edited to implement this
feature.

## Ownership Boundary

This consolidation MUST preserve Recommendation score, confidence, rationale, ranking, and ADR
ownership invariants. It MUST NOT create an ADR, record a decision, authorize implementation, or
mutate governance baselines.
