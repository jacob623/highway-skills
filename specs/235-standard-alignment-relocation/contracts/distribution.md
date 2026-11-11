# Contract: Distribution after the Relocation

## Contents

The distribution holds:

- the highway-* agent copies, `AGENTS.md`, `.claude/CLAUDE.md`, `.github/copilot-instructions.md`,
  and `.cursor/rules/highway-agent-context.mdc`, unchanged;
- `.highway/skills/<id>/`, from `skills/<id>/`;
- `.highway/library/` (the listed templates and knowledge files), `.highway/catalog/`,
  `.highway/governance/` (the Experience Standard and the storage rules), and
  `.highway/instructions/`, unchanged;
- `README.md`, from `framework/README.md`;
- `.highway/tools/.distribution-record`, the packaging record.

It holds no other file from `framework/` and none from `tests/`.

## Verification

Unchanged in output and exit codes, except the third check's wording:

1. No distributed file contains `.specify/` or `specs/`.
2. Every Markdown link in a distributed file resolves inside the distribution.
3. Every distributed skill passes `framework/validate-skill.sh` run from a verification tree: the
   distribution, plus the repository's `framework/`, with the skills moved back to `skills/`. The
   PASS line reads `skill validator succeeded against <n> skills using only distribution contents
   and the framework`.

Any failure removes the target and exits 1.
