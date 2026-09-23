# Quickstart: Highway ADR Decision Workflow

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

Use the existing Bash 3.2-compatible tools. No package installation or external service is
required.

## Validate the planning inputs

```sh
.specify/scripts/bash/check-prerequisites.sh --json --paths-only
git diff --check
```

Expected result: the active branch is `075-highway-adr`, the feature paths resolve, and the diff
has no whitespace errors.

## Validate canonical ADR contracts

After implementation, run:

```sh
.highway/tools/tests/highway-adr.test.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/validate-skill.sh .highway/skills/highway-adr
.highway/tools/validate-library.sh .highway/library/templates/output/adr-record.md
.highway/tools/validate-library.sh .highway/library/templates/output/adr-catalog.md
```

Expected result: all commands exit 0. The focused ADR test must cover valid generation, one
selected Discovery option, all alternatives, conditional override/findings, handoff completeness,
duplicate rejection, malformed-input failure, source-byte preservation, and deterministic output.

## Validate generated correspondence

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/generate-catalog.test.sh
.highway/tools/tests/generate-library-catalog.test.sh
.highway/tools/tests/generate-agent-adapters.test.sh
.highway/tools/tests/adapter-coverage.test.sh
```

Expected result: the ADR skill has catalog entries and synchronized adapters in every declared
agent tree, with no hand-edited generated artifacts.

## Validate behavior fixtures

The focused test should exercise these cases:

1. One valid Discovery produces one accepted ADR and one catalog advance.
2. Recommendation agreement omits Recommendation Override; a divergent selection renders it
   immediately after Decision with all three required values.
3. Missing, duplicate, malformed, or invalid Discovery input fails before any write.
4. Clarification statuses `not-started`, `in-progress`, `complete`, `blocked`, and malformed are
   consumed according to the snapshot rules without source mutation.
5. Open findings and conflict guidance remain advisory and retain their identifiers.
6. Identical inputs produce byte-identical ADR output and stable relationship ordering.
7. A duplicate ADR for the same Discovery identifier and an exhausted catalog conflict preserve
   the existing ADR, catalog, and all source bytes.

## Full validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

The completion report must state suite results separately from requirement coverage, as required by
D7.3. See [data-model.md](data-model.md) and [contracts/adr-workflow.md](contracts/adr-workflow.md)
for the retained entity and interface contracts.