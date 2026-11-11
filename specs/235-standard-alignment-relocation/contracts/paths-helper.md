# Contract: Paths Helper after the Relocation

Supersedes the Phase 5 layout in spec 234's contract; the functions are unchanged.

## Location

`framework/lib/paths.sh`. Sourced, never executed. The default root is two folders above the
helper. Shims: `tests/paths.sh` and `harness/bin/lib/paths.sh`, one `source` line each.

## Variables

| Variable | Value |
| --- | --- |
| `HW_ROOT` | repository root |
| `HW_SKILLS` | `$HW_ROOT/skills` |
| `HW_FRAMEWORK` | `$HW_ROOT/framework` |
| `HW_LIB` | `$HW_FRAMEWORK/lib` |
| `HW_TESTS` | `$HW_ROOT/tests` |
| `HW_FIXTURES` | `$HW_TESTS/fixtures` |
| `HW_HIGHWAY` | `$HW_ROOT/.highway` |
| `HW_CATALOG` | `$HW_HIGHWAY/catalog` |
| `HW_INSTRUCTIONS` | `$HW_HIGHWAY/instructions` |
| `HW_LIBRARY` | `$HW_HIGHWAY/library` |
| `HW_GOVERNANCE` | `$HW_HIGHWAY/governance` |
| `HW_KNOWLEDGE` | `$HW_LIBRARY/knowledge` |
| `HW_OUTPUT_TEMPLATES` | `$HW_LIBRARY/templates/output` |
| `HW_HARNESS` | `$HW_ROOT/harness` |
| `HW_AGENT_*`, `HW_CURSOR_RULES`, `HW_CLAUDE_MD`, `HW_COPILOT_MD`, `HW_AGENTS_MD` | unchanged |

`HW_TOOLS` no longer exists.

## `hw_doc` names

| Name | Path |
| --- | --- |
| `constitution` | `$HW_FRAMEWORK/constitution.md` |
| `authoring-standard` | `$HW_FRAMEWORK/authoring-standard.md` |
| `frontmatter-lexicon` | `$HW_FRAMEWORK/frontmatter-lexicon.txt` |
| `experience-standard`, `storage` | `$HW_GOVERNANCE/<name>.md` |
| `highway-identity`, `assessment-findings` | `$HW_KNOWLEDGE/<name>.md` |

`hw_template`, `hw_at`, `hw_rel`, and `hw_paths_init` are unchanged.

## Harness path map

`harness/bin/path-map.sh --location <skills|framework>` prints the repository-relative skills or
framework location.
