# Discovery Artifact Contract

## Record

The record is `discoveries/DISCXXXXXX.md` and uses the complete shared template `.highway/library/templates/output/discovery-record.md`.

Required frontmatter:

```yaml
id: DISCXXXXXX
request: REQXXXXXX
status: proposed
```

Required headings, in order:

1. Request
2. Research Findings
3. Assumptions
4. Risks
5. Unknowns
6. Candidate Approaches
7. Objective Relationships
8. Control Relationships
9. NFR Relationships

The record references exactly one Request. It contains no approved relationship, ADR, architecture, implementation, or governance mutation.

## Catalog

The catalog is `discoveries/discoveries.md` and uses the complete shared template `.highway/library/templates/output/discovery-catalog.md`.

Required structure:

```markdown
Version: X.Y.Z

Next ID: DISCXXXXXX

## Discovery Index

| Discovery ID | Request ID | Discovery Title |
|--------------|------------|-----------------|
```

Each entry is unique and contains exactly one Discovery ID, Request ID, and title. The catalog has no other top-level sections. `Next ID` is the only allocation source.

## Transaction

The skill reads the catalog, performs exclusive allocation, constructs both outputs in memory, validates both outputs and their cross-reference, then writes both outputs. A catalog conflict retries no more than three times. Any failure leaves all existing output bytes unchanged and writes no partial artifact.

## Privacy

Secrets and regulated personal data are excluded before rendering. The record contains a stable exclusion marker and business-relevant replacement evidence rather than the sensitive value.

## ADR Handoff

The traceability chain is `REQ -> DISC -> ADR -> Reference Architecture -> Reference Implementation`. A future ADR references exactly one Discovery identifier; Discovery itself does not create the ADR.
