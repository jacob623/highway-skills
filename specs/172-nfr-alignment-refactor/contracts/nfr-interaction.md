# NFR Interaction Contract

This contract describes the user-visible NFR owner behavior introduced by Feature 172. It does not add a network API or change the retained NFR record schema.

## Recommendation Exploration

When accepted context supports useful operational expectations, present a provisional recommendation set before requiring user invention.

The person may:

- select one recommendation;
- select several recommendations;
- select all recommendations;
- skip recommendations;
- provide a user-authored NFR;
- request additional suggestions.

Internal NFR Coverage Areas are not shown or persisted.

## Queue Construction

Selection appends recommendations to the active ordered queue. Selection does not develop, accept, capture, persist, allocate an identifier, or update the catalog.

Additional recommendations append only newly selected items and preserve existing queue order. Duplicate or overlapping suggestions remain subject to the existing NFR duplicate and overlap behavior.

## Exploration Exit

Recommendation exploration ends when one of these conditions is true:

1. No useful grounded recommendations remain.
2. The person provides their own NFR.
3. The person explicitly begins queue processing with language such as `Start with these`, `Process the queue`, `Capture the queue`, or `Let's review them`.

After exploration ends, the owner processes the active queue sequentially.

## NFR Development Lifecycle

Each queued recommendation or user-provided NFR follows:

```text
Queued Recommendation or User Provided NFR
↓
Present Converged NFR Proposal
↓
Acceptance
↓
Capture
↓
Next NFR
```

The proposal includes:

- Title
- Statement
- Why It Matters

Correction, replacement, rejection, cancellation, abandonment, or interruption leaves the proposal transient and writes no record.

## Queue and Acceptance Boundary

An NFR is captured only after its converged proposal is presented and explicitly accepted. Queue membership is never capture and never persistence.

Example:

```text
User:
Select all.

Owner:
The selected recommendations are added to the active NFR queue.

Queue membership does not capture NFRs.

They will be processed one at a time.
```

## Portfolio and Continuation

After the queue is exhausted, the owner may provide a concise advisory portfolio synthesis. It may discuss coverage, overlap, duplication, dependencies, gaps, tensions, and operational implications.

Portfolio synthesis does not reject NFRs, block progress, force completion, mutate the baseline, create a new lifecycle stage, or create a durable portfolio artifact. Additional suggestions and another NFR remain available while collection is active.

## Preserved Ownership

- NFR records, identifiers, catalogs, readiness, duplicate handling, overlap handling, and destructive safeguards remain NFR-owned.
- Accepted Controls remain recommendation context and do not create automatic NFR candidates.
- The existing NFR `controls` relationship field and accepted Control-to-NFR mappings remain intact.
