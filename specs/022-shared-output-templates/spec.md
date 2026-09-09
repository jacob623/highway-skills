# Feature Specification: Shared Output Templates

**Feature Branch**: `022-shared-output-templates`

**Created**: 2026-09-09

**Status**: Draft

**Input**: User description: "/speckit.specify \"I want every Highway skill that emits a file to cite a shared template covering that file's full structure -- frontmatter and body alike, not frontmatter alone -- rather than restate that structure in its own prose, so two skills emitting the same kind of record cannot silently diverge in either part. Verified 2026-09-09: highway-nfrs and highway-controls currently declare near-identical output on both counts -- frontmatter of id, title, status, plus a cross-reference array, and a body of a statement followed by a rationale -- but only because both were authored together, and nothing requires either alignment to hold. Before writing rule text I checked for a collision with the Experience Standard's X1.1 and X1.2, which already require a skill to declare its output shape, whole-file, and to follow it: a cited template is one way of declaring a shape, so neither needs amending, and this stays a single new P rule about citation discipline rather than a new X rule -- the same shape as P7.3 and D1.3/D1.4, which require citing rather than restating. Add P9.1 to the Highway Skills Constitution at .highway/governance/constitution.md, in a new Principle IX: a skill that emits a file MUST cite a template rather than restate the file's structure, observable as the Outputs section naming a path under .highway/library/templates/output/ in place of describing frontmatter fields or body sections directly, tagged [auto]. Add D8.1 to the Development Constitution at .specify/memory/constitution.md generalized to shared library artifacts rather than named for templates specifically, because requirements-inquiry.md is already such an artifact: a change to a shared library artifact MUST be followed by re-validation of every skill that cites it, observable as each citing skill being re-checked and its emitted output still matching in both frontmatter and body, tagged [agent-checkable]. Create .highway/library/templates/output/nfr-record.md and .highway/library/templates/output/control-record.md as complete skeletons -- frontmatter block and body section structure together -- holding exactly what both skills already declare. Update highway-nfrs and highway-controls to cite their template paths from Outputs instead of restating frontmatter or body structure, bump each skill's version as a PATCH since the emitted output does not change, and regenerate the catalog and adapters. Verify before enabling P9.1 that both skills conform once the citation is added, and record both amendments in their respective Sync Impact Reports. Do not govern the user's record content; govern only its declared structure.\""

**Clarification recorded 2026-09-09**: In addition to P9.1 and D8.1, the retained-file portion of
the request is governed by the newly added X1.5 Experience rule. X1.5 requires frontmatter on
retained file artifacts and excludes transient messages; it does not change the template citation
or user-owned record semantics.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Author a Consistent File-Emitting Skill (Priority: P1)

As a Highway skill author, I want a shared output template to define the complete structure of a file my skill emits, so that the frontmatter and body remain consistent with other skills producing the same kind of record.

**Why this priority**: Shared structure is the primary user value and prevents divergence at the point where new skills are authored.

**Independent Test**: Inspect a file-emitting skill's Outputs section and its cited template, then confirm the template defines both frontmatter and body structure and the skill does not independently restate that structure.

**Acceptance Scenarios**:

1. **Given** a skill emits a file with frontmatter and a Markdown body, **When** its Outputs section is reviewed, **Then** it cites a template under `.highway/library/templates/output/` that defines both parts of the file.
2. **Given** a skill cites a complete output template, **When** its Outputs section is validated, **Then** no separate inline frontmatter field list or body-section contract is used as the output definition.

### User Story 2 - Preserve Existing Output Contracts (Priority: P1)

As a user of `highway-nfrs` or `highway-controls`, I want the template migration to preserve the files those skills produce, so that the consistency improvement does not change my governance artifacts.

**Why this priority**: Existing user-owned artifacts must not change as a side effect of adopting shared templates.

**Independent Test**: Compare each skill's declared output before and after the migration and confirm the template contains the same frontmatter fields and body sections.

**Acceptance Scenarios**:

1. **Given** the current NFR output contract, **When** `nfr-record.md` is introduced, **Then** it contains the existing NFR frontmatter and body structure without imposing values on user-authored content.
2. **Given** the current Control output contract, **When** `control-record.md` is introduced, **Then** it contains the existing Control frontmatter and body structure without imposing values on user-authored content.

### User Story 3 - Detect Shared Template Drift (Priority: P2)

As a Highway maintainer, I want changes to a shared library artifact to trigger re-validation of every skill that cites it, so that a template change cannot silently invalidate a dependent skill's declared output.

**Why this priority**: Drift detection protects the shared contract after the initial migration and limits the cost of future changes.

**Independent Test**: Change a shared output template in a controlled fixture, identify every citing skill, and confirm each dependent skill is re-validated and any mismatch is reported.

**Acceptance Scenarios**:

1. **Given** a shared output template has changed, **When** the dependent skills are re-validated, **Then** every skill citing that template is included in the review.
2. **Given** a changed template no longer matches a citing skill's declared output, **When** the re-validation is performed, **Then** the mismatch is reported rather than silently accepted.

### Edge Cases

- A skill emits a retained file artifact: the artifact MUST include frontmatter, and its complete structure remains template-governed. This requirement applies to files retained after the skill completes, not to transient messages or other non-file output.
- A skill emits multiple file types: each distinct output structure requires its own cited template, and one template must not be assumed to cover unrelated files.
- The existing `requirements-inquiry.md` remains a question-content template and is not reclassified as an output-file skeleton.
- A template contains placeholders for user-owned values: validation checks the presence and arrangement of the declared structure, not the semantic quality or value of the user's content.
- A template is changed but no skill cites it: the change does not create a dependent skill review, but the template remains subject to normal library validation.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Highway Skills Constitution MUST define a Layer 1 rule requiring every skill that emits a file to cite a shared template for that file's complete structure instead of restating the structure in the skill's own output prose.
- **FR-002**: The new authoring rule MUST be identified as `P9.1`, placed under a new Principle IX, marked `[auto]`, and include an observable based on the Outputs section citing a path under `.highway/library/templates/output/`.
- **FR-003**: The Development Constitution MUST define a Layer 0 rule identified as `D8.1` requiring re-validation of every skill that cites a changed shared library artifact.
- **FR-004**: `D8.1` MUST be marked `[agent-checkable]` and its observable MUST require checking dependent skills' complete emitted output, including frontmatter and body, after a shared artifact changes.
- **FR-005**: The shared output-template area MUST be located at `.highway/library/templates/output/` and MUST remain distinct from the existing question-content template at `.highway/library/templates/requirements-inquiry.md`.
- **FR-006**: The feature MUST provide a complete NFR output template containing the existing NFR frontmatter and body structure, without prescribing user-owned NFR values.
- **FR-007**: The feature MUST provide a complete Control output template containing the existing Control frontmatter and body structure, without prescribing user-owned Control values.
- **FR-008**: `highway-nfrs` MUST cite its complete output template from its Outputs section and MUST NOT independently restate the template's frontmatter or body structure there.
- **FR-009**: `highway-controls` MUST cite its complete output template from its Outputs section and MUST NOT independently restate the template's frontmatter or body structure there.
- **FR-010**: The existing emitted output contracts of `highway-nfrs` and `highway-controls` MUST remain unchanged in fields, ordering, and body sections after the migration.
- **FR-011**: Both affected skills MUST receive PATCH version updates, and their generated catalog and adapter artifacts MUST be regenerated to match the source skills.
- **FR-012**: The Skills Constitution and Development Constitution amendments MUST each record their new rule, version change, and self-application review in the applicable Sync Impact Report.
- **FR-013**: The feature MUST verify that both affected skills conform to `P9.1` before enabling the rule, and MUST classify the amendment as MINOR only if no previously conforming skill is invalidated after the migration.
- **FR-014**: The feature MUST NOT impose semantic requirements on the values users place in NFR or Control records; it governs only the declared output structure.
- **FR-015**: The Experience Standard MUST define an `X1.5` rule requiring every retained file artifact emitted by a skill to include frontmatter, while excluding transient messages and other non-file output.

### Key Entities

- **Output template**: A shared, complete file skeleton that declares the frontmatter and body structure of one emitted file type.
- **Citing skill**: A Highway skill whose Outputs section names and relies on a shared output template.
- **Emitted output contract**: The declared fields, ordering, and body sections a skill promises to produce.
- **User-owned record**: An NFR or Control file whose values and policy meaning belong to the user's workspace, not to Highway's governance.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of current Highway skills that emit files cite a complete output template under `.highway/library/templates/output/` after the feature is enabled.
- **SC-002**: 100% of the two existing affected skills, `highway-nfrs` and `highway-controls`, pass the new output-template rule before it is enabled.
- **SC-003**: A controlled change to a shared output template identifies and re-validates 100% of the skills that cite it, with no dependent skill silently omitted.
- **SC-004**: The generated outputs of both affected skills retain 100% of their pre-migration frontmatter fields and body sections.
- **SC-005**: The output-template adoption introduces zero new requirements about the semantic content of user-owned NFR or Control records.
- **SC-006**: The specification, plan, and task records identify the template location, the two affected skills, the two governance rules, and the drift-validation obligation consistently.
- **SC-007**: 100% of retained file artifacts emitted by the affected skills include frontmatter, while transient non-file messages remain outside the requirement.

## Assumptions

- The existing `highway-nfrs` and `highway-controls` output descriptions accurately represent their current emitted structures and are the baseline for the templates.
- A complete template may use placeholders to represent user-owned values; placeholders do not become mandated content values.
- The new P rule can be decided mechanically from the skill's Outputs section and cited template path, while semantic emitted-output matching remains agent-checkable under D8.1.
- The frontmatter requirement is a Layer 2 Experience rule because it constrains retained runtime file artifacts, not the authoring text of a skill or the development process.
- The feature is a MINOR governance amendment only after the existing output contracts are preserved and both skills pass the new rule.
- The generated catalog and agent adapters are derived artifacts and are updated after the source skill changes.
- The feature does not change the ownership, location, or semantics of user-authored NFR and Control records.
