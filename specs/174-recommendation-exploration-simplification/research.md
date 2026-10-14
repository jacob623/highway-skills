# Research: Recommendation Exploration Simplification Pass

## Decision 1: Use the NFR exploration contract as the terminology reference

- **Decision**: Align Objective and Control wording with the existing NFR recommendation-exploration model, while replacing user-facing queue-processing language with review of selected artifacts.
- **Rationale**: The feature specification identifies NFRs as the existing reference behavior. A shared sequence reduces competing interpretations across the three owners without introducing a new workflow model.
- **Alternatives considered**: Define a fourth common abstraction or introduce a new persisted recommendation state. Both would expand scope and conflict with the requirement to preserve existing lifecycle and ownership boundaries.

## Decision 2: Keep queue mechanics internal and make review intent the user-facing boundary

- **Decision**: Retain queue membership, order, and sequential processing where the lifecycle requires them, but describe user-facing initiation as review of selected Objectives, Controls, or NFRs.
- **Rationale**: Queue membership is an internal orchestration mechanism and must remain distinct from proposal development, acceptance, and capture. Review language makes that boundary understandable without changing behavior.
- **Alternatives considered**: Remove queues entirely or expose queue processing as the primary user action. Removing queues would change lifecycle behavior; exposing them would preserve the competing path this feature is intended to remove.

## Decision 3: Treat Creation Workflow as a thin owner entry point

- **Decision**: Reduce each Creation Workflow to routing and continuation responsibilities: select the grounded recommendation or canonical question path, invoke exploration, hand off selected artifacts to review and the existing lifecycle, and continue until explicit finish.
- **Rationale**: Detailed behavior already has dedicated owners. Removing duplicated prose reduces contradiction risk and gives each rule one primary behavioral home.
- **Alternatives considered**: Keep duplicated lifecycle summaries for convenience. This was rejected because duplicate rules are the source of competing paths and are difficult to keep synchronized.

## Decision 4: Validate contracts statically and regenerate all derived surfaces

- **Decision**: Add or amend focused repository contract tests for the three authoritative skills, then run all declared generators and the complete test suite.
- **Rationale**: This repository ships Markdown skill contracts and generated adapters/catalogs. Static assertions are appropriate evidence for wording and ownership requirements, while generator correspondence checks prevent drift.
- **Alternatives considered**: Add runtime dependencies or build a separate workflow simulator. Neither is needed for this documentation-driven change and both violate the no-new-dependency and no-new-runtime-model scope.

## Resolved Planning Unknowns

- No external service, API, runtime package, database, or migration is required.
- No new persisted entity or lifecycle stage is required.
- The authoritative edit surface is `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, and `.highway/skills/highway-nfrs/SKILL.md`.
- Derived adapters and catalogs are regenerated through the existing repository generators.
- Validation uses the existing shell test suite plus focused recommendation-exploration contract checks.
