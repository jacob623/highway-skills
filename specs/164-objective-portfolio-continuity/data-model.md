# Feature 164 Data Model: Objective Portfolio Continuity

This feature introduces no persisted data. These entities describe transient guidance boundaries.

## Accepted Objective Set

- **Represents**: Objectives that have completed User Acceptance and capture.
- **Constraint**: Only captured Objectives contribute to synthesis.

## Portfolio Synthesis

- **Represents**: A brief advisory description of accepted Objective coverage and, when useful, how the newest Objective fits.
- **Attributes**: Coverage summary, optional newest-Objective fit, optional next-Objective cue.
- **Constraint**: It does not contain full Objective contents or become a review, proposal, recommendation set, or detailed portfolio assessment.

## Transition Contexts

- **Queued Objective Transition**: Synthesis may occur after capture and before the next queued Objective activity.
- **Collection Continuation Transition**: Synthesis may occur after capture and before the continuation question.
- **Setup Transition**: Synthesis may occur after accepted collection and before safeguards or another downstream setup activity.

## Protected Invariants

- No synthesis occurs before capture or implies User Acceptance.
- Existing lifecycle sequence, proposal contents, capture semantics, user authority, and collection finish behavior remain unchanged.
- No new lifecycle state, Objective field, durable queue, portfolio artifact, or computed score is introduced.
- Existing additional-suggestions reassurance remains available during active collection.
- Generated adapters remain equivalent identity copies of the source.
