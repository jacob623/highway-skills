# Phase 1 Data Model: Mechanical Enforcement of the Constitution

No database and no persisted state. The entities below are in-memory structures passed between
the tooling's stages, plus the enforcement map that binds rule IDs to checks.

## Entities

### Rule

Parsed from a constitution rule table row. The tooling never stores rule text of its own.

| Field | Source | Notes |
|---|---|---|
| `id` | column 1 | Matches `^P[0-9]+\.[0-9]+$`. Stable across amendments; never reused. |
| `text` | column 2 | Carried for reporting only. Never interpreted. |
| `observable` | column 3 | Carried for reporting only. Shown alongside a failure. |
| `tier` | column 4 | One of `auto`, `agent-checkable`, `human-review`. |

**Validation rule**: the parse MUST return every row of every rule table. A test asserts the
count matches the constitution, so a table format change fails loudly rather than silently
shrinking the inventory.

### Tier

Determines how a rule is handled, not whether it is obligatory.

| Value | Handling |
|---|---|
| `auto` | Eligible for a registered check. If none is registered, reported as unchecked. |
| `agent-checkable` | Reported as deferred. Never given an automated outcome. |
| `human-review` | Reported as deferred. Never given an automated outcome. |

### Rule Outcome

What validation reports for one rule against one skill. Disjoint: exactly one applies.

| Outcome | Meaning | Affects exit status |
|---|---|---|
| `pass` | A registered check ran and found no violation. | No |
| `fail` | A registered check ran and found a violation. | Yes |
| `not-applicable` | A registered check ran; the construct it examines is absent. Names the condition. | No |
| `deferred` | Tier requires judgment. | No |
| `unchecked` | Tier is `auto` but no check is registered. | No |

### Annotated Body Line

Emitted once per line by the body scanner; consumed by every content-level check.

| Field | Meaning |
|---|---|
| `line_no` | 1-based line number within the skill file, used in reported evidence. |
| `section` | Title of the nearest preceding `##` heading, or empty before the first. |
| `in_fence` | True inside a fenced code block, including the fence lines. |
| `is_list_item` | True for a bullet or ordered list item. |
| `is_ordered_item` | True only for an ordered list item. |
| `text` | The raw line. |

**Validation rule**: `in_fence` MUST be tracked as running state across lines. No check may
determine fence membership from a single line in isolation.

### Check Registry Entry

Binds one rule ID to the function that decides it.

| Field | Meaning |
|---|---|
| `rule_id` | The rule this entry decides. |
| `check_fn` | Function name. Returns pass, fail, or not-applicable, and emits findings. |
| `na_condition` | The permitted not-applicable condition this check cites when the construct is absent. Empty for checks that always apply. |

**Validation rule**: every registry entry's `rule_id` MUST exist in the parsed inventory. An
entry naming an unknown rule ID is an error, not a warning — it means the tooling is checking
something the constitution no longer defines.

### Token List

A prohibited-word list read from the constitution.

| Field | Meaning |
|---|---|
| `name` | Which list, for reporting. |
| `tokens` | Words parsed from the constitution's list block. |
| `excluded_sections` | Sections where occurrences do not count, as stated by the constitution itself. |

**Validation rule**: exclusions MUST come from the constitution's own wording, not from the
tooling. Currently: the list block itself, and the Illustrative Examples section.

## Enforcement Map

The 13 enforceable rules, their check basis, and their group. Group A has no external
dependency; Group B waits for constitution amendment 2.0.2.

| Rule | What the check examines | Not-applicable when | Group | State |
|---|---|---|---|---|
| P7.2 | Frontmatter version matches `MAJOR.MINOR.PATCH`. | — | A | Already implemented |
| P8.3 | A `## Verification` section is present and non-empty. | — | A | Already implemented |
| P7.1 | A `## Purpose` section is present and holds exactly one sentence. | — | A | New |
| P1.1 | Each normative line carries exactly one keyword. `MUST-level` excluded. | — | A | New |
| P1.3 | Each normative line is 25 words or fewer. | — | A | New |
| P7.4 | Count of MUST and MUST NOT lines is 12 or fewer. | — | A | New |
| P7.5 | Each normative section is 400 words or fewer. | Skill has no normative section | A | New |
| P3.5 | Each citation matches the Citation Format and resolves to AS-1 through AS-6. | Skill contains no citation | A | New |
| P5.3 | A numeral follows each retry instruction. | Skill names no retry | A | New |
| P8.1 | Ordered list items are sequentially numbered. | Skill contains no ordered list | A | New |
| P5.2 | Each list item in Error Handling names one of the four permitted next actions. | Error Handling contains no list | A | New |
| P4.2 | Verification section contains none of the three prohibited claim words. | — | A | New |
| P6.4 | Skill contains no token from the time/randomness/preference list. | — | B | Blocked on 2.0.2 |

Rules outside this table are reported as deferred (tier requires judgment) or unchecked (tier
is `auto` with no registered check). Both are visible in output and neither fails validation.

## Relationships

```text
constitution.md
   │  parsed by constitution.sh
   ├──> Rule[]        ──┐
   └──> Token List[]    │
                        ├──> compared against ──> Check Registry Entry[]
skill SKILL.md          │                              │
   │  parsed by         │                              │ each check consumes
   └──> Annotated Body Line[] ───────────────────────> ┘
                                                       │
                                                       └──> Rule Outcome[] ──> report + exit status
```

The one-directional flow matters: nothing reads the tooling to learn what a rule says. The
constitution is the only source of rule content, and the skill is the only source of the
content being judged.
