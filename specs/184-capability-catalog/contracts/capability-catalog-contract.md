# Capability Catalog Contract

## Purpose

Define the generated business-to-technology index derived from accepted Reference Implementation evidence.

## Inputs

- Accepted Reference Implementation records and the authoritative implementation catalog
- The shared implementation record and catalog templates
- Existing Capability Catalog, when present, for stable CAP identifier reuse
- Existing Reference Architecture, ADR, governance, and assessment records as read-only context only

## Source Evidence

Each RI may contain a `Realized Capabilities` section. Every capability entry has a business-readable Title, one or more Realized By values, and supporting evidence. The catalog MUST NOT infer a capability from an implementation component or provider name alone.

## Catalog Shape

```markdown
# Capability Catalog

Version: 1.0.0

Next ID: CAPXXXXXX

## Capability Index

| ID | Parent | Title | Realized By |
|----|--------|-------|-------------|
| CAPXXXXXX | RIXXXXXX | <business capability> | <provider; provider> |
```

The catalog contains no other index columns. `Realized By` may contain multiple canonical values in deterministic display order.

## Identity and Ordering

- Every row has exactly one `RI######` Parent.
- Every row has at least one non-empty Realized By value.
- Existing IDs match by Parent and normalized Title and remain stable.
- New IDs use the exact prior Next ID and increment once per newly allocated identity.
- Rows sort by Parent RI identifier, Title, then CAP identifier.
- No `CAP######.md` file is created.

## Publication and Failure

The implementation workflow validates all source evidence, generated rows, identifiers, ordering, and relationships before writing. RI publication, implementation catalog publication, and Capability Catalog publication are atomic. Any resolution, validation, allocation, or write failure preserves every pre-operation byte and leaves no orphaned capability row.

## Consumers

Assessment may read the catalog to identify the owning RI and direct realization providers. Reading the catalog does not transfer ownership, create a technology inventory, or authorize changes to any source artifact.
