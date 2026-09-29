# Quickstart: Validate the Final Governance Amendment

Run these from the repository root. The target rows are in [contracts/constitution-size-rule.md](./contracts/constitution-size-rule.md) and [contracts/experience-standard-amendment.md](./contracts/experience-standard-amendment.md). Field rules are in [data-model.md](./data-model.md).

## Prerequisites

- The governance edits are `.highway/governance/constitution.md` and `.highway/governance/experience-standard.md`.
- The citation edit is `.highway/skills/_authoring-standard.md`.
- The test edits are `constitution-inventory.test.sh`, `experience-standard-amendment.test.sh`, and `highway-ux-alignment.test.sh`.
- Skill domain workflows, shared templates, generators, and the development constitution stay unchanged.
- Run `.highway/tools/tests/run-all.sh` with unrestricted filesystem access. Regeneration probes write temporary directories.

## 1. Suite before the edit

Run the suite before the first edit of this feature. Expect exit 0.

## 2. Tests fail on the current text

Update the three tests to the contracts. Run each updated test before editing the governance documents. Expect a non-zero exit that names the missing new sentence or the history token the test no longer treats as current. Record that failure.

## 3. Implementation files

```sh
git diff --name-only -- .highway/governance/constitution.md .highway/governance/experience-standard.md .highway/skills .highway/library .highway/tools .specify/memory/constitution.md
```

Expect the two governance files, `_authoring-standard.md`, and the three tests. Expect no `SKILL.md` diff, no shared-template diff, no generator diff, and no development-constitution diff.

## 4. Versions and history

Confirm the constitution footer is 5.0.0, ratified 2026-09-06, last amended 2026-09-29, and that the older constitution reports remain. Confirm the Experience Standard footer is 4.0.0, ratified 2026-09-08, last amended 2026-09-29, and that the file contains one sync impact report.

## 5. Current obligations

Confirm the current P7.6 row requires reduction until P7.4 and P7.5 hold, and does not require additional skills. Confirm P7.3, P7.4, and P7.5 are unchanged. Confirm X2.9 requires `**Why it matters:**`. Confirm X2.25 names the shared recommendation model and does not require a numbered list. Confirm the authoring citation cites P7.6 and does not contain the P7.6 rule sentence.

## 6. Shipped tokens

Confirm neither governance file contains `.specify/` or `specs/`. Confirm the Experience Standard report does not name a test file, a feature number, or the development constitution.

## 7. Suite after the edit

Run the suite again. Expect exit 0.
