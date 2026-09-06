# Implementation Plan: Mechanical Enforcement of the Constitution

**Branch**: `003-constitution-enforcement` | **Date**: 2026-09-06 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/003-constitution-enforcement/spec.md`

## Summary

Teach the existing skill validator to check constitution rules by ID, so an author writing a
skill is told which rule they violated rather than receiving a generic structural complaint.

The technical approach has three parts. First, derive the rule inventory (rule IDs and their
tiers) by parsing the constitution's rule tables, so the tooling holds no normative content and
cannot silently fall out of date when the constitution is amended. Second, add a shared body
scanner that annotates each line of a skill with its section, whether it sits inside a fenced
block, and whether it is a list item — every content-level rule check reads from this one
scanner rather than re-parsing Markdown. Third, implement one check function per enforceable
rule ID, with a registry mapping rule ID to check, so any rule in the inventory without a
registered check is reported as unchecked.

Alongside the tooling, the authoring standard is rewritten to cite rule IDs instead of
restating rule text, and the four test fixtures and the worked example are rewritten to
conform.

## Technical Context

**Language/Version**: Bash 3.2-compatible shell, with `awk`, `sed`, and `grep` for text
processing. No new language runtime.

**Primary Dependencies**: None added. Extends the existing `.highway/tools/` shell tooling.

**Storage**: N/A. No state is persisted; validation reads files and writes to standard output.

**Testing**: The existing harness at `.highway/tools/tests/run-all.sh`, which discovers and
runs every `*.test.sh` and returns non-zero if any fails.

**Target Platform**: macOS default shell (bash 3.2.57) as the floor; must also run on Linux
bash 4+. No associative arrays, no `mapfile`, no `${var,,}`.

**Project Type**: Single project. Command-line shell tooling in one directory.

**Performance Goals**: Validation of one skill completes fast enough for interactive use during
authoring. Target under 2 seconds per skill on the reference platform.

**Constraints**:
- No network calls.
- The tooling MUST hold no normative content: rule text, tiers, and prohibited-token lists are
  read from the constitution at run time, never copied into scripts (FR-001, FR-033).
- Tightening validation reds the current fixtures, so fixture rewrites ship in the same change.
- A false positive is costlier than a missed violation, because real skills are about to be
  authored against this.

**Scale/Scope**: 48 constitution rules total; 13 enforceable; 2 already covered by existing
checks, so 11 new checks. Four fixtures plus one worked example to rewrite. One documentation
file to realign.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The constitution governs skills. This feature produces shell tooling and documentation and
authors no skill, so the skill-facing principles do not apply to its output. The rules that do
bear on this feature are recorded below.

| Principle | Status | Notes |
|---|---|---|
| I. Unambiguous, Actionable Directives | N/A | No skill content is authored. |
| II. Technology-Agnostic Portability | N/A | No skill content is authored. |
| III. Grounding in Approved Authority Sources | N/A | No skill content is authored. |
| IV. Measurable Quality Gates | PASS | Every success criterion in the spec is a count or a rate. The Testing Gate applies to this feature and is satisfied by the existing harness. |
| V. Reusable Patterns and Defined Error Handling | PASS | Validation reports every violation in one run and returns a defined exit status; no silent failure path. |
| VI. Deterministic, Explicit Decision Criteria | PASS | Conditional enforcement is governed by an explicit present/absent test per rule (FR-030, FR-024 to FR-026), not by discretion. |
| VII. Long-Term Maintainability | PASS | FR-001 and FR-033 prevent the tooling from duplicating constitution content, which is the specific duplication P7.3 prohibits. US2 removes the existing duplication in the authoring standard. |
| VIII. Reliability and Repeatability | PASS | Validation output for a given skill depends only on the skill and the constitution; no clock, randomness, or environment default is read. |

**Self-application note**: this feature implements checks for the constitution but does not
amend it. The prerequisite amendment (2.0.2) that adds the prohibited-token list and retags the
example-labeling rule is outside this feature and is tracked in Phase 0.

**Gate result**: PASS. No violations to justify; Complexity Tracking is not required.

## Project Structure

### Documentation (this feature)

```text
specs/003-constitution-enforcement/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── validation-output.md   # Phase 1 output: the reported line format tests assert on
└── tasks.md             # Phase 2 output (/speckit-tasks — NOT created here)
```

### Source Code (repository root)

```text
.highway/
├── skills/
│   └── _authoring-standard.md          # rewritten: cites rule IDs, restates no rule text
├── tools/
│   ├── validate-skill.sh               # entry point: adds rule-level reporting and summary
│   ├── lib/
│   │   ├── frontmatter.sh              # unchanged
│   │   ├── schema-validate.sh          # updated: required sections 6 → 7 (adds Purpose)
│   │   ├── constitution.sh             # new: parses rule inventory and token lists
│   │   ├── body-scan.sh                # new: annotates body lines (section, fenced, list item)
│   │   └── rule-checks.sh              # new: one check per enforceable rule ID, plus registry
│   └── tests/
│       ├── fixtures/                   # rewritten: all four conform or fail for one stated reason
│       ├── constitution-inventory.test.sh   # new
│       ├── rule-checks.test.sh              # new
│       ├── path-integrity.test.sh           # new: covers every file under .highway/
│       ├── validate-skill.test.sh           # updated
│       ├── generate-catalog.test.sh         # updated: fixture content changed
│       ├── generate-agent-adapters.test.sh  # updated: fixture content changed
│       ├── new-agent-extensibility.test.sh  # updated: fixture content changed
│       └── run-all.sh                       # unchanged
└── catalog/                            # unchanged
```

**Structure Decision**: Single project, extending the existing `.highway/tools/` layout rather
than introducing a new one. The three new library files separate the three concerns that would
otherwise entangle: reading the constitution, parsing a skill's body, and deciding one rule.
Keeping the body scanner separate is what prevents each of the eleven new checks from writing
its own Markdown parser, which is the main maintenance risk in this feature.

## Complexity Tracking

> Not required. The Constitution Check gate passed with no violations.

