# Quickstart: Propose Edit Lines

## Static checks

1. Run `bash .highway/tools/tests/propose-edit-lines.test.sh`. Expect a PASS line.
2. Run `bash .highway/tools/validate-skill.sh .highway/skills/highway-codify`. Expect `OK`.
3. Run the full suite with `bash .highway/tools/tests/run-all.sh`. Expect 0 failed.

## Behavior walkthrough

The person sees the same proposal. Each edit still does what [data-model.md](data-model.md) lists. The only difference is that the instruction states each kind on its own line. See [contracts/edit-lines.md](contracts/edit-lines.md).
