# Feature 080 Validation Quickstart

## Prerequisites

Run from the repository root on macOS or a GNU-compatible environment with Bash 3.2-compatible syntax and the existing command-line toolchain.

## Focused validation

Run the focused governance assertions:

```sh
bash .highway/tools/tests/rule-checks.test.sh
bash .highway/tools/tests/coverage-summary.test.sh
```

Expected result: both tests exit `0`. The checks must confirm:

- X2.1-X2.6 are unique rows under one X2 table with ID, Rule, Observable, Tier, and Sample fields.
- X2.2-X2.6 remain `[agent-checkable]` with Feature 079 wording and samples.
- Guided information-collection workflow and Implementation details are defined.
- The N/A Scenario/Example records `X2.5=N5` and `X2.6=N5` without classifying N/A as compliant or non-compliant.
- PASS/FAIL/N/A remains the only verdict vocabulary.

## Full validation

Run the complete repository suite:

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the suite reports zero failed tests and `git diff --check` exits `0`.

## Manual review points

Inspect `.highway/governance/experience-standard.md` and verify that the amendment preserves:

- X2.1, X namespace, N5, versioning policy, and existing X2.2-X2.6 semantics.
- Existing compliant and non-compliant examples for applicable collection and long-running behavior.
- The unchanged `.highway/tools/.distribution-manifest`.

The data entities and invariants are described in [data-model.md](data-model.md); the research decisions are recorded in [research.md](research.md).
