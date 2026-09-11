# Removal Inventory Contract

**Feature**: 044-spec-governance-removal | **Date**: 2026-09-11

This file discharges `D5.3`: a superseding document MUST name every element it changes. It is the
authoritative, reviewable list. Anything not named here is out of scope, and an edit to a file
absent from this list is a defect in the implementation rather than a judgement call.

Line numbers are as measured on 2026-09-11 and are **indicative only** — they shift as edits land.
Rule ids and file paths are authoritative.

---

## A. Constitution: rules removed

File: `.specify/memory/constitution.md`

| Rule | Line (indicative) | Tier | Enforced by |
|---|---|---|---|
| `D5.1` | 412 | [agent-checkable] | — |
| `D5.2` | 413 | [agent-checkable] | — |
| `D5.4` | 415 | [auto] | `spec-record.test.sh` |
| `D5.5` | 416 | [auto] | `spec-record.test.sh` |
| `D7.1` | 365 | [agent-checkable] | — |
| `D7.2` | 366 | [auto] | `completion-coverage.test.sh` |
| `D7.4` | 368 | [auto] | `completion-coverage.test.sh` |
| `D7.5` | 369 | [agent-checkable] | not in the Enforcement Map |

**Count: 8.** Tier impact: `[auto]` −4, `[agent-checkable]` −4, `[human-review]` unchanged.

`D7.5` is absent from the Enforcement Map despite being the rule Feature 043 was opened to correct.
That absence is a pre-existing finding, not a change made here.

## B. Constitution: rules retained by relocation

| Rule | From | To | Constraint |
|---|---|---|---|
| `D5.3` | `### V. Specification Record Integrity` | `### III. Verification Before and After` | Rule and Observable columns byte-identical; tier unchanged |
| `D7.3` | `### VII. Completion Integrity` | `### III. Verification Before and After` | Same |

Rule ids are not renumbered. See research.md §3.3.

## C. Constitution: sections removed

| Section | Line (indicative) | Condition |
|---|---|---|
| `### V. Specification Record Integrity` and its rationale paragraph | 408–420 | Only after `D5.3` has been relocated out |
| `### VII. Completion Integrity` and its rationale paragraph | 361–373 | Only after `D7.3` has been relocated out |

## D. Constitution: Enforcement Map rows removed

| Row | Line (indicative) | Names |
|---|---|---|
| `D5.4` | 299 | `spec-record.test.sh` |
| `D5.5` | 300 | `spec-record.test.sh` |
| `D7.2` | 301 | `completion-coverage.test.sh` |
| `D7.4` | 302 | `completion-coverage.test.sh` |

**13 rows before, 9 after.** Rows retained: `D1.1`, `D1.2`, `D3.7`, `D4.1`, `D4.2`, `D4.3`, `D4.5`,
`D4.6`, `D4.7`.

**Removed before the test files they name.** See research.md §5.

## E. Constitution: version and self-application

| Element | From | To |
|---|---|---|
| Version | `1.6.0` | `2.0.0` |
| Last Amended | `2026-09-10` | `2026-09-11` |

MAJOR per the document's own Versioning Policy: "a principle is removed or redefined". Two are.

The amendment entry MUST record: removed rule ids, relocated rule ids, new rule count, new tier
counts, and a self-application review against `D1.3`, `D1.4` and `D5.3` — the three ids the
Self-Application section names, all of which survive.

No existing version-history entry is edited. Historical counts were true when written (FR-007).

## F. Test files removed

| File | Lines | Time | Decided |
|---|---|---|---|
| `.highway/tools/tests/completion-coverage.test.sh` | 592 | 11.0s | `D7.2`, `D7.4`, `D7.5` |
| `.highway/tools/tests/spec-record.test.sh` | 150 | 0.59s | `D5.4`, `D5.5` |
| `.highway/tools/tests/feature-038-plan.test.sh` | 69 | 0.24s | no mapped rule |

**Total: 811 lines, 11.83s.**

## G. Files amended, not removed

| File | Change |
|---|---|
| `.highway/tools/tests/run-all.sh` | Remove `feature-038-plan.test.sh` from the skip `case` (line ~56) and from the ordered tail list (line ~61) |
| `.highway/tools/tests/feature-038-evidence-report.sh` | Remove the `feature-038-plan.test.sh` invocation from the `static contract` category (line ~29), or remove the file |
| `.specify/memory/completion-register.md` | Header rewritten to assert no reader; vocabulary widened to include `withdrawn`; rows for 042 and 043 updated |
| `specs/043-corrective-provenance-honesty/spec.md` | Status line only: `Draft` → `Withdrawn`, naming Feature 044 |

## H. Files explicitly NOT changed

Listed because each is a plausible target that a careless removal would reach.

| File | Why it stays |
|---|---|
| `.highway/tools/tests/feature-038-helpers.sh` | Sourced by `readiness-executable.test.sh` and `highway-setup-executable.test.sh`, both surviving |
| `.highway/tools/tests/coverage-summary.test.sh` | Its subject is `.highway/governance/constitution.md`, the shipped constitution — not the spec record, despite the name |
| `.highway/tools/tests/constitution-inventory.test.sh` | Unchanged. Its workload shrinks via the Map without any edit |
| `.highway/governance/constitution.md` | The shipped authoring constitution. Out of scope |
| Every `specs/*/coverage.md` | Including Feature 042's 27 rows and the 96 blanket-deferred rows. They become unread, not corrected |
| Every `specs/` directory | Nothing is deleted. The record remains as history |
| `D1.1`, `D1.2` | They name `specs/` as prohibited content in shipped files — the opposite direction. See research.md §4 |

## I. Rule ids removed, cross-referenced

`grep` for the eight removed ids across `.highway/` on 2026-09-11 returned matches in exactly two
files, both of which this feature deletes. **No shipped artifact cites a removed rule.**

One reference survives outside `.highway/`: `governance-plan.md` cited `D5.2` in Phase 7. It was
amended on 2026-09-11 to describe the practice without citing the rule.

## J. Verification checklist

Each line maps to a success criterion in spec.md.

- [ ] No remaining rule's Observable names `spec.md`, `plan.md`, `tasks.md`, a coverage record, a feature directory, or the completion register — SC-001
- [ ] Enforcement Map holds 9 rows; every named file exists — SC-002
- [ ] `D5.3` and `D7.3` Rule and Observable text byte-identical to pre-change — SC-003
- [ ] Three test files gone; no surviving file under `.highway/` names any of them — SC-004
- [ ] `run-all.sh` exits 0 with Feature 042 recorded `complete` — SC-005
- [ ] Feature 042's coverage record: 27 rows, all `satisfied` — SC-006
- [ ] Feature 043's directory intact, requirement count unchanged, Status `Withdrawn` — SC-007
- [ ] No `[auto]` row decided by a test over `.highway/` files was removed — SC-008
- [ ] Suite runtime recorded before and after; no target claimed as met — SC-009
- [ ] `validate-skill.sh` decides 93 of 480, unchanged — SC-010
- [ ] `D3.5` human sign-off recorded before the test files are deleted — FR-021
