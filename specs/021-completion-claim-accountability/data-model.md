# Data Model: Completion Claim Accountability

**Feature**: 021-completion-claim-accountability

## Completion Coverage Record

Path: `specs/<feature>/coverage.md`

| Field | Required | Meaning |
|---|---|---|
| Feature identifier | Yes | Feature directory whose `spec.md` is being covered |
| Requirement ID | Yes | Exactly one `FR-###` or other declared requirement identifier from `spec.md` |
| Outcome | Yes | `satisfied` or `deferred` |
| Evidence | Required for `satisfied` | Repository-relative artifact path and a concise description of the satisfying evidence |
| Deferral reason | Required for `deferred` | Why the requirement is not satisfied and what follow-up owns it |
| Reviewer/status | Yes | Whether the coverage entry is reviewed and the feature status it supports |

### Invariants

- Every requirement ID extracted from `spec.md` appears exactly once.
- No unknown, duplicate, malformed, or missing requirement ID is accepted.
- A satisfied entry names an existing repository-relative artifact.
- A deferred entry names a non-empty reason and is never counted as satisfied.
- The record does not alter the feature's `spec.md` or `tasks.md`.

## Test Evidence Record

Path: `specs/<feature>/test-evidence.md`

| Field | Required | Meaning |
|---|---|---|
| Task identifier | Yes | Implementation task relying on the evidence |
| Test reference | Yes | Test path or named check |
| Claimed behavior | Yes | The behavior the test is intended to discriminate |
| Failing observation | Yes | Recorded command/result showing the behavior was absent before implementation |
| Passing observation | Yes | Recorded command/result after implementation |
| Evidence status | Yes | `observed` or `missing` |

### Invariants

- A failing observation must identify the claimed behavior, not only a non-zero exit code.
- Evidence may describe a static prose-contract test.
- Missing evidence prevents the associated task from being accepted as complete.
- A passing observation without a prior failing observation is insufficient.

## Task Correspondence Record

A review relationship, not necessarily a new file: each completed task in `tasks.md` is checked
against its named artifact path and described change.

The review first checks that every named path exists and then performs the semantic correspondence
judgement against the task sentence. An unchecked task remains deferred and is never promoted by the
review. The automatic test covers the deterministic path and marker fixtures; the semantic change
judgement remains agent-checkable under D7.1.

| Field | Required | Meaning |
|---|---|---|
| Task ID | Yes | The task being reviewed |
| State | Yes | `[X]` or unchecked |
| Named path | Yes | Repository-relative artifact path from the task |
| Described change | Yes | The change the task claims |
| Correspondence result | Yes | `pass`, `fail`, or `deferred` |
| Finding | Required for `fail`/`deferred` | Missing path, absent change, or reason for deferral |

## Completion Report

A report contains separate claims:

1. **Check results**: commands, validators, and suite outcomes.
2. **Requirement coverage**: satisfied IDs, deferred IDs, artifacts, and reasons.
3. **Task status**: completed, incomplete, and semantically reviewed correspondence.
4. **Overall status**: unqualified complete only when no requirement is deferred and no implementation
   task remains incomplete.

The report reviewer rejects a report that merges check results and coverage into one claim. A report
with any deferred requirement or incomplete task uses `qualified` status.
