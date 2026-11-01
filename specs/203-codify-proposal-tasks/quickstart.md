# Quickstart: Codify Proposal Tasks

## Prerequisites

- Repository root: `highway-skills/`
- Bash 3.2.57-compatible shell
- Baseline suite green before the first edit (D3.1)

## Validate

1. Baseline: `bash .highway/tools/tests/run-all.sh`. Expect `0 failed`.
2. Probe (D3.6): run `bash .highway/tools/tests/codify-proposal-tasks.test.sh` before the skill edits. Expect it to fail on the new strings. Record the output.
3. After the edits:
   - `bash .highway/tools/validate-skill.sh .highway/skills/highway-codify` reports the skill valid.
   - `bash .highway/tools/validate-skill.sh .highway/skills/highway-adr` reports the skill valid.
   - `bash .highway/tools/validate-library.sh .highway/library/templates/output/codify-record.md` and the same for `codify-tasks.md` pass.
   - `bash .highway/tools/tests/codify-proposal-tasks.test.sh` and `bash .highway/tools/tests/highway-codify.test.sh` exit 0.
4. Regenerate: `generate-catalog.sh`, `generate-library-catalog.sh`, `generate-agent-adapters.sh` (D4.7).
5. Final: `bash .highway/tools/tests/run-all.sh`. Expect `0 failed` (D3.2).

## Manual walkthrough

Use an accepted implementation with one Technology Choice and a Terraform task.

| Step | Expected |
|---|---|
| `/highway-codify [Implementation title]` | Opening names the Technology Choice and says automating these tasks may be worth visiting. Titles start with verbs. The invitation line ends the list. See [suggest-list](contracts/suggest-list.md) |
| Pick one | The standard line appears before any source line. The proposal follows. See [align-checks](contracts/align-checks.md) |
| Read the proposal | Title, Summary, Description, Acceptance criteria, Diagram, Tasks. `flowchart TB`. Arrow labels match task actions. No Components, Current state, Action, Day, or Means. See [proposal](contracts/proposal.md) |
| Edit a task's method to a library the standard does not accept | The standard line names the correction, and the proposal is shown again |
| Accept | `codify.md` has the six sections. `codify-tasks.md` starts with `[Executor]` and ends with `[README]`. See [file-list](contracts/file-list.md) |

The suite checks skill and template text. It does not run codify or perform a web lookup.
