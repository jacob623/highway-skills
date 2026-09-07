# Feature Specification: Shared Content Library

**Feature Branch**: `004-shared-content-library`

**Created**: 2026-09-07

**Status**: Draft

**Input**: User description: "I want to centralize supporting files skills will need so applicable content required across multiple skills can be shared. I would like the following folders to be used for the described purpose: .highway/content/templates (skill output markdown templates), .highway/content/knowledge (general knowledge markdown files), .highway/content/governance (governance markdown files). These files should follow the same constitution requirements as the skills themselves."

## Clarifications

### Session 2026-09-07

- Q: How should a skill declare that it depends on a shared content file? → A: A frontmatter field (e.g. `dependencies: [content/templates/foo.md]`) listing shared files by repo-relative path.
- Q: Which constitution rules should apply to governance and knowledge files versus template files? → A: Governance and knowledge files get the full rule-content checks a skill's body gets (keyword-count, word-limit, citation format). Templates get a hand-picked subset instead, because a template's output becomes another skill's input and is not itself a rule statement.
- Q: Should a shared content file carry frontmatter similar to a skill's (`name`, `description`, `metadata.version`), or something simpler? → A: All three content types (templates, knowledge, governance) carry minimal frontmatter (`name`, `description`, `metadata.version`) — not the full skill shape, since `compatibility` is agent/adapter-specific and does not apply to shared content.
- Q: Should shared content files appear in the same generated catalog as skills, or be discovered a different way? → A: A separate, sibling listing artifact is generated for `.highway/content/`, grouped by content type, rather than reusing the skill catalog's schema.
- Q: Should shared content files be independently versioned, with a skill recording which version of a dependency it needs? → A: Yes. A skill's `dependencies` entry records both the path and the version it depends on; a mismatch against the shared file's current `metadata.version` is a validation failure.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - An author shares one file instead of duplicating it across skills (Priority: P1)

An author writing a second skill needs content already used by a first skill — an output
template, a piece of reference knowledge, or a governance policy. Instead of copying the
content into the new skill, the author references the one shared file both skills point to.

**Why this priority**: This is the entire reason the feature exists. Without it, the same
content is copied into every skill that needs it, and the two copies drift the moment one is
edited — the exact defect the constitution's non-duplication rule (P7.3) already prohibits
within a single skill, now recurring across skills instead of within one.

**Independent Test**: Author two skills that both depend on one shared file. Edit the shared
file once. Confirm both skills reflect the change with no edit to either skill file.

**Acceptance Scenarios**:

1. **Given** a shared template exists at `.highway/content/templates/`, **When** two different
   skills reference it, **Then** neither skill's own file contains a copy of the template's
   content.
2. **Given** a skill references a shared knowledge file that does not exist, **When** the skill
   is validated, **Then** validation fails and names the missing path.
3. **Given** a shared file is edited without changing its `metadata.version`, **When** any
   skill referencing it is next validated, **Then** validation reads the current content of the
   shared file rather than a cached copy, and the skill's pinned version still matches.

---

### User Story 2 - Shared content is held to the same constitution as a skill (Priority: P1)

An author writing a shared template, knowledge file, or governance file gets the same kind of
rule-level feedback an author writing a skill gets: a violation names the constitution rule,
not a generic complaint.

**Why this priority**: The user's explicit requirement. Equal priority to Story 1 because a
shared library that is not held to the same standard as the content it replaces is a
regression — it would let vague, uncited, or unversioned content spread to every skill that
references it, multiplying exactly the defect the constitution exists to prevent.

**Independent Test**: Seed one rule violation in a file under each of the three content
directories and confirm each is detected and reported by rule ID, the same way a skill
violation is reported.

**Acceptance Scenarios**:

1. **Given** a governance file citing no Approved Authority Source for a MUST-level rule,
   **When** it is validated, **Then** validation fails and names the citation rule.
2. **Given** a knowledge file whose normative line carries two keywords (both MUST and SHOULD
   on the same line), **When** it is validated, **Then** validation fails and names rule P1.1.
3. **Given** a template file that conforms to every rule that applies to its content type,
   **When** it is validated, **Then** validation succeeds.
4. **Given** a content file of a type no rule is defined for, **When** it is validated,
   **Then** the outcome is recorded as not-applicable rather than silently passed.

---

### User Story 3 - An author finds the right shared file without reading every skill (Priority: P2)

An author starting a new skill can discover what shared content already exists — which
templates, knowledge files, and governance files are available — before deciding whether to
write new content or reference existing content.

**Why this priority**: Valuable but not blocking. Story 1 works even if discovery is manual
(browsing three directories), since the library starts small. This becomes more valuable as the
number of shared files grows, which is not yet the case.

**Independent Test**: With at least one file in each of the three content directories, run a
listing operation and confirm every file appears with enough information to judge relevance
without opening it.

**Acceptance Scenarios**:

1. **Given** any number of files under `.highway/content/`, **When** an author requests a
   listing, **Then** every file appears exactly once, grouped by its content type.
2. **Given** a new shared file is added, **When** the listing is next produced, **Then** the
   new file appears without a manual registration step.

---

### Edge Cases

- A shared file is referenced by a skill and then deleted or renamed. What detects the break,
  and when — at validation time, at catalog-generation time, or only when the skill is run?
- Two skills reference the same shared knowledge file but need conflicting versions of it
  (one relies on content the other has since required changed). Each skill's `dependencies`
  entry pins its own required version, so the two skills can depend on different versions of
  the same path without conflicting; a mismatch is only a failure for the skill whose pinned
  version does not match the file's current `metadata.version`.
- A governance file in `.highway/content/governance/` states a rule that conflicts with a rule
  already in `.specify/memory/constitution.md`. Precedence between the two is undefined.
- A template file under `.highway/content/templates/` is, by its nature, an example of output
  shape rather than an instruction — it may legitimately contain placeholder text that looks
  like a vague, uncited, or incomplete rule. The rule-content checks (keyword-count,
  word-limit, citation format) that apply to governance and knowledge files must not misfire on
  a template's placeholder text, since a template's output is consumed as another skill's
  input, not evaluated as a rule statement.
- A skill references a shared file using a relative path that breaks if the skill or the
  content file moves. The stale-path defect from prior features recurs at this new join point
  unless the reference mechanism is path-independent.
- Two different skills need two different versions of the same shared file's content
  (one needs the old wording, one needs the new). Resolved by FR-015: each skill's dependency
  entry pins its own required version, so no single shared file version has to serve every
  referencing skill at once.
- A shared file under `.highway/content/` is itself never used by any skill. Whether an unused
  shared file is a defect worth detecting is undecided.

## Requirements *(mandatory)*

### Functional Requirements

**Directory structure**

- **FR-001**: The repository MUST provide three directories for shared content:
  `.highway/content/templates/`, `.highway/content/knowledge/`, and
  `.highway/content/governance/`.
- **FR-002**: `.highway/content/templates/` MUST hold markdown templates that a skill's output
  is generated from.
- **FR-003**: `.highway/content/knowledge/` MUST hold general reference knowledge shared across
  more than one skill.
- **FR-004**: `.highway/content/governance/` MUST hold governance content shared across more
  than one skill.

**Referencing shared content from a skill**

- **FR-005**: A skill MUST be able to reference a file under `.highway/content/` without
  copying that file's content into the skill's own `SKILL.md`, by listing it in a `dependencies`
  frontmatter field as a framework-relative path (relative to `.highway/`, e.g.
  `content/templates/foo.md`, matching how the existing skill catalog's `source_path` is already
  `.highway/`-relative) paired with the required version.
- **FR-006**: A skill listing a `dependencies` path that does not exist under `.highway/content/`
  MUST fail validation, naming the missing path.
- **FR-007**: A `dependencies` path MUST be interpreted as framework-relative (relative to
  `.highway/`), so resolution does not depend on which directory the validating tool is run
  from.

**Constitution enforcement on shared content**

- **FR-008**: Every file under `.highway/content/` MUST be validated against the same
  constitution the tooling built in feature 003 already reads at run time, so no rule content
  is duplicated into a second, content-specific standard.
- **FR-009**: A rule that does not apply to a given content type (for example, a section-
  presence rule that presumes a skill's fixed section set) MUST be recorded as not-applicable
  for that file, not silently skipped and not silently passed.
- **FR-010**: A rule violation in a shared content file MUST be reported the same way a rule
  violation in a skill is reported: by rule ID and by the observable that decided it.
- **FR-011**: The three content types MAY be held to different applicable-rule subsets from
  each other and from a skill, since a template's placeholder text, a knowledge file's prose,
  and a governance file's policy statements are not interchangeable in structure.

**Discovery**

- **FR-012**: An author MUST be able to produce a listing of every file under
  `.highway/content/`, grouped by content type, without manually registering each file
  elsewhere.

**Frontmatter, versioning, rule scope, and discovery**

- **FR-014**: A shared content file MUST carry minimal frontmatter (`name`, `description`,
  `metadata.version`) — not the full skill frontmatter shape, since `compatibility` is
  agent/adapter-specific and does not apply to shared content.
- **FR-015**: A skill's `dependencies` entry MUST record both the framework-relative path and
  the version of the shared file it was written against. Validation MUST fail when the pinned
  version does not match the shared file's current `metadata.version`, naming the path and the
  expected versus actual version.
- **FR-016**: Governance files and knowledge files MUST be checked against the same
  rule-content checks (keyword-count, word-limit, citation format) that apply to a skill's
  body. Template files MUST be checked against a hand-picked subset of rules instead, since a
  template's placeholder text is output shape a downstream skill consumes, not a rule
  statement in its own right. The specific rules in the template subset are named during
  planning, once real templates exist to test the subset against (see Out of Scope).
- **FR-017**: A separate, sibling listing artifact MUST be generated for `.highway/content/`,
  grouped by content type, rather than adding shared content entries to the existing skill
  catalog — the skill catalog's schema is closed to additional properties and shaped around
  skill-specific fields that do not fit a governance or knowledge file.

### Key Entities

- **Shared content file**: A markdown file under `.highway/content/`, belonging to exactly one
  of three types: template, knowledge, or governance. Referenced by zero or more skills.
- **Content type**: One of `template`, `knowledge`, `governance`. Determines which rule-content
  checks apply per FR-016.
- **Reference**: A named dependency from a skill to a shared content file, recorded as a
  framework-relative path plus a pinned version in the skill's `dependencies` frontmatter field.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A shared file's content edited without a `metadata.version` bump is reflected by
  every skill referencing it at next validation, with zero edits to any referencing skill's
  `dependencies` entry.
- **SC-002**: A skill referencing a nonexistent shared file fails validation 100% of the time,
  naming the missing path.
- **SC-003**: For each constitution rule that applies to a content type, a seeded violation in
  a file of that type is detected and reported by rule ID.
- **SC-004**: Zero rules that do not apply to a content type produce a false failure on that
  content type.
- **SC-005**: Every file under `.highway/content/` appears in the discovery listing; zero
  omissions and zero manual registration steps required.
- **SC-006**: Reference resolution in FR-007 succeeds regardless of the current working
  directory of the validating tool.
- **SC-007**: A shared file whose `metadata.version` is bumped causes every skill still pinned
  to the prior version to fail validation, naming the expected versus actual version, until the
  skill's `dependencies` entry is updated.

## Assumptions

- Constitution 2.0.1 is in effect, with the enforcement tooling from feature 003 already
  reading rule inventory, tiers, and token lists from it at run time rather than from a copy.
- "The same constitution requirements as the skills themselves" means shared content is subject
  to enforcement by rule ID, the same mechanism feature 003 built for skills — not that every
  rule applies identically regardless of content type. FR-011 records that different content
  types may have different applicable subsets, and FR-016 leaves the exact subset for
  clarification.
- This feature does not change the constitution itself. If a rule turns out to need a new
  Observable to be checkable against non-skill content, that is a follow-on constitution
  amendment, not part of this feature.
- No skill currently references any shared content, since `.highway/content/` does not yet
  exist. This feature has no existing skill to migrate or break.
- The reuse of feature 003's constitution-parsing tooling (rule inventory, tiers, body scanner)
  is preferred over building a second, content-specific parser, consistent with the
  no-duplication rule the tooling itself already enforces.

## Out of Scope

- Changing `.specify/memory/constitution.md` itself.
- Authoring any actual template, knowledge file, or governance file content. This feature
  delivers the structure and the enforcement; populating it is separate, follow-on work.
- Migrating or rewriting any existing skill to reference shared content, since none currently
  exists to migrate.
- A search or recommendation feature that suggests relevant shared content to an author;
  FR-012 requires only a complete listing, not ranking or suggestion.
- Naming the exact rule subset that applies to template files (FR-016). That subset is decided
  during planning, once real template content exists to test candidate rules against.
