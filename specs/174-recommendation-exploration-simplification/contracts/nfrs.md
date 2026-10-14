# NFR Recommendation Exploration Contract

## Primary Owners

- Recommendation Presentation presents grounded NFR Working Ideas.
- Recommendation Exploration owns selecting, extending, and exhausting recommendation sets.
- NFR Queue and Acceptance Boundaries distinguish selected NFRs from review, acceptance, and capture.
- NFR Development Lifecycle owns proposal development, correction, acceptance, capture, continuation, and explicit finish.

## Review Boundary

Review of selected NFRs begins only when recommendation exploration is exhausted or the person
explicitly asks to review the selected NFRs. Selecting an NFR alone does not begin review, proposal
development, acceptance, or capture.

## Creation Workflow Handoff

Creation Workflow invokes the primary owners in sequence and retains only the canonical no-recommendation
question path, continuation routing, and explicit-finish routing. It does not repeat recommendation,
queue, lifecycle, acceptance, or capture rules.

## User-Facing Language

Use review language for selected NFRs. Internal queue membership and sequential processing may remain
implementation concepts, but user-facing examples must not instruct the person to process or capture a queue.
