# Research: Final Objectives Cleanup

## Decision: Keep version 3.0.0

**Decision**: Keep the highway-objectives skill at 3.0.0 and leave objective-record.md unchanged.

**Rationale**: This work completes corrections to the already-planned 3.0.0 contract. The retained fields remain Statement, Success Measures, and Rationale, so no record schema change occurs.

**Alternatives considered**: Bumping to 3.1.0 or 4.0.0. Rejected because no new capability or retained-field change is introduced.

## Decision: Business Objective and Success are review prerequisites

**Decision**: Present the Objective review once Business Objective supports a Statement and Success supports at least one Success Measure. Ask Highway Relevance only when unresolved information would improve downstream Highway use.

**Rationale**: Highway Relevance is useful context but is not a required retained field and must not independently block Objective creation.

**Alternatives considered**: Require Highway Relevance before review. Rejected because it recreates the removed Significance gate under a new name.

## Decision: Synthesize Rationale from accepted evidence

**Decision**: Synthesize Rationale from accepted Business Objective, Success, Highway Relevance, and applicable accepted Profile evidence. Prefer the most direct accepted Objective evidence, then accepted Profile evidence that explains the downstream reason for the Objective. Use a concise rationale when that is all accepted evidence supports.

**Rationale**: The record requires Rationale, but Rationale is not a discovery dimension. A deterministic synthesis avoids a separate why-question and prevents unsupported facts.

**Alternatives considered**: Ask a separate Rationale question. Rejected because it restores Significance collection. Leave Rationale empty. Rejected because the retained record requires it.

## Decision: Recommendation selection remains acceptance

**Decision**: A selected recommendation is captured directly from the recommendation and its grounding evidence. Do not ask for confirmation or a separate Rationale answer. If required Success evidence is missing, ask only the unresolved Success question.

**Rationale**: The Experience Standard already treats selection as acceptance, and the 3.0.0 contract removed redundant confirmation.

**Alternatives considered**: Re-run the full captured-content review after selection. Rejected because it duplicates acceptance and may introduce unsupported synthesis.
