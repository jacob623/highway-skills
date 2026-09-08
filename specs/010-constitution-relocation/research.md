# Research: Constitution Relocation and Shipped-Tree Independence

Phase 0 output. Each item records a decision, the reasoning, and the alternatives rejected.

## R1: How is the constitution moved, and what is left at the vacated location?

**Decision**: Move the file to `.highway/governance/constitution.md` with its rule text
byte-unchanged, and leave a short placeholder at `.specify/memory/constitution.md`.

**Reasoning**: Ten development workflow commands read the vacated location — every `speckit-*`
skill without exception. Deleting the file degrades all of them until the next phase installs a
development constitution there. A placeholder costs one small file and keeps the workflow usable
in the interval.

The placeholder is a development-only artifact, so it may freely reference development locations;
it is outside the scope of the new check by construction.

The placeholder states three things: that the Highway Skills Constitution has moved, where it now
lives, and that development-process rules will replace this file. It states no rule and defines no
rule ID, so nothing can cite it by accident.

**Alternatives rejected**:

- *Delete the file and accept the gap.* Leaves ten commands degraded with no signal explaining
  why, and a future reader finding a missing file has no pointer to the new location.
- *Leave a symbolic link to the new location.* Would keep commands working, but it means the
  development workflow silently evaluates plans against skill-content rules — the exact confusion
  the layer separation exists to remove. It also cannot survive the next phase, which needs the
  path to hold different content.
- *Move the file and immediately write the development constitution in the same feature.* Couples
  two governance acts into one change and would make this feature's own Constitution Check
  incoherent, since the document governing it would change mid-feature.

## R2: How does the constitution's location get resolved after the move?

**Decision**: Change only the fallback branch in `con_file()` within
`.highway/tools/lib/constitution.sh`, from the repository-root development path to
`<highway root>/governance/constitution.md`. Leave the `CONSTITUTION_FILE` override untouched.

**Reasoning**: The override already exists and already takes precedence — the current
implementation checks `CONSTITUTION_FILE` first and falls back only when it is empty. The feature
description assumed configurability had to be built; it does not. This reduces the change to one
line plus the removal of the now-unused repository-root argument where callers no longer need it.

The resolution must be anchored at the framework root rather than the repository root. The two
differ, and anchoring at the repository root is what made the document unreachable from a
distributed tree in the first place.

**Alternatives rejected**:

- *Search several candidate locations in order.* Introduces a rule about precedence between
  locations that has no reader-visible benefit, and makes a misplaced file resolve silently
  instead of failing loudly.
- *Require every caller to pass the location explicitly.* Removes a default that is correct in
  every current case, and adds an argument to every call site for no gain.

## R3: What replaces a design-record path reference?

**Decision**: A name-only citation of the form `feature NNN (short-name)`, for example
`per feature 003 (constitution enforcement)`. No path, no link, no directory name.

**Reasoning**: The clarification recorded in the spec put both document links and source comments
in scope. Every such reference exists to answer "why is this the way it is", and a reader with the
development tree can still locate `specs/003-constitution-enforcement/` from the feature number
alone. A reader without the development tree could not have followed the path either, so nothing
is lost that was previously available to them.

Consistency across all 15 files matters more than the specific form chosen. A single form means a
reader learns the convention once, and a future reviewer can spot a deviation without a rule.

**Alternatives rejected**:

- *Keep the path but mark it as development-only in a comment.* The string is still present, so
  the check would have to interpret intent rather than match text — the failure mode that makes a
  guard rail untrustworthy over time.
- *Remove the provenance entirely.* Loses the reasoning behind non-obvious tooling decisions,
  which is the most valuable content in those comments.
- *Copy each design record into the distributed tree.* Turns records that are deliberately frozen
  and historical into maintained documentation, and duplicates content that would then drift.

## R4: How is the set of distributed paths declared, and how does the check consume it?

**Decision**: Declare the distributed path set once, as a list in the new test, and have the check
iterate it. The set is: `.highway/`, `.github/skills/highway-*`, `.claude/skills/highway-*`,
`.cursor/rules/highway-*`.

**Reasoning**: The spec requires the set to live in exactly one place, so that a later change adds
a path in one location rather than in each check independently. Declaring it as a list at the top
of the check follows the pattern already established by `AGENT_IDS` and `AGENT_TARGET_TEMPLATES`
in `generate-agent-adapters.sh`, where adding an agent is one new row.

The agent adapter patterns are restricted to the `highway-` prefix deliberately. The repository
also contains `speckit-*` adapter directories, which are external tooling used to build this
repository and are not Highway's product. `generate-agent-adapters.sh` already treats them as
out of bounds; the check does the same.

A later phase will need this same declaration for packaging. Keeping it in one place now means
that phase can lift it rather than re-derive it.

**Alternatives rejected**:

- *Scan the whole repository and exclude development paths.* Inverts the safer default: a new
  directory would be treated as distributed and scanned until someone excluded it. Listing what
  ships means a new directory is out of scope until deliberately added, which fails safe in the
  direction that matters — a false negative in the check is worse than a false positive.
- *Derive the set from the adapter manifest.* The manifest tracks generated adapter files only; it
  knows nothing of `.highway/skills/` or the catalog.

## R5: Are test fixtures excluded from the check?

**Decision**: No exclusion. Fixtures are scanned like every other file under `.highway/`.

**Reasoning**: Every fixture under `.highway/tools/tests/fixtures/` was searched; none contains a
reference to a development-only location. The exclusion contemplated in the spec would therefore
exempt a category that has nothing to exempt, while creating a permanent blind spot.

This also follows the precedent set by `path-integrity.test.sh`, whose header records that an
earlier version enumerated four documents, never looked at the fixtures, and so missed stale paths
in them for two features. Narrowing scope is the specific mistake that check already learned from.

The check must, however, exclude *itself*: the test file necessarily contains the strings it
searches for. `path-integrity.test.sh` solves this with a filename skip parameter, and the same
mechanism applies here.

**Alternatives rejected**:

- *Blanket fixture exemption.* Creates a directory where the rule does not apply, which is where a
  violation would eventually settle unnoticed.
- *Exclude by marker comment in the file.* Any file could then exempt itself, which makes the rule
  advisory rather than enforced.

## R6: How is the help skill's version increment classified?

**Decision**: PATCH. `3.0.0` → `3.0.1`.

**Reasoning**: Checked against the Skill Versioning Policy text rather than by analogy. That
policy defines PATCH as a wording repair with no change to Inputs, Outputs, or Verification, and
MAJOR as a breaking change to the skill contract, where the contract is the declared Inputs,
declared Outputs, and Verification criteria taken together.

The edits remove two pointers to a design record. One sits inside the `## Outputs` prose and one
at the end of `## Verification`. Neither is itself a declared output or a verification criterion:

- The `## Outputs` reference names the contract that specifies the field order. The field order,
  the field names, and the rendering rules are all stated in the section itself and are unchanged.
- The `## Verification` reference points to a fuller set of scenarios. The three verification
  criteria listed above it are unchanged, and each still names a runnable command or a checkable
  output string.

No declared input changes. No output field, order, or value changes. No verification criterion
changes. A caller invoking the skill before and after this feature receives identical output.
That is a wording repair.

**Alternatives rejected**:

- *MINOR.* Requires a capability to be added. None is.
- *MAJOR.* Requires an element of the contract to be removed, narrowed, or redefined. A pointer to
  a design record is none of those. This was checked explicitly rather than assumed, because the
  preceding feature recorded that bump classification must be verified against the policy text.

## R7: The relocated constitution would violate the rule this feature introduces

**Decision**: Rewrite the development-only path references inside the constitution's Sync Impact
Report to the name-only form defined in R3, as part of the move.

**Reasoning**: This is the finding that most affects the feature's correctness. The constitution's
Sync Impact Report — the HTML comment at the top of the file — cites `.specify/templates/` and two
`specs/` directories. Those references are harmless where the file lives today, because the file
is a development artifact. Moving it into the distributed tree makes it a distributed artifact,
and the same three references become violations of the rule this feature is establishing.

Without this step the feature would ship a governance document that fails its own new check, and
the check would fail on its first run.

The rewrite touches metadata only. No rule, no Observable, no tier, and no rule ID changes, so the
constitution's own version is not incremented: its versioning policy reserves PATCH for wording
repair with no change to any Observable, and this does not even reach that — the amended text sits
in a comment that states no rule.

**Alternatives rejected**:

- *Exempt the constitution from the check.* The document the framework is built around would be
  the one file allowed to contain dangling references, which is precisely backwards.
- *Strip the Sync Impact Report entirely.* Discards the amendment history that the constitution's
  own versioning policy requires each amendment to record.
- *Leave the references and fix them in a later feature.* The check added by this feature would
  fail immediately, so the feature could not complete.

## R8: Does the new check duplicate `path-integrity.test.sh`?

**Decision**: Add a separate check rather than extending the existing one.

**Reasoning**: The two ask different questions. `path-integrity.test.sh` asks whether a path
inside `.highway/` would mislead a reader into opening something at the repository root — a
correctness question about relative references, scoped to `.highway/` only. The new check asks
whether a distributed file references a location the user will not have — a shippability question,
scoped to the distributed set including the three adapter trees outside `.highway/`.

Merging them would produce one check with two unrelated patterns, two scopes, and a failure
message that has to explain which of two distinct problems occurred.

What is reused is the *shape*: whole-tree scanning rather than an enumerated file list, a filename
skip to exclude the check from its own search, and a seeded probe confirming the check can fail.
That last element matters most — a check that cannot be shown to fail proves nothing.

**Alternatives rejected**:

- *Extend `path-integrity.test.sh` with a second pattern.* Conflates two rules in one place and
  makes either harder to change without disturbing the other.
- *Add the check inside `validate-skill.sh`.* That validator judges one skill directory against
  the constitution. Shippability is a property of the tree, not of a skill, and most violations
  are in files no skill validator ever reads.
