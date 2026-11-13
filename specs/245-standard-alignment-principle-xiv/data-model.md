# Data Model: Principle XIV

## Principle XIV rule

| Field | Value |
| --- | --- |
| id | P5.15, P14.1, P14.2, P14.3, P14.4 |
| rule | one sentence, one keyword, at most 25 words |
| observable | the boundaries the rule checks, with Phase 13's limits |
| tier | `[auto]` |
| clause | a specification heading, or "None (Highway pattern)", in the list under the table |
| check | `rc_check_<id with _ for .>` registered with N/A condition N4 |

Validation: `con_rules` parses each row into four fields. The inventory test requires every
`[auto]` id to be registered.

## Boundary

| Field | Value |
| --- | --- |
| number | 1 to 12 |
| rule | the one rule that holds it (see [contracts/rule-checks.md](contracts/rule-checks.md)) |
| finding | file and condition, ending `(boundary <n>)` |
| seed | the retired test's seed `<n>`, applied to a copy of `tests/fixtures/flow-skill` |

## Skill folder (what a check reads)

- `SKILL.md`: the router. Its steps, its flows table (through `flows.sh`), its step references.
- Flow files: the files the flows table names.
- Other files in `references/`: references, judged only by boundary 8.
- Sibling skill folders: read only for boundary 11 and the cache key.

## Cache key

`sha256(skill listing hash ‖ environment hash)`. The skill listing covers the skill's own files and
the `SKILL.md` and `references/*.md` of each skill its handoffs name. An empty or malformed key
means no lookup and no record. See [contracts/validation-cache.md](contracts/validation-cache.md).

## State transitions

None. A verdict is computed per run. A cache record is written once per key and never updated.
