# Contract: Codex Repository Guidance

Defines the `AGENTS.md` output of `.highway/tools/generate-instructions.sh`. The merged-body rules
already used for Claude Code and Copilot apply here unchanged.

## File

`AGENTS.md` at the repository root.

Its bytes are identical to `.claude/CLAUDE.md` and to `.github/copilot-instructions.md`:

- One instruction: the file equals that body.
- Several instructions: bodies in `LC_ALL=C` filename order, each body keeping its trailing
  newline, one extra newline between bodies, no added heading.
- No instructions: the file is one newline. No `.agents/skills/` file is removed.

## Manifest

`.highway/tools/.instruction-manifest` gains a row whose path is `AGENTS.md`. The id field equals
the id field of the `.claude/CLAUDE.md` and `.github/copilot-instructions.md` rows. The third
field is the sha256 of the file.

## Refusal

A present `AGENTS.md` with no instruction-manifest row, or whose hash differs from its row, is
named and left unchanged. The run writes nothing. The publisher does not delete the file.

## Boundaries

Instruction publishing does not read or write `.agents/skills/`, `.highway/skills/`, or any
`speckit-*` file. Skill publishing does not write `AGENTS.md`.

## Distribution

One `include` row for `AGENTS.md`. The file ships with the same verifications as the other merged
files. A body that contains `.specify/` or `specs/` still fails those verifications. There is no
separate flag to keep `AGENTS.md` out.
