# Coverage: Suite Runtime Reduction

**Feature**: 151 | **Branch**: `feature/test-cleanup-spec151`

## Baseline (T001, T002, T003)

**Suite**: `.highway/tools/tests/run-all.sh` — **377 s wall, 74 passed, 0 failed, exit 0**.
D3.1 satisfied; this run preceded the first edit.

This is a *warm* figure. An earlier cold run in the same session reported 695 s and overstated
individual tests by up to 7×. The cold number is superseded and must not be used for comparison.
SC-001's stated baseline of 371.8 s and this 377 s run agree within normal variance.

### Ten slowest tests, warm (T002)

Measured earlier in this session with `bash <file>`, not `./<file>`. Roughly thirty test files are
not executable; invoking them with `./` yields exit 126 in about 20 ms, which reads as a fast pass
in a timing table and silently corrupts the measurement.

| Test | Warm | Cold (superseded) |
|---|---:|---:|
| constitution-inventory.test.sh | 88.9 s | 111.6 s |
| distribution-packaging.test.sh | 45.2 s | 65.8 s |
| generate-agent-adapters.test.sh | 33.7 s | 236.1 s |
| generate-catalog.test.sh | 20.6 s | 102.6 s |
| adapter-coverage.test.sh | 17.6 s | 19.1 s |
| validate-skill.test.sh | 15.8 s | 23.6 s |
| generate-library-catalog.test.sh | 12.4 s | 31.3 s |
| new-agent-extensibility.test.sh | 10.3 s | 21.5 s |
| rule-checks.test.sh | 8.6 s | 16.1 s |

`constitution-inventory.test.sh` is the single largest cost and it is the meta-harness this
feature scoped out. Its 88.9 s is the floor for any concurrent run unless the cache cascades into
it, which is what T019 exists to decide.

### Supporting measurements

| Quantity | Value |
|---|---|
| `validate-skill.sh` on one skill | 372 ms |
| All 12 skills | ~4.5 s |
| One `generate-agent-adapters.sh` run | 8.1 s |
| Revalidation share of a generation run | ~55% |
| Generator invocations inside `generate-agent-adapters.test.sh` | 4 |
| Environment hash over 11 lib scripts, 21 library files, 2 governance docs | 35 ms |

35 ms replacing 4.5 s is the whole economic argument for the cache.

### Reference artifact tree (T003)

`/tmp/highway-151-ref.ItvE46` — 76 files copied from `.github/skills/`, `.claude/skills/`,
`.cursor/skills/`, `.agents/skills/`, and `.highway/catalog/`. Path also recorded at
`/tmp/highway-151-ref-path.txt` for T016's `diff -r`.

## User Story 1 — validation cache (T004–T019)

### Observed failing before implementation (T012)

Ten assertions failed against the unmodified validator: VC-1 (no key recorded, no second-run
reuse), VC-3, VC-4 (three), VC-5, VC-7 (three), VC-8. D3.6 satisfied by observation, not by
assertion that it would fail.

One of those failures was a defect in the test rather than the implementation: a copy of the
fixture placed at `broken-skill/` could never validate, because the directory basename is the
skill id and must match the frontmatter `name`. The copies were renamed to keep the fixture's
name and isolate by parent directory instead.

### Two correctness holes found by reading the validator rather than assuming

Both were in the first draft of the environment hash and both would have produced stale verdicts:

| Hole | Consequence had it shipped |
|---|---|
| Hash filtered to `*.sh` and `*.md` | `library/knowledge/frontmatter-lexicon.txt` and `tools/.frontmatter-contract` are real validator inputs. Editing either would have changed a verdict without changing the key. |
| Document overrides ignored | `CONSTITUTION_FILE`, `EXPERIENCE_FILE`, `FRONTMATTER_CONTRACT_FILE`, and `FRONTMATTER_LEXICON_FILE` repoint validation at different documents. A key derived from the repository's own documents would have named a verdict never reached under them. |

The hash now covers every file under `tools/lib/`, `library/`, and `governance/` regardless of
extension, plus `validate-skill.sh` and `tools/.frontmatter-contract`. The cache disables itself
entirely whenever any override is set.

A third finding changed the data model: [coverage-summary.test.sh](../../.highway/tools/tests/coverage-summary.test.sh)
greps `validate-skill.sh` stdout for the exact `OK: skill ...` line. The "empty file"
representation in [data-model.md](data-model.md) would have made a cache hit print nothing and
broken that test. Records store the full report and replay it, so a hit is byte-identical to a
full run.

### Results

| Measure | Before | After |
|---|---:|---:|
| Validate all 12 skills, cold | 5383 ms | 5383 ms |
| Validate all 12 skills, warm | 5383 ms | **444 ms** |
| `generate-agent-adapters.test.sh` | 33.7 s | **12.9 s** |
| `generate-catalog.test.sh` | 20.6 s | **5.0 s** |
| `validate-skill.test.sh` | 15.8 s | **11.3 s** |
| `adapter-coverage.test.sh` | 17.6 s | **15.5 s** |
| `distribution-packaging.test.sh` | 45.2 s | 48.1 s |
| `constitution-inventory.test.sh` | 88.9 s | 98.6 s |
| **Full suite** | **377 s / 74 passed** | **266 s / 75 passed, 0 failed** |

- **T017**: verdicts for all 12 skills are identical across `--no-cache`, cold, and warm. D3.4
  satisfied against every live fixture.
- **T016**: `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/` are
  byte-identical to the reference tree. `.highway/catalog/` differs only in the `generated_at`
  timestamp, which is the one permitted exception. FR-003 holds; D4.4 satisfied.
- **T018**: 75 passed, 0 failed, exit 0.

### T019 — decision gate: NOT PASSED

`constitution-inventory.test.sh` did not fall. It went from 88.9 s to 98.6 s, inside run-to-run
variance but certainly not an improvement.

This is structural, not a defect. The test seeds mutations into the governance documents and
re-executes roughly fifty test files against them. Mutating a governance document is exactly what
changes the environment hash, so every probe runs against a cold cache **by design**. A
content-addressed cache cannot accelerate a harness whose purpose is to vary the content.

`distribution-packaging.test.sh` is likewise unaffected: it references `validate-skill` once, and
its 48 s is spent copying and link-checking a packaged tree.

**Consequence for SC-001.** Both tests are in the exclusive pool, so concurrency cannot overlap
them with anything. Their serial sum alone is ~147 s, and the rest of the exclusive pool adds
roughly 50 s more. The floor for a concurrent run is therefore around 200 s, and SC-001's 180 s
target is not reachable through the two causes this feature put in scope.

Per T019, implementation stopped here rather than building US2 and reporting the target as missed
at the end.

## Regression investigation (post-T019)

Prompted by [governance-plan.md](../../governance-plan.md) Phases 14 and 15, which had already
measured this suite on 2026-09-11 and 2026-09-12.

### Two of my own claims were wrong and are corrected here

1. **"The long tail grew by ~120 s."** False. Fifty-nine tests run under 1250 ms each, totalling
   **14.6 s** — consistent with Phase 14's "everything else together is under 35." The figure came
   from subtracting individually-measured test times from a `run-all.sh` wall clock, which are not
   comparable measurements.
2. **"The runner holds a ~59 s gap."** False. Timed in situ, the tests sum to **240 s** inside a
   **242 s** run. Runner overhead is ~2 s. The apparent gap was run-to-run variance between a
   266 s run and a later measurement set.

### Growth is not the problem

| | 2026-09-11 | 2026-10-08 |
|---|---:|---:|
| Test files | 36 | **75** |
| Files added | — | 39 |
| Files removed | — | **0** |
| Combined cost of all 39 new files | — | **~15.7 s** |

The suite more than doubled what it proves for about sixteen seconds. Thirty-four of the thirty-nine
new files cost under 600 ms each.

### Where the time went, and where it returned

| Measure | 2026-09-12 | Pre-cache today | Post-cache today |
|---|---:|---:|---:|
| `run-all.sh` wall clock | median 203 s | 377 s | **242 s** |

The 174 s regression was real, and the validation cache has recovered 135 s of it. What remains is
**+39 s against 2026-09-12**, of which ~16 s is the thirty-nine new test files, leaving roughly
**23 s genuinely unexplained**. That is a far smaller question than the one this investigation
opened with.

The 240 s interim ceiling Feature 042 set is now met within measurement noise. The 180 s target of
Phase 14 is **62 s away**.

### Phase 14's framing still holds

| Test | Phase 14, 2026-09-11 | In situ today |
|---|---:|---:|
| `constitution-inventory.test.sh` | 97.2 s | 80 s |
| `distribution-packaging.test.sh` | 38.3 s | 53 s |
| **Two files, share of run** | 135.5 s of ~200 s | **133 s of 240 s** |

Still two files holding more than half the run. Phase 14's conclusion — "not a broad efficiency
exercise but two files" — survives both the cache and the doubling of the test count.

---

## Completion report (T041)

**Feature 151 closes at the end of User Story 1.** US2 is descoped, not deferred silently; the
reasoning is recorded in [tasks.md](tasks.md) and [spec.md](spec.md).

### Claim 1 — suite result

Two consecutive full runs of `.highway/tools/tests/run-all.sh`, warm, on an idle machine:

| Run | Wall time | Result | Exit |
|---|---:|---|---:|
| 1 | 218 s | 75 passed, 0 failed | 0 |
| 2 | 248 s | 75 passed, 0 failed | 0 |

Reported as a **range of 218–248 s**, not as the better sample. The spread of 30 s across two
back-to-back runs is itself worth noting: single-sample runtime claims about this suite are not
trustworthy, which is why SC-001 was amended to a 250 s ceiling rather than to the 242 s that
was first measured.

The `PASS:`/`FAIL:` sets of both runs are identical across all 96 entries (SC-003, on two runs
rather than the three SC-003 asks for — see Not claimed, below).

### Claim 2 — requirement coverage

This is a separate claim from the suite being green, and a green suite does not establish it.

| Requirement | State | Evidence |
|---|---|---|
| FR-001 – FR-005 | Met | `tests/validation-cache.test.sh`, VC-1 – VC-9; all ten assertions observed failing before implementation |
| FR-003 (artifact equivalence) | Met | Generated artifacts byte-identical except `generated_at` |
| FR-006 – FR-011 | **Not met — descoped** | US2 not built; `run-all.sh` unchanged, confirmed by an empty `git diff` |
| FR-012 (no coverage traded for speed) | Met | See below |
| SC-001 (≤250 s, amended) | Met | 218–248 s from a 377 s baseline |
| SC-002 | Met | See below |
| SC-003 | Partially met | Two runs identical, not three |
| SC-004 | Met | T012 and VC-4: a broken skill is rejected with its original error even when previously cached |
| SC-005 | Met | T016 |
| SC-006 | **Not applicable — descoped** | No concurrency was introduced, so there is no interference to tell apart |

### FR-012 and SC-002 stated explicitly (T040)

A green suite does not prove coverage was preserved, so this is asserted on its own evidence:

- `git diff -- .highway/tools/tests/` across the whole branch shows **zero removed lines**. No
  pre-existing test file was modified at all.
- No test file was deleted or skipped. The count **rose from 74 to 75**.
- No assertion was removed or loosened. The only test change is an addition.

### Constitutional conformance

| Rule | Result |
|---|---|
| D1.1 | No new or edited file under `.highway/` references `.specify/` or `specs/` |
| D1.2 | `validate-skill.sh` exits 0 against a copy of the tree with `.specify/` and `specs/` absent |
| D2.1 | No associative array, `mapfile`, `readarray`, `${var^^}`, `&>>`, or `wait -n` |
| D2.2 | External commands invoked are `awk basename cat dirname find grep mkdir mktemp mv rm sed sha256sum shasum sort tr xargs` — all declared. No `git`, no `stat` |
| D3.6 | Ten assertions observed failing before implementation |
| D3.7 | `constitution-inventory.test.sh` exits 0 in 67 s standalone; every mapped probe still fails when seeded and passes when neutralised |
| D6.1 | `.highway/tools/README.md` documents `--no-cache` and the cache's three deliberate properties |
| D6.2 | Every path referenced by the updated README resolves inside the distributed tree |
| D7.3 | The two claims above are stated separately |

### Not claimed

Stated plainly rather than left for a reader to notice:

- **SC-003 asked for three consecutive runs; two were performed.** The result sets match, but the
  criterion is not fully satisfied.
- **Phase 14 requires five consecutive runs** before a runtime claim is recorded. This feature
  does not supply that, and must not be read as closing Phase 14.
- **The quickstart (T039) was not run end to end.** Its US2 sections describe flags that no longer
  exist following the descope, so running it as written would fail for reasons unrelated to what
  shipped. It needs revision before it can serve as evidence.
- **~23 s of the suite's regression against 2026-09-12 remains unexplained**, recorded as
  unexplained rather than attributed.
- **Spec Kit hooks were skipped.** There is no `.specify/extensions.yml` in this repository, so
  no pre- or post-command hook ran at any point in this feature.
- **An unresolved governance conflict is recorded in `governance-plan.md`.** Phase 15's
  specification text explicitly forbids introducing a cache of this kind. The argument that this
  implementation meets its intent is written out there alongside the argument that it does not.
  That conflict is for the repository owner to settle, not for this feature to assume away.
