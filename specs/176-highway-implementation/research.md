# Research: Highway Reference Implementation Workflow

## Decision: Follow the existing Highway source-skill and shared-template pattern

**Rationale**: Feature 175 establishes the nearest upstream contract: a source skill owns workflow
semantics, shared templates own output shape, catalogs own permanent identifiers, and generated
agent surfaces are derived. Reusing that pattern preserves repository conventions and keeps
implementation realization downstream from architecture.

**Alternatives considered**: A standalone executable implementation generator was rejected because
this feature explicitly produces a governed blueprint, introduces no runtime dependency, and leaves
planning and code generation to later workflows.

## Decision: Use `ARCH######` as the Reference Architecture input identifier

**Rationale**: The clarification resolved the requested `RA######` shorthand in favor of Feature
175's existing catalog-owned `ARCH######` identifier. This allows direct catalog resolution and
preserves cross-workflow traceability without an alias layer.

**Alternatives considered**: Introducing `RA######` was rejected because it would create a second
identity for the same Reference Architecture and require upstream catalog changes.

## Decision: Use catalog-owned `RI######` allocation

**Rationale**: A permanent implementation identifier and direct catalog entry make the artifact
addressable, prevent duplicate implementations for one architecture, and allow deterministic
repeated-run and conflict testing. The first successful publication consumes the catalog's exact
`Next ID`, advances it once, and writes the record and catalog atomically.

**Alternatives considered**: Deriving the identifier from the architecture title or filesystem
order was rejected because titles and filesystem order are not stable allocation authorities.

## Decision: Keep implementation realization technology-specific but architecture-traceable

**Rationale**: The Reference Architecture remains conceptual and technology-agnostic. The Reference
Implementation may select concrete technologies only when the architecture permits alternatives
and deterministic evidence supports the choice. Each choice records its architecture intent and
supporting evidence.

**Alternatives considered**: Copying technology choices into the architecture was rejected because
it would violate architecture ownership and make later implementation alternatives harder to govern.

## Decision: Treat malformed Clarification as a read-only fallback to architecture evidence

**Rationale**: Clarification is advisory. When a `CLAR-ARCH######` record is malformed, the
workflow preserves it, excludes it from evidence, and continues from the authoritative Reference
Architecture and other valid inputs. Open or blocked clarification contributes assumptions or risks
but does not block generation.

**Alternatives considered**: Aborting every run on malformed optional Clarification was rejected
because it would make advisory context a hard dependency. Malformed Profile, Objective, Control, or
NFR input remains fatal because those inputs can change realization validity and relationships.

## Decision: Publish only a blueprint and downstream handoff

**Rationale**: The MVP stops at a proposed Reference Implementation. It emits realization guidance,
lifecycle mappings, dependencies, risks, and traceability, then hands off to planning. It does not
create plans, tasks, source code, infrastructure definitions, deployment authorization, or
self-service productization.

**Alternatives considered**: Generating code or plans in the same workflow was rejected because it
would collapse distinct ownership boundaries and make architecture-to-implementation decisions
harder to review.
