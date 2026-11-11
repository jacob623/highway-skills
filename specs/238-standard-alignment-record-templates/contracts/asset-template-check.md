# Contract: The Skill Validator's Asset Template Check

## Which files

For `framework/validate-skill.sh [--no-cache] <skill-dir>`: every regular file `<skill-dir>/assets/*.md`
that contains a line matching `^## (File Frontmatter|Body|Catalog Structure)[[:space:]]*$`. Files in
`assets/` without such a line, such as highway-setup's skeletons, are not checked. A skill with no
`assets/` folder is unaffected.

## What is checked

Each selected file is checked by `framework/validate-library.sh --asset <file>`, which applies the same
checks as to a file under `library/templates/`:

- `name` present; `description` present and at most 500 characters;
- every auto-tier rule of the Highway Skills Constitution that has a registered check, except the
  template exemptions (P1.1, P1.3, P7.4, P7.5) and the library exemptions (P8.7, P6.4, P2.6).

`--asset` skips the containment check and the library-type check and treats the file as a template.
Without `--asset`, `validate-library.sh` behaves as before.

## How results appear

- Each finding is written to stderr as `ERROR: [<tag>] assets/<file>: <finding>`, where `<tag>` is the
  library validator's tag (`SCHEMA` or a rule id).
- A finding makes the skill fail: exit 1 and the `FAILED: skill '<id>' violates <n> rule(s)` line, with
  `<n>` counting asset findings too.
- A failing rule id joins the FAILED line. CHECKED, N/A, DEFERRED, and UNCHECKED are computed from
  `SKILL.md` alone, so a passing skill's report is byte-identical to before.

## Cache

`vc_key` covers `SKILL.md` and every file under `<skill-dir>/assets/`, so editing a template forces a full
validation. The environment hash covers `validate-library.sh`.

## Seeded failures

- A copy of highway-request with `description:` removed from `assets/request-record.md` fails, and stderr
  names `assets/request-record.md`.
- Two copies of a skill that differ in one `assets/` file have different `vc_key` values.
