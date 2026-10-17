# Capability Catalog Quickstart

## Prerequisites

- A valid Highway repository with `.highway/skills/highway-implementation/SKILL.md` and shared implementation templates.
- At least one accepted Reference Implementation containing explicit realized-capability evidence.
- Existing implementation and capability catalogs, or valid empty-catalog fixtures.

## Validation Scenarios

### Publish one implementation

1. Prepare an accepted RI with `E-Commerce` realized by `Shopify` and `Digital Downloads` realized by `Shopify`.
2. Run the implementation publication workflow using the repository's existing implementation invocation.
3. Verify one RI record, one implementation catalog entry, and one `implementations/capabilities.md` row per capability.
4. Verify every row contains one RI parent and a non-empty Realized By value.

### Preserve multiple realizations

1. Prepare one capability with `Shopify` and `Amazon` as Realized By values.
2. Publish and regenerate the catalogs.
3. Verify one stable CAP row contains both values in deterministic order and no CAP record file exists.

### Verify determinism and regeneration

1. Run the same accepted inputs twice.
2. Compare the generated capability catalog bytes, identifiers, Next ID, and row ordering.
3. Remove or change a capability in the authoritative RI evidence and regenerate.
4. Verify unsupported rows disappear and unrelated CAP identifiers remain stable.

### Verify atomic failure behavior

1. Supply a missing RI parent, empty Realized By value, duplicate CAP identifier, malformed source, allocation conflict, or forced write failure.
2. Run the publication workflow.
3. Verify the operation reports failure and all pre-operation RI, implementation catalog, and capability catalog bytes remain unchanged.

## Repository Checks

```sh
.highway/tools/tests/capability-catalog.test.sh
.highway/tools/tests/highway-implementation-onboarding.test.sh
.highway/tools/validate-skill.sh .highway/skills/highway-implementation
.highway/tools/validate-library.sh .highway/library/templates/output/implementation-record.md
.highway/tools/validate-library.sh .highway/library/templates/output/implementation-catalog.md
.highway/tools/validate-library.sh .highway/library/templates/output/capability-catalog.md
.highway/tools/tests/run-all.sh
```

The final implementation also regenerates declared agent adapters and catalog outputs, then runs `git diff --check`.
