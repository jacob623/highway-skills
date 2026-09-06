# Feature Specification: Mechanical Enforcement of the Constitution

**Feature Branch**: `003-constitution-enforcement`

**Created**: 2026-09-06

**Status**: Draft

**Input**: User description: "Make the Highway Skills constitution mechanically enforceable by the framework's own tooling."

## Clarifications

### Session 2026-09-06

- Q: When a rule is tagged as machine-decidable but its observable points at something a skill's format never marks out, how should the framework resolve that? → A: Enforce conditionally — check the rule where the construct is unambiguously present, record not-applicable where it is absent. No new mandatory sections are added to skills.
- Q: For the two rules that stay undecidable even with conditional enforcement, should the framework define detection mechanics or retag them as judgment-requiring? → A: Split them. Enumerate a closed prohibited-token list for the time/randomness/preference rule, mirroring the existing Prohibited Vagueness List mechanism. Retag the example-labeling rule as judgment-requiring. Automated enforcement settles at 13 of 14 rules.
- Q: Where should a compliance review be written — to the terminal, to a file next to the skill, or both? → A: Terminal output only, with an exit code signalling whether merge is blocked. No review file is generated or committed. (This answer is retained for the follow-on feature; the compliance review artifact was subsequently moved out of this feature's scope.)

### Session 2026-09-06 (scope revision)

- Q: Is this repository intended to be a reusable framework, or a place to author skills that complete tasks? → A: A place to author skills. Enforcement exists to support authoring, not as a product. User stories were re-prioritized, the compliance review artifact was deferred to a follow-on feature, and the assumption that no authored skills exist was corrected.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - An author is told which rule they violated (Priority: P1)

A skill author runs validation against a skill they are writing. Instead of a generic
structural complaint, each failure names the specific constitution rule ID and the observable
that decided it. The author repairs the named rule without reading or interpreting the
constitution themselves.

**Why this priority**: This is the whole point of the constitution being rule-addressable. A
rule that is never checked is guidance, not governance. Without this, the other stories have
nothing to report on.

**Independent Test**: Seed one deliberate violation per enforced rule, run validation on each,
and confirm the corresponding rule ID appears in the output. Delivers value on its own: an
author gets actionable, rule-level feedback the first time they write a real skill.

**Acceptance Scenarios**:

1. **Given** a skill whose `## Purpose` section is absent, **When** the author validates it,
   **Then** validation fails and the output names rule `P7.1`.
2. **Given** a skill containing a normative rule of 40 words, **When** the author validates it,
   **Then** validation fails and the output names rule `P1.3` and the offending line.
3. **Given** a skill with 15 MUST-level rules, **When** the author validates it, **Then**
   validation fails, names rule `P7.4`, and reports the counted value and the limit.
4. **Given** a fully conforming skill, **When** the author validates it, **Then** validation
   succeeds and reports which rules were checked and which were deferred.
5. **Given** a skill violating a rule the tooling cannot decide without judgment, **When** the
   author validates it, **Then** that rule is reported as pending rather than passed.

---

### User Story 2 - The authoring standard stops duplicating the constitution (Priority: P2)

The authoring standard points at rule IDs instead of restating rule text, so the two documents
cannot drift apart as the constitution is amended.

**Why this priority**: This is the document an author reads while writing a skill, so its
accuracy matters as soon as skill authoring begins. It is also a live defect: the constitution
prohibits restating another document's normative rules, and the authoring standard currently
does exactly that. It has no dependency on the tooling and can proceed in parallel.

**Independent Test**: Inspect the authoring standard and confirm no constitution rule text is
restated and that its checklist references rule IDs.

**Acceptance Scenarios**:

1. **Given** the authoring standard, **When** it is compared against the constitution, **Then**
   no normative rule text appears in both.
2. **Given** the authoring standard's compliance checklist, **When** it is inspected, **Then**
   each item references a rule ID rather than paraphrasing the rule.
3. **Given** a future constitution amendment that changes a rule's wording, **When** the
   authoring standard is re-inspected, **Then** it requires no edit to stay accurate.

---

### User Story 3 - The repository's fixtures and examples conform (Priority: P3)

Every fixture and worked example in the repository passes the same validation an authored
skill must pass, so an author starting from one of them inherits a conforming skill rather
than a violating one.

**Why this priority**: Housekeeping rather than a goal in itself. It ranks last on value but
is schedule-coupled to Story 1: tightening validation reds the current fixtures, and the
fixtures feed the catalog and adapter test suites. It must therefore ship in the same change
as Story 1 even though it is the lowest-value story.

**Independent Test**: Run validation against every skill-shaped artifact in the repository and
confirm each passes.

**Acceptance Scenarios**:

1. **Given** the repository as it stands, **When** validation runs against every skill-shaped
   artifact, **Then** every artifact intended to be valid passes.
2. **Given** the fixtures that exist to demonstrate failure, **When** validation runs, **Then**
   each still fails for its intended reason and no other.
3. **Given** the full test suite, **When** it runs after validation is tightened, **Then**
   every test passes.
4. **Given** any file beneath the tooling directory, **When** the path check runs, **Then** no
   reference to a pre-relocation path remains.

---

### Edge Cases

- A skill contains a normative keyword inside a fenced code block or an illustrative example.
  Does that line count as a normative rule for counting and length checks? It must not, or
  every example that quotes a rule inflates the count.
- The token `MUST-level` appears in a skill. The constitution excludes it from keyword counts;
  enforcement must apply the same exclusion.
- A skill has zero normative rules. Rules that count or measure normative rules must record a
  defined outcome rather than dividing by zero or failing ambiguously.
- The constitution is amended and a rule ID is added or retagged. Enforcement must not silently
  continue checking a stale rule set.
- A rule is retagged from decidable to judgment-requiring. It must move to pending rather than
  continue producing a verdict.
- A skill is valid but a required section is present and empty. The existing behavior treats
  this as a failure and must be preserved.

## Requirements *(mandatory)*

### Functional Requirements

**Rule inventory and drift**

- **FR-001**: The set of rule IDs the tooling checks MUST be derived from the constitution
  itself, so that amending the constitution cannot leave enforcement silently out of date.
- **FR-002**: When the constitution defines a rule the tooling does not check, that rule MUST
  be reported as unchecked rather than omitted from output.

**Validation feedback**

- **FR-003**: Validation MUST report each failure with the rule ID that was violated and the
  observable that decided it.
- **FR-004**: Validation MUST report, on success, which rule IDs were checked and which were
  deferred, so an author can tell verified conformance from unverified conformance.
- **FR-005**: Validation MUST NOT report a verdict for a rule that requires judgment; such
  rules are reported as pending.
- **FR-006**: Validation MUST continue to report every violation found in a single run rather
  than stopping at the first.
- **FR-007**: Validation MUST treat a required section that is present but empty as a failure,
  preserving existing behavior.
- **FR-008**: Validation MUST NOT count a normative keyword appearing inside a fenced code
  block or an illustrative example as a normative rule.
- **FR-009**: Validation MUST exclude the token `MUST-level` from keyword counts, matching the
  constitution's own exclusion.

**Skill structure**

- **FR-010**: The required body section set MUST include a Purpose section, raising the count
  from six to seven.
- **FR-011**: Every skill-shaped artifact in this repository MUST satisfy the rules the tooling
  enforces.
- **FR-012**: Fixtures that exist to demonstrate a specific failure MUST continue to fail for
  that reason and no other.

**Path integrity**

- **FR-013**: The stale-path check MUST cover every file beneath the tooling directory rather
  than an enumerated list of documents.
- **FR-014**: No file beneath the tooling directory may reference a pre-relocation path.

**Documentation**

- **FR-022**: The authoring standard MUST reference rule IDs rather than restating rule text.
- **FR-023**: The repository MUST record, without acting on it, the limitation that the
  published frontmatter and catalog contracts cannot carry gate-trigger data or a computed
  overlap ratio.

**Conditional enforcement**

- **FR-030**: Where a rule's observable references a construct that a skill's format does not
  delimit, the tooling MUST check the rule wherever that construct is unambiguously present
  and MUST record not-applicable where it is absent.
- **FR-031**: Conditional enforcement MUST NOT add a required section to a skill. The required
  section set is fixed at the seven of FR-010.
- **FR-032**: When a rule is recorded as not-applicable under FR-030, the output MUST name the
  permitted not-applicable condition that applies.
- **FR-024**: For the rule requiring numbered workflow steps, the tooling MUST check every
  ordered list in a skill and MUST record not-applicable when a skill contains no ordered list.
- **FR-025**: For the rule requiring each failure condition to name one of four next actions,
  the tooling MUST treat each list item in the Error Handling section as one failure
  condition, and MUST record not-applicable when that section contains no list.
- **FR-026**: For the rule prohibiting three named words as acceptance criteria, the tooling
  MUST check the Verification section, which is the skill's stated location for completion
  conditions.
- **FR-027**: For the rule prohibiting decision criteria that reference time, randomness, or
  preference, the tooling MUST check a skill against a closed list of prohibited tokens,
  using the same mechanism already applied to the Prohibited Vagueness List.
- **FR-028**: The rule requiring illustrative examples to be labeled MUST be treated as
  judgment-requiring. The tooling MUST NOT produce a verdict for it and MUST report it as
  deferred.
- **FR-033**: The prohibited-token list for FR-027 MUST be defined in the constitution, not in
  the tooling, so that the tooling holds no normative content of its own.

### Key Entities

- **Rule**: One addressable obligation from the constitution. Attributes: rule ID, keyword,
  observable, tier. Sourced from the constitution, never restated by the tooling.
- **Tier**: How a rule is decided. Determines whether the tooling reports an outcome for the
  rule or defers it.
- **Skill-shaped artifact**: Any file the tooling treats as a skill for validation purposes,
  including test fixtures and worked examples, as well as authored skills.
- **Rule outcome**: What validation reports for one rule against one artifact: checked and
  passing, checked and failing, not-applicable with a named condition, or deferred.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every skill-shaped artifact in the repository that is intended to be valid passes
  validation; count of unintended failures is zero.
- **SC-002**: For each enforced rule, a seeded violation of that rule is detected and the
  output names that rule ID; detection rate is 100% of enforced rules.
- **SC-003**: The full test suite passes; count of failing tests is zero.
- **SC-004**: Zero references to pre-relocation paths remain in any file beneath the tooling
  directory.
- **SC-005**: Zero constitution rule texts are restated in the authoring standard.
- **SC-006**: Zero rules requiring judgment receive an automated outcome.
- **SC-007**: An author correcting a reported violation needs no reference beyond the rule ID
  in the output and the constitution itself.
- **SC-008**: Zero new required sections are added to the skill format by this feature; the
  required section count is exactly seven.
- **SC-009**: The first skill authored after this feature ships passes validation without any
  change to the enforcement rules themselves.

## Assumptions

- Constitution 2.0.1 is in effect. It pins Purpose to a body section and defines the citation
  format, and it tags 14 rules as decidable without judgment.
- Of those 14 rules, 9 are enforceable directly from the constitution as written. Three more
  become enforceable under the conditional approach recorded in Clarifications, and one more
  once a prohibited-token list exists, giving 13. The remaining rule is retagged as
  judgment-requiring and is never checked automatically.
- This feature depends on a further constitution amendment that adds the prohibited-token list
  and retags the example-labeling rule. That amendment is a prerequisite, not part of this
  feature's scope.
- Conditional enforcement accepts a known gap: a construct written as prose rather than as a
  list escapes detection instead of failing. This is preferred over adding mandatory structure
  to a skill format before real skills exist to show what structure is warranted.
- This repository exists to author skills that complete tasks. It is not a framework intended
  for adoption elsewhere. Enforcement is a support tool for authoring, and its scope is set by
  what helps an author write a correct skill, not by what a downstream adopter would need.
- Skill authoring begins imminently. Tightening validation will therefore affect real skills,
  not only fixtures, so a false positive in a check is more costly than an uncaught violation.
- The constitution's `TODO(BUMP_TYPE_REVIEW)` becomes live: if a skill is authored that
  declares its Purpose outside a `## Purpose` section, amendment 2.0.1 must be reclassified as
  MAJOR. Resolve this before or during the first skill.
- Tightening validation and rewriting the fixtures are mutually blocking and belong in one
  change, because the fixtures feed the catalog and adapter test suites.
- The published contracts under the completed feature 001 are frozen for this feature.
  Gate-trigger data and computed overlap ratios have nowhere to live until those contracts
  change, which is a separate feature.
- The tooling remains shell scripts with no new language runtime and no network calls, and
  runs on the default macOS shell.
- Skills remain the single source of truth; nothing in this feature requires editing a skill to
  support an additional agent.

## Out of Scope

- **The compliance review artifact.** Emitting the full per-rule review the constitution's
  Compliance Review Protocol specifies is deferred to a follow-on feature. It pays off with
  many skills and multiple reviewers, and this repository has neither yet. The destination
  decision recorded in Clarifications (standard output, exit status signals blocking, no file
  written) carries forward to that feature.
- Changing the frontmatter or catalog contracts under `specs/001-multi-agent-skill-suite/contracts/`.
- Automating the manual overlap review or computing an overlap ratio into the catalog.
- Producing automated outcomes for rules that require judgment.
- Authoring any actual skill topic. Skills are authored as their own work, not as part of this
  feature.
