# Quickstart: Clarification Guided Resolution Workflow

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The focused contract test uses disposable fixtures and does not modify user-owned Request,
Discovery, ADR, or Architecture artifacts.

## Focused validation

```sh
.highway/tools/tests/highway-clarify.test.sh
```

Expected result:

```text
PASS: highway-clarify contract and disposable workspace checks
```

The fixture matrix covers:

1. Complete guidance fields and A/B/C/D ordering.
2. Repeated-generation determinism and source traceability.
3. Artifact-specific source sets and global precedence.
4. Missing evidence and highest-precedence conflicting evidence escalation.
5. Informational A/B/C/D/None selection and separate accepted-response resolution.
6. Resolved guidance retention, invalid values, privacy filtering, conflicts, and no partial writes.

## Contract and packaging validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-clarify
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result is zero failed checks and no whitespace errors. Revalidate all generated
Clarification adapters and every skill that cites the changed shared template before completion.

## References

- [Feature specification](spec.md)
- [Implementation plan](plan.md)
- [Data model](data-model.md)
- [Guided resolution contract](contracts/guided-resolution-contract.md)
