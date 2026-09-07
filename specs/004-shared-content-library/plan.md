# Implementation Plan: Shared Content Library

**Branch**: `004-shared-content-library` | **Date**: 2026-09-07 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/004-shared-content-library/spec.md`

## Summary

Add three directories under `.highway/content/` (`templates/`, `knowledge/`, `governance/`) so
content shared across skills is written once and referenced, not copied. A skill declares a
dependency on a shared file via a `metadata.dependencies` frontmatter list (path + pinned
version). Shared files carry minimal frontmatter (`name`, `description`, `metadata.version`)
and are validated against the constitution using the same rule inventory, body scanner, and
rule-check registry feature 003 already built — no second rule parser. Governance and
knowledge files get every registered rule-content check; template files are exempt from the
four checks whose logic counts MUST/SHOULD-bearing lines (P1.1, P1.3, P7.4, P7.5), since a
template's placeholder text is output shape, not a rule statement. A new sibling listing
artifact (`content-index.json`/`.md`) is generated for discovery, kept separate from the
existing skill catalog because that catalog's schema is closed to additional properties.

## Technical Context

**Language/Version**: Bash 3.2-compatible shell, with `awk`, `sed`, and `grep`. No new language
runtime.

**Primary Dependencies**: None added. Extends the existing `.highway/tools/` shell tooling and
reuses `lib/constitution.sh`, `lib/body-scan.sh`, `lib/rule-checks.sh`, and `lib/frontmatter.sh`
from feature 003.

**Storage**: N/A. No state is persisted beyond the generated catalog files, which are
regenerated in full on each run (no partial writes on failure, consistent with
`generate-catalog.sh`'s existing precedent).

**Testing**: The existing harness at `.highway/tools/tests/run-all.sh`, which discovers and
runs every `*.test.sh` and returns non-zero if any fails.

**Target Platform**: macOS default shell (bash 3.2.57) as the floor; must also run on Linux
bash 4+. No associative arrays, no `mapfile`, no `${var,,}`.

**Project Type**: Single project. Command-line shell tooling in one directory.

**Performance Goals**: Validation of one content file and generation of the content listing
complete fast enough for interactive use during authoring. Target under 2 seconds each on the
reference platform, matching feature 003's existing budget.

**Constraints**:
- No network calls.
- The tooling MUST hold no normative content: rule text, tiers, and prohibited-token lists
  continue to be read from the constitution at run time, never copied into scripts (carried
  over from feature 003, still binding here since this feature adds no new rule text).
- The existing skill catalog schema (`specs/001-multi-agent-skill-suite/contracts/catalog.schema.json`)
  is not modified; a new, separate schema is added for the content listing (FR-017).
- A false positive is costlier than a missed violation on template files specifically, since a
  false failure on placeholder text would block every template from validating.

**Scale/Scope**: Three new directories, zero content files to author (out of scope). One new
validator (`validate-content.sh`), one new discovery generator
(`generate-content-catalog.sh`), one new library (`lib/dependency-check.sh`), extensions to
`validate-skill.sh` and `lib/frontmatter.sh` for the `dependencies` field.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The constitution governs skills. This feature produces shell tooling, a directory layout, and
documentation, and authors no skill content and no shared content (populating
`.highway/content/` is explicitly out of scope). The skill-facing principles therefore do not
apply to this feature's own output; the table below records that and evaluates the principles
that do bear on tooling work.

| Principle | Status | Notes |
|---|---|---|
| I. Unambiguous, Actionable Directives | N/A | No skill content is authored. |
| II. Technology-Agnostic Portability | N/A | No skill content is authored. |
| III. Grounding in Approved Authority Sources | N/A | No skill content is authored. |
| IV. Measurable Quality Gates | PASS | Every success criterion in the spec is a count or a rate (SC-001 through SC-007). The Testing Gate is satisfied by the existing harness plus new tests for this feature's checks. |
| V. Reusable Patterns and Defined Error Handling | PASS | `validate-content.sh` and the dependency check report every violation in one run and return a defined exit status; no silent failure path. |
| VI. Deterministic, Explicit Decision Criteria | PASS | The template-vs-prose rule subset is a fixed exclusion list (P1.1, P1.3, P7.4, P7.5), not agent discretion (Decision 1, research.md). |
| VII. Long-Term Maintainability | PASS | No rule content is duplicated: content validation reuses feature 003's constitution parser, body scanner, and rule-check registry rather than re-implementing checks. |
| VIII. Reliability and Repeatability | PASS | Validation and catalog-generation output for given inputs depends only on those inputs and the constitution; no clock or environment default is read except the existing `generated_at` timestamp precedent already accepted for the skill catalog. |

**Gate result**: PASS. No violations to justify; Complexity Tracking is not required.

## Project Structure

### Documentation (this feature)

```text
specs/004-shared-content-library/
├── plan.md                          # This file
├── research.md                      # Phase 0 output
├── data-model.md                    # Phase 1 output
├── quickstart.md                    # Phase 1 output
├── contracts/
│   ├── content-validation-output.md # Phase 1 output: finding/coverage format for content files
│   ├── dependency-validation-output.md  # Phase 1 output: [DEPENDENCY]-tagged error format
│   └── content-catalog.schema.json  # Phase 1 output: schema for the new sibling listing
└── tasks.md                         # Phase 2 output (/speckit-tasks — NOT created here)
```

### Source Code (repository root)

```text
.highway/
├── content/
│   ├── templates/README.md      # new: directory purpose only, not a template itself
│   ├── knowledge/README.md      # new: directory purpose only, not a knowledge file itself
│   └── governance/README.md     # new: directory purpose only, not a governance file itself
├── tools/
│   ├── validate-skill.sh                 # updated: adds the dependency-resolution block
│   ├── validate-content.sh               # new: validates one shared content file
│   ├── generate-content-catalog.sh       # new: builds content-index.json + .md
│   ├── lib/
│   │   ├── frontmatter.sh                # updated: fm_get_dependencies (metadata.dependencies)
│   │   ├── rule-checks.sh                # updated: exposes the template exclusion list
│   │   ├── content-schema.sh             # new: minimal frontmatter checks for content files
│   │   └── dependency-check.sh           # new: resolves and version-checks a dependencies list
│   └── tests/
│       ├── fixtures/content/
│       │   ├── templates/{valid,invalid-missing-version}/...
│       │   ├── knowledge/{valid,invalid-vague-rule}/...
│       │   └── governance/{valid,invalid-bad-citation}/...
│       ├── validate-content.test.sh          # new
│       ├── generate-content-catalog.test.sh  # new
│       ├── dependency-check.test.sh          # new
│       ├── validate-skill.test.sh            # updated: dependency-resolution cases added
│       └── run-all.sh                        # unchanged (auto-discovers *.test.sh)
```

**Structure Decision**: Single project, extending the existing `.highway/tools/` shell tooling
in place. No new top-level project; `.highway/content/` is a new sibling of the existing
`.highway/skills/`, `.highway/tools/`, and `.highway/catalog/` directories.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

Not applicable. The Constitution Check gate passed with no violations.

