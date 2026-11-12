# Contract: bundled files and self-containment

## `framework/validate-skill.sh <skill-dir>`

`SKILL.md` checks are unchanged. Bundled files are then checked:

| Path | Checks | Finding form |
| --- | --- | --- |
| `assets/<f>.md` (complete template) | `ls_validate_name`, `ls_validate_description`, then constitution rules minus the template-exempt and bundled-exempt ids | `ERROR: [<tag>] assets/<f>.md: <message>` |
| `references/<f>.md` | constitution rules minus the bundled-exempt ids and P7.2 | `ERROR: [<tag>] references/<f>.md: <message>` |

- A failed bundled file fails the skill. Its rule ids join the FAILED line.
- The cache key covers `SKILL.md`, `assets/`, and `references/`.
- `framework/validate-library.sh` does not exist.

## `framework/lib/dependency-check.sh`

`metadata.dependencies` entries `<path>@<version>` resolve against the folder holding the
`SKILL.md`. A missing target or a version mismatch is a finding, as today.

## `tests/self-contained-skills.test.sh`

The test fails when, for any `skills/<name>/`:

1. `SKILL.md` names a `references/`, `assets/`, or `scripts/` path that is not one level deep, or
   that does not exist.
2. A file in those folders is not named in `SKILL.md`.
3. `SKILL.md` or a bundled file names `../`, another skill's folder, `framework/`, `tests/`, or
   `harness/`.
4. A line names the `.highway` folder without naming a code product's records (`code/`, `product`,
   `metadata.md`, `features/`).
5. highway-setup lacks "Setup writes no file other than the seeded files.", or names an `assets/`
   file that is not seeded.

It also fails when the repository has a `.highway/` folder, or when a script, test, harness file,
manifest, or live document names one outside the code-product rule.

Each numbered check has a seeded probe that must fail.
