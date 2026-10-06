# Quickstart: Experience Standard Runtime Contract Refactor

## Prerequisites

- Run from the repository root on branch `141-experience-standard-refactor`.
- Bash and the existing Highway test tools are available.
- The pre-refactor Experience Standard line count is recorded before implementation.

## Focused contract validation

Run the Feature 141 contract test after implementation:

```sh
bash .highway/tools/tests/feature-141-experience-standard-refactor.test.sh
```

Expected result: the test passes the stable X-rule inventory, Interaction Model, targeted guidance,
convergence, clarification, advisory, ownership, history-removal, protected-path, metadata, and
minimum-reduction checks.

## Diff and protected-path validation

```sh
git diff --check
git diff -- .highway/library/knowledge/highway-identity.md .highway/skills/highway-profile .specify/memory/constitution.md
```

Expected result: no protected Feature 141 runtime or governance file is changed, and the diff has no
whitespace errors.

## Full validation

```sh
.highway/tools/tests/run-all.sh
```

Expected result: the full repository suite passes with zero failures. The final document is at least
25% shorter than the recorded baseline while preserving all focused contract checks.
