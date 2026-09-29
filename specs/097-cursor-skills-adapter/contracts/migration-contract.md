# Contract: One-Time Rule Migration

Defines the temporary script `specs/097-cursor-skills-adapter/migrate-cursor-rules.sh`. The script
is removed when the migration completes (FR-017), so this contract is the durable record of what it
did and how it was verified.

## Invocation

Run once from any directory: `bash specs/097-cursor-skills-adapter/migrate-cursor-rules.sh`. The
repository root is resolved from the script's own location. The script takes no arguments and
prompts for nothing.

## Inputs

| Input | Use |
|---|---|
| `.highway/tools/.adapter-manifest` | The authority for which `.cursor/rules/` files are tracked Highway adapters, and for each one's recorded sha256 |
| The named orphan `.cursor/rules/test-catalog-fixture-20649.mdc` | The single untracked file also in scope, checked against the fixed sha256 `60826b120becb64a3a2b971b30b3230250da19719cc14dd2750fce5f03527392` |

## Behavior

For each manifest row whose path begins `.cursor/rules/`, and for the named orphan:

| File state | Action | Report line |
|---|---|---|
| Exists, hash equals recorded | Delete the file; delete the row | `REMOVED <path>` |
| Exists, hash differs | Leave file and row | `EDITED <path> -- resolve, then re-run` |
| Missing (tracked) | Delete the row | `ROW-DROPPED <path> (file already absent)` |
| Missing (orphan) | Nothing | `ABSENT <path>` |

Additionally:

- No other file under `.cursor/rules/` is opened, hashed, moved or deleted. Hand-written rules are
  never named in the report.
- Every manifest row not beginning `.cursor/rules/` is preserved byte-for-byte, including the
  `.mock-agent-4` rows.
- The manifest is rewritten through a temporary file and `mv`. If no row changes, the manifest is
  not rewritten.
- The script never adds a `.cursor/skills/` row; the generator does that.
- Nothing is removed until every state has been read, so a read failure changes nothing.

## Outcome and exit status

| Condition | Exit | Final line |
|---|---|---|
| Every in-scope file removed or already absent | 0 | `MIGRATION COMPLETE: <n> removed, <m> rows dropped` |
| At least one `EDITED` file remains | 1 | `MIGRATION INCOMPLETE: <k> edited file(s) need a decision` |
| Manifest missing or unreadable | 1 | `ERROR: .highway/tools/.adapter-manifest not found` (nothing changed) |

The unedited files are still removed when the status is 1 (clarification Q2 = B). A re-run after
the maintainer resolves an edited file completes and exits 0. A re-run when nothing is left exits 0
and changes nothing.

## Constraints

- Bash 3.2.57; declared toolchain only (D2.1, D2.2); no `git`.
- Idempotent: running it any number of times after completion changes nothing.
- Lives outside the distributed path set; it must be absent from the tree once complete, and the
  distribution must contain no `migrate-cursor-rules.sh`.

## Verification

Because the script does not persist, its behavior is proved against a temporary copy of the tree,
and the result is recorded in the completion notes. See the migration scenarios in
[../quickstart.md](../quickstart.md). The durable regression guard is the permanent generator test
asserting no `.cursor/rules/<id>.mdc` exists or is produced for a source skill.

## Completion note

The migration ran once with exit 0 (13 files removed, 12 manifest rows dropped, no edited file
found), and the script was removed on completion (task T030). The seeded scenarios and the real run
are recorded in [../evidence.md](../evidence.md). The script is not in the tree, so this contract now
serves as the record of what it did.
