# Quickstart: Clarification Record Integrity

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The focused tests use disposable fixtures and do not modify user-owned governance artifacts.

## Focused Contract Validation

```sh
.highway/tools/tests/highway-clarify.test.sh
.highway/tools/tests/output-template.test.sh
```

Expected result: both tests pass. Coverage must include:

1. Unique Resolution History Finding references and required history fields.
2. Complete frontmatter delimiters and exactly-once metadata fields.
3. Retained data separated from explanatory contract prose.
4. Canonical fingerprint alignment and placeholder escalation ownership.
5. Zero, one, and multiple Evidence Sources with three-field traceability or `None`.
6. Recommendation Basis mappings for authoritative, evidence-gap, and conflict states.
7. Option selection, response authority, explicit acceptance, and open-to-resolved lifecycle.
8. No-partial-write and source-immutability behavior across REQ, DISC, ADR, and RA records.

## Contract and Generated-Artifact Validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-clarify
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result is zero failed checks and no whitespace errors. Revalidate the generated
Clarification adapters and the canonical skill that cites the shared template.

## References

- [Feature specification](spec.md)
- [Implementation plan](plan.md)
- [Research decisions](research.md)
- [Data model](data-model.md)
- [Clarification record contract](contracts/clarification-record-integrity.md)
