# Feature Specification: Standard Alignment Agent Skills Format Conformance

**Feature Branch**: `feature/std-alignment-phase12`

**Created**: 2026-11-12

**Status**: Draft

**Input**: User description: "create a new spec to implement phase 12 of standard-alignment.md". Phase 12 (Agent Skills Format Conformance) makes every Highway skill pass the Agent Skills specification's rules, enforced by the bash suite. Frontmatter uses only the standard fields: `usage` moves under `metadata`, `compatibility` states real environment requirements or is left out, and `license` is added. Frontmatter parses as strict YAML, so a client with a strict parser loads every skill. Each `description` says what the skill does and when to use it, with the words a person would use. Handoff text names the next skill without assuming one way to invoke it, because agents differ: `/highway-adr`, `$highway-adr`, and the plugin-namespaced `highway:highway-adr`. `validate-skill.sh` runs on the source folders and enforces every rule in the specification, the same checks as `skills-ref validate`: the frontmatter block and strict YAML, the `name` format and its match with the folder, the `description` and `compatibility` lengths, only the defined fields, and `metadata` values as strings. The development constitution names the Agent Skills specification as the authority on skill format and replaces its own frontmatter rules that conflict with it. `allowed-tools` is out of scope: it pre-approves tools rather than restricting them, so declaring it is a consent decision, not a conformance gap. Exit: every skill passes the specification's validation in the bash suite.

## Clarifications

### Session 2026-11-12

- Q: Which license do the skills declare in `license`? → A: Apache-2.0. Phase 14's `plugin.json` and public `LICENSE` carry the same license.
- Q: What happens to the list-valued `metadata.dependencies` and `metadata.agent_exceptions`, which the specification's string-only `metadata` forbids? → A: Remove both, with the dependency check, the help index's `dependencies` field, and highway-help's `Dependencies:` line.
- Q: How do `metadata.usage` and the `## Example` section show an invocation? → A: `usage` names the skill and its arguments only, like handoffs. The Example keeps `/highway-adr` as one agent's illustration.
- Q: Should the closed word list keep checking skill descriptions now that they must use the words a person would use? → A: No. Retire the word list and its check entirely: the list, its library, and its tests.
- Q: Should the validator check automatically that each description says when to use the skill, or should a reviewer judge it? → A: Both. The validator fails a description without a sentence beginning "Use when", and a reviewer judges that the sentence is accurate and uses everyday words.
- Q: What frontmatter form should skills be held to so that a strict YAML parser and Highway's validator always read the same values? → A: Add a real, strict YAML parser to the development constitution's Declared Toolchain and validate frontmatter with it. The plan chooses the parser.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Any Agent Skills client loads every Highway skill (Priority: P1)

A person installs Highway's skills into an agent that follows the Agent Skills specification and loads skills with a strict parser. Every Highway skill loads, with the name, description, and metadata its author intended. No skill is skipped for an unknown field, a value of the wrong type, or frontmatter the parser reads differently from Highway's own tools.

**Why this priority**: Agent Plugins requires every skill in a plugin to conform to Agent Skills, and tells clients to skip a skill that does not. A skill a client skips does not exist for that person. Today every skill carries a non-standard top-level `usage` field and `compatibility: all`, which states no environment requirement, and none carries a `license`.

**Independent Test**: Parse every skill's frontmatter with a strict YAML parser and compare the result with the fields and values Highway's own tools read. List every top-level field and every `metadata` value's type.

**Acceptance Scenarios**:

1. **Given** any Highway skill, **When** its frontmatter is read, **Then** its top-level fields are only `name`, `description`, `license`, `metadata`, and, when the skill has a real environment requirement, `compatibility`.
2. **Given** any Highway skill, **When** its frontmatter is parsed by a strict YAML parser, **Then** the parse succeeds and yields the same field names and values that Highway's validator and index generator read.
3. **Given** any Highway skill, **When** its `metadata` is read, **Then** every value is a string, including `version` and `usage`.
4. **Given** any Highway skill, **When** its `license` is read, **Then** it is `Apache-2.0`.
5. **Given** a Highway skill with no real environment requirement, **When** its frontmatter is read, **Then** it has no `compatibility` field.

---

### User Story 2 - The bash suite enforces the Agent Skills specification (Priority: P1)

A maintainer edits a skill's frontmatter and runs `validate-skill.sh` on the source folder. Every rule in the Agent Skills specification is checked, the same rules `skills-ref validate` checks. A violation fails validation with an error that names the rule and the field, and the full suite proves each check can fail.

**Why this priority**: Conformance that is not enforced drifts. This is the phase's exit condition: every skill passes the specification's validation in the bash suite.

**Independent Test**: Run `validate-skill.sh` on every skill. Seed one violation of each specification rule into a copy of a valid skill and run the validator on each copy.

**Acceptance Scenarios**:

1. **Given** every Highway skill, **When** `validate-skill.sh` runs on its source folder, **Then** it passes, and the suite checks this for every skill.
2. **Given** a skill copy with no frontmatter block, or with frontmatter a strict YAML parser rejects, **When** the validator runs, **Then** it fails and names the frontmatter problem.
3. **Given** a skill copy whose `name` is longer than 64 characters, has an uppercase letter, starts or ends with a hyphen, contains two hyphens in a row, or differs from its folder, **When** the validator runs, **Then** it fails and names the `name` rule broken.
4. **Given** a skill copy whose `description` is empty or longer than 1,024 characters, or whose `compatibility` is present but empty or longer than 500 characters, **When** the validator runs, **Then** it fails and names the field and its limit.
5. **Given** a skill copy with a top-level field the specification does not define, **When** the validator runs, **Then** it fails and names the field.
6. **Given** a skill copy with a `metadata` value that is not a string, **When** the validator runs, **Then** it fails and names the key.
7. **Given** the full suite, **When** it runs, **Then** each specification check is proven able to fail by a seeded violation.

---

### User Story 3 - An agent picks the right Highway skill from its description (Priority: P2)

A person asks their agent, in their own words, to record an architecture decision, start a business request, or set up Highway. The agent sees only each skill's `name` and `description` when it decides which skill to load, and every Highway description says what the skill does and when to use it, in the words a person would use.

**Why this priority**: The description is the only thing an agent reads before choosing a skill. Today every Highway description says what the skill manages but none says when to use it, so an agent can miss the right skill when the person does not type its name.

**Independent Test**: Read every skill's `description`. For each, check that it states what the skill does and when to use it, and that it contains the everyday words a person would use for that task.

**Acceptance Scenarios**:

1. **Given** any Highway skill, **When** its `description` is read, **Then** it states what the skill does, followed by a sentence beginning "Use when" that says when to use it.
2. **Given** a skill copy whose description has no sentence beginning "Use when", **When** the validator runs, **Then** it fails and names the `description` rule.
3. **Given** a description's "Use when" sentence, **When** a reviewer checks it, **Then** it matches the skill's `## When to use` section and uses the words a person would use for that task.
4. **Given** a description written in the words a person would use, **When** the validator runs, **Then** no word in it is rejected for being outside a fixed vocabulary, because the closed word list and its check are retired.
5. **Given** the help index, **When** it is regenerated, **Then** each skill's entry carries the new description and the usage from `metadata`, and no `dependencies` field. highway-help prints `Name:`, `Description:`, `Version:`, `Usage:`, and `Example:` for one skill, without a `Dependencies:` line.

---

### User Story 4 - Handoffs work in every agent (Priority: P2)

A person finishes a step in one Highway skill, and the skill tells them which skill to run next. The person may use an agent that runs skills with `/name`, one that uses `$name`, or one that namespaces plugin skills as `highway:name`. The handoff names the next skill and what to give it, without prescribing a syntax that works in only some of those agents.

**Why this priority**: A handoff that prescribes one agent's syntax misleads people in every other agent. It does not stop a skill from loading, so it ranks below conformance.

**Independent Test**: Search every skill for text that tells the person to run another skill or the same skill again, and check how it names the skill.

**Acceptance Scenarios**:

1. **Given** any Highway skill, **When** it tells the person to run a skill next, or to run one again, **Then** it names the skill and its arguments without a `/` or `$` prefix or a plugin namespace.
2. **Given** a skill's `metadata.usage`, **When** it is read, **Then** it names the skill and its arguments without a prefix or namespace, for example "Run highway-adr with one discovery id."
3. **Given** a skill's `## Example`, **When** it is read, **Then** it still shows a concrete invocation such as `/highway-adr DSC-001`, as one agent's illustration, and highway-help's `Example:` line prints it unchanged.
4. **Given** a person who types a skill's name with their agent's own syntax, **When** the skill runs, **Then** it behaves exactly as before; only the text the skill shows changes.

---

### User Story 5 - The governing documents defer to the Agent Skills specification (Priority: P3)

A maintainer writing a new skill reads the development constitution, the authoring standard, and the frontmatter contract. All three name the Agent Skills specification as the authority on skill format and agree with it, so no Highway document asks for a field or a value the specification forbids.

**Why this priority**: The documents tell authors what to write. If they keep asking for top-level `usage` or the `compatibility` list of agents, the next skill breaks conformance again. It ranks last because enforcement (User Story 2) already catches the result.

**Independent Test**: Read each document's frontmatter rules and compare them with the Agent Skills specification.

**Acceptance Scenarios**:

1. **Given** the development constitution, **When** a maintainer reads it, **Then** it names the Agent Skills specification as the authority on skill format, and its Declared Toolchain lists the YAML parser the validator uses.
2. **Given** the authoring standard and the frontmatter contract, **When** a maintainer reads them, **Then** they allow only the specification's top-level fields, place `usage` and `version` under `metadata` as strings, use the specification's limits for `name`, `description`, and `compatibility`, and drop the `compatibility` list of agents.
3. **Given** any Highway rule that conflicts with the specification, **When** this change is complete, **Then** the rule is replaced or removed, and each constitution's amendment records the change in its Sync Impact Report.

---

### Edge Cases

- `metadata.dependencies` and `metadata.agent_exceptions` are lists, but the specification allows only string values in `metadata`. No skill declares either today. Both are removed, with the dependency check, the help index's `dependencies` field, and highway-help's `Dependencies:` line. A skill that declares either fails validation, because its value is not a string.
- The `## Example` keeps `/highway-adr` while `usage` and handoffs name only the skill. The Example is a specimen of one conversation, not an instruction, and P9.5 still requires every value it shares with the frontmatter to match.
- A version such as `1.0` or a value such as `yes` reads as a number or a boolean in YAML. Every `metadata` value is written so that a strict parser reads it as a string.
- A description written for a person uses words a fixed vocabulary cannot anticipate. The closed word list is retired, so description quality is judged only by whether it says what the skill does and when to use it.
- A skill's body text that describes when the person invokes it (for example the `## When to use` triggers) is not a handoff. It names the skill the same way as handoffs, so no skill text prescribes one agent's syntax.
- The harness drives skills through Copilot with `/name` prompts. Those prompts are the person's input, not skill text, and they stay.
- highway-experience is loaded by every other skill and also invocable directly. Its description says both.
- `allowed-tools` stays undeclared. The validator accepts it, because the specification defines it, but no Highway skill uses it.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Every skill's frontmatter MUST use only the top-level fields the Agent Skills specification defines: `name`, `description`, `license`, `compatibility`, `metadata`, and `allowed-tools`.
- **FR-002**: `usage` MUST move from the top level to `metadata.usage` in every skill. Every reader of `usage` (the index generator, highway-help, the validator's word-list check, and the tests) MUST read it there.
- **FR-003**: A skill MUST omit `compatibility` unless it has a real environment requirement. When present, it MUST be 1 to 500 characters stating that requirement. The fixed list of agent values MUST be removed.
- **FR-004**: Every skill MUST declare `license: Apache-2.0`.
- **FR-005**: Every skill's frontmatter MUST parse under a strict YAML parser to exactly the fields and values Highway's tools read, and every `metadata` value MUST be a string. The validator MUST parse frontmatter with a real, strict YAML parser, not a line reader, and MUST fail a skill whose frontmatter that parser rejects or reads as a value of the wrong type.
- **FR-005a**: The development constitution's Declared Toolchain MUST gain that parser, in the same amendment that names the Agent Skills specification as the authority (FR-012). The parser MUST run on both target platforms (GNU and Apple/BSD) without network access. Every other script MUST keep to the Declared Toolchain, and the amendment's Sync Impact Report MUST record why D2.4 permits the addition.
- **FR-006**: Every skill's `description` MUST state what the skill does, followed by a sentence beginning "Use when" that says when to use it, in the words a person would use, within 1 to 1,024 characters. The Highway Skills Constitution MUST carry this as two rules: an automatic rule that the "Use when" sentence is present, which the validator enforces and the suite proves can fail, and an agent-checkable rule that the sentence agrees with the skill's `## When to use` section and uses everyday words.
- **FR-007**: The closed word list (`framework/frontmatter-lexicon.txt`), the library that checks free-form frontmatter prose against it, its call in the validator, its tests, and every reference to it in the framework's documents and the harness selection MUST be removed.
- **FR-008**: Text in which a skill tells the person to run a skill, and every skill's `metadata.usage`, MUST name that skill and its arguments without a `/` or `$` prefix or a plugin namespace. The `## Example` section MAY keep a `/` invocation as one agent's illustration.
- **FR-009**: `validate-skill.sh` MUST enforce every rule in the Agent Skills specification on a source skill folder: the frontmatter block and strict YAML; the `name` format (1 to 64 characters, lowercase letters, digits, and single hyphens, not at either end) and its match with the folder; the `description` length (1 to 1,024 characters); the `compatibility` length when present (1 to 500 characters); only the defined top-level fields; and string `metadata` values. Each violation MUST fail validation with an error naming the rule and the field.
- **FR-010**: The suite MUST prove each check in FR-009 can fail, with a seeded violation for each.
- **FR-011**: The validator MUST keep every Highway rule that the specification does not contradict, such as the required `metadata.version` (P7.2) and the required body sections.
- **FR-012**: The development constitution MUST name the Agent Skills specification as the authority on skill format. Every Highway frontmatter rule that conflicts with the specification, in the constitutions, the authoring standard, or the frontmatter contract, MUST be replaced or removed.
- **FR-013**: `metadata.dependencies` and `metadata.agent_exceptions` MUST be removed from the frontmatter contract and the authoring standard, with the dependency check, the help index's `dependencies` field, highway-help's `Dependencies:` line, and their tests.
- **FR-014**: Every changed skill MUST take a MINOR version bump. Each constitution amendment MUST be classified by that constitution's own Versioning Policy and recorded in its Sync Impact Report.
- **FR-015**: The help index, the agent trees, and every other generated file MUST be regenerated, and a second regeneration MUST change nothing.
- **FR-016**: `allowed-tools` MUST NOT be declared by any skill in this phase.

### Key Entities

- **Skill frontmatter**: The YAML block at the top of `SKILL.md`. After this change it holds `name`, `description`, `license: Apache-2.0`, optional `compatibility`, and `metadata` with exactly two string values, `version` and `usage`.
- **Agent Skills specification**: The open standard that defines one skill folder's format. It is the authority on skill format, and Highway's own rules may add to it but not contradict it.
- **Handoff text**: Any sentence in which a skill tells the person to run a skill next or again.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 16 Highway skills pass `validate-skill.sh` with every Agent Skills specification check enabled, and the full suite passes.
- **SC-002**: Across all 16 skills, 0 top-level frontmatter fields are outside the specification's six, and 0 `metadata` values parse as anything other than a string.
- **SC-003**: Every one of the 16 descriptions states what the skill does and contains a sentence beginning "Use when", and the validator fails a seeded description without one.
- **SC-004**: 0 handoff sentences and 0 `metadata.usage` values in any skill prescribe a `/`, `$`, or plugin-namespaced invocation.
- **SC-005**: For each specification rule the validator enforces, one seeded violation makes validation fail with an error that names the rule and the field.
- **SC-006**: A strict YAML parse of every skill's frontmatter yields the same values that highway-help prints for that skill.
- **SC-007**: The harness tests pass, and a second regeneration of every generated file changes nothing.

## Assumptions

- The Agent Skills specification at agentskills.io, as published today, is the version this phase conforms to. Its rules on `name`, `description`, `compatibility`, `metadata`, and the defined fields are the ones listed in FR-009.
- No Highway skill has a real environment requirement beyond what any coding agent provides (reading and writing files in the person's repository), so every skill drops `compatibility`.
- The validator's limits become the specification's: `description` up to 1,024 characters, instead of Highway's 500, and no minimum beyond non-empty.
- `skills-ref` is not a declared tool, so the suite does not run it. The bash validator implements the same checks, using the added YAML parser for the frontmatter.
- The plan chooses the YAML parser. Python's standard library has no YAML parser, so the candidates include a standalone parser such as `yq` or a parser on the harness's existing Node toolchain. The framework no longer ships, so the parser is a development dependency, not one a person installing Highway needs.
- Highway's other frontmatter readers (the index generator, highway-help's index, the cache key) read the same values as the parser. The plan decides whether they call the parser or keep their line readers behind the validator's guarantee.
- The `## When to use` section stays in each skill's body. It may repeat the "when to use" part of the description in more detail.
- Highway's own rules that add to the specification stay: required body sections and `metadata.version` as a semantic version. The closed word list is the one addition retired.
- Agents that support Agent Skills load skills by `name` and `description`, so changing the text of a description, usage line, or handoff changes no behavior a person relies on.
- `allowed-tools` is not part of this phase, per the decision recorded in `standard-alignment.md`.
- Skill versions take MINOR bumps, never MAJOR, and there is no backward compatibility to preserve, because Highway is unreleased.
