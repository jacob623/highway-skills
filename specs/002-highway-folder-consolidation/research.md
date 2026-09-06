# Phase 0 Research: Consolidate Skill Suite Support Files into `.highway/`

No `[NEEDS CLARIFICATION]` markers remain in the Technical Context (see plan.md); this document
records the concrete technical decisions needed to execute the move safely.

## Decision 1: Dual-root resolution in relocated scripts

**Decision**: Each script under `.highway/tools/` computes two distinct root variables instead
of one:
- `HIGHWAY_ROOT` — the `.highway/` directory itself, computed as `$SCRIPT_DIR/..` (since the
  script now lives at `.highway/tools/<script>.sh`).
- `REPO_ROOT` — the true repository root, computed as `$HIGHWAY_ROOT/..`.

`HIGHWAY_ROOT` is used for everything that reads or writes skill-suite-internal content
(`$HIGHWAY_ROOT/skills`, `$HIGHWAY_ROOT/catalog`, `$HIGHWAY_ROOT/tools/.adapter-manifest`).
`REPO_ROOT` is used only for the three agent adapter target paths
(`.github/skills/`, `.claude/skills/`, `.cursor/rules/`), which do not move.

**Rationale**: Before this feature, `tools/`'s parent directory *was* the repository root, so a
single root variable worked for both purposes. After the move, `tools/`'s parent
(`.highway/`) and the true repository root are one level apart. Keeping this distinction
explicit as two named variables (rather than one variable reused for both purposes) keeps every
downstream path expression obviously correct and matches this repo's existing style of deriving
roots via `cd .. && pwd` rather than hardcoding path depth.

**Alternatives considered**:
- *Hardcode `../..` inline at each use site*: rejected — duplicates a "magic" depth constant
  across many call sites, making a future re-nesting error-prone.
- *Introduce an environment variable or config file declaring the repo root*: rejected — adds a
  configuration surface with no present need, since the directory nesting is fixed and fully
  knowable from `SCRIPT_DIR` alone.
- *Keep a single root variable and special-case the three adapter paths*: rejected — this is
  what the current code already avoids by naming both roots; special-casing three path
  expressions is more error-prone than naming the second root once.

## Decision 2: Moving files with no git history to preserve

**Decision**: Perform the move as a plain filesystem operation (`mkdir -p .highway && mv skills
tools catalog .highway/`), then stage the result normally. No `git mv`-specific rename-tracking
technique is required.

**Rationale**: Inspecting the repository's current state shows a single initial commit
containing only the placeholder root `README.md`; `skills/`, `tools/`, and `catalog/` (created
during the prior feature's implementation) are still untracked (`git status` reports them as
`??`). There is no committed history under the old paths to preserve, so a plain move is
sufficient and no special git rename-detection handling is needed.

**Alternatives considered**:
- *Use `git mv` for each file*: unnecessary given nothing under the old paths is tracked yet;
  harmless but adds no value over a plain `mv` in this specific repository state. (If this
  repository state changes before implementation — i.e., these directories get committed first
  — implementation should prefer `git mv` at that point purely as good practice, though it has
  no bearing on this feature's functional requirements.)

## Decision 3: Manifest and test fixture paths

**Decision**: `tools/.adapter-manifest` moves to `.highway/tools/.adapter-manifest` unchanged in
format (still tab-delimited `rel_path\tskill_id\tskill_version\tsha256`, where `rel_path` remains
relative to `REPO_ROOT`, e.g. `.github/skills/<id>/SKILL.md`, since that is what it tracks).
Test fixtures under `tools/tests/fixtures/` move unchanged (content-only) to
`.highway/tools/tests/fixtures/`.

**Rationale**: The manifest's job (detecting drift in agent-adapter output files) is unaffected
by where the manifest itself lives, since its recorded paths are already `REPO_ROOT`-relative,
not relative to the manifest's own location. Fixtures are pure test data with no path
dependencies of their own; they only need their referencing test scripts updated.

**Alternatives considered**:
- *Reset/regenerate the manifest instead of relocating it*: rejected — unnecessarily discards
  already-correct drift-detection state for no benefit; a plain relocation preserves it for free.

## Decision 4: Documentation update scope

**Decision**: Update path references in exactly these docs: root `README.md` (stays at repo
root, links updated), `.highway/tools/README.md`, `.highway/catalog/README.md`,
`.highway/skills/_authoring-standard.md`. `specs/001-multi-agent-skill-suite/*` (spec, plan,
research, data-model, contracts, quickstart, tasks) are left as an unmodified historical record
of the feature as originally planned and implemented; they are not "live" documentation that a
user follows to operate the current tooling.

**Rationale**: Matches FR-008 (fix docs a user would actually follow today) and SC-004 (zero
stale references in *tracked documentation*), while preserving the historical accuracy of the
prior feature's own planning artifacts — rewriting history to match a later structural change
would misrepresent what was actually decided and built at the time.

**Alternatives considered**:
- *Also rewrite `specs/001-multi-agent-skill-suite/*` paths*: rejected — these are dated planning
  records of a completed feature, not operational documentation; the quickstart.md skill run-book
  is what matters going forward, and the plan already excludes `specs/` from relocation for the
  same reason (spec-kit scaffolding, historical record).
