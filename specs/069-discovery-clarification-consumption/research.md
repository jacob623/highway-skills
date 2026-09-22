# Feature 069 Research

## Decision 1: Use a dedicated Discovery consumer contract

- **Decision**: Add `contracts/clarification-consumption-contract.md` for the cross-skill read-only interface.
- **Rationale**: `highway-clarify` already owns the Clarification artifact and catalog contracts. Discovery needs a focused consumer contract for lookup, fields, precedence, advisory projection, failure fallback, and ownership boundaries without duplicating the producer contract.
- **Alternatives considered**: Inline all rules in `SKILL.md`; rejected because the contract spans inputs, evidence precedence, failure behavior, and testable ownership boundaries and would make the skill document harder to review.

## Decision 2: Resolve only through the Clarification Catalog

- **Decision**: After resolving a completed Request, derive `CLAR-<REQ-ID>`, read `clarifications/clarifications.md`, and follow the matching `Clarification Path`. A missing catalog or row means no clarification evidence.
- **Rationale**: The Clarification catalog is the authoritative inventory and prevents recency, timestamp, directory-order, or duplicate-file selection. The existing Clarification contract already defines stable identifiers and direct artifact paths.
- **Alternatives considered**: Search the `clarifications/` directory or select the newest artifact; rejected because those approaches are nondeterministic and violate catalog ownership.

## Decision 3: Consume a bounded read-only field set

- **Decision**: Discovery reads status, open and resolved findings, finding summaries, responses, and blocking reason, after validating the catalog mapping and artifact structure. It does not interpret or mutate Clarification lifecycle state.
- **Rationale**: These fields provide the requested traceability and uncertainty evidence while preserving Clarification ownership of detection, response capture, status, and lifecycle.
- **Alternatives considered**: Re-run clarification analysis or infer findings from the Request; rejected because it duplicates producer ownership and could diverge from the authoritative artifact.

## Decision 4: Project evidence into existing Discovery sections

- **Decision**: Responses may add Research Findings; open findings may add Assumptions and Unknowns; findings may add Risks and confidence rationale. No dedicated Clarification section or Discovery schema change is introduced.
- **Rationale**: The existing Discovery record already has the required evidence categories, and this preserves downstream ADR compatibility.
- **Alternatives considered**: Add a Clarification section; rejected because the feature explicitly preserves the Discovery record contract and keeps clarification evidence advisory.

## Decision 5: Keep clarification outside scoring and recommendation selection

- **Decision**: Clarification evidence can affect explanatory rationale, risk reporting, and confidence explanation, but never candidate generation, scores, ranking, ordering, recommendation totals, or recommendation selection.
- **Rationale**: Clarification responses are higher-precedence advisory evidence than other baselines, but they are not authoritative business requirements. This preserves the existing Discovery decision boundary and deterministic comparison behavior.
- **Alternatives considered**: Feed clarification responses into score inputs; rejected because it changes established scoring ownership and violates the feature's explicit non-goals.

## Decision 6: Graceful fallback is field- and artifact-scoped

- **Decision**: Missing catalog, missing entry, or unavailable optional clarification continues silently without clarification evidence. An unreadable or malformed referenced artifact is ignored and may produce one deterministic advisory risk when appropriate; it never blocks Discovery or triggers repair.
- **Rationale**: Clarification is optional, and existing Discovery prerequisites remain sufficient. A referenced-but-invalid artifact is distinguishable from ordinary absence and should preserve uncertainty visibility without creating a hard dependency.
- **Alternatives considered**: Abort Discovery on any clarification problem; rejected because it makes an optional producer a prerequisite and violates the non-goals.

## Decision 7: Verify behavior with focused fixtures and repeatability

- **Decision**: Extend `.highway/tools/tests/highway-discovery.test.sh` with disposable fixtures for catalog-backed resolution, absent/missing entries, malformed/unreadable artifacts, open/resolved findings, response precedence, non-mutation, and repeated identical outputs. Preserve the existing probe classes and Bash 3.2.57 toolchain.
- **Rationale**: The repository's current Discovery test already validates static contracts and executed fixture behavior. Focused additions provide behavioral evidence without adding a runtime dependency or broadening the test harness.
- **Alternatives considered**: Add a new test runner or external parser; rejected because the suite is Bash-based and the feature can be validated with existing shell utilities and fixtures.

## Resolved planning unknowns

- Consumer contract location: `specs/069-discovery-clarification-consumption/contracts/clarification-consumption-contract.md`.
- Advisory risk trigger: only a referenced artifact that is unreadable or malformed, when the failure is relevant to the current analysis; absent catalog and absent entry remain valid no-warning paths.
- Discovery representation: existing Research Findings, Assumptions, Risks, Unknowns, confidence rationale, and advisory risk reporting only.
- Test location: the existing `highway-discovery.test.sh`, with disposable fixtures and the repository's established probe conventions.
