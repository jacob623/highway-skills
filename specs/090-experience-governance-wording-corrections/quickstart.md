# Feature 090 Validation Quickstart

## Prerequisites

- Repository root as the current working directory.
- macOS or another environment compatible with the repository's Bash 3.2-compatible scripts.
- No individual skill migration is required for this feature.

## Focused validation

### Baseline before implementation

- Experience Standard: version 1.6.0; X2.9 was `[agent-checkable]` with Sample `new` and N7 applicability.
- Constitution: version 2.6.0; Principle XII was rank 11, Principle XI was rank 10, and Experience Compliance was rank 9.
- Constitution history: the completed 2.5.0 -> 2.6.0 Feature 089 amendment was the latest completed report, with a duplicate Principle XI rationale present.

Run the governance inventory and UX alignment checks:

```sh
bash .highway/tools/tests/constitution-inventory.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected result: both commands exit 0 and report PASS. The checks must prove the corrected
authority wording, five-category X2.9 alignment, preserved X2.9 boundaries, orphan removal,
Principle XII placement and ranks, duplicate Principle XI rationale removal, and unchanged
identifier/tier/N/A counts.

## Full validation

Run the complete repository suite:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: every registered test passes and the summary reports zero failures.

Feature 090 validation result: the focused UX alignment and constitution inventory tests both exit 0;
the complete suite exits 0 with `47 passed, 0 failed`.

## Manual governance review

1. Confirm the Constitution Sync Impact Report explicitly classifies the Principle XII precedence
   change under the Constitution Versioning Policy and explains its conflict-resolution impact.
2. Confirm the Experience Standard authority and disclaimer refer to the X2 namespace generally,
   while the Interactive Workflow UX Contract remains interpretive guidance.
3. Confirm X2.9 remains X2.9 with its existing Tier, Sample classification convention, Observable
   boundary, and N7 condition; only the minimum trigger wording is aligned.
4. Confirm no individual skill file or user-owned governance record appears in the diff.
5. Confirm the final diff is whitespace-clean:

```sh
git diff --check
```
