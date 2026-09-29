# Research: Deliver Highway Skills to Cursor as Skills, Not Rules

No `NEEDS CLARIFICATION` markers remained after `/speckit-clarify`. The items below resolve the
technical unknowns the plan had to settle, and record what planning found in the current tree.

## Measured baseline (current tree, 2026-09-29)

| Fact | Value | Evidence |
|---|---|---|
| Source skills | 12 | `.highway/skills/*/SKILL.md` |
| Tracked `.cursor/rules/*.mdc` files | 13 (12 adapters + 1 fixture leftover) | `git ls-files .cursor` |
| Adapter manifest rows | 48 (12 skills x 3 agents, plus 12 `.mock-agent-4` rows) | `.highway/tools/.adapter-manifest` |
| Adapter manifest rows for `.cursor/rules/` | 12 | same |
| Fixture leftover `test-catalog-fixture-20649` | Committed in `.github/`, `.claude/` and `.cursor/rules/`; no source, no catalog entry, no manifest row | `git ls-files`, manifest grep |
| Fixture leftover rule file sha256 | `60826b120becb64a3a2b971b30b3230250da19719cc14dd2750fce5f03527392` | `shasum -a 256` |
| Distribution rows for `.cursor/rules/` | 12 per-file includes, under `exclude .cursor` | `.distribution-manifest` |
| `speckit-*` skills already in `.cursor/skills/` | 10, untracked | Spec Kit `cursor-agent` integration |

## Decision 1: Cursor row becomes a plain copy to `.cursor/skills/<id>/SKILL.md`

- **Decision**: Set the Cursor row to `.cursor/skills/%s/SKILL.md` with `identity-copy`, the same
  transform the Claude Code and Copilot rows use.
- **Rationale**: FR-001 and FR-002 require a byte-identical deliverable. Identity copy is the
  smallest change and makes the three agents' deliverables provably equal, so one comparison test
  covers all of them.
- **Evidence Cursor accepts the unchanged frontmatter**: the Highway `SKILL.md` files are already
  loaded as skills in a Cursor session today, through the `.claude/skills/` compatibility path,
  with their `usage` and `metadata.version` fields present. The `speckit-*` skills, which use the
  same `name`, `description`, `compatibility` and `metadata` keys, load from `.cursor/skills/`.
- **Residual risk**: Cursor's skill loader may ignore the Highway-specific `usage` key. That would
  be harmless (ignored, not rejected), and the spec assumes a rejection would be a separate finding.
- **Alternatives considered**:
  - *Keep `mdc-transform` and add a skill row*: emits each skill to Cursor twice and leaves the
    lossy conversion in place. Rejected by the spec.
  - *Symlink `.cursor/skills` to `.claude/skills`*: breaks the generator's per-target hash
    tracking and the drift refusal, and is fragile on checkout.
  - *Rely on Cursor's `.claude/skills/` compatibility and emit nothing*: makes Cursor delivery
    implicit and untestable, and is contrary to the spec's purpose.

## Decision 2: Remove `transform_mdc` and the `mdc-transform` case; keep the three arrays

- **Decision**: Delete the unused function and case branch (FR-003). Keep `AGENT_IDS`,
  `AGENT_TARGET_TEMPLATES` and `AGENT_TRANSFORMS` as three single-line arrays, with `identity-copy`
  remaining as the one transform.
- **Rationale**: `new-agent-extensibility.test.sh` proves that adding an agent is one row by
  rewriting those arrays with `sed -e 's/^AGENT_IDS=(\(.*\))$/...'`. The anchors require each array
  to stay on one line. The `AGENT_TRANSFORMS` array and the `case` dispatch also remain the
  extension seam for a future agent that needs a conversion.
- **Alternatives considered**: Collapsing the transform array away because every row is now
  `identity-copy` was rejected: it would change the documented extension mechanism and break that
  test for no gain.

## Decision 3: Distribution rows become per-skill directory includes

- **Decision**: Replace the 12 `include .cursor/rules/highway-*.mdc` rows with 12
  `include .cursor/skills/highway-*` directory rows. Keep `exclude .cursor`.
- **Rationale**: This mirrors how `.claude/skills` and `.github/skills` are already declared, and
  classification is by longest matching prefix, so `.cursor/skills/highway-help` covers its
  `SKILL.md` while `.cursor/skills/speckit-*` still falls under `exclude .cursor`. The single
  declaration stays in one place (D1.6). A path matching no record fails as unclassified, so no
  new path can slip through, and none is left unclassified here because `.cursor` already covers
  every descendant.
- **Alternatives considered**: One `include .cursor/skills` row with per-`speckit` excludes was
  rejected: it would default new tools' skills to shipped, and the manifest's own comment says a new
  directory must be classified deliberately rather than defaulting to either answer.

## Decision 4: Migration is a temporary, hash-checked, manifest-driven script

- **Decision**: A one-time script at `specs/097-cursor-skills-adapter/migrate-cursor-rules.sh`,
  removed as the final task (FR-017).
  - Reads every adapter manifest row whose path begins `.cursor/rules/`.
  - Deletes the file and drops its row only when the file's sha256 equals the recorded hash.
  - Leaves an edited file and its row, reports it, and exits non-zero (Q2 = B).
  - Also handles one named orphan, `.cursor/rules/test-catalog-fixture-20649.mdc`, against the
    fixed hash recorded above, because it has no manifest row to key on.
  - Never reads or deletes any other `.cursor/rules/` file (FR-007).
- **Rationale**: Deriving the deletion set from the manifest reuses the record of what the
  generator produced, which is exactly the authority `adapter-coverage.test.sh` already treats as
  "ours". A hash check gives the same safety the generator's drift refusal gives. A fixed hash for
  the single orphan keeps the allowlist as strict as the manifest-driven path.
- **Rationale for a temporary script**: The generator is not allowed to gain removal behavior
  (FR-017, Q3 = A), and a permanent tool for a finite legacy set was rejected by the maintainer.
  The script sits beside the spec, outside the distributed set, so it cannot ship.
- **Toolchain**: Bash 3.2, the declared toolchain, no `git`. Manifest is rewritten via `mktemp` and
  `mv`, as the generator does.
- **Alternatives considered**:
  - *Delete `.cursor/rules/*.mdc` by glob*: would also remove hand-written rules; violates FR-007.
  - *Manual `rm` commands*: not repeatable after a hand-edit is resolved, and leaves no report.
  - *Put the logic in the generator*: rejected by Q3.
  - *A permanent test for the script*: impossible once the script is removed. Its behavior is
    instead proved by a seeded run against a temporary copy (see quickstart.md), and the durable
    guarantee, "no Highway rule file is left or regenerated", is asserted by a permanent test.

## Decision 5: Test changes, with the reason for each superseded assertion (D3.5)

| File | Change | Superseded behavior recorded as the reason |
|---|---|---|
| `generate-agent-adapters.test.sh` | Replace the `alwaysApply`, `globs`, description-only and body-copied assertions with a byte-identity check of `.cursor/skills/$TMP_ID/SKILL.md`; add no-`.cursor/rules/` assertion; add a `speckit-*` sentinel under `.cursor/skills/` alongside the existing `.github/skills` one | The rule conversion no longer exists; the four assertions describe it |
| `adapter-coverage.test.sh` | `adapter_paths` -> `.cursor/skills/$id`; `adapter_files` -> `.cursor/skills/$id/SKILL.md`; orphan `case` `.cursor/rules/*.mdc` -> `.cursor/skills/*` | Correspondence now targets the skill location; the check itself is unchanged |
| `new-agent-extensibility.test.sh` | Cleanup path `.cursor/rules/$TMP_ID.mdc` -> `.cursor/skills/$TMP_ID` | The fixture is now written there |
| `highway-new.test.sh` | Expected distribution-manifest path -> `.cursor/skills/highway-new` (a directory row, like its `.github` and `.claude` siblings) | The distribution row moved |
| `feature-038-helpers.sh` | `cursor` key -> `.cursor/skills/` | Currency of a path helper; no caller depends on the old value |
| `run-all.sh` | Residue sweep `.cursor/rules/test-adapter-fixture-*.mdc` -> `.cursor/skills/test-adapter-fixture-*` | Test-created fixtures are written to the new location |

Not changed, deliberately:

- `fixtures/profile-092/impact-review.tsv` and `dependent-artifact-inventory.tsv` name
  `.cursor/rules/highway-profile.mdc`. They are feature 092's recorded evidence. The only test that
  reads them, `feature-092-correspondence.test.sh`, asserts that they contain generator names and
  `PASS`, not those paths, so leaving them cannot fail it and rewriting them would falsify a record.
- Historical specs under `specs/` (spec assumption).

## Decision 6: Documentation edits

| Document | Change |
|---|---|
| `README.md` line 16 | `.cursor/rules/` -> `.cursor/skills/` |
| `.highway/DISTRIBUTION.md` line 18 | `.cursor/rules/` -> `.cursor/skills/`; add one note (FR-016) that an older install's `.cursor/rules/<id>.mdc` Highway files are superseded and can be deleted. Wording must not contain `specs/` or `.specify/` (D1.1); this file ships as the distribution's `README.md`. |
| `.highway/tools/README.md` line 64 and 71-72 | Cursor path -> `.cursor/skills/<id>/SKILL.md`; the sentence "Never reads or writes existing `.github/skills/speckit-*` folders" is widened to cover `.cursor/skills/speckit-*` |
| `.specify/memory/constitution.md` | **No edit.** It names the agent tree `cursor` by id only. Editing it would force a Sync Impact Report and a version bump for no accuracy gain. |
| `.highway/skills/_authoring-standard.md` | **No edit.** Its `cursor` mentions are `compatibility` values, not paths. |

## Decision 7: Order of operations

Migration must run after the generator change and before the final regeneration:

1. Baseline: `run-all.sh` passes (D3.1); record it.
2. Amend tests so they fail against the old generator (D3.6).
3. Change the generator; regenerate; the Cursor deliverables and manifest rows appear.
4. Run the migration; it removes the rule files and their rows; resolve any reported edit and re-run.
5. Update the distribution manifest and documents.
6. Regenerate all declared generators; confirm no diff (D4.4, D4.7).
7. Full suite passes (D3.2). Delete the migration script (FR-017).

The generator's drift check iterates only its own targets, so it never trips over an old
`.cursor/rules/` row that has not been migrated yet.

## Observations recorded, out of scope

- **Fixture orphans in `.github/` and `.claude/`.** `test-catalog-fixture-20649` is committed
  there with no source. Left as they are (spec assumption).
- **`.mock-agent-4` rows persist in the adapter manifest.** `new-agent-extensibility.test.sh`
  removes rows only for its own temporary id, so 12 rows naming real skills under a mock agent
  remain. `adapter-coverage.test.sh` skips non-declared trees, so nothing fails. The migration
  script must preserve these rows exactly. Running the suite can re-add them, so the manifest diff
  is checked after each suite run.
- **Possible duplicate listing in Cursor** through `.claude/skills/` is accepted by clarification
  Q1 and recorded as an observation, not resolved.
