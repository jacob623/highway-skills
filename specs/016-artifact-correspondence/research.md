# Research: Generated Artifact Correspondence

**Feature**: 016-artifact-correspondence | **Date**: 2026-09-08

Three questions were open after the spec. All three are now resolved by measurement rather than
reasoning, and the third changed the shape of the feature.

---

## R1 — How can a currency check regenerate without dirtying the working tree?

**Decision**: Copy `.highway/` into a temporary directory and run the generators *there*, then
compare the temporary output against the committed artifacts. Never regenerate in place.

**Rationale**: All three generators resolve every path from their own script location:

| Generator | Root resolution |
|---|---|
| `generate-catalog.sh` | `HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"` |
| `generate-library-catalog.sh` | same |
| `generate-agent-adapters.sh` | same, plus `REPO_ROOT="$HIGHWAY_ROOT/.."` |

So a copy of the tree is fully self-relocating: nothing reaches back to the original. Verified
2026-09-08 by prototype — both generators ran cleanly inside a temp tree, the adapters landed at
`$TMP/.github/skills/` rather than in the repository, the temp catalog matched the committed one,
and the real tree was untouched.

This makes FR-012 structural rather than disciplinary. A backup-and-restore approach would leave
the tree dirty if the test were interrupted between the two steps; with a temp tree the worst
outcome of an interruption is an orphaned directory under `/tmp`.

**Alternatives rejected**:

- *Regenerate in place, diff, restore from backup.* Correct only if the restore always runs. An
  interrupt, a `set -e` exit, or a failed assertion between the two leaves the repository modified.
  The failure mode is silent and lands on the next person.
- *Add an output-root flag to each generator.* More invasive, changes three shipped scripts, and
  buys nothing the temp tree does not already give.

---

## R2 — Which generators does D4.7 cover?

**Decision**: The catalog, library catalog, and agent adapter generators. `generate-distribution.sh`
is **excluded**.

**Rationale**: Verified 2026-09-08 — `generate-distribution.sh` takes a target directory as an
argument (`Usage: .highway/tools/generate-distribution.sh <target-directory>`) and writes a tree
outside the repository. It produces no committed artifact, so "no diff against the committed
artifacts" has no referent for it. Its correctness is already covered by D1.2 and D4.3 and by
`distribution-packaging.test.sh`.

The spec recorded this as an assumption; it is now confirmed.

---

## R3 — Does D4.7 pass today? **No. It does not.**

**Finding**: The committed library catalog is **stale**. Feature 015 added
`.highway/library/templates/requirements-inquiry.md` and never regenerated the library catalog, so
`.highway/catalog/library-index.json` records `"entries": []`. The questionnaire that feature
exists to deliver is absent from the library index.

The full suite passes at 17/17 with that defect present, because nothing checks library catalog
currency — which is precisely the gap D4.7 names.

**How it was found**: not by looking for it. The prototype for R1 regenerated into a temp tree and
the comparison against the committed artifacts came back different. The check found a real defect
the first time it was run, before it was even written as a test.

**Consequence for the amendment**: under the versioning policy, MAJOR is "an obligation is
strengthened so that previously conforming work now fails". Enabling D4.7 against a stale catalog
would do exactly that. Two routes:

| Route | Result |
|---|---|
| Enable D4.7 as-is | The amendment is **MAJOR**, `1.1.0 → 2.0.0`, and the suite goes red on enablement |
| **Repair first, then enable** | The violation is a defect to fix, not a reason to redefine the rule. The amendment stays **MINOR**, `1.1.0 → 1.2.0` |

**Decision**: repair first. The repair is one regeneration and is already applied in the working
tree; the library catalog was re-verified current on 2026-09-08 after the fix. D4.7 is therefore
enabled against a conforming tree and the MINOR classification in FR-005 holds.

**This is also the strongest available argument for the rule.** The defect was introduced by the
immediately preceding feature, by a maintainer who had just been reasoning carefully about exactly
this class of problem, and it survived a full green suite and a commit.

---

## R4 — How should the manifest ordering churn be handled?

**Decision**: Exclude `.adapter-manifest` from the D4.7 currency comparison. Compare generated
*content* — the catalogs and the adapter files — not the hash record.

**Rationale**: Verified 2026-09-08 that `.adapter-manifest` carries three `.mock-agent-4/` rows
left by `new-agent-extensibility.test.sh`, with no such directory on disk, and that regenerating
after the suite has run reorders those rows while a second run is stable. A byte-diff over the
manifest therefore returns a different verdict depending on whether the suite ran first.

The manifest's own integrity is already covered: D4.3 makes the generator refuse to overwrite a
target it did not produce, and that is decided by `generate-agent-adapters.test.sh`. Diffing it
again here would add flakiness while asserting a property another check already owns.

The manifest is still in scope for **D4.6** — an orphan row naming a skill with no source is a
correspondence failure, and that check is order-independent because it asks which skill each row
names rather than comparing bytes.

**Alternatives rejected**:

- *Sort both sides before diffing.* Handles ordering but not the fixture rows, and hides genuine
  reordering bugs.
- *Strip mock rows before comparing.* Requires the check to know about a fixture, coupling a
  general rule to one test's leftovers.

---

## R5 — What does "an adapter in each agent tree" mean?

**Decision**: The three declared agents — `github-copilot`, `claude-code`, `cursor` — taken from
`AGENT_IDS` in `generate-agent-adapters.sh`. Mock trees are fixtures and are not required to hold
adapters.

**Rationale**: `adapter-coverage.test.sh` already encodes these three paths. Extending that same
list keeps one definition rather than introducing a second that can drift from it.

**Note for implementation**: the existing test hard-codes the three adapter paths in its own
`adapter_paths()` function, duplicating `AGENT_TARGET_TEMPLATES` in the generator. That duplication
predates this feature and is a latent D1.6 concern — a fourth agent would need adding in two
places. Worth recording, out of scope to fix here.
