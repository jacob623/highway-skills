# Quickstart: Highway Clarify Contract Hardening

## Prerequisites

- Repository root is `highway-skills`.
- Feature 058 baseline files exist: `.highway/skills/highway-clarify/SKILL.md` and `.highway/library/templates/output/clarification-record.md`.
- Bash 3.2-compatible shell and existing repository validators are available.

## Static Contract Validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-clarify
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md
```

Expected result: both commands exit 0 and recognize the hardened metadata, stable contract, privacy, profile, regeneration, revision, ordering, and template rules.

## Focused Feature Validation

```sh
.highway/tools/tests/highway-clarify.test.sh
```

Expected result: the focused test confirms stable `CLAR-<ARTIFACT-ID>` identity, profile precedence and absence behavior, stable consumer fields, regeneration preservation, deterministic ordering and bytes, privacy filtering before retention, status derivation, revision conflicts, no-write failures, and template conformance.

## Seeded Probes

```sh
.highway/tools/tests/highway-clarify.test.sh --probe source-document
.highway/tools/tests/highway-clarify.test.sh --probe source-document --neutralise
.highway/tools/tests/highway-clarify.test.sh --probe generated-artifact
.highway/tools/tests/highway-clarify.test.sh --probe generated-artifact --neutralise
.highway/tools/tests/highway-clarify.test.sh --probe disposable-fixture
.highway/tools/tests/highway-clarify.test.sh --probe disposable-fixture --neutralise
```

Each seeded probe must detect its injected defect before neutralization and pass after neutralization.

## Generated Correspondence and Packaging

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/generate-catalog.test.sh
.highway/tools/tests/generate-library-catalog.test.sh
.highway/tools/tests/distribution-packaging.test.sh
```

Expected result: generated skill/adapters/catalogs remain current, shared-template correspondence is valid, and packaging accepts the hardened shipped artifacts.

## Full Suite

```sh
.highway/tools/tests/run-all.sh
```

Expected result: all repository checks pass with no source-artifact mutation and no retained sensitive values in generated clarification records.

## Contract Scenarios

1. Generate a source with no profile, then add artifact-type and global profiles; confirm the first resolvable profile follows the declared precedence and absent profiles remain valid.
2. Generate and resolve a finding, modify unrelated source content, regenerate, and confirm the unchanged finding ID, response, and history remain while findings are recalculated.
3. Generate identical inputs twice and compare finding IDs, order, severity, and canonical artifact bytes.
4. Place secrets and regulated personal data in source evidence, a response, history, and metadata; confirm retained content contains only redaction markers.
5. Attempt an Update from a stale revision and confirm expected/actual revisions are returned with unchanged artifact bytes, revision, and history.
6. Remove required metadata or template sections and confirm Inspect, Read, and Status return `blocked` with a reason rather than repairing the record.
