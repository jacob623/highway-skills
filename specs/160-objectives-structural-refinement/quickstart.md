# Quickstart: Objectives Structural Refinement

## Prerequisites

- Run from the repository root.
- macOS or a compatible POSIX shell environment.
- Existing Feature 160 specification and authored Objective skill.

## Baseline

Before implementation, the authored skill was 386 lines and 22,508 bytes. The existing Feature 159
advisory and Objective management checks passed.

## Validate the authored guidance

Run the focused structural and advisory checks:

```sh
bash .highway/tools/tests/feature-159-objectives-advisory.test.sh
```

Expected result: the existing response-support, advisory, portfolio, recommendation lifecycle,
queue, continuation, and protected-contract checks pass.

Inspect the authored skill and verify that the six Feature 160 sections appear as peer sections in
the specified order, that Creation Workflow retains only its workflow responsibilities, and that
the recommendation exemplar contains three distinct bullets plus the explicit response paths.

## Validate generated correspondence

Regenerate adapters from the authored source, then run the Objective management and full suites:

```sh
.highway/tools/generate-agent-adapters.sh
bash .highway/tools/tests/objective-management.test.sh
bash .highway/tools/tests/run-all.sh
```

Expected result: generated adapters correspond to the authored source, Objective management passes,
and the full repository suite reports zero failures.

## Review the size boundary

Confirm that new authored behavioral prose is limited to the six required peer headings and one
concise recommendation exemplar. Existing guidance should be relocated or compressed rather than
duplicated. No Objective record, catalog, identifier, readiness result, mutation report, or setup
boundary should change.

## Completion evidence

Feature 160 is ready for task completion when the focused checks, adapter correspondence checks,
Objective management checks, and full suite pass, and the authored-source review confirms the
clarified prose budget.

## Final Validation Evidence

- Feature 160 structural contract: passed.
- Feature 159 advisory regression: passed.
- Objective management: passed.
- Full repository suite: 84 passed, 0 failed.
- Generated adapters: 4 of 4 match the authored source.
- Authored source: 422 lines and 24,226 bytes; new behavioral prose is limited to the six required
	peer headings and one concise exemplar.
- `git diff --check`: passed.