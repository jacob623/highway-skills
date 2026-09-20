# Quickstart: Reference Implementation Evaluation

## Prerequisites

Run from the repository root on macOS or another supported environment:

- Feature 050 files exist under `specs/050-reference-implementation-evaluation/`.
- The existing Discovery skill and shell test harness are available.
- No network service or additional package is required.

## Structural Validation

Confirm the feature artifacts and registration resolve to Feature 050:

```sh
ruby -rjson -e 'puts JSON.parse(File.read(".specify/feature.json"))["feature_directory"]'
.specify/scripts/bash/check-prerequisites.sh --json --paths-only
```

Expected result: the feature directory and `FEATURE_SPEC` point to `specs/050-reference-implementation-evaluation`.

## Specification Checks

```sh
grep -Fq 'Reference Implementation Count' specs/050-reference-implementation-evaluation/spec.md
grep -Fq 'Evaluation MUST stop immediately' specs/050-reference-implementation-evaluation/spec.md
! grep -Fq '[NEEDS CLARIFICATION' specs/050-reference-implementation-evaluation/spec.md
git diff --check
```

Expected result: every command exits zero.

## Behavioral Scenarios

Use the existing Discovery test harness to verify the implementation after tasks are completed:

```sh
./.highway/tools/tests/highway-discovery.test.sh
```

The relevant scenarios must prove:

1. Explicit Reference Architecture references produce matches.
2. Duplicate matching paths count one unique implementation.
3. Missing, unreadable, malformed, and inconsistent catalog cases continue with zero affected counts.
4. Reference Implementation evidence does not change Recommendation scores or confidence.
5. Ties resolve in Reference Architecture Match, Reference Implementation Count, then lowest `OPT` order.
6. Tie evaluation stops after the first resolving criterion.
7. Repeated identical executions produce identical outcomes.

## Full Repository Validation

```sh
./.highway/tools/tests/run-all.sh
```

Expected result: all existing tests pass, with no generated-artifact or distribution drift.

See [data-model.md](data-model.md) for entities and [contracts/](contracts/) for the internal evaluation contracts.
