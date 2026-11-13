# Contract: Final Run Evidence

## Order

1. Every change is made.
2. `bash tests/run-all.sh` passes, and so do the harness unit tests and `tsc`.
3. The generators run twice, and the second run changes nothing.
4. The final live runs, all with `--model gpt-5.6-luna`:
   - `node harness/src/cli.ts --smoke --model gpt-5.6-luna`
   - `node harness/src/cli.ts --changed-since main --model gpt-5.6-luna`
   - `node harness/src/cli.ts --skills highway-request --model gpt-5.6-luna`, or the narrowest
     selection that runs request-setup-needed and chain-request, when `--changed-since main`
     leaves them out.

When a change follows a final run, the final runs are repeated.

## Capture

- Copy each run folder to `specs/243-harness-failure-resolutions/harness/<label>/<run id>/`:
  `smoke`, `changed`, and `extra`.
- `.gitignore` holds `specs/243-harness-failure-resolutions/harness/*`.
- `git check-ignore` reports the folder ignored, and `git status` lists nothing under it.
- A search for the token's value finds 0 matches in the captured files. The value is never
  printed.

## Verdicts

- A scenario passes when either attempt passes, flaky included.
- A failure is explained by F3, F7, F15, or a service block, or it becomes a new finding (FR-027).
- `harness-model-findings.md` records, for each in-scope finding, the resolution applied and its
  confirming run id (FR-026). F3, F7, and F15 are unchanged.
