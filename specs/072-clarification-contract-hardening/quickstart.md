# Quickstart: Clarification Contract Hardening

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The focused Clarification test uses disposable fixtures and does not modify user-owned Request,
Discovery, ADR, or Reference Architecture artifacts.

## Focused contract validation

```sh
.highway/tools/tests/highway-clarify.test.sh
```

Expected result:

```text
PASS: highway-clarify contract and disposable workspace checks
```

The focused matrix must cover:

1. Skill/template version `2.0.0` alignment and category/fingerprint consistency.
2. Two-stage source-set filtering for REQ, DISC, ADR, and RA.
3. Global precedence after filtering, including ignored non-member sources.
4. `Unknown` for absent evidence and `Unknown / Escalate for Decision` for conflicting highest-precedence evidence.
5. Evidence Sources with Source Type, Source Identifier, and Reason Used.
6. REQ, DISC, ADR, and RA escalation-owner mapping.
7. Informational A/B/C/D/None selection, explicit response acceptance, and open-to-resolved-only transition.
8. Consumer restrictions, ownership prohibitions, source immutability, and no-partial-write behavior.

## Contract and generated-artifact validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-clarify
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result is zero failed checks and no whitespace errors. Revalidate every generated
Clarification adapter and every skill that cites the changed shared clarification-record template.

## References

- [Feature specification](spec.md)
- [Implementation plan](plan.md)
- [Research decisions](research.md)
- [Data model](data-model.md)
- [Clarification contract](contracts/clarification-contract-hardening.md)
