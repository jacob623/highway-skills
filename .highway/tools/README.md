# tools/

Bash tooling for the Highway Skills authoring framework. No network calls, no new language
runtime — POSIX shell (`bash`, `awk`, `sed`, `grep`) only.

## Scripts

### `.highway/tools/validate-skill.sh <skill-dir>`

Validates one skill directory against the constitution at `.specify/memory/constitution.md` and
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
intended state, so unverified must not read as failed. The output format is a contract; see
`specs/003-constitution-enforcement/contracts/validation-output.md`.

### Libraries

| File | Responsibility |
|---|---|
| `lib/frontmatter.sh` | Reads the YAML frontmatter block and body of a `SKILL.md`. |
| `lib/constitution.sh` | Parses the rule inventory, rule fields, and token lists from the constitution. |
| `lib/body-scan.sh` | Annotates each body line with its section, fenced-block state, and list membership, so no check parses Markdown for itself. |
| `lib/rule-checks.sh` | One check per enforceable rule, plus the rule-id-to-check registry. |
| `lib/schema-validate.sh` | Identity and frontmatter shape checks, plus the seven required body sections. |

### `.highway/tools/generate-catalog.sh`

Iterates `.highway/skills/*/SKILL.md`, validates each via `validate-skill.sh`, and writes
`.highway/catalog/index.json` + `.highway/catalog/index.md`.

- **Exit 0**: catalog written.
- **Exit 1**: at least one skill under `.highway/skills/` is invalid; the catalog is **not** written (no
  partial catalog), and the failing skill's `id` is named in the error output.

### `.highway/tools/generate-agent-adapters.sh`

Regenerates the per-agent adapters for every valid skill under `.highway/skills/`, into
`.github/skills/<id>/SKILL.md`, `.claude/skills/<id>/SKILL.md`, and `.cursor/rules/<id>.mdc` (at
the true repository root, not under `.highway/`), per
[contracts/agent-adapter-contract.md](../../specs/001-multi-agent-skill-suite/contracts/agent-adapter-contract.md).

- **Exit 0**: all adapters regenerated (or confirmed already up to date).
- **Exit 1**: any skill fails validation (no partial adapter set is written), or a target file was
  hand-edited outside this generator (refuses to overwrite, names the file).
- Never reads or writes existing `.github/skills/speckit-*` folders — those are external tooling
  used to build this repository, not part of this suite.

### `.highway/tools/tests/run-all.sh`

Discovers and runs every `*.test.sh` under `.highway/tools/tests/`, prints a pass/fail summary,
and exits non-zero if any test fails.

## Adding a New Agent (FR-004, SC-002)

Adding a 4th (or Nth) agent requires **only** a change to `.highway/tools/generate-agent-adapters.sh`'s
declarative agent config table — never an edit to any file under `.highway/skills/`. See
[contracts/agent-adapter-contract.md](../../specs/001-multi-agent-skill-suite/contracts/agent-adapter-contract.md)
for the full contract. Procedure:

1. Add one row to the `AGENT_IDS` / `AGENT_TARGET_PATTERNS` / `AGENT_TRANSFORMS` arrays at the
   top of `.highway/tools/generate-agent-adapters.sh` (agent id, target path pattern, transform
   name).
2. If the new agent needs a transform other than `identity-copy`, implement that transform as a
   new function in the script's transform-dispatch section (mirroring `mdc-transform`).
3. Run `.highway/tools/generate-agent-adapters.sh` and confirm the new target path is produced
   correctly for every existing skill, with zero diff under `.highway/skills/`.
4. No existing skill file changes. If any were required, that is a bug in the new transform, not
   an expected part of this procedure.
