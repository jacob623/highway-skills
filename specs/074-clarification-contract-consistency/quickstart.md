# Quickstart: Clarification Contract Consistency

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The checks use the existing Bash 3.2-compatible tooling and require no new dependencies.

## Validate the canonical inputs

```sh
.highway/tools/tests/highway-clarify.test.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/validate-skill.sh .highway/skills/highway-clarify
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md
```

Expected result: each command exits 0.

## Validate generated correspondence

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/generate-catalog.test.sh
.highway/tools/tests/generate-library-catalog.test.sh
.highway/tools/tests/generate-agent-adapters.test.sh
```

Expected result: generators succeed and generated-artifact tests report no drift.

## Validate requested contract outcomes

Check all of the following across canonical and generated artifacts:

1. `Unknown / Escalate for Decision` has zero matches outside historical version-control records.
2. `evidence-gap` maps to `Unknown` and `conflict` maps to `Escalate for Decision`.
3. Evidence Sources use direct list items with Source Type, Source Identifier, and Reason Used.
4. Empty evidence uses `Evidence Sources: None`.
5. Duplicate Resolution History Finding identifiers fail before any write and preserve pre-operation bytes.
6. Generated clarification records contain no nested `Source:` wrapper.
7. The explanatory contract sentence appears exactly once in the clarification-record template.

## Full validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the full suite exits 0 and `git diff --check` emits no whitespace errors.

See [data-model.md](data-model.md) for entities and invariants and [contracts/clarification-contract-consistency.md](contracts/clarification-contract-consistency.md) for the conformance contract.
