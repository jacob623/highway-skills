# Research: Clarification Determinism and Lifecycle Contracts

## Decision 1: Keep the contracts in the existing Clarify skill

**Decision**: Add the ambiguity and contradiction contract sections directly to `.highway/skills/highway-clarify/SKILL.md` in the requested order, immediately after `Inputs`. Add the Finding Identity Contract immediately before `Workflow`.

**Rationale**: Feature 066 already treats the skill contract as the authority for Clarify inputs, outputs, ordering, validation, and failure behavior. A separate vocabulary or rule template would create a second structure to keep synchronized and would exceed the requested scope.

**Alternative rejected**: A new shared vocabulary template or a new rule-authoring artifact would add an ownership surface without being required by the feature. Existing Clarification Profiles and declared contradiction rules remain the extension points.

## Decision 2: Normalize ambiguity terms by trim and case-fold, then compare exactly

**Decision**: Normalize the candidate phrase by removing leading/trailing whitespace and applying case-insensitive comparison. Compare the complete normalized phrase to the default vocabulary plus append-only profile extensions.

**Rationale**: This directly satisfies the requested matching contract and is deterministic across repeated runs. It excludes substring, partial-word, regular-expression, and semantic matching without requiring a scoring mechanism.

**Alternative rejected**: Regex, substring, fuzzy, and semantic matching introduce additional interpretation and can produce findings that cannot be explained by the declared vocabulary.

## Decision 3: Contradictions require declared rules and both source fields

**Decision**: Treat a contradiction rule as the complete authority for contradiction findings. The workflow may emit a finding only when the rule is in the declared rule set, both referenced fields exist, and its explicit condition evaluates true.

**Rationale**: The current skill already routes contradiction analysis through declared profiles/rules and explicitly excludes model inference. The new contract makes that boundary testable without inventing a new rule authoring format.

**Alternative rejected**: General knowledge, architecture recommendations, semantic similarity, probability, or model judgement would make identical inputs dependent on undeclared context.

## Decision 4: Store finding identity state with the clarification record

**Decision**: Derive a deterministic fingerprint from category, source field or section, and evidence reference. Persist the fingerprint-to-identifier association and retired sequence identifiers with the clarification artifact so updates can reuse unchanged IDs and prevent retired-ID reuse.

**Rationale**: The clarification artifact is the authoritative lifecycle record. Local identity history avoids introducing a global registry and keeps identity changes transactional with the clarification update.

**Alternative rejected**: Allocating by display position renumbers findings after reordering. Reusing the lowest unused sequence number violates the retired-identifier rule. A content-only fingerprint is too sensitive to wording edits.

## Decision 5: Evaluate status by an explicit precedence list

**Decision**: Evaluate `blocked`, then `complete`, then `in-progress`, then `not-started`; stop at the first matching condition. Presence plus structural validity is evaluated before open-finding counts.

**Rationale**: A malformed artifact must not appear complete merely because its count is zero. An explicit ordered list makes the one-status result deterministic and reviewable.

**Alternative rejected**: Independent boolean checks or count-first evaluation can produce conflicting statuses or allow malformed records to report completion.

## Decision 6: Bootstrap uses the same catalog validation path

**Decision**: When `clarifications/clarifications.md` is absent, construct an in-memory catalog from `.highway/library/templates/output/clarification-catalog.md`, insert the proposed row, validate it as an existing catalog, and write only after clarification and catalog validation succeed.

**Rationale**: The first-use path must have the same structural, reference, duplicate, supported-value, status, ordering, and byte-preservation guarantees as later updates.

**Alternative rejected**: Copying or editing the template directly, or using a reduced bootstrap validator, creates a weaker path and risks partial writes.

## Decision 7: Clarification Path is an informational derived value

**Decision**: Add `Clarification Path` to the catalog row and derive it from the authoritative clarification artifact path. Validate that it resolves directly to that artifact; do not make the path a second source of identity or ownership.

**Rationale**: The path improves lookup while preserving Feature 066's `CLAR-<ARTIFACT-ID>` identity and artifact ownership. Catalog content remains deterministic because the path is derived from repository state.

**Alternative rejected**: A path derived from catalog-only naming or an optional unresolved value would allow stale or ambiguous links.

## Decision 8: Versioning and generated artifacts

**Decision**: Keep the catalog template metadata at `1.0.0` and advance `highway-clarify` metadata from `1.2.0` to `1.3.0`. Regenerate adapters and catalog indexes after canonical shipped inputs change.

**Rationale**: The feature adds behavior contracts and lifecycle guarantees to the skill but does not change command syntax, artifact ownership, or supported artifact types. The requested catalog path is an additive informational column while the template version remains explicitly fixed by the specification.

**Validation baseline**:

- `.highway/tools/validate-skill.sh .highway/skills/highway-clarify`
- `.highway/tools/validate-library.sh .highway/library/templates/output/clarification-catalog.md`
- `.highway/tools/tests/highway-clarify.test.sh`
- `.highway/tools/tests/output-template.test.sh`
- `.highway/tools/tests/adapter-coverage.test.sh`
- Serialized full suite using the repository's 200-second macOS-compatible Perl alarm wrapper.
