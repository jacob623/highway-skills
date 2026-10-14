# Data Model: NFR Alignment Refactor

The refactor changes interaction state and owner boundaries, not the persisted NFR record schema.

## NFR Recommendation

A transient operational expectation suggested from accepted repository context.

- **Source context**: accepted Profile, Objectives, Controls, or NFR portfolio evidence.
- **Provisional content**: title and operational expectation statement sufficient for selection or refinement.
- **State**: Working Idea until selected and processed through the NFR lifecycle.
- **Persistence**: never persisted directly as a recommendation.
- **Relationships**: an accepted Control may ground the recommendation; this does not transfer ownership.

## NFR Queue

An ordered transient collection of selected recommendations awaiting sequential development.

- **Entries**: one or more selected NFR Recommendations or a user-provided NFR.
- **Order**: selection order, preserved as additional recommendations are appended.
- **Transitions**: empty -> active on selection; active -> processing on recommendation exhaustion or explicit start; processing -> empty after the final capture.
- **Persistence**: queue membership does not create an NFR record, identifier, catalog entry, or relationship.
- **Operations**: select one, select several, select all, append later selections, process next, and abandon without capture.

## Converged NFR Proposal

A transient proposal developed from one queued recommendation or user-provided NFR.

- **Title**: concise name of the operational expectation.
- **Statement**: enforceable or checkable operational expectation.
- **Rationale**: why the expectation matters based on accepted context.
- **Lifecycle**: presented -> corrected/replaced/rejected/abandoned or accepted -> capture.
- **Persistence**: only an explicitly accepted proposal may be captured.

## NFR Record

The existing user-owned persisted NFR artifact.

- **Identity**: existing permanent NFR identifier.
- **Content**: existing NFR record fields and required shared template structure.
- **Relationships**: existing `controls` relationship field remains owned by the NFR record and preserves accepted Control references.
- **Catalog**: existing NFR catalog and allocation state remain authoritative.
- **Mutation**: existing add, update, remove, reset, duplicate, overlap, readiness, and destructive safeguards remain unchanged except where workflow entry changes.

## NFR Portfolio

The accepted set of NFR Records used for advisory synthesis.

- **Observations**: coverage, overlap, duplication, relationships, dependencies, gaps, tensions, and operational implications.
- **Authority**: advisory only; it cannot reject, block, mutate, or force completion.
- **Continuation**: after queue exhaustion, synthesis may be followed by additional suggestions or another NFR.
- **Persistence**: no separate portfolio artifact is introduced.

## NFR Coverage Area

Internal recommendation-diversity guidance.

- **Values**: Reliability, Availability, Performance, Scalability, Security, Compliance, Maintainability, Operability.
- **Purpose**: identify meaningful recommendation gaps.
- **Visibility**: internal only.
- **Persistence**: never retained as NFR data.
- **Lifecycle effect**: creates no readiness state, queue state, or development stage.

## Control-to-NFR Relationship

The existing relationship between accepted Controls and NFR records.

- **Direction**: accepted Controls can inform NFR recommendations.
- **Ownership**: NFR records retain their existing relationship field and NFR ownership.
- **Boundary**: recommendation influence does not automatically create, accept, or capture an NFR.
- **Compatibility**: existing accepted relationships are not silently rewritten by this refactor.
