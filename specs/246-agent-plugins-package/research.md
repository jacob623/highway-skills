# Research: Agent Plugins Package

Each decision below resolves an unknown from the spec or the plan's Technical Context. Evidence
comes from the Agent Plugins 1.0.0 specification (https://agent-plugins.org), the installed
`@github/copilot-sdk` 1.0.30 type definitions, and a probe run on 2026-11-13 with the harness token
against a throwaway Copilot home. The probe script was removed after the run.

## R1. How the harness installs the plugin the way a person would

**Decision**: each attempt starts its `CopilotClient` with `baseDirectory` set to the attempt's own
temporary Copilot home (the harness already does this), then calls
`client.rpc.plugins.install({ source: <absolute path of highway-agent-plugin/> })` before it
creates the session. That RPC is the one behind `copilot plugin install <source>`; it accepts a
marketplace spec, `owner/repo`, a URL, or a local path.

**Probe result**: the install returned `skillsInstalled: 16`, the plugin `highway` enabled, and no
manifest `warnings`. `skills.discover` then listed all 16 Highway skills with source `plugin`, at
`<home>/installed-plugins/_direct/highway-agent-plugin-<hash>/skills/<name>/SKILL.md`. The home
held only `config.json`, `installed-plugins/`, and `settings.json`; nothing was written to
`~/.copilot`.

**Notice**: the install returned a `deprecationWarning`: direct installs (repositories, URLs, local
paths) are deprecated in favour of `plugin@marketplace` installs. It is not an error today. The
harness records it in the attempt transcript as a `system` entry. A marketplace manifest belongs
to publishing (Phase 18), so this spec does not add one.

**Alternatives considered**:

- `SessionConfig.pluginDirectories`: loads an Open Plugins folder for one session without
  installing it. Rejected: it is not how a person gets the plugin, which the spec requires.
- `builtinPluginDirectories` on the client: trusted host-bundled plugins. Rejected for the same
  reason.
- Copying `skills/` into `.github/skills/` (today's harness). Rejected by FR-013.

## R2. The harness model

**Decision**: the harness stays on `gpt-5.6-luna` for scenario sessions, the judge, and the reply
fallback (spec Clarifications). `harness/harness.config.json` does not change.

**Probe result**: `listModels()` for the harness token returned `auto`, `claude-sonnet-5.5`,
`claude-sonnet-5`, `claude-haiku-5.5`, `claude-haiku-4.5`, `gpt-6.1-terra`, `gpt-6-luna`,
`gpt-5.6-terra`, `gpt-5.6-luna`, `gpt-5.3-codex`, `mai-code-1.1-flash`, `grok-4.7`, `grok-4.6`,
`kimi-k3`. No Gemini model is offered, so the Gemini 3.8 Flash change is deferred.

## R3. What Agent Plugins 1.0.0 requires of the manifest and layout

**Decision**: `framework/validate-plugin.sh` checks these clauses, each named in its finding:

| Clause | Check |
| --- | --- |
| §5.1 | `plugin.json` exists at the plugin root and is a regular file |
| §5.2 | the file is JSON with one top-level object and no repeated key |
| §5.2 | top-level fields are only `$schema`, `name`, `version`, `description`, `author`, `homepage`, `repository`, `license`, `keywords`, `extensions` |
| §5.2 | `$schema` is `https://agent-plugins.org/schemas/1.0.0/plugin.schema.json` |
| §5.3, §5.5 | `name` is a string of 1 to 64 characters from `a-z`, `0-9`, `-`, `.`, starting and ending alphanumeric, with no `--` or `..` |
| §5.4 | `version`, `description`, `homepage`, `repository`, `license` are strings; `keywords` is a list of strings; `author` is an object with only `name`, `email`, `url` strings |
| §8.1 | `extensions`, if present, is an object whose values are objects |
| §4.1 | no path in the plugin is a symbolic link, so nothing resolves outside the plugin root |
| §6.1, §6.2 | `skills`, if present, is a directory; `mcp.json`, if present, is a regular file |
| §7.1 | each immediate child of `skills/` is a directory holding a regular-file `SKILL.md`, and passes `framework/validate-skill.sh` |

An unknown top-level field is non-fatal to a client (§5.2), but it does not conform to the
schema, so the validator fails on it. The validator reports every finding, not just the first.

**Alternatives considered**: validating against the published JSON Schema. Rejected: clients must
not fetch schemas while loading, the toolchain has no JSON Schema validator, and the specification
text is authoritative over the schema.

## R4. Parsing JSON in the bash framework

**Decision**: `framework/lib/plugin-manifest.sh` parses `plugin.json` with `python3` and its
standard-library `json` module, the way `lib/yaml-frontmatter.sh` parses frontmatter. It rejects
repeated keys with `object_pairs_hook`. The Development Constitution's Declared Toolchain note
names `python3` as invoked only by `lib/yaml-frontmatter.sh`, so it is amended (R10) to name this
library too. No new interpreter or module is added (D2.4): `json` is part of Python.

**Alternatives considered**: an awk JSON reader. Rejected: a strict parser that rejects malformed
JSON and repeated keys is several hundred lines of awk, and a lenient one would pass a manifest a
client rejects.

## R5. How the generator owns the plugin folder

**Decision**: `framework/generate-agent-plugin.sh` owns `highway-agent-plugin/` whole. It
validates every skill first and writes nothing if one fails (the other generators do the same). It
then builds the plugin into a temporary folder beside the target and replaces the target with it.
It refuses (D4.3) when the target exists and is not a plugin folder it produced, meaning its
`plugin.json` is missing or does not name `highway`, and names the folder.

The plugin holds no manifest of hashes, because the shipped set is fixed and nothing else may be
in it (FR-011). Hand edits inside the folder are caught by the drift check (R6) before a
regeneration replaces them, which is the D4.1 Observable: re-running the generator produces no
diff.

**Alternatives considered**: per-file hash rows like `.adapter-manifest`. Rejected: it needs a
file outside the plugin to track a folder that is replaced whole, and a removed skill or bundled
file would then be refused rather than removed.

## R6. One drift check for the suite and the harness

**Decision**: `generate-agent-plugin.sh --check` builds into a temporary folder and compares it
with the committed `highway-agent-plugin/`, printing one line per differing, missing, or extra
file and exiting 1 if any. The suite (`tests/agent-plugin.test.sh`) and the harness both call it,
so there is one definition of a stale plugin. `--check` skips skill validation, which FR-009
covers separately, so the harness can run it at the start of every run.

## R7. Reads inside the installed plugin

**Decision**: the harness permission policy allows a `read` whose path is inside the attempt's
`<home>/installed-plugins/`, in addition to the project. A write there stays an `outside-write`
and stays fatal. Without this, a skill's `references/` and `assets/` reads, which used to sit in
the project's `.github/skills/`, would be rejected.

## R8. Keeping the plugin out of the distribution

**Decision**: `framework/.distribution-manifest` gains `exclude	highway-agent-plugin	-`. A path
matching no row is unclassified and fails packaging, so the row is required. `framework/plugin/`
is already excluded by the `framework` row.

## R9. The license text

**Decision**: `framework/plugin/LICENSE` is the canonical Apache License 2.0 text from
`https://www.apache.org/licenses/LICENSE-2.0.txt` (202 lines, SHA-256
`cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30`). Every skill declares
`license: Apache-2.0`.

## R10. Development Constitution amendment

**Decision**: 3.5.0 → 3.6.0 (MINOR). Changed elements:

- Declared generators: `generate-agent-plugin.sh` is added. Its output is produced in the same
  change, so D4.7 still passes.
- Declared Toolchain note: `python3` is also invoked by `framework/lib/plugin-manifest.sh`, with the
  standard-library `json` module.
- Enforcement Map, D4.7 note: the regeneration includes `generate-agent-plugin.sh` and compares
  `highway-agent-plugin/`.
- Version line and Last Amended date.

No obligation is removed or strengthened, and no conforming work fails. The amendment records a
Sync Impact Report with a D1.3, D1.4, and D5.3 review.

**Alternatives considered**: leaving the generator undeclared. Rejected: D4.7 names its scope by
the declared list, and an undeclared generator's output would have no currency rule.

## R11. Harness path map and project build

**Decision**: `harness/bin/path-map.sh --location` replaces `agent-skills` with `plugin`, which
prints `highway-agent-plugin`. The harness's base project becomes an empty folder; the plugin
reaches the agent only through the install. A changed path under `highway-agent-plugin/` selects
nothing, since its source under `skills/` already selects the skill's scenarios.

## R12. Telling a load failure from a behavior failure

**Decision**: a new failure kind, `plugin-install`, covers an install that throws, installs fewer
skills than the plugin holds, reports manifest warnings, or leaves the plugin disabled after an
enable. The attempt ends before the session starts. A rejected read inside the installed plugin
is also a load failure. Every other failure is a skill-behavior failure under FR-019.
