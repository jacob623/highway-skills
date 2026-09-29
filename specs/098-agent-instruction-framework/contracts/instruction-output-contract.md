# Contract: Instruction Generator Output

Defines `.highway/tools/generate-instructions.sh` and the files it writes. Behavior shared with the skill generator is cited here rather than copied into that script's contract.

## Invocation

`.highway/tools/generate-instructions.sh`

No arguments. Exit 0 when every output is written or already current. Exit 1 when any source is invalid, any target is unsafe to overwrite, or the manifest is unreadable. A non-zero exit writes nothing.

## Outputs

| Output | Contents |
|---|---|
| `.cursor/rules/<id>.mdc` | `description` (quoted), `alwaysApply: true`, then the body. No `globs`. |
| `.claude/CLAUDE.md` | Bodies in filename order, one blank line between bodies, no added heading. |
| `.github/copilot-instructions.md` | The same bytes as `.claude/CLAUDE.md`. |

Filename order is `LC_ALL=C`. Zero instructions: each merged file is one newline, and no `.mdc` is written. The generator never deletes a file.

## Manifest

`.highway/tools/.instruction-manifest`, columns `path`, `id`, `sha256`, as in [../data-model.md](../data-model.md).

A target that exists with no row, or whose hash differs from its row, is named in the error and left unchanged. The skill adapter manifest is not read or written.

## Boundaries

The generator reads `.highway/instructions/` and its own manifest. It does not read or write `.highway/skills/`, `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, or any `speckit-*` file.

`generate-agent-adapters.sh` does not read or write `.highway/instructions/`, `.instruction-manifest`, `.claude/CLAUDE.md`, `.github/copilot-instructions.md`, or an `.mdc` file that has an instruction-manifest row.

## Distribution

Each output path has an `include` row in `.highway/tools/.distribution-manifest`. There is no flag on the source to exclude one instruction. A body that contains `.specify/` or `specs/` fails distribution verification.

## Correspondence

For every source id:

- `.cursor/rules/<id>.mdc` exists and its body equals the source body.
- Both merged files contain that body.
- The manifest has a Cursor row for that id, and the merged rows' id field lists every source id in filename order.
- The distribution classifies the `.mdc` and both merged paths as `include`.

A manifest row or a distribution include whose id has no source is a failure. A `.cursor/rules/highway-*.mdc` file with no instruction-manifest row remains a skill-suite failure.

## Determinism

Two runs on unchanged inputs produce identical files and an identical manifest, with no timestamp exception. This generator does not stamp a generation time.
