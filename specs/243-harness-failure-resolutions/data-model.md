# Data Model: Harness Failure Resolutions

## Finding

An entry under `# Harness Failures` in `harness-model-findings.md`.

| Field | Rule |
| --- | --- |
| Skill, Runs, Category, Confirmed, Basis, Proposed resolution | Kept as written. |
| Resolution applied | New. Added after the final runs (FR-026). Names the changes made. |
| Confirming run | New. The final run id or ids whose transcripts show the finding resolved, or the attempt that still shows it. |

- In scope: F1, F2, F4, F5, F6, F8, F9, F10, F11, F12, F13, and F14.
- F3, F7, and F15 are unchanged.
- F5 gains a per-scenario diagnosis table, as F4 has (FR-009).
- A failure in the final runs that F3, F7, F15, or a service block does not explain becomes a new
  finding, F16 onward, with Skill, Runs, Category, Confirmed, and Basis (FR-027).

## Failure kind (harness)

`FAILURE_KINDS` in `harness/src/failure.ts`.

| Kind | New | Meaning | Outcome |
| --- | --- | --- | --- |
| `service-error` | Yes | The session failed a turn with code -32603, or "No response was returned", after one resend. | When the last attempt's failures are all `service-error`, the scenario is `blocked`, not `fail`. |

The kind is not in `EXIT_2_KINDS`, so it does not stop the run.

## Scenario outcome

`pass`, `fail`, `blocked`, `not-run`, and `skipped`. They are unchanged, except that `blocked`
now also covers a service error that persists after the retry. Before this change, `blocked` was
only a fixture block.

## Skills before output (harness)

A list in `DriveResult`. A skill is appended when it is invoked before the first output. Now a
read of `<…>/highway-experience/SKILL.md`, approved before the first output, also appends
`highway-experience` once.

## State to branch (skill text)

| Skill and step | State | Branch |
| --- | --- | --- |
| adr `Entry` | No id, and the opening holds one waiting Discovery's exact title | That Discovery |
| architecture `Entry` | No id, and the opening holds one waiting ADR's exact title | That ADR |
| discovery `Entry` | No id, and the opening holds one ready Discovery's exact title | That Discovery, at `start` |
| discovery `Entry` | No id, no Discovery title, and one ready Request's exact title | That Request, at `analyze` |
| implementation `Entry` | No id, and the opening holds one accepted architecture's exact title | That architecture |
| profile `offer` | Nothing / text / link or document alone / link alone and no retrieval | `identity.ask` / supplied material / retrieve / `identity.ask`, silent |
| governance `queue` | The queue has titles, and recommendations remain | The "select any…, or are you ready to review" question |
| onboarding `map` `unknown` | Provider `Unknown` | The "Who builds or runs" question, then a provider or `Does not exist` |
| implementation `start` `accept` | A field is Needed | Name it, re-emit the block |
