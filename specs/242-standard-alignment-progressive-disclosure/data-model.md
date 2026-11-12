# Data Model: Standard Alignment Progressive Disclosure

## Entities

### Skill folder

`skills/<id>/`: `SKILL.md`, and optionally `references/`, `assets/`, `scripts/`.

- **Split skill**: one of the twelve in the split map below. It has a flows table and one or more
  flow files.
- **Unsplit skill**: highway-profile, highway-setup, highway-help, highway-experience. These have
  no flows table and stay as they are. highway-experience keeps its three references, each named
  by a line that begins "Read `references/<file>`".

### Router (`SKILL.md` of a split skill)

- Keeps:
  - the frontmatter;
  - every level-2 section;
  - the Procedure introduction, which gains the flows table;
  - `Entry`, `Classify`, and the other steps the split map leaves in `SKILL.md`;
  - every rule two flows apply;
  - each Verification bullet that spans files.
- Constraints: at most 500 lines and 20,000 characters (boundary 1). Outside the table, no line
  names a file in `references/` (boundary 8).
- Version: MINOR bump; the Example shows the new version.

### Flows table

- Preceded by the sentence "Before a step in this table, read its file and follow it to the end."
- Header `| File | Steps |`, then one row per flow file (format: R2 in `research.md`).
- Constraints:
  - one table per skill;
  - each Steps cell lists exactly that file's steps, in file order (boundary 7);
  - every flow file has a row, and every row names an existing file (boundary 8).

### Flow file

`skills/<id>/references/<name>.md`.

- Shape (boundary 4):
  - no frontmatter;
  - line 1 is `# <Flow name>`;
  - an optional introduction holds the rules only this flow applies;
  - the steps are `### <step>`, verbatim and in their original order;
  - `## Verification`, with one or more bullets, ends the file.
- Constraints:
  - boundaries 1, 2, 3 (at least 25 lines), 9 (names no file in `references/`), and 10;
  - judged by the validator as kind `flow` (R4).

### Step

A level-3 heading outside a fenced block. Its name is the heading text. It has exactly one home:
`SKILL.md` or one flow file (boundary 5).

### Step reference

A backticked name after "go to", "return to", "follow", "resume at", or "stay on". It contains
no `/` or `.` and does not start with `highway-`.
- If it is followed by "in `highway-<name>`", it is cross-skill and must name a step of that
  skill (boundary 11).
- Otherwise it must name a step of its own skill (boundary 10).

### Verification bullet

A `- ` line under `## Verification`.
- It lives with the steps whose outcome it checks.
- If it spans files, it stays in `SKILL.md`.
- Its harness id (first 12 hex digits of SHA-256 over the normalized text) is unchanged by the
  move.

### Inventory item

Output of `harness/bin/inventory.sh`: `<skill>\t<kind>\t<id>\t<text>`.
- Rows come from `SKILL.md`, then the flow files in table order.
- Kinds are `step`, `verification`, and `error`.

### Live run

One harness run with `--transcripts <dir>`. It produces a run folder with `report.md`,
`report.json`, `junit.xml`, `selection.txt`, and per-scenario transcripts, all redacted.

- **Pre-smoke run**: `--smoke` before any skill change. If it fails, implementation stops.
- **Post-smoke run**: `--smoke` after the split.
- **Affected run**: `--changed-since main` after the split.

## Split map

Step names are the heading text. "Stays" lists the steps left in `SKILL.md`.

| Skill | Flow file | Steps |
| --- | --- | --- |
| highway-codify | `references/catalog.md` | `catalog` |
| | `references/proposal.md` | `draft`, `code tasks`, `provider`, `standards`, `align`, `govern`, `resume`, `join`, `folder`, `layout`, `propose`, `revise` |
| | `references/record.md` | `identifier`, `title`, `write`, `index`, `index rules`, `plan`, `check`, `menu`, `review` |
| | `references/code.md` | `tasks`, `code`, `close` |
| highway-implementation | `references/proposal.md` | `start` |
| | `references/record.md` | `identifier`, `title`, `write`, `platforms` |
| | `references/amend.md` | `add capabilities`, `delivery platforms`, `delivery decline` |
| highway-adr | `references/proposal.md` | `start`, `span` |
| | `references/record.md` | `identifier`, `title`, `write` |
| highway-codify-config | `references/platforms.md` | `platforms`, `kind`, `platform proposal`, `platform rules`, `platform written` |
| | `references/standards.md` | `standards`, `standard rules`, `rule shape`, `standard proposal`, `standard write` |
| | `references/conflicts.md` | `conflicts`, `resolve` |
| highway-discovery | `references/options.md` | `analyze`, `check`, `identifier`, `title`, `write`, `start`, `explore` |
| highway-nfrs | `references/proposal.md` | `recommend`, `more`, `queue`, `ask`, `capture` |
| | `references/record.md` | `identifier`, `title`, `write` |
| highway-controls | `references/proposal.md` | `recommend`, `more`, `queue`, `ask`, `capture` |
| | `references/record.md` | `identifier`, `title`, `write` |
| highway-objectives | `references/proposal.md` | `recommend`, `more`, `queue`, `ask`, `capture` |
| | `references/record.md` | `identifier`, `title`, `write` |
| highway-onboarding | `references/proposal.md` | `overview`, `capabilities`, `map`, `mapping` |
| | `references/orchestrate.md` | `orchestrate`, `lineage`, `configure` |
| highway-architecture | `references/proposal.md` | `start` |
| | `references/record.md` | `identifier`, `title`, `write`, `name` |
| highway-assessment | `references/findings.md` | `write`, `list of findings`, `finding` |
| | `references/ready-records.md` | `ready records` |
| highway-request | `references/proposal.md` | `start` |
| | `references/record.md` | `identifier`, `title`, `write` |

That makes 27 flow files. Boundary 12 merged codify's `plan.md` into `record.md`, kept codify's `suggest.md` steps in `SKILL.md`, and merged discovery's three files into `options.md` (tasks.md Notes).

### Steps that stay in `SKILL.md`

| Skill | Stays |
| --- | --- |
| highway-codify | `Entry`, `choose`, `record check`, `Classify`, `rank`, `codified`, `code project`, `suggest` |
| highway-implementation | `Entry`, `choose`, `onboarding`, `Classify`, `close`, and the rule steps `execution`, `field`, `why it matters`, `capability title`, which steps in three flow files apply (tasks.md Notes) |
| highway-adr | `Entry`, `choose-discovery`, `onboarding`, `choose-option`, `Classify`, `close` |
| highway-codify-config | `Entry`, `Classify`, `menu`, `current`, `entry level`, `use entries`, `platform entries` |
| highway-discovery | `Entry`, `choose`, `Classify` |
| highway-nfrs, highway-controls, highway-objectives | `Entry`, `Classify`, `review` |
| highway-onboarding | `Classify`, `summary`, `review` |
| highway-architecture | `Entry`, `choose`, `onboarding`, `Classify`, `close` |
| highway-assessment | `Entry`, `Classify`, `review`, `summary` |
| highway-request | `Entry`, `Classify`, `intake`, `close` |

### Rules that move with a flow

Each of these is a paragraph or list that only one flow applies. It moves into that flow file's
introduction, or stays inside the step that holds it today.

| Skill | Rule | Goes to |
| --- | --- | --- |
| highway-codify | `code tasks` items 10 and 11 | `references/code.md` |
| highway-adr | evidence reading order | `references/proposal.md` |
| highway-discovery | evidence loading order | `references/options.md` |
| highway-assessment | category and trace-chain rules | `references/findings.md` |
| highway-request | seven-domain order | `references/proposal.md` |

### Rules that stay in `SKILL.md`

| Skill | Rule |
| --- | --- |
| highway-codify | step 3 of `index` (the Features entry): `code` also applies it (Q1) |
| highway-discovery | the redaction rule |
| highway-assessment | the catalog-first rule |
| highway-onboarding | the queue rules |
| highway-request | the secrets exclusion |

A rule found to be applied by two flows during the split also stays in `SKILL.md`. The finding is
recorded in `tasks.md`.

## Validation baseline (D3.4)

Expected verdicts of `tests/skill-flow-pattern.test.sh` against today's skills, before it is
wired into the suite. The test's actual output is compared to this table first.

| Skill | Lines | Characters | Expected |
| --- | --- | --- | --- |
| highway-codify | 770 | 55,482 | boundary 1 fails |
| highway-implementation | 456 | 34,319 | boundary 1 fails |
| highway-adr | 406 | 30,750 | boundary 1 fails |
| highway-codify-config | 453 | 28,139 | boundary 1 fails |
| highway-discovery | 370 | 24,805 | boundary 1 fails |
| highway-nfrs | 397 | 21,589 | boundary 1 fails |
| highway-onboarding | 347 | 21,017 | boundary 1 fails |
| highway-architecture | 327 | 21,003 | boundary 1 fails |
| highway-assessment | 309 | 19,139 | pass |
| highway-controls | 368 | 17,873 | pass |
| highway-objectives | 370 | 17,398 | pass |
| highway-request | 292 | 15,088 | pass |
| highway-profile | 280 | 11,134 | pass |
| highway-setup | 184 | 7,781 | pass |
| highway-help | 90 | 4,128 | pass |
| highway-experience | 81 | 3,055 | pass: no table, and each reference has a "Read" line |

Boundaries 2 to 11 are expected to pass on every skill today:
- no skill has a flow file yet;
- step names are unique within each skill;
- every within-skill and cross-skill handoff resolves.

Any other breach found is a defect in the test or a finding to resolve before wiring.

After the split, every skill is expected to pass every boundary.

## State transitions

```text
baseline ──pre-smoke passes──▶ library + tests ──split per skill──▶ regenerate ──▶ post-smoke + affected runs
    │
    └─pre-smoke fails or cannot start──▶ stop; the person decides
```
