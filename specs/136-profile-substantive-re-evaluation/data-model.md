# Feature 136 Data Model

Feature 136 adds no retained fields. The following entities describe transient reasoning and the existing accepted Profile boundary.

## Substantive Contribution

A person response that adds, changes, corrects, removes, qualifies, redirects, or otherwise supplies information that can change active Profile understanding.

- **Lifecycle**: received -> re-evaluated -> incorporated, clarified, converged, or routed to the next justified behavior.
- **Retention**: never retained directly; only accepted cohesive domain evidence or an explicit accepted correction/replacement is retained.

## Working Idea

Transient reasoning for the active Profile subject. It can be interpreted, sharpened, connected, corrected, clarified, redirected, or abandoned.

- **Relationships**: receives Substantive Contributions; may contain Identity Facets; informs a Converged Proposal.
- **Retention**: transient until the existing acceptance boundary is satisfied.

## Identity Facet

A provisional meaningful aspect of durable organizational activity or purpose used to make materially assembled Identity inspectable.

- **Relationships**: grouped within an Identity Working Idea; may be corrected, removed, extended, or redirected by a Substantive Contribution.
- **Validation**: no mandatory count, category, field, or technology inventory.
- **Retention**: not a schema field; only its accepted meaning may be synthesized into cohesive Identity evidence.

## Conversational Clarification

One focused transient question that resolves consequential uncertainty when the person's information is required to distinguish materially different interpretations.

- **Relationships**: follows re-evaluation; remains separate from another discovery question, Contribution Opportunity, and domain acceptance.
- **Retention**: no clarification identifier, record, catalog, or state; deterministic clarification artifacts remain owned by `highway-clarify`.

## Contribution Opportunity

A transient opportunity to add, correct, remove, qualify, extend, or redirect materially developed substance before convergence.

- **Relationships**: may follow provisional Identity facets or materially shaped Vision, Competitive Path, or Guiding Principles substance.
- **Validation**: resolving a clarification does not satisfy it unless the same interaction gave equivalent room to change the broader substance.
- **Retention**: does not authorize persistence or acceptance.

## Converged Proposal

A complete candidate domain representation that answers the active domain purpose coherently without unsupported facts.

- **Transition**: Working Idea -> Converged Proposal -> existing domain acceptance or correction path.
- **Retention**: only after explicit or natural acceptance under the existing owner-controlled boundary.

## Accepted Profile Knowledge

User-supplied, selected, or accepted cohesive domain evidence in the retained Profile.

- **Shape**: exactly `identity`, `vision`, `competitive_path`, and `guiding_principles`, each with existing `not_discussed`, `discussed`, or `bounded` outcomes.
- **Version**: schema `3.0.0`.
- **Relationships**: informs later contextual re-evaluation, especially full-Identity Vision and Identity/Vision relationship reasoning for Competitive Path.
