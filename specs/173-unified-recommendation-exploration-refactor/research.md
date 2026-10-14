# Research: Unified Recommendation Exploration Refactor

## Decision 1: Use the NFR recommendation-exploration model as the shared owner pattern

**Decision**: Apply the established NFR sequence to Objectives and Controls: recommendation development, exploration, queue construction, exhaustion or explicit queue start, queue processing, proposal development, acceptance, and capture.

**Rationale**: Feature 173 explicitly aligns the two owners with the already validated NFR behavior. Reusing the vocabulary and boundaries avoids a second lifecycle model and keeps selection distinct from proposal development and capture.

**Alternatives considered**: Preserve immediate processing after selection; rejected because it prevents additional recommendation exploration and makes selection behave like processing.

## Decision 2: Keep lineage recommendation-oriented and ownership-independent

**Decision**: Accepted Profile evidence informs Objective recommendations, and accepted Objectives inform Control recommendations. Neither upstream context creates downstream records or transfers ownership.

**Rationale**: The owner that receives the recommendation remains responsible for proposal development, acceptance, capture, persistence, identifiers, and readiness. This preserves the repository's independent Objective and Control baselines.

**Alternatives considered**: Automatically create downstream Objectives or Controls from accepted upstream context; rejected because it introduces ownership transfer and automatic record creation outside the requested scope.

## Decision 3: Treat recommendation exploration and queue membership as transient interaction concepts

**Decision**: Recommendations under evaluation are not queue members. Selected recommendations enter the active owner queue, which may continue growing while exploration remains active. Queue membership determines processing order only and does not imply proposal development or capture.

**Rationale**: This gives the person control over recommendation breadth without adding persisted candidate state, new records, or new lifecycle stages.

**Alternatives considered**: Persist candidate or review states for each recommendation; rejected because the feature explicitly preserves the existing persistence model and avoids candidate lifecycle concepts.

## Decision 4: Centralize queue-processing start conditions in Recommendation Exploration

**Decision**: Queue processing begins only after recommendation exhaustion or an explicit queue-processing request. Creation Workflow references this contract rather than restating the trigger logic.

**Rationale**: One authoritative rule prevents Objective and Control workflows from drifting and makes transcript and contract validation deterministic.

**Alternatives considered**: Begin processing after the first selection or after `Collection Result: Continue`; rejected because both collapse exploration into processing and violate the requested continuation behavior.

## Decision 5: Preserve existing proposal, acceptance, capture, and persistence boundaries

**Decision**: User-provided Objectives and Controls follow their existing proposal and acceptance paths. Captured records, identifiers, catalogs, relationships, readiness, and destructive safeguards remain unchanged.

**Rationale**: Feature 173 is a behavioral and contract alignment change, not a data-model or persistence redesign.

**Alternatives considered**: Add a new queue persistence layer or a new lifecycle stage; rejected because no new storage or lifecycle concept is required.

## Decision 6: Validate through focused owner tests and generated correspondence

**Decision**: Extend the existing Objective and Control contract tests for lineage, exploration, exhaustion, queue membership, continuation, and freeze behavior. Regenerate all adapters and catalogs, then run focused tests and the full suite.

**Rationale**: The repository already validates source-first skill contracts and generated artifact correspondence. Reusing those checks provides coverage without creating a parallel harness.

**Alternatives considered**: Add a separate runtime implementation or external API test suite; rejected because the feature has no runtime service or external protocol.
