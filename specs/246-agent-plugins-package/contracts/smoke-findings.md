# Contract: the smoke run and its findings

## Order

1. `tests/run-all.sh` exits 0 (SC-004).
2. `node harness/src/cli.ts --smoke --transcripts specs/246-agent-plugins-package/harness` runs
   from the repository root.
3. `git status --short specs/246-agent-plugins-package/harness` prints nothing (FR-018).

## Classifying each failing scenario

| The failure | Class | Action |
| --- | --- | --- |
| Kind `plugin-install`, or a rejected read inside the installed plugin, or the agent says a Highway skill is unavailable | Load failure | Fix it in this spec, then repeat the smoke run (FR-021) |
| Any other failure kind | Skill-behavior failure | Record it per the section below (FR-019) |
| `blocked` with `service-error` only, or `not-run` after a run stop | Service | Record it as a Service finding, or add the run to an existing Service finding |

## Recording

- **Matching an existing finding**: when the failure's skill, step, and failure kind match a
  finding in `harness-model-findings.md`, add a Runs line to that finding. Do not open a new one.
- **New finding**: otherwise, add `## F<next>: <title>` starting at F26, with these fields:

  ```markdown
  **Skill**: <skill ids>

  **Runs**:

  - Plugin install smoke (GPT-5.6 Luna) `<run id>`: <scenario> (<attempts>)

  **Category**: Skill | Scenario | Harness | Model | Service

  **Confirmed**: Yes | No

  **Basis**: <the transcript evidence: turn, question, reply, file, or check>

  **Proposed resolution**: <the change and where, or "Investigate ...", or "No change yet. Watch ...">
  ```

- **Placement**: a finding goes under `# Harness Failures` when **Confirmed** is Yes, and under
  `# Research Harness Failures` when it is No.
- **No failures**: when the run has none, `harness-model-findings.md` is unchanged, and the spec's
  completion report records the run id.
