# Highway

A portable skill-authoring framework. Skills are authored once and distributed to each supported
agent — GitHub Copilot, Claude Code, Cursor, and Codex — through generated copies, so skill
content is never duplicated or hand-adapted per agent.

## Layout

```text
skills/                Skill sources, one directory per skill
framework/             Validators, generators, and the rules every skill is validated against
tests/                 The bash test suite for the framework
highway-agent-plugin/  The Agent Plugins build of the skills, with each agent's manifest, generated
                       from skills/ and framework/plugin/
```

Each skill is self-contained: it reads only its own folder. Whatever it needs beyond `SKILL.md`
sits beside it in `references/`, `assets/`, or `scripts/`, named by a relative path one level
deep. `skills/highway-experience/` holds Highway's identity, the Experience Standard, and the
storage contract under `references/`. Every other Highway skill activates it as the first step of
its Procedure, so no always-on instruction file is needed. highway-help reads the generated index
of every skill from its own `assets/index.json`.

The framework is POSIX shell (`bash`, `awk`, `sed`, `grep`) only, with no network calls and no
language runtime to install.

## Authoring a skill

Create `skills/<id>/SKILL.md`, then check it and publish it to your agents:

```sh
framework/validate-skill.sh skills/<id>
framework/generate-catalog.sh
framework/generate-agent-adapters.sh
framework/generate-agent-plugin.sh
```

The validator reports one line per rule that failed, each naming the rule id that decided it. The
catalog generator refreshes highway-help's index; the adapter generator writes the per-agent
copies; the plugin generator rebuilds `highway-agent-plugin/`. Run all four after any change to a
skill.

Every generator refuses to overwrite a file or folder it did not produce, naming it rather than
replacing it. If you see that message, the file was hand-edited — move it aside if regenerating is
safe.

## The rules a skill is validated against

Skills are governed by written rules, each with a stable id, an observable condition, and a tier
saying whether it is decided automatically, by an agent, or by a human reviewer.

- `framework/constitution.md` — the rules
- `framework/authoring-standard.md` — how to satisfy them when writing a skill
- [Agent Skills specification](https://agentskills.io/specification) — the authority on skill
  format; `framework/.frontmatter-contract` declares the frontmatter fields it permits

Rule ids are stable. A retired id is never reused, so a citation stays meaningful.

## Scripts

### `framework/validate-skill.sh [--no-cache] <skill-dir>`

Validates one skill directory against `framework/constitution.md` and
`framework/authoring-standard.md`.

Rule ids, tier tags, and token lists are read from the constitution at run time. No rule content
is stored in the scripts, so amending the constitution cannot leave this tooling silently out of
date.

- **Exit 0**: no check failed.
- **Exit 1**: at least one check failed; prints one `ERROR: [<rule-id>] ...` line per violation,
  each naming the rule and the observable that decided it.

Every run also prints a coverage summary, so verified conformance is distinguishable from
unverified conformance:

```text
CHECKED:   rules a check ran for
FAILED:    rules a check ran for and rejected
N/A:       rules whose construct is absent, each naming the permitted condition
DEFERRED:  rules whose tier requires judgment; never decided automatically
UNCHECKED: machine-decidable rules with no check registered yet
```

Deferred and unchecked rules do not affect exit status. Enforcing a subset of the rules is the
intended state, so unverified must not read as failed. The output format is a contract, per
feature 003 (constitution enforcement).

Frontmatter is parsed with a strict YAML parser (`lib/yaml-frontmatter.sh`, which runs `python3`
with the PyYAML module) before any field check. A block that does not parse, a repeated key, a
field the Agent Skills specification does not define, a value that is not a string, or a value the
line readers in `lib/frontmatter.sh` read differently from the parser is an `ERROR: [SCHEMA] ...`
finding. Without `python3` and PyYAML the validator stops with
`ERROR: [SCHEMA] the YAML parser is unavailable: ...`.

#### Bundled files

The validator also checks the files a skill bundles, against the constitution's rules only, since
a bundled file emits nothing. A finding names the file, as
`ERROR: [<tag>] assets/<file>: ...` or `ERROR: [<tag>] references/<file>: ...`, and fails the
skill; the coverage summary still describes `SKILL.md`.

- A complete template in `assets/`, meaning a file with a `## File Frontmatter`, `## Body`, or
  `## Catalog Structure` heading, needs `name`, `description`, and `metadata.version`. It is exempt
  from the four checks that key on MUST/SHOULD keyword text (P1.1, P1.3, P7.4, P7.5), since its
  placeholder text can legitimately contain those words without being a rule statement.
- A file in `references/` has no frontmatter. It is exempt from the same four checks, because a
  reference such as the Experience Standard defines rules for others in table rows, and from P7.1
  and P7.2, which judge a `SKILL.md` Purpose and a frontmatter version. Its citations and the
  remaining rules are checked.
- Seeded skeletons in highway-setup's `assets/` have none of the template headings and are not
  checked this way; `tests/catalog-seeding.test.sh` compares each one with its reference copy in
  `tests/fixtures/catalog-seeding/skeletons/`.

#### Validation cache

A successful validation is recorded under `${TMPDIR:-/tmp}/highway-validation-cache` and replayed
when the same skill is validated again against the same validator. Generation re-validates the
same skills many times in one run, and the cache is what stops that work being repeated — it
takes validating all twelve skills from roughly 5.4 s to 0.44 s. Pass `--no-cache` to force full
validation.

The cache key is a hash of the skill's `SKILL.md` combined with a hash of **every validator
input**: `validate-skill.sh` itself, `.frontmatter-contract`, the constitution, the Experience
Standard, and every file under `framework/lib/`. A skill's own `assets/`
and `references/` are part of that skill's side of the key, and so is its folder name, which its
`name` must match. Where the skills folder sits is not.
Change any of them and the key changes, so a recorded verdict can never outlive the thing that
decided it. Three properties are deliberate and should be preserved by anyone editing this:

- **Only successes are recorded.** A failing skill is re-validated and re-reported every time.
- **The full report is stored and replayed**, so a cache hit is byte-identical to a full run.
  Callers parse this output; a hit must not be quieter than a miss.
- **The cache disables itself** when `CONSTITUTION_FILE`, `EXPERIENCE_FILE`, or
  `FRONTMATTER_CONTRACT_FILE` is set, because those overrides
  repoint validation at documents the key does not describe. It also disables itself if the cache
  directory would resolve inside the repository, or is not writable.

The cache is an optimisation and never a source of truth: deleting the directory changes nothing
but runtime. `tests/validation-cache.test.sh` holds the assertions, including that breaking a
previously-cached skill still fails with its original error.

### `framework/generate-catalog.sh`

Iterates `skills/*/SKILL.md`, validates each via `validate-skill.sh`, and writes highway-help's
`skills/highway-help/assets/index.json`: one entry per skill with its `id`, `name`,
`description`, `usage` (from `metadata.usage`), `version`, and `example`, which is everything highway-help
prints. Unchanged skill sources produce a byte-identical file.

- **Exit 0**: index written.
- **Exit 1**: at least one skill under `skills/` is invalid, including one whose `name` differs
  from its folder; the index is **not** written (no partial index), and the failing skill's `id`
  is named in the error output.

### `framework/generate-agent-adapters.sh`

Regenerates the per-agent copies for every valid skill under `skills/`, into
`.github/skills/<id>/SKILL.md`, `.claude/skills/<id>/SKILL.md`, `.cursor/skills/<id>/SKILL.md`,
and `.agents/skills/<id>/SKILL.md` at the repository root, per feature 009 (skill id namespace
alignment). The deliverables for one skill are byte-identical copies of the source. Every other
file in the skill's folder, such as `references/<name>.md`, is copied to the same relative path
beside each copy's `SKILL.md`.
`<id>` is already the full agent-facing identifier (e.g. `highway-help`) — this generator injects
no namespace prefix of its own.

- **Exit 0**: all adapters regenerated (or confirmed already up to date).
- **Exit 1**: any skill fails validation (no partial adapter set is written), or a target file was
  hand-edited outside this generator (refuses to overwrite, names the file).
- Never reads, writes, or removes existing `speckit-*` folders under `.github/skills/`,
  `.cursor/skills/`, or `.agents/skills/` — those are external tooling used to build this
  repository, not part of this suite. The generator removes no file at all.

### `framework/generate-agent-plugin.sh [--check]`

Builds `highway-agent-plugin/`, an [Agent Plugins](https://agent-plugins.org) 1.0.0 plugin of the
skills that each supported agent can also install from its own manifest. The folder holds:

- `plugin.json`, `README.md`, `LICENSE`, and `assets/`, copied from `framework/plugin/`;
- `skills/<id>/` for each skill under `skills/`, with every file except dotfiles;
- marketplace catalogs at `.cursor-plugin/marketplace.json`, `.claude-plugin/marketplace.json`,
  `.agents/plugins/marketplace.json`, and `.github/plugin/marketplace.json` (each lists `highway`
  with source `./`);
- one manifest per agent format, rendered from `framework/plugin/`:

| Manifest | Read by |
| --- | --- |
| `plugin.json` | Copilot, VS Code, and Kiro (Agent Plugins 1.0.0) |
| `.claude-plugin/plugin.json` | Claude Code |
| `.codex-plugin/plugin.json` | Codex |
| `.cursor-plugin/plugin.json` | Cursor |
| `.antigravity-plugin/plugin.json` | Antigravity |
| `gemini-extension.json` | Gemini CLI |

Two builds from unchanged sources are byte-identical: each manifest is written in a fixed key
order with two-space indentation. The generator owns the folder whole: each build replaces it.
Never edit a file under `highway-agent-plugin/`; change its source and rebuild.

Where each manifest field comes from:

- **Shared fields** (`name`, `version`, `description`, `author`, `homepage`, `repository`,
  `license`, `keywords`) live only in `framework/plugin/plugin.json`. Each agent manifest carries
  the ones its format accepts, with the same values: Cursor's `author` keeps only `name` and
  `email`, and `gemini-extension.json` carries only `name`, `version`, and `description`. A release
  changes `version` there, and nowhere else.
- **Agent-only fields** live in `framework/plugin/listing.json`, keyed by agent: Codex's
  `interface` block (display name, descriptions, category, capabilities, default prompts, and
  logo), Cursor's `logo`, and Antigravity's `displayName`, `logo`, and `suggestedPrompts`. The
  listing file never holds a shared field.
- **Derived fields** are rendered from a shared field: Codex's `interface.developerName` from
  `author.name`, and `interface.websiteURL` from `homepage`.
- **Format constants** are set by the generator: `"skills": "./skills/"` for Codex and Cursor, and
  Antigravity's `$schema`.
- **The logo** is `framework/plugin/assets/logo.svg`, a placeholder. Replace the file under the
  same name to replace it in every manifest.

The formats are defined once, in `framework/lib/plugin-manifest.sh`, which both this generator and
the validator read. No manifest declares hooks, MCP servers, rules, commands, agents, or a context
file.

- **Exit 0**: the plugin was written.
- **Exit 1**: `listing.json` holds a shared field, a derived field, or a field its agent does not
  read (one `ERROR: [LISTING] <agent>.<field>: <problem>` line each); a skill fails validation; or
  `highway-agent-plugin/` exists but its `plugin.json` is missing or does not name `highway`
  (refuses to overwrite, names the folder). Nothing is written.

With `--check`, it checks `listing.json` the same way, then builds into a temporary folder and
compares that with `highway-agent-plugin/` without writing in the repository. It prints one
`DRIFT<TAB><differs|missing|extra><TAB><path>` line per difference and exits 1, or exits 0 when
there is none. The harness runs it before every run, so it never tests a stale plugin.

The plugin is not part of the distribution below. To change a shared field, edit
`framework/plugin/plugin.json`; to change an agent-only field, edit `framework/plugin/listing.json`;
to change the README, license, or logo, edit the file in `framework/plugin/`. Then rebuild.

### `framework/publish-agent-plugin.sh [--dry-run]`

Publishes a fresh `highway-agent-plugin/` build as the root of
`https://github.com/highway-systems/agent-plugin` (override with `HIGHWAY_PUBLIC_REMOTE`). One-way:
the public repository is not the source of truth. Refuses to push when the staged tree differs from
the build, when contents reference `specs/` or `.specify/`, or when a simple secret scan fails.
The first publish may keep version `0.1.0` and tag `v0.1.0`. Later releases must bump
`framework/plugin/plugin.json` `version` first. `--dry-run` runs every gate and local commit/tag
step without pushing. Auth uses your git credentials for the `highway-systems` remote.

### `framework/validate-plugin.sh <plugin-dir>`

Validates a plugin folder against Agent Plugins 1.0.0, checks its agent manifests, then validates
each of its skills with `framework/validate-skill.sh`. It prints one line per finding,
`ERROR: [MANIFEST]`, `ERROR: [AGENT]`, `ERROR: [LAYOUT]`, or `ERROR: [SKILL]`, each naming the
file, field, or path, then `OK` or `FAIL` with a count.

- **Manifest**: the closed set of fields, the 1.0.0 `$schema`, the name rules, each field's type,
  the `author` sub-fields, and `extensions`, each naming its specification clause; a file that is
  not JSON or repeats a key fails.
- **Agent**: each of the five agent manifests exists and is valid JSON; holds only the keys its
  format accepts; carries each shared field its format accepts, equal to the plugin's
  `plugin.json`, and each field its format requires; has the format's constants and Codex's
  derived fields; and points its `skills` path at the plugin's skills folder and each logo path at
  an image in the plugin.
- **Layout**: no symbolic link anywhere in the folder, a `skills` entry that is a folder, and a
  `SKILL.md` in each skill folder. The folder holds only the shipped set: the six manifests,
  marketplace catalogs (`.agents/`, `.github/`, and `marketplace.json` beside Claude/Cursor
  overlays), `skills/`, `assets/`, `README.md`, and `LICENSE`; and `assets/` holds only files a
  manifest names.

- **Exit 0**: no finding.
- **Exit 1**: at least one finding.
- **Exit 2**: a usage error, or `python3` is unavailable.

### Records, templates, and seeded files

Every record has its complete template in the `assets/` of the one skill that creates it, such as
`skills/highway-request/assets/request-record.md` or `skills/highway-adr/assets/adr-record.md`.
highway-onboarding creates no record itself: it hands each provider's ADR, reference architecture,
and reference implementation to highway-adr, highway-architecture, and highway-implementation.

The organization catalogs, the findings file, and the storage record are seeded:
`skills/highway-setup/assets/` holds their skeletons, and highway-setup writes each absent one
into the project at the start of every run. Skills that write a seeded file edit it in its
existing structure and state its rules in their own text. The governance catalog templates live
in the `assets/` of highway-objectives, highway-controls, and highway-nfrs. A rule two skills share
has one source in `framework/shared-rules/`, and `tests/shared-rules.test.sh` fails when a copy
differs.

When a bundled file changes, identify every `SKILL.md` that cites it, re-run the skill validator
on each, and review the complete emitted structure. A mismatch in
frontmatter or body is reported under D8.1; transient messages are not retained file artifacts.

### `framework/generate-distribution.sh <target-directory>`

Produces the user-facing distribution from this repository, then verifies it before accepting it.
What ships is read from `framework/.distribution-manifest`, never hard-coded in the script, so the
path set has exactly one declaration. Artifacts are copied rather than regenerated. Each skill
folder ships whole in every agent tree (`.github/skills/`, `.claude/skills/`, `.cursor/skills/`,
`.agents/skills/`); the skill sources, the framework, and the test suite do not ship, except this
file, which ships as the distribution's `README.md`. The generator records what it wrote in
`.distribution-record` at the distribution's root.

Three verifications must all pass, or no distribution is produced:

1. No distributed file references a development-only location.
2. Every documentation cross-reference resolves to a path inside the distribution.
3. Every distributed skill passes `framework/validate-skill.sh` run from a verification tree: the
   distribution, plus this repository's `framework/`, with the skills copied from `.agents/skills/`
   to `skills/`. So
   the check proves the shipped skills validate using only distribution contents and the
   framework.

- **Exit 0**: distribution produced and all three verifications passed.
- **Exit 1**: a verification failed (the candidate is removed, not left in place), a repository
   path is unclassified, or the target exists and was not produced by this generator (refuses to
   overwrite, names the file).

### `tests/run-all.sh`

Discovers and runs every `*.test.sh` under `tests/`, prints a pass/fail summary, and exits
non-zero if any test fails.

## Paths helper

`framework/lib/paths.sh` is the one declaration of where every repository location lives: the
skills, highway-experience, highway-help's index, framework, tests, fixtures, harness, agent
trees, and the plugin and its sources, as `HW_*` variables, plus each output template and each framework or highway-experience
document by name. Moving a location means editing its line there and nothing else.

- Framework scripts source it directly. Tests source `tests/paths.sh` and harness scripts source
  `harness/bin/lib/paths.sh`; each shim is one `source` line.
- `hw_template <name>` and `hw_doc <name>` return one template or document. Use them rather than
  joining a file name to a folder.
- `hw_at <root> <path>` re-roots a location under a copied tree, and `hw_rel <path>` makes it
  repository-relative. Libraries take a repository root and re-root through `hw_at`, so a test
  can point them at a copy.
- `hw_paths_init [root]` resets every `HW_*` variable for another root.

`tests/path-construction.test.sh` fails when a script under `framework/`, `tests/`, or
`harness/bin/` builds a path from a root variable, climbs from its own folder, or joins a named
template or document to its folder (development constitution D2.5).

## Libraries

| File | Responsibility |
|---|---|
| `lib/paths.sh` | The paths helper described above. |
| `lib/frontmatter.sh` | Reads the YAML frontmatter block and body of a `SKILL.md` with line readers, for the generators and rule checks. |
| `lib/yaml-frontmatter.sh` | Parses a `SKILL.md` frontmatter block with a strict YAML parser (`python3` with PyYAML). |
| `lib/plugin-manifest.sh` | Checks a `plugin.json` against the Agent Plugins 1.0.0 manifest rules; defines the agent manifest formats, renders the agent manifests from `plugin.json` and `listing.json`, and checks them and the plugin's closed list. It reads every file with `python3`'s standard-library `json` module and rejects a repeated key. |
| `lib/frontmatter-contract.sh` | Reads the permitted frontmatter keys and value constraints from `.frontmatter-contract`. |
| `lib/constitution.sh` | Parses the rule inventory, rule fields, and token lists from the constitution. |
| `lib/body-scan.sh` | Annotates each body line with its section, fenced-block state, and list membership, so no check parses Markdown for itself. |
| `lib/rule-checks.sh` | One check per enforceable rule, the rule-id-to-check registry, and the bundled-file rule-exemption lists. |
| `lib/schema-validate.sh` | Identity and frontmatter checks over the parsed frontmatter (fields, types, lengths, agreement with the line readers), plus the eight required body sections, for a skill. |
| `lib/library-schema.sh` | Minimal frontmatter shape checks (`name`, `description`) for a complete template a skill bundles. |
| `lib/distribution.sh` | Classifies a repository path as included in or excluded from the user-facing distribution, and maps it to its destination, by reading `.distribution-manifest`. |
| `lib/validation-cache.sh` | Content-addressed record of successful skill validations, keyed on the skill plus every validator input. |

## Adding a new agent

Adding a 4th (or Nth) agent requires **only** a change to `framework/generate-agent-adapters.sh`'s
declarative agent config table — never an edit to any file under `skills/`. See feature 009 (skill
id namespace alignment) for the full contract. Procedure:

1. Declare the agent's skills tree in `framework/lib/paths.sh` as an `HW_AGENT_*` variable, then
   add one entry to each of the `AGENT_IDS` / `AGENT_TARGET_TEMPLATES` / `AGENT_TRANSFORMS` arrays
   in `framework/generate-agent-adapters.sh` (agent id, target path pattern built with `hw_rel`
   from that variable, transform name).
2. If the new agent needs a transform other than `identity-copy`, implement that transform as a
   new function in the script's transform-dispatch section (mirroring `mdc-transform`).
3. Run `framework/generate-agent-adapters.sh` and confirm the new target path is produced
   correctly for every existing skill, with zero diff under `skills/`.
4. No existing skill file changes. If any were required, that is a bug in the new transform, not
   an expected part of this procedure.

## Requirements

Bash and standard command-line utilities, as shipped with macOS and Linux, plus `python3` with the
PyYAML module (`python3 -c 'import yaml'` exits 0). The skill validator uses it only to parse
skill frontmatter strictly, and the plugin generator and validator only to read, render, and check
the plugin's JSON manifests. No package
manager and no network access. The skills themselves need none of
this: the framework does not ship.
