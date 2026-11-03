# Feature Specification: Codify Config Skill

**Feature Branch**: `207-codify-config-skill`

**Created**: 2026-11-03

**Status**: Draft

**Input**: User description: "Relocate codify-platforms to the person's library/coding-standards folder and add When to use and When not to use columns. Add When to use, When not to use, and Inherits From columns to coding-standards.md, which covers languages and the platforms that use them. highway-codify uses these fields when building a proposal; a platform standard takes precedence over a language standard, and inherited standards are included. highway-implementation leaves the new platform fields empty and offers to configure the platform. Create a new highway-codify-config skill that takes over configure from highway-codify (the code catalog view stays in highway-codify, per Clarifications) and presents three options: View or Update Platforms, View or Update Coding Standards, and Resolve Codify Conflicts, each with proposals that show Consequences and Conflicts."

## Clarifications

### Session 2026-11-03

- Q: Where does the code catalog view (the list of recent automations) live? → A: It stays in `highway-codify` as `/highway-codify catalog`. Only `configure` moves to `highway-codify-config`.
- Q: When a file matches both a platform standard and a language standard, how should codify know which one is the platform? → A: Codify does not decide silently. Each proposal task gets a **Standards** field: an ordered list of the coding standards that match that task. The model proposes it, platform standards before the language standards they build on and inherited standards included, and the person can correct it. The same field is in the saved automation record.
- Q: Should a conflict count only when two entries match word for word, or also when Highway judges they mean the same thing? → A: Highway judges meaning. Each conflict quotes both overlapping entries so the person can see why it was flagged.
- Q: When adding a platform sends the person to onboarding, how should they get back to finish the platform proposal? → A: Onboarding, when it started from codify config, closes with "Run `/highway-codify-config [Platform]` to finish adding [Platform]." Running that opens option 1 at that platform's proposal.
- Q: When Highway proposes a new coding standard, should the proposal also say whether files written under it need tests? → A: Yes. The standard proposal shows **Tests:** after **Coding Standards:**, either "required" with one sentence on how tests are written, or "not required". Highway proposes the value from best practices, and the person can correct it.
- Q: When the person removes a coding standard in option 2, should Highway delete its standard file too, or only remove its catalog row? → A: Remove only the catalog row and keep the file. The removal proposal's Consequences say the file remains and is no longer used, and standards that inherit from it are listed as conflicts.
- Q: When onboarding adds a platform that can start automation, should it also ask whether to configure that platform? → A: Yes. Onboarding asks "Would you like to configure [Platform] for automation?" each time it adds a platform, only when that platform can execute automation. Yes is collected without leaving onboarding, and onboarding's close gives "Run `/highway-codify-config [Platform]`" for each platform the person chose to configure.
- Q: How should the two catalogs store the When to use, When not to use, and Inherits From lists? → A: Keep one table per catalog. Each list sits in its cell, with entries separated by semicolons, and an empty list is left blank.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Open one place to configure codify (Priority: P1)

The person runs `/highway-codify-config` and sees one question with three choices: view or update platforms, view or update coding standards, and resolve codify conflicts. Picking a choice opens it. Canceling anywhere returns to this menu.

**Why this priority**: Every other story starts here. Today, platform changes sit inside `highway-codify`, and coding standards have no managed path at all.

**Independent Test**: Run `/highway-codify-config`. The heading "How would you like to configure Highway Codify?" appears with the three numbered choices in order. Pick 1, then cancel. The menu appears again.

**Acceptance Scenarios**:

1. **Given** a Highway project, **When** the person runs `/highway-codify-config`, **Then** it shows "### How would you like to configure Highway Codify?" followed by:
   1. **View or Update Platforms** highway considers for automation and self-service.
   2. **View or Update Coding Standards** highway uses for coding.
   3. **Resolve Codify Conflicts** so highway can provide more accurate and consistent proposals.
2. **Given** the menu, **When** the person picks an option, **Then** the reply begins with one consequence sentence about what that option can change, and then opens that option.
3. **Given** any option or proposal, **When** the person says to cancel, **Then** nothing is written and the menu appears again.
4. **Given** `highway-codify`, **When** the person runs it, **Then** it no longer offers a `configure` path, and it points to `/highway-codify-config` wherever it used to point to `/highway-codify configure`.
5. **Given** `highway-codify`, **When** the person runs `/highway-codify catalog`, **Then** the code catalog view works as before.

---

### User Story 2 - Add or update a platform with guidance on when to use it (Priority: P1)

The person picks View or Update Platforms. The platform catalog is shown, and they are asked what they would add, correct, or remove. To add a platform, it must already be an accepted implementation. If it isn't, Highway offers onboarding and returns afterward. Highway proposes the platform's row, including When to use and When not to use lists grounded in the platform and the rest of the catalog, followed by Consequences and Conflicts. Accepting writes the row.

**Why this priority**: When to use and When not to use are what let codify pick the right platform consistently. Without them, every proposal falls back to the first row.

**Independent Test**: With Cursor and GitHub Actions as accepted implementations and GitHub Actions already in the catalog, add Cursor. The proposal shows **Platform:**, **Implementation:**, ordered When to use and When not to use lists, **Consequences:**, and **Conflicts:**. Accept it. The catalog has a Cursor row with both lists.

**Acceptance Scenarios**:

1. **Given** the person picks option 1, **When** it opens, **Then** each catalog row is shown by platform title, and the person is asked **What would you add, correct, or remove?**
2. **Given** the person names a platform to add that is not an accepted implementation, **When** Highway checks, **Then** it says the platform is not in the implementation catalog and asks whether they would like to onboard it.
3. **Given** they choose to onboard, **When** onboarding accepts the implementation, **Then** onboarding's close ends with "Run `/highway-codify-config [Platform]` to finish adding [Platform]."
4. **Given** the person runs `/highway-codify-config` with the title of an accepted implementation, **When** the skill opens, **Then** it skips the menu and shows option 1's proposal for that platform: an add proposal when it is not listed, or an update proposal when it is.
5. **Given** an accepted implementation to add, or a listed platform to update, **When** the proposal appears, **Then** every catalog field appears as a bold label followed by a colon and its value. When to use and When not to use appear as ordered lists under their bold headings.
6. **Given** an update, **When** the proposal appears, **Then** it starts from the platform's current catalog values.
7. **Given** any platform proposal, **When** it appears, **Then** it includes **Consequences:**, a list of bold consequences each followed by a description, and **Conflicts:**, an ordered list of bold conflicts with existing platforms, each followed by a description and a recommendation.
8. **Given** conflicts exist, **When** the proposal ends, **Then** it says the person may accept with the conflicts and that Highway can help resolve them after acceptance.
9. **Given** any platform proposal, **When** it ends, **Then** it asks **What would you add or correct?** followed by "If you'd like to cancel, just say so."
10. **Given** the person accepts, **When** the write succeeds, **Then** the catalog has that row with its fields, and no other row changes.
11. **Given** the person accepted with conflicts, **When** the write succeeds, **Then** Highway asks whether they would like help resolving the conflicts. Yes opens option 3.
12. **Given** the accepted platform works with code or configuration files a coding standard could cover, **When** the write succeeds, **Then** Highway asks whether they would like to configure coding standards for it. Yes opens option 2.
13. **Given** the person names a listed platform to remove, **When** they accept the removal, **Then** that row is dropped, and no other row changes.

---

### User Story 3 - Add or update a coding standard with guidance and inheritance (Priority: P1)

The person picks View or Update Coding Standards. The coding standards catalog is shown, and they are asked what they would add, correct, or remove. For a language such as Java or YAML, or a platform such as Kubernetes or Terraform, Highway proposes its coding standard: at most ten rules from best practices when none exists, or the current standard when it does. The proposal also shows When to use, When not to use, Consequences, and Conflicts. Accepting writes the standard file and the catalog row.

**Why this priority**: Codify reads these standards for every file it writes. Platform standards that inherit from language standards let one organization keep several patterns consistent.

**Independent Test**: With a YAML standard listed, add Kubernetes inheriting from YAML. The proposal shows **Coding Standards:** with at most ten rules, **Tests:**, ordered When to use and When not to use lists, **Inherits From:** YAML Coding Standard, **Consequences:**, and **Conflicts:**. Accept it. A Kubernetes standard file exists in `library/coding-standards/`, and the catalog has its row.

**Acceptance Scenarios**:

1. **Given** the person picks option 2, **When** it opens, **Then** each catalog row is shown by Standard Title, and the person is asked **What would you add, correct, or remove?**
2. **Given** a language or platform with no standard, **When** the proposal appears, **Then** **Coding Standards:** lists at most ten rules drawn from that technology's best practices, followed by **Tests:** with "required" and one sentence on how tests are written, or "not required".
3. **Given** a listed standard to update, **When** the proposal appears, **Then** **Coding Standards:** shows the current rules, and When to use, When not to use, and Inherits From show the current catalog values.
4. **Given** any standard proposal, **When** it appears, **Then** it shows **When to use:** and **When not to use:** as ordered lists grounded in that technology's best practices and the rest of the catalog, followed by **Consequences:** and **Conflicts:** in the same form as platform proposals.
5. **Given** conflicts exist, **When** the proposal ends, **Then** it says the person may accept with the conflicts and that Highway can help resolve them after acceptance.
6. **Given** any standard proposal, **When** it ends, **Then** it asks **What would you add or correct?** followed by "If you'd like to cancel, just say so."
7. **Given** the person accepts, **When** the write succeeds, **Then** the standard file is written in `library/coding-standards/` first, the catalog row is written second, and no other row changes.
8. **Given** the person accepted with conflicts, **When** the write succeeds, **Then** Highway asks whether they would like help resolving them. Yes opens option 3.
9. **Given** the person names a listed standard to remove, **When** the removal proposal appears, **Then** its Consequences say the standard file remains and is no longer used, and its Conflicts list every standard that inherits from it.
10. **Given** the person accepts a removal, **When** the write succeeds, **Then** only that catalog row is removed, and the standard file is unchanged.

---

### User Story 4 - Resolve conflicts so proposals are consistent (Priority: P2)

The person picks Resolve Codify Conflicts. Highway assesses the platforms and coding standards for conflicts and lists each one with a recommendation. The person picks a conflict, and Highway proposes the exact record changes that resolve it. Accepting writes those changes and returns to the list.

**Why this priority**: Overlapping guidance makes codify choose differently from one run to the next. This option removes that drift. It follows stories 2 and 3 because it needs populated catalogs.

**Independent Test**: Give GitHub Actions and Jenkins the same When to use entry. Open option 3. The overlap appears as a numbered bold conflict with a description and a recommendation. Pick it. The proposal lists each record to change, in bold, with lettered changes under it. Accept it. The catalogs change, and the list no longer shows that conflict.

**Acceptance Scenarios**:

1. **Given** the person picks option 3, **When** the assessment finds conflicts, **Then** each appears as an ordered list item: the conflict in bold, followed by a description and a recommendation for consistent results.
2. **Given** two entries that overlap in meaning but not in wording, such as "Deploy containers on merge" and "Container deployment after merge", **When** the assessment runs, **Then** it reports the conflict and quotes both entries with the records they come from.
3. **Given** that list, **When** it ends, **Then** it asks **Which conflict would you like to resolve?** followed by "If you'd like to cancel, just say so."
4. **Given** no conflict is found, **When** the assessment ends, **Then** Highway says so and asks the person to describe inconsistencies they have noticed in proposals. Their description is assessed again.
5. **Given** the person picks a conflict, **When** the proposal appears, **Then** it is an ordered list of the records that will change. Each record's Standard Title or Platform appears in bold, followed by a line break and a lettered list (a, b, c) of its changes.
6. **Given** that proposal, **When** it ends, **Then** it asks **What would you add or correct?** followed by "If you'd like to cancel, just say so."
7. **Given** the person accepts, **When** the write succeeds, **Then** only those records change, and the conflict list appears again, reassessed.

---

### User Story 5 - Codify proposals use the guidance (Priority: P1)

When `highway-codify` builds a proposal, it chooses the Provider using each platform's When to use and When not to use. Each task in the proposal shows **Standards**, an ordered list of the coding standards that match that task. Codify proposes the list from file patterns, When to use, When not to use, and Inherits From: platform standards come before the language standards they build on, and every inherited standard is included. The person can correct the list like any other proposal field. The accepted list is saved with the automation and decides how each file is written.

**Why this priority**: This is the payoff. The configured guidance changes what codify proposes and how it writes code.

**Independent Test**: With GitHub Actions configured for "build and deploy on merge" and Cursor configured for "store and content changes", propose a Shopify product update. Cursor is the Provider. With Kubernetes inheriting from YAML, a task that writes `deployment.yaml` shows **Standards:** with Kubernetes Coding Standard first and YAML Coding Standard second. Correct the task to remove YAML. The saved record shows only Kubernetes for that task.

**Acceptance Scenarios**:

1. **Given** the person names a platform, **When** codify proposes, **Then** that platform is the Provider, as before.
2. **Given** no platform is named, **When** codify proposes, **Then** the Provider is the platform whose When to use fits the action and whose When not to use does not. When several fit, the earlier row wins. When none fits, the existing fallback applies.
3. **Given** a platform whose When not to use matches the action, **When** codify proposes, **Then** that platform is not chosen unless the person named it.
4. **Given** any proposal, **When** it is shown, **Then** each task shows **Standards:** as an ordered list of matching coding standard titles, or "No coding standard applies."
5. **Given** a task matched by a platform standard and the language standard it builds on, **When** codify proposes, **Then** the platform standard is listed first and the language standard after it.
6. **Given** a proposed standard inherits from others, directly or through a chain, **When** codify proposes, **Then** each inherited standard is in the list once, after the standard that inherits it.
7. **Given** a standard whose When not to use matches the task, **When** codify proposes, **Then** that standard is left out of the list.
8. **Given** the person adds, removes, or reorders a task's standards, **When** codify re-emits the proposal, **Then** it begins with one consequence sentence and shows the corrected list.
9. **Given** the person accepts, **When** the record is written, **Then** each task's accepted **Standards** list is saved in the automation record.
10. **Given** coding starts, **When** a task's file is written, **Then** it follows every standard in that task's accepted list. Where they disagree, the earlier standard wins.

---

### User Story 6 - New platforms from implementations wait for configuration (Priority: P2)

When an accepted implementation can start automation, `highway-implementation` or `highway-onboarding` adds its catalog row with When to use and When not to use left blank, and asks "Would you like to configure [Platform] for automation?" From `highway-implementation`, yes directs them to `/highway-codify-config [Platform]`. From onboarding, yes is collected and the pointer appears at onboarding's close.

**Why this priority**: The row still makes the platform available. Configuring it is what makes codify choose it consistently.

**Independent Test**: Accept an implementation of Cursor. The catalog gains a Cursor row with blank When to use and When not to use. Highway asks "Would you like to configure Cursor for automation?" Say yes, then run `/highway-codify-config Cursor`. Option 1 opens with the Cursor update proposal.

**Acceptance Scenarios**:

1. **Given** an accepted implementation that can start automation, **When** it is included, **Then** its row has blank When to use and When not to use cells.
2. **Given** that inclusion, **When** Highway reports it, **Then** it asks whether the person would like to configure the platform for automation.
3. **Given** they say yes, **When** Highway continues, **Then** it directs them to run `/highway-codify-config [Platform]`, which opens that platform's update proposal.
4. **Given** they say no, **When** Highway continues, **Then** the row stays with empty fields and the implementation close continues.
5. **Given** onboarding adds a platform that can execute automation, **When** it reports the inclusion, **Then** it asks "Would you like to configure [Platform] for automation?" and continues onboarding after the answer.
6. **Given** onboarding writes an implementation that cannot execute automation, **When** it continues, **Then** it adds no row and asks nothing.
7. **Given** the person said yes for one or more platforms during onboarding, **When** onboarding closes, **Then** it gives "Run `/highway-codify-config [Platform]`" once for each of those platforms.

---

### Edge Cases

- The platform catalog or coding standards catalog is absent. Option 1 or 2 says nothing is listed yet and still asks what to add. The first accepted proposal creates the file.
- A platform catalog still exists in the old knowledge location. It is not read or moved. Backward compatibility is not required.
- A platform to add is already listed. Highway says it is already included and offers the update proposal instead.
- A platform or standard to remove or correct is not listed. Highway says it is not listed and writes nothing.
- An Inherits From title names no listed standard. That is a conflict, and the proposal still shows it.
- Inheritance forms a cycle. That is a conflict. Codify lists each standard in the cycle once.
- The person adds a standard title that is not in the coding standards catalog to a task. Codify says it is not listed, keeps the rest of the list, and points to `/highway-codify-config` option 2.
- A platform has empty When to use and When not to use. Codify does not choose it by fit. It can still be named, and it can still be the fallback.
- The person declines onboarding when adding a platform that is not an accepted implementation. Nothing is written, and option 1 asks again.
- The standard file write fails. The catalog row is not written, and existing files are unchanged.
- `/highway-codify-config` names a platform that is not an accepted implementation. Option 1 opens at the add check, says it is not in the implementation catalog, and offers onboarding.
- A removed standard's file stays in `library/coding-standards/` with no catalog row. Adding that standard again reuses the file as the current standard for an update proposal.
- A conflict proposal would change a record that has since been removed. Highway reassesses and shows the current list.

## Requirements *(mandatory)*

### Functional Requirements

**Catalogs**

- **FR-001**: The platform catalog MUST live at `library/coding-standards/codify-platforms.md`. Every skill that reads or writes it MUST use that path.
- **FR-002**: Each platform row MUST have Platform, Implementation ID, When to use, and When not to use.
- **FR-003**: Each coding standards row MUST have its existing fields plus When to use, When not to use, and Inherits From, a list of Standard Titles.
- **FR-004**: The coding standards catalog MUST accept both languages, such as Java or YAML, and platforms, such as Kubernetes or Terraform. The language or platform name appears in Standard Title.
- **FR-004a**: Each catalog MUST be one table. When to use, When not to use, and Inherits From MUST hold their entries in one cell, separated by semicolons. An empty list MUST be a blank cell. Proposals MUST show these lists as ordered lists.

**highway-codify-config**

- **FR-005**: A new skill, `highway-codify-config`, MUST open with the heading "How would you like to configure Highway Codify?" and the three options, in the order and wording of User Story 1.
- **FR-006**: The `configure` path MUST move from `highway-codify` to `highway-codify-config`. `highway-codify` MUST point to `/highway-codify-config` wherever it pointed to `/highway-codify configure`.
- **FR-007**: Picking an option, and every change to a proposal, MUST begin with one consequence sentence.
- **FR-008**: Options 1 and 2 MUST show their catalog and ask **What would you add, correct, or remove?**
- **FR-009**: Adding a platform MUST require an accepted implementation of it. Otherwise, Highway MUST say it is not in the implementation catalog and offer onboarding. Onboarding started this way MUST close with "Run `/highway-codify-config [Platform]` to finish adding [Platform]." Onboarding started any other way MUST NOT show that line.
- **FR-009a**: `/highway-codify-config` invoked with an accepted implementation title MUST skip the menu and open option 1's add or update proposal for that platform.
- **FR-010**: A platform proposal MUST show every catalog field as a bold label, a colon, and its value. When to use and When not to use MUST be ordered lists grounded in the platform and the existing catalog. An update MUST start from the current values.
- **FR-011**: A standard proposal MUST begin with **Coding Standards:** listing at most ten rules from best practices when no standard exists, or the current rules when one does. It MUST then show **Tests:**, either "required" with one sentence on how tests are written, or "not required", proposed from best practices or taken from the current standard. It MUST then show When to use, When not to use, and Inherits From. The accepted Tests value MUST be written to the standard file in the form codify reads.
- **FR-012**: Every platform and standard proposal MUST include **Consequences:** (each consequence bold, then a description) and **Conflicts:** (each conflict bold, then a description and a recommendation). When conflicts exist, it MUST say the proposal can be accepted with them and resolved afterward.
- **FR-013**: Every proposal in the skill MUST end with **What would you add or correct?** followed by "If you'd like to cancel, just say so." Cancel MUST write nothing and return to the menu.
- **FR-014**: Accepting a platform proposal MUST write only that row. Accepting a standard proposal MUST write the standard file in `library/coding-standards/` first and then its catalog row. Accepting a standard removal MUST remove only its catalog row and MUST NOT delete or change the standard file.
- **FR-015**: After an accepted proposal with conflicts, Highway MUST offer to help resolve them. Yes opens option 3.
- **FR-016**: After an accepted platform that works with code or configuration files, Highway MUST offer to configure coding standards for it. Yes opens option 2.
- **FR-017**: Option 3 MUST list conflicts as ordered bold items with a description and a recommendation, and ask **Which conflict would you like to resolve?** Overlap MUST be judged by meaning, not exact wording, and each overlap conflict MUST quote both entries and name the records they come from. The same rule applies to the Conflicts list in platform and standard proposals. With no conflict, it MUST say so and ask the person to describe inconsistencies they have noticed, then assess again.
- **FR-018**: A conflict proposal MUST list each record to change in bold with lettered changes beneath it. Accepting MUST write only those changes and then show the reassessed conflict list.
- **FR-019**: The code catalog view MUST stay in `highway-codify` as `/highway-codify catalog`, unchanged by this feature.

**highway-codify**

- **FR-020**: When no platform is named, the Provider MUST be the earliest platform whose When to use fits the action and whose When not to use does not. When none fits, the existing fallback order MUST apply. A named platform MUST remain the Provider.
- **FR-021**: Each proposal task MUST show **Standards:**, an ordered list of the coding standard titles that match it, or "No coding standard applies." Codify MUST propose the list from file patterns, When to use, When not to use, and Inherits From. It MUST leave out a standard whose When not to use matches the task. It MUST list a platform standard before the language standards it builds on, and each inherited standard once, after the standard that inherits it, even in a cycle.
- **FR-022**: The person MUST be able to add, remove, or reorder a task's standards as a proposal correction. The accepted list MUST be saved per task in the automation record, and the record template MUST include the field. When coding, each file MUST follow every standard in its task's accepted list, and the earlier standard MUST win a disagreement.

**highway-implementation**

- **FR-023**: Including a platform MUST leave When to use and When not to use blank and ask "Would you like to configure [Platform] for automation?" Yes MUST direct them to run `/highway-codify-config [Platform]`, which opens option 1's update proposal for that platform.

**highway-onboarding**

- **FR-024**: When onboarding adds a platform that can execute automation, it MUST ask "Would you like to configure [Platform] for automation?" It MUST NOT ask for an implementation that cannot execute automation. An answer MUST NOT stop or redirect onboarding.
- **FR-025**: Onboarding's close MUST give "Run `/highway-codify-config [Platform]`" once for each platform the person chose to configure during that run.

### Key Entities

- **Platform catalog**: `library/coding-standards/codify-platforms.md`. One row per platform that can start automation, with Platform, Implementation ID, When to use, and When not to use.
- **Coding standards catalog**: `library/coding-standards/coding-standards.md`. One row per language or platform standard, with Standard Title, Technology, File Patterns, Summary, When to use, When not to use, Inherits From, and Standard Path.
- **Coding standard**: A file in `library/coding-standards/` with at most ten rules for one language or platform.
- **Conflict**: A situation in which the catalogs cannot pick exactly one platform for an action, or one standard for a file, or in which a record contradicts itself or names a missing standard.
- **Consequence**: One bold effect of a proposal on future codify proposals or coding, followed by a description.
- **Task standards**: The ordered list of coding standard titles on one proposal task, saved with the automation record. The first standard wins a disagreement.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The person reaches any of the three configuration options in 1 step from `/highway-codify-config`.
- **SC-002**: With platforms configured so exactly one fits an action, the same action proposed 3 times names the same Provider 3 times.
- **SC-003**: 100% of proposal tasks show a **Standards** list. When a platform standard and its language standard both match, the platform standard is listed first, and a correction by the person is saved exactly as accepted.
- **SC-004**: Every platform and standard proposal shows both a Consequences list and a Conflicts list, 100% of the time.
- **SC-005**: Accepting a conflict resolution removes that conflict from the reassessed list.
- **SC-006**: A platform added from an implementation has 0 When to use entries and 0 When not to use entries until the person configures it.
- **SC-007**: Canceling at any step writes 0 files.

## Assumptions

- "codify-standards.md" in the request means `library/coding-standards/coding-standards.md`.
- Every platform row comes from an accepted implementation. The `own` source and the Source column are removed, because adding a platform now requires an accepted implementation.
- A coding standard file keeps today's shape: Scope, Rules, and Tests. Its Tests section holds the accepted **Tests:** value, so codify's existing test-task rule keeps working.
- A conflict is any of the following, with overlap judged by meaning: two platforms whose When to use entries overlap; an entry whose meaning appears in both When to use and When not to use of one record; two standards whose file patterns overlap, neither inheriting from the other, with overlapping When to use; an Inherits From title that names no listed standard; or an inheritance cycle.
- A platform "works with code or configuration files" when its interface reads or runs files a coding standard could cover, such as pipeline definitions, manifests, or Terraform.
- Returning from onboarding uses the platform title the person gave. Onboarding changes in two ways: the configure question for each platform that can execute automation, and the closing lines for the platforms the person chose to configure or for a run started from codify config.
- The coding standards catalog gains an output template so the skill can write it the same way each time.
- Existing tests that pin `/highway-codify configure`, the old platform path, or the Source column are amended with recorded reasons.
- Backward compatibility is not required. Existing catalogs are not migrated.
