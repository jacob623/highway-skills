# Assessment Catalog Consumption Contract

## Inputs Contract

`highway-assessment` accepts these repository indexes as analysis inputs:

- `adrs/adrs.md`
- `architectures/architectures.md`
- `implementations/implementations.md`
- `implementations/capabilities.md`

Assessment resolves catalog entries before opening associated ADR, Reference Architecture, or
Reference Implementation records. A source record is opened only when the catalog evidence does
not answer the active assessment question.

## Authority Contract

Catalogs are authoritative indexes for navigation and direct relationship evidence. Their owning
source records remain authoritative for detailed rationale, constraints, dependencies, and other
retained record content. A conflict is observable as unavailable or inconsistent evidence; it is not
silently repaired by assessment.

`highway-assessment` is read-only with respect to all four catalogs and their source records. It
must not create, update, allocate, or re-index capabilities, Capability Catalog entries, capability
relationships, implementations, architectures, ADRs, or their catalogs.

## Domain Contract

- Portfolio assessment may evaluate capability coverage, technology adoption, provider patterns,
  implementation reuse, and repository landscape relationships from all four catalogs.
- Architecture assessment may compare realized capabilities with architecture representation and
  surface capability-to-architecture gaps or shared realization patterns.
- Implementation assessment may use the Implementation Catalog to locate implementations before
  opening records, then use Capability Catalog `Realized By` values for provider concentration,
  shared realization, reuse, and distribution observations.

## Finding Contract

Capability-related observations use only the existing categories:

`Coverage`, `Consistency`, `Dependency`, `Opportunity`, `Reuse`, `Risk`.

They use the existing assessment domain, finding fingerprint, status, disposition, review, and
persistence rules. They remain advisory until requester disposition.

## Determinism Contract

For identical accepted catalogs, relevant source evidence, findings state, and selected domain:

- catalog row order does not change normalized evidence;
- finding identities and equivalent observations remain identical;
- no timestamp, filesystem order, randomness, or environment state affects the result; and
- no owner artifact or catalog byte changes.

## Fallback Contract

Missing, malformed, unreadable, duplicated, unresolved, or conflicting catalog and source evidence
preserves uncertainty. Assessment may report a grounded Consistency, Coverage, Risk, or other
existing-category finding when supported, but it must not invent a capability, provider, technology
inventory, or owner mutation.
