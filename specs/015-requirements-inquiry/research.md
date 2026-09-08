# Phase 0 Research: Requirements Inquiry Skill

**Feature**: `015-requirements-inquiry` | **Date**: 2026-09-08

---

## R1. A skill is prose, not a program

**Decision**: `highway-inquiry` is a `SKILL.md` containing instructions an agent follows. No
script is written, and none of the behaviour in the specification is implemented in code.

**Rationale**: This is what a Highway skill is. `highway-help` is a `SKILL.md` with eight sections
and no executable. The toolchain under `.highway/tools/` validates and distributes skills; it does
not run them.

This reframes most of the specification. FR-008 through FR-014 — determining intent, asking rather
than guessing, challenging a weak question — are **instructions to an agent**, and their quality
is a property of how precisely the skill's text is written. They cannot be unit-tested, and
designing as though they could would produce a skill that reads like a program and instructs
nobody.

**What this means for verification**: the testable surface is the skill's *conformance* — that it
validates, that it carries the required sections, that it appears in the catalog and adapters —
plus the *questionnaire's* conformance. The behavioural requirements are verified by following the
skill, which is what its own Verification section is for.

**Alternatives considered**:

- *Write a script that edits the questionnaire, and have the skill call it.* Rejected: it splits
  one behaviour across two artifacts, and the interesting part — deciding what the user meant — is
  precisely the part a script cannot do. It would also add a shipped executable whose failure
  modes need their own tests, for an operation an agent performs directly.

---

## R2. The questionnaire is a library file and must satisfy the library validator

**Decision**: `requirements-inquiry.md` carries library frontmatter and the two body sections the
validator requires, above the questions.

**Verified 2026-09-08** — a library file is decided against exactly these:

| Requirement | Source |
|---|---|
| `name` frontmatter field | SCHEMA |
| `description` frontmatter field, under 500 characters | SCHEMA |
| `metadata.version` matching MAJOR.MINOR.PATCH | P7.2 |
| A `## Purpose` section containing **exactly one sentence** | P7.1 |
| A non-empty `## Verification` section | P8.3 |

Everything else, including the prose rules and the vagueness list, is deferred for library files.
A user's question wording is therefore not judged.

**The consequence that matters**: the skill rewrites this file on every action, so it must emit
all five every time. The one-sentence Purpose is the easiest to break — a generated Purpose that
grows a second sentence fails P7.1, and it would fail on every user's machine at once.

**Alternatives considered**:

- *Keep the questions in a file with no frontmatter.* Rejected: it ships in the library, and a
  library file that fails the library validator is not something to hand over.
- *Put the questionnaire outside the library.* Rejected: the user asked for it to be visible in
  their library, and it is framework content, so the library is where it belongs.

---

## R3. Adding a skill silently omits its adapters from the distribution

**This is a defect in the packaging manifest, found while planning this feature.**

The manifest classifies adapters by exact path: `.github` is excluded, and
`.github/skills/highway-help` is included by a more specific row. A second skill's adapters match
only the exclude row:

```text
.github/skills/highway-inquiry     exclude
.claude/skills/highway-inquiry     exclude
.cursor/rules/highway-inquiry.mdc  exclude
.highway/skills/highway-inquiry    include
```

So the distribution would contain the skill's source and **not** the adapters that make it
available to an agent. Nothing fails: the paths are classified, so the unclassified-path check
passes, and packaging succeeds. A recipient would receive a skill their agent cannot see.

**Decision**: add three manifest rows for this skill, and add a test asserting that every skill in
`.highway/skills/` has its three adapters classified as included.

**Rationale**: the rows fix today. The test fixes the pattern — this defect is not specific to
`highway-inquiry`, it applies to every skill added from now on, and it is invisible without a
check. Feature 012 chose whole-tree scanning over enumerated lists for exactly this reason, and
the manifest's per-skill rows reintroduced the enumeration it was avoiding.

**Alternatives considered**:

- *Change the manifest to include `.github/skills/highway-*` by glob.* Rejected here, though it is
  the better long-term shape: the classifier matches by longest path prefix, not by glob, so this
  is a change to `lib/distribution.sh` — a shipped file — and to the manifest format. That is a
  feature of its own, and doing it inside a skill-authoring feature would bury it.
- *Add the rows and no test.* Rejected: the next skill silently repeats the defect.

---

## R4. Renumbering and the multi-step instruction problem

**Decision**: The questionnaire stores questions in file order, numbered contiguously from 1
across the whole file. The skill renumbers after every mutation and reports the resulting
numbering. A multi-step instruction is resolved step by step against the state each step produces,
and the skill states the numbering it used whenever that differs from what the user named.

**Rationale**: FR-005 through FR-007b. Numbering is the user's handle, and after "remove question
3" the old question 4 is the new question 3. "Remove question 3 and update question 4" is
genuinely ambiguous, and the resolution has to be stated rather than left to whichever reading the
agent happens to take.

Numbering runs across the whole file rather than restarting per section because it expresses the
order questions are asked, and that order is global. A per-section numbering would make "question
3" ambiguous across eight sections.

**Alternatives considered**:

- *Resolve all steps against the state before any of them.* Rejected: it makes "add a question then
  move it to position 2" unexpressible, because the added question has no number in the prior
  state.

---

## R5. What "destructive" means here, and what it requires

**Decision**: Replacing the whole questionnaire, and removing a question, both require the skill
to state what will be lost and obtain confirmation before writing.

**Rationale**: FR-011. These are the only actions that destroy content the user did not restate.
Replacement is the sharper case — a user supplying eight questions to a questionnaire of thirty
loses twenty-two they never mentioned, and the file is not somewhere they will notice.

The confirmation must name what is lost, not merely ask. "This will replace 30 questions with 8"
is a decision the user can make; "Are you sure?" is not.

---

## R6. What a new installation starts with

**Decision**: This feature creates `requirements-inquiry.md` with a starting set of questions,
organised into the sections the description names.

**Rationale**: FR-019 requires predictable behaviour when no questionnaire exists, and the two
candidate behaviours are "create an empty one" and "ship one". Shipping content is better here:
the file's purpose is to be the authoritative question set, an empty authoritative set is not
useful, and a user tuning existing questions is a much easier first experience than a user facing
a blank file.

The starting content is a **default, not a recommendation**. The skill exists precisely so that a
user can change it, and the questionnaire should say so in its own Purpose.

**Alternatives considered**:

- *Create it on first use.* Rejected: it means the shipped library has a gap where the file should
  be, and the first user action is answering "what should be in it".

---

## R7. Determinism

**Decision**: The questionnaire's content is a function of its questions, their sections, and
their order. Writing the same question set twice produces the same file.

**Rationale**: FR-018. The precedent is D4.2 and the adapter generator's byte-identical output.
The specific hazard to avoid is a generation timestamp: `generate-catalog.sh` writes one and it
forced an exception into D4.2's Observable. Nothing here needs a timestamp, and adding one would
make every write a diff.

`metadata.version` is content, not a timestamp, and changes only when the questions change.
