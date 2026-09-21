# Contract: Classification Equivalence

**Requirements**: FR-007, FR-008, FR-012, FR-019 | **Success criteria**: SC-005, SC-006, SC-010

**Precedent**: `specs/046-contract-proof-and-lexicon-speed/contracts/required-key-proof.md`. That
feature established that a check may be reimplemented for speed **provided its output and exit
status are proved byte-identical across every target it decides**. This contract applies the same
obligation to path classification.

---

## What is being replaced

| Element | Before | After |
|---|---|---|
| `dist_classify <path>` | 2 processes per call (`dist_records` \| `awk`) | wrapper over `dist_classify_many` for a single path |
| Bulk classification | one `dist_classify` call per repository file — 1,546 processes for 773 files | `dist_classify_many` — one `awk` process for the whole list |
| Repository walk | `find` enumerates all 773 files, every one classified | `find` prunes exclude roots with nothing included beneath them |

`.highway/tools/.distribution-manifest` is **not edited**. The matching semantics are not changed.

## Interface

```sh
dist_classify <path>                    # unchanged: echoes include | exclude | unclassified
dist_classify_many                      # reads paths on stdin, one per line
                                        # writes "<classification><TAB><path>", one per input line
dist_prune_roots                        # echoes the derived prune-root set, one path per line
```

## Obligations

### O1 — Per-path equivalence

For **every** path in the repository, and for the adversarial set below, `dist_classify_many` must
produce the classification `dist_classify` produces for that path alone.

The proof is mechanical and is run before the old path is removed:

```sh
find "$REPO_ROOT" -type f -not -path "$REPO_ROOT/.git/*" \
  | sed "s|^$REPO_ROOT/||" | sort >/tmp/paths.txt
while read -r p; do printf '%s\t%s\n' "$(dist_classify "$p")" "$p"; done </tmp/paths.txt >/tmp/old.txt
dist_classify_many </tmp/paths.txt >/tmp/new.txt
diff /tmp/old.txt /tmp/new.txt        # must be empty
```

**Adversarial paths that must appear in the proof set**, because each is a case where a naive
rewrite diverges:

| Path | Correct result | Why it is a trap |
|---|---|---|
| `.github/skills/highway-new/SKILL.md` | `include` | An include beneath the `exclude .github` record |
| `.github` | `exclude` | The record itself, not a descendant |
| `.highway/tools/tests/run-all.sh` | `exclude` | A more specific exclude beneath `exclude .highway` |
| `.highway/skills/highway-new/SKILL.md` | `include` | An include beneath `exclude .highway` |
| `specs/056-test-suite-runtime-recovery/spec.md` | `exclude` | Beneath a prune root; must still classify correctly when asked directly |
| `.DS_Store` | `exclude` | Exact-match record, no descendants |
| `.highway/tools/lib/distribution.sh` | `exclude` | Exact-match file record beneath a directory record |
| a path matching nothing | `unclassified` | Must remain a failure, never a default |

### O2 — Prune-root derivation

`dist_prune_roots` emits every record where `classification == exclude` **and** no other record's
`source` is strictly beneath it.

**Must be derived from the manifest at runtime.** A hardcoded list is prohibited by this contract,
because `.claude`, `.cursor`, `.github` and `.highway` are all excluded records with includes
beneath them, and pruning any of them would silently drop the adapter trees and every shipped skill
out of the distribution.

**Assertion**: for each root `r` emitted, no manifest record's `source` starts with `r/`.

### O3 — Walk equivalence

The set of files the pruned walk enumerates, unioned with everything beneath the prune roots, must
equal the set the unpruned walk enumerates. Every path dropped by pruning must classify `exclude`.

```sh
comm -3 <(pruned_walk | sort) <(unpruned_walk | grep -v -f <(dist_prune_roots | sed 's|$|/|') | sort)
# must be empty
```

### O4 — Distribution byte-identity

The produced distribution must be unchanged. Proved by hashing both trees:

```sh
find "$OLD_DIST" -type f | sed "s|^$OLD_DIST/||" | sort >/tmp/old-files.txt
find "$NEW_DIST" -type f | sed "s|^$NEW_DIST/||" | sort >/tmp/new-files.txt
diff /tmp/old-files.txt /tmp/new-files.txt                    # same 83 paths
while read -r f; do shasum -a 256 "$NEW_DIST/$f"; done </tmp/new-files.txt
# every hash equal to the old tree's, except the file carrying the generation timestamp
```

The generation timestamp is the only permitted difference, and only because the D4.2 Observable
already excepts it.

### O5 — Growth decoupling

Adding 500 files beneath `specs/` must change total suite runtime by no more than 5 seconds
(FR-012), measured once as acceptance evidence. The standing guard is **structural**, not timed:
`classification-scope.test.sh` fails if any classification pass enumerates a path beneath a prune
root.

**This is deliberately not a timing assertion.** A permanent test that created 500 files and
re-ran the suite would cost more than the budget it protects and would be flaky on shared
hardware — and a flaky test gets disabled, taking the protection with it.

## Failure messages

| Condition | Message |
|---|---|
| Bulk and single classification disagree | `FAIL: classification mismatch for <path>: single=<a> bulk=<b>` |
| A prune root has a record beneath it | `FAIL: prune root <root> has a more specific record: <record>` |
| The walk enumerates a pruned path | `FAIL: classification pass enumerated <path> beneath prune root <root>` |
| Distribution content changed | `FAIL: distribution differs at <path>` |

## Out of scope

Manifest semantics, the manifest file itself, `dist_destination`, `dist_included_sources`, and
`dist_unclassified_paths` (already bounded to top-level entries).
