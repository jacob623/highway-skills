# Quickstart: Discovery Contract Consolidation

## Prerequisites

Run from the repository root on macOS or another supported shell environment. The repository
must contain the authoritative Discovery skill, its adapter generator, and the existing shell
suite. No network service or additional package is required.

## Structural Contract Validation

```sh
source=.highway/skills/highway-discovery/SKILL.md
[ "$(grep -c '^## Verification$' "$source")" -eq 1 ]
[ "$(grep -c '^## Error Handling$' "$source")" -eq 1 ]
! grep -Fq '## Verification Expectations' "$source"
! grep -Fq '## Error Handling Expectations' "$source"
 grep -Fq 'Recommendation Tie-Break Evaluation' "$source"
! grep -Fq 'prefer a matched architecture' "$source"
```

Expected result: every command exits zero.

## Focused Discovery Validation

```sh
/usr/bin/perl -e 'alarm shift; exec @ARGV' 300 ./.highway/tools/tests/highway-discovery.test.sh
```

Expected result: the focused Discovery contract and disposable-workspace checks pass.

## Adapter Regeneration and Currency

```sh
./.highway/tools/generate-agent-adapters.sh
./.highway/tools/tests/adapter-coverage.test.sh
```

Expected result: generation succeeds without drift errors and adapter correspondence/currency
checks pass.

## Full Repository Validation

```sh
/usr/bin/perl -e 'alarm shift; exec @ARGV' 300 ./.highway/tools/tests/run-all.sh
```

Expected result: the full repository suite passes with no generated-artifact or governance
validation failures.

## Manual Review

Compare the merged sections and Workflow step 10 in the authoritative source against
[spec.md](spec.md), [data-model.md](data-model.md), and
[contracts/discovery-contract-consolidation.md](contracts/discovery-contract-consolidation.md).
Confirm that no ADR, decision, authorization, or governance mutation was introduced.
