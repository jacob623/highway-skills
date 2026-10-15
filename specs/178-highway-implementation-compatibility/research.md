# Research: Highway Implementation Compatibility Assessment

## Decision 1: Keep compatibility ownership in `highway-implementation`

- **Decision**: Extend `.highway/skills/highway-implementation/SKILL.md` and the shared implementation record template; do not create a separate compatibility skill or runtime service.
- **Rationale**: The implementation workflow already owns realization, technology choices, Controls/NFR realization, lifecycle mapping, persistence, and the downstream RI handoff. Keeping the assessment there preserves one ownership boundary and the existing Feature 176 contract.
- **Alternatives considered**: A separate assessment skill was rejected because it would duplicate source resolution and realization ownership. A runtime compatibility service was rejected because Highway distributes Markdown skill contracts with Bash static validation rather than a service runtime.

## Decision 2: Treat Implementation Selections as user-owned inputs

- **Decision**: Require one or more explicitly supplied `Implementation Selections`; support components, services, products, frameworks, databases, middleware, infrastructure, and provider capabilities without using `Products` as the primary concept.
- **Rationale**: Realization validity depends on the owner's intended building blocks. The workflow may normalize names and ordering, but it must not invent technology choices.
- **Alternatives considered**: Internally generated technology lists were rejected because they obscure ownership and can claim support without evidence. A vendor-only input model was rejected because the feature explicitly includes non-vendor building blocks and future observed components.

## Decision 3: Use exactly three compatibility outcomes

- **Decision**: Every assessment produces exactly `Compatible`, `Incomplete`, or `Incompatible`.
- **Rationale**: The outcomes distinguish realizable selections, unresolved responsibilities, and direct contradictions while giving each state a deterministic generation boundary.
- **Alternatives considered**: A binary compatible/incompatible result was rejected because unresolved but non-contradictory realization gaps need a distinct actionable state. Additional states were rejected as unnecessary for the requested workflow.

## Decision 4: Evaluate deterministic architecture-derived responsibility categories

- **Decision**: Extract implementation-relevant requirements from accepted architecture sections and evaluate applicable categories in stable order: Compute, Messaging, Persistence, Identity, Networking, Security, Observability, Recovery, Deployment, Operations.
- **Rationale**: Explicit categories make coverage auditable and allow one selection to satisfy multiple responsibilities or multiple selections to jointly satisfy one responsibility. Non-required categories remain `Not Applicable` rather than becoming invented work.
- **Alternatives considered**: A free-form checklist was rejected because it cannot prove coverage consistently. Evaluating every category for every architecture was rejected because it creates false gaps for irrelevant concerns.

## Decision 5: Separate gaps from conflicts

- **Decision**: `Incomplete` produces Implementation Gap Analysis; `Incompatible` produces structured conflicts and exactly two resolution paths.
- **Rationale**: A missing realization can be resolved by the owner, while a contradiction must not be silently repaired or converted into a weaker architecture. The distinction preserves architecture authority.
- **Alternatives considered**: Treating every issue as a conflict was rejected because it prevents legitimate incremental resolution. Automatically selecting a replacement was rejected because it would override user ownership and architecture evidence.

## Decision 6: Require evidence-backed recommendations and preserve Unknown

- **Decision**: Recommend a realization only when architecture, governance, or declared evidence supports it; otherwise emit `Unknown`.
- **Rationale**: This matches Highway's existing evidence and recommendation boundaries and avoids presenting unsupported provider choices as organizational knowledge.
- **Alternatives considered**: Defaulting to common products such as Kafka or a cloud provider was rejected because popularity is not architecture evidence.

## Decision 7: Gate RI generation on compatibility

- **Decision**: Only `Compatible` may proceed to the existing RI generation and persistence boundary. `Incomplete` and `Incompatible` produce no RI allocation or catalog mutation.
- **Rationale**: The RI is defined as a validated realization, so generation before compatibility would preserve the old projection behavior and permit unresolved or contradictory output.
- **Alternatives considered**: Generating a draft RI for incomplete input was rejected because the specification requires no RI until required gaps are resolved. Generating an RI with warnings for conflicts was rejected because conflicts require an explicit owner path.

## Decision 8: Make future brownfield observations an input-shape compatibility, not a feature expansion

- **Decision**: Define observed implementation components as compatible with the same assessment input shape, but do not implement brownfield discovery or ingestion in Feature 178.
- **Rationale**: One assessment model can serve both new selections and future observations without duplicating validation logic, while scope remains bounded.
- **Alternatives considered**: A separate brownfield validator was rejected because it would drift from selection validation. Implementing discovery now was rejected because it is outside the requested version-one boundary.
