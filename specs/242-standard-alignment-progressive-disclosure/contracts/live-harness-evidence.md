# Contract: Live Harness Evidence

## Model

`harness/harness.config.json` `"model"` is the Copilot id for GPT-5.6 Luna, confirmed through
`client.listModels()` (R8). It is set before the first harness run of this feature.

## Runs

| Run | When | Command | Transcripts |
| --- | --- | --- | --- |
| Pre-smoke | before any `skills/` change | `node harness/src/cli.ts --smoke --transcripts specs/242-standard-alignment-progressive-disclosure/harness/pre-smoke` | kept in the spec folder |
| Post-smoke | after the split and regeneration | same, with `post-smoke` | kept in the spec folder |
| Affected (Option B) | after post-smoke | `node harness/src/cli.ts --changed-since main` | `harness/runs` (default) |

## Gate

- The pre-smoke run must exit 0. Any failure, including `missing-token`, stops implementation
  before the first skill change, and the person decides how to continue.
- The pre-smoke run `20261112-162017Z-smoke-49ab958` failed: 6 of 16 passed, on unchanged skills.
  The person made it the **baseline**, and its failures are recorded in `harness-model-findings.md`
  as F1 to F10.

## No worse than the baseline

Post-smoke run, scenario by scenario:

| Baseline status | Required after the split |
| --- | --- |
| pass or pass (flaky): assessment, experience, help, architecture, codify, request | pass or pass (flaky) |
| fail: adr, codify-config, controls, discovery, implementation, nfrs, objectives, onboarding, profile, setup | pass, or fail where each failing attempt's transcript shows a finding F1 to F10 |

Affected run (`--changed-since main`): each scenario passes, or each failing attempt's transcript
shows a finding F1 to F10.

A failure that matches no finding is a regression. It is diagnosed per `harness/README.md`
("Diagnosing failures") and fixed before the phase closes. Each verdict is recorded in the Notes
section of `tasks.md`.

## Redaction

The runner redacts token values from every file it writes. After each kept run, searching its
folder for the token value must find nothing. The token itself is never printed or written.
