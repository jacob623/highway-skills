# Quickstart: Highway Reference Implementation Workflow

## Prerequisites

- Run from the repository root.
- Feature 176 source artifacts exist under `specs/176-highway-implementation/`.
- Feature 175 provides the accepted Reference Architecture contract and `ARCH######` identifiers.
- The repository's existing Highway test harness is available.
- Use macOS default Bash-compatible shell behavior; no new dependency is required.

## Design Artifact Checks

```sh
test -f specs/176-highway-implementation/plan.md
test -f specs/176-highway-implementation/research.md
test -f specs/176-highway-implementation/data-model.md
test -f specs/176-highway-implementation/contracts/implementation-workflow.md
test -f specs/176-highway-implementation/quickstart.md
```

## Focused Contract Validation

After implementation, run:

```sh
bash .highway/tools/tests/highway-implementation-onboarding.test.sh
```

Expected result: the test reports the implementation skill contract, shared output templates,
ownership boundaries, ARCH-to-RI resolution, optional-input handling, realization sections,
no-write failures, deterministic identifier rules, deferred artifacts, and generated
adapter/catalog correspondence as passing.

## Generated Surface Validation

Regenerate the declared derived surfaces after source edits:

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-instructions.sh
```

Then run:

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

1. One accepted `ARCH######` creates exactly one proposed `RI######` record and one catalog entry.
2. Missing optional governance continues without fabricated relationships.
3. Blocked optional governance continues and appears in implementation risks.
4. Complete and in-progress Clarification contribute according to status; malformed Clarification
   falls back to architecture evidence without mutation.
5. Malformed optional Profile, Objective, Control, or NFR aborts without writes.
6. Missing, ambiguous, malformed, duplicate, or non-accepted architecture input aborts without
   writes.
7. Invalid catalog state, allocation conflict after three retries, validation failure, and write
   failure preserve all pre-operation bytes.
8. Repeated identical inputs produce byte-identical implementation and catalog output.
9. Technology choices are present only when architecture intent and deterministic evidence support
   them, and every choice is traceable.
10. Controls, NFRs, lifecycle activities, dependencies, risks, and constraints are represented.
11. Generated adapters and catalogs match authoritative source files.
12. Deferred plans, tasks, source code, infrastructure definitions, deployment authorization, and
    self-service productization artifacts are absent.
