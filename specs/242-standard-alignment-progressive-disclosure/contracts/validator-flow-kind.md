# Contract: Validator Flow Kind

## Classification

`framework/validate-skill.sh <skill-dir>/SKILL.md` judges each bundled file by kind:

| File | Kind | Exempt rule ids |
| --- | --- | --- |
| `assets/*.md` | template | unchanged |
| `references/<f>.md` named in the flows table (`fl_files`) | `flow` | P7.1, P7.2, P8.7 |
| any other `references/*.md` | reference | unchanged (`rc_reference_exempt_ids` plus `rc_bundled_exempt_ids`) |

`rc_flow_exempt_ids` in `framework/lib/rule-checks.sh` prints exactly `P7.1 P7.2 P8.7`.

## Output

A finding in a flow file uses the existing bundled-file format, so callers need no change.

The verdict is the worst over `SKILL.md` and its bundled files, as today.

## Seeded checks (D3.6)

`tests/validate-skill.test.sh` gains cases on a fixture skill with a flows table:
- A flow file containing a framework path (P2.6) fails.
- The same text in a non-flow reference passes, which proves the classification.
- A flow file with no `## Purpose` and no version passes (P7.1 and P7.2 are exempt).
