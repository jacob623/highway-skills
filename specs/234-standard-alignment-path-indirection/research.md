# Research: Standard Alignment Path Indirection

Decisions for spec 234 (Phase 5 of `standard-alignment.md`). Each entry gives the decision, the
reason, and the alternatives considered.

## R1. Regression-only tests removed

**Decision**: Remove these five tests and the three fixtures only they read.

| Test | What it checked | Disposition |
|---|---|---|
| `profile-yaml.test.sh` | The removed YAML Profile template stays absent and no runtime fallback names it | Superseded: guards a finished removal (Feature 026) |
| `path-integrity.test.sh` | No pre-relocation `tools/...sh` or `](tools/` reference under `.highway/` | Superseded: guards the finished Feature 010 relocation. Phase 6 relocates again and the D2.5 check (R8) covers path construction in scripts |
| `feature-092-correspondence.test.sh` | The Feature 092 inventory and impact review exist and name two generators; three generated files exist | Superseded for the evidence files. The existence of `.adapter-manifest`, `.distribution-manifest`, and `catalog/index.json` is kept by `adapter-coverage.test.sh`, which reads all three |
| `profile-adaptive.test.sh` | The Feature 091 adaptive corpus names four organization sizes and two coverage phrases | Superseded: checks a past feature's evidence file, not current behavior |
| `runtime-contract-hygiene.test.sh` | No `FR-`, `Feature NNN`, `specs/`, `.specify/`, or feature-folder path in highway-profile, highway-setup, and the Profile template; their `metadata.version` is well formed | `FR-` and `Feature NNN` scan superseded (FR-004). `specs/` and `.specify/` kept by `shipped-tree-independence.test.sh`. Well-formed version kept by `validate-skill.sh` (P7.2), which every skill test runs |

Fixtures removed: `fixtures/profile-092/dependent-artifact-inventory.tsv`,
`fixtures/profile-092/impact-review.tsv`, `fixtures/profile-091/adaptive-corpus.md`. No other
fixture document lists them.

**Alternatives considered**: converting them to the helper first and removing them later. Rejected
by the phase ordering: no test is converted only to be deleted.

## R2. Reduced tests

**Decision**:

- **Experience Standard tests**: keep `experience-standard-convergence.test.sh` as the one test for
  the Experience Standard's current shape. Move into it every current check from
  `experience-standard-amendment.test.sh` and `feature-141-experience-standard-refactor.test.sh`,
  once each, then remove those two tests. The neutral name is kept because it is not tied to a
  feature number.
- **Kept, once each**: the section headings (Interaction Model, Conversational Clarification,
  Contribution Opportunity, Constructive Advisory, Recommendation Sets, Interaction Boundaries,
  X5 Addressability); the union of the rule rows the three tests require; the content phrases
  each test requires; the 64-rule count; at least 33 table rows; X5 before the Interaction Model;
  exactly one boundary-example table with five rows; and the boundary that the Experience Standard
  names no development-governance term (`Highway Skills Constitution`, `P namespace`, tier
  labels, `## Versioning Policy`, `## Self-Application`).
- **Consolidated from other tests**: the 64-rule count in `constitution-experience-alignment` and
  `highway-ux-alignment`, and the governance-term boundary in `constitution-experience-alignment`,
  are removed there because the consolidated test holds them.
- **Superseded**: the `Version` line pins, the `Version change: 8.1.0` (and 7.2.0, 8.0.0, 8.3.0)
  absences, the retired-rule absences (X2.8, X2.14, X2.23, X2.25, X2.26, X2.39, X2.40), the
  removed-section absences (`Historical amendment record`, `## Candidates`, the four
  Non-Normative Guidance headings, Context Awareness), `CLAR identifiers` and
  `persisted clarification history` absences, and the protected-path check, which can never fail
  because its own exemption matches the current constitution.
- **`constitution-experience-alignment.test.sh`**: keep the present-text checks and the 74-rule
  count; drop the version line and the two removed-text loops (superseded: they guard the
  finished Feature 146 refactor).
- **`profile-template-migration.test.sh`**: keep that the Profile record template exists, that
  highway-profile names `library/knowledge/profile.md` and ignores the framework-tree profile,
  and that the distribution manifest includes `profile-record.md`. Drop the obsolete-template
  absence checks (superseded: guard the finished Feature 092 migration). The test keeps
  assertions, so it stays.

**Alternatives considered**: keeping all three Experience Standard tests and only removing the
duplicates. Rejected: each would hold a fragment, and the spec asks for one copy of each check.

## R3. Exact version checks removed

**Decision**: Remove every check of the exact version of a skill (`version:` in a `SKILL.md`), an
output template (its frontmatter `version:`), the Highway Skills Constitution (`**Version**` line,
`Version change:` history lines, `Last Amended` dates on the version line), or the Experience
Standard (`**Version**` and `Layer 2` version lines). In a `for ... in` list, the pin is removed
from the list and the list is kept. A test left with no assertion is removed.

Not version checks, and kept:

- Values a template writes into user records: the catalog starting value `Version: 1.0.0` and the
  Profile `schema_version: 3.0.0`. They are output content a skill must produce, not the
  template's own version.
- Version strings inside disposable fixtures the test writes (`rule-checks`, `dependency-check`,
  `generate-catalog`, `storage-contract`, `capability-catalog`).
- Checks that a version is well formed or that the Example matches the frontmatter (the
  validator's P7.2 and P9.5).

The per-line record is `dropped-assertions.md` in this folder, produced from the diff during
implementation and annotated with the behavior each check covered.

**Alternatives considered**: a minimum-version check instead of an exact one. Rejected: it still
fails on a major renumbering and adds a comparison nothing else needs.

## R4. Helper location and bootstrap

**Decision**: The helper is `.highway/tools/lib/paths.sh`. It ships with the tools (the manifest's
`include .highway/tools` row covers it). It derives the repository root from its own position,
`$(dirname "${BASH_SOURCE[0]}")/../../..`, so it works in the repository and in an unpacked
distribution alike.

Each caller reaches it with one line that never climbs:

- Tools: `source "$SCRIPT_DIR/lib/paths.sh"`.
- Shared libraries: libraries are sourced by tools that have already sourced the helper. A library
  sourced alone sources its sibling `paths.sh` when `HW_ROOT` is unset.
- Tests: `source "$SCRIPT_DIR/paths.sh"`, a shim in the tests folder that sources the helper. The
  shim is named `paths.sh`, not `*.test.sh`, so the runner does not run it.
- Harness scripts: `. "$HERE/lib/paths.sh"`, a shim in `harness/bin/lib/` that sources the helper.

The two shims are the only files that climb from their own folder to the helper. Phase 6 edits
the helper's declarations and the two shims, and nothing else.

**Alternatives considered**: every test sourcing `"$SCRIPT_DIR/../lib/paths.sh"` directly. Rejected:
Phase 6 moves the tests away from the tools, and every test would need its source line edited.
An environment variable set by `run-all.sh`. Rejected: a test run on its own would have no
locations.

## R5. Helper interface

**Decision**: See [contracts/paths-helper.md](contracts/paths-helper.md). In short:

- Variables, set when sourced: `HW_ROOT`, `HW_FRAMEWORK`, `HW_SKILLS`, `HW_TOOLS`, `HW_LIB`,
  `HW_TESTS`, `HW_FIXTURES`, `HW_CATALOG`, `HW_INSTRUCTIONS`, `HW_LIBRARY`, `HW_GOVERNANCE`,
  `HW_KNOWLEDGE`, `HW_OUTPUT_TEMPLATES`, `HW_HARNESS`, the four agent copy trees, the Cursor rules
  folder, and the three always-on instruction outputs.
- `hw_template <name>` and `hw_doc <name>` return one file by name through a `case` statement, one
  arm per file. An unknown name prints an error and returns 1.
- `hw_at <root> <path>` maps a path under `HW_ROOT` into another root, for disposable copies and
  for libraries that take a root argument.
- `hw_rel <path>` returns a path relative to `HW_ROOT`, for manifests, adapter targets, the path
  map, and messages.
- `hw_paths_init [root]` sets every variable for a root; sourcing calls it with the helper's own.

The folder variables for templates, governance, and knowledge stay so a test can list every file
in them. Opening a named file in them must go through `hw_template` or `hw_doc` (R8, rule 4).

"Development-only location" in FR-008 is read as D1.1 defines it: the spec-driven workflow's
folders. The tests and harness folders are named by the helper because FR-005 requires the tests
and fixtures to be declared there, and the harness folder is a sibling the tests read. Neither
name is a D1.1 token, so the shipped-tree check still passes.

**Alternatives considered**: a function per location (`hw_skills_dir`). Rejected: a subshell per
lookup across 88 tests costs run time, and variables read more plainly. Computing a template's path
as `$HW_OUTPUT_TEMPLATES/$name.md`. Rejected by clarification Q1: one declaration per file.

## R6. Libraries and their root argument

**Decision**: Libraries that take a `highway_root` argument keep the argument, renamed `root`, and
it becomes the repository root. They find files with `hw_at "$root" "$(hw_doc constitution)"` and
the like, so a caller can still point them at another tree. Callers pass `"$HW_ROOT"`.
`dependency-check.sh` resolves a declared dependency path against
`$(hw_at "$root" "$HW_FRAMEWORK")`, because dependency paths are written relative to the framework
folder. `validation-cache.sh` and `distribution.sh` take the repository root as before, with the
argument renamed. The `CONSTITUTION_FILE`, `EXPERIENCE_FILE`, `FRONTMATTER_CONTRACT_FILE`, and
`FRONTMATTER_LEXICON_FILE` overrides keep working.

**Alternatives considered**: dropping the argument and reading `HW_*` globals. Rejected: callers
that validate another tree would have to re-initialize the helper and restore it.

## R7. Tests that build disposable copies

**Decision**: A test that copies the framework into a temporary tree resolves locations inside the
copy with `hw_at "$tmp" "$HW_SKILLS"` and the like. It copies with
`cp -R "$HW_FRAMEWORK" "$(hw_at "$tmp" "$HW_FRAMEWORK")"`. Paths in a user tree a test builds,
such as `$fixture_root/library/governance/nfrs`, follow the storage contract's user layout, not a
framework location, and stay as written.

## R8. The path construction check

**Decision**: `path-construction.test.sh` scans every `*.sh` under `HW_TOOLS` (tools, libraries,
tests, fixture scripts) and under `$HW_HARNESS/bin`. The helper is exempt from every rule. Lines
whose first non-blank character is `#` are skipped. Each violation prints `file:line: rule: text`.

| Rule | Fails on | Why |
|---|---|---|
| 1. Root variable | `HIGHWAY_ROOT`, `REPO_ROOT`, or `highway_root` anywhere | These names are how scripts build their own roots today |
| 2. Declared segment | a variable followed by `/.highway`, `/.github/`, `/.claude/`, `/.cursor/`, `/.agents/`, `/AGENTS.md`, or `/harness/`; or `HW_ROOT`, `HW_FRAMEWORK`, `HW_TOOLS`, `HW_TESTS`, `HW_LIBRARY` followed by a sub-folder the helper declares | Combining a root with a folder the helper declares |
| 3. Climbing | `SCRIPT_DIR`, `HERE`, or a `dirname` substitution followed by `/..` | Deriving a root from a script's own position. The two shims are exempt from this rule only |
| 4. Named file | `HW_OUTPUT_TEMPLATES`, `HW_GOVERNANCE`, or `HW_KNOWLEDGE` followed by `/` and a file name | A named template or document must come from `hw_template` or `hw_doc`. A glob such as `/*.md` passes |

Text a test greps for, path-map inputs, fixture content, and printed messages are literals with no
variable before the folder name, so no rule matches them (FR-011). The check's own patterns are
written with bracket expressions so its source does not match itself.

Artifact class `source-document`. `--probe source-document` writes a script that builds a skills
path from a root variable into a temporary folder and scans that folder; it must fail.
`--neutralise` writes the same script using the helper; it must pass.

**Alternatives considered**: flagging every literal `.highway/` string. Rejected: it would flag
document-text checks and path-map inputs, which the spec keeps literal.

## R9. Harness

**Decision**: The four `harness/bin/` scripts source the harness shim. `path-map.sh` builds its
`case` patterns from `hw_rel` of the helper's skills, library, governance, instructions, catalog,
tools, agent-tree, and harness locations. It gains `--location <skills|tools>`, which prints that
location relative to the repository root. `select.ts` calls it for the skills location in
`skillsAtRef` and takes the skill id as the first path segment after that location.
`project.ts` calls it for the tools location instead of naming `.highway/tools`. The selection
list (`harness/selection/shared.txt`) and the path-map test inputs stay literal (FR-011).

**Alternatives considered**: a TypeScript copy of the layout. Rejected: two declarations.

## R10. Constitution amendment

**Decision**: Add D2.5 to Principle II: "A script MUST get repository locations from the paths
helper." Observable: "`path-construction.test.sh` reports no path built from a root variable, a
climb from the script's folder, or a named template or document outside the helper." Tier
`[auto]`. Add the Enforcement Map row, extend the Toolchain Gate to D2.1–D2.5 and to files under
`harness/bin/`, bump 3.0.0 to 3.1.0 (MINOR: a new rule that a conforming change can meet), and
record the Sync Impact Report with the self-application review.

## R11. Order of work

**Decision**: Baseline, then removals and version checks (User Story 1), then the helper and shims,
then the check (observed failing on the unconverted tree, D3.6), then conversion of tools,
libraries, tests, and harness, then the amendment and documents, then regeneration and the full
suite. Conversion is mechanical for the common forms (root lines, folder prefixes, named
templates and documents) and by hand for the rest, using the check's output as the worklist.
