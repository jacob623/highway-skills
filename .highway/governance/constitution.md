<!--
Sync Impact Report
Version change: 8.0.0 → 9.0.0 (MAJOR), 2026-10-06
Bump rationale: the Constitution's remaining broad decision criteria and failure inheritance wording
are narrowed to development validation of effective shipped runtime contracts. Experience delegation,
context roles, and owner persistence are kept with their runtime owners.
Changed elements:
- Principles V, VI, XI, and XII are narrowed or redefined for effective shipped runtime contracts.
- P5.14 and P13.1 are retired. P13.2 is relocated into Principle XII without changing its obligation.
  P1.7, P6.1-P6.5, P7.3, P11.2, and P11.3 are redefined. Surviving IDs are not renumbered.
- Principle XIII is removed because its remaining obligation belongs with owner-controlled orchestration.
- Principle Precedence, Governance, Self-Application, and the dependency direction remain development-only.
Downstream skills that still reference Constitution-owned failure wording remain later cleanup work;
this amendment does not edit them.
Protected artifacts: the Experience Standard, Highway Identity, individual skills, runtime templates,
and persisted outputs are unchanged.
Self-application review: P1.1-P1.4, P6.4, P6.6, and P7.3 are rechecked against the amended document;
the amendment preserves stable IDs, effective-contract ownership, and registered observables and tiers.

Sync Impact Report
Version change: 6.1.0 → 7.0.0 (MAJOR), 2026-10-06
Bump rationale: The Converged Proposal definition and P12A.2 Observable are redefined so owner
completeness no longer establishes conversational convergence by itself. The Constitution now
delegates visible collaborative development and convergence semantics to the Experience Standard
while retaining authority, transience, accepted repository knowledge, owner mutation, persistence,
and orchestration boundaries.
Changed elements:
- Version footer: 6.1.0 → 7.0.0. Last Amended becomes 2026-10-06.
- Working Idea and Converged Proposal definitions, Accepted User-Owned Artifact wording, P12A.2,
  Principle XIII introduction/rationale/lifecycle, and Self-Application review.
- Experience Standard owns visible collaborative-development and convergence semantics; owner and
  orchestration rules remain Constitution-owned.
Unchanged: P12A.1, P12A.3, P12A.4, Principles X, XI, and XII, Principle Precedence, owner mutation,
persistence, orchestration behavior, and runtime schemas. Downstream review is limited to inconsistent
Converged Proposal references.
Self-application review: P1.1-P1.4, P6.4, P6.6, and P7.3 PASS; P12A.1-P12A.4 remain individually
addressable; P12A.2 delegates convergence without duplicating X2.41; owner and orchestration rules
remain unchanged.

Sync Impact Report
Version change: 6.0.0 → 6.1.0 (MINOR), 2026-10-02
Bump rationale: Principle XII-A and rules P12A.1–P12A.4 add collaborative knowledge boundaries
without changing existing owner-controlled completion rules or invalidating conforming artifacts.
Changed elements:
- Version footer: 6.0.0 → 6.1.0. Last Amended becomes 2026-10-02.
- Added definitions: Accepted Repository Knowledge, Active Reasoning Context, Working Idea,
  Converged Proposal, and Accepted User-Owned Artifact.
- Added principle: XII-A. Collaborative Knowledge Development, with P12A.1–P12A.4.
- Updated Principle Precedence to place XII-A below X and above XI.
- Updated Repository Context, Governance, Self-Application, rule counts, and lifecycle boundary.
- Recorded synchronization impact for Experience Standard, highway-profile, highway-objectives,
  highway-controls, highway-nfrs, and future Architecture/ADR workflows.
Self-application review: P12A.1–P12A.4 each have one normative keyword, one obligation, one
Observable, and the [agent-checkable] tier; no rule prescribes conversational technique or durable
reasoning state. Rollout order: Highway Identity, Experience Standard, highway-profile, behavioral
testing, highway-objectives, highway-controls, highway-nfrs, then architecture workflows.
Rule count: 77. Tier counts: [auto] 13, [agent-checkable] 64, [human-review] 0.

Previous amendment:
Version change: 5.0.0 → 6.0.0 (MAJOR), 2026-09-30
Bump rationale: P12.13–P12.15 strengthen owner-mutation, owner-result, and orchestration-completion obligations so previously conforming work may fail.
Changed elements:
- Version footer: 5.0.0 → 6.0.0. Ratified stays 2026-09-06. Last Amended becomes 2026-09-30.
- Added rule rows: P12.13, P12.14, and P12.15.
- Updated Principle XII rationale, precedence reason, rule counts, and acceptance-to-owner-result persistence boundary.
Rule count: 73. Tier counts: [auto] 13, [agent-checkable] 60, [human-review] 0.
Self-application review: P1.1–P1.4, P6.4, P6.6, and P7.3 were reviewed. P12.13–P12.15 each have one keyword, one obligation, one Observable, and the [agent-checkable] tier.

Sync Impact Report
Version change: 4.1.0 → 5.0.0 (MAJOR), 2026-09-29
Bump rationale: P7.6 is redefined. An oversized skill is reduced until it meets P7.4 and P7.5. Redefining a governance rule is MAJOR under the Constitution Versioning Policy.
Changed elements:
- Version footer: 4.1.0 → 5.0.0. Ratified stays 2026-09-06. Last Amended stays 2026-09-29.
- Redefined rule row: P7.6.
Unchanged elements: every other current rule, principle precedence, and the older sync reports.
Self-application review: P1.1, P1.2, P1.3, P1.4, P6.4, P6.6, and P7.3 were reviewed. The redefined row has one keyword, one obligation, and no more than 25 words.

Sync Impact Report
Version change: 4.0.0 → 4.1.0 (MINOR), 2026-09-29
Bump rationale: P9.2 through P9.8 place existing output obligations in Principle IX. Precedence is unchanged. Adding rules without invalidating conforming work is MINOR.
Changed elements:
- Version footer: 4.0.0 → 4.1.0. Last Amended stays 2026-09-29.
- Added rule rows: P9.2, P9.3, P9.4, P9.5, P9.6, P9.7, P9.8.
- P9.5 is [auto]. P9.2, P9.3, P9.4, P9.6, P9.7, and P9.8 are [agent-checkable].
Self-application review: P1.1, P1.2, P1.3, P1.4, P6.4, P6.6, and P7.3 were reviewed. Each added row has one keyword, one obligation, and no more than 25 words.

Sync Impact Report
Version change: 3.0.1 → 4.0.0 (MAJOR), 2026-09-29
Bump rationale: multiple governance rules are removed or redefined, including Principle XII.
Removing or redefining a governance rule is MAJOR under the Constitution Versioning Policy.
Changed elements:
- Version footer: 3.0.1 → 4.0.0. Last Amended: 2026-09-25 → 2026-09-29.
- Retired rule rows: P3.1, P4.1, P4.3, P5.1, P5.2, P5.3, P5.4, P5.5, P8.1, P11.5, P12.1, P12.2, P12.3, P12.4.
- Redefined rule rows: P1.7, P3.3, P7.3, P8.2, P8.4, P9.1, P10.1, P11.1, P11.2, P11.3, P11.4, P12.5.
- Added rule rows: P5.7, P5.8, P5.9, P5.10, P5.11, P5.12, P5.13, P5.14, P12.6, P12.7, P12.8, P12.9, P12.10, P12.11, P12.12.
- Principle XII is renamed Owner-Controlled Completion and Orchestration. Precedence rank stays 5. The rank reason describes owner-controlled completion.
- Removed sections: Code Generation Gate, Testing Gate, Maintainability Gate, Performance Gate, Compliance Review Protocol, Skill Authoring Workflow, merge decision, N5, N6, N7, N8, N9, Persistence Verification, and Verified Completion Claim.
- The Security Gate applies when the skill performs the triggering action.
- The approved-source list stays closed. A later amendment may add an entry that names its provenance.
Self-application review: P1.1, P1.2, P1.3, P1.4, P6.4, P6.6, and P7.3 were reviewed. Each new or redefined row has one keyword, one obligation, and no more than 25 words. This report cites identifiers.

Sync Impact Report
Version change: 3.0.0 -> 3.0.1 (PATCH), 2026-09-25
Bump rationale: the Repository Context Document definition explicitly includes user-owned
organizational context already listed by Principle XI, without changing principle precedence or
the P11 obligations.
Changed elements: Repository Context Document definition and synchronized descriptive context text.
Self-application review: P1.1, P1.3, P6.6, and P7.3 pass; no Principle Precedence change occurs.
Compliance Review Protocol evidence: constitution-inventory.test.sh, coverage-summary.test.sh, and
constitution-profile-context.test.sh pass; the amendment changes no rule Observable or Tier.

Sync Impact Report
Version change: 2.6.0 → 3.0.0 (MAJOR), 2026-09-24
Bump rationale: moves Principle XII directly after Principle V, changing which principle prevails
when Persistence and Completion Integrity conflicts with Principles VIII, VII, II, III, X, or XI.
This changes constitutional conflict-resolution behavior and is classified as MAJOR under the
Constitution Versioning Policy, independently from the Experience Standard wording correction.
Changed elements: Principle Precedence ordering and affected ranks, duplicate Principle XI history,
and this amendment's semantic-version metadata.
Unchanged elements: principle identifiers, rule identifiers, normative rule text, rule Tiers, N/A
conditions, and the relative order of unaffected principles.
Self-application review: the precedence change is a constitutional conflict-resolution amendment;
P1.1-P1.4, P6.6, P7.3, and the amendment's own version classification were reviewed.

Previous amendment:
Version change: 2.5.0 → 2.6.0 (MINOR)
Bump rationale: Principle XII and rules P12.1-P12.5 add verified retained-output completion
without invalidating unchanged skills; existing skills remain grandfathered until amendment.
Reconciled metadata: the prior completed report declared 2.5.0 while the footer remained 2.4.0;
the footer was reconciled to 2.5.0 before calculating this amendment.
Added principle: XII. Persistence and Completion Integrity (P12.1-P12.5).
Added definitions: Retained Output, Persistence Verification, Completion Claim, and Verified
Completion Claim.
Added permitted N/A conditions: N6-N9, registered here as the sole authoritative vocabulary.
Rule count: 59. Tier counts: [auto] 14, [agent-checkable] 45, [human-review] 0.
Self-application review: P12.1-P12.4 are N/A under N6 for this constitution's no Retained Output;
P12.5 is evaluated by its orchestration trigger. P1.1-P1.4, P6.4, P6.6, and P7.3 pass.

Bump rationale: Principle XI and rules P11.1-P11.5 are added without invalidating a conforming
skill; Experience Compliance governs newly created and amended skills while unchanged skills remain
grandfathered.
Added principle: XI. Repository Context (P11.1-P11.5).
Added obligations: context declaration, relevant-only consumption, available-context use, workflow
input ownership, and absent-context verification.
Verified before enabling: the existing parser reads P and X namespaces, the five-group coverage
contract remains unchanged, and focused review-output tests cover PASS, FAIL, and N/A reporting.
Self-application review: P10.1 and P10.2 reference Experience Standard compliance and exception
accountability without restating X2.2-X2.8 rule text; P11.1-P11.5 define context use without
restating Experience Standard interaction rules.

Previous amendment:
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
Added rules: P11.1-P11.5. Removed rules: none. Rule count: 54.
Modified rules:
  - P2.3 retagged [auto] → [agent-checkable]. Rule text and Observable are unchanged. Reason:
    checking for the literal word "Illustrative" is trivial, but deciding whether a passage is a
    technology-specific example is semantic, and no mechanical proxy covers it honestly. Treating
    a language-tagged fenced block as the signal was considered and rejected because it
    under-detects — an example in inline prose or an untagged fence would pass while the tier
    still claimed full automation, which is a subtler form of the same false claim.
Tier counts: [auto] 15 → 14 (P2.3 leaves); [agent-checkable] 34 → 40; [human-review] 0,
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

This constitution is development-time governance for the design and validity of shipped Highway
skills and shared runtime contracts. It is applied by maintainers and compliance tooling while an
artifact is authored, reviewed, packaged, or validated. An executing skill MUST NOT need to load or
consult this document, and this document does not govern runtime interaction or domain decisions.
The Highway Development Constitution governs how this validation system is built and shipped. The
Experience Standard and each owning skill govern their respective runtime contracts.

## Definitions

These definitions are normative. A term defined here carries this meaning everywhere in this
document and in every skill governed by it.

| Term | Definition |
|---|---|
| **MUST**, **MUST NOT** | An absolute obligation. A conforming artifact satisfies it in every case. Non-satisfaction is a FAIL. |
| **SHOULD** | An obligation that applies unless the artifact contains a written exception naming the condition that displaces it. Absent that written exception, SHOULD is evaluated as MUST. |
| **Skill** | A single file, `SKILL.md`, plus its directory, that instructs an agent how to perform one category of task. |
| **Development Validator** | A maintainer, compliance check, or development tool that evaluates a shipped artifact against this constitution. |
| **Normative rule** | A line containing MUST, MUST NOT, or SHOULD that states an obligation. |
| **MUST-level rule** | A normative rule whose keyword is MUST or MUST NOT. The hyphenated token `MUST-level` names this category and is not itself a keyword occurrence. |
| **Normative section** | A body section of a skill that contains at least one normative rule. |
| **Skill contract** | A skill's declared Inputs, declared Outputs, and Verification criteria, taken together. |
| **Behavioral guarantee** | A statement in a skill asserting what will be true after the skill is followed. |
| **Breaking change** | A change that removes, narrows, or redefines any element of a skill contract or behavioral guarantee. |
| **Observable** | The specific condition, countable property, or command result that decides PASS or FAIL for one rule. |
| **Tier** | How a rule is decided: `[auto]`, `[agent-checkable]`, or `[human-review]`. |
| **Experience Standard** | The Highway Experience Standard governing user-visible output and interaction behavior, with rule IDs in the `X` namespace. |
| **Security-affecting** | Guidance that touches any item in the Security Gate trigger list. |
| **Declared input** | A value, file, or precondition named in a skill's Inputs section. |
| **Repository Context Source** | A declared file or accepted artifact whose content may influence runtime behavior under a skill's declared contract. |
| **Repository Context** | Information from declared context sources available under a skill's runtime contract. |
| **Accepted Artifact** | A user-owned artifact persisted through its owning workflow and available to a skill under its declared contract. |
| **Runtime Contract** | A skill-owned or shared contract that defines runtime inputs, outputs, state, ownership, persistence, failure behavior, or interaction delegation. |
| **Development Validation** | Review or automated checking performed before release or amendment; it does not execute a runtime contract. |
| **Correctness-Critical Contract** | A contract whose state, mutation, persistence, ownership, routing, identifiers, structure, output, destructive action, or declared outcome requires repeatable behavior. |
| **Advisory Content** | Interpretations, connections, implications, alternatives, recommendations, explanations, examples, or phrasing that may vary while honoring the owning contract. |
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

This list is closed. A later amendment may add an entry that names its provenance. A skill cites an entry only when it asserts that external requirement. A citation that names no item on this list does not satisfy P3.5.

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
| P1.7 | A skill MUST define or reference runtime handling for an absent or self-contradictory declared input. | The effective shipped runtime contract provides handling for that input. | [agent-checkable] |

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
| P3.2 | A citation MUST name the source and its specific section, control, or identifier. | The citation matches the Citation Format and its identifier field is non-empty. | [agent-checkable] |
| P3.3 | A skill MUST cite an external source only when asserting an external requirement. | The citation is present exactly when the rule asserts an external technical, security, regulatory, protocol, or standards requirement. | [agent-checkable] |
| P3.4 | A rule that applies only under a condition MUST state that condition. | The rule text contains an explicit "when", "if", or "unless" clause. | [agent-checkable] |
| P3.5 | A skill MUST NOT cite a source outside the Approved Authority Sources list. | Every citation matches the Citation Format and its `AS-N` token resolves to AS-1 through AS-6. | [auto] |

Rationale: A closed source list makes grounding decidable instead of leaving it to the
evaluator's knowledge.

### IV. Measurable Quality Gates

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P4.2 | A skill MUST NOT use "secure", "performant", or "maintainable" as an acceptance criterion. | None of the three words appears in an acceptance criterion. | [auto] |
| P4.4 | A numeric threshold MUST state a number and a unit. | The threshold contains a numeral and a unit token. | [agent-checkable] |
| P4.5 | A skill MUST NOT instruct disabling verification, hardcoding credentials, or bypassing input validation. | No step directs any of these three actions. | [agent-checkable] |
| P4.6 | A skill MUST require the agent to report a suspected vulnerability rather than altering it silently. | The Error Handling section directs reporting on this condition. | [agent-checkable] |

Rationale: A quality goal with no check attached cannot be satisfied on purpose, only by
accident.

### V. Reusable Patterns and Defined Error Handling

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P5.6 | A skill MUST apply to two or more triggering scenarios. | The "When to use" section lists at least two scenarios. | [agent-checkable] |
| P5.7 | A runtime contract MUST obtain missing or contradictory required input before continuing. | The effective shipped contract waits until that input is present and consistent. | [agent-checkable] |
| P5.8 | A runtime contract MUST stop without mutation when authoritative state is malformed or unsafe. | No write follows detection of that state. | [agent-checkable] |
| P5.9 | A runtime contract MUST identify the malformed or unsafe authoritative state that stopped it. | The stop names that state. | [agent-checkable] |
| P5.10 | A runtime contract MUST stop without unintended mutation when the user declines or exits. | No write follows the decline or exit. | [agent-checkable] |
| P5.11 | A runtime contract MUST consume a dependent owner's preserved non-success result. | The calling contract keeps that result and uses it. | [agent-checkable] |
| P5.12 | A runtime contract MUST NOT report a failed mutation as success. | The reported outcome records the failed mutation. | [agent-checkable] |
| P5.13 | A runtime contract MUST stop for an unexpected failure with actionable user-facing context. | The stop states what the user can do next. | [agent-checkable] |
Rationale: Development validation verifies that required failure behavior exists in the effective
shipped runtime contract, whether the behavior is defined by the skill or a separately shipped
shared runtime contract. The Constitution does not supply omitted runtime behavior.

### VI. Deterministic, Explicit Decision Criteria

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P6.1 | A correctness-critical contract choice between two or more actions MUST use an ordered list, decision table, or numeric threshold. | The contract choice is followed by one of those three structures. | [agent-checkable] |
| P6.2 | Criteria for a correctness-critical contract result MUST cover every input they can receive. | The structure ends with an explicit default or "otherwise" branch. | [agent-checkable] |
| P6.3 | A correctness-critical contract MUST NOT leave a result choice to agent discretion without bounding constraints. | Each discretionary result choice lists its bounding constraints. | [agent-checkable] |
| P6.4 | A correctness-critical decision criterion MUST NOT reference time, randomness, or agent preference. | No correctness-critical criterion names a clock, random value, or preference. | [auto] |
| P6.5 | Ordered criteria for a correctness-critical contract MUST be evaluated in their stated order. | The contract structure states its evaluation order explicitly. | [agent-checkable] |
| P6.6 | A correctness-critical contract MUST select the same result for identical declared inputs. | No correctness-critical branch depends on a value outside the declared inputs. | [agent-checkable] |

Rationale: Development validation requires deterministic criteria for correctness-critical contract
results while allowing multiple grounded Advisory Content contributions within their owning runtime
contract and the Experience Standard.

### VII. Long-Term Maintainability

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P7.1 | A skill MUST declare exactly one Purpose. | A section titled `## Purpose` is present and contains exactly one sentence. | [auto] |
| P7.2 | A skill MUST carry a semantic version. | `metadata.version` matches MAJOR.MINOR.PATCH. | [auto] |
| P7.3 | A skill MUST NOT restate a requirement owned outside that skill. | A cross-reference names the Experience Standard, a shared runtime contract, an owning skill, or a shared output contract. | [agent-checkable] |
| P7.4 | A skill MUST NOT contain more than 12 MUST-level rules. | Count of MUST and MUST NOT rules is 12 or fewer. | [auto] |
| P7.5 | A normative section MUST NOT exceed 400 words. | Word count per normative section is 400 or fewer. | [auto] |
| P7.6 | A skill exceeding P7.4 or P7.5 MUST be reduced until it satisfies those limits. | The resulting skill satisfies P7.4 and P7.5. | [agent-checkable] |
| P7.7 | A breaking change to a skill contract MUST increment MAJOR per the Skill Versioning Policy. | The version increment matches the change classification. | [agent-checkable] |

Rationale: A skill is a long-lived artifact and is held to the maintainability standard it
imposes on code.

### VIII. Reliability and Repeatability

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P8.2 | A skill MUST declare step order only when order affects behavior, ownership, safety, mutation, or output. | The skill names that order in those cases and does not number steps otherwise. | [agent-checkable] |
| P8.3 | A skill MUST contain a Verification section. | A section titled Verification is present and non-empty. | [auto] |
| P8.4 | The Verification section MUST name a checkable outcome. | The section states what is true when the skill is done. An ordinary artifact workflow does not need a command. | [agent-checkable] |
| P8.5 | A skill MUST require the agent to read and state project configuration that changes its output. | Each configuration-dependent step directs the agent to read and report that value. | [agent-checkable] |
| P8.6 | A skill MUST NOT rely on an environment default it has not stated. | Every default value the skill assumes appears in its text. | [agent-checkable] |
| P8.7 | A skill MUST NOT link to a relative path. | No Markdown link target in the skill body is a relative filesystem path. | [auto] |

Rationale: Repeatability is what allows a skill to be reused without re-verifying it every
time.

### IX. Shared Output Contracts

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P9.1 | A skill MUST NOT repeat a shared output template's structure or generic invariants. | The Outputs section names the template, the output location, and the domain meaning the template does not own. | [auto] |
| P9.2 | A skill MUST declare the shape of what it emits. | The Outputs section states the fields, sections, or file structure produced. | [agent-checkable] |
| P9.3 | A skill MUST emit content in its declared shape. | Every field and ordering in the output appears in the Outputs declaration. | [agent-checkable] |
| P9.4 | An empty result MUST have a declared form. | The Outputs section states the content emitted when there is nothing to report. | [agent-checkable] |
| P9.5 | A specimen MUST agree with the metadata it repeats. | Every value the Example section shares with the skill frontmatter matches it. | [auto] |
| P9.6 | A retained file artifact MUST include frontmatter. | Each retained emitted file begins with frontmatter. Transient messages are excluded. | [agent-checkable] |
| P9.7 | A skill that writes a file MUST declare its path. | The Outputs section names each path written. | [agent-checkable] |
| P9.8 | A retained artifact MUST derive its content from declared inputs. | The artifact contains no timestamp, random value, or environment-dependent content. | [agent-checkable] |

Rationale: A shared complete skeleton prevents two skills producing the same kind of record from
silently diverging in metadata or body structure.

### X. Experience Compliance

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P10.1 | Every new or amended skill MUST comply with all applicable Experience Standard rules. | The skill references the Experience Standard and does not restate its generic interaction rules. | [agent-checkable] |
| P10.2 | A skill that cannot satisfy an applicable Experience Standard rule MUST identify the X-rule and exception condition. | Each exception names one X rule and the condition that displaces it in the skill file. | [agent-checkable] |

Rationale: Experience Compliance makes user-visible behavior reviewable alongside correctness and
portability while leaving the Experience Standard as the source of interaction rule text.

### XI. Repository Context

Repository Context Sources are declared inputs considered during development validation. The
`.highway/library/knowledge/highway-identity.md` source is shared, non-normative context describing
what Highway is, why it exists, and what it is trying to achieve. The user-owned organizational context
at `.highway/library/knowledge/profile.md` and accepted repository artifacts remain owned by
their workflows. This Constitution does not define behavioral guidance, strategic direction,
evaluation criteria, conversational epistemic status, or runtime context precedence. Missing context
is not invented or silently substituted; workflow-specific inputs remain authoritative.

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P11.1 | A skill MUST declare each context source that can influence its behavior. | Each influencing source is named in Inputs. | [agent-checkable] |
| P11.2 | A skill MUST declare the contract role of each context source that can influence its behavior. | The skill's runtime declaration names each source's contract role. | [agent-checkable] |
| P11.3 | A skill MUST preserve workflow-specific and user-owned input ownership. | The skill's runtime contract preserves the declared authority boundary. | [agent-checkable] |
| P11.4 | A skill MUST NOT substitute missing context, including by invention. | Missing context stays missing. No replacement content is written. | [agent-checkable] |

Rationale: Development validation checks that runtime context dependencies and ownership are declared
without making validator mechanics part of the shipped skill.

### XII. Owner-Controlled Completion and Orchestration

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P12.5 | An orchestrator MUST consume the owner's declared result. | Orchestration uses that result. | [agent-checkable] |
| P12.6 | An owner MUST determine its own readiness. | Readiness comes from the owner. | [agent-checkable] |
| P12.7 | An owner MUST determine its own domain state. | Domain state comes from the owner. | [agent-checkable] |
| P12.8 | An owner MUST supply its next supported action when interaction is required. | The next action is the one the owner supplies. | [agent-checkable] |
| P12.9 | An orchestrator MUST delegate the action the owner supplied. | The delegated action is that supplied action. | [agent-checkable] |
| P12.10 | An orchestrator MUST advance only from the owner's declared terminal result. | Advance follows that terminal result. | [agent-checkable] |
| P12.11 | An orchestrator MUST NOT inspect owner-internal state. | Owner-internal records are not read to decide the result. | [agent-checkable] |
| P12.12 | An orchestrator MUST NOT reconstruct owner-internal state. | Owner-internal records are not rebuilt to decide the result. | [agent-checkable] |
| P12.13 | An owner MUST perform its accepted mutation before returning a dependent result. | The mutation occurs before the dependent result. | [agent-checkable] |
| P12.14 | An orchestrator MUST wait for the owning skill's declared mutation result after acceptance. | Acceptance is followed by the owning skill's declared result, not treated as that result. | [agent-checkable] |
| P12.15 | An orchestrator MUST wait for every required owner's terminal result before claiming completion. | The Completion Claim follows every required owner's terminal result. | [agent-checkable] |
| P13.2 | A skill MUST assign acceptance and persistence to the owning workflow. | The runtime contract names the owner and its mutation boundary. | [agent-checkable] |

Rationale: Development validation checks owner mutation, readiness, declared-result, orchestration,
acceptance, and persistence boundaries without becoming a runtime authority.

## Principle Precedence

When two rules conflict, the rule belonging to the higher-ranked principle prevails. This
ordering is total: every pair of principles has a defined winner.

| Rank | Principle | Reason for rank |
|---|---|---|
| 1 | IV. Measurable Quality Gates | Carries the security-affecting rules P4.5 and P4.6. |
| 2 | I. Unambiguous, Actionable Directives | A rule that cannot be read one way cannot be applied at all. |
| 3 | VI. Deterministic, Explicit Decision Criteria | Determines which correctness-critical contract result is accepted during development validation. |
| 4 | V. Reusable Patterns and Defined Error Handling | Validates required failure behavior in the effective runtime contract. |
| 5 | XII. Owner-Controlled Completion and Orchestration | Validates owner mutation, readiness, declared-result, orchestration, acceptance, and persistence boundaries. |
| 6 | VIII. Reliability and Repeatability | Governs whether the outcome can be confirmed. |
| 7 | VII. Long-Term Maintainability | Governs cost over time rather than correctness now. |
| 8 | II. Technology-Agnostic Portability | Governs reach across environments. |
| 9 | III. Grounding in Approved Authority Sources | Governs provenance of a rule already stated. |
| 10 | X. Experience Compliance | Validates conformity with the Experience Standard. |
| 11 | XI. Repository Context | Governs declared context dependencies and ownership during development validation. |

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

### Security Gate

**Trigger**: the skill performs any of: authentication, authorization, input handling, secrets
or credentials, network calls, file writes outside the working directory, deserialization of
external data, cryptography, or dependency selection.

When triggered, the skill MUST satisfy P4.5 and P4.6. An external security citation is required
only when the skill asserts an external security requirement. Rules produced under this gate are
security-affecting and take the Security override in Principle Precedence.

## Permitted N/A Conditions

This list is closed. It names the conditions a remaining gate or rule may use.

| ID | Condition |
|---|---|
| **N1** | The rule belongs to a quality gate whose trigger test evaluates false. |
| **N2** | The rule governs a skill section that this artifact type is not required to contain. |
| **N3** | The rule governs amendment of this constitution, and the reviewed artifact is not this constitution. |
| **N4** | The rule's stated scope names an artifact type that the reviewed artifact is not. |

## Illustrative Examples (Non-Normative)

These examples illustrate two principles. They state no obligation and are excluded from every
check that references the prohibited token lists.

**Illustrative, for Principle I:**

| Non-compliant | Compliant |
|---|---|
| "Handle problems appropriately." | "If required input is missing or contradictory, obtain it before continuing." |

**Illustrative, for Principle VI:**

| Non-compliant | Compliant |
|---|---|
| "Allocate the next identifier from agent preference." | "If the next identifier is OBJ000007, allocate OBJ000008; otherwise reject malformed state." |

## Governance

This constitution governs development-time validation of shipped skills and shared runtime contracts.
It does not supersede the Experience Standard at runtime, and an executing skill does not consult it.
Conflicts between rules inside this document during development validation are resolved by Principle
Precedence. Domain semantics, artifact ownership, persistence, operational contracts, and generic
user-visible interaction belong to their applicable runtime owners.

Development validation does not invent organizational facts or silently promote inferred or
discovered information into user-owned authoritative content. Objectives, Controls, Non-Functional
Requirements, architectures, decisions, implementations, and organizational Profile stay user-owned.
The applicable workflow defines proposal acceptance and persistence; this Constitution checks that
the owner and boundary are explicit.

### Self-Application

This constitution is itself subject to P1.1 through P1.4 (clarity), P6.4 and P6.6
(correctness-critical determinism), and P7.3 (non-duplication). Every amendment MUST record a review
against those rule IDs. Rules P7.4 and P7.5 state limits on skills and do not apply to this document.
This amendment review confirms P10.1 remains the generic Experience delegation rule, P13.1 is retired,
P13.2 remains individually addressable within Principle XII, and owner mutation and orchestration
rules remain development-time contract checks.

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

**Version**: 9.0.0 | **Ratified**: 2026-09-06 | **Last Amended**: 2026-10-06
