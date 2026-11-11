# Highway

A portable skill-authoring framework. Skills are authored once and distributed to each supported
agent — GitHub Copilot, Claude Code, Cursor, and Codex — through generated copies, so skill
content is never duplicated or hand-adapted per agent.

## Layout

```text
skills/            Skill sources, one directory per skill
framework/         Validators, generators, and the rules every skill is validated against
tests/             The bash test suite for the framework
.highway/
├── library/       Shared reference material skills draw on
└── catalog/       The generated index of available skills
```

`skills/highway-experience/` holds Highway's identity, the Experience Standard, and the storage
contract under `references/`. Every other Highway skill activates it as the first step of its
Procedure, so no always-on instruction file is needed.

The framework is POSIX shell (`bash`, `awk`, `sed`, `grep`) only, with no network calls and no
language runtime to install.

## Authoring a skill

Create `skills/<id>/SKILL.md`, then check it and publish it to your agents:

```sh
framework/validate-skill.sh skills/<id>
framework/generate-catalog.sh
framework/generate-agent-adapters.sh
```

The validator reports one line per rule that failed, each naming the rule id that decided it. The
catalog generator refreshes the index; the adapter generator writes the per-agent copies. Run all
three after any change to a skill.

Both generators refuse to overwrite a file they did not produce, naming it rather than replacing
it. If you see that message, the file was hand-edited — move it aside if regenerating is safe.

## The rules a skill is validated against

Skills are governed by written rules, each with a stable id, an observable condition, and a tier
saying whether it is decided automatically, by an agent, or by a human reviewer.

- `framework/constitution.md` — the rules
- `framework/authoring-standard.md` — how to satisfy them when writing a skill
- `framework/frontmatter-lexicon.txt` — the closed word list for frontmatter descriptions

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

Also checks every `metadata.dependencies` entry against `.highway/library/` (see
`framework/validate-library.sh` below): a missing path or a stale pinned version is reported as an
`ERROR: [DEPENDENCY] ...` finding, per feature 004 (shared content library).

#### Validation cache

A successful validation is recorded under `${TMPDIR:-/tmp}/highway-validation-cache` and replayed
when the same skill is validated again against the same validator. Generation re-validates the
same skills many times in one run, and the cache is what stops that work being repeated — it
takes validating all twelve skills from roughly 5.4 s to 0.44 s. Pass `--no-cache` to force full
validation.

The cache key is a hash of the skill's `SKILL.md` combined with a hash of **every validator
input**: `validate-skill.sh` itself, `.frontmatter-contract`, the constitution, the frontmatter
lexicon, the Experience Standard, and every file under `framework/lib/` and `.highway/library/`.
Change any of them and the key changes, so a recorded verdict can never outlive the thing that
decided it. Three properties are deliberate and should be preserved by anyone editing this:

- **Only successes are recorded.** A failing skill is re-validated and re-reported every time.
- **The full report is stored and replayed**, so a cache hit is byte-identical to a full run.
  Callers parse this output; a hit must not be quieter than a miss.
- **The cache disables itself** when `CONSTITUTION_FILE`, `EXPERIENCE_FILE`,
  `FRONTMATTER_CONTRACT_FILE` or `FRONTMATTER_LEXICON_FILE` is set, because those overrides
  repoint validation at documents the key does not describe. It also disables itself if the cache
  directory would resolve inside the repository, or is not writable.

The cache is an optimisation and never a source of truth: deleting the directory changes nothing
but runtime. `tests/validation-cache.test.sh` holds the assertions, including that breaking a
previously-cached skill still fails with its original error.

### `framework/generate-catalog.sh`

Iterates `skills/*/SKILL.md`, validates each via `validate-skill.sh`, and writes
`.highway/catalog/index.json`. Unchanged skill sources produce a byte-identical file.

- **Exit 0**: catalog written.
- **Exit 1**: at least one skill under `skills/` is invalid; the catalog is **not** written (no
  partial catalog), and the failing skill's `id` is named in the error output.

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

### `framework/validate-library.sh <library-file>`

Validates one shared library file (template or knowledge) under `.highway/library/`, the same way
`validate-skill.sh` validates a skill: minimal frontmatter (`name`, `description`,
`metadata.version`) plus the constitution's rule-content checks. A template file is exempt from
the four checks that key on MUST/SHOULD keyword text (P1.1, P1.3, P7.4, P7.5), reported N/A rather
than skipped, since a template's placeholder text can legitimately contain those words without
being a rule statement.

- **Exit 0**: no check failed.
- **Exit 1**: at least one check failed, or the file is not located under
  `library/templates/`, `library/knowledge/`, or `library/governance/` (tagged
  `[LIBRARY-TYPE]`).

Output format is a contract, per feature 005 (rename content to library).

Complete skeletons for retained files emitted by skills live under
`.highway/library/templates/output/`. Each skeleton covers the emitted file's frontmatter and
body. Request-producing skills use the shared request skeletons at
`.highway/library/templates/output/request-record.md` and
`.highway/library/templates/output/request-catalog.md`; every skill that cites either must be
revalidated when it changes.

When a shared library artifact changes, identify every `SKILL.md` that cites it, re-run the
affected skill and library validators, and review the complete emitted structure. A mismatch in
frontmatter or body is reported under D8.1; transient messages are not retained file artifacts.

### `framework/generate-distribution.sh <target-directory>`

Produces the user-facing distribution from this repository, then verifies it before accepting it.
What ships is read from `framework/.distribution-manifest`, never hard-coded in the script, so the
path set has exactly one declaration. Artifacts are copied rather than regenerated. Skills ship
under `.highway/skills/`; the framework and the test suite do not ship, except this file, which
ships as the distribution's `README.md`.

Three verifications must all pass, or no distribution is produced:

1. No distributed file references a development-only location.
2. Every documentation cross-reference resolves to a path inside the distribution.
3. Every distributed skill passes `framework/validate-skill.sh` run from a verification tree: the
   distribution, plus this repository's `framework/`, with the skills moved back to `skills/`. So
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
skills, highway-experience, framework, tests, fixtures, catalog, library, harness, and agent
trees, as `HW_*` variables, plus each output template and each framework or highway-experience
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
| `lib/frontmatter.sh` | Reads the YAML frontmatter block and body of a `SKILL.md`, including `metadata.dependencies`. |
| `lib/frontmatter-contract.sh` | Reads the permitted frontmatter keys and value constraints from `.frontmatter-contract`. |
| `lib/frontmatter-lexicon.sh` | Checks frontmatter description words against `frontmatter-lexicon.txt`. |
| `lib/constitution.sh` | Parses the rule inventory, rule fields, and token lists from the constitution. |
| `lib/body-scan.sh` | Annotates each body line with its section, fenced-block state, and list membership, so no check parses Markdown for itself. |
| `lib/rule-checks.sh` | One check per enforceable rule, the rule-id-to-check registry, and the template rule-exemption list. |
| `lib/schema-validate.sh` | Identity and frontmatter shape checks, plus the eight required body sections, for a skill. |
| `lib/library-schema.sh` | Minimal frontmatter shape checks (`name`, `description`) for a shared library file. |
| `lib/dependency-check.sh` | Resolves a skill's `metadata.dependencies` entries against `.highway/library/` and flags a missing path or version mismatch. |
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

Bash and standard command-line utilities, as shipped with macOS and Linux. Nothing to install, no
package manager, no runtime.
