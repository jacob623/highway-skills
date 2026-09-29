# Quickstart: Validate the Advisory Experience Amendment

Run these from the repository root after the amendment. The identifier maps are in [contracts/experience-standard-amendment.md](./contracts/experience-standard-amendment.md) and [contracts/constitution-output-relocation.md](./contracts/constitution-output-relocation.md). Field rules are in [data-model.md](./data-model.md).

## Prerequisites

- The governance edits are `.highway/governance/experience-standard.md` and `.highway/governance/constitution.md`.
- Tests, the specimen check, and skill citations of the removed contract or retired identifiers are in scope.
- Skill domain workflows, shared templates, and the development constitution stay unchanged.

## 1. Implementation files

```sh
git diff --name-only -- .highway/governance/experience-standard.md .highway/governance/constitution.md .highway/skills .highway/library .highway/tools .specify/memory/constitution.md
```

Expect the two governance files, citation updates under `.highway/skills/`, and updates under `.highway/tools/tests/` plus `.highway/tools/lib/rule-checks.sh`. Expect no shared-template diff and no development-constitution diff.

## 2. Versions

Confirm the Experience Standard footer is 3.0.0, the ratified date is 2026-09-08, and the last-amended date is 2026-09-29. Confirm the Skills Constitution footer is 4.1.0, the ratified date is 2026-09-06, and the last-amended date is 2026-09-29. Confirm each file has a new sync impact report and still has its older reports.

## 3. Moved obligations

Confirm P9.2 through P9.8 are current constitution rows tagged agent-checkable. Confirm X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, and X6.1 are not current Experience Standard rows. Confirm the precedence table is unchanged.

## 4. Interaction authority

Confirm the Interactive Workflow UX Contract, the N/A token table, and the Sample column are absent as current sections. Confirm X1.6, X1.7, X2.1 through X2.31, X5.1, and X5.2 are current rows. Confirm the inferred-content heading and the five-choice limit are present. Confirm the short eleven-step model is present.

## 5. Shipped tokens and ownership

Confirm neither governance file contains `.specify/` or `specs/`. Confirm the Experience Standard does not name the development constitution as a runtime dependency. Confirm it still keeps user-owned strategy, policy, requirements, priorities, and preferred wording outside its authority.

## 6. Suite

```sh
.highway/tools/tests/run-all.sh
```

Expect exit 0. The suite is also run once before the governance documents are edited, and that run exits 0 after the test updates and before those document edits.
