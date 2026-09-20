# Quickstart: Highway New Wording Cleanup

## Prerequisites

Run from the repository root on macOS or Linux with the existing Bash 3.2-compatible tooling.

## Focused Validation

Run the source and shared-template assertions:

```sh
./.highway/tools/tests/highway-new.test.sh
./.highway/tools/tests/output-template.test.sh
./.highway/tools/validate-skill.sh .highway/skills/highway-new
./.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md
```

Expected result: every command exits 0. The checks must confirm the consolidated allowed-class
wording, the explicit exception for other list-shaped fields, the concise field-error sentence,
and `No business constraints` wording without changing durable-state assertions.

## Generated Artifact Validation

After updating the authoritative skill, regenerate outputs:

```sh
./.highway/tools/generate-catalog.sh
./.highway/tools/generate-agent-adapters.sh
./.highway/tools/tests/adapter-coverage.test.sh
./.highway/tools/tests/shipped-tree-independence.test.sh
./.highway/tools/tests/distribution-packaging.test.sh
```

Expected result: generators succeed and every correspondence/distribution check exits 0.

## Repository Validation

Run the complete suite:

```sh
./.highway/tools/tests/run-all.sh
```

Expected result: the suite completes with no failures attributable to Feature 055. Review the
output for any pre-existing baseline diagnostics separately from the wording correction.

## References

- [Wording Contract](contracts/wording-contract.md)
- [Durable State Contract](contracts/durable-state-contract.md)
- [Data Model](data-model.md)
