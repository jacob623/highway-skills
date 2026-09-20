# Quickstart: Discovery Analysis

## Prerequisites

- Run from the repository root.
- Bash 3.2-compatible repository tooling is available.
- A completed Request exists and can be selected by explicit `REQXXXXXX` identifier.
- The source skill and both shared discovery templates are authored before generation.

## 1. Validate the source skill and templates

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-discovery
.highway/tools/validate-library.sh .highway/library/templates/output
```

Expected result: both commands exit 0 with no relevant `ERROR:` lines.

## 2. Generate repository outputs

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
```

Expected result: the catalog registers `highway-discovery` and adapters exist at:

- `.github/skills/highway-discovery/SKILL.md`
- `.claude/skills/highway-discovery/SKILL.md`
- `.cursor/rules/highway-discovery.mdc`

## 3. Exercise successful bootstrap

In a disposable workspace, provide one completed `REQ000001` and no Discovery catalog. Invoke
`highway-discovery` with that explicit identifier.

Expected result: `discoveries/discoveries.md` bootstraps with `Version: 1.0.0` and
`Next ID: DISC000001`; exactly one `DISC000001.md` record and one index entry are written.
The record has all nine required sections and `request: REQ000001`.

## 4. Exercise deterministic analysis and matching

Run the same invocation twice against byte-identical Request, baselines, and catalog fixtures.
Include an explicit identifier match, an exact title match, a one-token near miss, and a two-token
context match.

Expected result: output bytes and ordering are identical; the first two candidates are High and
Medium, the one-token near miss is absent, and the two-token candidate is Low and advisory.

## 5. Exercise failure and privacy behavior

Run with a missing, malformed, ambiguous, nonexistent, or incomplete source; malformed catalog;
forced validation failure; and a write failure. Run once with a secret or regulated personal value
in the Request.

Expected result: every failure aborts without writes and preserves existing bytes. Sensitive values
are absent from the written record, a stable exclusion marker is present, and replacement
business evidence is requested.

## 6. Run focused and full validation

```sh
.highway/tools/tests/highway-discovery.test.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/run-all.sh
```

Expected result: the focused test passes all Discovery scenarios; generation leaves no drift;
adapter coverage passes; baseline remediation is complete; and the final suite passes with no
failures attributable to Feature 048.

## Recorded Completion Evidence

The focused Discovery test, adapter coverage, skill validation, library validation, and
output-template correspondence checks passed. The final `.highway/tools/tests/run-all.sh` result
was 40 passed and 0 failed. Generated catalog indexes and all three Discovery adapters are present;
the three pre-existing baseline failures remain resolved.

Requirement coverage is reported separately in `plan.md`: the implementation is a deterministic
instruction-driven analysis contract with disposable transaction and byte-preservation checks,
not a new runtime service.
