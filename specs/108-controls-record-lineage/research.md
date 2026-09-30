# Research: Controls Record Lineage Cleanup

## Decision 1: Use Recommendation Grounding as the canonical term

**Decision**: Replace retained-grounding uses of `Provenance` with `Recommendation Grounding`,
including the record heading and all Controls verification references.

**Rationale**: The retained content is lineage for a Highway recommendation, not a general
provenance or policy field. One term makes that boundary explicit.

**Alternatives considered**: Keeping `Provenance` was rejected because it is broader than the
specific retained meaning and obscures the recommendation boundary.

## Decision 2: Retain only materially influential sources

**Decision**: Recommendation Grounding is optional and is retained only when a Highway recommendation
materially influenced the accepted Control. It includes only sources that actually influenced that
recommendation, stable Highway artifact identifiers when available, and identifying references for
external expertise.

**Rationale**: Lineage should explain the accepted recommendation without turning every available
context source into organizational policy.

**Alternatives considered**: Listing all consulted context was rejected because unused context is not
causal grounding and would create misleading traceability.

## Decision 3: Keep lineage in the record body

**Decision**: Rename the optional body section to `## Recommendation Grounding`; keep it out of YAML
frontmatter and preserve `id`, `title`, `status`, and identifier-only `nfrs` frontmatter semantics.
Bump the template metadata from `1.0.0` to `2.0.0`.

**Rationale**: The retained section name is part of the record contract, so its rename is a schema
contract change. Body placement keeps operational metadata separate from lineage.

**Alternatives considered**: Keeping version `1.0.0` was rejected because the durable section contract
changes. Adding a frontmatter field was rejected by the feature requirements.

## Decision 4: Preserve the existing 4.0.0 Controls boundaries

**Decision**: Keep `highway-controls` at `4.0.0`, retain the four-field collection result without
`Created Control IDs`, keep one candidate-generation invocation after successful new Control creation,
and leave subsequent candidate state, review, persistence, and readiness with NFRs.

**Rationale**: These corrections complete the existing contract rather than introducing a new skill
version or ownership model.

**Alternatives considered**: Bumping Controls again or restoring transient IDs was rejected because
both contradict the already-planned 4.0.0 contract.

## Decision 5: Remove only duplicated instructions

**Decision**: Delete the first duplicated revalidation paragraph under Proposal and Persistence and
remove the local `A failed mutation cannot report success.` sentence. Keep the later revalidation
paragraph and rely on the Constitution's common failure model.

**Rationale**: The later paragraph is the authoritative domain-specific revalidation instruction;
common mutation failure is shared governance.

**Alternatives considered**: Retaining both revalidation paragraphs or a local failure reminder was
rejected because it creates competing instructions.
