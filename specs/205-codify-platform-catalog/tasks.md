---

description: "Task list for the codify platform catalog"
---

# Tasks: Codify Platform Catalog

**Input**: Design documents from `/specs/205-codify-platform-catalog/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/platform-catalog.md, contracts/configure.md, contracts/provider-diagram.md, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before the skill edits.

**Organization**: Tasks are grouped by user story so each story can be checked on its own.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

---

## Phase 1: Setup

**Purpose**: Confirm a green suite before any edit (D3.1)

- [X] T001 Run `bash .highway/tools/tests/run-all.sh > /tmp/205-baseline.txt 2>&1; echo "EXIT:$?" >> /tmp/205-baseline.txt` in the background with all permissions, wait for it, then copy the `Summary:` and `EXIT:` lines into specs/205-codify-platform-catalog/baseline.txt. Stop if any test fails

---

## Phase 2: Foundational

**Purpose**: The failing test and the catalog shape every story relies on

- [X] T002 Create .highway/tools/tests/codify-platform-catalog.test.sh (mode 644) in the house style: `# Instrument class: static-document-contract`, `# Artifact classes: source-document`, and `# Seeded failure probe:` header lines, then `require` and `reject` helpers using `grep -Fq`. Assert in `.highway/library/templates/output/codify-platforms.md`: require `| Platform | Implementation ID | Source |` and `version: 1.0.0`. Assert in `.highway/skills/highway-implementation/SKILL.md`: require `### platforms`, `is included as a platform that can start automation. To remove it, run /highway-codify configure.`, `library/knowledge/codify-platforms.md`, `an agent that starts the work`, and `version: 6.0.0`. Assert in `.highway/skills/highway-onboarding/SKILL.md`: require `` follow `platforms` in `highway-implementation` `` and `version: 8.0.0`. Assert in `.highway/skills/highway-codify/SKILL.md`: require `### configure`, `` When the invocation is the word `configure` ``, `is not included as a platform that can start automation. To add it, run /highway-codify configure.`, `A platform that can start automation is needed. Run /highway-codify configure.`, `Every task names that same Provider`, `Do not replace the Provider`, `P -->|[Next action]|`, and `version: 5.0.0`; reject `The executor and each provider are the person`, `Do not invent a means that no accepted architecture describes.`, and `T1 -->|[Next action]|`. Assert in `.highway/library/templates/output/codify-record.md`: require `P -->|<next action>|` and `version: 4.0.0`; reject `T1 -->|<next action>|`. Assert in `.highway/library/templates/output/codify-tasks.md`: require `The Provider is the first node` and `version: 2.0.1`. End with `PASS: codify platform catalog, provider, and diagram`
- [X] T003 Run `bash .highway/tools/tests/codify-platform-catalog.test.sh > specs/205-codify-platform-catalog/probe-fail.txt 2>&1; echo "EXIT:$?" >> specs/205-codify-platform-catalog/probe-fail.txt` and confirm it fails with FAIL lines and a nonzero exit (D3.6)
- [X] T004 Create .highway/library/templates/output/codify-platforms.md at `version: 1.0.0`, following the frontmatter and section shape of .highway/library/templates/output/assessment-findings.md. Body: a `# Codify Platforms` heading and the table `| Platform | Implementation ID | Source |`. Explain each column per specs/205-codify-platform-catalog/data-model.md: Source is `implementation` or `own`, an `own` row has Implementation ID `None`, one row per Implementation ID, rows stay in the order they were added, and the first row is the default Provider. Say the file lists platforms that can start automation and is not a roster of every implementation

**Checkpoint**: The new test fails only on skill and template strings

---

## Phase 3: User Story 1 - Include a platform that can start automation (Priority: P1)

**Goal**: Accepting an implementation that can start automation writes one catalog row and says it is included. A target is not included

**Independent Test**: Read `platforms` in highway-implementation. Cursor as an agent that starts the work is included with the two sentences. Shopify is not. Opening a record does not enter `platforms`

- [X] T005 [US1] In .highway/skills/highway-implementation/SKILL.md, add `### platforms` between `write` and `close` per specs/205-codify-platform-catalog/contracts/platform-catalog.md. Read Technology Choice, Runtime Components, and Realized By. Include a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, or an agent that starts the work. A store, a newsletter, a records product, or a backup is not included, says nothing, and goes to `close`. Write `library/knowledge/codify-platforms.md` from `.highway/library/templates/output/codify-platforms.md`, creating `library/knowledge/` when absent. Keep one row per Implementation ID, replacing that row on a second inclusion, and leave other rows unchanged. Then emit `**[Platform] is included as a platform that can start automation. To remove it, run /highway-codify configure.**` and go to `close`
- [X] T006 [US1] In .highway/skills/highway-implementation/SKILL.md, route to `platforms`: `write` success goes to `platforms` instead of `close`, and the reuse bullet in `identifier` goes to `platforms` instead of `close`. Add `library/knowledge/codify-platforms.md` and the new template to Inputs, and the catalog row to Outputs. Opening, listing, and declining do not enter `platforms`
- [X] T007 [US1] In .highway/skills/highway-onboarding/SKILL.md, after the implementation exists in `orchestrate`, add: follow `platforms` in `highway-implementation`, and emit the same two sentences when a platform is included. Keep "Do not create a technology, platform, provider, or application inventory." and add one sentence that this catalog is not that inventory. Do not emit the implementation proposal or its questions. Add the catalog and template to Inputs and Outputs

**Checkpoint**: Inclusion text is present in both skills

---

## Phase 4: User Story 2 - Change the catalog from codify (Priority: P1)

**Goal**: `/highway-codify configure` shows the catalog and asks what to add, correct, or remove

**Independent Test**: Read `configure` in highway-codify. It runs before an implementation is chosen, shows each row, asks the question, and writes only the catalog

- [X] T008 [US2] In `Entry` of .highway/skills/highway-codify/SKILL.md, add a first case after the project-root check: `` When the invocation is the word `configure`, go to `configure`. `` It runs before resuming an open task and before matching an implementation title. Update the Procedure order sentence and `When to use` to name `/highway-codify configure`
- [X] T009 [US2] Add `### configure` to .highway/skills/highway-codify/SKILL.md per specs/205-codify-platform-catalog/contracts/configure.md. Show one numbered line per row, labeled by platform and by whether it came from an implementation or the person, never by id. An empty or absent file says nothing is included yet. Ask `**What would you add, correct, or remove?**` and handle add, add of a present name, remove, remove or correct of an absent name, correct, `decline`, and `unknown`. Write the whole file or nothing. Do not start `choose`, `suggest`, `start`, or `code`
- [X] T010 [US2] In .highway/skills/highway-codify/SKILL.md, add `library/knowledge/codify-platforms.md` and `.highway/library/templates/output/codify-platforms.md` to Inputs, and the updated catalog after configure to Outputs. Replace the when-not-to-use sentence `Do not invent a means that no accepted architecture describes.` with one that forbids changing the catalog anywhere except `configure`

**Checkpoint**: Configure is reachable and does not start an automation

---

## Phase 5: User Story 3 - Use an included platform for a different implementation (Priority: P1)

**Goal**: One Provider executes every task, and the diagram is a logical flow from that Provider

**Independent Test**: Read `start`, `align`, `propose`, and the record template. A Shopify proposal with Cursor included names Cursor on every task, and both diagram arrows leave Cursor

- [X] T011 [US3] In `start` of .highway/skills/highway-codify/SKILL.md, replace the executor bullet and the sentence `The executor and each provider are the person, or something the accepted architecture or the implementation names in Realized By, Technology Choice, or Runtime Components.` with the Provider rules in specs/205-codify-platform-catalog/contracts/provider-diagram.md: one Provider for the whole automation, `Every task names that same Provider`, the implementation being automated is a target, and the selection order (named platform, this implementation when it has a row, the first row, otherwise unset). Add the not-included sentence and the empty-catalog sentence
- [X] T012 [US3] In `align` of .highway/skills/highway-codify/SKILL.md, change the correction sentence to correct the method, library, module, or pattern and add `Do not replace the Provider.` Keep the existing failure line and return to `suggest`
- [X] T013 [US3] In `propose` of .highway/skills/highway-codify/SKILL.md, rewrite the diagram sentence: the diagram starts at the Provider, each task is one arrow from the Provider to that task's target in task order, and no target performs the next action. Change the block to `P["[Provider]"] -->|[First action]| T1["[First target]"]` and `P -->|[Next action]| T2["[Next target]"]`. Change the Provider placeholder to `[The platform executing this automation.]`. In the `edit` bullet, a Provider change sets that platform on every task and in the diagram, then goes to `align`. In `accept`, stay on `propose` while the Provider is unset
- [X] T014 [US3] In `code` of .highway/skills/highway-codify/SKILL.md, say the README Use part follows the interface of the Provider. Keep `[Executor]` and `executor/` for the Provider's files. In `write`, say the executor's files are the Provider's files
- [X] T015 [P] [US3] In .highway/library/templates/output/codify-record.md, change the Diagram Block to `P["<provider>"] -->|<first action>| T1["<first target>"]` and `P -->|<next action>| T2["<next target>"]`. Rewrite its explanation: the first node is the Provider, each task is one arrow from the Provider to its target, and no arrow leaves a target. Change the task Provider placeholder to `<the platform executing this automation>`. Bump `version: 3.0.0` to `version: 4.0.0`
- [X] T016 [P] [US3] In .highway/library/templates/output/codify-tasks.md, replace `The executor is the first node of the accepted diagram.` with `The Provider is the first node of the accepted diagram, and its files are the executor's files.` Bump `version: 2.0.0` to `version: 2.0.1`

**Checkpoint**: `bash .highway/tools/tests/codify-platform-catalog.test.sh` passes once Polish T017 sets the skill versions

---

## Phase 6: Polish and Cross-Cutting Concerns

- [X] T017 Bump `version: 5.0.0` to `version: 6.0.0` in .highway/skills/highway-implementation/SKILL.md, `version: 4.0.0` to `version: 5.0.0` in .highway/skills/highway-codify/SKILL.md, and `version: 7.0.0` to `version: 8.0.0` in .highway/skills/highway-onboarding/SKILL.md
- [X] T018 In .highway/tools/tests/record-purpose-titles.test.sh, change the highway-implementation pin from `version: 5.0.0` to `version: 6.0.0`. Leave the highway-architecture pin unchanged. Record the reason in specs/205-codify-platform-catalog/research.md under a D3.5 note: the implementation skill gained a MAJOR change in this feature, and the title assertions are unchanged
- [X] T019 Add Verification bullets to .highway/skills/highway-implementation/SKILL.md (inclusion and the two sentences, no row for a target, opening writes nothing), .highway/skills/highway-codify/SKILL.md (configure, one Provider on every task, diagram from the Provider, align keeps the Provider, empty catalog), and .highway/skills/highway-onboarding/SKILL.md (same inclusion, no question)
- [X] T020 Run `bash .highway/tools/tests/codify-platform-catalog.test.sh` and `bash .highway/tools/tests/record-purpose-titles.test.sh` and confirm both print PASS
- [X] T021 Measure the word count of each changed `###` section in .highway/skills/highway-implementation/SKILL.md, .highway/skills/highway-codify/SKILL.md, and .highway/skills/highway-onboarding/SKILL.md, and confirm each is at or under 400 words (P7.5). Split a section that exceeds it. Confirm 12 or fewer MUST rules per skill (P7.4)
- [X] T022 With all permissions, run `bash .highway/tools/validate-skill.sh` on .highway/skills/highway-implementation, .highway/skills/highway-codify, and .highway/skills/highway-onboarding (D8.1), and `bash .highway/tools/validate-library.sh` on .highway/library/templates/output/codify-platforms.md, .highway/library/templates/output/codify-record.md, and .highway/library/templates/output/codify-tasks.md
- [X] T023 With all permissions, run `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh` (D4.5–D4.7)
- [X] T024 Confirm no changed shipped file under .highway/ references `.specify/` or `specs/` (D1.1, D1.2)
- [X] T025 Run `bash .highway/tools/tests/run-all.sh` in the background with all permissions, wait for it, and confirm `0 failed` and `EXIT:0` (D3.2)
- [X] T026 Walk the manual scenarios in specs/205-codify-platform-catalog/quickstart.md against the skill text

---

## Dependencies and Execution Order

### Phase Dependencies

- Setup runs first
- Foundational depends on Setup. T003 depends on T002. T004 follows T003
- US1, US2, and US3 depend on Foundational
- Polish depends on all stories

### User Story Dependencies

- US1 edits highway-implementation and highway-onboarding. It is independent of US2 and US3
- US2 and US3 both edit highway-codify, so US3's skill tasks follow US2
- T015 and T016 edit templates only and can run beside US2

### Parallel Opportunities

- US1 can run beside US2, because they edit different skills
- T015 and T016 edit different templates
- Do not parallelize two tasks that edit the same skill

---

## Parallel Example: User Story 1 beside User Story 2

```text
Task: "T005–T007 Inclusion in .highway/skills/highway-implementation/SKILL.md and .highway/skills/highway-onboarding/SKILL.md"
Task: "T008–T010 Configure in .highway/skills/highway-codify/SKILL.md"
Task: "T015 Diagram block in .highway/library/templates/output/codify-record.md"
Task: "T016 Provider sentence in .highway/library/templates/output/codify-tasks.md"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and read `platforms`. Cursor is included with the two sentences, and Shopify is not

### Incremental Delivery

1. User Story 1 writes the catalog when an implementation can start automation
2. User Story 2 lets the person add, correct, or remove rows from `/highway-codify configure`
3. User Story 3 makes the catalog platform the Provider on every task and draws the diagram from it
4. Polish bumps versions, amends one version pin, validates, regenerates, and requires a green suite

The new test passes only after all three stories and the version bumps.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- `[Executor]` and `executor/` stay, so the spec 203 assertions keep passing
- Existing implementations are not scanned and saved automations are not rewritten
- Do not commit unless asked
