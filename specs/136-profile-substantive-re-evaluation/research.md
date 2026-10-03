# Feature 136 Research

## Decision: Amend the Profile skill contract, not the retained Profile schema

- **Rationale**: The requested behavior is conversational reasoning and routing. The authoritative record remains the four readiness domains in `profile-record.md`, schema version 3.0.0. Working Ideas, Identity facets, clarification reasoning, and Contribution Opportunities remain transient.
- **Alternatives considered**: Adding facet, ambiguity, or reasoning fields to the record was rejected by FR-021 through FR-023 and would move transient Profile ownership into the shared template.

## Decision: Classify the skill amendment as MINOR, version 5.2.0 to 5.3.0

- **Rationale**: The feature adds substantive re-evaluation, selective clarification, fuller Identity development, and downstream relationship reasoning while preserving existing Inputs, Outputs, readiness states, schema, acceptance, and persistence boundaries. The Skill Versioning Policy defines this as a capability addition without a breaking contract change.
- **Alternatives considered**: PATCH was rejected because user-visible behavior and Verification obligations change. MAJOR was rejected because no existing contract or behavioral guarantee is removed or made incompatible.

## Decision: Use material assembly or interpretation, not a facet count, as the Identity threshold

- **Rationale**: The spec requires provisional facets when Profile materially assembles or interprets website, multi-source, or substantial evidence, while allowing direct domain-complete user Identity to converge. A fixed count or mandatory category list would force artificial interaction and violate the no-fixed-facets boundary.
- **Alternatives considered**: Requiring facets for every Identity response was rejected because it would break direct complete contributions. Requiring a numeric evidence threshold was rejected because the evidence is qualitative and the existing skill uses responsible interpretation rather than collection quotas.

## Decision: Keep provisional Identity facets as inspectable substantive pieces

- **Rationale**: Meaningful organizational activities and purpose are the smallest useful shape for a person to identify missing, incorrect, overstated, or incomplete understanding. The interaction remains illustrative, not a retained schema or fixed taxonomy.
- **Alternatives considered**: A fixed business-line or offering model was rejected because it would add schema concepts and encourage technology-estate inventory.

## Decision: Treat consequential relationship ambiguity as the clarification boundary

- **Rationale**: Profile incorporates one responsible interpretation directly. It asks one focused Conversational Clarification only when materially different interpretations can change the active result and the person's information is required. This directly consumes X2.38-X2.40 and preserves one-question behavior.
- **Alternatives considered**: Asking a clarification after every new facet was rejected as ceremonial. Deferring every relationship until acceptance was rejected because Vision and Competitive Path must use useful relationships during active reasoning.

## Decision: Evaluate relevant context across all four domains before routing

- **Rationale**: Acquisition already processes responses, recommendations, and validated discoveries across all four domains. Feature 136 makes the re-evaluation step explicit, while downstream behavior uses the active Working Idea and relevant accumulated context. This preserves P12A.4 without creating cross-domain retained state.
- **Alternatives considered**: Restricting each response to the current domain was rejected because new organizational evidence can affect unresolved Vision, Competitive Path, or Guiding Principles.

## Decision: Add static source-contract assertions and regenerate distributed artifacts

- **Rationale**: This repository defines skills as Markdown contracts and validates them with Bash tests. The implementation needs deterministic assertions for re-evaluation, Identity facets, clarification boundaries, full-Identity reasoning, technology exclusion, transient state, and protected paths. Source adapters and catalogs are generated artifacts and must be refreshed from the source.
- **Alternatives considered**: A runtime integration test was rejected because Profile behavior is defined in the skill contract and has no executable service implementation. A new external contract was rejected because no public API, persistence schema, or ownership boundary changes.

## Resolved dependencies

Feature 135 supplies X2.38-X2.40, Feature 134 supplies Contribution Opportunity behavior, and the existing Profile synchronization contracts supply the accumulated-context model. No extension hooks are registered. Protected artifacts remain unchanged.
