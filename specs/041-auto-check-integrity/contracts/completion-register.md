# Contract: Completion Register

**Path**: `.specify/memory/completion-register.md`

**Consumers**: `completion-coverage.test.sh` (scope for `D7.2`, `D7.4`; corrective set for `D7.5`),
`constitution-inventory.test.sh` (the `Completed spec` definition it now names).

**Producers**: A maintainer, by hand. Nothing generates this file, and nothing may infer a row.

---

## Format

```markdown
# Completion Register

<prose paragraph stating what the file decides>

| Feature | Status | Corrects |
|---|---|---|
| 001-multi-agent-skill-suite | complete | - |
| 002-highway-folder-consolidation | complete | - |
| 003-constitution-enforcement | incomplete | - |
| 025-profile-path-migration | complete | 024-highway-profile |
| 041-auto-check-integrity | in-progress | - |
```

The header row must match `| Feature | Status | Corrects |` exactly, once. The parser reads only
lines beginning `| ` followed by three digits, so prose above and below the table is free.

## Field contract

| Field | Accepted values | Rejected |
|---|---|---|
| `Feature` | A basename matching `[0-9][0-9][0-9]-*` that exists under `specs/` | Anything else, including a path, a number alone, or a directory that does not exist |
| `Status` | `complete`, `incomplete`, `in-progress` | Any other token, including an empty cell. There is no default |
| `Corrects` | `-`, or a `Feature` value with a strictly lower number | A self-reference, a higher or equal number, or a name with no directory |

## Assertions the consuming check must make

| # | Assertion | Failure message shape |
|---|---|---|
| A1 | Every `specs/[0-9][0-9][0-9]-*` directory has exactly one row | `FAIL: feature directory is not in the completion register: <dir>` |
| A2 | Every row names an existing directory | `FAIL: completion register names a directory that does not exist: <name>` |
| A3 | Every `Status` is in the vocabulary | `FAIL: malformed status in completion register: <name> -> <value>` |
| A4 | No duplicate `Feature` value | `FAIL: duplicate completion register entry: <name>` |
| A5 | Every `Corrects` value resolves and is lower-numbered | `FAIL: completion register correction does not resolve: <name> -> <value>` |
| A6 | Every `complete` row's directory holds a conforming `coverage.md` | existing `MISSING_COVERAGE:` / `FAIL:` messages, unchanged |
| A7 | Every row with a `Corrects` value has corrective provenance in its own coverage record | existing `FAIL: corrective record ...` messages, unchanged |
| A8 | The parser matched at least one row | `FAIL: no rows parsed from the completion register; the reader matched nothing` |

**A8 is not decoration.** `constitution-inventory.test.sh` already carries the equivalent assertion
for its own reader — *"A parser that silently matches nothing would make every assertion in this block
pass regardless of the document's contents."* A register reader without A8 reproduces exactly the
defect this feature removes.

## Parsing constraints

- Bash 3.2.57. No associative array; rows are held as newline-delimited `name<TAB>status<TAB>corrects`
  and iterated with `while IFS=$'\t' read`.
- Under `set -u`, an empty result set must not be expanded as `"${arr[@]}"`.
- `$(...)` strips trailing newlines; the register is never round-tripped through it.
- No utility outside the Declared Toolchain. `awk`, `grep`, `sed`, `sort`, `uniq`, `cut` suffice.

## What this file is not

- **Not a status board.** It records whether a feature is complete, not how it is going.
- **Not generated.** `D4.1` does not apply; there is no generator to re-run.
- **Not shipped.** It lives under `.specify/`, a declared development artifact, so `D1.1` and `D1.2`
  are satisfied by placement rather than by care.
- **Not a substitute for `tasks.md`.** Task checkboxes remain the record of work within a feature.
  What changes is that they no longer decide which features a repository-wide rule reaches.
