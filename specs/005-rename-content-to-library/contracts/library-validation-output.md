# Contract: Library Validation Output

Governs the output of `.highway/tools/validate-library.sh <library-file>`. Supersedes
`specs/004-shared-content-library/contracts/content-validation-output.md` for this renamed
script (that document remains an unedited historical record of feature 004's original
`validate-content.sh`, per FR-007). Extends the finding and coverage-summary format
`specs/003-constitution-enforcement/contracts/validation-output.md` already defines for
skills; this contract states only what differs for a library file.

## Finding line format (unchanged)

    ERROR: [<TAG>] <message> (<observable>)

`<TAG>` is either a constitution rule ID (e.g. `P1.1`) or one of the non-rule tags `SCHEMA`
(frontmatter/identity checks, unchanged — shared with skill validation) or `LIBRARY-TYPE`
(renamed from `CONTENT-TYPE`; a file not located under one of the three recognized library
directories). `(<observable>)` is included for rule-ID-tagged findings only, identical to the
skill validator.

## Coverage summary (extended)

Same five groups as the skill validator (`CHECKED:`, `FAILED:`, `N/A:`, `DEFERRED:`,
`UNCHECKED:`), each rule ID in exactly one group. For a `template`-type file, the `N/A:` group
additionally contains P1.1, P1.3, P7.4, P7.5, each annotated `=N2` (matching the annotation
style `validate-skill.sh` already uses for other N/A conditions, e.g. `P3.5=N2`). For
`governance` and `knowledge` files, those four rule IDs are only in `N/A:` if they self-gate
(e.g. no normative lines at all), same as any skill.

## Result line format (unchanged)

    OK: library '<library_type>/<name>' is valid (<n> rules checked, <m> deferred, <u> unchecked)
    FAILED: library '<library_type>/<name>' violates <k> rule(s)

`<library_type>/<name>` names the file by its library type and its frontmatter `name` field
(not its path), so the result line reads the same regardless of directory depth. The word
before the quoted name changes from `content` to `library` to match the renamed noun.

## Exit status (unchanged)

Exit 0 only if no `ERROR:` line was produced. Exit 1 otherwise. `N/A`, `DEFERRED`, and
`UNCHECKED` never affect exit status, identical to the skill validator's contract.
