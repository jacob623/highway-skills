# Contract: Stdout and Failure Output

## Header (once per run)

```text
HARNESS run=<run id> commit=<sha> type=<full|smoke|targeted> model=<id> judge=<id|off> sdk=<version> cli=<version>
```

## Progress (one line per attempt)

```text
[ 3/12] PASS codify-plan-review (attempt 1, 14 turns, 4m12s)
[ 4/12] FAIL codify-decline (attempt 2) -> unmatched-question
```

## Failure block (as each failure happens)

```text
==== FAILURE codify-decline (attempt 2 of 2) ====
Where:   harness/scenarios/highway-codify/codify-decline.scenario; stage -; turn 6; step revise
What:    expect absent code/*/.highway/features/*/codify.md
         expected: no file; actual: code/worker/.highway/features/001-restart-the-worker/codify.md
         declared at line 18
Covers:  4f2a91c0d3e1 Declining a proposal writes nothing.
Recent:  (last turns, at most 20 lines, redacted)
Rejected: none
Likely cause: The skill wrote a file the scenario expects to be absent; check the decline path in the skill.
HARNESS-FAILURE {"run":"...","scenario":"codify-decline","attempt":2,"kind":"assertion","stage":null,"turn":6,"step":"revise","check":"absent","path":"code/*/.highway/features/*/codify.md","expected":"no file","actual":"...","line":18,"covers":["4f2a91c0d3e1"],"cause":"..."}
```

## Failure kinds and likely causes

| Kind | Likely cause |
|---|---|
| `unmatched-question` | The skill's question changed, or the agent left the workflow at this step. Compare the question with the scenario's `ask:` lines. |
| `rejected-request` | The agent tried to run a shell command, use memory, or write outside the project, which the storage contract forbids. |
| `outside-writes` | The agent changed a file outside the scenario's `writes:` patterns. Check the skill's output paths. |
| `turn-limit` | The agent kept going past the turn limit; it repeated the question "<q>" <n> times. |
| `timeout` | The attempt ran past its time limit; the agent stalled or the model was slow. |
| `assertion` | A written file is missing a required part. If it is a template heading, the template changed after the fixture was promoted, or the skill skipped its template. |
| `fixture-blocked` | The scenario's fixture no longer matches its template. Promote a fresh chain run or fix the fixture. |
| `missing-token` | No Copilot token was found. Set GITHUB_TOKEN in harness/.env. |
| `no-access` | The token has no Copilot access. Check the account's Copilot plan. |
| `build-failed` | The distribution build failed; the last lines of its output follow. |
| `rate-limit` | Copilot kept rate limiting after 3 retries. Lower --parallel or wait. |
| `allowance` | The premium-request allowance is used up. Wait for the reset or raise the limit. |
| `chain-stage` | A chain stage failed, so later stages and every scenario were skipped. |
| `unclassified` | The raw error follows. |

## Summary (end of run)

```text
==== SUMMARY ====
Passed 10, failed 1, flaky 1, blocked 0, not run 0, skipped 0
FAIL codify-decline: assertion - <likely cause>
Run folder: harness/runs/20261110-153512Z-targeted-a1b2c3d
```

Every line is redacted, and the recent-turns section is capped at 20 lines of 200 characters.
