# Quickstart: Discovery Clarification Status Rules

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The focused contract test creates disposable Request, Clarification, and Discovery fixtures and cleans
them up before exit. No runtime dependency or user-owned artifact is required.

## Focused validation

```sh
.highway/tools/tests/highway-discovery.test.sh
```

Expected result:

```text
PASS: highway-discovery contract and disposable workspace checks
```

The fixture matrix covers:

1. `not-started`, `in-progress`, `complete`, and `blocked` status projections.
2. Request-over-response precedence and disagreement risk evidence.
3. Open versus resolved finding projection.
4. Unreadable, malformed, path-mismatched, state-invalid, and count-invalid fallback.
5. Byte preservation, repeated-run determinism, and unchanged candidate/recommendation behavior.

## Full validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result is zero failed tests and no whitespace errors. Regenerate distributed artifacts before
validation when the canonical Discovery skill changes:

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
```

## Contract references

- [Clarification status contract](contracts/clarification-status-consumption-contract.md)
- [Data model](data-model.md)
- [Feature specification](spec.md)
