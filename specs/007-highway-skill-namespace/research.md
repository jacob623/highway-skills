# Phase 0 Research: Highway Skill Namespace

## R1: What does a coding agent actually read as a skill's identifier?

- **Decision**: The coding-agent-facing identifier is derived from the generated adapter
  artifact's **directory/file path segment** (the `<id>` component of
  `generate-agent-adapters.sh`'s `AGENT_TARGET_TEMPLATES`), not from the frontmatter `name:`
  field inside the file.
- **Rationale**: Direct empirical evidence from this exact repository, observed in this
  session's own tool context. `.github/skills/help/SKILL.md` declares `name: Help` (capitalized)
  in its frontmatter, yet GitHub Copilot's own skill listing (surfaced to this session as
  `<skill><name>help</name>...</skill>`) shows `help` — all-lowercase, matching the **directory
  name**, not the frontmatter value. This directly falsifies the assumption (recorded in
  spec.md's Assumptions section) that the identifier comes from "a `name` frontmatter field for
  GitHub Copilot and Claude Code adapters"; it is superseded by this finding. No corresponding
  counter-example was found for Claude Code or Cursor, so the same directory/file-path mechanism
  is adopted for all three agents for consistency (FR-007's uniform-application requirement),
  since Cursor's `.mdc` format has no `name` field at all today (spec.md Edge Cases) and must
  already rely on some non-frontmatter signal — most plausibly its file name, matching the
  pattern.
- **Alternatives considered**:
  - *Rewrite the frontmatter `name:` field to `highway.<id>` during generation.* Rejected: the
    evidence above shows this field is not what the agent reads, so it would not satisfy FR-001
    at all. It would also break the `identity-copy` transform's existing byte-identical guarantee
    (specs/001 contract) for no benefit.
  - *Prefix only the Cursor rule's description text.* Rejected: does not address GitHub Copilot
    or Claude Code, violating FR-007's uniform-application requirement.

## R2: Where does the prefix get applied mechanically?

- **Decision**: Change the three `AGENT_TARGET_TEMPLATES` entries in
  `.highway/tools/generate-agent-adapters.sh` from `.github/skills/%s/SKILL.md`,
  `.claude/skills/%s/SKILL.md`, `.cursor/rules/%s.mdc` to `.github/skills/highway.%s/SKILL.md`,
  `.claude/skills/highway.%s/SKILL.md`, `.cursor/rules/highway.%s.mdc`. No other line in the
  script changes; `identity-copy` and `mdc-transform` keep copying/transforming file *content*
  unchanged (FR-004), only the destination *path* changes.
- **Rationale**: The script's own header comment states its extensibility contract: "adding an
  agent = one new row here, never an edit to skills/". Prefixing is the same class of change —
  one row edited, zero transform-logic edits — which keeps FR-002 (tooling applies the prefix
  automatically, no author action) and FR-004 (source untouched) trivially satisfied.
- **Alternatives considered**:
  - *Add a `--namespace` CLI flag.* Rejected: FR-007 requires uniform application with no
    per-skill or per-run opt-out; a flag would introduce exactly that.

## R3: What happens to the old, non-namespaced adapter files already on disk?

- **Decision**: When generating the namespaced replacement for a skill/agent pair,
  `generate-agent-adapters.sh` MUST also remove the previous (non-namespaced) artifact at its old
  path, but only after the same drift-safety check already used before overwriting
  (`check_no_drift`-equivalent: refuse if the old file is untracked by the manifest or its hash
  no longer matches the manifest's recorded hash), and MUST prune the old file's row from
  `.highway/tools/.adapter-manifest`.
- **Rationale**: SC-002 requires a developer to distinguish this project's skills "with zero
  ambiguity, by the presence of the `highway.` prefix alone". Leaving `.github/skills/help/`
  sitting alongside the new `.github/skills/highway.help/` would present the *same* skill twice
  — once unprefixed — directly contradicting SC-002 and re-introducing the exact collision risk
  the feature exists to remove. FR-005 already establishes that no migration/backward-compat
  handling is required, i.e. nothing prevents deletion; this decision goes one step further and
  makes deletion of the stale duplicate a requirement, not just a permission, because leaving it
  is actively harmful to SC-002.
- **Alternatives considered**:
  - *Leave old files in place, undocumented.* Rejected: produces a duplicate, unprefixed listing
    that defeats the feature's purpose (SC-002).
  - *Leave old files in place but add a warning comment inside them.* Rejected: the agent's
    listing is driven by path, not content (R1), so a comment would not stop the duplicate
    listing from appearing; it would only add clutter.

## R4: Test-suite impact

- **Decision**: `.highway/tools/tests/generate-agent-adapters.test.sh` and
  `.highway/tools/tests/new-agent-extensibility.test.sh` are the only two existing test files
  that hard-code the pre-namespace target paths (`GH_TARGET`, `CLAUDE_TARGET`, `CURSOR_TARGET`
  and equivalents); both must be updated to expect the `highway.<id>` form. No other test file
  under `.highway/tools/tests/` references a generated adapter path.
- **Rationale**: Confirmed by a repository-wide search of `.highway/tools/tests/*.test.sh` for
  `.github/skills/`, `.claude/skills/`, `.cursor/rules/`, and `AGENT_TARGET_TEMPLATES` occurrences
  during this planning phase.
- **Alternatives considered**: N/A — this is a factual inventory, not a design choice.

## Outcome

All NEEDS CLARIFICATION markers from the Technical Context are resolved (none were unresolved to
begin with; this feature's spec already fixed the scope and language during `/speckit.clarify`
via `vscode_askQuestions`, per the prior specify session). No open research question remains
before Phase 1.
