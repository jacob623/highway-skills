# Phase 0 Research: Distribution Packaging

**Feature**: `012-distribution-packaging` | **Date**: 2026-09-08

Every unknown carried by the Technical Context is resolved below. Each entry records what was
chosen, why, and what was rejected.

---

## R1. Where the classification is declared

**Decision**: A single data file, `.highway/tools/.distribution-manifest`, listing one entry per
line as `classification<TAB>source path<TAB>destination path`. Classification is `include` or
`exclude`. Destination is `-` when the path lands where it sits.

**Rationale**: FR-003 requires one declaration and FR-004 requires the packaging step to read it
rather than carry a copy. A data file read by every consumer satisfies both, where a shell array
inside the packaging script would not — the test suite and the independence check would each need
their own copy. The tab-delimited shape matches `.adapter-manifest`, already parsed with `grep -F`
and `awk` in `generate-agent-adapters.sh`, so no new parsing technique enters the toolchain.

The third column exists solely for FR-019. Without it the distribution front page has nowhere to
come from, because the repository root is already occupied by a different document.

**Alternatives considered**:

- *Two files, one listing includes and one listing excludes.* Rejected: two files can disagree,
  and a path absent from both would be silently unclassified, which FR-006 forbids.
- *Reuse `.gitignore` semantics.* Rejected: it answers "is this tracked", a different question
  from "does this ship", and it is meaningless in a tree that is not a repository.
- *A YAML file.* Rejected: no YAML parser is in the declared toolchain, and adding one violates
  D2.4.

---

## R2. Reconciling the manifest with the existing distributed path set

**This is the sharpest design question in the feature, and the plan's answer differs from what
the specification's assumption implies.**

`shipped-tree-independence.test.sh` declares a distributed path set today: all of `$HIGHWAY_ROOT`,
plus the `highway-*` adapters under three agent directories. D1.6 requires that set be declared in
exactly one place, and the specification assumes it is "the natural seed for the new
classification".

It is the natural seed, but the two sets are **not equal**. The independence check scans all of
`.highway/`, fixtures included — feature 010 chose that deliberately, with no exemption. The
distribution excludes `.highway/tools/tests/`. So the independence check's scope is a strict
superset of the distribution.

**Decision**: The manifest is the single declaration of what ships. The independence check derives
its targets from the manifest and then explicitly adds the test directory, with the reason
recorded inline.

**Rationale**: This keeps one declaration of the shipped set, satisfying D1.6, while preserving
the check's existing breadth. Making the check read the manifest *alone* would silently drop
fixtures from its scope — a weakened assertion, which D3.5 forbids without a recorded reason
naming the superseded behavior. The addition is one line and is not a second declaration of what
ships; it is a statement that the check's scope intentionally exceeds the distribution.

**Alternatives considered**:

- *Let the independence check read the manifest and accept the narrower scope.* Rejected: this is
  precisely the weakening D3.5 exists to prevent, and fixtures are the content most likely to
  carry a development-path reference.
- *Classify `tests/` as included to make the sets equal.* Rejected: it ships deliberately
  non-conformant fixtures to users, which the recorded scope decision rules out.

---

## R3. Proving self-containment rather than assuming it

**Decision**: The verification invokes the **distribution's own copy** of the validator, at
`<distribution>/.highway/tools/validate-skill.sh`, with `CONSTITUTION_FILE` unset.

**Rationale**: The validator derives `HIGHWAY_ROOT` from `SCRIPT_DIR` — its own location — not
from the tree it is inspecting. Verified 2026-09-08: the repository's validator exits 0 against a
tree containing no toolchain and no governing document, because it resolves the repository's own
constitution. Running the repository's validator against a candidate distribution therefore proves
nothing about self-containment; it proves only that the skill *content* is conformant.

Invoking the distribution's own copy inverts this. If any library, the governing document, or any
sourced file is missing from the distribution, the run fails. That is FR-009a: the check must use
only what the distribution contains. `CONSTITUTION_FILE` must be unset for the same reason — an
override supplies from outside exactly what the check exists to prove is inside.

**Alternatives considered**:

- *Run the repository's validator with `CONSTITUTION_FILE` pointed into the distribution.*
  Rejected: it still sources every library from the repository, so a missing library goes
  undetected.
- *Enumerate the files the toolchain needs and assert each exists.* Rejected: an enumeration drifts
  the moment a new library is sourced. Executing the toolchain tests the real dependency set.

---

## R4. Naming the packaging script

**Decision**: `.highway/tools/generate-distribution.sh`.

**Rationale**: The development constitution's Generator Gate triggers on "a change touches a
`generate-*.sh` script", evaluating D4.1–D4.4. This script is a generator in substance — it
produces derived artifacts and keeps a manifest — so those rules should apply to it. Naming it
`package-distribution.sh` would leave the gate untriggered on a technicality while the substance
was unchanged. Naming it to match makes the gate fire on its own terms.

**Alternatives considered**:

- *`package-distribution.sh` plus a note that D4.1–D4.4 apply anyway.* Rejected: it relies on
  every future reader honoring a note instead of the trigger doing its job.

---

## R5. Byte-identical output

**Decision**: Packaging copies committed artifacts verbatim. It never invokes a generator.

**Rationale**: FR-012 requires two runs from the same repository state to be byte-identical.
`generate-catalog.sh` writes a `generated_at` timestamp, so any run that regenerated the catalog
would differ between invocations — the same fact that forced D4.2's timestamp exception. Copying
sidesteps it entirely and makes the distribution a faithful image of the repository state.

The cost is that packaging a stale repository produces a stale distribution. This is acceptable
because D4.1 and D4.4 already require generated artifacts to be current, and the test suite
enforces it.

**Alternatives considered**:

- *Regenerate during packaging and exclude the timestamp from comparison.* Rejected: it makes
  "byte-identical" conditional, which is the weaker claim FR-012 was written to avoid.

---

## R6. Drift refusal for a directory target

**Decision**: Record `<relative path><TAB><sha256>` for every produced file in a manifest written
inside the distribution at `.highway/tools/.distribution-record`. On a later run, refuse when the
target directory exists and holds a file absent from that record or whose hash differs.

**Rationale**: FR-013 requires refusing to overwrite a target the step did not produce.
`generate-agent-adapters.sh` solves the same problem per file, and reusing its `sha256_of`
fallback — `sha256sum`, else `shasum -a 256` — keeps both platforms working and adds no
dependency. The difference is that the target is a whole tree, so absence of a file from the
record is as much a signal as a hash mismatch.

**Alternatives considered**:

- *Delete and rewrite the target directory each run.* Rejected: a recursive delete of a
  user-supplied path is exactly the destructive shortcut FR-013 exists to prevent.
- *Trust a marker file at the distribution root.* Rejected: a marker proves the directory was
  produced once, not that its contents are still what was produced.

---

## R7. Cross-reference resolution

**Decision**: For each Markdown link target in a distribution file, skip external schemes and
in-page anchors, then require the target to resolve relative to the containing file, inside the
distribution.

**Rationale**: FR-008 and D6.2 both require references to resolve within the containing tree. The
link-extraction technique already exists in `rc_check_P8_7`, which locates `](`, extracts the
target, and skips empty targets, `#` anchors, and `scheme:` URLs. Reusing it means one extraction
behavior rather than two that can diverge.

Note that P8.7 prohibits relative links *in skills*, so skill files contribute nothing to this
check. It applies to the tools README, the authoring standard, the governing document, and the
distribution front page.

**Alternatives considered**:

- *Check only the front page.* Rejected: SC-004 requires the count of unresolvable references
  across the distribution to be zero.

---

## R8. Proving the verification can fail

**Decision**: Each of the three verification checks is exercised against a deliberately broken
candidate built in a temporary directory, following the seeded-probe pattern in
`shipped-tree-independence.test.sh`.

**Rationale**: FR-015 and SC-007 require demonstrated capability to fail. The probe pattern is
already established, self-cleaning, and proven — it caught a real gap during feature 011, where a
newly added check passed its own tests without ever being dispatched.

**Alternatives considered**:

- *Commit permanently broken candidate fixtures.* Rejected: the recorded scope decision keeps
  deliberately non-conformant content out of shipped paths, and a temporary probe leaves no
  artifact to misclassify.
