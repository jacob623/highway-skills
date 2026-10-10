# Feature 156 Validation Guide

## Prerequisites

Run from the repository root on macOS with the existing shell toolchain:

- Bash 3.2.57-compatible shell
- Existing `.highway/` source and generated adapter trees

## Focused static-document validation

Run the Feature 156 contract test:

```sh
bash .highway/tools/tests/feature-156-structure-revealing-advisory-contributions.test.sh
```

Expected result:

```text
OK: Feature 156 structure-revealing advisory delivery sites pass
```

The test verifies that Profile guidance:

- prefers supported structure before extension;
- permits a connected linear structure → implication → possibility/tradeoff chain;
- rejects summary-only contributions and detached strategic leaps;
- rejects branching alternatives and recommendation-set behavior;
- preserves the existing Experience Standard and named Profile guidance.

## Generated-artifact validation

Regenerate the declared agent adapters:

```sh
.highway/tools/generate-agent-adapters.sh
```

Then confirm the focused test and adapter correspondence:

```sh
bash .highway/tools/tests/feature-156-structure-revealing-advisory-contributions.test.sh
bash .highway/tools/tests/adapter-coverage.test.sh
```

## Full validation

Run the complete suite:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: the summary reports zero failed tests. Static-document checks do not establish runtime conversational quality; transcript or live workflow evaluation remains separate evidence.
