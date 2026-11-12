# Contract: ADR Catalog Architecture ID

highway-architecture's `name` step is the one place that records which architecture an ADR produced.

- Sets the ADR's `Reference Architecture` field to the `RA` id.
- Sets that ADR's Architecture ID cell in `adrs/adrs.md` to the same `RA` id.
- Changes no other ADR or ADR catalog byte; the catalog version is unchanged.
- One write for both. A failure keeps the architecture and its catalog, says the ADR could not be updated
  to name it and that running `/highway-architecture [ADR id]` again will, and does not call the chain
  complete. Entry case 6 then reaches `name` again and repairs both.
- The seeded-file check names `adrs/adrs.md` and `architectures/architectures.md`.

Holds for a direct `/highway-architecture` run and for the onboarding entry step alike (SC-004).
