# Feature Specification: Enforce the Experience Standard

**Feature Branch**: `018-experience-enforcement`

**Created**: 2026-09-08

**Status**: Draft

**Input**: User description: "I want the Highway Experience Standard's X rules enforced by the same tooling that already enforces the constitution's P rules, rather than by a second parallel mechanism. Extend lib/constitution.sh so it can load more than one governance document and return a merged rule inventory, register the automatically checkable X rules in the rule-check library alongside the P rules, and keep the existing five-group coverage summary format unchanged so every rule id still appears in exactly one group. Extend the constitution inventory test so it asserts every X rule appears in exactly one coverage group, the same way it does for P rules today. Where an X rule constrains runtime output that a static validator cannot see, use a golden-output fixture per skill instead, and require the skill's Verification section to name the X rules its self-check exercises."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - No X rule can silently go unenforced (Priority: P1)

Today the Experience Standard exists and nothing reads it. All eight `X` rules are
`[agent-checkable]`, which is honest, but there is no inventory asserting that each rule is
accounted for. A ninth rule could be added tomorrow and no machinery would notice.

After this feature the rule loader reads both shipping governance documents, and the inventory
test asserts every `X` rule lands in exactly one coverage group — the same guarantee `P` rules
have had since feature 013.

**Why this priority**: This is the durable part. Whatever proportion of rules turns out to be
automatable, the inventory is what stops the standard drifting into decoration.

**Independent test**: Add a rule to the standard without touching anything else; the inventory
test fails until that rule is accounted for.

**Acceptance Scenarios**:

1. **Given** the rule loader, **When** it is asked for the inventory, **Then** it returns both `P` and `X` rules from their respective documents.
2. **Given** an `X` rule in no coverage group, **When** the inventory test runs, **Then** it fails naming that rule.
3. **Given** every `X` rule accounted for, **When** the suite runs, **Then** it passes.
4. **Given** the loader, **When** it reads the development constitution, **Then** it still does not — that document does not ship and is out of scope.

---

### User Story 2 - The automatable X rules are decided automatically (Priority: P1)

Where a rule can be decided by reading a `SKILL.md`, it should be, reported under its own rule id
in the existing five-group summary rather than by a parallel mechanism.

**Why this priority**: It is the request. But see the Edge Cases — the honest size of this set is
small, and this story must not be inflated to justify the machinery.

**Independent test**: Break a skill so it violates an automated `X` rule; the validator reports
that rule id under `FAILED`.

**Acceptance Scenarios**:

1. **Given** an automatable `X` rule, **When** the validator runs, **Then** the rule id appears under `CHECKED` or `FAILED`, never `UNCHECKED`.
2. **Given** a skill violating that rule, **When** the validator runs, **Then** it exits non-zero and names the rule id.
3. **Given** a rule retagged `[auto]`, **When** the standard is read, **Then** the retag is recorded as an amendment with its reasoning.
4. **Given** a rule that cannot be decided mechanically, **When** this feature completes, **Then** it remains `[agent-checkable]` rather than being tagged optimistically.

---

### User Story 3 - Rules about emitted output get a recorded specimen (Priority: P2)

Several `X` rules constrain what a skill emits at runtime. No static check can see that. The
request asks for a golden-output fixture per skill — but see Edge Cases: **nothing in this
repository can execute a skill**, so there is no output to capture.

The available substitute is each skill's own `## Example` section, which is a recorded specimen of
its output that already exists and already ships.

**Why this priority**: Valuable, and the only route to checking emission rules at all — but it
rests on a substitution the user has not yet approved.

**Independent test**: Change a skill's Example so it no longer matches the shape its Outputs
section declares; a check fails.

**Acceptance Scenarios**:

1. **Given** a skill whose Example matches its declared Outputs shape, **When** the check runs, **Then** it passes.
2. **Given** a skill whose Example omits a declared field, **When** the check runs, **Then** it fails naming the field.
3. **Given** a skill with no emission-shaped output, **When** the check runs, **Then** it is recorded `N/A` rather than failing.

---

### User Story 4 - Each skill names the X rules its own self-check exercises (Priority: P2)

A skill's Verification section already names commands and states to check. It should also name
which `X` rules that self-check covers, so the rules a static validator cannot decide are at least
claimed and reviewable at a named place.

**Why this priority**: It is the honest fallback for rules no machine will ever decide, and it
costs two small edits.

**Independent test**: Read either skill's Verification section and list the `X` rules it claims to
exercise.

**Acceptance Scenarios**:

1. **Given** each skill, **When** its Verification section is read, **Then** it names the `X` rules its self-check exercises.
2. **Given** a named rule id, **When** it is looked up, **Then** it exists in the standard.
3. **Given** those edits, **When** the suite runs, **Then** the catalog and adapters have been regenerated per `D4.7`.

---

### Edge Cases

Found by inspecting the repository on 2026-09-08. The first two change what this feature can be.

- **Nothing can execute a skill.** `.highway/tools/` holds six scripts: four generators and two
  validators. A skill is Markdown instructing an agent, not an executable. A golden-output fixture
  presumes a runner that does not exist, so the request's fallback is infeasible as literally
  stated. Both skills do carry a populated `## Example` section — 9 and 7 non-blank lines — which
  is a recorded specimen and is the available substitute.
- **The automatable set is small, and may be very small.** All eight `X` rules govern emitted
  output. `validate-skill.sh` reads a `SKILL.md`. Only rules that constrain what the *file
  declares* are statically decidable — plausibly `X1.1`, and `X1.2` only against the Example
  specimen. Five or more rules will remain `[agent-checkable]`, and the feature must say so rather
  than inflate the number.
- **`con_rules()` is namespace-bound by regex**, matching `P[0-9]+\.[0-9]+`. This is the same
  defect that made feature 014's first guard pass without iterating anything. Any change here
  needs a vacuity assertion proving the reader matched something.
- **`CONSTITUTION_FILE` is a single path, not a list.** Extending it to several documents changes
  a shipped file's contract; existing callers that set it must keep working.
- **The loader ships.** Unlike feature 014's development constitution, the Experience Standard is
  distributed, so teaching shipped code to read it is legitimate rather than a layer violation.
- **A category tension.** `X` rules govern emissions; the validator reads a file. Registering an
  `X` rule in a skill validator asserts something about the skill's *declaration*, not its
  behaviour. Wherever that gap exists it must be stated, not papered over.
- **Editing both skills triggers `D4.7`.** Regeneration is required in the same change.

## Requirements *(mandatory)*

### Functional Requirements

#### The inventory

- **FR-001**: The rule loader MUST be able to read more than one governance document and return a merged inventory of rule id, tier, and source document.
- **FR-002**: The loader MUST NOT be bound to a single rule-id namespace by its matching pattern.
- **FR-003**: Existing callers that set a single document path MUST keep working unchanged.
- **FR-004**: The loader MUST NOT read the development constitution, which does not ship.
- **FR-005**: The inventory test MUST assert every `X` rule appears in exactly one coverage group, and MUST fail if any rule appears in none or in more than one.
- **FR-006**: The inventory test MUST assert that its reader matched at least one rule from each document it claims to cover, so a namespace mismatch cannot pass vacuously.

#### The automated checks

- **FR-007**: Every `X` rule that can be decided by reading a `SKILL.md` MUST be registered in the existing rule-check library and reported under its own rule id.
- **FR-008**: The existing five-group coverage summary format MUST be unchanged, and every rule id MUST appear in exactly one group.
- **FR-009**: No second enforcement mechanism may be introduced alongside the rule-check library.
- **FR-010**: An `X` rule that cannot be decided mechanically MUST remain `[agent-checkable]`. Tagging it `[auto]` because enforcement was the goal is prohibited.
- **FR-011**: Each retag MUST be recorded as an amendment to the standard with its reasoning.
- **FR-012**: Each new check MUST be evaluated against every existing fixture before it is enabled, per `D3.4`, and MUST be observed failing and then passing again.
- **FR-013**: The `UNCHECKED` group MUST be empty for every skill after this feature, as it is today.

#### The specimen

- **FR-014**: Where an `X` rule constrains emitted output, the check MUST operate on the skill's `## Example` section as a recorded specimen, because no runner exists to produce live output.
- **FR-015**: The specimen check MUST record `N/A` rather than fail where a skill has no output of the relevant shape.
- **FR-019**: A value the specimen shares with the skill's own metadata MUST agree with it. Where the Example shows a version, it matches the frontmatter version.
- **FR-020**: The live defect found by FR-019 MUST be repaired **before** the check is enabled, so that enabling it invalidates no conforming work.
- **FR-021**: FR-019's obligation MUST be stated as a rule in the Experience Standard, added as a MINOR amendment, rather than enforced by a check with no rule behind it.

**Decided 2026-09-08: use the `## Example` section as the specimen.** Both alternatives were
rejected. Hand-maintained golden files have the shape of verification without the substance — two
hand-written files agreeing proves only that someone wrote them consistently. Skipping specimen
checking entirely is honest but delivers no mechanical check on emitted shape at all.

**This makes each Example load-bearing**, which is the point rather than a side-effect. An Example
that contradicts what the Outputs section declares is already a defect; today nothing looks, so it
rots quietly in a file that ships into three agent trees.

**A live instance already exists.** Verified 2026-09-08: `highway-help`'s frontmatter reads
`3.0.2` while its Example still shows `Version: 3.0.1`. The drift was introduced by feature 017
hours earlier — the version was bumped and the Example was not — and no gate noticed.
`highway-inquiry` has no version line in its Example and is `N/A`.

FR-020 exists because of the ordering lesson feature 016 recorded: enabling a rule against a tree
that violates it is a strengthening, and the repair belongs first.

#### The declared coverage

- **FR-016**: Each skill's Verification section MUST name the `X` rules its self-check exercises.
- **FR-017**: Every named rule id MUST exist in the standard, and no skill may claim a rule its self-check does not exercise.
- **FR-018**: Both skills MUST be regenerated after editing, per `D4.7`, and MUST carry a version increment.

### Key Entities

- **Rule inventory**: the merged set of rule ids, tiers, and source documents that the tooling knows about.
- **Coverage group**: one of `CHECKED`, `FAILED`, `N/A`, `DEFERRED`, `UNCHECKED`. Every rule id lands in exactly one.
- **Registered check**: a function in the rule-check library bound to a rule id.
- **Specimen**: a recorded example of a skill's output, available today as its `## Example` section. Load-bearing after this feature: an edit to it can fail the suite.
- **Declared coverage**: the `X` rules a skill's Verification section claims its self-check exercises.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every `X` rule appears in exactly one coverage group, and adding a rule without accounting for it fails the suite.
- **SC-002**: The number of `X` rules decided automatically is stated as a measured figure, not an aspiration, and every remaining rule is honestly tiered.
- **SC-003**: Each new check has been observed failing and then passing again after restoration.
- **SC-004**: The `UNCHECKED` group is empty for every skill.
- **SC-005**: No second enforcement mechanism exists; the rule-check library remains the only one.
- **SC-006**: A reader can determine, for any `X` rule, what decides it — a script, a specimen, or a named human self-check.
- **SC-007**: The suite passes, artifacts are current, and both skills validate.
- **SC-008**: An Example that drifts from the skill it illustrates fails the suite. Today it does not, and one such drift is already present.

## Assumptions

- **The Experience Standard is stable.** Feature 017 ratified it at 1.0.0 with 8 rules; this feature enforces rather than revises, except for tier retags.
- **Retagging a rule from `[agent-checkable]` to `[auto]` is MINOR** — it reflects enforcement that now exists rather than a new obligation.
- **Both shipping documents may be read by shipped tooling.** The loader already ships, and so do both governance documents.
- **The five-group summary is a contract**, relied on by the coverage-summary test and the inventory test.
- **Most `X` rules will remain `[agent-checkable]`.** That is the expected outcome, not a shortfall.

## Dependencies

- Feature 017's Experience Standard and its tier definitions.
- Feature 013's rule-check library, coverage summary, and inventory test.
- Feature 016's `D4.7`, which makes regeneration after the skill edits enforced.

## Out of Scope

- **Building a skill runner.** Executing a skill to capture real output is a much larger feature and is not attempted here.
- **Adding or removing `X` rules**, with one approved exception: the rule required by FR-021, which states the obligation FR-019 enforces. Decided 2026-09-08 — the alternatives were an unstated obligation, which feature 011 established is discoverable only by failing the suite, or redefining `X1.2` to mean whatever the check happens to do, which is the defect features 013, 014 and 016 each removed. Otherwise only tiers change.
- **Enforcing `D` rules.** The development constitution does not ship and is owned by its own Enforcement Map.
- **Changing the five-group summary format.**
