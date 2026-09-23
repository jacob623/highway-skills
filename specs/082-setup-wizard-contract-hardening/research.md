# Feature 082 Research: Setup Wizard Contract Hardening

## Decision 1: Keep Feature 081 as the behavioral baseline

- **Decision**: Treat the Feature 081 Setup Wizard skill, owner workflows, dashboard, and four-stage order as authoritative; Feature 082 adds explicit contract language and verification coverage only.
- **Rationale**: The requested changes correct ambiguity and strengthen evidence without changing the user-facing workflow or ownership model.
- **Alternatives considered**: Reimplementing Setup behavior was rejected because it would expand scope and risk changing established owner semantics.

## Decision 2: Omit numeric Step at completion

- **Decision**: When `Current Stage` is `Complete`, Setup emits no numeric `Step`.
- **Rationale**: Numeric steps identify active owner stages only; omitting the field avoids assigning completion to an owner stage that is no longer active.
- **Alternatives considered**: Retaining Step 4 was rejected because it conflates the NFR stage with the overall completed state.

## Decision 3: Use a deterministic User Exit and Owner Outcome classification table

- **Decision**: Document User Exits as `pause`, `cancel`, and `stop responding`; document Owner Outcomes as `declined`, `aborted`, and `blocked` in a deterministic classification table.
- **Rationale**: Explicit vocabulary prevents user actions from being confused with owner workflow results and supports stable tests.
- **Alternatives considered**: Relying on prose examples was rejected because terminology drift would be harder to detect.

## Decision 4: Preserve owner output order and bytes

- **Decision**: When an owner response contains informational output and a next question, present the informational output first and the question second, preserving owner content byte-for-byte except for Setup-owned progress framing.
- **Rationale**: Owner workflows remain authoritative for meaning, wording, and examples; Setup only frames and routes.
- **Alternatives considered**: Normalizing or summarizing owner output was rejected because it could alter semantics and invalidate owner-controlled guidance.

## Decision 5: Keep wizard state transient

- **Decision**: Setup never persists owner collection state, unanswered questions, draft responses, cancellation markers, or wizard checkpoints; later invocations use persisted owner readiness only.
- **Rationale**: A second Setup persistence model could conflict with owner artifacts and make resume behavior non-deterministic.
- **Alternatives considered**: Persisting wizard drafts or exact unanswered questions was rejected because those values are not authoritative owner state.

## Decision 6: Verify ownership explicitly

- **Decision**: Verification must prove Setup does not allocate identifiers, write catalogs, write owner artifacts, write candidate state, or write relationship state; mutations must originate from owner workflows.
- **Rationale**: These boundaries are central to the safety and maintainability of the wizard.
- **Alternatives considered**: Checking only the absence of direct file writes was rejected because it would not cover ownership of identifiers, candidates, catalogs, or relationships.

## Decision 7: Preserve the repository's validation split

- **Decision**: Use static document-contract assertions for wording and structure, executable fixtures for ordering and state behavior, focused Setup tests, generated-artifact validation, and the full suite.
- **Rationale**: The constitution requires static and executed-behavior evidence to remain distinct.
- **Alternatives considered**: Treating static text presence as proof of runtime behavior was rejected by the repository's verification rules.
