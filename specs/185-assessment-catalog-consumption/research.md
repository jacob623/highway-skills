# Assessment Catalog Consumption Research

## Decision: Start assessment from accepted catalogs

**Decision**: Resolve the ADR, Reference Architecture, Reference Implementation, and Capability catalogs before opening associated source records.

**Rationale**: The catalogs are the repository's accepted navigation indexes and contain enough relationship evidence for many coverage, reuse, provider, and distribution observations. Catalog-first analysis avoids unnecessary architecture traversal and makes the source-record fallback explicit.

**Alternatives considered**: Continue traversing architecture records first; rejected because it hides direct capability and implementation relationships and opens unrelated source artifacts.

## Decision: Preserve split authority between indexes and records

**Decision**: Use catalog entries as authoritative indexes for navigation and source records as authoritative evidence for detailed record content. Report conflicts rather than silently merging or replacing either authority.

**Rationale**: This preserves the existing owner boundaries while allowing assessment to use the right evidence surface for each question.

**Alternatives considered**: Treat source records as the only authority; rejected because catalog navigation would provide no independent value. Treat catalog rows as complete source truth; rejected because catalogs are projections and do not contain all detailed rationale or constraints.

## Decision: Read-only assessment consumption

**Decision**: Assessment may observe and correlate catalog evidence but never creates, updates, allocates, or re-indexes capabilities, implementations, architectures, ADRs, or their catalogs.

**Rationale**: `highway-implementation` owns realized capabilities and Capability Catalog publication; other workflows own their records and catalogs. Assessment remains an advisory findings workflow.

**Alternatives considered**: Add repair or synchronization behavior to assessment; rejected because it would create a competing owner and mutation boundary.

## Decision: Direct capability/provider analysis

**Decision**: Use Capability Catalog `Parent`, `Title`, and `Realized By` values directly for capability coverage, provider concentration, shared realization, implementation reuse, and landscape observations. Use existing finding categories only.

**Rationale**: The catalog already expresses the business-to-technology relationship needed by assessment. A separate technology inventory or new finding taxonomy would duplicate ownership and vocabulary.

**Alternatives considered**: Infer providers from architecture components or create a technology inventory; rejected because both approaches discard accepted implementation evidence or introduce an unowned artifact family.

## Decision: Deterministic catalog normalization and selective source fallback

**Decision**: Normalize catalog rows by stable identifiers and canonical field values before analysis. Open a source record only when the requested observation needs evidence absent from the relevant catalog entry. Equivalent catalog inputs in different row orders must produce equivalent findings.

**Rationale**: Stable ordering and bounded source access are necessary for reproducible findings and testable catalog-first behavior.

**Alternatives considered**: Use filesystem order or open every source record unconditionally; rejected because those choices are nondeterministic or defeat the feature's purpose.

## Decision: Additive MINOR skill contract change

**Decision**: Increment the `highway-assessment` skill version from `1.0.0` to the next MINOR version while preserving domains, finding categories, finding persistence, review behavior, and ownership boundaries.

**Rationale**: The feature adds accepted inputs and analysis guidance without removing or redefining an existing contract.

**Alternatives considered**: MAJOR version change; rejected because no existing input, output, lifecycle, or ownership contract is removed.
