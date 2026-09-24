# Feature 088 Quickstart

## Prerequisites

Run commands from the repository root. Confirm the three context documents exist:

```sh
test -f .highway/library/knowledge/highway-identity.md
test -f .highway/library/knowledge/highway-vision.md
test -f .highway/library/knowledge/highway-platform-objectives.md
```

No new runtime dependency is required. The implementation changes only the two governance files:

- `.highway/governance/constitution.md`
- `.highway/governance/experience-standard.md`

## Focused governance validation

Run the existing structural and experience checks:

```sh
bash .highway/tools/tests/constitution-inventory.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected result: both commands exit 0. The checks must confirm unique rule identifiers, valid rule
fields and tiers, the Identity -> Vision -> Platform Objectives precedence, the new X2.7/X2.8
guidance, and preservation of existing interaction rules.

## Static contract probes

Review the changed documents for the following conditions:

```sh
grep -n 'Repository Context Documents' .highway/governance/constitution.md
grep -n 'Identity.*Vision.*Platform Objectives' .highway/governance/constitution.md
grep -n 'X2.7\|X2.8\|Contextual Guidance' .highway/governance/experience-standard.md
```

Confirm that accepted repository artifacts are supplements, that missing context cannot be
invented, and that context acknowledgments do not promote unrelated capabilities.

## Full validation

Run the complete repository suite:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: the suite exits 0. Record executable test results separately from the static
constitutional review required by FR-022 and SC-014.

## Review checklist

- Confirm FR-004 declaration is distinct from FR-019 selective consumption.
- Confirm all added constitutional rules have one keyword, one Observable, an allowed tier, and
  unique IDs within the governing document.
- Confirm Identity -> Vision -> Platform Objectives is an ordered conflict-resolution path.
- Confirm no-context cases do not fabricate, assume, or substitute repository context.
- Confirm no Experience Principles document is added by Feature 088.
