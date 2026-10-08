# Quickstart: Validating Collaborative Convergence

**Feature**: 150 | **Date**: 2026-10-07

Two kinds of evidence exist for this feature and they must not be conflated. The suite decides
whether the documents say what the contracts say. A human decides whether the conversation got
better. D3.8 and D7.3 require them to be reported as separate claims.

## Prerequisites

- Repository root: `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`
- Bash 3.2.57 (`/bin/bash`), Declared Toolchain only — no `git`, no `stat` inside scripts
- Evidence inputs live one directory above the repository: `setup-model.md`, `setup-assessment.md`,
  and the nine captured conversations

## Part 1 — Document contract (suite-decidable)

```sh
.highway/tools/tests/run-all.sh
```

**Expected before the first edit**: `Summary: 73 passed, 0 failed`, exit 0.
**Expected after the final edit**: `Summary: 74 passed, 0 failed`, exit 0 — one new test file.

Targeted re-runs while working:

```sh
bash .highway/tools/tests/feature-150-collaborative-convergence.test.sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/adapter-coverage.test.sh
```

Rule inventory spot check:

```sh
grep -cE '^\| X[0-9]+\.[0-9]+ \|' .highway/governance/experience-standard.md    # 49
grep -c 'MUST' .highway/skills/highway-profile/SKILL.md                          # 0
grep -c 'X2.41' .highway/skills/highway-profile/SKILL.md                         # 0
```

Observe the new test failing before it passes (D3.6):

```sh
cp .highway/governance/experience-standard.md /tmp/std.bak
grep -v '^| X2.49 |' /tmp/std.bak > .highway/governance/experience-standard.md
bash .highway/tools/tests/feature-150-collaborative-convergence.test.sh   # expect non-zero
cp /tmp/std.bak .highway/governance/experience-standard.md
```

Record the failing message before the fix, per D3.6. Repeat for each probe in
[contracts/test-impact.md](contracts/test-impact.md).

## Part 2 — Conversation quality (human-decided)

No check in this repository decides SC-001 through SC-007. The procedure:

1. In a fresh session with no prior context, invoke `/highway-profile setup`.
2. Drive it with the stimulus sequence used in `setup-model.md`: a repository name, a wrong website,
   a logistics correction, a contradiction, the real business, a vague vision, airplanes and traffic,
   a two-of-three selection, a late addition, a partial agreement, a reference to content that is
   not there, and a final confirmation.
3. Save the transcript alongside the nine baselines.
4. Judge, by reading:

| Criterion | What to look for |
|---|---|
| SC-001 | Every captured domain follows a real contribution, not an approval |
| SC-002 | Every domain term in the record traces to the person |
| SC-003 | Vision, Competitive Path, and Guiding Principles each open with possibilities |
| SC-004 | No acceptance request can be satisfied by saying yes |
| SC-005 | Hand it a complete description and it captures it without an exploratory detour |
| SC-006 | Closer to `setup-model.md` than to `setup-cursor-gemini-2.md` |
| SC-007 | At least three organizational facts none of the nine baselines obtained |

5. The decisive negative baseline is `setup-copilot-luna-2.md`, in which the person answered **yes**
   to an entirely wrong organizational identity and corrected it unprompted a turn later. If the new
   run can still produce that, the amendment did not work.

## Part 3 — Short-path regression

The risk this amendment creates is overcorrection: forcing exploration on someone who arrived
ready. Verify it separately.

1. Fresh session, `/highway-profile setup`.
2. Answer the Identity question with a complete, domain-ready paragraph.
3. **Expected**: Highway captures it and asks the open acceptance question. No exploratory turn is
   interposed.
4. **Failure**: an unnecessary Contribution Opportunity appears. That means the factual condition in
   X2.41 was implemented as a ritual rather than a condition.

## Reporting

The completion report states two separate claims:

- **Check results**: the suite summary and exit code.
- **Requirement coverage**: which FR each artifact satisfies, with SC-001 through SC-007 marked
  human-decided and unclaimed by any check.
