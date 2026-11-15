# Contract: Generator and Validator Checks

## Generator listing check (`framework/generate-agent-plugin.sh`)

Runs before anything is written, in build mode and in `--check` mode. One line per finding:

```text
ERROR: [LISTING] <agent>[.<field>...]: <problem>
```

| Defect | Finding |
| --- | --- |
| `listing.json` missing, not JSON, or repeating a key | `ERROR: [LISTING] listing.json: <problem>` |
| An agent key other than `codex`, `cursor`, `antigravity` | `ERROR: [LISTING] <key>: is not an agent with listing fields` |
| A shared field in an entry | `ERROR: [LISTING] <agent>.<field>: is a shared field; keep it in plugin.json` |
| A derived Codex field | `ERROR: [LISTING] codex.interface.<field>: is derived from <source>; remove it` |
| A field the agent's format does not allow | `ERROR: [LISTING] <agent>.<field>: is not a listing field for <agent>` |
| A value of the wrong type, or more than 3 suggested prompts | `ERROR: [LISTING] <agent>.<field>: must be <type>` |

Exit 1 with nothing written. In `--check` mode the findings are printed in place of drift lines,
then the exit is 1.

## Drift check (`--check`)

Unchanged in form: `DRIFT<TAB><differs|missing|extra><TAB><path>`. The fresh build now includes
the five agent manifests and `assets/`, so a hand-edited manifest reports
`DRIFT	differs	.codex-plugin/plugin.json`.

## Validator findings (`framework/validate-plugin.sh <plugin-dir>`)

Order: `[MANIFEST]`, then `[AGENT]`, then `[LAYOUT]`, then `[SKILL]`.

```text
ERROR: [AGENT] <manifest path>: <field or "file">: <problem>
```

| Defect | Finding |
| --- | --- |
| A manifest missing | `[AGENT] <path>: is missing` |
| Not JSON, a repeated key, or not one object | `[AGENT] <path>: <problem>` |
| A key the format does not accept (FR-009 keys included) | `[AGENT] <path>: <key>: is not accepted in this manifest` |
| A required field missing (a shared key the root holds and the format accepts; Codex `interface.displayName`, `shortDescription`, `developerName`, `category`; Antigravity `name`) | `[AGENT] <path>: <field>: is required` |
| A shared field different from the root `plugin.json` | `[AGENT] <path>: <field>: must equal plugin.json's <field>` |
| A wrong constant (`$schema`, `skills`) | `[AGENT] <path>: <key>: must be <value>` |
| A derived Codex field different from its source | `[AGENT] <path>: interface.<field>: must equal plugin.json's <source>` |
| A skills path that does not lead to the plugin's skills folder | `[AGENT] <path>: skills: must lead to the plugin's skills folder (./skills/)` |
| A logo path that is absolute, climbs, has an unaccepted extension, or names no file | `[AGENT] <path>: <field>: <problem>` |
| Antigravity `name` outside `^[a-zA-Z0-9_-]+$`, or more than 3 suggested prompts | `[AGENT] <path>: <field>: <problem>` |

Closed list:

| Defect | Finding |
| --- | --- |
| A top-level entry outside the shipped set | `[LAYOUT] <entry>: is not in the shipped set` |
| An entry in a `.<agent>-plugin/` folder other than `plugin.json` | `[LAYOUT] <path>: is not in the shipped set` |
| A file in `assets/` no manifest names | `[LAYOUT] assets/<file>: is not named by any manifest` |

When the root `plugin.json` is missing or invalid, it is reported once under `[MANIFEST]`, and
shared-field comparisons are skipped.

## Test cases (`tests/agent-plugin.test.sh`)

New: the shipped set includes the manifests and `assets`; each manifest's shared fields equal the
source; two builds are byte-identical (existing); a changed shared field (description) reaches
all six manifests and no other file; a hand-edited manifest drifts; a listing field repeating a
shared field and a derived field each stop the build; an unlisted top-level file, an extra file in
an agent folder, and an unnamed asset fail validation; a missing required field, a shared field
that differs, a wrong skills path, a missing logo, and a forbidden key each fail validation.

Changed (D3.5): the shipped-set assertion (superseded set: `LICENSE README.md plugin.json
skills`); the copy check now covers `assets/logo.svg`; the `author` and `keywords` seeds edit the
existing fields, since inserting a second key now reports a repeated key.
