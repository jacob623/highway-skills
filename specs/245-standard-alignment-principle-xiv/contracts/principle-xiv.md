# Contract: Principle XIV text in `framework/constitution.md`

## Placement

- `### XIV. Agent Skills Alignment` follows Principle XII's Rationale and precedes
  `## Principle Precedence`. XIII stays retired.
- P5.15's row moves out of Principle V's table, byte for byte, and becomes the first row of
  Principle XIV's table. P5.16 stays in Principle V.

## Section text

```markdown
### XIV. Agent Skills Alignment

The [Agent Skills specification](https://agentskills.io/specification) defines the skill format.
The rules below narrow it for Highway skills without restating it. Each is decided once per skill,
from its `SKILL.md`, and names the clause it narrows below the table.

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P5.15 | (unchanged row) | | [auto] |
| P14.1 | A `SKILL.md` or flow file MUST NOT exceed 500 lines or 20,000 characters. | `SKILL.md` and each flow file have at most 500 lines and at most 20,000 characters (boundary 1). | [auto] |
| P14.2 | A skill's flow files MUST keep the layout this rule's Observable states. | Each flow file is a Markdown file directly in `references/` (boundary 2). A skill has at most 6 flow files, each at least 25 lines (boundary 3). Each flow file has no frontmatter, starts with its only level-1 heading, holds its steps as level-3 headings, and ends with `## Verification`, its only level-2 heading, holding at least one bullet (boundary 4). | [auto] |
| P14.3 | A skill's `SKILL.md` MUST be the one route to each of its steps. | Each step is a step in exactly one file (boundary 5). `Entry` and `Classify` are steps of `SKILL.md` (boundary 6). A skill with flow files has one flows table, whose Steps cell lists each flow file's steps in file order; a File and Steps table without the flows table's sentence fails (boundary 7). No `SKILL.md` line outside the flows table names a file in `references/`, each file in `references/` has a row, and each row names a file that exists. Without a flows table, each file in `references/` is named by a `SKILL.md` line beginning "Read `references/<file>`" (boundary 8). | [auto] |
| P14.4 | A skill's step references MUST resolve one file reference from `SKILL.md`. | No flow file names a file in `references/` (boundary 9). Each step reference names a step of the skill (boundary 10). A step reference followed by `` in `highway-<name>` `` names a skill beside this one and a step of it (boundary 11). In a flow file, a step reference outside a reply line names a step of that file or of `SKILL.md` (boundary 12). | [auto] |

Specification clauses narrowed:
- P5.15: `SKILL.md` format, `description` field.
- P14.1: Progressive disclosure.
- P14.2: Optional directories, `references/`.
- P14.3: None (Highway pattern).
- P14.4: File references, for boundary 9. Boundaries 10 to 12: None (Highway pattern).

Rationale: an Agent Skills client loads `SKILL.md` when a skill activates and opens a flow file
only when a step needs it. These rules keep each load small and every step reachable from the file
that names it.
```

Each rule sentence: one keyword (P1.1), at most 25 words (P1.3), no token from the Prohibited
Vagueness List or the Prohibited Nondeterministic Criterion Tokens.

## Definitions rows (after **Skill**)

```markdown
| **Flow file** | A file in a skill's `references/` that the skill's flows table names. |
| **Flows table** | The File and Steps table in `SKILL.md` directly after the sentence "Before a step in this table, read its file and follow it to the end." |
| **Step** | A level-3 heading in `SKILL.md` or a flow file, outside a fenced block. |
| **Step reference** | A backticked name after "go to", "return to", "follow", "resume at", or "stay on" that contains no `/` or `.` and does not start with `highway-`. |
| **Reply line** | A list item that starts with a backticked reply class and a colon. |
```

## Precedence row (after rank 11)

```markdown
| 12 | XIV. Agent Skills Alignment | Governs how a skill's files are laid out for an Agent Skills client. |
```

## Self-Application

The paragraph keeps its existing sentences and adds: "P5.15 remains individually addressable
within Principle XIV."

## Sync Impact Report (new, at the top)

- Version change: 10.4.0 → 10.5.0 (MINOR), 2026-11-13.
- Bump rationale: Principle XIV is added. It holds the rules that narrow the Agent Skills
  specification, and every skill already passes them. `tests/skill-flow-pattern.test.sh` is
  retired because the Principle XIV checks decide every boundary it checked, each proved by a seeded
  case in `tests/rule-checks.test.sh` (D3.5).
- Changed elements: the version line; the Last Amended date (2026-11-12 → 2026-11-13); Definitions
  (five terms); Principle V (P5.15 moved out); Principle XIV (added, with P5.15 and P14.1 to
  P14.4); Principle Precedence (rank 12); Self-Application (one sentence).
- Rule count 76 → 80. Tier counts: [auto] 15 → 19, [agent-checkable] 61, [human-review] 0.
- Unchanged: every other rule's keyword, obligation, Observable, and tier; every other rank.
- Self-application review against P1.1 to P1.4, P6.4, P6.6, and P7.3.

## Version line

`**Version**: 10.5.0 | **Ratified**: 2026-09-06 | **Last Amended**: 2026-11-13`
