# Data Model: Harness Failure Follow-ups

## Finding (in `harness-model-findings.md`)

| Field | Rule |
| --- | --- |
| Id | `F` plus a number. A new finding takes the next unused number after F22. |
| Section | `# Harness Failures` when the Proposed resolution is a concrete change; `# Research Harness Failures` when it needs investigation or more runs. |
| Skill, Runs, Category, Confirmed, Basis, Proposed resolution | Required for every finding. Runs name run ids. |

Transitions after the final runs (FR-020):
- In-scope, resolution applied, not seen: removed. The note at the top of `# Harness Failures` names it.
- Any finding still seen: Runs, Basis, and Proposed resolution are updated. It may move between the two sections.
- Research finding not seen: stays. One line says it was not seen in spec 244's final runs.
- New failure: added to the section that matches its Proposed resolution.

## Scenario reply

| Field | Rule |
| --- | --- |
| Key | `ask:` text or `ask-pattern:` regex. It names the question it answers. No key may match any question (no `\?`, `.`, `.*`, or `.+`). |
| Say | The person's reply, with an optional `[class]` tag. |
| Order | Matched among unused replies in file order. The fallback may offer only the earliest unused reply. |

## Expectation

| Assertion | Passes when |
| --- | --- |
| `contains` | every matching file holds the text (unchanged) |
| `contains-any` | at least one matching file holds the text (new) |

## Drive outcome and failure kind

| Outcome | Failure kind | When |
| --- | --- | --- |
| `unmatched-question` | `unmatched-question` | no reply for a question not yet answered in the attempt |
| `repeated-question` | `repeated-question` (new) | no reply for a question already answered in the attempt. The failure names the question and the spent reply. |

## Governance `close` step

| Caller | Emits | Returns |
| --- | --- | --- |
| `highway-setup` | nothing | `Finished` |
| the person | one closing line: "Your [Records] are recorded." or, with none active, "No [Records] are recorded yet. Run highway-[skill] when you have one to add." | nothing |
