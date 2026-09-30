# Research: Controls Skill Update

## Decision 1: Keep generic interaction rules in shared governance

**Decision**: The rewritten Controls skill will state only Control-specific behavior and cite the
Highway Experience Standard and Skills Constitution for generic questions, recommendations,
acceptance, progress, acknowledgments, failure, and context rules.

**Rationale**: The requested change removes duplicated runtime guidance and development-only
compliance material. Keeping the shared documents authoritative prevents contradictory local rules.

**Alternatives considered**: Retaining a local interaction contract was rejected because it would
reintroduce the duplication and maintenance drift the feature is intended to remove.

## Decision 2: Use evidence-first discovery

**Decision**: Concern, Condition, and Obligation remain transient reasoning categories. Controls
evaluates all accepted evidence before each follow-up, asks only for missing information, routes
clearly NFR-shaped intent to NFRs, and proceeds when a safeguard can be constructed without invented
policy.

**Rationale**: This preserves ordinary user language and avoids asking users to restate understood
requirements in a formal schema.

**Alternatives considered**: A fixed three-question sequence was rejected because it treats internal
categories as user obligations and creates unnecessary questions.

## Decision 3: Remove transient Created Control IDs from collection results

**Decision**: The Controls collection result contains only fields required for continuation,
termination, and owner routing. `Created Control IDs` is removed. Setup uses collection status and
fresh readiness rather than cumulative identifiers.

**Rationale**: The identifiers were legacy coordination state and are not needed to determine whether
collection continues or whether the persisted baseline is ready.

**Alternatives considered**: Retaining cumulative IDs was rejected by clarification because it
preserves transient cross-owner state without being necessary for routing.

## Decision 4: Version the breaking skill contract

**Decision**: `highway-controls` metadata changes from `3.0.0` to `4.0.0`. Unrelated catalog and
record template versions remain unchanged unless their own structures change.

**Rationale**: The interaction, output, persistence-verification, continuation, and NFR handoff
contracts are intentionally redefined, which is a MAJOR skill change.

**Alternatives considered**: Keeping `3.0.0` was rejected because it would misrepresent a breaking
contract change.

## Decision 5: Persist recommendation provenance in an optional body section

**Decision**: Add an optional `## Provenance` section to the retained Control record body. It records
accepted repository context or declared external expertise that grounded a recommendation. It is
never placed in YAML frontmatter and is omitted when no recommendation grounding applies.

**Rationale**: Body content preserves future traceability while keeping frontmatter limited to the
record's identity and operational metadata.

**Alternatives considered**: Transient-only provenance was rejected because it would not support
future traceability. A separate artifact was rejected because it would add a new ownership and
relationship contract.

## Decision 6: Keep the NFR boundary narrow

**Decision**: Controls invokes NFR-owned candidate generation once after a successfully created new
Control and consumes only its declared result. NFRs retains candidate state, classification, review,
accepted artifacts, identifiers, readiness, and completion.

**Rationale**: This preserves ownership and avoids copying NFR internals into Controls.

**Alternatives considered**: Embedding candidate state or review mechanics in Controls was rejected
because it would create competing ownership and recovery behavior.
