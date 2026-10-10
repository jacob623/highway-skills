# Quickstart: Interpretation Confidence

## Prerequisites

Run from the repository root with the existing shell toolchain available.

## Focused validation

Run the feature contract:

```sh
.highway/tools/tests/feature-158-interpretation-confidence.test.sh
```

Expected result: the test passes the subsection placement, exact guidance, verification statements,
protected-content checks, and generated-adapter correspondence checks.

## Regenerate adapters

After editing the authoritative Profile source, regenerate distributed adapters:

```sh
.highway/tools/generate-agent-adapters.sh
```

Then rerun the focused contract.

## Full validation

Run the complete repository suite:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: all existing checks pass, including the focused Feature 158 contract.

## Validation boundaries

The static contract proves the authored wording, placement, protected sections, and adapter
identity. It does not by itself prove runtime conversational quality; the existing Experience
Standard and Profile behavioral contracts remain the governing runtime sources.
