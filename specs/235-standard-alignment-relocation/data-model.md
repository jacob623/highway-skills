# Data Model: Standard Alignment Relocation

## Location map

Each moved location, its old and new repository path, and where it sits in a user's project.

| Location | Before | After | In the distribution |
| --- | --- | --- | --- |
| Skills | `.highway/skills/<id>/` | `skills/<id>/` | `.highway/skills/<id>/` (unchanged) |
| Framework | `.highway/tools/` | `framework/` | not shipped |
| Tests | `.highway/tools/tests/` | `tests/` | not shipped |
| Highway Skills Constitution | `.highway/governance/constitution.md` | `framework/constitution.md` | not shipped |
| Authoring standard | `.highway/skills/_authoring-standard.md` | `framework/authoring-standard.md` | not shipped |
| Word list | `.highway/library/knowledge/frontmatter-lexicon.txt` | `framework/frontmatter-lexicon.txt` | not shipped |
| Authoring guide | `.highway/DISTRIBUTION.md` + `.highway/tools/README.md` | `framework/README.md` | `README.md` |
| Paths helper | `.highway/tools/lib/paths.sh` | `framework/lib/paths.sh` | not shipped |

Unchanged: `.highway/catalog/`, `.highway/governance/experience-standard.md`,
`.highway/governance/storage.md`, `.highway/instructions/`, `.highway/library/`, the agent trees,
`AGENTS.md`, and `harness/`.

## Manifest record

`classification<TAB>source<TAB>destination`. The longest matching source decides both the
classification and, when its destination is not `-`, the destination: the destination followed by
the rest of the path.

## Verification tree

A temporary folder holding the distribution's files, the repository's `framework/`, and the
distribution's skills at `skills/`. It exists only while packaging verifies, and it is removed
afterwards.

## Leftover entry

An adapter copy, adapter manifest row, or skill folder for a skill or agent that is not declared.
None may exist after a test run.
