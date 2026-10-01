# Feature 117 Research: Experience Standard Alignment

## Decision 1: Treat the Experience Standard as the sole shared interaction authority

- **Decision**: Implement shared presentation and interaction changes in `.highway/governance/experience-standard.md`; keep Profile, Objectives, Controls, NFRs, and Setup domain workflows in their owner documents.
- **Rationale**: The standard's scope governs emitted user-visible interaction, while owner skills govern domain evidence, lifecycle, persistence, readiness, derivation, and orchestration. Copying those workflows would create competing contracts and violate the feature's explicit boundary.
- **Alternatives considered**: Updating every owner skill was rejected because it would duplicate domain semantics and expand the feature beyond the requested shared contract. Leaving the stale examples unchanged was rejected because they would continue to contradict current observables.

## Decision 2: Classify the amendment as MAJOR 6.0.0

- **Decision**: Change the standard from 5.0.0 to 6.0.0 and record the amendment as MAJOR.
- **Rationale**: X1.7, X2.9, X2.13, X2.25, X2.27, X2.28, X2.33, X2.34, and X2.35 are strengthened, clarified, or redefined in ways that can make previously conforming output fail. The standard's versioning policy explicitly classifies rule redefinition and strengthened obligations as MAJOR.
- **Alternatives considered**: MINOR was rejected because the change is not additive only. PATCH was rejected because the observables and required presentation order change.

## Decision 3: Preserve existing X identifiers and add none unless implementation proves necessity

- **Decision**: Keep all existing X identifiers stable and use the next available identifier, X2.36, only if a genuinely new observable obligation cannot be expressed by amending an existing rule.
- **Rationale**: Stable identifiers preserve traceability for existing tests and owner references. The current request is primarily alignment and clarification of existing obligations, so adding identifiers prematurely would create unnecessary contract surface.
- **Alternatives considered**: Renumbering or reusing retired identifiers was rejected because the standard forbids it. Assigning new identifiers to every wording improvement was rejected because it would turn amendments into duplicate rules.

## Decision 4: Validate with focused static-document tests and the full suite

- **Decision**: Update the existing Experience Standard amendment and UX-alignment tests, then run those focused tests and `.highway/tools/tests/run-all.sh`.
- **Rationale**: Existing tests pin version metadata, rule text, examples, and interaction observables. The full runner discovers all repository contract tests and catches cross-artifact regressions.
- **Alternatives considered**: Adding a new runtime harness was rejected because this feature changes governance documents and their static contract assertions, not an executable application.

## Decision 5: Do not create external contracts

- **Decision**: Omit `contracts/` because the repository exposes no external API or protocol for this feature.
- **Rationale**: The deliverable is a Markdown governance contract consumed by Highway skills and shell validation tests. Its user-visible interaction contract is documented in the standard and represented in the data model and quickstart.
- **Alternatives considered**: Creating an API-style contract was rejected because it would misrepresent the artifact and add implementation noise.

## Decision 6: Preserve Bash 3.2 compatibility

- **Decision**: Keep validation scripts compatible with macOS's default Bash 3.2 and existing repository shell conventions.
- **Rationale**: The repository explicitly targets macOS development and its Constitution constrains the shell toolchain. No new shell feature is required for this document amendment.
- **Alternatives considered**: Requiring a newer Bash was rejected because it would add an unnecessary environment dependency to static governance validation.
