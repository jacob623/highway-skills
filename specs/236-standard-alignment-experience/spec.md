# Feature Specification: Standard Alignment highway-experience

**Feature Branch**: `feature/std-alignment-phase7`

**Created**: 2026-11-11

**Status**: Complete

**Input**: User description: "create a new spec to implement phase 7 of standard-alignment.md". Phase 7 (highway-experience) gives every skill Highway's identity, output standard, and storage rules through one new skill, highway-experience, and removes the always-on instructions. highway-experience holds `references/highway-identity.md`, `references/experience-standard.md`, and `references/storage-contract.md`, with a description written for its supporting role and a short Highway summary when invoked directly. The storage contract splits: its fixed rules go to highway-experience, and the mode becomes a project record, where no record means Local. The contract separates reading a skill's own bundled files, and activating highway-experience, from the four repository operations. Every skill activates highway-experience by name as its first step and drops its paths into `.highway/governance/` and `.highway/library/knowledge/highway-identity.md`. The always-on instructions' two own rules move into highway-experience's `SKILL.md`, and the always-on instructions, `generate-instructions.sh`, `.instruction-manifest`, and the four generated files are removed. A harness invariant checks that highway-experience loads before a skill's first output. Exit: no skill reads `.highway/governance/`, no always-on file exists, and the full suite and harness pass.

## Clarifications

### Session 2026-11-11

- Q: Does the Highway Skills Constitution gain a rule that every Highway skill activates highway-experience first, checked by the validator, or only follow the new locations? → A: Only follow the new locations, a MINOR amendment from 10.1.0 to 10.2.0. A bash test and the harness invariant enforce the activation step.
- Q: How should each Highway skill word its step that activates highway-experience? → A: One identical sentence as the first step of the Procedure in every skill, which the bash test matches exactly.
- Q: What does a skill do when the project's storage record names a mode other than Local? → A: It stops before any other repository read or write, says the recorded mode is not supported yet, and names Local as the supported mode.
- Q: How do the versions of the skills that gain the activation step change? → A: MINOR for each of the 15 existing skills. Highway is unreleased through the remaining phases and the rollout, so nothing depends on the old arrangement and no change is treated as breaking.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Every skill gets Highway's guidance from highway-experience (Priority: P1)

A person runs any Highway skill. Before the skill shows them anything, it activates highway-experience, which gives the agent Highway's identity, the output standard, and the storage rules. The person sees the same kind of output as before, but the guidance now travels with the skills rather than coming from files in the project or from always-on instructions the agent may not load.

**Why this priority**: This is the phase's purpose. Under the Agent Skills and Agent Plugins standards, a skill may rely only on its own folder, the other Highway skills, and the project. The identity, output standard, and storage rules currently sit in the project's `.highway/` folder and reach the agent through always-on files that the plugin cannot ship.

**Independent Test**: Read each Highway skill's `SKILL.md` for its first step and its references; list highway-experience's folder; run the harness scenarios and check the order in which skills load.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer lists `skills/highway-experience/`, **Then** it holds `SKILL.md` and `references/highway-identity.md`, `references/experience-standard.md`, and `references/storage-contract.md`.
2. **Given** the Highway Identity and the Experience Standard, **When** each is compared with its reference in highway-experience, **Then** the content is the same, apart from any path that named an old location.
3. **Given** any other Highway skill, **When** a maintainer reads its `SKILL.md`, **Then** the first step of its Procedure is the same activation sentence as in every other Highway skill, naming highway-experience, before any output the person sees, and it names no path under `.highway/governance/` and not `.highway/library/knowledge/highway-identity.md`.
4. **Given** highway-experience's `SKILL.md`, **When** a maintainer reads it, **Then** it is short, says when to read each reference, and states the two rules the always-on instructions carried: when a Highway skill applies, defer the workflow, artifacts, inputs, outputs, and decisions to that skill; and do not treat Highway identity or experience guidance as organizational facts.
5. **Given** highway-experience's description, **When** an agent decides whether to activate it for a request, **Then** the description says it holds Highway's identity and output standard and is loaded by the other Highway skills, so an unrelated request does not activate it.
6. **Given** a person invokes highway-experience directly, **When** it runs, **Then** it gives a short summary of what Highway is and nothing else.
7. **Given** a harness run of any Highway scenario, **When** the run is checked, **Then** highway-experience was activated before the first output the person saw, and a run where it was not fails that check.

---

### User Story 2 - The storage rules ship with the skills and the mode belongs to the project (Priority: P1)

A skill reads and writes the project through the same four operations as before. The rules for those operations, the paths rule, and what a skill does not do now come from highway-experience, so they are the same for every project and update with the skills. The project's choice of mode is a project record, and a project with no record uses Local, the only supported mode.

**Why this priority**: The storage contract governs every read and write of the project (P2.6). It must keep working, unchanged in effect, when it stops being a project file.

**Independent Test**: Read highway-experience's storage contract and compare its operations, modes, paths rule, and prohibitions with today's `storage.md`; run a skill in a project with no storage record; run the storage-contract check.

**Acceptance Scenarios**:

1. **Given** highway-experience's `references/storage-contract.md`, **When** a maintainer reads it, **Then** it holds the four operations, what each does in each mode, the paths rule, and what a skill does not do, with the same meaning as today's `storage.md`.
2. **Given** the storage contract, **When** a maintainer reads it, **Then** it states that a skill reading its own bundled files, and a skill activating highway-experience, are not repository operations, and that the four operations still govern every read and write of the project.
3. **Given** the storage contract, **When** a maintainer reads how the mode is chosen, **Then** it names the project record `library/knowledge/storage.md` as where the mode is kept, and states that a project with no record uses Local.
4. **Given** a project with no storage record, **When** any Highway skill runs, **Then** it reads and writes the project in Local mode, as it does today.
5. **Given** a project whose storage record names a mode other than Local, **When** any Highway skill runs, **Then** it makes no other repository read or write, says the recorded mode is not supported yet, and names Local as the supported mode.
6. **Given** the Highway Skills Constitution, **When** a maintainer reads P2.6 and the other text that names the storage contract or the Experience Standard, **Then** it names them as references of highway-experience, not as files under `.highway/governance/`.
7. **Given** the skill validator, **When** it checks a skill against the Experience Standard's rules, **Then** it reads them from highway-experience's reference and reports the same findings as before.

---

### User Story 3 - The always-on instructions are gone (Priority: P1)

A maintainer finds no always-on instruction source, no instruction generator, and none of the four generated files: `AGENTS.md`, `.cursor/rules/highway-agent-context.mdc`, `.claude/CLAUDE.md`, and `.github/copilot-instructions.md`. A user's project built from the distribution has none of them either. Every skill behaves the same whether or not those files exist, because each skill gets what they said from highway-experience.

**Why this priority**: Agent Plugins 1.0 has no portable rules or instructions. While skills depend on always-on files, the plugin in Phase 14 cannot carry Highway.

**Independent Test**: List the repository and a built distribution for the instruction source and the four generated files; search the scripts, tests, harness, and live documents for them; run the full suite.

**Acceptance Scenarios**:

1. **Given** the repository after this change, **When** a maintainer looks for `.highway/instructions/`, `framework/generate-instructions.sh`, `framework/.instruction-manifest`, `AGENTS.md`, `.cursor/rules/highway-agent-context.mdc`, `.claude/CLAUDE.md`, or `.github/copilot-instructions.md`, **Then** none exists.
2. **Given** the distribution built after this change, **When** a user lists it, **Then** it holds no always-on instruction file, and it holds highway-experience with its references wherever it holds the other skills and their agent copies.
3. **Given** the scripts, tests, harness, development constitution, and live documents, **When** they are searched for the instruction generator, its manifest, the instruction source, or the four generated files, **Then** none names them as a part of Highway, and the tests that existed only to check them are removed.
4. **Given** `.highway/` after this change, **When** a maintainer lists it, **Then** `governance/` and `instructions/` are gone, and `library/knowledge/` no longer holds `highway-identity.md`.

---

### User Story 4 - The repository's checks follow the new owner (Priority: P2)

A maintainer who changes an identity, output, or storage rule edits one file in highway-experience, and the suite, the harness selection, and the validator all follow it. The paths helper names the three references, the harness selects every scenario when one of them changes, highway-experience gets its catalog entry and agent copies like any skill, and the generators and checks stop expecting `.highway/governance/` and the instruction outputs.

**Why this priority**: Without this, the move leaves stale checks behind or breaks the suite. It ranks below the behavior itself because it follows from it.

**Independent Test**: Regenerate every generated artifact, run the full suite and the harness tests, and run the harness path map on each reference.

**Acceptance Scenarios**:

1. **Given** the paths helper, **When** a maintainer reads it, **Then** the Experience Standard, the storage contract, and the Highway Identity resolve to highway-experience's references, and it declares no governance or instructions folder.
2. **Given** the harness path map, **When** one of highway-experience's references or its `SKILL.md` changes, **Then** it selects the smoke set, because every skill loads them.
3. **Given** highway-experience, **When** the generators run, **Then** it has a catalog entry, an agent copy in each declared agent tree, and the manifest rows every skill has, and highway-help lists it like any other skill.
4. **Given** the development constitution, **When** a maintainer reads it, **Then** no definition, declared generator, Enforcement Map row, or gate names `.highway/governance/`, the instruction generator, or its outputs, and the amendment and its self-application review are recorded.

---

### Edge Cases

- highway-help names none of the three files today; it received them through the always-on instructions. It still activates highway-experience first, like every other Highway skill.
- highway-experience is a Highway skill and must not activate itself. Its own first step is to read the reference it needs.
- A person asks for highway-experience directly. It gives the short summary and does not start a workflow or write anything.
- An agent that loads skills only on request may not load highway-experience on its own. The activating skill names it, so an agent that supports activation by name loads it; the harness invariant catches an agent or scenario where it did not.
- A project has a `library/knowledge/storage.md` that names a mode other than Local. Only Local is supported, so the skill stops before any other repository read or write, says the recorded mode is not supported yet, and names Local as the supported mode. It does not fall back to Local, which would write to the working tree against the person's choice.
- This repository's own `AGENTS.md` and `.cursor/rules/highway-agent-context.mdc` are generated outputs and are removed with the rest. Agents working on this repository lose that always-on context, which Phase 3 accepted.
- The validator's cache key covers the Experience Standard. Moving it changes the key once, so every skill revalidates on the first run after the move.
- Specs under `specs/` name the old locations as history and do not change.
- `rollout-plan.md` stays gitignored and excluded in the distribution manifest.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A new skill, highway-experience, MUST exist at `skills/highway-experience/` with `SKILL.md` and `references/highway-identity.md`, `references/experience-standard.md`, and `references/storage-contract.md`, and MUST pass the skill validator.
- **FR-002**: `.highway/library/knowledge/highway-identity.md` and `.highway/governance/experience-standard.md` MUST move to highway-experience's references with their content unchanged apart from paths that name a moved file.
- **FR-003**: highway-experience's `SKILL.md` MUST stay short, say when to read each reference, and state the always-on instructions' two own rules: defer the workflow, artifacts, inputs, outputs, and decisions to the Highway skill that applies; and do not treat Highway identity or experience guidance as organizational facts.
- **FR-004**: highway-experience's description MUST say that it holds Highway's identity and output standard and is loaded by the other Highway skills. Invoked directly, it MUST give a short summary of what Highway is and MUST NOT start a workflow or write a file.
- **FR-005**: `references/storage-contract.md` MUST hold the four operations, what each does in each mode, the paths rule, and what a skill does not do, with the same effect as today's `.highway/governance/storage.md`, apart from the storage record rules in FR-007.
- **FR-006**: The storage contract MUST state that reading a skill's own bundled files and activating highway-experience are not repository operations, and that the four operations govern every read and write of the project.
- **FR-007**: The storage contract MUST name `library/knowledge/storage.md` as the project record of the mode, and MUST state that a project with no record uses Local. When the record names a mode other than Local, the contract MUST direct the skill to stop before any other repository read or write, say the recorded mode is not supported yet, and name Local as the supported mode. `.highway/governance/storage.md` MUST NOT remain.
- **FR-008**: The first step of every other Highway skill's Procedure MUST be one activation sentence, identical in every skill, that activates highway-experience by name before any output the person sees. A skill MUST NOT name a path under `.highway/governance/` or `.highway/library/knowledge/highway-identity.md`. Each of these skills' versions MUST increment MINOR. A bash test MUST fail when a Highway skill other than highway-experience lacks that exact sentence as its first Procedure step or names one of these paths.
- **FR-009**: The always-on instruction source (`.highway/instructions/`), `framework/generate-instructions.sh`, `framework/.instruction-manifest`, and the four generated files (`AGENTS.md`, `.cursor/rules/highway-agent-context.mdc`, `.claude/CLAUDE.md`, `.github/copilot-instructions.md`) MUST be removed, with the tests that only check them. Scripts, tests, harness files, and live documents MUST NOT reference them as part of Highway.
- **FR-010**: The harness MUST check, for every Highway scenario run, that highway-experience was activated before the first output the person sees, and MUST fail the run when it was not. The check MUST have a test that proves it can fail.
- **FR-011**: The paths helper MUST resolve the Experience Standard, the storage contract, and the Highway Identity to highway-experience's references, and MUST NOT declare a governance or instructions folder. The validator MUST read the Experience Standard's rules from there and report the same findings for every skill and fixture as before.
- **FR-012**: The harness selection MUST select the smoke set when highway-experience's `SKILL.md` or any of its references changes, and MUST stop listing the removed files.
- **FR-013**: highway-experience MUST receive the generated artifacts every skill has: a catalog entry, an agent copy in each declared agent tree, and its adapter and distribution manifest rows. Regenerating every generated artifact MUST then leave no diff.
- **FR-014**: The distribution MUST ship highway-experience with its references wherever it ships the other skills, and MUST NOT ship `.highway/governance/`, `.highway/instructions/`, or any always-on instruction file.
- **FR-015**: The Highway Skills Constitution MUST name the storage contract and the Experience Standard as highway-experience's references wherever it names them, including P2.6, P10.1, and the Highway Identity note, and MUST record the amendment in its Sync Impact Report. The constitution gains no activation rule: the amendment only follows the new locations and is MINOR, 10.1.0 to 10.2.0. The bash test in FR-008 and the harness invariant in FR-010 enforce the activation step instead of the validator.
- **FR-016**: The development constitution MUST stop naming `.highway/governance/`, the instruction generator, and its outputs in its Definitions, declared generators, Enforcement Map, and gates, as a MINOR amendment (3.2.0 to 3.3.0) recorded with its self-application review.
- **FR-017**: Live documents MUST describe the new arrangement in the same change: `README.md`, `framework/README.md`, `framework/authoring-standard.md`, `harness/README.md`, `governance-plan.md`, and `standard-alignment.md`, which also marks Phase 7 complete.
- **FR-018**: Content edits to existing skills MUST be limited to the activation step, removing the old paths, and the version change. Other skill behavior MUST NOT change.
- **FR-019**: The full bash suite and the harness TypeScript tests MUST pass before the first edit and after the last.

### Key Entities

- **highway-experience**: a supporting Highway skill holding Highway's identity, the output standard, and the storage rules, loaded by every other Highway skill before its first output.
- **Highway Identity** (`references/highway-identity.md`): non-normative context on what Highway is and why it exists.
- **Experience Standard** (`references/experience-standard.md`): the rules for user-visible output, read by agents at runtime and by the validator as the X rules.
- **Storage contract** (`references/storage-contract.md`): the fixed rules for reaching the project: four operations, modes, paths rule, and prohibitions.
- **Storage record** (`library/knowledge/storage.md` in a project): the project's choice of mode; absent means Local.
- **Activation step**: one sentence, identical in every Highway skill other than highway-experience, that is the first step of its Procedure and activates highway-experience by name.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 15 of 15 existing Highway skills activate highway-experience as their first step, and 0 skills name a path under `.highway/governance/` or the Highway Identity's old path.
- **SC-002**: highway-experience holds exactly 3 references, and the Highway Identity and Experience Standard references match their previous content apart from paths.
- **SC-003**: 0 always-on instruction files, instruction generators, or instruction manifests exist in the repository or in a built distribution, and `.highway/governance/` and `.highway/instructions/` do not exist.
- **SC-004**: The validator reports the same verdict for every skill and fixture as before the move, apart from the version changes.
- **SC-005**: In a harness run, every Highway scenario shows highway-experience activated before the first output, and a seeded run without it fails the check.
- **SC-006**: Regenerating every generated artifact produces 0 changed files, and the full bash suite and the harness TypeScript tests pass.

## Assumptions

- highway-setup does not write the storage record in this phase. Phase 8 puts its skeleton in highway-setup's `assets/` and seeds it; until then every project has no record and uses Local, which is the only supported mode, so behavior is unchanged.
- "Activate by name" is plain text naming the `highway-experience` skill. Phase 12 settles how handoff text names a skill across agents.
- highway-experience follows the current skill format (the frontmatter fields and eight body sections the validator requires). Phase 12 aligns every skill, including this one, with the Agent Skills specification.
- Other Highway skills read highway-experience's references only through activation, never by a path into its folder, because a path into another skill's folder is not portable.
- The distribution keeps placing skills under `.highway/skills/` until Phase 14, so highway-experience ships at `.highway/skills/highway-experience/` with its agent copies.
- `.highway/catalog/` and `.highway/library/` stay until later phases empty them.
- Highway is unreleased through the remaining phases and `rollout-plan.md`, so there is no backward compatibility to keep: no migration, no handling of projects made by an earlier arrangement, and no change counted as breaking.
- Historical specs keep the old paths.
- Nothing is committed until the maintainer asks.
