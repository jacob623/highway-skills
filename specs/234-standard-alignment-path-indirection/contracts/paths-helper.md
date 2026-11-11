# Contract: Paths Helper

File: `.highway/tools/lib/paths.sh`. Sourced, never executed. Bash 3.2 and the Declared Toolchain
only. Ships with the framework tools.

## Sourcing

```bash
source "<folder>/paths.sh"
```

Sourcing sets every variable below for the root three folders above the helper. Sourcing twice is
harmless. The helper prints nothing and changes no shell option.

## Variables

| Variable | Location today |
|---|---|
| `HW_ROOT` | the repository root, or the distribution root |
| `HW_FRAMEWORK` | `.highway` |
| `HW_SKILLS` | `.highway/skills` |
| `HW_TOOLS` | `.highway/tools` |
| `HW_LIB` | `.highway/tools/lib` |
| `HW_TESTS` | `.highway/tools/tests` |
| `HW_FIXTURES` | `.highway/tools/tests/fixtures` |
| `HW_CATALOG` | `.highway/catalog` |
| `HW_INSTRUCTIONS` | `.highway/instructions` |
| `HW_LIBRARY` | `.highway/library` |
| `HW_GOVERNANCE` | `.highway/governance` |
| `HW_KNOWLEDGE` | `.highway/library/knowledge` |
| `HW_OUTPUT_TEMPLATES` | `.highway/library/templates/output` |
| `HW_HARNESS` | `harness` |
| `HW_AGENT_COPILOT` | `.github/skills` |
| `HW_AGENT_CLAUDE` | `.claude/skills` |
| `HW_AGENT_CURSOR` | `.cursor/skills` |
| `HW_AGENT_CODEX` | `.agents/skills` |
| `HW_CURSOR_RULES` | `.cursor/rules` |
| `HW_CLAUDE_MD` | `.claude/CLAUDE.md` |
| `HW_COPILOT_MD` | `.github/copilot-instructions.md` |
| `HW_AGENTS_MD` | `AGENTS.md` |

Every value is an absolute path with no trailing slash.

## Functions

| Function | Output | Failure |
|---|---|---|
| `hw_paths_init [root]` | Sets every variable for `root`, or for the helper's own root when omitted | none |
| `hw_template <name>` | The absolute path of the output template `<name>` (no `.md`) | Unknown name: message on stderr, exit 1 |
| `hw_doc <name>` | The absolute path of the governance or knowledge document `<name>` | Unknown name: message on stderr, exit 1 |
| `hw_at <root> <path>` | `<path>`, which must lie under `HW_ROOT`, re-rooted under `<root>` | Path outside `HW_ROOT`: message on stderr, exit 1 |
| `hw_rel <path>` | `<path>` relative to `HW_ROOT` | Path outside `HW_ROOT`: message on stderr, exit 1 |

`hw_template` names: every file in the output templates folder, by base name. `hw_doc` names:
`constitution`, `experience-standard`, `storage`, `highway-identity`, `assessment-findings`,
`frontmatter-lexicon`. Each name has its own `case` arm, so a later phase can move one file by
editing one arm.

## Guarantees

- No output on success except the requested path.
- No subprocess for a lookup: `hw_template`, `hw_doc`, `hw_at`, and `hw_rel` use `case` and
  parameter expansion only.
- The file contains neither of the strings the shipped-tree check forbids.
