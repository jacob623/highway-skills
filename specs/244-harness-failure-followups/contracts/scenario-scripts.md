# Contract: Scenario Scripts

Checked by `tests/harness-failure-followups.test.sh`, `tests/harness-scenarios.test.sh`, and
`tests/harness-coverage.test.sh`.

## No catch-all (FR-006)

No `.scenario` file under `harness/scenarios/` holds `ask-pattern: \?`, `ask-pattern: .`,
`ask-pattern: .*`, or `ask-pattern: .+`.

| Scenario | After the change |
| --- | --- |
| adr-smoke | ends after `[accept] Looks good.` |
| architecture-smoke | ends after `[accept] Looks good.` |
| assessment-smoke | `ask: Where would you like to go next?` / `say: [decline] Stop here.` |
| chain-request | ends after `[accept] Looks good.` |
| request-smoke | ends after `[accept] Looks good.` |
| codify-control-unmet | `ask-pattern: different action\|explore any of these options` / `say: [decline] Never mind.` |
| codify-standard-unmet | the same |
| controls-smoke, nfrs-smoke, objectives-smoke | end after the second `[accept] Looks good.` |

## Governance smokes (FR-007)

| Scenario | Replaces | With |
| --- | --- | --- |
| controls-smoke | `expect: contains library/governance/controls/*.md :: two-factor` | `expect: contains-any library/governance/controls/*.md :: two-factor` and `shows: Your Controls are recorded.` |
| nfrs-smoke | `expect: contains library/governance/nfrs/*.md :: two seconds` | `expect: contains-any library/governance/nfrs/*.md :: two seconds` and `shows: Your NFRs are recorded.` |
| objectives-smoke | `expect: contains library/objectives/*.md :: repeat` | `expect: contains-any library/objectives/*.md :: repeat` and `shows: Your Objectives are recorded.` |

## Unknown provider (FR-008)

In onboarding-smoke, chain-implementation, and implementation-onboards-platform, directly after the
`[edit] Remove AI-Augmented Technology Development.` reply, two copies of:

```text
ask-pattern: unable to infer a platform
say: [unknown] I don't know.
ask-pattern: Who builds or runs
say: No one.
```

## codify-configure (FR-009)

```text
open: Use highway-codify with the word configure.
shows: To configure platforms and coding standards, run highway-codify-config.
```

The `covers:` and `reaches: Entry` lines are unchanged.
