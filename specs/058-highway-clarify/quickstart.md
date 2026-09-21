# Quickstart: Highway Clarify

## Prerequisites

- Repository root is `highway-skills`.
- Bash 3.2-compatible shell and existing repository tools are available.
- No live user-owned `requests/`, `discoveries/`, `adrs/`, or `reference-architectures/` fixtures are required; the focused test creates disposable inputs.

## Static Validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-clarify
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md
```

Expected result: both commands exit 0.

## Focused Contract and Fixture Validation

```sh
.highway/tools/tests/highway-clarify.test.sh
```

Expected result: the test confirms command forms, identifier validation, deterministic resolution,
colocated output, source-byte preservation, analysis category precedence, status transitions,
revision conflict handling, no automatic merge, no-write failures, read-only commands, advisory
open findings, and repeatability.

The test also supports seeded artifact-class probes:

```sh
.highway/tools/tests/highway-clarify.test.sh --probe source-document
.highway/tools/tests/highway-clarify.test.sh --probe generated-artifact
.highway/tools/tests/highway-clarify.test.sh --probe disposable-fixture
```

Each probe must fail before neutralization and pass with `--neutralise`.

## Generated Correspondence

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/generate-catalog.test.sh
```

Expected result: the catalog and all three generated adapters include `highway-clarify`, with no
manual edits or stale correspondence.

## Full Suite

```sh
.highway/tools/tests/run-all.sh
```

Expected result: all existing and new checks pass. Report static contract results, disposable
fixture behavior, generated correspondence, and full-suite status separately.

## Manual Contract Scenarios

1. Generate a `REQ000001` fixture with explicit contradiction, missing, unknown, ambiguity, and
   unresolved-assumption evidence. Confirm category priority emits one finding per evidence source.
2. Run Generate twice with unchanged inputs. Confirm identical finding order, IDs, path, and
   output bytes apart from explicitly non-semantic metadata.
3. Start two Update operations at revision 7. Commit one to revision 8, then confirm the other
   returns expected revision 7 and actual revision 8 without changing bytes or history.
4. Run Inspect, Read, and Status against absent, valid, complete, in-progress, and malformed
   clarification records. Confirm absent is `not-started`, malformed is `blocked`, and all three
   read-only commands leave hashes unchanged.
5. Leave findings open and invoke a downstream consumer. Confirm consumption proceeds and the
   consumer receives advisory status and open findings.
