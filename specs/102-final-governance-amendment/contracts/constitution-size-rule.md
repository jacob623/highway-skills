# Contract: Skills Constitution Size Rule

Source: `.highway/governance/constitution.md`

## Version

| Field | Value |
|---|---|
| From | 4.1.0 |
| To | 5.0.0 |
| Class | MAJOR |
| Ratified | 2026-09-06 |
| Last amended | 2026-09-29 |

The new sync report is prepended. It names P7.6 as redefined, states that redefining a governance rule is major, and records the self-application review of P1.1, P1.2, P1.3, P1.4, P6.4, P6.6, and P7.3. Older reports stay, including `4.0.0 → 4.1.0 (MINOR)`, `3.0.1 → 4.0.0 (MAJOR)`, `2.6.0 → 3.0.0 (MAJOR)`, and the Principle XI bump rationale. Precedence stays unchanged.

## P7.6

| Column | Text |
|---|---|
| ID | P7.6 |
| Rule | A skill exceeding P7.4 or P7.5 MUST be reduced until it satisfies those limits. |
| Observable | The resulting skill satisfies P7.4 and P7.5. |
| Tier | `[agent-checkable]` |

The rule has one keyword, one obligation, and 14 words. The observable does not require additional skills. No check is registered for P7.6, so the tier stays agent-checkable.

## Unchanged rows

| ID | Obligation that stays |
|---|---|
| P7.3 | A skill references, rather than restates, a requirement owned outside that skill. |
| P7.4 | A skill contains at most 12 MUST-level rules. |
| P7.5 | A normative section contains at most 400 words. |

Every other current constitution rule stays, including runtime-only governance, common failure handling, the absence of mandatory post-write persistence verification, simplified repository context, Experience Standard delegation, shared-template ownership, and owner-controlled readiness and orchestration.

## Authoring citation

`.highway/skills/_authoring-standard.md` replaces "split the skill rather than exceeding either" with a paraphrase that the skill is reduced until both limits hold, still citing **P7.4, P7.5, P7.6**. The file does not contain the P7.6 rule sentence.

## Inventory assertions

`constitution-inventory.test.sh` requires the footer `**Version**: 5.0.0`, ratified 2026-09-06, and last amended 2026-09-29. A comment records that the 4.1.0 footer assertion described the prior amendment. The test still requires the historical constitution reports named above. It requires the current P7.6 row to be the reduced-skill sentence and not the split sentence.
