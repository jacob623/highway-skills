# Quickstart: Validate the Cursor Skills Adapter

Run these from the repository root. They prove the feature end to end and are ordered so each step
can be observed to fail before the change (D3.6) and pass after. Contract details live in
[contracts/cursor-adapter-contract.md](./contracts/cursor-adapter-contract.md) and
[contracts/migration-contract.md](./contracts/migration-contract.md); the entities are in
[data-model.md](./data-model.md).

## Prerequisites

- Bash and the standard utilities already required by the repository. Nothing to install.
- A clean working tree for `.highway/`, `.cursor/rules/` and `.highway/tools/.adapter-manifest`
  (the Spec Kit changes elsewhere in the tree are unrelated and stay uncommitted).
- Snapshot the Spec Kit skills for the non-interference check:

```sh
find .cursor/skills -name SKILL.md -path '*speckit-*' -print0 | xargs -0 shasum -a 256 | sort > /tmp/speckit-cursor-before.txt
wc -l < /tmp/speckit-cursor-before.txt   # expect 10
```

## 0. Baseline (D3.1)

```sh
.highway/tools/tests/run-all.sh          # expect exit 0; allow up to 240 seconds
git diff --stat .highway/tools/.adapter-manifest   # note any change the suite itself made
```

## 1. Cursor deliverable is a byte-identical skill (US1, FR-001, FR-002, FR-003)

After the generator change and regeneration:

```sh
for d in .highway/skills/highway-*/; do
  id=$(basename "$d")
  cmp -s ".cursor/skills/$id/SKILL.md" ".claude/skills/$id/SKILL.md" || echo "DIFFERS: $id"
  cmp -s ".cursor/skills/$id/SKILL.md" ".highway/skills/$id/SKILL.md" || echo "DIFFERS FROM SOURCE: $id"
done                                                  # expect no output
ls .cursor/skills | grep -c '^highway-'               # expect 12
grep -c 'mdc-transform\|transform_mdc' .highway/tools/generate-agent-adapters.sh   # expect 0
grep -c '^usage:' .cursor/skills/highway-help/SKILL.md                             # expect 1
```

Expected before the change: no `.cursor/skills/highway-*` exists, so the loop reports every id.

## 2. Migration, proved on a temporary copy first (US2, FR-006, FR-007, FR-017)

Run against a copy so each case is seeded without touching the real tree:

```sh
T=$(mktemp -d) && cp -R .highway .cursor specs "$T"/ && cd "$T"
```

| Case | Seed | Expected |
|---|---|---|
| Clean | none | Exit 0, 12 `REMOVED` lines, one `REMOVED` for the fixture leftover, `MIGRATION COMPLETE` |
| Edited adapter | `printf '\nedit\n' >> .cursor/rules/highway-help.mdc` | Exit 1, that file kept and reported `EDITED`, the other 11 removed, `MIGRATION INCOMPLETE` |
| Re-run after resolving | delete the edited file, run again | Exit 0, its row dropped, `MIGRATION COMPLETE` |
| Foreign rule | `echo x > .cursor/rules/hand-written.mdc` | File unchanged, never named in the output |
| Edited leftover | `printf 'x' >> .cursor/rules/test-catalog-fixture-20649.mdc` | Exit 1, reported `EDITED`, kept |
| Preservation | none | `diff` of manifest rows not starting `.cursor/rules/` shows no change, `.mock-agent-4` rows included |
| Idempotent | run twice on a clean copy | Second run changes nothing, exits 0 |
| Missing manifest | delete `.highway/tools/.adapter-manifest` | Exit 1, nothing changed |

Then discard the copy: `cd - && rm -rf "$T"`.

## 3. Real migration and regeneration (FR-006, FR-008, FR-015)

> The migration ran once and its script was removed (T030), so step 2 and the migration command
> below cannot be re-run; they are the record of how it was verified, kept in
> [evidence.md](./evidence.md). The regeneration and idempotence checks remain repeatable.

```sh
bash specs/097-cursor-skills-adapter/migrate-cursor-rules.sh; echo "exit=$?"    # expect 0
ls .cursor/rules 2>/dev/null | grep -c 'highway-\|test-catalog-fixture'         # expect 0
grep -c '^\.cursor/rules/' .highway/tools/.adapter-manifest                     # expect 0
grep -c '^\.cursor/skills/highway-' .highway/tools/.adapter-manifest            # expect 12
.highway/tools/generate-catalog.sh && .highway/tools/generate-library-catalog.sh && .highway/tools/generate-agent-adapters.sh
git status --short .highway .cursor > /tmp/097-after-run-1.txt
.highway/tools/generate-catalog.sh && .highway/tools/generate-library-catalog.sh && .highway/tools/generate-agent-adapters.sh
git status --short .highway .cursor > /tmp/097-after-run-2.txt
diff /tmp/097-after-run-1.txt /tmp/097-after-run-2.txt && echo IDEMPOTENT   # expect IDEMPOTENT
shasum -a 256 .cursor/skills/highway-*/SKILL.md | shasum -a 256   # run twice; the two values must match
```

## 4. Spec Kit coexistence (US3, FR-005)

```sh
find .cursor/skills -name SKILL.md -path '*speckit-*' -print0 | xargs -0 shasum -a 256 | sort | diff - /tmp/speckit-cursor-before.txt && echo UNCHANGED
```

An untracked-collision case, in a temporary copy: create `.cursor/skills/highway-help/SKILL.md` with
different content and no manifest row, run the generator, and expect a non-zero exit that names the
file, with the file's content unchanged.

## 5. Distribution (US3, FR-009, FR-010)

```sh
D=$(mktemp -d)/dist && .highway/tools/generate-distribution.sh "$D"; echo "exit=$?"   # expect 0
find "$D/.cursor" -maxdepth 2 | sort
ls "$D/.cursor/skills" | grep -c '^highway-'          # expect 12
ls "$D/.cursor/skills" | grep -c '^speckit-'          # expect 0
find "$D" -name 'migrate-cursor-rules.sh' | wc -l     # expect 0
grep -rl 'specs/\|\.specify/' "$D/README.md" | wc -l  # expect 0 (the FR-016 note stays clean)
```

## 6. Tests and documents (US4, FR-011 to FR-014)

```sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/generate-agent-adapters.test.sh
.highway/tools/tests/new-agent-extensibility.test.sh
.highway/tools/tests/highway-new.test.sh
.highway/tools/tests/distribution-packaging.test.sh
.highway/tools/tests/shipped-tree-independence.test.sh
rg -n '\.cursor/rules|\.mdc' README.md .highway/DISTRIBUTION.md .highway/tools/README.md
```

Each test exits 0. The final search reports only the one deliberate FR-016 note in
`.highway/DISTRIBUTION.md`; nothing in `README.md` or `.highway/tools/README.md` still names
`.cursor/rules` as a delivery location.

## 7. Full suite and cleanup (D3.2, FR-017)

```sh
.highway/tools/tests/run-all.sh                        # expect exit 0
git diff --stat .highway/tools/.adapter-manifest       # only the 12 rows swapped; no stray rows
rm specs/097-cursor-skills-adapter/migrate-cursor-rules.sh
test ! -e specs/097-cursor-skills-adapter/migrate-cursor-rules.sh && echo REMOVED
```

## 8. Manual observation in Cursor (SC-001)

Open the repository in Cursor. Confirm every `highway-*` skill is under Skills and none is under
Rules. If a skill also appears a second time through the Claude-compatible path, record it as an
observation; it does not fail the feature (clarification Q1).
