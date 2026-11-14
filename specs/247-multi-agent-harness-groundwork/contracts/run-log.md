# Contract: Run log

Standard output carries only the run log. Standard error carries progress notes. The log has no
color codes and no timestamps other than `started=`. Every line is path-rewritten, then redacted.
Path rewriting makes project paths relative and replaces the agent home with `<home>`, the work
root with `<work>`, and any other path under the system temporary folder with `<tmp>` (on macOS,
also the per-user folder above `T`, since agents sometimes drop that segment). A root matches
only as a whole path segment.

## Header

```text
HARNESS run=<id> commit=<sha> type=<type> agent=<id> model=<model> judge=<agent>/<model>|off fallback=<agent>/<model>|off sdk=<version> runtime=<version> started=<ISO time>
Selected <n> scenario(s):
  <scenario>: <reasons>
```

Targeted-selection notes print before the header, as today. A full run prints
`Chain: 1:<id> -> 2:<id> ...` after the selection.

## Attempt block

```text

== <scenario> (<skill>) attempt <n> ==
system: installed plugin highway (16 skills)
  Direct plugin installs (repos, URLs, local paths) are deprecated. ...
user: /highway-help
skill: highway-experience
skill: highway-help
question: Which record?
  1. First
answer: 1
denied: read /etc/hosts
agent: Highway needs setup.
  Run /highway-setup to get started.
files: out/answer.md (created), notes.md (changed)
warning: Paraphrased question at turn 2: expected "...", got "..."
fail: assertion exists out/answer.md: expected a matching file; actual: none
not met: <bullet text> - <one-sentence reason>
```

- Entries appear in transcript order. `files:` follows the `agent:` entry of a turn that changed
  the project, and is left out otherwise. Paths in `files:` are relative to the project and sorted
  as created, then changed, then deleted.
- A multi-line entry's continuation lines are indented two spaces. Blank lines inside an entry are
  dropped.
- `skill:` shows the skill name. A permission summary `rejected <kind>: <detail>` becomes
  `denied: <kind> <detail>`. With `--verbose`, `approved <kind>: <detail>` becomes
  `approved: <kind> <detail>`, and a `usage:` line ends the conversation part: `usage: <calls>
  calls, <in> input tokens, <out> output tokens`.
- After the conversation come `warning:` lines (paraphrased questions only), then `result: pass`
  or one `fail:` line per failure, then one `not met:` line per bullet judged not met. A `fail:`
  line reads `fail: <kind> <check>[ <path>]: expected <expected>; actual <actual>[ (scenario line
  <n>)]`, with each part left out when empty, flattened to one line and capped at 400 characters.
  The scenario line appears when the failure comes from an `expect:` line. A failure's detail
  lines follow it, indented two spaces: the last 20, each capped at 200 characters, after a note
  of how many earlier lines were cut.

## Blocked block

A scenario whose fixture fails validation prints, in its selection slot:

```text

== <scenario> (<skill>) blocked ==
fail: fixture-blocked fixture <fixture>
  <problem>
  <problem>
```

## Run block

Run-level failures print where they happen:

```text

== run ==
fail: missing-token token: expected COPILOT_GITHUB_TOKEN or GITHUB_TOKEN; actual neither is set in the environment or harness/.env
cause: No Copilot token was found. Set GITHUB_TOKEN in harness/.env.
```

## Closing table

```text

== summary ==
| Scenario | Skill | Status | Attempts | Turns | Summary |
|---|---|---|---|---|---|
| help-smoke | highway-help | pass | 1 | 3 | judge 2/3 met |
| codify-smoke | highway-codify | fail | 2 | 3, 4 | assertion exists |
| objectives-smoke | highway-objectives | pass (flaky) | 2 | 3, 3 | - |
| profile-smoke | highway-profile | blocked | 0 | - | fixture-blocked |
| request-smoke | highway-request | skipped | 0 | - | chain stage 2 failed |
| setup-smoke | highway-setup | not run | 0 | - | run stopped |
Passed 1, failed 1, flaky 1, blocked 1, not run 1, skipped 1
Usage: 249 model calls, 7665632 input tokens, 75471 output tokens
Exit code: 1
Run folder: <path>
```

- Summary column:
  - a failure: `<kind> <check>`;
  - blocked: the failure kind;
  - skipped: `chain stage <n> failed`;
  - not run: `run stopped`;
  - a pass: `judge <met>/<total> met`, or `-` when the judge is off or covers no bullet.
- `Run folder:` appears only with `--transcripts`.
- A full run whose chain passed without `--transcripts` prints
  `Candidate snapshots were not saved; rerun with --transcripts <dir> to save them for --promote.`

## Progress (standard error)

```text
[ 3/16] start help-smoke attempt 1
[ 3/16] PASS help-smoke (attempt 1, 3 turns, 0m45s)
[ 4/16] FAIL codify-smoke (attempt 1) -> assertion
```
