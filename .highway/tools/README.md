# tools/

Bash tooling for the Highway Skills authoring framework. No network calls, no new language
runtime — POSIX shell (`bash`, `awk`, `sed`, `grep`) only.

## Scripts

### `.highway/tools/validate-skill.sh <skill-dir>`

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

### `.highway/tools/generate-catalog.sh`

Iterates `.highway/skills/*/SKILL.md`, validates each via `validate-skill.sh`, and writes
`.highway/catalog/index.json` + `.highway/catalog/index.md`.

- **Exit 0**: catalog written.
- **Exit 1**: at least one skill under `.highway/skills/` is invalid; the catalog is **not** written (no
  partial catalog), and the failing skill's `id` is named in the error output.

### `.highway/tools/generate-agent-adapters.sh`

Regenerates the per-agent adapters for every valid skill under `.highway/skills/`, into
`.github/skills/<id>/SKILL.md`, `.claude/skills/<id>/SKILL.md`, and `.cursor/rules/<id>.mdc` (at
the true repository root, not under `.highway/`), per feature 009 (skill id namespace alignment).
`<id>` is already the full agent-facing identifier (e.g. `highway-help`) — this generator injects
no namespace prefix of its own.

- **Exit 0**: all adapters regenerated (or confirmed already up to date).
- **Exit 1**: any skill fails validation (no partial adapter set is written), or a target file was
  hand-edited outside this generator (refuses to overwrite, names the file).
- Never reads or writes existing `.github/skills/speckit-*` folders — those are external tooling
  used to build this repository, not part of this suite.

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
`README.md`), validates each via `validate-library.sh`, and writes
`.highway/catalog/library-index.json` + `.highway/catalog/library-index.md` — a sibling listing
to the skill catalog, kept separate since the skill catalog's schema is closed to additional
properties and shaped around skill-only fields.

- **Exit 0**: catalog written.
- **Exit 1**: at least one file under `.highway/library/` is invalid; the catalog is **not**
  written (no partial catalog), and the failing file's path is named in the error output.

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
