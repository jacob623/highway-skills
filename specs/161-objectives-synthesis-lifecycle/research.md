# Feature 161 Research: Objectives Synthesis Lifecycle

## Decision: Extend the existing source skill contract

- **Decision**: Add the synthesis-first lifecycle, discovery exception, Success Measure proposal guidance, queue boundaries, one-review rule, and queue example to `.highway/skills/highway-objectives/SKILL.md`.
- **Rationale**: The requested behavior is an interaction and authoring contract owned by the existing Objective skill. Keeping it in the source skill preserves the current ownership boundary and lets the existing adapter generator distribute it consistently.
- **Alternatives considered**: A new runtime module or separate queue service was rejected because the feature explicitly preserves Objective persistence, identifiers, catalogs, orchestration, and existing queue behavior.

## Decision: Keep the active queue transient

- **Decision**: Model the active Objective queue as transient ordered working state; do not add durable queue records, schema, identifiers, or catalog fields.
- **Rationale**: Selection determines development order only. Capture remains the existing owner-controlled acceptance and atomic persistence boundary.
- **Alternatives considered**: Persisting queue state was rejected because it would expand the feature into storage and recovery behavior that is explicitly out of scope.

## Decision: Use static contract verification plus existing regression suites

- **Decision**: Add a focused static-document contract test for lifecycle wording, proposal fields, queue boundaries, review count, and protected contracts; regenerate adapters and run the existing Objective and full suites.
- **Rationale**: The repository validates skill behavior through document-contract tests and generated-artifact checks. Static checks can verify authored guidance and adapter correspondence, while existing suites protect mutation and readiness behavior.
- **Alternatives considered**: Introducing a new runtime harness or external test dependency was rejected because no executable Objective runtime exists in this repository and the established Bash test harness is sufficient for the authored contract.

## Decision: Preserve the existing acceptance and convergence model

- **Decision**: Treat a Converged Objective proposal as the single review candidate, preserve user authority to refine or reject it, and keep discovery only for missing evidence or consequential ambiguity.
- **Rationale**: This aligns the feature with the Highway Experience Standard and the existing Objective skill's review, acceptance, correction, duplicate, overlap, and revalidation rules.
- **Alternatives considered**: Adding a second proposal or confirmation cycle was rejected because it would create redundant review and conflict with the requested one-review lifecycle.
