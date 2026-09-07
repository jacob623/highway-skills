# Phase 0 Research: Skill Id Namespace Alignment

No `[NEEDS CLARIFICATION]` markers were present in spec.md's Technical Context (the plan filled
it directly from established repo constraints — Bash 3.2.57, existing test harness, no new
dependency). The research below resolves design questions the spec deliberately left at the
"what", not "how", level.

## R1: How is `.highway/skills/help/` renamed to `.highway/skills/highway-help/` without breaking history or derived artifacts?

**Decision**: `git mv .highway/skills/help .highway/skills/highway-help`, then edit the moved
`SKILL.md`'s frontmatter `name` and the body text that names its own id/path, then regenerate
`.highway/catalog/index.json` and the agent adapters from the moved file.

**Rationale**: `git mv` preserves file history (rename detection) and is the same reversible,
local operation every prior feature in this repo used for file-level changes. Nothing reads
`.highway/skills/help/` by a mechanism other than directory globbing
(`shopt -s nullglob; skill_dirs=("$SKILLS_DIR"/*/)` in both `generate-agent-adapters.sh` and
`generate-catalog.sh`) plus `basename` to derive the id — so the rename alone, with no code
change, already produces the new id everywhere id is derived from the directory.

**Alternatives considered**:
- Leave the directory named `help/` and only change frontmatter `name` — rejected: this is
  exactly the ambiguity spec.md's User Story 1 exists to remove; the directory name is defined
  (by `_authoring-standard.md` and `validate-skill.sh`'s `id="$(basename "$skill_dir")"`) as the
  sole source of a skill's id, so leaving it unrenamed would leave `id` and `name` aligned with
  each other but still misaligned with the actual agent-facing identifier.
- Copy to a new directory and delete the old one as two separate steps — rejected: functionally
  identical to `git mv` but loses rename detection in history for no benefit.

## R2: How do the generated agent adapter paths stay correct once the source id already includes the `highway-` prefix?

**Decision**: Change `AGENT_TARGET_TEMPLATES` in `generate-agent-adapters.sh` from
`.github/skills/highway-%s/SKILL.md` (etc.) to `.github/skills/%s/SKILL.md` (etc.) — drop the
static `highway-` the template used to inject, since the `%s` substitution (the id, taken from
the directory name) now already carries it.

**Rationale**: The current template computes the agent-facing path by concatenating a
hard-coded `highway-` with the bare id (`help` → `highway-help`). Once the source directory
itself is named `highway-help`, keeping that same template would substitute the *already
namespaced* id into a template that *also* injects the prefix, producing
`.github/skills/highway-highway-help/SKILL.md` — a double-prefix regression. Dropping the
injected prefix from the template restores the correct, single-prefixed path, and because the
id changed from `help` to `highway-help` at exactly the same time the template's static segment
was removed, **the final resolved path is byte-identical to what specs/008 already produced**
(`.github/skills/highway-help/SKILL.md`, `.claude/skills/highway-help/SKILL.md`,
`.cursor/rules/highway-help.mdc`). No existing generated adapter needs to move; only its
content is regenerated (frontmatter `name`, `## Example`, `## Verification` text change on the
source side).

**Alternatives considered**:
- Keep the `highway-%s` template and strip the prefix back off the id before substitution (e.g.
  `id#highway-`) — rejected: reintroduces a compute-the-namespace-at-generation-time step, which
  is precisely the indirection this feature exists to remove (spec.md Assumptions: "this feature
  ... does not change what that identifier is, only where it is authored").
- Detect and skip already-prefixed ids to avoid double-prefixing defensively, while keeping the
  old template for ids that are not yet migrated — rejected: adds a permanent conditional for a
  transitional state (mixed migrated/unmigrated skills) that this feature closes out completely
  in one pass (only one skill exists); unjustified complexity for zero remaining use case.

## R3: What happens to the `AGENT_OLD_TARGET_TEMPLATES` / stale-removal mechanism specs/008 added?

**Decision**: Retire it — remove `AGENT_OLD_TARGET_TEMPLATES` and the
`check_stale_removable`/`remove_stale_target` functions and their call sites from
`generate-agent-adapters.sh`.

**Rationale**: That mechanism existed for exactly one purpose: cleaning up the dot-separated
duplicate (`highway.help`) specs/007's original scheme left behind when specs/008 switched to
hyphens. That cleanup already ran and specs/008's quickstart confirmed zero dot artifacts
remain. This feature (per R2) produces byte-identical target paths to what already exists —
there is no new stale duplicate to detect or remove, and no future migration of this same shape
is anticipated (the whole point of this feature is that the source directory is now the single,
permanent source of the namespaced id, so there is no more "compute a different path" step left
to migrate away from again). Keeping unused stale-removal code and an empty
`AGENT_OLD_TARGET_TEMPLATES` array around would be dead weight with no remaining caller.

**Alternatives considered**:
- Keep the mechanism, generalized, for any future skill migration — rejected as speculative;
  nothing in spec.md calls for a general migration framework, and adding one would be
  over-engineering for a one-time, already-completed transition.

## R4: What tier and mechanism validates `name` MUST equal the directory-derived id?

**Decision**: Add `sv_validate_name()` to `.highway/tools/lib/schema-validate.sh`, tagged
`[SCHEMA]` (not a constitution principle id), following the exact precedent of
`sv_validate_id`/`sv_validate_description`/`sv_validate_usage`/`sv_validate_compatibility` — a
pure string-equality check with no judgment call, called from `validate-skill.sh` alongside the
other schema-level checks.

**Rationale**: `[SCHEMA]`-tagged checks in this codebase are exactly the checks that are fully
decidable by direct comparison and are not tied to a specific constitution principle id (id
kebab-case shape, description/usage length, compatibility enum membership). `name == id` is the
same kind of check — a direct string comparison with no ambiguity — so it belongs in the same
file, at the same tier, with no constitution amendment needed (avoids the P7.3 risk of adding a
rule id that then has to be kept in sync across two documents).

**Alternatives considered**:
- Add a new constitution principle/rule id (e.g. a `P1.5`) for this — rejected: the constitution
  reserves rule ids for principles requiring the Tier/Observable apparatus (`[auto]` /
  `[agent-checkable]` / `[human-review]`) used for constitution-governed rules; a pure schema
  shape check (like id format) is deliberately kept out of that apparatus in the existing code,
  and this check has the identical decidability profile.
- Enforce only as `[human-review]` guidance in `_authoring-standard.md` with no automated check —
  rejected: spec.md's User Story 3 explicitly requires the validator to reject a mismatch
  (Acceptance Scenario 2), not merely document a convention.

## R5: What is the `help` skill's own version bump classification?

**Decision**: MAJOR (`2.0.0` → `3.0.0`).

**Rationale**: Per the constitution's Skill Versioning Policy (`.specify/memory/constitution.md`
line ~419) and P7.7, a breaking change is "a change that removes, narrows, or redefines any
element of a skill contract or behavioral guarantee" (Definitions). This feature changes two
elements of the `help` skill's own contract: (1) the previously-valid self-invocation
`/highway-help help` becomes an unrecognized-identifier error — a declared input value is
removed; (2) the `Name:` output field's computation changes from a `highway-<id>`
string-concatenation (specs/008) to a verbatim catalog `id` read — a redefinition of an output's
computation, per the contract in help-output-contract.md. Both are breaking changes under the
constitution's own definition, so MAJOR applies, not MINOR (no existing contract element "still
holds" per the MINOR definition — the self-invocation value literally stops working) or PATCH
(Inputs and Outputs both change, and PATCH requires no change to Inputs/Outputs/Verification).

**Alternatives considered**: MINOR — rejected because the MINOR definition requires every
existing contract element to continue to hold, and `/highway-help help` ceasing to resolve
violates that directly. This mirrors the lesson recorded from specs/008: verify against the
constitution's literal Skill Versioning Policy text, not by analogy to the size of the diff.
