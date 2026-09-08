# Feature Specification: Skill Path Resolvability Rule

**Feature Branch**: `011-skill-path-resolvability`

**Created**: 2026-09-08

**Status**: Draft

**Input**: User description: "I want the rule that a skill must not reference a path a user will not have to be written down where a skill author reads it, not only enforced by a test they discover by failing. Feature 010 removed every development-path reference from the shipped tree and added shipped-tree-independence.test.sh to keep them out, but wrote no rule, so the constraint is invisible until the suite goes red. Add a new rule to the Highway Skills Constitution at .highway/governance/constitution.md requiring that every path a skill references resolves within the tree distributed alongside it, with an Observable naming the resolvable-path check, and phrase it generally rather than naming the development directories, because those directories do not exist for an end user. Increment the constitution's version as a MINOR amendment and record the addition in its Sync Impact Report. Cite the new rule by id from .highway/skills/_authoring-standard.md rather than restating its text, per P7.3. Add a governance section to the root README.md pointing at .highway/governance/constitution.md and the authoring standard, because the README currently documents how to author a skill without mentioning the rules a skill is validated against. Finally, clear the stale entries from the constitution's follow-up TODO list: PURPOSE_SECTION_ENFORCEMENT is already satisfied because schema-validate.sh lists Purpose among the required body sections, BUMP_TYPE_REVIEW is resolvable because highway-help exists and declares a Purpose section so no reclassification is needed, and AUTHORING_STANDARD_REALIGNMENT should be completed by rewriting the Constitution Compliance Checklist to cite rule ids instead of restating principle text."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - An author can read the rule before breaking it (Priority: P1)

A skill author needs to know, before writing a skill, that any path the skill points at must
exist for whoever receives that skill. Today that constraint is enforced by a test but stated in
no document. An author learns it by writing a reference, running the suite, and reading a failure.
Every author repeats that discovery independently.

**Why this priority**: This is the entire reason the feature exists. A constraint enforced but
unwritten teaches by failure, which is the most expensive way to learn a rule and the least
likely to be understood rather than merely worked around.

**Independent Test**: Read the authoring standard end to end without running any tool, and confirm
the constraint is stated there and traceable to a governing rule.

**Acceptance Scenarios**:

1. **Given** the governing document, **When** an author looks for constraints on what a skill may
   reference, **Then** a rule states that every referenced path must resolve for the recipient.
2. **Given** the authoring standard, **When** an author reads it before writing a skill, **Then**
   the constraint is present and identified by its rule id, with the rule's text living only in
   the governing document.
3. **Given** the new rule, **When** an end user who has never seen this project's development
   directories reads it, **Then** the rule is meaningful, because it names no directory that
   exists only during development.
4. **Given** the amended governing document, **When** its version is compared to the previous
   version, **Then** the increment reflects an addition that invalidates no existing skill.

---

### User Story 2 - Someone new can find the governance at all (Priority: P2)

The repository's front page explains how to author, validate, catalog, and distribute a skill. It
says nothing about the rules a skill is validated against, so a reader has no path from "how do I
author a skill" to "what is my skill judged by" without already knowing where to look.

**Why this priority**: Real but narrower than User Story 1. The rules exist and are enforced; this
makes them discoverable from the obvious starting point.

**Independent Test**: Start at the repository front page and reach the governing document and the
authoring standard without searching the file tree.

**Acceptance Scenarios**:

1. **Given** the repository front page, **When** a reader looks for the rules governing skills,
   **Then** a section names the governing document and the authoring standard and links to both.
2. **Given** that section, **When** a reader follows either link, **Then** it resolves.

---

### User Story 3 - The follow-up list describes work that is actually outstanding (Priority: P3)

The governing document carries four follow-up entries. Three of them describe work that has since
been completed by other features, but the entries were never removed. A reader cannot tell which
entries are real without independently verifying each one.

**Why this priority**: Bookkeeping. Nothing is broken; the list is simply misleading, and a
misleading backlog costs a reader time every time it is consulted.

**Independent Test**: Read each follow-up entry, check the repository for the state it describes,
and confirm every remaining entry describes work that has not been done.

**Acceptance Scenarios**:

1. **Given** the follow-up list, **When** each entry is checked against the repository, **Then**
   every remaining entry describes outstanding work.
2. **Given** an entry describing work already completed, **When** the list is amended, **Then**
   the entry is removed and the amendment records why it was removable.

---

### Edge Cases

- **Can the new rule be decided automatically?** Not by the existing tree-level check, which
  searches for two specific location names. A skill could reference a path that simply does not
  exist and satisfy that check while violating the general rule. Resolved by building a check that
  decides the rule generally — see Clarifications.
- **What counts as a referenced path?** A skill body contains both cross-references, which point
  at another document, and command examples, which show something to run. Resolving every
  path-shaped string would flag legitimate command examples as violations. The check must target
  the former without catching the latter.
- **Does the new check change any existing verdict?** A check enabled without first being
  evaluated against every fixture can silently turn a fixture expected to produce one failure into
  one producing two. This is the failure mode the development constitution's D3.4 exists to
  prevent, and it applies directly to this feature.
- **Does the amendment invalidate any existing skill?** The increment recorded depends on it. If
  every registered skill already satisfies the new rule, the addition is a MINOR amendment; if any
  skill fails, the obligation has been strengthened against a conforming artifact.
- **Does the governing document satisfy its own new rule?** It became a distributed artifact when
  it was relocated, so a rule about references applies to it as much as to a skill.
- **Does the new rule read as a restatement of an existing one?** The development constitution
  already carries a rule about documentation cross-references resolving. That rule governs
  repository documentation; this one governs skills, which are distributed into a tree the author
  never sees. The two must be worded so that their distinct subjects are evident and neither
  restates the other.
- **Which principle should the rule join?** The rule is about a skill working as delivered rather
  than about clarity, technology independence, or maintainability cost.
- **Do the removed follow-up entries need replacing?** Removing an entry whose work is complete is
  bookkeeping; removing one whose work is merely inconvenient would hide it.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The governing document MUST carry a rule requiring every path a skill references to
  resolve within the tree distributed alongside that skill.
- **FR-002**: The rule MUST be phrased without naming any location that exists only during
  development, so that it remains meaningful to a recipient who has never seen one.
- **FR-003**: The rule MUST carry a stable identifier, exactly one obligation keyword, an
  Observable, and a tier tag, matching the form of every other rule in that document.
- **FR-004**: The rule's tier MUST reflect how it is actually decided, not how it would ideally be
  decided.
- **FR-004a**: A check MUST decide the rule automatically for every skill.
- **FR-004b**: The check MUST target cross-references and MUST NOT flag a command example.
- **FR-004c**: The check MUST report a violation by naming the skill, the unresolvable reference,
  and its location.
- **FR-004d**: The check MUST report its result by rule identifier, in the same output groups the
  validator already uses for every other rule.
- **FR-004e**: The check MUST be evaluated against every existing fixture before it is enabled,
  and each fixture's expected verdict MUST be recorded, so that no fixture silently changes from
  one failure to two.
- **FR-004f**: The check MUST be demonstrably capable of failing.
- **FR-005**: The governing document's version MUST be incremented, and the increment MUST match
  the change classification defined by that document's own versioning policy.
- **FR-006**: The amendment MUST be recorded in the document's change report, naming the rule
  added and the classification reasoning.
- **FR-007**: The authoring standard MUST make the constraint discoverable to an author, citing
  the rule by identifier.
- **FR-008**: The authoring standard MUST NOT restate the rule's text.
- **FR-009**: The repository front page MUST name and link to both the governing document and the
  authoring standard.
- **FR-010**: Every link added by this feature MUST resolve within the tree that contains the
  document holding it.
- **FR-011**: Every follow-up entry describing already-completed work MUST be removed, and each
  removal MUST record the evidence that the work is complete.
- **FR-012**: Every follow-up entry that remains MUST describe outstanding work.
- **FR-013**: Every registered skill MUST satisfy the new rule without amendment to that skill.
- **FR-014**: The governing document MUST itself satisfy the new rule.

### Key Entities

- **Governing document**: The document defining the rules a skill is validated against. Read by
  the validation tooling and distributed to users.
- **Authoring standard**: The practical guide an author reads when writing a skill. Cites rules by
  identifier and holds no rule text of its own.
- **Rule**: An identifier, one obligation, an Observable, and a tier tag.
- **Follow-up entry**: A recorded item of outstanding work, carried in the governing document's
  change report.
- **Repository front page**: The document a reader encounters first.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: An author can discover the path-resolvability constraint by reading the authoring
  standard alone, without running any tool and without opening the governing document.
- **SC-002**: A reader starting at the repository front page reaches both governance documents by
  following links only.
- **SC-003**: Every registered skill passes validation with no change to its own content, and no
  skill's verdict differs from before this feature.
- **SC-004**: The complete test suite passes, with no test removed or weakened.
- **SC-004a**: Introducing a single unresolvable cross-reference into any skill causes validation
  to fail, naming that skill and that reference.
- **SC-004b**: A command example in a skill body does not cause validation to fail.
- **SC-005**: The governing document's follow-up list contains only entries whose work is
  outstanding, verified entry by entry.
- **SC-006**: No sentence of rule text appears in more than one document.
- **SC-007**: Every link added by this feature resolves within its own tree.

## Assumptions

- **All three follow-up entries named in the description are already satisfied**, not merely
  resolvable. The description assumed one of them still required work. Verified on 2026-09-08:
  the required-sections list already includes the section that entry describes; a skill exists
  that declares that section, so the reclassification condition never triggered; and the authoring
  standard already cites 28 distinct rule identifiers, restates no rule text, and contains no
  section by the name the third entry uses. A test already enforces the last of these and passes.
  This feature therefore removes three entries rather than completing work for one of them.
- The rule joins the principle governing reliability and repeatability, as the next identifier in
  that principle's sequence. It concerns whether a skill works as delivered, which is that
  principle's subject; it is not about clarity, technology independence, or maintenance cost. The
  identifier is confirmable during planning.
- The increment is expected to be MINOR, on the basis that the sole registered skill already
  satisfies the new rule. This is verified rather than assumed during implementation; were a skill
  to fail, the classification would change.
- The existing tree-level check partially decides the new rule and continues to serve its own
  purpose. The new check decides the rule generally and does not replace it; the two answer
  different questions and both remain.
- The new check is expected to report through the validator that already reports every other rule
  by identifier, rather than as a standalone test, so that the rule appears in the same output
  groups as its siblings. This is confirmed during planning.
- Adding a governance section to the front page does not make the governing document a published
  contract for end users. Whether the distribution includes it is settled by a later feature.
- No skill content changes, so no skill version is incremented and no derived artifact is
  regenerated by this feature.

## Clarifications

### Session 2026-09-08

- **Q**: The rule is to be phrased generally, but the only existing automation searches for two
  specific location names and so does not decide the general rule. Build a check that decides it,
  or state the rule and tag it according to today's partial coverage?
- **A**: Build a check that decides it. The rule is stated generally and tagged as automatically
  decided, because a check will genuinely decide it.
- **Consequences**: The feature grows beyond documentation. A check must resolve every
  cross-reference in every skill and fail when one does not exist within the tree distributed
  alongside that skill. In exchange the rule means something the day it is adopted rather than
  describing an intention, and it adds nothing to the backlog of rules tagged as automatically
  decidable but not decided. The check must distinguish a cross-reference from a command example,
  or it will flag legitimate content, and it must be evaluated against every fixture before being
  enabled.
