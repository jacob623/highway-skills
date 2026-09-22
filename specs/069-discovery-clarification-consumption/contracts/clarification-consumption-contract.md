# Contract: Discovery Clarification Consumption

## Resolution Contract

After resolving one completed Request `REQ######`, Discovery MUST derive `CLAR-<REQ-ID>` and read the optional catalog at `clarifications/clarifications.md`.

1. If the catalog is absent, continue without clarification evidence.
2. If no unique row matches the derived Clarification ID, continue without clarification evidence.
3. If a row matches, use its direct Clarification Path and verify the artifact identity and Request linkage.
4. Never select an artifact by timestamp, newest-file status, directory traversal order, or filesystem order.
5. Never repair a catalog, artifact, finding, response, revision, or status.

## Consumer Field Contract

For a valid referenced artifact, Discovery may read:

- status;
- open findings;
- resolved findings;
- total findings;
- blocking reason;
- finding identifiers, categories, severities, states, summaries, and evidence references; and
- accepted responses.

The producer-owned Clarification contract remains authoritative for field meaning, finding identity, state transitions, privacy filtering, and status precedence.

## Evidence Contract

Evidence precedence is:

1. Request evidence;
2. Clarification responses;
3. Profile;
4. Objectives;
5. Controls;
6. NFRs;
7. Reference Architectures; and
8. Reference Implementations.

Clarification findings are advisory uncertainty, not authoritative business requirements. Discovery may project them through existing `Research Findings`, `Assumptions`, `Risks`, `Unknowns`, confidence rationale, and advisory risk reporting. Discovery MUST NOT add a dedicated Clarification section.

## Decision-Boundary Contract

Clarification evidence MUST NOT change candidate generation, candidate scores, ranking, candidate ordering, recommendation totals, recommendation selection, Discovery schema, or ADR ownership. The Recommendation remains advisory and ADR remains the owner of decisions.

## Failure Contract

- Missing catalog or missing entry: continue normally with no warning requirement.
- Duplicate, stale, or path-mismatched catalog mapping: ignore clarification evidence and preserve existing Discovery behavior.
- Unreadable or malformed referenced artifact: ignore clarification evidence, record a deterministic advisory risk only when appropriate, and continue.
- Open findings: continue and treat them as advisory uncertainty; clarification completion is not required.
- Any clarification failure preserves all source and clarification bytes and never mutates Clarification state.

## Determinism Contract

For identical Request, catalog, Clarification artifact, governance baselines, and reference inputs, clarification resolution, evidence projection, confidence rationale, and Discovery output are byte-identical. No timestamp, recency, directory order, filesystem order, randomness, or environment state may influence the result.
