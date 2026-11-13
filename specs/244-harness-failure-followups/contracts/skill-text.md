# Contract: Skill Text

Each line below is pinned by `tests/harness-failure-followups.test.sh`. `[Record]` and `[Records]`
are Objective/Objectives, Control/Controls, and NFR/NFRs. `[skill]` is objectives, controls, or nfrs.

## Governance `close` (FR-001)

`SKILL.md`, a new step after `review`:

```markdown
### close

When `highway-setup` delegated this skill, return `Finished`. Emit nothing else.

Otherwise emit one line and stop. When at least one [Record] is active, emit:

Your [Records] are recorded.

When no [Record] is active, emit:

No [Records] are recorded yet. Run highway-[skill] when you have one to add.
```

Also:

| File | Location | Line |
| --- | --- | --- |
| `SKILL.md` | `## Procedure` order sentence | ends with "Both paths end at `close`." |
| `SKILL.md` | `### review` | `` - `accept`: go to `close`. `` |
| `SKILL.md` | `## Outputs` | `- One closing line after review acceptance or a successful guided write, when the person ran this skill directly.` |
| `SKILL.md` | `## Verification` | `- Acceptance of that review goes to `close`.` replaces "Acceptance of that review returns `Finished` and emits nothing else." |
| `SKILL.md` | `## Verification` | `- Run by `highway-setup`, `close` returns `Finished` and emits nothing else. Run directly, it emits one closing line and no question.` |
| `references/proposal.md` | `### ask` | `` - `decline`: write the empty catalog described in `write`. Go to `close`. `` |
| `references/record.md` | `### write` | `On success, go to `close`.` replaces "On success, emit nothing. Return `Finished`." |
| `references/record.md` | `### write` | "Do not add a closing line." is removed. |
| `references/record.md` | `## Verification` | `- A successful guided write goes to `close` and does not show the stored records.` |

Rejected anywhere in the three skills' text: "Emit nothing else." outside `close`, and "On success,
emit nothing."

Versions: objectives 8.8.0, controls 8.8.0, nfrs 9.9.0.

## highway-codify-config `menu` (FR-002)

```markdown
- `decline`: when a return step is held, go to that step in its skill. Otherwise emit `Your platforms and coding standards are up to date.` Write nothing. Stop.
```

Version 3.12.0.

## highway-codify (FR-003, FR-004)

- `references/proposal.md` `### revise`: `An edit that would break a listed Control or NFR is not applied. Say: [Title] stays in effect. To change a Control, run highway-controls. To change an NFR, run highway-nfrs. Then re-emit the proposal and stay on `revise`.`
- `SKILL.md` `### Entry` step 2: `2. When the invocation is the word `catalog`, or asks to show the code catalog, go to `catalog`. Do not resume a task list or select an implementation. An invocation that names nothing is not a catalog request.`

Version 14.9.0.

## Write steps (FR-005)

- highway-discovery `references/options.md` `### write`: `- Keep every heading and table header row of `assets/discovery-record.md`, in order, even when a section has no content. Write `None` under a section with no content, after its table header row when it has one.`
- highway-adr `references/record.md` `### write`: the same line with `assets/adr-record.md`.
- highway-adr `SKILL.md` `### onboarding`: `- The record keeps every heading of a Discovery-backed ADR, as `write` says, including `## Decision Confidence`.` replaces "The record uses every section a Discovery-backed ADR uses."

Versions: discovery 5.8.0, adr 6.8.0. Templates are unchanged.
