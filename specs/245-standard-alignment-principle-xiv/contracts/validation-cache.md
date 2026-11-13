# Contract: validation cache key (`framework/lib/validation-cache.sh`)

## Inputs a key covers

1. The skill's `SKILL.md`, and every file under its `assets/` and `references/`, by path relative to
   the skills folder and by content.
2. For each distinct `` in `highway-<name>` `` in the skill's `SKILL.md` or `references/*.md`, other
   than the skill itself: that skill's `SKILL.md` and every file in its `references/`, when they
   exist. Today that is highway-architecture (naming highway-implementation) and highway-onboarding
   (naming highway-adr, highway-architecture, and highway-implementation).
4. A listed path that names no file is skipped, as before; a file that exists and cannot be hashed
   fails the key.
3. The environment hash: `validate-skill.sh`, `.frontmatter-contract`, both constitutions the
   validator reads, and every file under `framework/lib/`.

## Fail closed

| Condition | `vc_key` prints | Validator |
| --- | --- | --- |
| Every hash computed, key is 64 lowercase hex characters | the key | looks up, and records on a miss |
| The hasher exits non-zero, prints fewer lines than paths, or prints nothing | nothing | validates in full, replays nothing, records nothing |
| The environment hash cannot be computed | nothing | as above; the failure is not memoised |

`vc_hash_list` passes paths to the hasher as arguments, with no `xargs`.

## Tests (`tests/validation-cache.test.sh`)

| Case | Asserts |
| --- | --- |
| VC-12: two skills, one after the other | each report names its own skill |
| VC-13: `xargs` fails | the invalid fixture still fails after the valid one is cached |
| VC-14: hasher fails | the output equals a `--no-cache` run, and no key is recorded |
| VC-15: a cross-skill target step is renamed | the skill holding the handoff fails P14.4 on the next cached run |

VC-1 to VC-11 exist and are unchanged.
