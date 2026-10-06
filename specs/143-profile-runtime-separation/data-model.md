# Feature 143 Data Model

Feature 143 changes the runtime instruction model; it does not add retained Profile fields or schema values.

## Profile Domain

One of the four retained readiness domains:

- `identity`: who the organization is and what it meaningfully encompasses.
- `vision`: the future the organization is trying to create.
- `competitive_path`: the broad organizational approach toward the accepted Vision.
- `guiding_principles`: enduring principles that shape organizational decisions.

**State values**: `not_discussed`, `discussed`, or `bounded`.

**Validation**:

- `discussed` requires accepted evidence establishing the domain narrative.
- `bounded` requires an explicit user decision not to establish further evidence.
- Missing evidence, uncertainty, failed discovery, and `I don't know` do not establish `bounded`.
- Complete readiness requires every domain to be `discussed` or `bounded`.

## Acquisition Evidence

Transient user-supplied or supported public-website material used to reason about one or more unresolved Profile domains.

**Rules**:

- Evidence can support multiple domains and need not match Profile headings, schema, or terminology.
- Evidence remains proposed until it crosses the existing Profile acceptance boundary.
- A supplied Organization URL may be accepted optional Context; derived organizational facts remain proposed.
- Acquisition evidence is limited to organizational Profile meaning and is not a technology inventory.
- Source metadata and source-precedence state are not retained.

## Organizational Expression

Transient terminology, phrasing, formality, and related guidance that can shape representation of supported Profile meaning.

**Rules**:

- Expression affects representation, not truth.
- Active user wording and corrections take precedence.
- Expression cannot establish unsupported facts, strategy, priorities, intentions, or principles.
- Expression is not retained as tone, voice, persona, style, terminology, or Organizational Context fields.

## Profile Domain Candidate

A coherent supported narrative for one Profile domain.

**Lifecycle**:

1. Relevant accepted and active evidence is evaluated.
2. Profile determines whether the domain meaning is complete.
3. The Experience Standard determines whether collaborative development has converged.
4. The owning Profile interaction presents the candidate for the existing validation and acceptance boundary.
5. Successful owner mutation makes accepted knowledge available to later Profile reasoning.

Completeness alone does not establish convergence or acceptance.

## Transient Working Material

Working Ideas, provisional facets, themes, strategic pieces, principle lists, rejected alternatives, unaccepted advisory commentary, presentation headings, and organizational-expression guidance.

**Retention**: Never retained unless the person incorporates the relevant meaning into accepted Profile evidence.

## Accepted Profile Mutation

The owner-controlled persistence operation that applies accepted Profile domain narratives, accepted corrections or replacements, explicit accepted domain boundaries, and permitted optional Context.

**Rules**:

- Acceptance authorizes mutation but is not successful persistence.
- Dependent readiness, completion, and progression wait for successful mutation.
- Mutation failure prevents dependent terminal output and does not establish accepted persisted knowledge.
- No additional post-write read-back stage is introduced.

## Readiness Result

An internal classification with `Status`, `Summary`, `Next Action`, and `Blocking Reason` fields.

**Transitions**:

- No retained artifact -> `Missing`, next action `/highway-profile setup`.
- Malformed, contradictory, or structurally invalid artifact -> `Blocked`, next action `None`, unchanged artifact.
- Valid artifact with any `not_discussed` domain -> `Missing`, next action `/highway-profile configure`.
- Valid artifact with all domains `discussed` or `bounded` -> `Complete`, next action `None`.
- Optional Context and enrichment do not change the transition.

These machine fields remain hidden from normal orchestrated conversation and may be shown for a direct readiness request.
