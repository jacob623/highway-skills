# Quickstart: Validating Conversation Delivery Hardening

**Feature**: 153 | **Date**: 2026-10-09

How to verify this feature, start to finish. Every step is a command you can run. Expected results
are stated as comparisons against the baseline measured in [research.md](./research.md), not as
adjectives.

## Prerequisites

- macOS or Linux with the declared toolchain (`D2.2`); no package installation is required
- Working directory: repository root
- Shell: `bash` 3.2.57 compatible (`D2.1`)

## Step 0 — Record the starting state (`D3.1`)

```bash
.highway/tools/tests/run-all.sh
```

**Expected**: exit 0. Record the pass count and the wall-clock duration — SC-009 compares against
this number, so taking it after the change is too late.

```bash
grep -cE '\b(MUST|SHOULD)\b' .highway/skills/highway-profile/SKILL.md
```

**Expected**: `0`. This is FR-015's baseline and must read `0` again at the end.

```bash
awk '/^#{2,5} /{if(h!="")printf "%6d  %s\n",w,h; h=$0; w=0; next} {w+=NF} \
     END{if(h!="")printf "%6d  %s\n",w,h}' .highway/skills/highway-profile/SKILL.md
```

**Expected**: the section table in research.md, totalling 2088 words with the
`## Readiness` roll-up at 1303. FR-017 compares the post-change roll-up against 1303.

## Step 1 — Observe the new assertions fail (`D3.6`)

Write `.highway/tools/tests/feature-153-delivery-sites.test.sh` first, before any source edit.

```bash
.highway/tools/tests/feature-153-delivery-sites.test.sh
```

**Expected**: non-zero exit, with a message naming each absent delivery site. Record the failing
output. A test that passes here is testing nothing — `D3.6` exists for this case.

## Step 2 — Evaluate the new rules against the existing tree (`D3.4`, `D8.1`)

Before enabling X2.68 through X2.72, check every skill that cites the Experience Standard:

```bash
grep -rl 'experience-standard' .highway/skills/
```

For each result, record whether its current emitted output would satisfy or fail the five new
rules. **Expected**: a recorded verdict per skill, before the rules are added. A skill that would
newly fail must be named, not quietly left failing.

## Step 3 — Implement

In order: Standard rules and the X2.56 Observable; `highway-profile` delivery sites; the
exemplars; the grounding source. Contracts for each are in
[contracts/delivery-sites.md](./contracts/delivery-sites.md).

Both sign-off items are closed: the reaction literal is accepted as drafted (C2), and the setup
heading level is not changed (C4 is empty; research item R5).

## Step 4 — Regenerate (`D4.5`, `D4.6`, `D4.7`, FR-016)

```bash
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-instructions.sh
```

```bash
git status --short
```

**Expected**: changes appear in all four agent trees and the catalogs. No generated file is
hand-edited — if one is, `generate-agent-adapters.sh` refuses and names it (`D4.3`).

## Step 5 — Verify the delivery sites

```bash
.highway/tools/tests/feature-153-delivery-sites.test.sh
```

**Expected**: exit 0.

```bash
grep -c '\*\*What would you add, correct, or remove?\*\*' .highway/skills/highway-profile/SKILL.md
```

**Expected**: `1`. This is the R6 guard. A count of 4 means an exemplar reached for the stock
question instead of a question from its own domain content.

```bash
grep -cE '\b(MUST|SHOULD)\b' .highway/skills/highway-profile/SKILL.md
```

**Expected**: `0`. A non-zero count means an obligation was written into the skill instead of
delivered by it — FR-015 and `P7.3` both fail.

## Step 6 — Measure and record (FR-017, SC-009)

```bash
awk '/^#{2,5} /{if(h!="")printf "%6d  %s\n",w,h; h=$0; w=0; next} {w+=NF} \
     END{if(h!="")printf "%6d  %s\n",w,h}' .highway/skills/highway-profile/SKILL.md
```

**Expected**: a larger `## Readiness` roll-up than 1303, using the `/^## /` form of the command.
The measured value is **1915**. **No check will object.** The number goes
in the completion report because nothing else will report it.

```bash
time .highway/tools/tests/run-all.sh
```

**Expected**: exit 0, with the pass count above Step 0's and the duration delta recorded.

## Step 7 — The completion report (FR-018, FR-019, FR-020, `D7.3`)

The report must state, as separate claims:

1. The suite result and pass count
2. Requirement coverage, requirement by requirement
3. That **every** requirement's evidence is a document contract, and that no requirement is
   evidence that any behavior occurs at runtime
4. The recorded section size, since no check decides it
5. That conversational evaluation is deferred to a follow-up feature

## What a full pass does and does not establish

A green run of every step above establishes that the text exists, is shaped as contracted, and
reaches all four agent trees. It establishes nothing about whether a conversation improves. The
assessment measured two runs of the same host against identical text landing at opposite ends of
the quality judgment — which is the reason the evaluation round is a separate feature and not a
success criterion here.
