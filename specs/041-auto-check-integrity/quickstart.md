# Quickstart: Validating Automatic Check Integrity

**Feature**: 041-auto-check-integrity | **Date**: 2026-09-10

Every scenario below is runnable against the tree. Each one breaks something real and then restores
it. **Restore by rewriting the bytes, never with version control** — during feature 010 a revert
discarded unrelated uncommitted work, and `git` is not in the Declared Toolchain.

Run from the repository root.

---

## Scenario 0 — Baseline (run first, and again last)

```sh
time bash .highway/tools/tests/run-all.sh; printf 'EXIT=%s\n' "$?"
```

**Expect**: `EXIT=0`, 39+ passed / 0 failed, wall clock **under 180s**.

Record the number. FR-020 requires the suite green at both ends, and the runtime is the budget in
research R3.

---

## Scenario 1 — A checkbox no longer decides scope

*Validates FR-003, US1. This is the defect that broke the suite the moment `specs/041-*` was created.*

```sh
# Pick a feature registered complete, and un-tick one of its tasks
sed -i '' '0,/^- \[x\]/s//- [ ]/' specs/033-highway-setup/tasks.md

bash .highway/tools/tests/completion-coverage.test.sh; printf 'EXIT=%s\n' "$?"

# Restore
sed -i '' '0,/^- \[ \]/s//- [x]/' specs/033-highway-setup/tasks.md
```

**Expect**: `EXIT=0`, and the feature still appears in the coverage assertions.

**Before this feature**: the feature silently drops out of scope and the suite stays green — reporting
success for a check that stopped looking.

---

## Scenario 2 — An unregistered directory is named, not ignored

*Validates FR-001, FR-004, assertion A1.*

```sh
mkdir -p specs/099-probe-$$
printf '# Probe\n' > specs/099-probe-$$/spec.md

bash .highway/tools/tests/completion-coverage.test.sh; printf 'EXIT=%s\n' "$?"

rm -rf specs/099-probe-$$
```

**Expect**: `EXIT=1` and `FAIL: feature directory is not in the completion register: 099-probe-<pid>`.

A new directory must be declared before it is exempt. Silence here is the defect.

---

## Scenario 3 — The register cannot be quietly emptied

*Validates assertion A8.*

```sh
cp .specify/memory/completion-register.md /tmp/register-$$.bak
sed -i '' 's/^| 0/# | 0/' .specify/memory/completion-register.md

bash .highway/tools/tests/completion-coverage.test.sh; printf 'EXIT=%s\n' "$?"

cp /tmp/register-$$.bak .specify/memory/completion-register.md && rm /tmp/register-$$.bak
```

**Expect**: `EXIT=1` naming that the reader matched nothing — **not** a green run over zero features.

---

## Scenario 4 — The corrective set follows the register

*Validates FR-006, FR-007, US2.*

```sh
sed -i '' 's/^| 025-profile-path-migration | complete | 024-highway-profile |/| 025-profile-path-migration | complete | - |/' .specify/memory/completion-register.md
bash .highway/tools/tests/completion-coverage.test.sh; printf 'EXIT=%s\n' "$?"   # expect 0
```

Restore the row, then confirm the obligation returns:

```sh
sed -i '' 's/^| 025-profile-path-migration | complete | - |/| 025-profile-path-migration | complete | 024-highway-profile |/' .specify/memory/completion-register.md
bash .highway/tools/tests/completion-coverage.test.sh; printf 'EXIT=%s\n' "$?"   # expect 0
```

**Expect**: both runs green, and no eight-name list anywhere in the file:

```sh
grep -c 'profile-path-migration\|valid-profile-yaml\|objectives-rename-cleanup' \
  .highway/tools/tests/completion-coverage.test.sh
```

**Expect**: `0`.

---

## Scenario 5 — A probe that does not probe is rejected

*Validates FR-008, FR-010, US3. This is the round trip the whole feature rests on.*

```sh
bash .highway/tools/tests/adapter-coverage.test.sh --probe generated-artifact
printf 'SEEDED_EXIT=%s\n' "$?"        # expect non-zero

bash .highway/tools/tests/adapter-coverage.test.sh --probe generated-artifact --neutralise
printf 'NEUTRAL_EXIT=%s\n' "$?"       # expect 0
```

**Expect**: `SEEDED_EXIT` non-zero, `NEUTRAL_EXIT=0`.

A probe that always fails passes the first and fails the second. That pairing is why the harness
cannot be satisfied by a printed token.

---

## Scenario 6 — A comment is no longer evidence

*Validates FR-009, US3.*

```sh
cp .highway/tools/tests/generate-catalog.test.sh /tmp/gc-$$.bak

# Keep the comment; break the probe it advertises
sed -i '' 's/^probe_generated_artifact() {/probe_generated_artifact() { return 1;/' \
  .highway/tools/tests/generate-catalog.test.sh

bash .highway/tools/tests/constitution-inventory.test.sh; printf 'EXIT=%s\n' "$?"

cp /tmp/gc-$$.bak .highway/tools/tests/generate-catalog.test.sh && rm /tmp/gc-$$.bak
```

**Expect**: `EXIT=1`, naming `D4.2` and the class.

**Before this feature**: green, because the comment is still there.

---

## Scenario 7 — The five correspondences for `highway-inquiry`

*Validates FR-011, US4. `highway-inquiry` is the prescribed subject because it conforms, so each
correspondence can be broken and restored.*

| Break | Rule | Expect |
|---|---|---|
| Remove its catalog entry | D4.5 | `adapter-coverage` fails, naming the skill |
| Remove its adapter from one agent tree | D4.6 | fails, naming tree and skill |
| Remove its adapter manifest row | D4.6 | fails, naming the manifest |
| Remove its distribution manifest row | D4.5 | fails, naming the manifest |
| Change its description without regenerating | D4.7 | fails, naming staleness |

Each is exercised by the paired invocation from Scenario 5. Confirm the tree is unchanged afterwards:

```sh
bash .highway/tools/tests/adapter-coverage.test.sh; printf 'EXIT=%s\n' "$?"   # expect 0
```

---

## Scenario 8 — No residue

*Validates FR-012. Residue has twice named a defect that did not exist.*

```sh
find .highway specs -name '*probe*' -o -name '*[0-9][0-9][0-9][0-9][0-9]*' | grep -v '/specs/[0-9]' 
```

**Expect**: no output after any scenario above.

---

## Scenario 9 — The records the rules already demanded

*Validates FR-013, FR-014, US5.*

```sh
head -3 specs/038-readiness-verification-corrections/coverage.md
grep -c '^| FR-' specs/038-readiness-verification-corrections/coverage.md
grep -c '^| FR-' specs/040-historical-coverage-reconstruction/coverage.md
```

**Expect**: the declared header `| Requirement | Outcome | Evidence |`; `15` rows for 038 with the
eight non-requirement rows gone; a row count for 040 matching its declared requirement ids.

---

## Scenario 10 — The claim that was reported met

*Validates FR-015.*

```sh
grep -n 'Phase 12' governance-plan.md | head -20
```

**Expect**: the original Done-when text **unchanged**, with an added note recording that it was
reported met while `D7.4`'s scope excluded three directories and `D3.7` read a comment.

Rewording the original would erase the evidence. The point is that the record shows both the claim and
its falsification.

---

## Exit criteria

| # | Criterion |
|---|---|
| 1 | Scenario 0 green at start and end, under 180s |
| 2 | Scenarios 1–9 produce the stated exits |
| 3 | Scenario 8 finds nothing after every other scenario |
| 4 | Every assertion added by this feature was observed failing before the work it covers was marked complete (FR-019) |
