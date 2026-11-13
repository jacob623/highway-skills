# Data Model: Agent Plugins Package

## Plugin folder: `highway-agent-plugin/`

The shipped set is exactly these four entries. Any other entry fails the suite (FR-011).

| Entry | Source | Rule |
| --- | --- | --- |
| `plugin.json` | `framework/plugin/plugin.json` | Byte copy, validated per [validate-plugin](contracts/validate-plugin.md) |
| `skills/<name>/` | `skills/<name>/`, for each folder holding `SKILL.md` | Every file except dotfiles, byte copy, same relative path |
| `README.md` | `framework/plugin/README.md` | Byte copy; names every skill in `skills/` |
| `LICENSE` | `framework/plugin/LICENSE` | Byte copy; Apache License 2.0 |

Lifecycle:

1. Absent.
2. Built by `generate-agent-plugin.sh`.
3. Committed.
4. When a source changes, the folder is stale. `--check` lists the stale files and exits 1.
5. Regenerated, which brings the folder back to current.

## Plugin manifest: `plugin.json`

```json
{
  "$schema": "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json",
  "name": "highway",
  "version": "0.1.0",
  "description": "<one sentence: what Highway is and what its skills do>",
  "homepage": "https://github.com/jacob623/highway-skills",
  "repository": "https://github.com/jacob623/highway-skills",
  "license": "Apache-2.0"
}
```

| Field | Required | Rule |
| --- | --- | --- |
| `$schema` | yes | The canonical 1.0.0 identifier |
| `name` | yes | `highway`, which meets the name constraints in §5.5 |
| `version` | Highway: yes | `0.1.0`; Phase 18 bumps it |
| `description` | Highway: yes | A non-empty string |
| `homepage`, `repository` | Highway: yes | The public repository URL |
| `license` | Highway: yes | `Apache-2.0` |

No other field is used. `author`, `keywords`, and `extensions` are permitted by the specification
and validated if present.

## Plugin skill

A plugin skill is `highway-agent-plugin/skills/<name>/`, identical to `skills/<name>/`. It must
hold a regular-file `SKILL.md`, and it must pass `framework/validate-skill.sh` when validated in
place. Validating in place means its handoffs resolve against the other plugin skills.

## Drift line (output of `--check`)

`DRIFT<TAB><kind><TAB><path relative to highway-agent-plugin/>`. The kind is one of:

- `differs`: the file is in both the plugin and a fresh build, with different bytes;
- `missing`: a fresh build has the file and the plugin does not;
- `extra`: the plugin has the file and a fresh build does not. This covers anything outside the
  shipped set.

## Attempt agent home

`<workRoot>/homes/<scenario>-<attempt>-XXXXXX/`. The SDK sets `COPILOT_HOME` to this folder
through `baseDirectory`. The runtime fills it with `config.json`, `settings.json`, and
`installed-plugins/_direct/highway-agent-plugin-<hash>/`. The runner removes it when the attempt
ends.

| Path | Agent may read | Agent may write |
| --- | --- | --- |
| The project | yes | yes, within the scenario's `writes:` |
| `<home>/installed-plugins/**` | yes | no: an outside write, which is fatal |
| Anything else | no | no |

## Install outcome (one per attempt)

| Field | Source | Load failure when |
| --- | --- | --- |
| `skillsInstalled` | `PluginInstallResult.skillsInstalled` | It is not the number of skills in `highway-agent-plugin/skills/` |
| `warnings` | `PluginInstallResult.warnings` | It is present and not empty |
| `enabled` | `PluginInstallResult.plugin.enabled`, after `plugins.enable` if false | It is still false |
| `deprecationWarning` | `PluginInstallResult.deprecationWarning` | Never: it is logged as a `system` transcript entry |

## Finding (`harness-model-findings.md`)

The fields are as in the existing entries: `## F<n>: <title>`, then **Skill**, **Runs**,
**Category** (Skill, Scenario, Harness, Model, or Service), **Confirmed**, **Basis**, and
**Proposed resolution**. New ids start at F26. A Runs line for this spec reads
``- Plugin install smoke (GPT-5.6 Luna) `<run id>`: <scenario> (<attempts>)``.
