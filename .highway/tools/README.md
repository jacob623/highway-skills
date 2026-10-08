# tools/

Bash tooling for the Highway Skills authoring framework. No network calls, no new language
runtime — POSIX shell (`bash`, `awk`, `sed`, `grep`) only.

## Scripts

### `.highway/tools/validate-skill.sh [--no-cache] <skill-dir>`

Validates one skill directory against the constitution at `.highway/governance/constitution.md` and
against [skills/_authoring-standard.md](../skills/_authoring-standard.md).

Rule ids, tier tags, and token lists are read from the constitution at run time. No rule content
is stored here, so amending the constitution cannot leave this tooling silently out of date.

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
`.highway/tools/validate-library.sh` below): a missing path or a stale pinned version is
reported as an `ERROR: [DEPENDENCY] ...` finding, per feature 004 (shared content library).

#### Validation cache

A successful validation is recorded under `${TMPDIR:-/tmp}/highway-validation-cache` and replayed
when the same skill is validated again against the same validator. Generation re-validates the
same skills many times in one run, and the cache is what stops that work being repeated — it
takes validating all twelve skills from roughly 5.4 s to 0.44 s. Pass `--no-cache` to force full
validation.

The cache key is a hash of the skill's `SKILL.md` combined with a hash of **every validator
input**: `validate-skill.sh` itself, `.frontmatter-contract`, and every file under `lib/`,
`.highway/library/` and `.highway/governance/`. Change any of them and the key changes, so a
recorded verdict can never outlive the thing that decided it. Three properties are deliberate and
should be preserved by anyone editing this:

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

### Libraries

| File | Responsibility |
|---|---|
| `lib/frontmatter.sh` | Reads the YAML frontmatter block and body of a `SKILL.md`, including `metadata.dependencies`. |
| `lib/constitution.sh` | Parses the rule inventory, rule fields, and token lists from the constitution. |
| `lib/body-scan.sh` | Annotates each body line with its section, fenced-block state, and list membership, so no check parses Markdown for itself. |
| `lib/rule-checks.sh` | One check per enforceable rule, the rule-id-to-check registry, and the template rule-exemption list. |
| `lib/schema-validate.sh` | Identity and frontmatter shape checks, plus the eight required body sections, for a skill. |
| `lib/library-schema.sh` | Minimal frontmatter shape checks (`name`, `description`) for a shared library file. |
| `lib/dependency-check.sh` | Resolves a skill's `metadata.dependencies` entries against `.highway/library/` and flags a missing path or version mismatch. |
| `lib/distribution.sh` | Classifies a repository path as included in or excluded from the user-facing distribution, by reading `.distribution-manifest`. |
| `lib/validation-cache.sh` | Content-addressed record of successful skill validations, keyed on the skill plus every validator input. |

### `.highway/tools/generate-catalog.sh`

Iterates `.highway/skills/*/SKILL.md`, validates each via `validate-skill.sh`, and writes
`.highway/catalog/index.json` + `.highway/catalog/index.md`.

- **Exit 0**: catalog written.
- **Exit 1**: at least one skill under `.highway/skills/` is invalid; the catalog is **not** written (no
  partial catalog), and the failing skill's `id` is named in the error output.

### `.highway/tools/generate-agent-adapters.sh`

Regenerates the per-agent adapters for every valid skill under `.highway/skills/`, into
`.github/skills/<id>/SKILL.md`, `.claude/skills/<id>/SKILL.md`, `.cursor/skills/<id>/SKILL.md`,
and `.agents/skills/<id>/SKILL.md`
(at the true repository root, not under `.highway/`), per feature 009 (skill id namespace
alignment). The deliverables for one skill are byte-identical copies of the source, so Cursor
and Codex each receive the skill as a skill.
`<id>` is already the full agent-facing identifier (e.g. `highway-help`) — this generator injects
no namespace prefix of its own.

- **Exit 0**: all adapters regenerated (or confirmed already up to date).
- **Exit 1**: any skill fails validation (no partial adapter set is written), or a target file was
  hand-edited outside this generator (refuses to overwrite, names the file).
- Never reads, writes, or removes existing `speckit-*` folders under `.github/skills/`,
  `.cursor/skills/`, or `.agents/skills/` — those are external tooling used to build this
  repository, not part of this suite. The generator removes no file at all.

### `.highway/tools/generate-instructions.sh`

Publishes every `.highway/instructions/<id>.md` file to the always-on instruction locations.
Author one instruction as its own file. The frontmatter is `name` (equal to the filename id) and
`description`. The body is plain markdown and is copied unchanged.

- Cursor receives one always-on rule per instruction: `.cursor/rules/<id>.mdc`, with
  `alwaysApply: true`.
- Claude Code receives every body in `.claude/CLAUDE.md`.
- GitHub Copilot receives the same bytes in `.github/copilot-instructions.md`.
- Codex receives the same bytes in `AGENTS.md` at the repository root.

Bodies in the merged files are in filename order, with one blank line between bodies.

- **Exit 0**: every output written or already current.
- **Exit 1**: a source is invalid, or a target was hand-edited outside this generator (refuses
  to overwrite, names the file). A non-zero exit writes nothing. The generator removes no file.

### `.highway/tools/tests/run-all.sh`

Discovers and runs every `*.test.sh` under `.highway/tools/tests/`, prints a pass/fail summary,
and exits non-zero if any test fails.

### `.highway/tools/generate-distribution.sh <target-directory>`

Produces the user-facing distribution from this repository, then verifies it before accepting it.
What ships is read from `.distribution-manifest`, never hard-coded in the script, so the path set
has exactly one declaration. Artifacts are copied rather than regenerated, because
`generate-catalog.sh` records a timestamp and regenerating would break byte-identical output.

Three verifications must all pass, or no distribution is produced:

1. No distributed file references a development-only location.
2. Every documentation cross-reference resolves to a path inside the distribution.
3. The distribution's **own** copy of `validate-skill.sh` succeeds against every skill it
   contains, with no constitution override. The repository's copy is deliberately not used: it
   resolves its governing document relative to its own location, so it succeeds against a tree
   containing neither toolchain nor governing document and proves nothing about self-containment.

- **Exit 0**: distribution produced and all three verifications passed.
- **Exit 1**: a verification failed (the candidate is removed, not left in place), a repository
   path is unclassified, or the target exists and was not produced by this generator (refuses to
   overwrite, names the file).

The packaging tooling itself is excluded from the distribution. A recipient never packages, and
the script necessarily contains the development-path tokens that verification 1 searches for.

### `.highway/tools/validate-library.sh <library-file>`

Validates one shared library file (template, knowledge, or governance) under
`.highway/library/`, the same way `validate-skill.sh` validates a skill: minimal frontmatter
(`name`, `description`, `metadata.version`) plus the constitution's rule-content checks. A
template file is exempt from the four checks that key on MUST/SHOULD keyword text (P1.1, P1.3,
P7.4, P7.5), reported N/A rather than skipped, since a template's placeholder text can
legitimately contain those words without being a rule statement.

- **Exit 0**: no check failed.
- **Exit 1**: at least one check failed, or the file is not located under
  `library/templates/`, `library/knowledge/`, or `library/governance/` (tagged
  `[LIBRARY-TYPE]`).

Output format is a contract, per feature 005 (rename content to library).

### `.highway/tools/generate-library-catalog.sh`

Iterates `.highway/library/{templates,knowledge,governance}/*.md` (excluding each directory's
`README.md` and the three opaque root-seeded context documents
`highway-identity.md`, `highway-platform-objectives.md`, and `highway-vision.md`), validates each
cataloged file via `validate-library.sh`, and writes
`.highway/catalog/library-index.json` + `.highway/catalog/library-index.md` — a sibling listing
to the skill catalog, kept separate since the skill catalog's schema is closed to additional
properties and shaped around skill-only fields.

- **Exit 0**: catalog written.
- **Exit 1**: at least one file under `.highway/library/` is invalid; the catalog is **not**
  written (no partial catalog), and the failing file's path is named in the error output.
Complete skeletons for retained files emitted by skills live under
`.highway/library/templates/output/`. Each skeleton covers the emitted file's frontmatter and
body. Request-producing skills use the shared request skeletons at
`.highway/library/templates/output/request-record.md` and
`.highway/library/templates/output/request-catalog.md`; the `highway-new` skill cites both and
must be revalidated when either changes. The questionnaire at
`.highway/library/templates/requirements-inquiry.md` is a question-content template and remains
separate.

When a shared library artifact changes, identify every `SKILL.md` that cites it, re-run the
affected skill and library validators, and review the complete emitted structure. A mismatch in
frontmatter or body is reported under D8.1; transient messages are not retained file artifacts.

## Adding a New Agent (FR-004, SC-002)

Adding a 4th (or Nth) agent requires **only** a change to `.highway/tools/generate-agent-adapters.sh`'s
declarative agent config table — never an edit to any file under `.highway/skills/`. See
feature 009 (skill id namespace alignment)
for the full contract. Procedure:

1. Add one row to the `AGENT_IDS` / `AGENT_TARGET_TEMPLATES` / `AGENT_TRANSFORMS` arrays at the
   top of `.highway/tools/generate-agent-adapters.sh` (agent id, target path pattern, transform
   name).
2. If the new agent needs a transform other than `identity-copy`, implement that transform as a
   new function in the script's transform-dispatch section (mirroring `mdc-transform`).
3. Run `.highway/tools/generate-agent-adapters.sh` and confirm the new target path is produced
   correctly for every existing skill, with zero diff under `.highway/skills/`.
4. No existing skill file changes. If any were required, that is a bug in the new transform, not
   an expected part of this procedure.
