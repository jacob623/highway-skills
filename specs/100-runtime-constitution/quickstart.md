# Quickstart: Validate the Runtime Constitution Amendment

Run these from the repository root after the amendment. The identifier map is in
[contracts/skills-constitution-amendment.md](./contracts/skills-constitution-amendment.md). Field
rules are in [data-model.md](./data-model.md).

## Prerequisites

- The suite exits 0 before the first edit.
- The implementation files this change may edit are `.highway/governance/constitution.md` and `.highway/tools/tests/constitution-inventory.test.sh`.

## 1. Implementation files

```sh
git diff --name-only -- .highway/governance/constitution.md .highway/tools/tests/constitution-inventory.test.sh .highway/skills .specify/memory/constitution.md
```

Expect the constitution and `constitution-inventory.test.sh`. Expect no file under
`.highway/skills/` and no development constitution.

## 2. Version

Confirm the version footer is 4.0.0, the ratified date is unchanged, and the last-amended date
is the amendment date. Confirm a new sync impact report names every retired, redefined, and
added identifier from the contract, and that the older reports are still present.

## 3. Retired obligations are not current rules

For each retired identifier in the contract, confirm it does not appear as a current rule row.
The amendment report may name it as removed. Confirm the four development gates, the Compliance
Review Protocol, the Skill Authoring Workflow, and the merge decision are absent. Confirm N6 is
absent.

## 4. New and redefined obligations

Confirm each redefined and added identifier in the contract has one current row, one keyword,
and one obligation. Confirm P5.6 and P12.5 are still present. Confirm Principle XII's name
describes owner-controlled completion and orchestration, and that precedence rank 5 still
belongs to Principle XII.

## 5. Shipped tokens and ownership

Confirm `.highway/governance/constitution.md` contains neither `.specify/` nor `specs/`.
Confirm the document still forbids inventing organizational facts and still treats Objectives,
Controls, Non-Functional Requirements, architectures, decisions, implementations, and Profile
as user-owned.

## 6. Inventory test

```sh
.highway/tools/tests/constitution-inventory.test.sh
```

Expect exit 0. The test requires the amended rule rows, footer `4.0.0`, and last amended
`2026-09-29`. Other tests are unchanged and are not the acceptance signal for this change.
