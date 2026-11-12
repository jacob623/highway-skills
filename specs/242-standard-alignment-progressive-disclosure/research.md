# Research: Standard Alignment Progressive Disclosure

Each item records the decision, why it was chosen, and what else was considered. No item is left
open; R8 names a value confirmed at run time.

## R1: One reader of the flows table

**Decision**: a new library, `framework/lib/flows.sh`, is the only code that parses a flows table.
Its functions are:

- `fl_table <skill-dir>`: prints `<file>\t<step>`, one line per step, in table order.
- `fl_files <skill-dir>`: prints each flow file path relative to the skill folder, in table
  order, once.
- `fl_steps <file>`: prints each level-3 heading text outside a fenced block, in order.
- `fl_skill_text <skill-dir>`: prints `SKILL.md`, then each flow file in table order, so a test
  can search one skill's text the way it searched `SKILL.md`.

The validator, the boundary test, `harness/bin/inventory.sh`, and the tests source it.
`inventory.sh` already sources `framework/lib/paths.sh` through `harness/bin/lib/paths.sh`, so
`$HW_LIB/flows.sh` resolves from there.

**Rationale**: the table format then has one definition (D4.4's single-implementation idea
applied to a parser). A skill without a table prints nothing, so every consumer treats an unsplit
skill as it does today.

**Alternatives considered**:
- Each consumer parsing the table itself: four copies of one format, which drift.
- A YAML or JSON sidecar listing the flows: a second artifact for the model to ignore, and the
  model needs the table in `SKILL.md` anyway.

## R2: Flows table format

**Decision**: the sentence `Before a step in this table, read its file and follow it to the end.`
is followed by a Markdown table with the header `| File | Steps |`.

- A File cell is one inline-code path, `` `references/<name>.md` ``.
- A Steps cell lists inline-code step names separated by `, `.
- The table sits in the Procedure introduction, before the first step that stays in `SKILL.md`.

**Rationale**: inline code is not a link, so P8.7 is unaffected, and the parser needs one pattern
for each cell. Putting the table before the router's first step means the model sees it before
any handoff.

**Alternatives considered**:
- Markdown links: P8.7 forbids relative link targets in instructions.
- A bulleted list: a model reads it equally well, but a list has no fixed column for steps.

## R3: What counts as a step

**Decision**:
- For the boundaries, a step is any `### ` heading outside a fenced block, in `SKILL.md` or a
  flow file, as Phase 13 defines it.
- For the harness inventory, a step in `SKILL.md` stays a `### ` heading under `## Procedure` (as
  today), and a step in a flow file is any `### ` heading outside a fenced block.

The step name is the heading text.

**Rationale**: a flow file has no Procedure heading, since its only L2 is Verification (boundary
4). Skipping fenced blocks keeps a template's headings out (FR-006).

**Alternatives considered**: requiring `## Procedure` in each flow file. That adds a second L2,
which boundary 4 forbids, and repeats the router's heading.

## R4: The validator's flow kind

**Decision**:
- `validate-skill.sh` already judges `references/*.md` as kind `reference`. It now judges a file
  that `fl_files` names as kind `flow`; other `references/` files stay `reference`.
- A flow file is exempt only from P7.1, P7.2, and P8.7, through a new `rc_flow_exempt_ids` in
  `rule-checks.sh`.
- Rules with an N/A condition keep it. For example, P5.15 and P9.1 return N/A for a file with no
  frontmatter, as they do for references today.

**Rationale**:
- P7.1 (Purpose) and P7.2 (version) are about the whole skill, and the router carries both.
- P8.7 forbids relative link targets because `SKILL.md` used to travel alone. A flow file holds
  no links anyway.
- Every other rule judges instructions, and a flow file is instructions moved out of `SKILL.md`
  (US3).

**Alternatives considered**: keeping flow files as kind `reference`. The reference exemptions
(P1.1, P1.3, P7.4, P7.5, P7.1, P7.2, plus P8.7 and P2.6 for bundled files) would let moved text
escape P2.6 and the rule-shape rules.

## R5: Harness inventory reads flow files

**Decision**:
- `inventory.sh` reads `SKILL.md` as today, then each file from `fl_files` in table order.
- From a flow file it takes every step (R3) and every `- ` bullet under `## Verification`.
- An id stays the first 12 hex digits of SHA-256 over the normalized bullet text, so a moved
  bullet keeps its id.
- Output order is `SKILL.md` first, then each flow file in table order.

**Rationale**: every `covers:` and treatment hash keeps resolving without editing a scenario,
because a bullet moves verbatim (FR-002, FR-010).

**Alternatives considered**: prefixing ids with the file name. That would break every `covers:`
line for a move that changes nothing a model does.

## R6: Tests that pin moved text

**Decision**: 49 tests name a split skill's `SKILL.md`.
- A test that searches the skill's text for wording reads `fl_skill_text` into a temporary file
  and searches that.
- A test that checks something only `SKILL.md` holds, such as frontmatter, a version, or
  `## When to use`, keeps reading `SKILL.md`.
- A test that extracts a section that moved, such as a step's body or a Verification bullet, reads
  it from the flow file that now holds it.

The affected tests are found by running the suite after each split, not by guessing. No assertion
is removed or loosened (D3.5, FR-011).

**Rationale**: the tests guard the same words, wherever they now live.

**Alternatives considered**: concatenating the skill folder inside each test with inline `cat`.
That repeats the table order in 49 places.

## R7: Moving text verbatim

**Decision**: each split is done by a one-off helper run in the agent session, not a committed
script.
- It cuts the named `### ` sections, from the heading up to the next `### ` or `## `, out of the
  Procedure.
- It writes them, in their original order, under an L1 heading in the flow file.
- It moves the Verification bullets assigned to that flow.
- It adds the flows table.

The check: the moved text, with only the headings and the table set aside, joins back to the
original byte for byte (SC-002).

**Rationale**: hand-moving about 1,500 lines invites drift. A mechanical cut keeps the wording,
and the join check proves it.

**Alternatives considered**: a committed migration script. The Declared Toolchain rule would
apply to it, and it runs once.

## R8: The GPT-5.6 Luna model id

**Decision**: `harness/harness.config.json` sets `"model"` to the Copilot id for GPT-5.6 Luna.
- The id is read from `client.listModels()` once a token exists. The expected form is
  `gpt-5.6-luna`.
- If the id differs, the config takes the listed value.
- The judge model follows the run model unless `--judge-model` is given, so it changes too.

**Rationale**: Q2 of the clarification sets the model before any harness run. Only the Copilot
service can confirm the id.

**Alternatives considered**: passing `--model` on each run. That works for one run, but the
config is the stated default, and Q2 asks for the switch.

## R9: Live run protocol and transcripts

**Decision**:
1. **Before any skill change**: `node harness/src/cli.ts --smoke --transcripts
   specs/242-standard-alignment-progressive-disclosure/harness/pre-smoke`.
2. If any scenario fails, or the run cannot start (for example `missing-token`), stop and ask
   the person what to do.
3. **After the split**: the same command with `post-smoke`.
4. **Then Option B**: `--changed-since main` with the default transcripts folder.

The runner already redacts the token from every file it writes. A final search of both kept
folders for the token's value must find nothing.

**Rationale**:
- Q2 asks for both smoke transcripts in the spec folder and Option B after.
- The smoke set has one scenario for each of the 16 skills.
- Option B covers every scenario whose skill changed.

**Alternatives considered**: keeping transcripts under `harness/runs` and copying them after.
`--transcripts` writes them in place, so nothing needs copying.

## R9a: No token in this environment

**Finding**:
- There is no `harness/.env`.
- Neither `COPILOT_GITHUB_TOKEN` nor `GITHUB_TOKEN` is set.
- `gh` is not installed.

The pre-change smoke run will end with `missing-token`.

**Decision**: per Q2, implementation stops before the first skill change and asks the person
whether to supply a token or proceed another way. The baseline suite, the harness unit tests, the
model switch, and the library and test work that does not touch a skill may run first.

## R10: The boundary test

**Decision**: `tests/skill-flow-pattern.test.sh` checks boundaries 1 to 12 on every skill under
`skills/`, using `flows.sh`.

- It prints `skill-flow-pattern: <skill>: boundary <n>: <detail>` for each breach, then
  `PASS`/`FAIL`.
- It declares `Instrument class: executed-behavior` and `Artifact classes: source-document`.
- `--probe source-document` copies one valid split skill into a temporary folder, seeds one
  breach per boundary there, and requires each breach to be reported.
- `--neutralise` runs the same copy unseeded and requires a pass (D3.6, D3.7).

**Rationale**: the probe contract and the line format match the existing tests, so
`tests/run-all.sh` runs it like the others.

**Alternatives considered**: putting the boundaries in the validator now. Phase 15 does that
through Principle XIV, and FR-016 keeps both constitutions unchanged here.

## R11: Verification bullet assignment

**Decision**:
- A Verification bullet moves to the flow file holding every step whose outcome it checks.
- A bullet that checks steps in two files, or the whole skill, stays in `SKILL.md`.
- The assignment is made while splitting, by reading each bullet against the steps' names, and is
  recorded in `tasks.md` per skill.

**Rationale**: FR-006 keeps checks beside the steps they check. Codify needs its checks moved to
get under 5,000 tokens (Phase 13).

**Alternatives considered**: leaving every bullet in `SKILL.md`. Codify would stay over the
ceiling, and the checks would sit far from their flows.

## R12: Documentation that names the layout

**Decision**:
- `framework/authoring-standard.md` gains the router, flow file, and flows table rules and the
  500-line and 20,000-character limits.
- `harness/README.md`'s inventory description names flow files.

Both change in the same change (D6.1).

**Rationale**: D6.1 requires live documentation to describe current behavior.

**Alternatives considered**: none; D6.1 is mandatory.
