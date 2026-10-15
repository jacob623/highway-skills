# Feature 179 Quickstart: Explicit ADR Option Selection

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The canonical sources are `.highway/skills/highway-adr/SKILL.md`, `.highway/library/templates/output/adr-record.md`, and `.highway/library/templates/output/adr-catalog.md`.

## Focused contract validation

```sh
bash .highway/tools/tests/highway-adr.test.sh
```

Expected result:

```text
PASS: highway-adr contract
```

The test must cover exact identifier syntax, explicit selection, missing-option prompt, unsupported-option rejection, no partial writes, recommendation/decision ownership, and removal of automatic tie-break selection language.

## Canonical validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-adr
.highway/tools/validate-library.sh .highway/library/templates/output/adr-record.md
```

Both commands must exit successfully with no `FAILED` rules.

## Generated correspondence

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
```

Verify the four generated `highway-adr` adapters match the canonical source and that the catalogs contain the current skill/template metadata.

## Full regression suite

```sh
.highway/tools/tests/run-all.sh
```

Expected result: zero failures. Existing ADR, Discovery, output-template, catalog, and adapter correspondence tests must remain green.

## Manual contract scenarios

1. Confirm creation requires `/highway-adr DISC000001 OPT000001`.
2. Confirm `/highway-adr DISC000001` presents every available option and the advisory recommendation without allocating or writing an ADR.
3. Confirm `/highway-adr DISC000001 OPT999999` aborts without allocation or writes.
4. Confirm an explicitly selected option may differ from the recommendation and is retained as `Selected Option`.
5. Confirm no ADR decision rule mentions recommendation, score, architecture match, or lower option identifier as an automatic selector.
