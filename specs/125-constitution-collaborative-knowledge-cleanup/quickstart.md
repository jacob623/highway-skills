# Quickstart: Constitution Collaborative Knowledge Cleanup

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The implementation target is `.highway/governance/constitution.md`. Preserve the current working
changes from Feature 124 while reviewing the Feature 125 diff.

## Focused validation

After implementation, verify the exact structural and semantic requirements:

```sh
grep -nE '^### (XI\. Repository Context|XII\. Owner-Controlled Completion and Orchestration|Acceptance-to-owner-result persistence boundary|XIII\. Collaborative Knowledge Development|Collaborative knowledge lifecycle|Principle Precedence)' .highway/governance/constitution.md
grep -nF '| P12A.2 | A skill MUST distinguish a Working Idea from a Converged Proposal. | Artifact acceptance occurs only after a complete candidate result exists. | [agent-checkable] |' .highway/governance/constitution.md
grep -nF '**Version**: 6.1.0' .highway/governance/constitution.md
git diff --name-only -- .highway/governance/constitution.md
```

Expected outcome: the headings appear in the specified order, the P12A.2 row matches exactly,
version `6.1.0` remains present, and implementation changes are confined to the Constitution.

Review the final diff to confirm P12A.1, P12A.3, P12A.4, P12.5-P12.15, definitions, lifecycle,
governance wording, and the persistence boundary are unchanged except for the requested section
name/placement and precedence metadata.

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: all repository tests pass. If a current validator encodes the former `XII-A`
placement or exact old precedence, record that as a validation compatibility issue rather than
modifying files outside `.highway/governance/constitution.md`.
