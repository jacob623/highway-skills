# Feature 085 Data Model

This feature introduces no persisted data model. It defines presentation states over existing owner readiness and outcome values.

## Setup Opening Experience

- **Inputs**: active owner workflow, owner-supplied next unresolved question, interaction state.
- **Output order**: welcome or resume greeting, owner introduction, one unresolved owner question.
- **Validation**: emitted only when user input is required; the question is presented after the owner introduction and before routine status or progress commentary.
- **Persistence**: none.

## Active Collection State

- **Inputs**: active owner and owner question.
- **Presentation**: `Owner Workflow` and `Question` conversational content without routine `Step`, `Stage`, completed-stage, remaining-stage, or current-activity framing.
- **Transition**: waits for one user response, forwards it to the owning workflow, and preserves existing owner outcome classification.

## Setup Outcome State

- **Values**: complete, blocked, declined, aborted, or explicit status request.
- **Presentation**: may include the existing dashboard or actionable owner context such as `Owner Workflow`, `Blocking Reason`, and `Next Action`.
- **Transition**: preserves existing terminality and safe-stop behavior; no downstream owner is invoked after a non-terminal stop.

## Completion Dashboard

- **Source**: existing highway-setup completion contract.
- **Contents**: ownership routes, governance destinations, and completion state.
- **Validation**: unchanged by this feature and emitted without a collection question when all required foundations are complete or not applicable.

## Relationships

- Setup selects the first incomplete owner using the existing Profile, Objectives, Controls, and NFR order.
- The active owner supplies the question wording and outcome.
- Setup supplies presentation ordering and status visibility only.
- No new authority, artifact, checkpoint, or persistence relationship is introduced.
