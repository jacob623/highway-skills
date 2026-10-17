# Assessment Catalog Consumption Data Model

## Catalog Inputs

| Entity | Source | Role | Authority |
|---|---|---|---|
| ADR Catalog | `adrs/adrs.md` | Resolve accepted ADRs and architecture decision navigation | Index for navigation; ADR record for detailed evidence |
| Reference Architecture Catalog | `architectures/architectures.md` | Resolve accepted architectures and architecture relationships | Index for navigation; architecture record for detailed evidence |
| Reference Implementation Catalog | `implementations/implementations.md` | Locate implementations and assess implementation distribution | Index for navigation; implementation record for detailed evidence |
| Capability Catalog | `implementations/capabilities.md` | Resolve business capabilities, RI parents, and Realized By values | Capability index for navigation; owning RI evidence for detailed capability meaning |

## Catalog Entry

- **Identifier**: Stable identifier supplied by the owning catalog, such as `ADR######`, `ARCH######`, `RI######`, or `CAP######`.
- **Parent**: The owning relationship when present, especially a Capability Catalog `RI######` parent.
- **Title**: The catalog's accepted business or artifact title.
- **Realized By**: One or more provider, platform, product, technology, service, process, or mechanism values for a capability.
- **Source Path**: The record path resolved from the catalog entry.
- **Status**: The accepted or otherwise declared source status used to determine whether evidence is eligible.

## Assessment Evidence View

Assessment builds a read-only evidence view in this order:

1. Load and validate the four catalogs.
2. Normalize entries by stable identifier and canonical field values.
3. Correlate direct catalog relationships for the selected domain.
4. Open only the associated ADR, Architecture, or Implementation record required for missing detail.
5. Preserve unresolved or conflicting evidence as unknown or as a grounded Consistency finding.

## Domain Projections

- **Portfolio**: Correlates ADR, Architecture, Implementation, and Capability entries to identify landscape coverage, provider patterns, adoption, reuse, and supported risks or opportunities.
- **Architectures**: Compares realized capabilities and shared realization patterns with architecture coverage and representation.
- **Implementations**: Uses Implementation Catalog entries to locate implementation distribution, then Capability Catalog relationships and source evidence to assess reuse, provider concentration, dependencies, and risks.

## Finding Relationship

Capability-related observations use the existing `Coverage`, `Consistency`, `Dependency`, `Opportunity`, `Reuse`, or `Risk` category and existing assessment domain. They remain Working Ideas until requester disposition and persist through the existing finding ID, fingerprint, status, disposition, and revision contract.

## Validation Rules

- Catalog entries must be accepted, parseable, and uniquely resolvable before they can ground a finding.
- A Capability Catalog relationship preserves the exact RI parent and every Realized By value; distinct parents are not merged.
- Missing source detail never becomes an inferred fact.
- Catalog row order does not affect normalized evidence or finding identity.
- Assessment performs no catalog, record, identifier, relationship, or publication mutation.
