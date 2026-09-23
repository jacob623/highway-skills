# Feature 080 Research

## Decision: Keep the authoritative source and existing validation boundary

- **Decision**: Amend `.highway/governance/experience-standard.md` and extend the existing shell checks under `.highway/tools/tests/`.
- **Rationale**: The specification names the Experience Standard as authoritative, and Feature 079 already established the X2 rows, N5 condition, and repository validation surface there.
- **Alternatives considered**: Adding a new runtime evaluator or changing skills was rejected because the feature is a documentation and validation correction and explicitly preserves skill behavior.

## Decision: Preserve Feature 079 rule semantics and use a documentation amendment

- **Decision**: Keep X2.1, X2.2-X2.6 rule obligations, `[agent-checkable]` tiers, samples, X namespace, PASS/FAIL/N/A vocabulary, and N5 condition unchanged; change only table placement, definitions, and example presentation.
- **Rationale**: FR-003 and FR-012 make Feature 079 the authoritative semantic baseline. The requested change improves reviewability without changing applicability or conformance meaning.
- **Alternatives considered**: Rewording X2.3/X2.4 obligations or adding a new N/A token was rejected because it would expand the amendment beyond representation and terminology correction.

## Decision: Use existing Bash 3.2-compatible static document checks

- **Decision**: Add focused assertions to the existing `rule-checks.test.sh` surface and retain the full `run-all.sh` suite as the completion check.
- **Rationale**: The repository's development constitution requires validation before and after edits, Bash 3.2 compatibility, and seeded evidence for new checks. Existing tests already parse the Experience Standard and report governance failures.
- **Alternatives considered**: Introducing Python or a new parser dependency was rejected because the current shell/toolchain is sufficient and the feature must not add runtime dependencies.

## Decision: No external contracts

- **Decision**: Do not create files under `contracts/`.
- **Rationale**: Feature 080 changes a repository governance document and its local validation checks; it exposes no API, CLI command schema, service endpoint, or external integration contract.
- **Alternatives considered**: A formal runtime or API contract was considered in the planning template but is inapplicable to this internal documentation change.

## Decision: Record the N/A example as its own two-column table

- **Decision**: Retain compliant and non-compliant examples for applicable behavior, then add a separate `Scenario | Example` table for the read-only status/no-long-running-activity case with `X2.5=N5` and `X2.6=N5`.
- **Rationale**: This directly satisfies FR-008 through FR-011 and prevents N/A from being visually classified as PASS or FAIL.
- **Alternatives considered**: Keeping the N/A scenario in either existing column was rejected because it is the defect Feature 080 is correcting.
