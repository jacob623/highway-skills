# Feature 061 Validation Quickstart

Run from the repository root on branch `feature/discovery-contract-alignment-spec061`.

## Prerequisites

- macOS or a supported shell environment with the repository's existing Bash 3.2-compatible utilities.
- Feature 061 sources under `specs/061-discovery-contract-alignment/`.

## Focused contract validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-discovery
.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md
.highway/tools/tests/highway-discovery.test.sh
```

Expected result: all commands exit 0. The focused test checks canonical source documents, generated
artifacts, and disposable fixtures; invalid fixtures fail independently for their targeted rule.

## Regenerate derived artifacts

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
```

Generated adapters and catalogs must be produced from canonical inputs. Do not hand-edit them.

## Correspondence and full validation

```sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: validators, correspondence checks, and the full repository suite pass; canonical
and generated artifact checks report no drift, and disposable fixture execution leaves canonical
bytes unchanged.

## Contract scenarios

The focused test must cover synchronized section ordering, `Fully Compliant`, integer alignment
values from 0 through 100 inclusive, Required Platform Match traceability-only wording, and
Candidate Elimination Log ordering. Each rule needs a valid fixture and an independently failing
invalid fixture.
