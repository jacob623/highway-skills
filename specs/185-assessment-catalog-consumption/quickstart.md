# Assessment Catalog Consumption Quickstart

## Prerequisites

- Repository root is `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`.
- Accepted ADR, Reference Architecture, Reference Implementation, and Capability Catalog fixtures are available.
- Existing assessment findings are available or intentionally empty.

## Focused Contract Validation

Run the assessment contract test:

```sh
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
bash .highway/tools/tests/highway-assessment.test.sh
```

Expected result: the assessment contract passes with catalog inputs, direct Capability Catalog
provider evidence, existing finding categories, read-only ownership, and deterministic behavior.

## Catalog-First Scenarios

1. Provide all four catalogs and source records with additional detail.
2. Run `/highway-assessment portfolio` and verify catalogs are resolved before source records.
3. Run `/highway-assessment architectures` with a capability absent from architecture representation and verify a supported Coverage finding can be proposed without architecture traversal to discover the capability.
4. Run `/highway-assessment implementations` with repeated Realized By values and shared capability rows and verify provider concentration and reuse observations use direct catalog evidence.
5. Reorder equivalent catalog rows and rerun assessment; compare finding identities and equivalent observations.
6. Request a capability allocation or catalog update through assessment and verify the request routes to the owning workflow without mutation.

## Full Validation

```sh
bash .highway/tools/tests/run-all.sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-assessment
```

Expected result: focused and full tests pass, the assessment skill remains valid, generated adapters
match the canonical skill after regeneration, and no owner catalog or source record changes.

See [data-model.md](data-model.md) for evidence relationships and
[contracts/catalog-consumption-contract.md](contracts/catalog-consumption-contract.md) for the
input, authority, fallback, finding, and determinism contracts.
