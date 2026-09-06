# Contract: Validation Output Format

The format `validate-skill.sh` writes. The test suite asserts on it, so it is a contract rather
than a presentation detail. Changing it is a breaking change to the tests.

## Finding lines

One line per violation, written to standard error, one for each violated rule occurrence.

```text
ERROR: [<RULE-ID>] <message> (<observable>)
```

- The `ERROR: ` prefix is retained from the existing validator so current expectations continue
  to hold.
- `<RULE-ID>` matches `^P[0-9]+\.[0-9]+$`, or the literal `SCHEMA` for the identity and
  frontmatter checks that predate rule-level reporting and correspond to no single rule.
- `<message>` names the offending field, section, or line number, and states the counted value
  and the limit where the rule is a threshold.
- `<observable>` is copied verbatim from the constitution's observable column for that rule.

Examples:

```text
ERROR: [P7.1] missing required body section '## Purpose' (A section titled `## Purpose` is present and contains exactly one sentence.)
ERROR: [P1.3] line 42: normative rule is 40 words, limit is 25 (Word count of the rule text is 25 or fewer.)
ERROR: [P7.4] skill declares 15 MUST-level rules, limit is 12 (Count of MUST and MUST NOT rules is 12 or fewer.)
ERROR: [SCHEMA] field 'metadata.version' ("1.0") does not match MAJOR.MINOR.PATCH
```

**Requirements met**: FR-003, FR-006.

## Coverage summary

Written to standard output after the findings, on every run, whether or not validation passed.
Lists rule IDs only, space-separated, in ascending order.

```text
CHECKED:   <rule-id> ...
FAILED:    <rule-id> ...
N/A:       <rule-id>=<condition-id> ...
DEFERRED:  <rule-id> ...
UNCHECKED: <rule-id> ...
```

- Every rule ID in the constitution appears in exactly one group.
- A group with no members is printed with an empty list rather than omitted, so absence is
  visible rather than inferred.
- `N/A` entries name the permitted not-applicable condition that applies.

**Requirements met**: FR-002, FR-004, FR-005, FR-032.

## Result line

The final line of a run.

```text
OK: skill '<id>' is valid (<n> rules checked, <m> deferred, <u> unchecked)
```

or, on failure:

```text
FAILED: skill '<id>' violates <k> rule(s)
```

The `OK: skill '<id>' is valid` prefix is preserved from the existing validator; the
parenthesised counts are appended. This keeps the existing passing-case assertion intact.

## Exit status

| Status | Meaning |
|---|---|
| `0` | No check failed. Deferred and unchecked rules may exist. |
| `1` | At least one check failed, or the skill file could not be read. |

Deferred and unchecked rules do NOT affect exit status. Enforcing 13 of 48 rules is the
intended state of this feature, so treating unverified rules as failures would make every skill
fail permanently.

**Requirements met**: FR-005.

## Stability guarantees

- Rule IDs in output are stable; they change only when the constitution retires an ID.
- Group names in the coverage summary are stable tokens and may be matched literally by tests.
- Message wording after the rule ID is NOT stable and MUST NOT be matched literally by tests.
  Tests assert on the rule ID and, where relevant, on the counted value.
