# Implementation Plan: Collaborative Convergence

**Branch**: `150-collaborative-convergence` | **Date**: 2026-10-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/150-collaborative-convergence/spec.md`

## Summary

Nine captured setup conversations show the same failure: Highway writes an organizational identity
the person never supplied, asks a closed question about it, and persists the answer. The
collaborative behavior that would have prevented this already exists in the Experience Standard,
but every clause guarding it is an exit — X2.37 fires only when Highway judges that it "materially
shaped" a Working Idea, and "materially" is defined nowhere. Meanwhile Profile mandates a literal
closed sentence, which appears verbatim in all nine transcripts. Agents reliably emit mandated
strings and reliably skip judgement-conditioned obligations.

The approach follows from that asymmetry. Replace the self-assessed trigger with a fact Highway
cannot talk itself out of — whether the person has made a Substantive Contribution to the subject —
and state it identically in X2.37 (when an opportunity is owed) and X2.41 (when convergence is
permitted). Prescribe the shape of that opportunity so it cannot be collapsed into a capture.
Mandate literal open acceptance sentences in Profile, since literal strings are what actually land.
Require attribution of introduced vocabulary so a person can reject the framing rather than only
the conclusion.

Sixteen rules are added to the Experience Standard and three are amended; Profile's four closed
sentences are replaced and one permissive hook is deleted. Seventeen existing assertions across
twelve test files move, and one new document-contract test is added.

## Technical Context

**Language/Version**: Bash 3.2.57 (`/bin/bash` on macOS) for tests; Markdown for the governed
artifacts

**Primary Dependencies**: None added. Declared Toolchain only — `awk basename cat comm cp cut date
diff dirname find grep head mkdir mktemp mv rm sed sha256sum shasum sort tail tr uniq wc xargs`.
No `git`, no `stat` inside any script.

**Storage**: N/A. No schema, persisted field, or readiness dimension changes.
`.highway/library/templates/output/profile-record.md` is untouched.

**Testing**: `.highway/tools/tests/run-all.sh`, auto-discovering `*.test.sh`

**Target Platform**: macOS and Linux; GNU coreutils and BSD/Apple variants both

**Project Type**: Governance document set with a shell test suite and generated agent adapter trees

**Performance Goals**: N/A

**Constraints**: `.highway/governance/experience-standard.md` and
`.highway/skills/highway-profile/SKILL.md` are on the protected-file audit list and may be modified
only under this specification. The Experience Standard must contain no tier token. The Profile
skill must contain no `MUST` rule and no X identifier.

**Scale/Scope**: 2 governed documents, 4 generated adapters, 12 test files edited, 1 added.
16 new rules, 3 amended, 0 retired.

## Constitution Check

### Against the Highway Skills Constitution (required by D1.5)

| Rule | Verdict | Basis |
|---|---|---|
| P1.1 — one keyword per rule | PASS | Each of X2.42–X2.57 contains exactly one of MUST, MUST NOT, SHOULD. Asserted by the new test. |
| P1.2 — one obligation per rule | PASS | Attribution is one obligation over two subjects (research §6); amendment preserve/distinguish are split into X2.55 and X2.56. |
| P1.3 — 25 words or fewer | PASS | Counts recorded per rule in [contracts/rule-inventory.md](contracts/rule-inventory.md); maximum is 24. Asserted by the new test. |
| P1.4 — vagueness terms need a countable parenthetical | PASS | No new rule uses a Prohibited Vagueness List term. "Materially" is removed from X2.37's trigger, not added. |
| P1.5 — name every dependency | PASS | Profile's Inputs already names the Experience Standard; no new dependency. |
| P2.1, P2.2 — no model, vendor, or tool in a rule | PASS | No new rule names a technology. |
| P4.2 — no "secure"/"performant"/"maintainable" as acceptance criteria | PASS | None appears. |
| P7.1 — exactly one Purpose | PASS | Profile's Purpose is unchanged. |
| P7.2 — semantic version | PASS | Profile `10.0.0`. |
| P7.3 — no restating a requirement owned elsewhere | PASS | Profile carries output wording, not rule text, and cites the Standard by name. The Standard carries the rule and does not name Profile. Discharges FR-026 in both directions. |
| P7.4 — at most 12 MUST-level rules in a skill | PASS | Profile contains zero and gains none. |
| P7.5 — 400 words per normative section | PASS | Profile's edits are net −1 sentence in Identity and +4 sentences spread across three other sections. Verified at implementation. |
| P7.7 — breaking change increments MAJOR | PASS | All four mandated user-visible acceptance sentences are replaced; `9.0.0` → `10.0.0`. |
| P8.3, P8.4 — Verification section present and checkable | PASS | Profile's Verification section is retained; one line is added for the open validation sentences. |
| P8.7 — no relative-path link | PASS | No link is added to Profile. |
| P9.1 — no repeating the shared output template | PASS | `profile-record.md` is untouched and not described. |
| P10.1 — comply with applicable Experience Standard rules | PASS | Profile is the one skill verified against the new rules. |
| P10.2 — name the X-rule for any exception | N/A | Profile claims no exception. |
| P11.4 — must not substitute missing context, including by invention | PASS | X2.52, X2.53, and X2.54 strengthen this directly. |
| P13.2 — acceptance and persistence assigned to the owner | PASS | Unchanged. Profile still owns acceptance and persistence; the Standard governs the form of the request only. |

### Against the development constitution

| Rule | Verdict | Basis |
|---|---|---|
| D1.1 — no shipped artifact references `.specify/` or `specs/` | PASS | Neither edited document gains such a reference. |
| D1.4 — no restating constitution rule text | PASS | This plan cites rule IDs. |
| D1.5 — Constitution Check against the Highway Skills Constitution | PASS | The table above. |
| D2.1 — Bash 3.2.57 | PASS | The new test uses indexed loops and no associative array, `mapfile`, `readarray`, `${var^^}`, or `&>>`. |
| D2.2 — Declared Toolchain only | PASS | The new test uses `grep`, `sed`, `awk`, `wc`, `cmp`, `cp`, `mktemp`, `rm`. `cmp` is already used by four existing tests under this toolchain. |
| D2.3 — flags work on GNU and BSD | PASS | Only `-c`, `-q`, `-F`, `-E`, `-n`, `-s`. |
| D3.1 — suite passes before the first edit | PASS | 73 passed, 0 failed, exit 0, recorded 2026-10-07. |
| D3.2 — suite passes after the final edit | Deferred | Verified at completion, not claimed here. |
| D3.3 — behavioral change amends a test | PASS | Twelve edited, one added. |
| D3.4 — new check evaluated against every fixture first | PASS | The new test reads two source documents and four adapters; each is evaluated before the check is wired in. The eight `profile-convergence` fixtures are untouched and unread by it. |
| D3.5 — no test weakened | PASS | The `-ne 33` → `-ne 49` and version-string moves retain the assertion's purpose at a new value; each edited file records the superseded value and reason inline. No assertion is removed. |
| D3.6 — observe the failure first | Deferred | Probes specified in [contracts/test-impact.md](contracts/test-impact.md); the failing runs are recorded during implementation. |
| D3.8 — static document contract is not behavioral evidence | PASS | The new test declares `static-document-contract` and is not offered for any success criterion. |
| D4.4, D4.7 — regenerate after a generator input changes | PASS | Profile adapters are regenerated; `adapter-coverage.test.sh` decides. |
| D6.1 — live documentation updated in the same change | PASS | Both governed documents and their twelve dependent tests change together. |
| D6.2 — cross-references resolve | PASS | No new cross-reference path. |
| D7.3 — coverage reported separately from check results | Deferred | The report shape is specified in [quickstart.md](quickstart.md). |
| D8.1 — re-validate skills citing a changed shared library artifact | N/A | No shared library artifact changes. The Experience Standard is governance, not `library/`. |

**Gate result**: no unjustified violation. Complexity Tracking is empty.

### Re-evaluation after Phase 1 design

Unchanged. Two design decisions were taken specifically to keep the gate clean and are recorded in
[research.md](research.md): attribution is one rule rather than three, so P1.2 holds without
producing a near-duplicate pair (§6); and the tier clause of FR-024 is satisfied vacuously, because
the Standard carries no tier and three tests assert that tier tokens are absent from it (§2).

One substantive risk was retired during design rather than carried: the factual convergence
condition was checked against the short path and preserves it by construction, because a
domain-complete statement is itself a Substantive Contribution (§3). No exemption clause is needed,
and FR-023 holds without one.

## Project Structure

### Documentation (this feature)

```text
specs/150-collaborative-convergence/
├── plan.md                      # This file
├── spec.md                      # Input, with 5 integrated clarifications
├── research.md                  # Phase 0: 12 recorded decisions
├── data-model.md                # Phase 1: entities, relationships, state transitions
├── quickstart.md                # Phase 1: suite evidence and human evidence, kept separate
├── follow-up.md                 # Discharges FR-037
├── contracts/
│   ├── rule-inventory.md        # Exact Standard rule and prose text
│   ├── profile-wording.md       # Exact Profile user-visible wording
│   └── test-impact.md           # Every moving assertion, every frozen assertion, the new test
├── checklists/
│   └── requirements.md          # 16/16
└── tasks.md                     # Produced by /speckit-tasks
```

### Source (repository root)

```text
.highway/
├── governance/
│   └── experience-standard.md                 # 9.1.0 → 10.0.0; +16 rules, 3 amended, 3 definitions
├── skills/highway-profile/
│   └── SKILL.md                               # 9.0.0 → 10.0.0; 4 sentences replaced, 1 deleted, 4 added
└── tools/tests/
    ├── feature-150-collaborative-convergence.test.sh   # NEW
    ├── experience-standard-amendment.test.sh           # count, version, date
    ├── experience-standard-convergence.test.sh         # count
    ├── constitution-experience-alignment.test.sh       # count
    ├── highway-ux-alignment.test.sh                    # count
    ├── feature-141-experience-standard-refactor.test.sh# count, version, date
    ├── profile-behavior.test.sh                        # version, Identity sentence
    ├── feature-138-visible-profile-structure.test.sh   # version
    ├── feature-137-profile-acquisition-expression-persistence.test.sh  # version
    ├── feature-136-profile-substantive-re-evaluation.test.sh           # version
    ├── feature-140-profile-convergence-alignment.test.sh               # version
    ├── feature-092-contract.test.sh                    # version
    ├── profile-runtime-separation.test.sh              # version
    └── profile-structure.test.sh                       # version

.github/skills/highway-profile/SKILL.md        # regenerated
.claude/skills/highway-profile/SKILL.md        # regenerated
.cursor/skills/highway-profile/SKILL.md        # regenerated
.agents/skills/highway-profile/SKILL.md        # regenerated
```

**Structure Decision**: Governance-document change, not an application. No source tree, no
services, no models. The three contracts carry the exact text so implementation is transcription
rather than re-derivation, and so the wording decisions are reviewable before any protected file is
opened.

## Evidence that replaces the undecidable success criteria

SC-001 through SC-007 are countable but human-decided, and the preceding attempt at this work was
abandoned because mechanical scoring of agent transcripts could not be made to work. D3.8 forbids
recording a static document contract as the evidence satisfying a behavioral requirement, and every
test this feature touches is a static document contract.

The completion report therefore makes two separate claims, per D7.3:

1. **Check results** — the suite summary and exit code. This claim covers only whether the governed
   documents contain the contracted text.
2. **Requirement coverage** — which artifact satisfies which FR, with SC-001 through SC-007 marked
   human-decided and claimed by nothing.

The substitute evidence for the success criteria is the procedure in
[quickstart.md](quickstart.md) Parts 2 and 3: a fresh conversation driven by the `setup-model.md`
stimulus sequence and read by a human against the nine baselines, plus a separate short-path run
that checks the amendment did not overcorrect into ceremony.

## Complexity Tracking

No Constitution Check violation. This section is intentionally empty.
