# Phase 0 Research: Shared Content Library

No `NEEDS CLARIFICATION` markers remain in the spec after `/speckit-clarify`. This phase records
the design decisions needed to turn the five resolved clarifications into an implementable
approach, plus the one item the spec explicitly deferred to planning (the template rule
subset).

## Decision 1: The template rule subset is a fixed exclusion list, not per-file judgment

**Decision**: Template files are checked against every registered rule in
`lib/rule-checks.sh`'s registry (`rc_registry`) **except** the four whose check logic is
defined over `bs_normative_lines` — the body-scan function that selects only lines carrying
MUST/MUST NOT/SHOULD outside a fenced block: **P1.1** (exactly one keyword), **P1.3** (25-word
limit), **P7.4** (12 MUST-level rule limit), **P7.5** (400-word normative-section limit).
Governance and knowledge files get all twelve registered checks unchanged.

**Rationale**: A template's placeholder text can legitimately contain the word "MUST" or
"SHOULD" as an example of the shape a skill's output should take, without that text being an
actual rule statement (see spec Edge Cases). The four excluded checks are precisely the ones
that fire on the presence of those keywords, so they are the only ones capable of misfiring on
placeholder text. Every other registered check either operates on a named section that content
files are not required to contain (P4.2 Verification, P5.2 Error Handling, P8.3 Verification
presence — each already returns not-applicable when the section is absent) or checks a
structural pattern unrelated to keyword-counting (P3.5 citation format, P8.1 ordered-list
numbering, P7.1 Purpose-section sentence count, P7.2 semantic version) and so carries no
misfire risk; keeping them active for templates costs nothing and catches a real defect if one
occurs (e.g., a malformed citation inside a template).

**Alternatives considered**:
- *Run all twelve checks unchanged on templates, relying on the checks to self-gate.* Rejected:
  P1.1, P1.3, P7.4, and P7.5 do not self-gate — they return PASS with a count of zero when no
  MUST/SHOULD text is present, but return FAIL the moment placeholder text happens to contain
  one, which is exactly the false-positive risk the spec calls out.
- *Hand-pick a bespoke subset per content type, decided file-by-file as templates are
  authored.* Rejected: this is a per-file judgment call, which fails Principle VI (Deterministic,
  Explicit Decision Criteria) — the same rule ID would need a different verdict on different
  templates for no stated reason.
- *Exempt templates from the whole rule-content check pass.* Rejected: this was Option A ("full
  exemption") from the clarification question, and the user's answer explicitly chose the
  narrower hand-picked-subset option instead.

**Reporting**: the four excluded rules are recorded in the content validator's N/A group using
condition code **N2** (from the constitution's Compliance Review Protocol: "the rule governs a
skill section that this artifact type is not required to contain"), extended by existing
precedent in `rc_registry` — P3.5, P4.2, P5.2, P5.3, P7.5, and P8.1 already use N2 for
not-applicable conditions that are not literally about a missing section (e.g., P3.5 uses it
when zero citations are present). This feature follows that same precedent rather than
introducing a new condition code.

## Decision 2: `dependencies` lives under `metadata`, one entry per shared file

**Decision**: A skill's `SKILL.md` frontmatter carries dependencies as:

```yaml
metadata:
  version: 1.0.0
  dependencies:
    - path: content/templates/foo.md
      version: 1.0.0
```

Each entry has `path` (framework-relative, i.e. relative to `.highway/`, matching how the
existing catalog's `source_path` field is already `.highway/`-relative — no leading
`.highway/` itself) and `version` (the pinned semantic version). Multiple entries are permitted; zero entries (the field absent entirely) is
valid and is the default for every skill today, since no skill currently references shared
content.

**Rationale**: This exactly mirrors the existing `metadata.agent_exceptions` list shape
(`- agent: ... / deviation: ...`), which `lib/frontmatter.sh`'s `fm_get_agent_exceptions`
already parses with a small, tested awk state machine. Reusing that shape means the new
`fm_get_dependencies` function is a structural copy of a function already proven correct,
rather than a new parsing strategy.

**Alternatives considered**:
- *Inline string form*, e.g. `dependencies: ["content/templates/foo.md@1.0.0"]`. Rejected:
  requires a new delimiter-splitting parser and a new escaping rule for paths that could
  theoretically contain `@`; the list-of-objects form reuses working code instead.
- *Path-only, no pinned version.* Rejected outright by the clarification answer (FR-015
  requires both).

## Decision 3: dependency resolution is framework-relative and checked from `validate-skill.sh`

**Decision**: `path` in a `dependencies` entry is resolved as `$HIGHWAY_ROOT/$path` (not
`$REPO_ROOT/$path` — the example path `content/templates/foo.md` only resolves to a real file
when anchored at `.highway/`, matching the existing catalog's `source_path` convention, e.g.
`skills/foo/SKILL.md`). A new `lib/dependency-check.sh` provides
`dc_validate_dependencies <skill_file> <highway_root>`, called from `validate-skill.sh` for
every skill. It is not called from `validate-content.sh`, because the spec scopes dependencies
to skill-to-content references only (FR-005); content-to-content references are out of scope.

**Rationale**: `HIGHWAY_ROOT` is already resolved once at the top of `validate-skill.sh` via
`SCRIPT_DIR` (see feature 002's path-resolution precedent, which established `HIGHWAY_ROOT` as
distinct from the true repo root). Anchoring `path` to `HIGHWAY_ROOT` rather than to the skill
file's own directory means resolution is identical regardless of which directory the validating
tool is run from (FR-007) and regardless of how deeply nested the skill or the shared file is.

**Alternatives considered**:
- *Resolve relative to the skill's own directory.* Rejected: this reintroduces the exact
  stale-path risk feature 003's `path-integrity.test.sh` was built to catch — a path that
  happens to work from one working directory but not another.

## Decision 4: dependency errors are tagged `[DEPENDENCY]`, not a rule ID

**Decision**: A missing path or a version mismatch is reported as
`ERROR: [DEPENDENCY] <message>`, following the same tagged-finding-line convention
`validate-skill.sh` already uses for `[SCHEMA]` (structural checks with no owning rule ID).

**Rationale**: FR-005 through FR-007 and FR-015 are feature-level requirements about the
dependency mechanism itself; they are not constitution rule IDs, so tagging a finding with a
nonexistent rule ID would be misleading. `[SCHEMA]` already establishes the pattern of a
non-rule tag for structural requirements this same script enforces.

## Decision 5: the content listing is a new sibling artifact, reusing the catalog's generation pattern

**Decision**: `generate-content-catalog.sh` walks `.highway/content/{templates,knowledge,governance}/*.md`,
validates each file first via `validate-content.sh` (aborting with no partial write if any
fails, mirroring `generate-catalog.sh`'s existing all-or-nothing precedent), and writes
`.highway/catalog/content-index.json` (schema: `contracts/content-catalog.schema.json`) plus a
human-readable `.highway/catalog/content-index.md`.

**Rationale**: `.highway/catalog/` is already the established location for generated,
authoritative listings; placing the sibling artifact there instead of inventing a new directory
keeps one convention for "where generated indexes live." The schema is new and separate (not an
extension of `catalog.schema.json`) per the clarification answer, since that schema is
`additionalProperties: false` and shaped around skill-only fields (`compatibility`,
`overlap_flags`) that do not fit a governance or knowledge file.

**Alternatives considered**:
- *Add content entries into `catalog/index.json` directly.* Rejected by the clarification
  answer (Option B chosen over Option A).
- *No generated artifact; directory scan on demand only.* Rejected by the clarification answer
  (Option C was not chosen); FR-012 requires a listing operation, and a generated, committed
  artifact is consistent with how the skill catalog already satisfies the equivalent skill-side
  requirement.

## Decision 6: minimal content frontmatter reuses existing schema-validate.sh patterns where they fit

**Decision**: A new `lib/content-schema.sh` provides checks for the three required frontmatter
fields (`name`, `description`, `metadata.version`), tagging every finding `[SCHEMA]`. The
`description` length rule (non-empty, ≤500 characters) reuses the exact threshold
`sv_validate_description` already applies to skills, since the spec does not ask for a
different threshold for content files and introducing one would be an unstated, undecided
number.

**Rationale**: Consistency with the existing skill frontmatter contract avoids inventing a new
number with no citation. `metadata.version`'s semantic-version format check reuses the same
regex `rc_check_P7_2` already applies (`^[0-9]+\.[0-9]+\.[0-9]+$`), read as a shared constant
rather than duplicated, per the no-duplication rule this tooling holds itself to (P7.3-style
reasoning applied to the tooling's own code, not just to skills).

**Alternatives considered**:
- *No length limit on content `description`.* Rejected: an unbounded description is exactly the
  kind of unmeasurable, non-decidable rule the constitution's own Principle IV rejects for
  skills; the same reasoning applies here.

## Summary of resolved unknowns

| Unknown | Resolved by |
|---|---|
| Reference mechanism (spec FR-013, retired after resolution) | Clarification Q1 + Decision 2 |
| Frontmatter shape for content files | Clarification Q3 + Decision 6 |
| Rule scope per content type | Clarification Q2 + Decision 1 |
| Discovery/catalog mechanism | Clarification Q4 + Decision 5 |
| Dependency versioning | Clarification Q5 + Decisions 2–4 |

No `NEEDS CLARIFICATION` markers remain. Phase 1 may proceed.
