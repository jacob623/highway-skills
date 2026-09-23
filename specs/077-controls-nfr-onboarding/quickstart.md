# Quickstart: Controls and NFRs Onboarding Enhancement

## Prerequisites

- Repository root is `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`.
- Bash 3.2-compatible shell and the existing `.highway/tools/` utility toolchain are available.
- Feature 077 source and generated artifacts are present.

## Focused validation

Run the feature-focused tests after implementation:

```sh
.highway/tools/tests/highway-controls.test.sh
.highway/tools/tests/control-derived-nfr.test.sh
.highway/tools/tests/highway-nfrs.test.sh
.highway/tools/tests/highway-setup.test.sh
```

Expected result: every focused test exits 0 and covers collection cancellation, review completeness,
transaction atomicity, duplicate handling, candidate ordering, readiness states, and existing-baseline
routing.

## Generated-artifact validation

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/adapter-coverage.test.sh
```

Expected result: generators complete without stale or hand-edited output and correspondence checks
pass.

## Full validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the full suite exits 0, no whitespace errors are reported, and all governed writes
in failure fixtures preserve their pre-operation bytes.

## Behavioral scenarios

1. Start with valid Profile and Objective prerequisites and no Control baseline. Run Control setup,
   collect one or more statements across the four fixed categories, cancel collection, and verify
   no records, catalog, relationship, or candidate bytes changed.
2. Re-run collection, leave one proposal undecided, invoke Cancel Review, and verify no writes. Then
   decide every proposal and invoke Review Complete; verify one atomic Control transaction.
3. Verify candidate output is ordered by persisted Control ID and availability/security/performance
   rule order. Review candidates with a duplicate NFR fixture and verify failure before NFR allocation.
4. Invoke setup with an existing valid Control baseline and verify no collection prompts are shown.
5. Exercise NFR Review Complete with all candidates decided, then exercise cancellation and an injected
   write failure; verify the NFR baseline and relationships are unchanged on both no-write paths.

See [data-model.md](./data-model.md) for state transitions and [contracts/](./contracts/) for the
command and readiness contracts.
