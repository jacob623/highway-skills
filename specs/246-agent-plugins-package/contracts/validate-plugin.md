# Contract: `framework/validate-plugin.sh <plugin-dir>`

Validates one plugin folder against Agent Plugins 1.0.0, then validates each of its skills against
Agent Skills through `framework/validate-skill.sh`.

## Output

One line per finding, in this order: manifest, layout, then skills.

```text
ERROR: [MANIFEST] <field or file>: <what is wrong> (Agent Plugins §<clause>)
ERROR: [LAYOUT] <relative path>: <what is wrong> (Agent Plugins §<clause>)
ERROR: [SKILL] skills/<name>: <first validator ERROR line>
```

After the findings comes a summary line: `OK: <plugin-dir> (<n> skill(s))` when there are none, or
`FAIL: <plugin-dir> (<k> finding(s))`.

## Exit codes

- `0`: no finding.
- `1`: at least one finding.
- `2`: a usage error, or `python3` is unavailable. In the second case it prints
  `ERROR: [MANIFEST] the JSON parser is unavailable: framework/validate-plugin.sh needs python3`.

## Manifest checks (`lib/plugin-manifest.sh`)

The checks are listed in research R3. Each one names the field: `$schema`, `name`, a metadata
field, an `author` sub-field, `extensions`, or `<unknown field>` for a field outside the permitted
set. A file that is not JSON, or that repeats a key, yields one `plugin.json` finding.

## Layout checks

- There are no symbolic links anywhere in the folder (§4.1).
- `skills`, if present, is a directory; `mcp.json`, if present, is a regular file (§6.2).
- Each immediate child of `skills/` is a directory holding a regular-file `SKILL.md` (§7.1).

## Skill checks

`framework/validate-skill.sh <plugin-dir>/skills/<name>` runs for every skill. A non-zero exit is
reported as one `[SKILL]` finding, giving the first `ERROR:` line of the validator's output.
