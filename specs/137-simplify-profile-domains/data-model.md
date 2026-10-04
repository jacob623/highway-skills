# Feature 137 Data Model

No retained schema change. Profile record schema remains 3.0.0 with readiness domains `identity`, `vision`, `competitive_path`, and `guiding_principles`.

## Retained entities

### Profile Domain

- **Fields**: existing readiness outcome and accepted cohesive narrative only.
- **Relationships**: Identity grounds Vision. Vision and Identity ground Competitive Path. All three ground Guiding Principles.
- **Validation**: A domain is retained accepted knowledge only after its accepted mutation succeeds.
- **States**: unresolved, discussed, or bounded. Acceptance authorizes the mutation. Success makes the domain available for later re-evaluation. Failure leaves it unpersisted and blocks dependent progression.

### Profile Record

- **Unchanged fields**: repository name, organization name, optional organization URL, and the four domain narratives owned by the shared template.
- **Prohibited additions**: acquisition sources, assistant-export metadata, source lists, tone, voice, style, persona, terminology guidance, Identity facets, Vision dimensions, Competitive Path dimensions, safeguard fields, Control fields, NFR fields, and reasoning or clarification state.

## Transient entities

### Acquisition Evidence

- **Source**: public website, organizational description, strategy material, assistant export or summary, pasted description, or other readable input the person supplies.
- **Rule**: Interpret across unresolved domains. Remains proposed until accepted. Does not need Profile headings or vocabulary.
- **Non-sources**: unspecified model memory, prior-agent memory, and information the agent cannot identify in the active interaction.

### Organizational Expression

- **Content**: terminology, recurring language, phrasing, formality, and other communication patterns.
- **Lifecycle**: available during the active Profile interaction only. The person's wording overrides it. It never becomes a retained field and does not control other owners.

### Working Idea and Converged Proposal

- **Working Idea**: transient developing understanding.
- **Converged Proposal**: complete candidate presented for acceptance.
- **Transition**: acceptance authorizes mutation; only mutation success retains the cohesive narrative.

### Volunteered Downstream Detail

- **Content**: safeguard, operational expectation, architecture, or implementation detail offered during Competitive Path.
- **Rule**: may inform the broad path. Not developed or retained as a safeguard, NFR, architecture, or implementation requirement.
