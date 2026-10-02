# Quickstart: Collaborative Knowledge Development

## Prerequisites

- Run from the repository root: `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`.
- Use the repository's supported shell environment. Tests must remain compatible with macOS Bash 3.2.
- Keep the canonical Constitution at `.highway/governance/constitution.md`.

## Focused validation

Run the constitutional checks that cover the amendment's direct surfaces:

```sh
bash .highway/tools/tests/constitution-inventory.test.sh
bash .highway/tools/tests/coverage-summary.test.sh
bash .highway/tools/tests/rule-checks.test.sh
bash .highway/tools/tests/generate-agent-adapters.test.sh
```

Expected outcome: the Constitution contains exactly one valid record for `P12A.1` through
`P12A.4`, each rule has the required obligation/observable/tier shape, existing P12.5-P12.15
records remain present, and generated adapter output remains aligned.

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: all repository tests pass, including governance routing, profile/context
contracts, generated-output correspondence, and existing owner-result checks.

## Manual review assertions

Review the final Constitution diff against [spec.md](spec.md) and [data-model.md](data-model.md):

- Working Ideas and Active Reasoning Context remain non-authoritative and non-retained.
- Converged Proposal completeness belongs to the owning workflow; no literal acceptance wording is required.
- P12.5-P12.15 and owner mutation ordering are unchanged.
- The precedence table places `XII-A` below X and above XI.
- The Sync Impact Report names all six downstream areas and records the requested rollout order.
- No new conversation-state, reasoning, thread-catalog, or cross-interaction restoration artifact exists.
