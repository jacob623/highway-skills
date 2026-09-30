# Controls Record Lineage Cleanup Quickstart

## Prerequisites

Run from the repository root with the existing Highway shell tooling available.

## Focused validation

1. Confirm the canonical Controls skill contains `4.0.0`, Recommendation Grounding, the four-field
   collection result, and the retained revalidation paragraph.
2. Confirm `Provenance`, `## Provenance`, `Created Control IDs`, the duplicated first revalidation
   paragraph, and the local common-failure sentence are absent from the corrected contract.
3. Confirm `control-record.md` is version `2.0.0`, has `## Recommendation Grounding` in the body,
   has no frontmatter grounding field, and preserves `nfrs: []`.
4. Regenerate adapters and the library catalog from canonical inputs.

```sh
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/generate-library-catalog.sh
```

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: zero failed tests, aligned generated artifacts, valid Control-record template
dependencies, unchanged `highway-controls` version `4.0.0`, and Control records that retain
Recommendation Grounding only as optional body lineage.
