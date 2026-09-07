# Phase 0 Research: Help Output Namespacing

No `[NEEDS CLARIFICATION]` markers remain in spec.md, so this phase records the design
decisions needed to move from spec to data model/contracts.

## R1: Hyphen vs. dot as the namespace separator

**Decision**: `highway-<id>` (hyphen), replacing the `highway.<id>` (dot) form shipped by
specs/007-highway-skill-namespace, across all three in-scope agents (github-copilot,
claude-code, cursor).

**Rationale**: GitHub Copilot's published Agent Skills spec states a skill's `name` value must
consist of lowercase letters, numbers, and hyphens only — no dots, slashes, colons, or namespace
prefixes are permitted in that field — and separately requires `name` to match the skill's
parent directory name exactly. A directory named `highway.help` can never produce a `name` value
that satisfies both rules simultaneously: any spec-compliant `name` (hyphens only) can never
equal a dotted directory name. This is a structural incompatibility, not a style preference. No
equivalent research turned up a documented incompatibility or anti-pattern for a hyphen separator
on any of the three agents; Claude Code's own directory-is-the-command convention imposes no
character restriction beyond what a filesystem allows, and Cursor's `.mdc` rule files are keyed
by file name only (no `name` frontmatter field to conflict).

**Alternatives considered**:
- Keep the dot (`highway.help`) — rejected: violates the documented Copilot spec outright; the
  repository's own generated adapter for `help` would silently fail to load per that spec, even
  though today's implementation happens to tolerate it (undocumented, non-guaranteed behavior).
- Folder uses hyphens, but invocation uses dots (`highway-help` on disk, `/highway.help` typed) —
  researched directly by inspecting this repository's own vendored `speckit-*` tooling, which
  appears at first glance to support exactly this split (`speckit.specify` appears in
  `.specify/workflows/speckit/workflow.yml`'s `command:` keys and in every `speckit-*/SKILL.md`'s
  hook-handling section, while the directories are `speckit-specify` etc.). Confirmed this is not
  a real invocation alias: every `speckit-*/SKILL.md` explicitly instructs "When constructing
  command invocations from hook command names, replace dots (`.`) with hyphens (`-`)" before ever
  constructing a real invocation, and separately notes "the invocation may differ from the
  literal `{command}` id shown above". The dotted form (`speckit.specify`) is a workflow-engine-
  internal identifier (used only inside YAML configs and hook keys), always mechanically
  translated to a hyphen before being invoked for real; the real folder name and the real slash
  command are both hyphenated. No dot-invoke/hyphen-folder mechanism exists in either product
  researched. Rejected as unsupported.

## R2: Where does the help output's `Name:` value come from?

**Decision**: Computed as `highway-<id>` from the skill's catalog `id` field, at the time help
output is constructed — no longer copied verbatim from the skill's frontmatter `name` field (the
behavior specs/006's original contract established, and specs/007's contract left unchanged for
adapter-generation purposes).

**Rationale**: The frontmatter `name` field is documented in
`.highway/skills/_authoring-standard.md` as "Free-form display name. Never required to match the
directory-derived id" — by design, it can be anything (e.g. `Help`), so copying it verbatim into
help output cannot guarantee it matches the identifier a coding agent actually invokes. Computing
`Name:` from the same `id` field the adapter generator already namespaces (R1) guarantees the two
can never drift apart, without requiring every skill author to hand-author a redundant, easy-to-
forget-to-update namespaced display name.

**Alternatives considered**: Add a new frontmatter field (e.g. `display_id`) holding the
namespaced form — rejected: a second, hand-authored source of truth for a value that is a pure,
deterministic function of `id` (`highway-` + `id`) is exactly the kind of drift risk specs/006's
own R5 (the `Help:` field's derivation) already rejected for the same reason.

## R3: Where does the help output's `Usage:` value come from?

**Decision**: Stays an authored frontmatter field (`usage`, unchanged mechanism from specs/006
R1) — but its free-text content, wherever it names its own skill's invocation, MUST use that
skill's `highway-<id>` form. For this feature's actual scope, this means editing `help`'s own
`usage` string (the only skill under `.highway/skills/` today) to read using `/highway-help`
instead of `/help`.

**Rationale**: Unlike `Name:` (R2) and `Help:` (R4), `Usage:` is prose that describes *how and
when* to invoke a skill in the author's own words (for `help`, two distinct modes: "for all
skills" vs. "for one named skill") — this is not a pure function of `id` alone, so it cannot be
fully computed without losing that authored nuance. Making the invocation *token* inside that
prose correct is an authoring responsibility, the same way `.highway/skills/_authoring-standard.md`
already documents every other authored field's content rule.

**Alternatives considered**: Split `usage` into a computed invocation prefix plus authored
trailing prose, joined at render time — rejected: adds a second field and a concatenation rule
for one sentence's worth of savings, more complex than directly authoring the correct text.

## R4: What does the copy-able `Help:` command look like?

**Decision**: `/highway-help <id>`, replacing specs/006 R5's `/help <id>` — still computed at
response time from the catalog `id` field, never stored as its own catalog column. Unchanged
mechanism from R5; only the literal prefix changes, for the same reason as R2.

**Rationale**: Directly extends specs/006 R5's own rationale ("a deterministic, one-line function
of a field that already exists; storing a derived string separately would risk silent drift")
to the corrected, hyphen-namespaced prefix established by R1.

## R5: How does the `Example:` value become copy-able?

**Decision**: The invocation line inside a skill's `## Example` section MUST be presented as an
inline code span (backtick-wrapped), not as bare prose. Since specs/006 R2 already established
that the single-skill mode's `Example:` field is read directly from the target skill's own
`## Example` section at request time, formatting the source section this way is sufficient — no
separate transformation step is needed at render time.

**Rationale**: A fenced code block (already used for `help`'s worked example) is copy-able when a
human is reading the raw Markdown source, but once the `Example:` field is rendered as one line
of a six-line labeled response (as this feature's User Story 2/3 require), a fenced block cannot
be embedded inline — an inline code span is the only Markdown construct that stays copy-able
inside a single labeled line.

**Alternatives considered**: Keep the fenced block and accept prose-wrapped rendering for the
live `Example:` line — rejected: this is the exact defect the user reported (not independently
copy-able).

## R6: Skill versioning impact

**Decision**: `.highway/skills/help/SKILL.md`'s `metadata.version` bumps MAJOR, `1.0.0` →
`2.0.0`.

**Rationale**: The constitution's Definitions classify a "Breaking change" as one that "removes,
narrows, or redefines any element of a skill contract or behavioral guarantee," and its Skill
Versioning Policy reserves PATCH for "wording repair with no change to Inputs, Outputs, or
Verification." This feature changes the `## Inputs` section itself (the `Name:` field's Single-
Skill-mode value stops being read from frontmatter `name` and is instead computed from `id`, per
R2) and changes the literal, previously-documented output value of `Name:`, `Usage:`, `Help:`,
and `Example:` for every existing caller — an existing behavioral guarantee is replaced, not
merely added alongside, so MINOR does not apply either. This is a breaking change to the skill
contract and MUST increment MAJOR per P7.7.

**Alternatives considered**: PATCH — rejected: disqualified because `## Inputs` and `## Outputs`
both change, not just wording. MINOR — rejected: no prior behavior continues to hold unchanged
alongside the new one; the old `Name:`/`Usage:`/`Help:` values are replaced, not supplemented.

