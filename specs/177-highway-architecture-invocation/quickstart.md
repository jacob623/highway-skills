# Quickstart: Feature 177 Invocation Guards

## Prerequisites

Run from the repository root on macOS with the existing Bash 3.2-compatible toolchain.

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

## Validate the source contracts

Run the two focused onboarding tests:

```sh
.highway/tools/tests/highway-architecture-onboarding.test.sh
.highway/tools/tests/highway-implementation-onboarding.test.sh
```

Expected result: both tests print a `PASS` line and exit 0.

## Validate the generated surfaces

Regenerate the catalog and agent adapters using the existing repository generators, then run the focused tests again:

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/highway-architecture-onboarding.test.sh
.highway/tools/tests/highway-implementation-onboarding.test.sh
```

The generated catalog and adapters must remain current with the two authoritative source skills.

## Validate the full suite

```sh
.highway/tools/tests/run-all.sh
```

Expected result: the complete suite exits 0.

## Manual contract scenarios

1. Invoke `/highway-architecture` without an identifier. Confirm the exact ADR next action, question, examples, and zero writes.
2. Invoke `/highway-architecture ADR000001`. Confirm exact identifier validation, unique ADR resolution, canonical completeness/readiness validation, and continued processing only when all pass.
3. Invoke `/highway-implementation` without an identifier. Confirm the exact ARCH next action, question, examples, and zero writes.
4. Invoke `/highway-implementation ARCH000001`. Confirm exact identifier validation, unique architecture resolution, canonical completeness/readiness validation, and continued processing only when all pass.
5. Repeat missing-input scenarios with zero, one, and many candidate sources. Confirm no source is selected from availability, order, timestamp, recency, context, environment, or session state.

See [data-model.md](data-model.md) for transient guard entities and [contracts/invocation-guards.md](contracts/invocation-guards.md) for exact command contracts.
