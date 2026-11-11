# Data Model: Standard Alignment Path Indirection

## Location

A named place the framework or the suite reads or writes.

| Field | Meaning |
|---|---|
| Name | The helper variable (`HW_SKILLS`) or the lookup name (`hw_template adr-record`) |
| Kind | Folder or file |
| Declared at | One line or one `case` arm in `.highway/tools/lib/paths.sh` |
| Value | Absolute path under `HW_ROOT` |

Folders: root, framework, skills, tools, shared helpers, tests, fixtures, catalog, instructions,
library, governance, knowledge, output templates, harness, four agent copy trees, Cursor rules.
Files: three instruction outputs; each output template; each governance and knowledge document.
The full list is in [contracts/paths-helper.md](contracts/paths-helper.md).

Rule: a location is declared once. A caller never combines a root with a declared folder or file
name.

## Bootstrap shim

A one-line file that sources the helper from a folder that cannot reach it without climbing.

| Shim | Used by |
|---|---|
| `.highway/tools/tests/paths.sh` | every `*.test.sh`, `run-all.sh`, fixture scripts |
| `harness/bin/lib/paths.sh` | the four `harness/bin/` scripts |

Rule: the shims are the only files besides the helper allowed to climb from their own folder.

## Path construction rule

| Field | Meaning |
|---|---|
| Number | 1 to 4 (see [research.md](research.md) R8) |
| Pattern | An extended regular expression matched per line |
| Exempt files | The helper for all rules; the two shims for rule 3 |
| Report | `file:line: rule N: text` |

Lines whose first non-blank character is `#` are not matched.

## Dropped assertion

| Field | Meaning |
|---|---|
| Test | The test the assertion left |
| Assertion | The check, quoted or summarized |
| Disposition | Kept (with the test that holds it), consolidated (with the one test that keeps it), or superseded |
| Behavior | What it covered, for superseded entries |

Stored in `dropped-assertions.md` in this folder.

## Constitution rule D2.5

| Field | Value |
|---|---|
| Rule | A script MUST get repository locations from the paths helper |
| Observable | `path-construction.test.sh` reports no violation |
| Tier | `[auto]` |
| Enforced by | `path-construction.test.sh` |
| Gate | Toolchain |
