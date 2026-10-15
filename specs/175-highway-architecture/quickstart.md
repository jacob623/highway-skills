# Quickstart: Highway Reference Architecture Workflow

## Prerequisites

- Run from the repository root.
- Feature 175 source artifacts exist under `specs/175-highway-architecture/`.
- The repository's existing Highway test harness is available.
- Use macOS default Bash-compatible shell behavior; no new dependency is required.

## Design Artifact Checks

Verify the generated design artifacts exist:

```sh
test -f specs/175-highway-architecture/plan.md
test -f specs/175-highway-architecture/research.md
test -f specs/175-highway-architecture/data-model.md
test -f specs/175-highway-architecture/contracts/architecture-workflow.md
test -f specs/175-highway-architecture/quickstart.md
```

## Focused Contract Validation

After implementation, run the architecture-specific test:

```sh
bash .highway/tools/tests/highway-architecture-onboarding.test.sh
```

Expected result: the test reports the architecture skill contract, output templates, ownership
boundaries, deterministic identifier rules, optional-input handling, no-write failures, and
regenerated adapter/catalog correspondence as passing.

## Generated Surface Validation

Regenerate the declared derived surfaces after source edits:

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-instructions.sh
```

Then run adapter and library checks:

```sh
bash .highway/tools/tests/adapter-coverage.test.sh
bash .highway/tools/tests/validate-library.test.sh
bash .highway/tools/tests/validate-skill.test.sh
```

## Full Validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: all repository tests pass and the diff has no whitespace errors.

## Behavioral Fixture Matrix

The focused implementation test should cover at least:

1. One accepted ADR creates exactly one proposed `ARCHXXXXXX` record and one catalog entry.
2. Missing optional governance input continues without fabricated relationships.
3. Blocked optional governance input continues and appears in architecture risks.
4. Malformed optional input aborts without writes.
5. Missing, ambiguous, malformed, duplicate, or non-accepted ADR input aborts without writes.
6. Invalid catalog state, allocation exhaustion, validation failure, and write failure preserve all
   pre-operation bytes.
7. Repeated identical inputs produce byte-identical record and catalog output.
8. Generated adapters and catalogs match authoritative source files.
9. Deferred capability artifacts, diagrams, threat models, scoring, and implementation outputs are
   absent.
