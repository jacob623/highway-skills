# Research: Principle XIV, Agent Skills Alignment

## R1. Rule ids, sentences, and Observables

Decision: P14.1 Size, P14.2 Layout, P14.3 Routing, P14.4 Handoff integrity, all `[auto]`. Each rule
sentence states one obligation with one keyword in at most 25 words. The Observable carries
Phase 13's concrete limits and names the boundaries it checks. The exact text is in
[contracts/principle-xiv.md](contracts/principle-xiv.md).

Rationale: the rule sentence stays short enough for P1.1 and P1.3 while the Observable holds every
limit, as P7.4's and P7.5's rows do. Ids P14.1 to P14.4 were never used, so none is reused.

Alternatives considered: one rule per boundary (12 rules). Rejected: Phase 15 fixes four rules, one
per group, and twelve rows would repeat one obligation.

## R2. How each rule names the specification clause it narrows

Decision: a "Narrows" list directly under Principle XIV's rule table, one bullet per rule id, each
naming the clause by the specification's own heading or "None (Highway pattern)". The principle's
introduction links the specification once.

| Rule | Clause |
| --- | --- |
| P5.15 | `SKILL.md` format, `description` field |
| P14.1 | Progressive disclosure |
| P14.2 | Optional directories, `references/` |
| P14.3 | None (Highway pattern) |
| P14.4 | File references (boundary 9). Boundaries 10 to 12: None (Highway pattern) |

Rationale: `con_rules` reads every line beginning `| P<n>.<n> |` as a rule row and fails a row
without four cells, and the inventory test counts the same lines. A fifth column would break the
parser contract FR-002 preserves, and a second table keyed by rule id would double-count. A bullet
line beginning `- P14.1:` matches neither. Headings were checked against
https://agentskills.io/specification on 2026-11-13: "Progressive disclosure", "Optional
directories" with a `references/` subsection, "File references", and "`description` field".

Alternatives considered: clause in the Observable cell (mixes what decides PASS with provenance);
a second table (double-counts).

## R3. Precedence

Decision: rank 12, "XIV. Agent Skills Alignment", reason "Governs how a skill's files are laid out
for an Agent Skills client." No other rank changes.

Rationale: no current rule conflicts with a Principle XIV rule. P5.15 moving from rank 4 to rank 12
changes no verdict, because nothing conflicts with it. The inventory test pins ranks 5, 6, and 11,
which stay as they are.

## R4. Definitions

Decision: five rows added to the Definitions table, after **Skill**:

- **Flow file**: a file in a skill's `references/` that the skill's flows table names.
- **Flows table**: the File and Steps table in `SKILL.md` that directly follows the sentence
  "Before a step in this table, read its file and follow it to the end."
- **Step**: a level-3 heading in `SKILL.md` or a flow file, outside a fenced block.
- **Step reference**: a backticked name after "go to", "return to", "follow", "resume at", or
  "stay on", that has no `/` or `.` and does not start with `highway-`.
- **Reply line**: a list item that starts with a backticked reply class and a colon.

Rationale: these are the meanings `framework/lib/flows.sh` and the retired test implement.
Defining them once lets the Observables use them without restating them (P7.3).

## R5. Check design

Decision: four functions in `framework/lib/rule-checks.sh`, `rc_check_P14_1` to `rc_check_P14_4`,
ported from `check_skill` in `tests/skill-flow-pattern.test.sh` with each boundary in exactly one
function. Helpers `rc_p14_step_refs`, `rc_p14_turn_refs`, and `rc_p14_skill_steps` are ported
from `step_refs`, `turn_refs`, and `skill_steps`. The flows table is read only through
`fl_table`, `fl_files`, and `fl_steps`; `rule-checks.sh` sources `flows.sh` when `fl_files` is not
yet defined.

- Each check takes a `SKILL.md`, judges the whole folder, and returns 2 (N/A, condition N4) for any
  other file. That is P5.15's existing guard, and it is what keeps a breach from being reported
  again when `check_bundled` runs the [auto] rules over a flow file, reference, or template
  (FR-010). The exempt-id lists do not change.
- P14.2 passes a skill with no flow files: nothing is out of place. So all 16 skills count the
  four rules as checked (SC-001).
- A cross-skill handoff resolves against the skill folders beside the validated one
  (`dirname` of the skill folder). That is `skills/` in the repository, in a verification tree,
  and wherever a generator validates. A seeded copy in a temporary folder resolves against that
  folder, so a handoff to a skill absent there fails boundary 11, which is the intended verdict.
- Findings name the file and the broken condition and end with `(boundary <n>)`, so a seeded test
  and a reader both see which Phase 13 boundary failed. The validator appends the rule's
  Observable, as for every rule.
- Characters for boundary 1 are counted as bytes (`wc -c`), as the retired test counted them.
  Bytes are never fewer than characters, so the count never passes a file that is over the limit.

Rationale: one function per rule keeps the registry contract unchanged (one id, one function).
Porting the retired test's logic line for line, rather than rewriting it, is what makes "every
skill passes with no skill change" a check on the port: a difference shows a porting error.

Alternatives considered:
- A new library file. Rejected: `rule-checks.sh` already holds every check, and a new file would
  need its own distribution entry.
- Adding P14 ids to every exempt list. Rejected: the N/A guard covers all three bundled kinds in
  one place and matches P5.15.
- Resolving cross-skill handoffs against `$HW_SKILLS`. Rejected: the check would depend on where
  the repository is, not on the tree being validated.

## R6. Validation cache key

Decision: rebuild `vc_key` and `vc_environment_hash` so the file listing is hashed first into a
variable, checked, and only then summarised.

- `vc_hash_list` reads paths into an array and passes them to the hasher as arguments, without
  `xargs`. It prints nothing and returns 1 unless it hashed every path it was given.
- `vc_key` adds to the skill's own files the `SKILL.md` and every `references/` file of each skill named
  by `` in `highway-<name>` `` in the skill's `SKILL.md` or `references/*.md`. A named skill that
  does not exist adds nothing, so creating it changes the key.
- `vc_key` prints a key only when every step produced output and the key is 64 hex characters;
  otherwise it prints nothing. `validate-skill.sh` already treats an empty key as "no lookup, no
  record", so it validates in full.
- `vc_environment_hash` fails the same way and is not memoised when it fails.

Rationale: the defect was a pipeline: `xargs` failed in the sandbox, and the next stage hashed
empty input into a constant, so every skill shared one key. Hashing a checked listing fails closed.
Naming only the skills a handoff names keeps a change to one skill from invalidating every other
skill's verdict.

Alternatives considered: hashing every sibling skill (correct, but any skill change revalidates
all 16); `set -o pipefail` inside the subshell (does not catch a hasher that prints nothing).

## R7. Where the seeded cases live, and D3.7

Decision: the seeded cases go into `tests/rule-checks.test.sh`, which already seeds one violation
per rule and asserts the validator reports it.

- Twelve cases copy `tests/fixtures/flow-skill`, apply the retired test's seeds 1 to 12 unchanged,
  and assert the `FAILED:` line lists exactly the boundary's rule.
- Four cases use the test's base skill, which has no `references/`, and assert the rule is reported.
- An unseeded copy of each passes with every P14 rule in `CHECKED:`.

D3.7 binds the Development Constitution's Enforcement Map, whose rows are D rules. P rules are
held to the inventory test's [auto] assertion, which requires a registered check per [auto] rule.
That assertion is what makes P14.1 to P14.4 registered before the constitution tags them.

## R8. Retiring `tests/skill-flow-pattern.test.sh`

Decision: delete it once R7's cases pass. The removal is recorded with its reason (D3.5) in the
Sync Impact Report and in `standard-alignment.md`'s Phase 15 Status. Each of its twelve seeds is
reproduced byte for byte in `tests/rule-checks.test.sh`, so no breach it caught goes uncaught.
`framework/authoring-standard.md` line 201 cites P14.1 to P14.4 instead. The Enforcement Map does
not name the test, so it does not change.

## R9. Counts and fixed text

Decision: `tests/constitution-experience-alignment.test.sh` expects 80 rules. No test pins the
[auto] count numerically; the inventory test derives it. `require_text 'P1.1-P1.4, P6.4, P6.6, and
P7.3'` and `'P10.1 remains the generic Experience delegation rule'` remain true, because the
Self-Application paragraph keeps those phrases and gains one sentence on P5.15.

## R10. D3.4: evaluating the checks before registration

Decision: before the registry rows are added, run each `rc_check_P14_*` function directly against
all 16 `skills/*/SKILL.md` and every `tests/fixtures/*/SKILL.md`. Record each verdict in tasks.md.
Expected: every skill and every fixture passes, because the retired test passes every skill and
the fixture, and the other fixtures have no flows table, no `references/`, and no handoffs.
