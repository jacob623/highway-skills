<!--
Sync Impact Report
Version change: 2.2.0 → 2.3.0 (MINOR)
Bump rationale: Principle IX and rule P9.1 are added without invalidating a conforming skill;
  the two existing file-emitting skills are migrated and verified before the rule is enabled.
  The shared output-template citation is an authoring obligation and does not prescribe user-owned
  record values.
Added principle: IX. Shared Output Contracts (P9.1).
Added rule: P9.1, requiring file-emitting skills to cite a complete shared output template.
Verified before enabling: highway-nfrs and highway-controls cite complete templates and preserve
  their existing frontmatter and body contracts.
Self-application review: P1.1, P1.3, P6.4, P6.6, and P7.3 PASS; the amendment names the new
  rule and distinguishes citation from runtime output conformance.

Previous amendment:
Version change: 2.1.0 → 2.2.0 (MINOR)
Bump rationale: a section is added — the Prohibited Nondeterministic Criterion Tokens list.
  Classified against this document's Versioning Policy rather than by analogy: MINOR covers a
  principle, section, or rule added without invalidating a conforming artifact, and a section is
  added. The P2.3 retag considered alone would have been neither MAJOR (nothing removed,
  redefined, or strengthened) nor MINOR (nothing added), leaving PATCH by elimination; the higher
  classification governs, so the amendment is MINOR. No obligation is strengthened: P6.4's rule
  text is unchanged and only its enforcement becomes real, so a skill that violated it was always
  violating it and simply was not told.
Added sections:
  - Prohibited Nondeterministic Criterion Tokens: the vocabulary P6.4 prohibits in a decision
    criterion, in three groups — time, randomness, and agent preference. Declared here rather
    than inside a script so the boundary is reviewable and changing it is an amendment. Carries
    the same two exclusions as the Prohibited Vagueness List.
Removed sections: none.
Added rules: none. Removed rules: none. Rule count: 49, unchanged.
Modified rules:
  - P2.3 retagged [auto] → [agent-checkable]. Rule text and Observable are unchanged. Reason:
    checking for the literal word "Illustrative" is trivial, but deciding whether a passage is a
    technology-specific example is semantic, and no mechanical proxy covers it honestly. Treating
    a language-tagged fenced block as the signal was considered and rejected because it
    under-detects — an example in inline prose or an untagged fence would pass while the tier
    still claimed full automation, which is a subtler form of the same false claim.
Tier counts: [auto] 15 → 14 (P2.3 leaves); [agent-checkable] 34 → 35; [human-review] 0,
  unchanged.
Enforcement change: P6.4 is now decided automatically by rc_check_P6_4 and reported under its own
  rule ID. The check is scoped to the "When to use" and "When not to use" sections, because a
  decision criterion lives there and scoping structurally avoids having to recognise a criterion
  by meaning. It is exempted for library files, which have no such sections.
Conformance impact: no conforming artifact is invalidated. Verified 2026-09-08 before the check
  was registered: all eight skill fixtures, highway-help, _authoring-standard.md, and every
  library file pass P6.4, and no fixture's verdict changes.
Provenance: this amendment is the work feature 003 deferred to "amendment 2.0.2", which never
  happened — this document went 2.0.1 → 2.1.0 and skipped it. Tasks T046 and T047 of that
  feature are superseded here and are left unedited in their own spec record.
Templates and dependent artifacts:
  - .highway/skills/_authoring-standard.md cites P6.4 by ID and restates no rule text, per P7.3.
  - .highway/tools/lib/rule-checks.sh registers rc_check_P6_4 and exempts it for library files.
  - .highway/tools/tests/constitution-inventory.test.sh asserts that every rule this document
    tags [auto] has a registered check, so the tier cannot drift back out of honesty. That guard
    covers this document only, and says so; the Highway Development Constitution has the same
    defect and is addressed separately.
Follow-up TODOs closed by this amendment:
  - AUTO_TIER_ENFORCEMENT: satisfied. Two rules were tagged [auto] with no script deciding them,
    which the validator reported in every run as "UNCHECKED: P2.3 P6.4". P6.4 now has a check;
    P2.3 is retagged to the tier that describes how it is actually decided. The unchecked group
    is empty for every skill, and the inventory test fails if that ceases to be true.
Follow-up TODOs: none.
-->

# Highway Skills Constitution

## Definitions

These definitions are normative. A term defined here carries this meaning everywhere in this
document and in every skill governed by it.

| Term | Definition |
|---|---|
| **MUST**, **MUST NOT** | An absolute obligation. A conforming artifact satisfies it in every case. Non-satisfaction is a FAIL. |
| **SHOULD** | An obligation that applies unless the artifact contains a written exception naming the condition that displaces it. Absent that written exception, SHOULD is evaluated as MUST. |
| **Skill** | A single file, `SKILL.md`, plus its directory, that instructs an agent how to perform one category of task. |
| **Agent** | Any automated system that reads a skill and acts on it, or that evaluates an artifact against this constitution. |
| **Normative rule** | A line containing MUST, MUST NOT, or SHOULD that states an obligation. |
| **MUST-level rule** | A normative rule whose keyword is MUST or MUST NOT. The hyphenated token `MUST-level` names this category and is not itself a keyword occurrence. |
| **Normative section** | A body section of a skill that contains at least one normative rule. |
| **Skill contract** | A skill's declared Inputs, declared Outputs, and Verification criteria, taken together. |
| **Behavioral guarantee** | A statement in a skill asserting what will be true after the skill is followed. |
| **Breaking change** | A change that removes, narrows, or redefines any element of a skill contract or behavioral guarantee. |
| **Observable** | The specific condition, countable property, or command result that decides PASS or FAIL for one rule. |
| **Tier** | How a rule is decided: `[auto]`, `[agent-checkable]`, or `[human-review]`, defined in the Compliance Review Protocol. |
| **Security-affecting** | Guidance that touches any item in the Security Gate trigger list. |
| **Declared input** | A value, file, or precondition named in a skill's Inputs section. |
| **Verdict** | One of exactly three tokens: PASS, FAIL, N/A. No other token is a verdict. |

### Prohibited Vagueness List

The following terms carry no decidable meaning on their own. Two locations are excluded from
every check that references this list: occurrences inside this list itself, and occurrences
inside the section titled "Illustrative Examples (Non-Normative)".

> appropriate, reasonable, reasonably, competent, clean, best, proper, adequate, sufficient,
> proportional, material, materially, significant, genuine, genuinely, broadly recognized,
> well-known, obvious, non-obvious, class of, sensitive, robust, effective, as needed,
> where relevant, if necessary

### Prohibited Nondeterministic Criterion Tokens

The following terms make a decision criterion depend on when it is read, on chance, or on the
reader's taste, so the same input can yield different decisions. This list is referenced by P6.4,
which applies to the sections of a skill that state when it does and does not apply. Two locations
are excluded from every check that references this list: occurrences inside this list itself, and
occurrences inside the section titled "Illustrative Examples (Non-Normative)".

> currently, nowadays, recently, lately, at present, for now, latest, most recent, up to date,
> random, randomly, at random, arbitrary, arbitrarily, whichever, any of them,
> prefer, prefers, prefer to, preferred, preferably, preference, idiomatic, cleaner, nicer,
> tasteful, feels right

### Approved Authority Sources

This list is closed. A citation that names no item on this list does not satisfy P3.1.

| ID | Source |
|---|---|
| **AS-1** | A published standard from ISO, IETF (RFC), W3C, or ECMA |
| **AS-2** | OWASP Top 10, OWASP ASVS, or a CWE entry |
| **AS-3** | A NIST publication, including the SP 800 series |
| **AS-4** | The official documentation of a language, runtime, or tool named in the skill's Purpose |
| **AS-5** | A peer-reviewed publication, cited by title and year |
| **AS-6** | A written policy file stored in this repository, cited by path |

#### Citation Format

A citation is the token `AS-N` followed by a colon and the section, control, or heading
identifier, enclosed in square brackets:

    [AS-2: A03:2021 Injection]
    [AS-6: .highway/skills/_authoring-standard.md]

A citation written in any other form does not satisfy P3.2 or P3.5.

## Core Principles

Every rule below carries four elements, per row: a stable ID, exactly one keyword, an
Observable, and a Tier tag. A rule that cannot be given an Observable is rewritten or removed,
never softened. Rule IDs are stable across amendments; a retired ID is never reused.

### I. Unambiguous, Actionable Directives

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P1.1 | A normative rule MUST contain exactly one keyword. | The rule line contains one of MUST, MUST NOT, SHOULD, and no second keyword. Occurrences of the token `MUST-level` are not counted. | [auto] |
| P1.2 | A normative rule MUST state exactly one obligation. | The rule states one required action; it joins no second obligation with "and" or "or". | [agent-checkable] |
| P1.3 | A normative rule MUST NOT exceed 25 words. | Word count of the rule text is 25 or fewer. | [auto] |
| P1.4 | A skill MUST NOT use a Prohibited Vagueness List term in a normative rule without an inline parenthetical defining a countable condition. | Each occurrence of a listed term is followed by a parenthetical stating a number, unit, or enumerated set. | [agent-checkable] |
| P1.5 | A skill MUST name every tool, file, and prior step it depends on. | Each dependency appears by name in the Inputs section. | [agent-checkable] |
| P1.6 | A skill MUST NOT instruct an agent to request clarification about the meaning of the skill's own steps. | No step directs the agent to ask what a step means. | [agent-checkable] |
| P1.7 | A skill MUST require clarification when a declared input is absent or self-contradictory. | The Error Handling section names this condition and directs escalation. | [agent-checkable] |

Rationale: One obligation per addressable line is what allows a rule to be cited, checked, and
failed on its own.

### II. Technology-Agnostic Portability

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P2.1 | A skill MUST NOT name a model, vendor, or tool in a normative rule unless its stated Purpose names that technology. | Every technology named in a rule also appears in the `## Purpose` section. | [agent-checkable] |
| P2.2 | A skill that depends on a named technology MUST declare that dependency. | The technology appears by name in the Inputs section. | [agent-checkable] |
| P2.3 | A technology-specific example MUST be labeled "Illustrative". | The example carries the literal word "Illustrative". | [agent-checkable] |
| P2.4 | An illustrative example MUST sit outside every numbered rule list. | No example text appears inside a rule table or numbered rule list. | [agent-checkable] |
| P2.5 | A skill MUST state outcomes as verifiable properties rather than as named implementations. | Each stated outcome names a checkable property, not a specific product. | [agent-checkable] |

Rationale: A skill that hard-codes an incidental technology stops working when that technology
is replaced.

### III. Grounding in Approved Authority Sources

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P3.1 | Every MUST-level rule in a skill MUST cite one Approved Authority Source. | The rule names an AS-1 through AS-6 source. | [agent-checkable] |
| P3.2 | A citation MUST name the source and its specific section, control, or identifier. | The citation matches the Citation Format and its identifier field is non-empty. | [agent-checkable] |
| P3.3 | A skill MUST NOT encode a naming, formatting, or architectural preference as a MUST-level rule without a citation. | Every such rule carries an AS-1 through AS-6 citation. | [agent-checkable] |
| P3.4 | A rule that applies only under a condition MUST state that condition. | The rule text contains an explicit "when", "if", or "unless" clause. | [agent-checkable] |
| P3.5 | A skill MUST NOT cite a source outside the Approved Authority Sources list. | Every citation matches the Citation Format and its `AS-N` token resolves to AS-1 through AS-6. | [auto] |

Rationale: A closed source list makes grounding decidable instead of leaving it to the
evaluator's knowledge.

### IV. Measurable Quality Gates

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P4.1 | Every quality claim MUST be paired with one check that returns pass or fail. | The claim is followed by a named command, threshold, or file-state check. | [agent-checkable] |
| P4.2 | A skill MUST NOT use "secure", "performant", or "maintainable" as an acceptance criterion. | None of the three words appears in an acceptance criterion. | [auto] |
| P4.3 | Each applicable gate MUST name its verification command or check in the skill. | For each gate whose trigger is true, a named check appears. | [agent-checkable] |
| P4.4 | A numeric threshold MUST state a number and a unit. | The threshold contains a numeral and a unit token. | [agent-checkable] |
| P4.5 | A skill MUST NOT instruct disabling verification, hardcoding credentials, or bypassing input validation. | No step directs any of these three actions. | [agent-checkable] |
| P4.6 | A skill MUST require the agent to report a suspected vulnerability rather than altering it silently. | The Error Handling section directs reporting on this condition. | [agent-checkable] |

Rationale: A quality goal with no check attached cannot be satisfied on purpose, only by
accident.

### V. Reusable Patterns and Defined Error Handling

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P5.1 | Every workflow step MUST define its failure detection condition. | Each step has a stated exit code, output string, or file state that signals failure. | [agent-checkable] |
| P5.2 | Every failure condition MUST name exactly one next action from: retry, abort, escalate, fall back. | The condition names one of the four tokens. | [auto] |
| P5.3 | A retry action MUST state a maximum attempt count. | A numeral follows the retry instruction. | [auto] |
| P5.4 | A fall back action MUST name its alternative by identifier. | The alternative is named by step number, command, or skill id. | [agent-checkable] |
| P5.5 | A skill MUST NOT leave a step without an error path. | Every numbered step maps to an Error Handling entry. | [agent-checkable] |
| P5.6 | A skill MUST apply to two or more triggering scenarios. | The "When to use" section lists at least two scenarios. | [agent-checkable] |

Rationale: Undefined error paths are where agent behavior stops being predictable.

### VI. Deterministic, Explicit Decision Criteria

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P6.1 | Every choice between two or more actions MUST be governed by an ordered list, a decision table, or a numeric threshold. | The choice point is followed by one of those three structures. | [agent-checkable] |
| P6.2 | Decision criteria MUST cover every input they can receive. | The structure ends with an explicit default or "otherwise" branch. | [agent-checkable] |
| P6.3 | A skill MUST NOT leave a choice to agent discretion without naming its bounding constraints. | Each discretionary point lists the constraints that bound it. | [agent-checkable] |
| P6.4 | A decision criterion MUST NOT reference time, randomness, or agent preference. | No criterion names a clock, a random value, or a preference. | [auto] |
| P6.5 | Ordered criteria MUST be evaluated in their stated order. | The structure states its evaluation order explicitly. | [agent-checkable] |
| P6.6 | Applying the criteria to identical inputs MUST select the same action every run. | No branch condition depends on a value outside the declared inputs. | [agent-checkable] |

Rationale: Verdict invariance across evaluators is possible only when the decision path is
fully written down.

### VII. Long-Term Maintainability

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P7.1 | A skill MUST declare exactly one Purpose. | A section titled `## Purpose` is present and contains exactly one sentence. | [auto] |
| P7.2 | A skill MUST carry a semantic version. | `metadata.version` matches MAJOR.MINOR.PATCH. | [auto] |
| P7.3 | A skill MUST NOT restate a normative rule defined in another skill. | Duplicated rules are replaced by a cross-reference naming the other skill id. | [agent-checkable] |
| P7.4 | A skill MUST NOT contain more than 12 MUST-level rules. | Count of MUST and MUST NOT rules is 12 or fewer. | [auto] |
| P7.5 | A normative section MUST NOT exceed 400 words. | Word count per normative section is 400 or fewer. | [auto] |
| P7.6 | A skill exceeding P7.4 or P7.5 MUST be split into two or more skills. | Each resulting skill satisfies P7.4 and P7.5. | [agent-checkable] |
| P7.7 | A breaking change to a skill contract MUST increment MAJOR per the Skill Versioning Policy. | The version increment matches the change classification. | [agent-checkable] |

Rationale: A skill is a long-lived artifact and is held to the maintainability standard it
imposes on code.

### VIII. Reliability and Repeatability

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P8.1 | Workflow steps MUST be numbered. | Each step carries a sequential numeral. | [auto] |
| P8.2 | A skill MUST state every ordering dependency between its steps. | Each dependent step names the step it follows. | [agent-checkable] |
| P8.3 | A skill MUST contain a Verification section. | A section titled Verification is present and non-empty. | [auto] |
| P8.4 | The Verification section MUST name at least one command, file state, or output string to check. | One checkable item is named. | [agent-checkable] |
| P8.5 | A skill MUST require the agent to read and state project configuration that changes its output. | Each configuration-dependent step directs the agent to read and report that value. | [agent-checkable] |
| P8.6 | A skill MUST NOT rely on an environment default it has not stated. | Every default value the skill assumes appears in its text. | [agent-checkable] |
| P8.7 | A skill MUST NOT link to a relative path. | No Markdown link target in the skill body is a relative filesystem path. | [auto] |

Rationale: Repeatability is what allows a skill to be reused without re-verifying it every
time.

### IX. Shared Output Contracts

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P9.1 | A skill that emits a file MUST cite a shared template for that file's complete structure. | The Outputs section names a path under `.highway/library/templates/output/` and does not restate the template's frontmatter or body structure as a separate contract. | [auto] |

Rationale: A shared complete skeleton prevents two skills producing the same kind of record from
silently diverging in metadata or body structure.

## Principle Precedence

When two rules conflict, the rule belonging to the higher-ranked principle prevails. This
ordering is total: every pair of principles has a defined winner.

| Rank | Principle | Reason for rank |
|---|---|---|
| 1 | IV. Measurable Quality Gates | Carries the security-affecting rules P4.5 and P4.6. |
| 2 | I. Unambiguous, Actionable Directives | A rule that cannot be read one way cannot be applied at all. |
| 3 | VI. Deterministic, Explicit Decision Criteria | Determines which action an agent selects at runtime. |
| 4 | V. Reusable Patterns and Defined Error Handling | Governs behavior when a step fails. |
| 5 | VIII. Reliability and Repeatability | Governs whether the outcome can be confirmed. |
| 6 | VII. Long-Term Maintainability | Governs cost over time rather than correctness now. |
| 7 | II. Technology-Agnostic Portability | Governs reach across environments. |
| 8 | III. Grounding in Approved Authority Sources | Governs provenance of a rule already stated. |

**Security override**: a rule tagged security-affecting outranks every rule in every principle,
including rank 1 rules that are not security-affecting.

**Tie-break for rules of equal rank** (two rules within one principle), applied in this order:

1. A MUST NOT rule prevails over a MUST rule, which prevails over a SHOULD rule.
2. If step 1 does not resolve, the rule with the lower rule number prevails.

These two steps always resolve, because no two rules share a rule number.

## Quality Gates and Binary Trigger Tests

Each gate below applies to a skill only when its trigger test evaluates true. A gate whose
trigger evaluates false is recorded as N/A under condition N1. No gate uses a scope phrase
broader than its trigger list.

### Code Generation Gate

**Trigger**: the skill instructs an agent to create or modify a source file.

When triggered, the skill MUST name the command an agent runs to confirm correctness before
reporting the task complete. The named command MUST be one of: a test command, a build
command, or a lint command.

### Testing Gate

**Trigger**: the skill instructs an agent to create or modify executable behavior.

When triggered, the skill MUST state the required test action using this table, and MUST state
what result counts as passing.

| Change type | Required test action |
|---|---|
| New behavior added | Add a test asserting the new behavior; the test fails before the change and passes after. |
| Existing behavior modified | Update the test that asserts the old behavior to assert the new behavior. |
| Defect repaired | Add a test that reproduces the defect and fails before the repair. |
| Refactor with no behavior change | Run the existing suite unchanged; every test passes. |
| Dependency version changed | Run the existing suite unchanged; every test passes. |
| Comment, documentation, or formatting change only | No test action required. |

### Security Gate

**Trigger**: the skill's guidance touches any of: authentication, authorization, input
handling, secrets or credentials, network calls, file writes outside the working directory,
deserialization of external data, cryptography, or dependency selection.

When triggered, the skill MUST cite AS-2 and MUST satisfy P4.5 and P4.6. Rules produced under
this gate are security-affecting and take the Security override in Principle Precedence.

### Maintainability Gate

**Trigger**: the skill produces or modifies a file that is retained after the task completes.

When triggered, the skill MUST require a comment only where the comment states intent that the
code does not state, and MUST NOT require a comment that restates the adjacent line.

### Performance Gate

**Trigger**: the skill's guidance names a loop over unbounded input, a network call, a
database query, or a file-system scan.

When triggered, the skill MUST require the agent to state the cost as either an algorithmic
complexity expression or a measured number with a unit.

## Compliance Review Protocol

### Tiers

| Tag | Meaning | Who decides |
|---|---|---|
| `[auto]` | Decidable by a deterministic script with no model involved. | Tooling |
| `[agent-checkable]` | Decidable by any conforming agent from the artifact text alone, with no judgment and no knowledge beyond this document. | Agent |
| `[human-review]` | Requires human judgment. | Human |

A reviewing agent MUST NOT emit a verdict for a rule tagged `[human-review]`. Those rule IDs
are listed in a separate DEFERRED block for a human. DEFERRED is a block name, not a verdict.

### Required output shape

A review emits exactly one line per rule ID, in ascending rule ID order, in this form:

    <RULE-ID> | <VERDICT> | <EVIDENCE>

- `<VERDICT>` is exactly one of `PASS`, `FAIL`, `N/A`. No other token is permitted.
- A `PASS` line MUST carry evidence: either quoted text of 25 words or fewer copied from the
  artifact, or a file path plus a line number.
- A `FAIL` line MUST carry either the same evidence form pointing at the violation, or the
  literal token `ABSENT` when the required element does not exist.
- An `N/A` line MUST name one condition ID from the table below. An `N/A` line that names no
  condition ID is itself recorded as a `FAIL`.

After the per-rule lines, the review emits a DEFERRED block listing every `[human-review]` rule
ID, then a single summary line stating the count of each verdict.

### Permitted N/A conditions

This list is closed.

| ID | Condition |
|---|---|
| **N1** | The rule belongs to a quality gate whose trigger test evaluates false. |
| **N2** | The rule governs a skill section that this artifact type is not required to contain. |
| **N3** | The rule governs amendment of this constitution, and the reviewed artifact is not this constitution. |
| **N4** | The rule's stated scope names an artifact type that the reviewed artifact is not. |

### Merge decision

One or more `FAIL` verdicts blocks merge. A review containing an unresolved DEFERRED block
blocks merge until a human records a verdict for each deferred rule ID.

## Skill Authoring Workflow

1. Write the skill with all required sections present: Purpose, When to use, When not to use,
   Inputs, Outputs, Verification, Error Handling.
2. Evaluate each of the five quality gate triggers and record which evaluate true.
3. Run the Compliance Review Protocol against every rule ID in this document.
4. Resolve every `FAIL` before requesting merge.

### Overlap resolution

Count the MUST-level rules in the new skill that restate a MUST-level rule in an existing
skill. Divide by the count of MUST-level rules in the new skill.

- If the result exceeds 0.50, consolidate the two skills into one.
- Otherwise, remove the restated rules and replace them with a cross-reference naming the
  other skill's id.

Exactly one branch applies to any input, so this rule selects one action every time.

### Breaking changes

A change to a skill contract or a behavioral guarantee MUST be named in the change description
and classified per the Skill Versioning Policy.

## Illustrative Examples (Non-Normative)

These examples illustrate two principles. They state no obligation and are excluded from every
compliance review.

**Illustrative, for Principle I:**

| Non-compliant | Compliant |
|---|---|
| "Add adequate test coverage for the change." | "Add one test asserting the new behavior. The test fails before the change and passes after." |

**Illustrative, for Principle VI:**

| Non-compliant | Compliant |
|---|---|
| "Choose the best error-handling strategy for the situation." | "If the failure is a network timeout, retry up to 3 times. If the failure is a 4xx response, abort. Otherwise, escalate." |

## Governance

This constitution supersedes every other skill-authoring document in this repository when a
conflict exists. Conflicts between rules inside this document are resolved by Principle
Precedence.

Every new or amended skill MUST pass the Compliance Review Protocol before merge. A skill that
cannot satisfy a rule MUST record a written exception in the skill file naming the rule ID and
the condition that displaces it; silent deviation is a FAIL.

### Self-Application

This constitution is itself subject to P1.1 through P1.4 (clarity), P6.4 and P6.6
(determinism), and P7.3 (non-duplication). Every amendment MUST record a review against those
rule IDs. Rules P7.4 and P7.5 state limits on skills and do not apply to this document.

### Constitution Versioning Policy

Amendments are made by editing this file and MUST include an updated Sync Impact Report as an
HTML comment at the top of the file. Versioning follows semantic versioning:

- **MAJOR**: a principle or governance rule is removed or redefined, or an obligation is
  strengthened so that a previously conforming artifact now fails.
- **MINOR**: a principle, section, or rule is added without invalidating a conforming artifact.
- **PATCH**: wording or typo repair with no change to any Observable.

### Skill Versioning Policy

Each skill carries its own semantic version, independent of this document's version and of
every other skill's version. This is the policy referenced by P7.7.

- **MAJOR**: a breaking change, as defined in Definitions, to the skill contract or a
  behavioral guarantee.
- **MINOR**: a capability is added while every existing contract element continues to hold.
- **PATCH**: wording repair with no change to Inputs, Outputs, or Verification.

**Version**: 2.2.0 | **Ratified**: 2026-09-06 | **Last Amended**: 2026-09-08
