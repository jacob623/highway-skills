# Feature 069 Quickstart

This guide validates the planned Discovery consumer behavior with the repository's existing Bash test harness.

## Prerequisites

- macOS-compatible Bash 3.2.57 and the repository's declared shell utilities.
- A clean or understood working tree at the repository root.
- Feature 069 design artifacts present under `specs/069-discovery-clarification-consumption/`.

## Static contract validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-discovery
.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md
.highway/tools/validate-library.sh .highway/library/templates/output/discovery-catalog.md
```

Expected result: all validators exit 0, and the Discovery skill cites the shared output templates and the clarification consumer contract without adding a Discovery schema section.

## Focused behavioral validation

```sh
.highway/tools/tests/highway-discovery.test.sh
.highway/tools/tests/highway-discovery.test.sh --probe source-document
.highway/tools/tests/highway-discovery.test.sh --probe source-document --neutralise
.highway/tools/tests/highway-discovery.test.sh --probe generated-artifact
.highway/tools/tests/highway-discovery.test.sh --probe generated-artifact --neutralise
.highway/tools/tests/highway-discovery.test.sh --probe disposable-fixture
.highway/tools/tests/highway-discovery.test.sh --probe disposable-fixture --neutralise
```

Expected results: the normal test and each neutralised probe exit 0; each non-neutralised probe exits non-zero. The focused fixtures must cover catalog-backed `CLAR-<REQ-ID>` resolution, missing catalog/entry, malformed or unreadable artifact fallback, open and resolved findings, response precedence, clarification byte preservation, unchanged candidate recommendation values, and repeated byte-identical outputs.

## Full validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the full suite exits 0 and `git diff --check` reports no whitespace errors. If canonical `.highway/skills/` or `.highway/library/` inputs changed, regenerate the catalog and agent adapters, then rerun the full suite and verify generated correspondence.

## Contract reference

The field, resolution, precedence, failure, ownership, and determinism assertions are defined in [clarification-consumption-contract.md](contracts/clarification-consumption-contract.md). Entity relationships and validation rules are defined in [data-model.md](data-model.md).
