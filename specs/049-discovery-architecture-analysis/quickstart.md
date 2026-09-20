# Feature 049 Quickstart

This guide validates the planned Discovery architecture-analysis behavior without requiring a
network service or a new runtime. Run commands from the repository root.

## Prerequisites

- Feature pointer resolves to `specs/049-discovery-architecture-analysis`.
- Existing Highway tools are executable.
- Disposable Request, governance, Reference Architecture, and Reference Implementation fixtures
  are created outside the live `requests/` and `discoveries/` paths.
- The canonical skill and shared templates are updated before generated adapters are regenerated.

## Focused Contract Validation

Run the existing Discovery contract test:

```sh
./.highway/tools/tests/highway-discovery.test.sh
```

Expected result: the contract and disposable-workspace checks pass, including byte preservation
on invalid-input and write-failure paths.

## Deterministic Analysis Scenarios

For each scenario, run the Discovery workflow twice with identical closed inputs and compare the
record and catalog bytes with `shasum` or `cmp`:

1. Three viable strategies produce exactly three options, stable `OPT` identifiers, a complete
   matrix, and one recommendation.
2. Two viable strategies produce two options; fewer than two aborts without writes.
3. More than five viable strategies retain the deterministic first five and record truncation.
4. Multiple exact Reference Architecture matches report every candidate and each candidate's
   highest-precedence reason.
5. Equal scores prefer a matched architecture; all-matched ties use the highest associated
   Reference Implementation count, then lower `OPT`; absent/unreadable catalogs make every count
   zero and use lower `OPT`.
6. Adding or removing informational categories leaves score, confidence, ranking, selection, and
   option ordering unchanged.
7. An ADR handoff exposes all options, matrix values, recommendation rationale, and matches while
   the Discovery artifact contains no decision fields.

## Repository Validation

After implementation and regeneration, run:

```sh
./.highway/tools/validate-skill.sh .highway/skills/highway-discovery/SKILL.md
./.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md
./.highway/tools/tests/highway-discovery.test.sh
./.highway/tools/tests/run-all.sh
```

Expected result: each focused validator and the full suite pass; generated adapters and catalogs
match the canonical sources; source baselines and user-owned inputs remain byte-for-byte unchanged.