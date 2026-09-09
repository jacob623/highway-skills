# Research: Shared Output Templates

## Decision: Route frontmatter as an Experience rule

**Decision**: Treat the requirement that retained file artifacts include frontmatter as Layer 2 and assign it the planned `X1.5` identifier.

**Rationale**: The routing test assigns rules constraining files emitted at runtime to the Experience Standard. `P` governs the text of `SKILL.md`; `D` governs development records and build process. Existing `X1.1` and `X1.2` govern declared output shape and conformance but do not require frontmatter, so the new obligation is additive rather than a restatement.

**Alternatives considered**:
- Add it to `P`: rejected because that would constrain authoring text rather than the produced file.
- Add it to `D`: rejected because the rule must apply to users running skills, not only maintainers building Highway.
- Leave it as an edge-case note: rejected because it would not be a testable governance requirement.

## Decision: Route template citation as an Authoring rule

**Decision**: Treat the requirement that a file-emitting skill cite a complete shared output template as Layer 1 and assign it the planned `P9.1` identifier.

**Rationale**: The obligation constrains what a skill author writes in the `Outputs` section. It is a citation discipline, not a runtime judgment about user-owned record values. `X1.1` and `X1.2` remain responsible for the emitted shape and its conformance.

**Alternatives considered**:
- Add a second `X` rule for template citation: rejected because citation is a property of `SKILL.md`, while `X` governs emitted output.
- Put the citation rule in the Development Constitution: rejected because it would not ship to skill authors or govern skills outside the repository.

## Decision: Keep drift validation agent-checkable

**Decision**: Add the planned `D8.1` rule as `[agent-checkable]`, requiring re-validation of every skill citing a changed shared library artifact.

**Rationale**: Determining whether a runtime output still matches a changed template requires semantic comparison of complete frontmatter and body structure. A static proxy would under-detect and would repeat the false automation pattern corrected by Features 013 and 014.

**Alternatives considered**:
- Mark `D8.1` `[auto]`: rejected because no current check can decide semantic output-shape equivalence honestly.
- Omit drift validation: rejected because the shared template would become a new single source of truth without a stated dependent-review obligation.

## Decision: Separate output skeletons from the existing questionnaire template

**Decision**: Store complete output skeletons under `.highway/library/templates/output/`; leave `requirements-inquiry.md` in its existing directory and role.

**Rationale**: The existing file is a question-content template, not a generated-file skeleton. A dedicated subdirectory makes the distinction visible and prevents a future validator or author from treating the two template classes as interchangeable.

**Alternatives considered**:
- Keep all templates flat: rejected because the directory would mix different contracts.
- Move or rename `requirements-inquiry.md`: rejected because it would create unrelated catalog and adapter churn.

## Decision: Preserve existing output contracts

**Decision**: Extract the currently declared NFR and Control structures without changing their fields, ordering, body sections, ownership, or user-provided values.

**Rationale**: The feature is a governance and consistency change, not a redesign of user-owned artifacts. The templates define form only; they do not prescribe the semantic content of NFRs or Controls.

**Alternatives considered**:
- Improve the record schemas during extraction: rejected because it would turn a consistency feature into a contract change and could require a MAJOR amendment.
- Validate user record values against Highway prose rules: rejected by the Layer 3 containment boundary.

## Implementation Decisions Confirmed

- The P9.1 static check applies only after Markdown links are removed from the Outputs-section
	scan, so a skill mentioning a documentation link is not mistaken for a file emitter.
- Nested output templates are included by `.highway/tools/generate-library-catalog.sh`; the
	catalog generator now discovers sorted Markdown files recursively under each library type.
- D8.1 is enforced through documented agent review and focused citer/contract tests, not by a
	false automatic semantic comparison of runtime output.
