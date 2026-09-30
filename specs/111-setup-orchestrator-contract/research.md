# Research: Setup Orchestrator Contract Simplification

## Decision: Use owner contracts as the only domain authority

- **Decision**: Setup will route by owner readiness and consume owner-provided collection results.
- **Rationale**: The feature explicitly makes Profile, Objectives, Controls, and NFRs responsible for their own domain state, discovery, recommendations, persistence, and readiness.
- **Alternatives considered**: Retaining Setup-specific routing algorithms was rejected because it duplicates owner behavior and violates the owner-controlled orchestration boundary.

## Decision: Keep the change documentation- and contract-test-focused

- **Decision**: Update the canonical Markdown skill, focused shell contract tests, and generated documentation artifacts.
- **Rationale**: The repository is a shipped skill tree; this feature changes a runtime skill contract rather than application code or persistent application data.
- **Alternatives considered**: Adding a new runtime service or Setup checkpoint store was rejected because Setup must remain stateless and thin.

## Decision: Apply the shared governance contracts by reference

- **Decision**: Reference the Highway Skills Constitution and Highway Experience Standard rather than copying their generic rules.
- **Rationale**: The Constitution owns common failure handling and owner orchestration rules; the Experience Standard owns generic interaction behavior.
- **Alternatives considered**: Repeating those rules locally was rejected because it creates competing contracts and is explicitly out of scope.

No unresolved technical unknowns remain after inspection of the current Setup skill, owner-loop tests, generators, and governing documents.
