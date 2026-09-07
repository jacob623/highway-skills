# Contract: Content Validation Output

Governs the output of `.highway/tools/validate-content.sh <content-file>`. Extends the finding
and coverage-summary format `specs/003-constitution-enforcement/contracts/validation-output.md`
already defines for skills; this contract states only what differs for a content file.

## Finding line format (unchanged)

    ERROR: [<TAG>] <message> (<observable>)

`<TAG>` is either a constitution rule ID (e.g. `P1.1`) or one of the non-rule tags `SCHEMA`
(frontmatter/identity checks) or `CONTENT-TYPE` (a file not located under one of the three
recognized content directories). `(<observable>)` is included for rule-ID-tagged findings only,
identical to the skill validator.

## Coverage summary (extended)

Same five groups as the skill validator (`CHECKED:`, `FAILED:`, `N/A:`, `DEFERRED:`,
`UNCHECKED:`), each rule ID in exactly one group. For a `template`-type file, the `N/A:` group
additionally contains P1.1, P1.3, P7.4, P7.5, each annotated `=N2` (matching the annotation
style `validate-skill.sh` already uses for other N/A conditions, e.g. `P3.5=N2`). For
`governance` and `knowledge` files, those four rule IDs are only in `N/A:` if they self-gate
(e.g. no normative lines at all), same as any skill.

## Result line format (unchanged)

    OK: content '<content_type>/<name>' is valid (<n> rules checked, <m> deferred, <u> unchecked)
    FAILED: content '<content_type>/<name>' violates <k> rule(s)

`<content_type>/<name>` names the file by its content type and its frontmatter `name` field
(not its path), so the result line reads the same regardless of directory depth.

## Exit status (unchanged)

Exit 0 only if no `ERROR:` line was produced. Exit 1 otherwise. `N/A`, `DEFERRED`, and
`UNCHECKED` never affect exit status, identical to the skill validator's contract.
