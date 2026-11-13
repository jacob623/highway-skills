# Contract: Principle XIV rule checks

## Registry rows (`rc_registry` in `framework/lib/rule-checks.sh`)

```text
P14.1	rc_check_P14_1	N4
P14.2	rc_check_P14_2	N4
P14.3	rc_check_P14_3	N4
P14.4	rc_check_P14_4	N4
```

N4 is cited because each check is not applicable to a file that is not a `SKILL.md`.

## Function contract

`rc_check_P14_<n> <file>`, under the file's existing check contract:

| Input | Return | Output |
| --- | --- | --- |
| A file whose basename is not `SKILL.md` | 2 | nothing |
| A `SKILL.md` whose folder meets every boundary of the rule | 0 | nothing |
| A `SKILL.md` whose folder breaks a boundary of the rule | 1 | one line per breach |

- The skill folder is `dirname <file>`. Other skills are the folders beside it: `dirname` of the
  skill folder.
- The flows table is read only through `fl_table`, `fl_files`, and `fl_steps`.
- P14.2 returns 0 for a skill with no flow files.
- A check never exits the calling shell and writes nothing.

## Boundaries per rule

| Rule | Boundaries |
| --- | --- |
| P14.1 | 1 |
| P14.2 | 2, 3, 4 |
| P14.3 | 5, 6, 7, 8 |
| P14.4 | 9, 10, 11, 12 |

## Finding lines

Each names the file, relative to the skill folder, and the broken condition, ending with
`(boundary <n>)`. The texts are the retired test's messages with the `boundary <n>: ` prefix moved
to a suffix, for example:

```text
references/proposal.md has 532 lines, limit is 500 (boundary 1)
references/sub/record.md is not a Markdown file directly in references/ (boundary 2)
step write is a step in more than one place (boundary 5)
SKILL.md hands off to `nowhere`, which is not a step of this skill (boundary 10)
```

The validator prints each as `ERROR: [P14.<n>] <finding> (<Observable>)`.

## Seeded cases (`tests/rule-checks.test.sh`)

| Case | Source | Seed | FAILED line must list |
| --- | --- | --- | --- |
| 1 to 12 | copy of `tests/fixtures/flow-skill` | the retired test's seed `<n>`, unchanged | exactly the boundary's rule |
| P14.1 without references | base skill | `SKILL.md` padded past 500 lines | P14.1 |
| P14.2 without references | base skill | flows table naming `references/sub/flow.md` | P14.2 |
| P14.3 without references | base skill | a File and Steps table with no flows sentence | P14.3 |
| P14.4 without references | base skill | "go to `nowhere`" | P14.4 |
| unseeded | fixture copy and base skill | none | nothing; P14.1 to P14.4 in `CHECKED:` |
