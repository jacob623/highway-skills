# Quickstart: Discovery Contract Completion

## Prerequisites

Run from the repository root on macOS or another supported environment:

- `discovery.md` exists at the repository root.
- Shared Discovery record and catalog templates exist under `.highway/library/templates/output/`.
- Existing Discovery shell tests are available under `.highway/tools/tests/`.
- No network service or additional package is required.

## Structural Contract Checks

```sh
grep -Fq '### Outputs' discovery.md
grep -Fq 'discoveries/DISCXXXXXX.md' discovery.md
grep -Fq 'discoveries/discoveries.md' discovery.md
grep -Fq '### Reference Implementation Matching' discovery.md
grep -Fq '### Reference Implementation Counting' discovery.md
grep -Fq '### Recommendation Tie-Break Evaluation' discovery.md
grep -Fq '### Reference Implementation Determinism' discovery.md
grep -Fq '### Reference Implementation Scope Clarification' discovery.md
grep -Fq '### Reference Implementation Traceability' discovery.md
grep -Fq '### Verification Expectations' discovery.md
grep -Fq '### Error Handling Expectations' discovery.md
```

Expected result: every command exits zero and the Outputs section contains no orphaned prose.

## Focused Behavioral Validation

```sh
perl -e 'alarm shift; exec @ARGV' 300 ./.highway/tools/tests/highway-discovery.test.sh
```

Expected result: the focused Discovery suite passes and covers explicit matching, unique counting,
zero-count fallbacks, tie-break order, score/confidence preservation, and advisory ADR ownership.

## Full Repository Validation

```sh
perl -e 'alarm shift; exec @ARGV' 300 ./.highway/tools/tests/run-all.sh
```

Expected result: the full suite passes with no generated-artifact or distribution drift.

## Manual Contract Review

Review [discovery-output-contract.md](contracts/discovery-output-contract.md),
[reference-implementation-evaluation-contract.md](contracts/reference-implementation-evaluation-contract.md),
and [recommendation-tie-break-contract.md](contracts/recommendation-tie-break-contract.md) against
[spec.md](spec.md). Confirm that matching is explicit, counts are unique, malformed and unavailable
inputs follow their stated fallbacks, tie evaluation stops after a winner, and ADR remains the
sole owner of decisions.
