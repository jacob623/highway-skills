# Implementation Plan: Specification-Record Governance Removal

**Branch**: `044-spec-governance-removal` | **Date**: 2026-09-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/044-spec-governance-removal/spec.md`

## Summary

Remove the eight development-constitution rules whose subject is the `specs/` tree or the completion
register, relocate the two rules under those principles whose subject is not, delete the four
Enforcement Map rows and three test files that enforced them, and close Features 042 and 043 in the
same change.

The technical approach is **deletion in dependency order**, verified by the surviving suite at each
step. There is no new behaviour to build. The whole risk of this feature is that a deletion reaches
further than intended, so every step is paired with an assertion that something specific is still
true afterwards.

The ordering constraint that drives everything: `constitution-inventory.test.sh` reads the
Enforcement Map and executes the declared probe of every test it names. Remove a test file before
its map row and that test fails. Map rows come out first, then the files.

## Technical Context

**Language/Version**: Bash 3.2.57 (macOS default), per `D2.1`

**Primary Dependencies**: None added. Declared Toolchain only, per `D2.2` and `D2.4`

**Storage**: Files. `.specify/memory/constitution.md`, `.specify/memory/completion-register.md`,
`.highway/tools/tests/`

**Testing**: `.highway/tools/tests/run-all.sh`, 43 test files before this feature, 40 after

**Target Platform**: macOS and Linux, per `D2.3`

**Project Type**: Governance/tooling repository. Layer 0 only — no shipped artifact changes

**Performance Goals**: None. Runtime change is a recorded side effect, explicitly not a goal
(FR-022). Baseline ~200s; the three removed tests total 11.8s

**Constraints**: The suite passes before the first edit and after the last (`D3.1`, `D3.2`). No test
over a `.highway/` file is weakened (FR-012). `validate-skill.sh` decision count unchanged at 93/480
(SC-010)

**Scale/Scope**: 8 rules removed, 2 relocated, 4 of 13 Enforcement Map rows, 3 test files totalling
811 lines, 1 helper script amended, 2 feature records closed

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

| Rule | Tier | Verdict | Basis |
|---|---|---|---|
| `D1.1` | [auto] | PASS | No shipped file is edited; the prohibited tokens are not introduced anywhere under the distributed path set |
| `D1.2` | [auto] | PASS | The packaged tree is unaffected; three deleted tests live under `.highway/tools/tests/`, which the distribution excludes from validation scope |
| `D1.3` | [agent-checkable] | PASS | This plan cites rule ids and restates no rule sentence |
| `D1.4` | [agent-checkable] | PASS | Same |
| `D1.5` | [agent-checkable] | N/A | No skill or library file is created or modified |
| `D2.1`–`D2.4` | [agent-checkable] | PASS | Deletions only; no script gains a command or dependency |
| `D3.1` | [agent-checkable] | **Gate** | Suite must exit 0 before the first edit. Recorded in research.md |
| `D3.2` | [agent-checkable] | **Gate** | Suite must exit 0 after the final edit |
| `D3.3` | [agent-checkable] | PASS | The change edits files under `.highway/tools/tests/` — by removing them. Recorded explicitly rather than claimed by technicality |
| `D3.4` | [agent-checkable] | N/A | No new validation check is added |
| `D3.5` | **[human-review]** | **REQUIRES SIGN-OFF** | Three passing tests are deleted. See Complexity Tracking and research.md |
| `D3.6` | [agent-checkable] | N/A | No behaviour is marked complete on the strength of a newly passing test |
| `D3.7` | [auto] | PASS, with a required re-run | Map rows are removed before their tests, so no row ever names a missing file |
| `D3.8` | [agent-checkable] | PASS | No static contract is recorded as behavioural evidence |
| `D4.1`–`D4.7` | mixed | PASS | No generator, generated artifact, or generator input is touched |
| `D5.1` | [agent-checkable] | **VIOLATION, justified** | Feature 043's `spec.md` is edited to set Status `Withdrawn`. See Complexity Tracking |
| `D5.2` | [agent-checkable] | PASS | This correction ships as its own numbered directory, `044` |
| `D5.3` | [agent-checkable] | **Gate** | This feature supersedes rules; every element it changes must be named. The contract in `contracts/removal-inventory.md` is how that obligation is discharged |
| `D5.4` | [auto] | PASS | `044` is one greater than `043` |
| `D5.5` | [auto] | PASS | Directory basename equals the `Feature Branch` value |
| `D6.1` | [agent-checkable] | **Gate** | `governance-plan.md` and the completion register header both name the removed behaviour and must be edited in this change (FR-019, FR-023) |
| `D6.2` | [agent-checkable] | PASS | No live documentation is left naming a removed rule |
| `D7.1`–`D7.5` | mixed | Self-referential | These rules are the subject. They bind this feature until the edit that removes them lands, and the task order respects that |
| `D8.1` | [agent-checkable] | N/A | No shared library dependency is added or changed |

**Two gates need explicit handling and are carried into Complexity Tracking: `D3.5` and `D5.1`.**

Note the self-reference: `D5.1`, `D5.2`, `D5.4`, `D5.5` and `D7.x` are simultaneously the rules being
removed and the rules governing their removal. They are honoured up to the moment they are deleted,
which is why Feature 043's status edit and the register edits are sequenced against the rule removals
rather than done first.

## Project Structure

### Documentation (this feature)

```text
specs/044-spec-governance-removal/
├── plan.md                        # This file
├── research.md                    # Phase 0 output
├── data-model.md                  # Phase 1 output
├── quickstart.md                  # Phase 1 output
├── contracts/
│   └── removal-inventory.md       # Phase 1 output: the exact removal set
└── tasks.md                       # Phase 2 output (/speckit-tasks — not created here)
```

### Source Code (repository root)

```text
.specify/memory/
├── constitution.md                # Rules removed, two relocated, version 1.6.0 → 2.0.0
└── completion-register.md         # Header rewritten; 042 complete; 043 withdrawn

.highway/tools/tests/
├── completion-coverage.test.sh    # DELETED (592 lines)
├── spec-record.test.sh            # DELETED (150 lines)
├── feature-038-plan.test.sh       # DELETED (69 lines)
├── feature-038-evidence-report.sh # AMENDED — drops the deleted test from one category
├── feature-038-helpers.sh         # RETAINED — two surviving tests source it
├── run-all.sh                     # AMENDED — ordered tail list and skip case
├── constitution-inventory.test.sh # UNCHANGED — its workload shrinks via the Map
└── coverage-summary.test.sh       # UNCHANGED — its subject is the shipped constitution

governance-plan.md                 # Already amended: Phases 12, 13, 15, 16 removed

specs/042-probe-reachability-correction/  # UNCHANGED
specs/043-corrective-provenance-honesty/  # spec.md Status → Withdrawn; nothing else
```

**Structure Decision**: No new directories or files are created outside this feature's own spec
directory. Every edit is a deletion or an amendment to an existing file. The `specs/` tree remains in
place, including all coverage records — they become unread, not removed.

## Implementation Phases

### Order is a correctness constraint, not a preference

Each step's dependency is stated because reordering breaks the suite:

1. **Record the baseline.** Suite runtime and exit code, per-test timings, `validate-skill.sh`
   decision count. Required by `D3.1` and by SC-009 and SC-010, and it cannot be recovered after the
   edits.
2. **Relocate `D5.3` and `D7.3`** into Principle III, text byte-identical. Done first so the
   principle sections are empty of survivors before removal, and so no window exists in which either
   rule is absent from the document.
3. **Remove the four Enforcement Map rows.** Before the test files, so `constitution-inventory` never
   names a missing file. Run the suite here — this is the step most likely to surprise.
4. **Remove the eight rules and the two emptied principle sections.**
5. **Bump the version to 2.0.0** and write the amendment entry, including the self-application review
   against `D1.3`, `D1.4` and `D5.3` that the constitution requires of itself.
6. **Amend `run-all.sh` and `feature-038-evidence-report.sh`** to stop naming the tests about to be
   deleted. Before deletion, so no intermediate state has a dangling caller.
7. **Delete the three test files.** Run the suite.
8. **Rewrite the completion register header**, mark 042 `complete`, mark 043 `withdrawn`, widen the
   stated vocabulary.
9. **Set Feature 043's spec Status to `Withdrawn`**, naming Feature 044.
10. **Record the closing measurements** and the `D3.5` verdict.

Steps 3 and 7 each end with a full suite run rather than deferring verification to the end. A single
run at the end would report a failure without isolating which deletion caused it.

### What this feature must not do

- Add any check. FR-012 and SC-008 exist to catch a removal that quietly compensates with a new
  assertion.
- Edit any coverage record, including Feature 042's. The 96 blanket-deferred rows become unread.
- Touch `.highway/governance/constitution.md`, the shipped authoring constitution.
- Delete anything under `specs/` beyond Feature 043's Status line.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| `D3.5` — three passing tests deleted | The rules they decide cease to exist. A test enforcing a deleted rule is not a weakened test; it is an orphaned one, and leaving it would make the constitution and the suite disagree | Retaining them means retaining `D5.4`, `D5.5`, `D7.2` and `D7.4`, which is the change this feature exists to make. Disabling rather than deleting leaves 811 lines of unreachable code asserting a superseded position |
| `D5.1` — Feature 043's completed-directory content edited | 043 is `in-progress`, not complete, so `D5.1` does not strictly bind. It is recorded as a violation anyway because a reader will see an edit inside a spec directory and should find the reason here rather than infer one | Leaving 043 at `Draft` forever means the register carries a feature whose subject no longer exists with no explanation — the same placeholder dishonesty Feature 042 was opened to remove |
| Constitution MAJOR bump to 2.0.0 | The document's own Versioning Policy defines MAJOR as a principle being removed or redefined. Two principles are removed | A MINOR bump would understate the change and contradict the policy the document states about itself |

## Risks

- **`constitution-inventory.test.sh` may fail in an unanticipated way at step 3.** It derives work
  from the Map, and no one has removed a Map row before. This is why step 3 is isolated and
  suite-verified rather than batched with step 4.
- **The runtime reduction may be larger than the 11.8s the deleted tests account for**, because
  `constitution-inventory` stops executing two files' probes. That is a welcome side effect and a
  reporting hazard: FR-022 forbids presenting it as the justification. Report the number; do not
  lean on it.
- **A rule may be removed that has a non-record consumer.** `D5.3` and `D7.3` were found by
  inspection; the constitution's own Self-Application section cites `D5.3`, which confirms it. The
  contract file lists every removal explicitly so this is reviewable rather than trusted.

## Phase Outputs

- **Phase 0** → [research.md](./research.md): baseline measurements, the `D3.5` verdict, per-test
  statement of what becomes unchecked, and the disposition reasoning for all ten rules.
- **Phase 1** → [data-model.md](./data-model.md): the entities and their state transitions;
  [contracts/removal-inventory.md](./contracts/removal-inventory.md): the exact, reviewable removal
  set; [quickstart.md](./quickstart.md): how to execute and verify the removal.

## Post-Design Constitution Re-Check

Re-evaluated after Phase 1 artifacts were written. No verdict changed. The two flagged gates,
`D3.5` and `D5.1`, are both carried into Complexity Tracking with a stated justification, and
`contracts/removal-inventory.md` discharges `D5.3` by naming every element this feature changes.
