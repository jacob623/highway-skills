# Quickstart: Validating the Requirements Inquiry Skill

**Feature**: `015-requirements-inquiry` | **Date**: 2026-09-08

Runnable scenarios proving the feature works. Each maps to a success criterion. Run from the
repository root.

**Prerequisites**: a clean working tree and `.highway/tools/tests/run-all.sh` exiting 0, which
D3.1 requires. It is 16 today.

Formats are in [the contract](contracts/questionnaire-format.md); structures are in
[the data model](data-model.md).

**A note on what is testable here.** A skill is prose an agent follows, not a program. Scenarios
S1 through S5 are mechanical and belong in the suite. S6 through S9 are behavioural and are
verified by following the skill, which is what its own Verification section exists for. Writing
them as if they were automatable would be dishonest about what the suite proves.

---

## S1 — The skill validates (SC-010)

```bash
.highway/tools/validate-skill.sh .highway/skills/highway-inquiry; echo "exit=$?"
```

**Expected**: exit 0, with `UNCHECKED:` empty and no `FAILED:` entries. The two rules most likely
to bite are **P8.7**, if the skill links to the questionnaire rather than naming it, and **P6.4**,
if a decision criterion uses prohibited vocabulary.

---

## S2 — The questionnaire validates (SC-008)

```bash
.highway/tools/validate-library.sh .highway/library/templates/requirements-inquiry.md; echo "exit=$?"
```

**Expected**: exit 0. The fragile requirement is **P7.1** — `## Purpose` must contain exactly one
sentence. Confirm it directly:

```bash
sed -n '/^## Purpose$/,/^## /p' .highway/library/templates/requirements-inquiry.md \
  | grep -v '^##' | grep -c '\.'
```

**Expected**: `1`.

---

## S3 — Numbering is contiguous and global (SC-002)

```bash
grep -oE '^[0-9]+\.' .highway/library/templates/requirements-inquiry.md \
  | tr -d '.' | awk 'NR==1{p=$1; if(p!=1) print "does not start at 1"} NR>1{if($1!=p+1) print "gap or duplicate at",$1; p=$1} END{print "last:",p,"count:",NR}'
```

**Expected**: no gap or duplicate reported, and `last` equals `count`. Numbering runs across the
whole file, so it must not restart at each section.

---

## S4 — Question text is unique (SC-002a)

```bash
grep -oE '^[0-9]+\. .*' .highway/library/templates/requirements-inquiry.md \
  | sed 's/^[0-9]*\. //' | sort | uniq -d
```

**Expected**: no output. A duplicate makes answers keyed by text ambiguous, which is the property
a future presenting skill depends on.

---

## S5 — The skill reaches users, adapters included (SC-011)

This is the scenario that catches the manifest defect. Producing the distribution is not enough —
check what a recipient actually receives:

```bash
d="$(mktemp -d)/dist"
.highway/tools/generate-distribution.sh "$d" >/dev/null 2>&1 && echo "builds: yes"
for p in .highway/skills/highway-inquiry \
         .highway/library/templates/requirements-inquiry.md \
         .github/skills/highway-inquiry \
         .claude/skills/highway-inquiry \
         .cursor/rules/highway-inquiry.mdc; do
  [ -e "$d/$p" ] && echo "OK      $p" || echo "MISSING $p"
done
rm -rf "$d"
```

**Expected**: `builds: yes` and five `OK` lines. Before the manifest rows are added, the three
adapters report `MISSING` while packaging still reports success — a skill whose agent cannot see
it.

---

## S6 — The skill asks rather than guessing *(behavioural)*

Follow the skill with an instruction that names no question: *"Move monitoring higher."*

**Expected**: it names the candidate questions and changes nothing. Confirm the file is unchanged:

```bash
shasum -a 256 .highway/library/templates/requirements-inquiry.md
```

Compare before and after. **Expected**: identical.

---

## S7 — Destructive actions confirm, naming what is lost *(behavioural)*

Follow the skill with *"Set the questionnaire to these three questions."* against a questionnaire
holding more than three.

**Expected**: before writing, the skill states how many questions will be lost and that they are
not in the new set. "Are you sure?" does not satisfy this — the user must be able to decide from
what they are told.

---

## S8 — Quality checks advise rather than veto *(behavioural)*

Submit a question that cannot reasonably be answered, such as *"Is the system good?"*

**Expected**: the skill explains why, offers at least one alternative, and accepts the question
anyway if the user insists. A skill that can refuse will be worked around by editing the file
directly.

---

## S9 — Numbering is reported after a change *(behavioural)*

Remove a question, then ask to update the one that followed it.

**Expected**: after the removal the skill reports the resulting numbering; and if the number the
user then names was resolved against different numbering, it says which it used.

---

## S10 — Determinism (SC-009)

```bash
cp .highway/library/templates/requirements-inquiry.md /tmp/inquiry-before.md
```

Follow the skill through an action that changes nothing — for example, adding a question and
removing it again.

```bash
diff /tmp/inquiry-before.md .highway/library/templates/requirements-inquiry.md && echo "identical"
rm -f /tmp/inquiry-before.md
```

**Expected**: `identical`, apart from `metadata.version`, which is content and moves when the
questions move. No timestamp should appear anywhere in the file.

---

## S11 — The suite passes, nothing weakened (SC-011)

```bash
.highway/tools/tests/run-all.sh
```

**Expected**: all tests pass, count no lower than 17. No assertion removed or loosened.

---

## S12 — The gate is cleared

```bash
ls .highway/skills/ | grep -v '^_' | wc -l | tr -d ' '
```

**Expected**: `2`. The governance plan blocks authoring the Experience Standard while
`highway-help` is the only skill, because a standard generalised from one skill is built on a
sample of one.
