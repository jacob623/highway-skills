# Contract: harness `shows:` and the setup-needed scenario

## Key

`shows: <text>` is repeatable. After a run that ended, each value must appear in the concatenated agent
messages of the transcript. A missing value is a failure of kind `assertion` with check `shows`, expected
`text "<value>"`, actual `the agent did not show it`.

- `harness/src/scenario.ts` parses it into `Scenario.shows: string[]`.
- `harness/src/checks.ts` exports `showsFailures(agentText, shows)`.
- `harness/src/runner.ts` runs it beside the `expect` checks.
- `tests/harness-scenarios.test.sh` accepts the key.
- `harness/README.md` lists it.

## Scenario

`harness/scenarios/highway-request/request-setup-needed.scenario`:

```text
# The setup-needed stop: highway-request in a project with no seeded files.
id: request-setup-needed
skill: highway-request
fixture: empty
open: /highway-request <the request-smoke problem statement>
shows: **Oops... we need to setup your repository.**
shows: Highway needs to gather your organizational preferences and set up your repository. Run /highway-setup to get started.
```

No `ask`, so a question fails as `unmatched-question`. No `writes:`, so any write fails as `outside-writes`.
