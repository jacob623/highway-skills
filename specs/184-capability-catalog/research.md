# Capability Catalog Research

## Decision: Keep Reference Implementations authoritative

**Decision**: Capability meaning and realization evidence are captured in the accepted Reference Implementation. `implementations/capabilities.md` is a generated projection used for navigation and analysis.

**Rationale**: The existing implementation workflow owns realization evidence and atomic publication. A separate authoring workflow or capability record family would split ownership and create competing organizational truth.

**Alternatives considered**:

- Standalone capability records: rejected because the request explicitly excludes `CAP######.md` files and independent capability ownership.
- Assessment-owned capability discovery: rejected because assessment is advisory and must not create substitute artifact families.

## Decision: Add explicit realized-capability evidence to the RI record

**Decision**: Extend the shared implementation record template with a `Realized Capabilities` section. Each entry contains a business-readable Title, one or more Realized By values, and supporting evidence.

**Rationale**: The catalog must be generated from explicit implementation evidence, not from component names or semantic inference. The RI record is the nearest authoritative owner and already carries implementation selections and traceability.

**Alternatives considered**:

- Infer capabilities from Runtime Components or Technology Realization: rejected because implementation components are not necessarily business outcomes.
- Store capability evidence only in the catalog: rejected because the generated index would become authoritative and regeneration could not explain its source.

## Decision: Use one catalog row per RI and normalized capability title

**Decision**: A catalog entry identity is the pair `(Parent RI, normalized capability Title)`. One row contains one or more canonical Realized By values rendered in a deterministic order. A provider change updates the row without allocating a new CAP identifier.

**Rationale**: This preserves one capability identity when multiple providers realize the same outcome and keeps `CAP######` catalog-local. It also satisfies the requirement that multiple realization values do not create independent capability artifacts.

**Alternatives considered**:

- Allocate one CAP identifier per provider: rejected because provider changes would fragment one business capability into unrelated identities.
- Use only capability title as identity: rejected because the same business capability may be realized by multiple independent RIs and must retain each parent relationship.

## Decision: Allocate and preserve CAP identifiers from prior catalog identity

**Decision**: Validate the existing catalog, match existing entries by `(Parent RI, normalized Title)`, preserve their CAP identifiers, allocate the lowest available sequential Next ID for genuinely new pairs, and advance Next ID only for allocations that publish successfully.

**Rationale**: Stable identity must survive unrelated additions, removals, and row reordering while still allowing deterministic allocation and regeneration.

**Alternatives considered**:

- Derive CAP identifiers from a hash: rejected because the requested format is sequential `CAP######` and catalog-local sequential IDs are easier to inspect.
- Reassign identifiers from sorted rows on every generation: rejected because removal or insertion would change unrelated identities.

## Decision: Publish all derived outputs atomically

**Decision**: Generate and validate the RI record, implementation catalog, and capability catalog in memory, then publish them as one transaction with rollback or no observable write when any validation, allocation, or write step fails.

**Rationale**: The capability catalog must never contain orphaned rows or disagree with the RI that produced it.

**Alternatives considered**:

- Write the RI first and regenerate the catalog later: rejected because an interrupted run would expose partial state.
- Treat the catalog as best-effort: rejected because assessment and navigation depend on a consistent projection.

## Decision: Preserve exact deterministic order

**Decision**: Sort catalog rows by Parent RI identifier, normalized Title, then CAP identifier. Sort multiple Realized By values by normalized provider value while preserving the canonical display spelling selected by the RI evidence.

**Rationale**: Explicit ordering removes filesystem order and input-order dependence and makes repeated output byte-identical.

**Alternatives considered**:

- Preserve source file order: rejected because it is not stable across independent accepted implementations.
- Sort only by title: rejected because parent identity and stable CAP identity are required tie-breakers.
