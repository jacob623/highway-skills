# Quickstart: Static Operating NFRs

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `191-static-operating-nfrs`
- The NFR and Request skill sources are available for a manual pass

## Confirm the NFR review

1. Read `.highway/skills/highway-nfrs/SKILL.md` and confirm a new-set review includes **No system hosting** and **Direct purchase** with the queued NFRs.
2. Confirm silence uses the default statements in [contracts/operating-limits.md](contracts/operating-limits.md), and accepted hosting or buying material replaces the matching default.
3. Confirm a stored-record review does not insert a limit the person removed.

## Confirm the Request

1. Read `.highway/skills/highway-request/SKILL.md` and confirm the field mapping in [data-model.md](data-model.md).
2. Confirm a removed or retitled limit is not recreated from another NFR.
3. Confirm `.highway/skills/highway-discovery/SKILL.md` is unchanged.

## Confirm the suite

Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.

Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-nfrs` and `.highway/skills/highway-request`. Each exits 0.
