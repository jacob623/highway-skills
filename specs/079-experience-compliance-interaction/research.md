# Feature 079 Research

## Decision: Reuse the shipped governance parser and validator

**Decision**: Continue loading `.highway/governance/constitution.md` and
`.highway/governance/experience-standard.md` through `.highway/tools/lib/constitution.sh`, and
report both rule inventories through the existing validator path.

**Rationale**: The repository already resolves both documents from the framework root, parses the
P and X namespaces, and has inventory coverage proving that both documents are read. A second
loader would create a competing source of truth and violate the feature's no-second-enforcement
constraint.

**Alternatives considered**: A separate Experience Standard validator was rejected because it
would duplicate rule loading and reporting. Parsing only the Constitution was rejected because
X rules would remain outside the review contract.

## Decision: Preserve the existing five-group output contract

**Decision**: Extend the existing output contract to include applicable X rules without changing
the groups `CHECKED`, `FAILED`, `N/A`, `DEFERRED`, and `UNCHECKED`, or the verdict vocabulary
`PASS`, `FAIL`, and `N/A`.

**Rationale**: `coverage-summary.test.sh` already asserts the five groups, exactly-one-group
coverage, and condition-bearing N/A entries. Keeping that shape makes constitutional and
Experience Standard results comparable and avoids downstream parser churn.

**Alternatives considered**: Adding `WARN`, `INFO`, `PARTIAL`, or `NOT TESTED` was rejected because
the Constitution's Compliance Review Protocol defines a closed verdict vocabulary. A separate X
summary was rejected because it would make cross-document review incomplete.

## Decision: Represent X2.5 and X2.6 non-applicability with existing N/A conditions

**Decision**: Treat no-long-running-activity cases as N/A under the existing condition-token
mechanism, with explicit X2.5/X2.6 conditions documented in the Experience Standard and asserted
by review-output tests.

**Rationale**: The current protocol requires every N/A result to name a permitted condition. The
feature therefore extends the condition vocabulary only where the X rules need it and keeps N/A
outcomes distinguishable from PASS and FAIL.

**Alternatives considered**: Treating these rules as PASS was rejected because it hides that the
trigger did not arise. Treating them as FAIL was rejected because the spec explicitly defines the
rules as non-applicable without a long-running activity.

## Decision: Grandfather unchanged skills

**Decision**: Apply the new constitutional Experience Compliance obligations to newly created or
amended skills, while leaving unchanged existing skills valid without forced rewrites.

**Rationale**: The feature explicitly distinguishes required modifications from historical
review. This avoids a broad migration unrelated to the governance amendment while ensuring every
future change is evaluated against applicable X rules.

**Alternatives considered**: Rewriting every existing skill was rejected as out of scope and
would create unrelated contract changes. Ignoring Experience Compliance for amended skills was
rejected because it would make the new constitutional obligation unenforceable at the point of
change.

## Decision: Use repository shell tests and disposable fixtures for validation

**Decision**: Add or amend focused tests under `.highway/tools/tests/`, run them against existing
fixtures, and finish with the full `run-all.sh` suite and `git diff --check`.

**Rationale**: This matches D3.3, D3.4, D3.6, and the established test harness. The feature has
no live skill runner, so runtime conversation behavior is documented and reviewed as an
agent-checkable contract rather than falsely represented as automated behavior.

**Alternatives considered**: Adding a new runtime or model-based evaluator was rejected because it
would add a dependency and exceed the feature scope. Golden live-output fixtures were rejected
because skills are Markdown instructions and cannot be executed by the current repository.
