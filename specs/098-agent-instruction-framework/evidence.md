# Evidence: Distribute Always-On Agent Instructions from One Source

## Baseline (D3.1)

`.highway/tools/tests/run-all.sh` on 2026-09-29, before any feature 098 edit.

- Exit status: 0
- Summary: 60 passed, 0 failed
- Elapsed: 252 seconds

A first attempt inside the sandbox was discarded. Regeneration writes outside the workspace, and stopping that run left the tree in motion. The result above is a later run with the tree clean and no other suite process running.

## Cited documents

Both files exist and were not edited:

- `.highway/library/knowledge/highway-identity.md`
- `.highway/governance/experience-standard.md`

Neither file has a diff against HEAD.

## Failing before the generator (D3.6)

Both tests were run before `.highway/tools/generate-instructions.sh` existed.

- `.highway/tools/tests/generate-instructions.test.sh` exited 1: `FAIL: .highway/tools/generate-instructions.sh is absent`
- `.highway/tools/tests/instruction-coverage.test.sh` exited 1: `FAIL: no instructions were found under .highway/instructions/`

## User Story 1

`.highway/tools/generate-instructions.sh` publishes `.highway/instructions/<id>.md`. The body is copied with `fm_body`. Cursor receives `description` (quoted), `alwaysApply: true`, and the body. `.claude/CLAUDE.md` and `.github/copilot-instructions.md` are the same bytes. Zero instructions write one newline and no `.mdc`. An invalid source exits 1 and writes nothing. A hand-edited merged file is named and left unchanged.

`.highway/tools/tests/generate-instructions.test.sh` exited 0. The temporary id was `test-instruction-<pid>`, which is not a `highway-*` rule, and the exit trap removed it.

## User Story 3

The leftover-rule loop in `.highway/tools/tests/generate-agent-adapters.test.sh` previously failed on every `.cursor/rules/highway-*.mdc` (D3.5). It now fails only when `.highway/tools/.instruction-manifest` has no row for that path. The adapter manifest still must not contain a `.cursor/rules/` row. A probe file `highway-leftover-<pid>.mdc` with no row is classified as a leftover and then removed.

`.highway/tools/tests/generate-agent-adapters.test.sh` exited 0 after `.cursor/rules/highway-agent-context.mdc` existed. Checksums of `.cursor/skills/speckit-tasks/SKILL.md`, `.github/skills/speckit-tasks/SKILL.md`, and `.highway/tools/.adapter-manifest` are unchanged by `generate-instructions.sh`. `generate-agent-adapters.sh` does not change `.claude/CLAUDE.md`, `.github/copilot-instructions.md`, or `.instruction-manifest`.

## User Story 2

`.highway/instructions/highway-agent-context.md` has `name: highway-agent-context`, the specified description, and the Highway Agent Context body with no blank line between the closing `---` and `# Highway Agent Context`.

After `generate-instructions.sh`:

- The heading is on line 5 of the source and of `.cursor/rules/highway-agent-context.mdc`, and on line 1 of both merged files.
- The source body, the Cursor body below its frontmatter, and both merged files compare equal.
- `alwaysApply: true` occurs once. `globs` occurs zero times.
- Both merged-file manifest ids are `highway-agent-context`.

A further run left checksums and `git status --short` for the four outputs unchanged.

## User Story 4

Include rows:

- `.claude/CLAUDE.md`
- `.github/copilot-instructions.md`
- `.cursor/rules/highway-agent-context.mdc`
- `.highway/instructions`

The source directory is included because `.highway/tools` already ships `generate-instructions.sh`. A recipient who ran that generator without the sources would rewrite the merged files as a single newline. There is no per-instruction exclude flag. The existing `exclude` rows for `.claude`, `.cursor`, and `.github` remain, so `speckit-*` skills stay out.

`.specify/memory/constitution.md` is 2.1.0, last amended 2026-09-29. The sync impact report lists the version line, the last-amended date, the declared-generator list, and the D4.7 enforcement-map cell. D4.5 and D4.6 are unchanged. `generate-instructions.sh` is a declared generator. `adapter-coverage.test.sh` runs it inside the temporary-tree regeneration and compares the instruction outputs with no timestamp exception, because this generator writes none.

`README.md`, `.highway/tools/README.md`, and `.highway/DISTRIBUTION.md` describe authoring `.highway/instructions/<id>.md` and publishing it with `generate-instructions.sh`. `.highway/DISTRIBUTION.md` does not contain `specs/` or `.specify/`.

Distribution into a temporary directory:

- Exit 0
- 107 paths included
- PASS: no distributed file references a development-only location
- PASS: 7 cross-references resolve within the distribution
- PASS: skill validator succeeded against 12 skills using only distribution contents
- `.claude/CLAUDE.md`, `.github/copilot-instructions.md`, and `.cursor/rules/highway-agent-context.mdc` match the repository
- `speckit-*` path count: 0

`instruction-coverage.test.sh` could not pass until those include rows existed, so the rows were added before that test was recorded as passing.

## Suite after the last edit (D3.2)

`.highway/tools/tests/run-all.sh` on 2026-09-29.

- Exit status: 0
- Summary: 62 passed, 0 failed
- Elapsed: 247 seconds

The two new tests are included in that count. This result is the check result. Requirement coverage is the next section.

## Quickstart steps 1 through 7

| Step | Result |
|---|---|
| 1. Publish | Exit 0. Heading in all four files. Merged files identical. `alwaysApply` 1, `globs` 0. Source body matches the Cursor body and both merged files. |
| 2. Second run | `git status --short` for the instruction source, `.cursor/rules`, both merged files, and `.instruction-manifest` was unchanged. |
| 3. Invalid source, in a copy | Mismatched `name`, an `alwaysApply` key, and an empty body each exited 1, named `highway-agent-context.md`, and left the three outputs and the manifest unchanged. |
| 4. Hand edit, in a copy | Exit 1, `.claude/CLAUDE.md` named, appended line still present. |
| 5. Skills and speckit | Speckit checksums unchanged. `.adapter-manifest` has no `.cursor/rules/` row. `generate-agent-adapters.sh` left the two merged files and `.instruction-manifest` unchanged. It rewrote its own manifest in a different row order with the same rows; that file was restored to the committed order. |
| 6. Tests | The suite above includes `generate-instructions.test.sh`, `instruction-coverage.test.sh`, `generate-agent-adapters.test.sh`, `adapter-coverage.test.sh`, `distribution-packaging.test.sh`, and `shipped-tree-independence.test.sh`, each PASS. |
| 7. Distribution | Recorded under User Story 4. |
| 8. Seen on load | Left for a person. |

## Completion report

The suite result above is not this coverage judgment.

| Requirement | Evidence |
|---|---|
| FR-001 | One file, `.highway/instructions/highway-agent-context.md`. The generator reads that directory and does not append to a shared source. |
| FR-002 | Frontmatter is `name` and `description` only. `name` equals the id. The description is one non-empty line. The body is non-empty. The source has no `alwaysApply`, `globs`, `paths`, or `applyTo`. |
| FR-003 | Source body, Cursor body, and both merged files compare equal for the one instruction. The two-instruction case in `generate-instructions.test.sh` joins `# First`, a blank line, and `# Second`. |
| FR-004 | `.cursor/rules/highway-agent-context.mdc` has the quoted description, `alwaysApply: true`, no `globs`, and the source body immediately below the frontmatter. |
| FR-005 | `.claude/CLAUDE.md` and `.github/copilot-instructions.md` are byte-identical to that body. |
| FR-006 | Quickstart step 3. Each invalid source exited 1 with the outputs unchanged. |
| FR-007 | `.highway/tools/.instruction-manifest` has path, id, and sha256. It is not `.adapter-manifest`. Quickstart step 4 refused the hand edit, named the file, and left the line in place. The generator has no delete path. |
| FR-008 | Quickstart step 2. The second run did not change status or checksums. |
| FR-009 | The source file matches the specified name, description, and body. |
| FR-010 | Quickstart step 5. Instruction generation left speckit files and the adapter manifest unchanged. Skill generation left the instruction outputs unchanged. |
| FR-011 | `generate-agent-adapters.test.sh` exited 0 while `highway-agent-context.mdc` was present and had an instruction-manifest row. A `highway-*.mdc` file with no row is still a failure. |
| FR-012 | `instruction-coverage.test.sh` exited 0. It requires the Cursor rule, both merged bodies, the manifest ids, and the include rows, and it fails an id with no source. |
| FR-013 | The distribution contains the three outputs, contains 0 `speckit-*` paths, and passed its three verifications. The Highway Agent Context body names neither `.specify/` nor `specs/`. There is no per-instruction exclude flag. |
| FR-014 | `README.md`, `.highway/tools/README.md`, and `.highway/DISTRIBUTION.md` were edited in this change and name `.highway/instructions/<id>.md` and `generate-instructions.sh`. |
| FR-015 | Constitution 2.0.0 → 2.1.0 (MINOR). `generate-instructions.sh` is on the declared-generator list, separate from `generate-agent-adapters.sh`. The sync impact report names the changed elements. |
| SC-001 | Met. The one body compares equal across the source, the Cursor rule, and both merged files. |
| SC-002 | Not met by this run. The files are in the always-on locations. A person still has to open the repository in Cursor, Claude Code, and Copilot and confirm the text is present without attaching it. Quickstart step 8. |
| SC-003 | Met for the mechanism. `generate-instructions.test.sh` adds one source file in a copy and one generator run produces the joined merged file and a second Cursor rule, with no hand edit of those outputs. |
| SC-004 | Met. Quickstart step 2. |
| SC-005 | Met. Quickstart step 5. |
| SC-006 | Met. Baseline 60 passed, 0 failed, exit 0. After the last edit, 62 passed, 0 failed, exit 0. |
| SC-007 | Met. The produced distribution contains the three outputs, 0 `speckit-*` paths, and passed all three verifications on that run. |
