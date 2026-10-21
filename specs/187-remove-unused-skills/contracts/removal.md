# Contract: Skill removal

## Skills removed

| Skill | Source | Owned templates |
|---|---|---|
| `highway-clarify` | `.highway/skills/highway-clarify/` | `clarification-record.md`, `clarification-catalog.md` |
| `highway-inquiry` | `.highway/skills/highway-inquiry/` | `requirements-inquiry.md` |
| `highway-relationships` | `.highway/skills/highway-relationships/` | none |
| `highway-new` | `.highway/skills/highway-new/` | none |

Published copies are the same skill name under `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/`.

## Templates kept

| Template | Still cited by |
|---|---|
| `.highway/library/templates/output/request-record.md` | `highway-request` |
| `.highway/library/templates/output/request-catalog.md` | `highway-request` |

## Checks

| Check | Action |
|---|---|
| `.highway/tools/tests/highway-clarify.test.sh` | Delete. It only covers `highway-clarify`. |
| `.highway/tools/tests/highway-new.test.sh` | Delete. It only covers `highway-new`. |
| `.highway/tools/tests/relationship-integrity.test.sh` | Delete. It only covers `highway-relationships`. |
| `.highway/tools/tests/output-template.test.sh` | Edit. Stop requiring the clarification templates and `highway-clarify`. Keep the request-template checks on `highway-request`. |
| `.highway/tools/tests/highway-ux-alignment.test.sh` | Edit. Stop requiring `highway-new` and `highway-clarify`. |

Each deletion is recorded in `specs/187-remove-unused-skills/retirements.md` with the skill it served.
