# Highway Assessment Quickstart

## Prerequisites

Run from the repository root with the existing Highway toolchain available. The workflow is
repository-native and requires no additional package installation.

## Validate the contracts

```bash
bash .highway/tools/validate-skill.sh .highway/skills/highway-assessment
bash .highway/tools/validate-library.sh .highway/library/knowledge/assessment-findings.md
bash .highway/tools/tests/highway-assessment.test.sh
```

Expected result: the skill and findings artifact pass validation, and the focused contract test
reports no failures.

## Regenerate distributed artifacts

```bash
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/generate-catalog.sh
bash .highway/tools/generate-library-catalog.sh
```

Expected result: the four adapter copies and catalog/manifests correspond to the canonical skill and
knowledge artifact.

## Run the full suite

```bash
bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: all repository tests pass and no whitespace errors are reported.

## Manual interaction scenarios

1. Start `/highway-assessment` with an existing findings record containing Open and non-Open rows.
   Verify all Open rows appear before new analysis.
2. Run `/highway-assessment portfolio` against accepted context containing a grounded cross-artifact
   relationship. Verify the observation is advisory and receives a deterministic fingerprint.
3. Re-run with equivalent evidence. Verify the existing `F###` row is reused rather than duplicated.
4. Apply a status change from the revision that was read, then attempt another update from that old
   revision. Verify the stale update is rejected without changing the newer record.
5. Request architecture or implementation creation from assessment. Verify the request is routed to
   the responsible owner instead of being performed by assessment.
