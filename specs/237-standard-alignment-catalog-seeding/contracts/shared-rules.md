# Contract: shared rules

## Source format

One file per rule under `framework/shared-rules/`:

```text
skills: <skill> <skill>
rule: <the exact line each skill holds>
```

## Rules

`framework/shared-rules/capability-title.txt`

```text
skills: highway-architecture highway-implementation
rule: Capability title rule: a capability title is one noun phrase of five words or fewer. A hyphenated word counts as one word. Modifiers can precede the noun. A title does not contain `and`, `or`, `&`, `/`, `+`, or a comma. A title that joins two things is two capabilities, one per part. Each part keeps its own words and repeats a shared noun when there is one.
```

`framework/shared-rules/adr-id-cell.txt`

```text
skills: highway-architecture highway-adr
rule: ADR ID cell rule: the architecture catalog ADR ID cell lists every current decision that names the architecture, in id order, separated by a comma and a space. One id is used when only one current decision names it. A superseded or removed decision is not in that cell. An ADR id appears on at most one row. A decision whose ADR catalog Architecture ID cell lists several architectures is the exception: it appears on the row of each architecture it names.
```

Elsewhere, each skill refers to "the capability title rule" or "the ADR ID cell rule" by name.

## Test

`tests/shared-rules.test.sh`:

- reads each source and fails when it lacks exactly one `skills:` and one `rule:` line;
- fails, naming the skill and the rule, when a named skill does not hold the `rule:` text as a whole line;
- seeds a probe: a copy of a skill with one word of the rule changed fails.

highway-codify-config does not state the capability title rule and does not name a capability template.
