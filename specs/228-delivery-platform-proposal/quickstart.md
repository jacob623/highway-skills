# Quickstart: Delivery Platform Proposal

Run from the repository root.

1. New test: `bash .highway/tools/tests/delivery-platform-proposal.test.sh`. Expect `PASS: delivery platforms proposes each unset field from execution`.
2. Related tests:
   - `bash .highway/tools/tests/delivery-platform-handoff.test.sh`
   - `bash .highway/tools/tests/establish-from-record.test.sh`
   - `bash .highway/tools/tests/codify-platform-catalog.test.sh`
3. Validator: `bash .highway/tools/validate-skill.sh .highway/skills/highway-implementation`. Expect `OK`.
4. Full suite: `bash .highway/tools/tests/run-all.sh`. Expect 0 failed.

Wording under test: [contracts/wording.md](contracts/wording.md). States: [data-model.md](data-model.md).
