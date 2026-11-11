# Research: Standard Alignment Relocation

## R1. How files move

**Decision**: Move with plain `mv`, not `git mv`. Every moved file keeps its bytes, so git
records each as a rename when the change is committed. Nothing is staged or committed by this
work.

**Alternatives considered**: `git mv`. Rejected: it stages every move, and this work leaves the
index untouched until the maintainer asks for a commit.

## R2. Paths helper names

**Decision**: The helper moves to `framework/lib/paths.sh` and resolves the root two folders up.
Its variables are renamed so each name says what the folder now is:

| Variable | Before | After |
| --- | --- | --- |
| `HW_HIGHWAY` | (new name for the old `HW_FRAMEWORK`) | `.highway` |
| `HW_FRAMEWORK` | `.highway` | `framework` |
| `HW_TOOLS` | `.highway/tools` | removed; every use becomes `HW_FRAMEWORK` |
| `HW_LIB` | `.highway/tools/lib` | `framework/lib` |
| `HW_TESTS` | `.highway/tools/tests` | `tests` |
| `HW_FIXTURES` | `.highway/tools/tests/fixtures` | `tests/fixtures` |
| `HW_SKILLS` | `.highway/skills` | `skills` |

`HW_CATALOG`, `HW_INSTRUCTIONS`, `HW_LIBRARY`, `HW_GOVERNANCE`, `HW_KNOWLEDGE`, and
`HW_OUTPUT_TEMPLATES` stay under `HW_HIGHWAY`. `hw_doc` gains `authoring-standard`, and
`constitution` and `frontmatter-lexicon` point into `framework/`. The rename is mechanical: first
`HW_FRAMEWORK` becomes `HW_HIGHWAY`, then `HW_TOOLS` becomes `HW_FRAMEWORK`, across `framework/`,
`tests/`, `harness/bin/`, and the documents that name them.

**Alternatives considered**: keep `HW_TOOLS` as an alias for `framework/`. Rejected: two names for
one location is what Phase 5 removed. Keep `HW_FRAMEWORK` meaning `.highway`. Rejected: the word
"framework" now names `framework/`.

## R3. Shims

**Decision**: `tests/paths.sh` sources `../framework/lib/paths.sh`, and `harness/bin/lib/paths.sh`
sources `../../../framework/lib/paths.sh`. Each stays one line plus comments.

## R4. Distribution manifest and directory destinations

**Decision**: `dist_destination` maps by longest matching record, like classification: a record
whose source is the path or one of its folders, and whose destination is not `-`, places the path
at the destination plus the rest of the path. The manifest becomes:

- `include skills .highway/skills`, so a user's project keeps `.highway/skills/<id>/`;
- `exclude framework`, with `include framework/README.md README.md`;
- `exclude tests`;
- the `.highway` rows lose `.highway/skills`, `.highway/tools`, and the tools carve-outs, and the
  `.highway/DISTRIBUTION.md` row goes.

The distribution record stays at `.highway/tools/.distribution-record` inside the distribution, so
the drift guard and its tests keep working; it is a packaging record, not framework.

**Alternatives considered**: list each skill folder with its own destination. Rejected: one record
per skill would have to change with every new skill.

## R5. Packaging verification without a shipped validator

**Decision**: `verify_self_validation` builds a verification tree in a temporary folder: the
distribution's files, the repository's `framework/` copied in, and the distribution's skills
moved back from their destination to `skills/`. It runs that tree's `framework/validate-skill.sh`
on every skill, with no constitution override. The tree has no `specs/`, `.specify/`, or
`tests/`, so a pass proves D1.2: the skills validate with the development folders absent, and
every file a skill names comes from the distribution.

**Alternatives considered**: run the repository's validator in place against the distribution's
skill folders. Rejected: dependency paths and skill ids would resolve against the repository, not
the distribution, which proves nothing about what ships.

## R6. highway-help's index

**Decision**: `generate-catalog.sh` keeps writing `source_path` as `skills/<id>/SKILL.md`. It is
relative to `.highway/` in a user's project, where the distribution still places skills, and
regeneration leaves `index.json` byte-identical.

## R7. `framework/README.md`

**Decision**: `framework/README.md` is `DISTRIBUTION.md` rewritten as the authoring guide, with
the tools README merged in. It drops the per-agent adapter, always-on instruction, earlier Cursor
rule, and "skills in this distribution are registered" sections, and names `skills/`,
`framework/`, and `tests/`. Because it also ships as the distribution's `README.md` until Phase
14, it has no Markdown link to a file the distribution lacks; framework files are named in code
spans. It names no development-only location.

## R8. Constitution amendments

**Decision**:

- Development constitution 3.1.0 to 3.2.0 (MINOR): D2.5, D3.1 to D3.3, D4.5, D4.6, the
  Definitions (shipped artifact no longer lists the framework; generated artifact names
  `framework/`), the Enforcement Map (D1.2 note: the verification tree; D2.5 note: `framework/`,
  `tests/`, `harness/bin/`), the Harness Toolchain note, and the Toolchain, Correspondence, and
  Skill Content gates.
- Highway Skills Constitution 10.0.0 to 10.1.0 (MINOR), now at `framework/constitution.md`: P2.6's
  Observable names `framework/`; the body's path references follow the moves. `rc_check_P2_6`
  flags `framework/` in place of `.highway/tools/`. Historical Sync Impact Reports keep their
  paths.
- D3.4: before the P2.6 check changes, every skill fixture and every skill is checked for the
  text `framework/`. None contains it (recorded in the plan), so no verdict changes.

## R9. Harness

**Decision**: the harness shim follows the helper; `path-map.sh` replaces `REL_TOOLS` with
`REL_FRAMEWORK`, adds `REL_TESTS` (selects nothing, "the bash suite covers it"), and renames
`--location tools` to `--location framework`, which `project.ts` uses. The selection list drops
the constitution and word-list rows, which no longer ship. Harness tests and the README use the
new paths.

## R10. Path-construction check

**Decision**: the check scans `framework/`, `tests/`, and `harness/bin/`. Rule 2 also flags a
variable joined to `/skills/`, `/framework/`, or `/tests/`, and the variable names in its rules
follow R2. The helper is exempt from every rule and the two shims from the climb rule, as before.

## R11. Literal paths in tests and fixtures

**Decision**: a literal that names a location in this repository changes to the new layout, for
example a path given to the distribution classifier or the harness path map. A literal that
describes a user's project, such as highway-help's `.highway/skills/<id>/SKILL.md`, stays.

## R12. Committed test leftovers

**Decision**: delete `.claude/skills/test-catalog-fixture-20649/` and
`.github/skills/test-catalog-fixture-20649/`, and the 15 `.mock-agent-4` rows in
`framework/.adapter-manifest`. `new-agent-extensibility.test.sh` removes every `.mock-agent-4`
row in its exit trap, not only rows naming its temporary skill. `generate-catalog.test.sh` and
`generate-agent-adapters.test.sh` remove any adapter copy and manifest row for their temporary
skill in their exit traps.

## R13. Order of work

**Decision**: the baseline is the 82/82 suite run on the unchanged tree. Then: leftovers; the
helper rename and move, with the shims; the file moves; the converted references and literals;
the distribution manifest and verification; the harness; the README merge and documents; the two
constitution amendments; regeneration and the full suite.
