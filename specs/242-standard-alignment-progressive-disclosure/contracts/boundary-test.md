# Contract: `tests/skill-flow-pattern.test.sh`

## Invocation

```text
bash tests/skill-flow-pattern.test.sh                              # every skill under skills/
bash tests/skill-flow-pattern.test.sh --probe source-document      # seeded breaches must fail
bash tests/skill-flow-pattern.test.sh --probe source-document --neutralise   # same path, unseeded, must pass
```

## Output

- One line per breach: `skill-flow-pattern: <skill>: boundary <n>: <detail>`.
- Last line: `PASS: skill-flow-pattern` or `FAIL: skill-flow-pattern (<k> breaches)`.
- Exit 0 on pass, 1 on any breach, 2 on a usage error.

## Checks (Phase 13 boundaries)

| # | Check | Applies to |
| --- | --- | --- |
| 1 | `wc -l` ≤ 500 and `wc -c` ≤ 20,000 | `SKILL.md` and each flow file |
| 2 | each File cell is `references/<name>.md` with no further `/` | flows table |
| 3 | at most 6 rows, and each flow file has ≥ 25 lines | flows table, flow files |
| 4 | no frontmatter; line 1 `# `; exactly one L1; the only L2 is a final `## Verification` with ≥ 1 bullet | flow files |
| 5 | every step name is a step in exactly one file | `SKILL.md` and flow files |
| 6 | `Entry` and `Classify` are not steps in any flow file | flow files |
| 7 | the sentence immediately precedes the table; header `File`, `Steps`; each Steps cell equals that file's steps in order | `SKILL.md` with flow files |
| 8 | with a table: no line outside it names `references/`; every file in `references/` has a row; every row's file exists. Without one: each file in `references/` is named by a line beginning ``Read `references/<file>` `` | `SKILL.md` |
| 9 | a flow file has no `references/` | flow files |
| 10 | each step reference not followed by `` in `highway- `` names a step of the skill | `SKILL.md` and flow files |
| 11 | each step reference followed by `` in `highway-<name>` `` names a step of that skill | `SKILL.md` and flow files |
| 12 | each step reference outside a reply line (a list item starting with a backticked class and `:`), other than "stay on", names a step of that file or of `SKILL.md` | flow files |

Fenced blocks are skipped for steps, step references, and headings (boundaries 4, 5, 10, 11, 12).

## Probe

`--probe source-document`:
1. Copy a passing split skill (one with at least two flow files) into a temporary folder.
2. For each boundary, apply one seeded breach to a fresh copy and run the checks against it.
3. Require exactly that boundary to be reported.

`--neutralise` runs the same copies unseeded and requires a clean pass. Seeds, by boundary:
1. Pad a flow file past 500 lines.
2. Point a row at `references/sub/x.md`.
3. Add a seventh row and file, or cut a file to 10 lines.
4. Add frontmatter, or an L2 `## Notes`.
5. Repeat a step heading in `SKILL.md`.
6. Move `Classify` into a flow file.
7. Reorder one Steps cell.
8. Name `references/record.md` in a router step.
9. Name `references/proposal.md` in a flow file.
10. "go to `nowhere`".
11. "follow `nowhere` in `highway-adr`".
12. In `record.md`, "Go to `revise`." in a numbered item.

## Library

The test sources `framework/lib/flows.sh` for `fl_table`, `fl_files`, and `fl_steps`. It does not
parse the table itself.
