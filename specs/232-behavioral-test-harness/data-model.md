# Data Model: Behavioral Test Harness

## Scenario (`harness/scenarios/<skill>/<name>.scenario`)

| Field | Key | Cardinality | Rule |
|---|---|---|---|
| Id | `id` | 1 | Unique across scenarios; equals the file name without `.scenario` |
| Primary skill | `skill` | 1 | A directory under `.highway/skills/` |
| Pass-through skills | `through` | 0..n | Skills the conversation enters |
| Fixture | `fixture` | 1 | `empty`, a stage name, or an overlay name |
| Chain position | `chain` | 0..1 | 1–6; unique across scenarios |
| Smoke | `smoke` | 0..1 | `yes` marks the skill's one smoke scenario |
| Web | `web` | 0..1 | `yes` approves URL fetches |
| Opening message | `open` | 1 | The first message sent |
| Keyed reply | `ask` or `ask-pattern`, then `say` | 0..n | `say` follows its key; optional `[kind]` prefix: accept, edit, question, unknown, decline, select |
| Writes | `writes` | 0..n | Globs relative to the project root; `**` crosses folders |
| Expected file | `expect` | 0..n | `<assertion> <path>[ :: <argument>]`; every path must match a `writes` glob unless the assertion is `absent` or the path pre-exists in the fixture |
| Covered bullet | `covers` | 0..n | `<12-hex hash> <bullet text>` |
| Step reached | `reaches` | 0..n | A `###` step name of the primary skill |

## Fixture

| Kind | Location | Rule |
|---|---|---|
| Stage | `harness/fixtures/stages/<stage>/` | Stages: setup, request, discovery, architecture, implementation |
| Overlay | `harness/fixtures/overlays/<name>/` | `overlay.txt` holds `stage: <stage>`; files replace or add; `.delete` lists removed paths |
| Template map | `harness/fixtures/templates.map` | `<glob>\t<template file name>` |

## Coverage item (output of `harness/bin/inventory.sh`)

`<skill>\t<kind>\t<id>\t<text>`, kind ∈ `step`, `verification`, `error`. For bullets, id is the
12-hex hash. For steps, id is the step name.

## Treatment (`harness/coverage/treatments.txt`)

- `invariant: <skill> <hash> <invariant> :: <bullet text>`, invariant ∈ storage, no-shell,
  writes-nothing.
- `waiver: <skill> <hash> <reason> :: <bullet text>`.

A bullet's treatment is `scenario` when any scenario covers its hash, otherwise its treatment
line. A tag whose hash is not in the inventory is unknown and is reported beside the uncovered
bullets of the same skill.

## Run

| Field | Rule |
|---|---|
| Id / folder | `<YYYYMMDD-HHMMSSZ>-<full|smoke|targeted>-<short commit>` |
| Selection | List of `{scenario, reasons[]}` |
| Report | `report.md`, `report.json`, `junit.xml`, `selection.txt` |
| Status | exit 0, 1, or 2 |

## Attempt

| Field | Rule |
|---|---|
| Files | `attempt-N.raw.jsonl`, `attempt-N.jsonl`, `attempt-N.result.json` |
| Result | `{scenario, attempt, model, judgeModel, status: pass|fail|blocked|not-run|skipped, failures[], warnings[], usage, judge[]}` |
| Warning kinds | `paraphrased-question`, `flaky` |

## State transitions

- Scenario: `selected → running → (pass | fail → retry → pass[flaky] | fail)`; `blocked` when its
  fixture fails validation; `not-run` after a rate-limit stop; `skipped` after a chain failure.
- Candidate snapshot: written per passing chain stage 1–5, only when all six stages pass; promoted
  by `--promote <run folder>`.
