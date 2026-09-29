# Research: Distribute Always-On Agent Instructions from One Source

No `NEEDS CLARIFICATION` markers remained after `/speckit-clarify`. The decisions below settle the
output bytes and the records the spec left to planning.

## Decision 1: A separate generator, not a fourth skill-adapter row

- **Decision**: Add `.highway/tools/generate-instructions.sh`. Leave `generate-agent-adapters.sh` as three `identity-copy` rows.
- **Rationale**: Skill adapters are byte-identical `SKILL.md` files. Instruction outputs are not: Cursor is one file per instruction, and Claude Code and Copilot are concatenations. Putting both jobs in one script would make the skill extension test, which rewrites the three single-line `AGENT_*` arrays, responsible for a different output shape.
- **Alternatives considered**: One generator with a second source directory was rejected for that reason. Hand-maintained agent files were rejected because they drift.

## Decision 2: Body bytes, join rule, and the empty file

- **Decision**: The body is `fm_body` of the source: every line after the closing `---`. The checked-in Highway Agent Context file has no blank line between `---` and `# Highway Agent Context`, so the body starts at that heading and matches the spec block.
- **Join**: Each body keeps its own trailing newline. Between two bodies the generator inserts one extra newline, which is one blank line. A single instruction's merged file equals that body, including its trailing newline. The generator adds no heading.
- **Empty set**: Both merged files are exactly one newline, and no Cursor rule is written. The generator still does not delete a Cursor rule left from an earlier run.
- **Rationale**: `fm_body` already exists and preserves line bytes. Stripping trailing newlines would make "unchanged" depend on a rewrite. One newline is a real file with no instruction text, which is what the spec requires for the empty case.
- **Alternatives considered**: A generated title above each body was rejected because the canonical body already carries its heading. Omitting the merged files when the set is empty was rejected because the spec requires those files to exist.

## Decision 3: Cursor wrapper

- **Decision**: `.cursor/rules/<id>.mdc` is:

```yaml
---
description: "<source description>"
alwaysApply: true
---
```

followed immediately by the body. No `globs`, no `name`, no blank line inserted between the closing `---` and the body.

- **Rationale**: `alwaysApply: true` is what makes Cursor load the file with the repository. The description is copied from the source so the file is identifiable. Quoting the description keeps the comma in the Highway Agent Context description a single YAML value.
- **Constraint**: A description containing a double quote or a newline is invalid. The first instruction's description has neither.
- **Alternatives considered**: Copying the whole source frontmatter into the rule was rejected because `name` is not a Cursor rule field and the spec forbids `alwaysApply` in the source.

## Decision 4: Manifest columns

- **Decision**: `.highway/tools/.instruction-manifest` has three tab-separated fields: path, id, sha256. No version column.
- **Cursor row**: id is the instruction id.
- **Merged-file row**: id is the instruction ids in filename order, joined by commas. With one instruction the id is `highway-agent-context`. With none it is `-`.
- **Rationale**: The spec asks for path, id, and hash. Instructions have no version. The joined id makes a merged file declare which sources it contains, so a missing instruction fails correspondence even when the hash was not regenerated.
- **Alternatives considered**: Reusing `.adapter-manifest` was rejected because skill correspondence treats every row as a skill adapter. A four-column copy of the skill manifest would invent a version the source does not have.

## Decision 5: What ships

- **Decision**: Add three include rows to `.distribution-manifest`, under the existing `exclude` rows for `.claude`, `.cursor`, and `.github`:

```text
include	.claude/CLAUDE.md	-
include	.cursor/rules/highway-agent-context.mdc	-
include	.github/copilot-instructions.md	-
```

A later instruction adds one include row for its `.mdc` file. The two merged paths stay single rows. There is no ship flag on the source. A body containing `.specify/` or `specs/` fails distribution verification, which is the existing check.

- **Alternatives considered**: Per-instruction exclude was rejected in clarification. Including all of `.cursor/rules/` was rejected because hand-written rules would then ship.

## Decision 6: The skill leftover-rule guard

- **Decision**: In `generate-agent-adapters.test.sh`, a `.cursor/rules/highway-*.mdc` file is a failure only when `.instruction-manifest` has no row for that path. The assertion that `.adapter-manifest` contains no `.cursor/rules/` row stays.
- **Rationale**: `highway-agent-context.mdc` matches the current glob. The instruction manifest is the record that the file is an instruction output. A skill rule named `highway-*.mdc` still has no instruction row, so it still fails. Record the superseded behavior: the glob used to fail on every such file because no instruction outputs existed.
- **Alternatives considered**: Renaming the first instruction so it does not start with `highway-` was rejected because the spec fixes the id. Deleting the glob and trusting only the adapter manifest was rejected because a leftover `highway-*.mdc` with no adapter row would then pass.

## Decision 7: Constitution amendment

- **Decision**: `.specify/memory/constitution.md` goes from 2.0.0 to 2.1.0 (MINOR). The declared-generator list gains `generate-instructions.sh`. The D4.7 enforcement-map cell names that generator alongside the regeneration `adapter-coverage.test.sh` already performs. D4.5 and D4.6 are not edited. The sync impact report lists the version line, the last-amended date, the declared-generator list, and that one map cell.
- **Rationale**: D4.7's observable is "every declared generator". Adding a name without running it in the mapped test would make the map false. D4.5 and D4.6 speak only about skills; instruction correspondence is a new test, not a redefinition of those rules. MINOR matches the constitution's own precedent for widening a check in the same change that makes the tree pass.
- **Alternatives considered**: A new D-rule for instructions was rejected. It would be a second constitution change for a check the spec already requires as a test.

## Decision 8: Identity rule for ids

- **Decision**: `<id>` matches `^[a-z0-9]+(-[a-z0-9]+)*$` and equals `name`. Frontmatter keys are only `name` and `description`. `description` is one non-empty line and contains no `"`.
- **Rationale**: This is the same shape as skill ids, so filenames stay portable. Restricting the keys stops agent-specific fields from creeping into the source.
- **Alternatives considered**: Accepting any filename was rejected because a space or a quote would break the generated paths.
