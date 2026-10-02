# Feature 127 Conceptual Data Model

This feature introduces no persisted data, storage, API, schema, or retained artifact type. The model below describes the concepts whose relationships the Experience Standard presents to users.

## Working Idea

A transient developing interpretation, recommendation, alternative, implication, or related thread.

**Attributes**:

- current meaning or direction;
- relevant accepted context;
- useful distinctions, implications, relationships, tensions, or alternatives;
- person's response and subsequent refinement.

**Lifecycle**: begins from a contribution or grounded recommendation; may be interpreted, sharpened,
challenged, expanded, narrowed, split, combined, replaced, or abandoned; may converge into a
Converged Proposal or stop when further development adds no value.

**Persistence**: none is required while it remains a Working Idea.

## Active Reasoning Context

Transient, task-anchored context used to organize relevant Working Ideas, unresolved questions,
implications, alternatives, tensions, and contributions during the active interaction.

**Relationship**: contains or relates Working Ideas without becoming a required reasoning file or
user-visible state label.

**Persistence**: not persisted by this feature; visible commentary does not narrate its internal
organization.

## Converged Proposal

A complete candidate artifact or artifact set that the owning workflow can present at an applicable
acceptance boundary.

**Attributes**:

- complete candidate content as determined by the owner;
- presentation context;
- applicable acceptance boundary;
- available user-authored alternative.

**Relationship**: may be produced from a Working Idea when further development has converged. It is
not created merely because a person agrees with a Working Idea.

## Artifact Acceptance Boundary

The decision point at which an owner may treat a complete candidate as accepted user-owned knowledge.

**Relationship**: a Converged Proposal is presented before this boundary; explicit selection of that
presented complete candidate crosses the boundary without redundant confirmation. Requests for
explanation, comparison, refinement, or additional information do not cross it.

## Accepted Knowledge

User-owned knowledge that has crossed the applicable Artifact Acceptance Boundary.

**Relationship**: can be persisted by the owner under existing domain behavior and re-enters the
relevant context for post-acceptance Contextual Re-evaluation.

## Contextual Re-evaluation

Reconsideration of new or accepted information together with relevant accumulated context.

**Possible outcomes**:

- useful interpretation or sharpening;
- grounded contribution or recommendation;
- continued Working Idea development;
- presentation of a Converged Proposal;
- one needed question;
- natural conclusion when no useful addition or unresolved need remains.

**Constraint**: it does not require a fixed acknowledgment formula and does not narrate persistence,
state transitions, routing, or processing.

## Owner

The skill or workflow responsible for domain completeness, acceptance handling, and persistence of its
governed artifact or artifact set.

**Authority**: determines whether a candidate is domain-complete and owns the resulting artifact
content and persistence behavior. The Experience Standard governs the user-visible collaboration
around that authority; it does not define individual domain schemas.
