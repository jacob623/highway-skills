# Contract: Test Impact

**Feature**: 150 | **Date**: 2026-10-07

Every suite that asserts text or an identifier this feature changes, and the exact assertion that
moves. Baseline before any edit: `.highway/tools/tests/run-all.sh` → **73 passed, 0 failed, exit 0**
(D3.1 satisfied, recorded 2026-10-07).

## Tests whose assertions change

| # | Test | Assertion today | Change |
|---|---|---|---|
| 1 | `experience-standard-amendment.test.sh` | `` '**Layer 2 - Experience.** Version `9.1.0`.' `` | → `10.0.0` |
| 2 | `experience-standard-amendment.test.sh` | `` '**Version**: `9.1.0` \| **Ratified**: 2026-09-08 \| **Last Amended**: 2026-10-06' `` | → `10.0.0`, `2026-10-07` |
| 3 | `experience-standard-amendment.test.sh` | `-ne 33` rule inventory | → `-ne 49` |
| 4 | `experience-standard-convergence.test.sh` | `-ne 33` rule inventory | → `-ne 49` |
| 5 | `constitution-experience-alignment.test.sh` | `-ne 33` rule inventory on the Standard | → `-ne 49` |
| 6 | `highway-ux-alignment.test.sh` | `-ne 33` rule inventory | → `-ne 49` |
| 7 | `feature-141-experience-standard-refactor.test.sh` | `-ne 33` rule inventory | → `-ne 49` |
| 8 | `feature-141-experience-standard-refactor.test.sh` | `` '**Version**: `9.1.0` \| ... \| **Last Amended**: 2026-10-06' `` | → `10.0.0`, `2026-10-07` |
| 9 | `profile-behavior.test.sh` | `'version: 9.0.0'` | → `10.0.0` |
| 10 | `profile-behavior.test.sh` | `'Is this an accurate description of your organization?'` | → the open Identity sentence |
| 11 | `feature-138-visible-profile-structure.test.sh` | `'version: 9.0.0'` | → `10.0.0` |
| 12 | `feature-092-contract.test.sh` | `'version: 9.0.0'` | → `10.0.0` |
| 13 | `feature-140-profile-convergence-alignment.test.sh` | `'version: 9.0.0'` | → `10.0.0` |
| 14 | `feature-137-profile-acquisition-expression-persistence.test.sh` | `'version: 9.0.0'` | → `10.0.0` |
| 15 | `feature-136-profile-substantive-re-evaluation.test.sh` | `'version: 9.0.0'` | → `10.0.0` |
| 16 | `profile-runtime-separation.test.sh` | `'version: 9.0.0'` | → `10.0.0` |
| 17 | `profile-structure.test.sh` | `'version: 9.0.0'` | → `10.0.0` |

Each edited file records the superseded value and the reason inline, in the convention already used
in these files (`# Superseded behavior: ...`), per D3.5.

## Assertions that must NOT move

These constrain the amendment and are listed so the implementation does not break them by accident.

| Test | Assertion | Consequence |
|---|---|---|
| `feature-141` | exactly 5 Interaction Boundaries rows | Amend the existing row; add none |
| `feature-141` | `| X2.21 |` … `| X2.41 |` all present | Amend in place; retire nothing |
| `experience-standard-convergence` | `'grounded reasoning materially improves it'` | Interaction Model step 7 stays |
| `experience-standard-convergence` | `'Working Idea material'`, `'acceptance boundary as approval of the representation'` | Steps 3 and 10 stay |
| `experience-standard-convergence` | `'**Converged Proposal**: A complete candidate whose relevant substance is developed enough'` | That definition stays |
| `experience-standard-amendment`, `constitution-experience-alignment`, `highway-ux-alignment` | `[auto]`, `[agent-checkable]`, `[human-review]`, `Highway Skills Constitution`, `P namespace` absent from the Standard | New rules carry no tier |
| `constitution-experience-alignment` | `Contribution Opportunity`, `Substantive Contribution` absent from the **constitution** | Add nothing to the constitution |
| `constitution-experience-alignment` | constitution rule count `-ne 73` | This feature adds no P rule |
| `feature-140`, `profile-runtime-separation` | `'X2.41'` absent from Profile | Profile cites no X identifier |
| `feature-122-profile-experience-synchronization` | `'X2.36'` absent from Profile | unchanged |
| `profile-behavior` | the four `You can also change it or provide your own ...` lines | Retained byte-identical |
| `profile-behavior`, `feature-140` | `'Validate the Converged Proposal with'` | Sentence frame retained |
| `profile-behavior`, `feature-138`, `profile-runtime-separation` | every domain heading and `When entering unresolved ...` sentence | Added sentences follow them |
| `feature-134`, `feature-138`, `feature-140`, `profile-runtime-separation` | all four adapters `cmp -s` identical to source | Regenerate |
| `rule-checks.test.sh` | exact X2.4 and X2.13 rule text | Neither is amended |
| `coverage-summary.test.sh` | exact X2.5 and X2.6 rule text | Neither is amended |
| `profile-convergence-behavior.test.sh` | 8 fixtures, fixed rubric dimension vocabulary | No fixture added or renamed |

## New test

`.highway/tools/tests/feature-150-collaborative-convergence.test.sh`

Discovered automatically by `run-all.sh` (`*.test.sh` glob). Declares:

```text
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact
```

Per D3.8 it is recorded as a document contract and is **not** offered as evidence for any of
SC-001 through SC-007.

It asserts:

1. Each of `| X2.42 |` … `| X2.57 |` is present.
2. The Standard's rule inventory is 49.
3. Each new rule row contains exactly one of `MUST`, `MUST NOT`, `SHOULD` (FR-024, one keyword).
4. Each new rule's Rule cell is 25 words or fewer (FR-024).
5. No retired identifier is reused: none of X1.7, X2.2, X2.8, X2.14, X2.23, X2.25, X2.26, X2.27,
   X2.28, X2.33, X2.39, X2.40 appears as a rule row (FR-025).
6. The new X2.37 and X2.41 text is present and the superseded text is absent.
7. `Development Turn` appears nowhere in the Standard or Profile (FR-027).
8. The three new definitions are present.
9. None of the four closed acceptance sentences remains in Profile; all four open sentences are
   present (FR-016, FR-033).
10. The three `Open that subject with grounded possibilities` sentences are present (FR-009).
11. The Identity permissive hook is absent.
12. Profile still contains zero `MUST` occurrences.
13. All four Profile adapters are byte-identical to the source.

### Seeded failure probes (D3.6, D3.7)

Each class is proved failable before the implementation lands:

| Probe | Expected |
|---|---|
| Copy the Standard, delete the `| X2.49 |` row | non-zero, names X2.49 and the count |
| Copy the Standard, extend a new rule past 25 words | non-zero, names the rule |
| Copy the Standard, add a second `MUST` to a new rule | non-zero, names the rule |
| Copy Profile, restore `Is this an accurate description of your organization?` | non-zero |
| Copy Profile, insert a `MUST` line | non-zero |
| Touch one adapter | non-zero, names the adapter |

## Regeneration

`generate-agent-adapters.sh` and any generator reading skill frontmatter must be re-run after the
Profile edit (D4.4, D4.7). `adapter-coverage.test.sh` decides whether a diff remains.
