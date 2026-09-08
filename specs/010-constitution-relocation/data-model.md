# Data Model: Constitution Relocation and Shipped-Tree Independence

Phase 1 output. This feature moves no data at runtime; the entities below are files, path sets,
and reference forms.

## Entity: Governance document location

| Property | Before | After |
|---|---|---|
| Path | `.specify/memory/constitution.md` | `.highway/governance/constitution.md` |
| Classification | Development artifact | Distributed artifact |
| Anchored at | Repository root | Framework root (`.highway/`) |
| Present in a distributed tree | No | Yes |
| Overwritten by the development constitution command | Yes — data loss | No |
| Rule text | 8 principles, 44 rules, v2.0.1 | Byte-unchanged |
| Sync Impact Report | Cites 3 development-only paths | Cites the same records by name |

**Validation rule**: the document resolves from a tree containing only `.highway/`. Anchoring at
the framework root rather than the repository root is what makes this true.

## Entity: Constitution resolution

| Property | Before | After |
|---|---|---|
| Override variable | `CONSTITUTION_FILE` | Unchanged |
| Override precedence | Checked first | Unchanged |
| Fallback | `<repo root>/.specify/memory/constitution.md` | `<framework root>/governance/constitution.md` |
| Function signature | `con_file <repo_root>` | Takes the framework root |

Only the fallback branch changes. The override mechanism the feature description asked for
already exists.

## Entity: Distributed path set

Declared once, consumed by the check. A path not on this list is out of scope.

| Pattern | Holds |
|---|---|
| `.highway/` | Skills, library, catalog, governance, tooling, tests |
| `.github/skills/highway-*` | GitHub Copilot adapters |
| `.claude/skills/highway-*` | Claude Code adapters |
| `.cursor/rules/highway-*` | Cursor adapters |

**Deliberately excluded**: `.github/skills/speckit-*` and the equivalent adapter directories for
other agents. These are external tooling used to build this repository, not Highway's product.
`generate-agent-adapters.sh` already refuses to read or write them.

**Also excluded**: `.specify/`, `specs/`, `governance-plan.md`, and the repository `README.md`
are development artifacts and may reference development locations freely.

## Entity: Prohibited reference

A distributed file must contain neither string.

| Token | Names |
|---|---|
| `.specify/` | The development workflow directory |
| `specs/` | The specification record |

Both document links and source comments are in scope, per the clarification recorded in the spec.
The check matches text, not intent, which is what makes it dependable.

## Entity: Provenance citation form

| Property | Value |
|---|---|
| Form | `feature NNN (short-name)` |
| Example | `per feature 003 (constitution enforcement)` |
| Contains a path | No |
| Contains a link | No |
| Consistent across files | Required |

## Reference inventory

34 references across 20 files under `.highway/`. Every one is removed or rewritten.

| File | Refs | Nature |
|---|---|---|
| `.highway/tools/README.md` | 6 | Constitution location, plus 5 design-record links |
| `.highway/catalog/README.md` | 3 | Design-record links |
| `.highway/tools/generate-catalog.sh` | 3 | Header comments |
| `.highway/skills/highway-help/SKILL.md` | 2 | Document links in Outputs and Verification |
| `.highway/tools/validate-skill.sh` | 2 | Constitution location, design record |
| `.highway/tools/validate-library.sh` | 2 | Constitution location, design record |
| `.highway/tools/generate-agent-adapters.sh` | 2 | Header comments |
| `.highway/tools/lib/constitution.sh` | 2 | Fallback location, design record |
| `.highway/skills/_authoring-standard.md` | 1 | Link to the constitution |
| `.highway/tools/generate-library-catalog.sh` | 1 | Header comment |
| `.highway/tools/lib/body-scan.sh` | 1 | Header comment |
| `.highway/tools/lib/dependency-check.sh` | 1 | Header comment |
| `.highway/tools/lib/schema-validate.sh` | 1 | Header comment |
| `.highway/tools/tests/authoring-standard.test.sh` | 1 | Constitution location |
| `.highway/tools/tests/constitution-inventory.test.sh` | 1 | Constitution location |
| `.highway/tools/tests/coverage-summary.test.sh` | 1 | Constitution location |
| `.highway/tools/tests/dependency-check.test.sh` | 1 | Design record |
| `.highway/tools/tests/generate-agent-adapters.test.sh` | 1 | Design record |
| `.highway/tools/tests/new-agent-extensibility.test.sh` | 1 | Design record |
| `.highway/tools/tests/validate-library.test.sh` | 1 | Design record |

Plus 2 references inside the constitution's Sync Impact Report, which become in-scope the moment
the document is relocated.

Test fixtures were searched and contain none. No fixture exemption is added.

## Derived artifacts regenerated

| Artifact | Generator | Change |
|---|---|---|
| `.highway/catalog/index.json` | `generate-catalog.sh` | Help skill version |
| `.highway/catalog/index.md` | `generate-catalog.sh` | Help skill version |
| `.github/skills/highway-help/SKILL.md` | `generate-agent-adapters.sh` | 2 links removed, version |
| `.claude/skills/highway-help/SKILL.md` | `generate-agent-adapters.sh` | 2 links removed, version |
| `.cursor/rules/highway-help.mdc` | `generate-agent-adapters.sh` | 2 links removed, version |
| `.highway/tools/.adapter-manifest` | `generate-agent-adapters.sh` | Version and hashes |

The three adapters hold 6 further references between them. They are corrected by regeneration, not
by editing — hand-editing a generated artifact is refused by the generator.

## Skill change record

| Element | Change | Version impact |
|---|---|---|
| `## Outputs` | Contract link replaced by a name-only citation | PATCH |
| `## Verification` | Quickstart link replaced by a name-only citation | PATCH |
| `metadata.version` | `3.0.0` → `3.0.1` | The increment itself |
| Declared inputs | None | — |
| Output fields, order, values | None | — |
| Verification criteria | None | — |

A single PATCH increment covers both edits. Classification reasoning is in research.md R6.

## Entity: Vacated-location placeholder

| Property | Value |
|---|---|
| Path | `.specify/memory/constitution.md` |
| Classification | Development artifact |
| States a rule | No |
| Defines a rule ID | No |
| Records | That the Highway Skills Constitution moved, where it went, what replaces this file |
| Lifetime | Until the development constitution is ratified |

Exists so the ten development workflow commands that read this path continue to function.

## Entity: Shippability check

| Property | Value |
|---|---|
| Location | `.highway/tools/tests/shipped-tree-independence.test.sh` |
| Scope | The distributed path set |
| Failure output | The offending file, its line number, and the matched text |
| Self-exclusion | By filename, matching the existing path-integrity precedent |
| Self-test | Seeds a reference, confirms detection, removes it |
| Relationship to `path-integrity.test.sh` | Separate; different question, different scope |
