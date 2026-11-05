# Feature Specification: Codify Products

**Feature Branch**: `212-codify-products`

**Created**: 2026-11-04

**Status**: Draft

**Input**: User description: "Make codify product-oriented. A CDY is a friendly product folder the person can copy into a git repo, with feature records at .highway/features/001-<action>. The product catalog and an integrations catalog decide join or start without opening product files. A feature is listed only when a later decision needs it. Accepting a proposal writes any integration it includes. The proposal shows Proposed project and a plain-language Rationale that cites a rule only when one changed the decision. A coding standard read before the proposal can replace the base decision. The person can change the proposal. Existing CDY folders need not be preserved."

## Clarifications

### Session 2026-11-04

- Q: When both sides of a composition already have their own product folders, which folder should the proposal join? → A: Join the folder of the implementation being codified, and leave the other folder in place. The person can change the proposal.
- Q: Should the new skill text explain the product model in prose? → A: No. Additions are ordered imperative steps. A decision that does not fit an existing step is its own step.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A product folder can become a repo (Priority: P1)

The person accepts a new product. Highway writes a folder named from the product title, not from the CDY. The product files and the README sit at the folder root. The CDY is stored once. Each accepted action gets the next numbered feature directory. Copying the folder is enough to start a git repo later.

**Why this priority**: The folder is the product. Every later decision writes into this shape.

**Independent Test**: Accept a new product whose title is Worker and whose action is Establish the worker. The folder is `code/worker/`. `.highway/metadata.md` holds the CDY. The feature files are `code/worker/.highway/features/001-establish-the-worker/codify.md` and `codify-tasks.md`. The README and product files are at `code/worker/`.

**Acceptance Scenarios**:

1. **Given** a new product, **When** the person accepts it, **Then** the folder name comes from the product title, contains no CDY, and is unique among catalog paths, including removed rows.
2. **Given** that acceptance, **When** the folder is written, **Then** `.highway/metadata.md` exists once and its frontmatter holds the CDY.
3. **Given** the first action in that product, **When** it is written, **Then** its records are `001-<action>/codify.md` and `001-<action>/codify-tasks.md` under `.highway/features/`.
4. **Given** a product that already has feature `001`, **When** a new action is accepted, **Then** the next directory is `002-<action>` and `001` is left in place.
5. **Given** an open feature, **When** the person returns to it, **Then** that feature is resumed and no new directory is written.
6. **Given** the product files, **When** they are written, **Then** their paths are relative to the product folder, and the README is at the folder root.

---

### User Story 2 - The catalogs decide without opening the product (Priority: P1)

Highway decides whether to join or start from the product catalog and the integrations catalog. It does not open product files, feature directories, or vendor documentation to make that decision. A feature is added to the product catalog only when a later decision would change without it.

**Why this priority**: A proposal has to stay sound when there are hundreds of features. The catalog is the index.

**Independent Test**: With two accepted products and several finished features that changed nothing a later decision uses, ask for a new action. Highway names join or start from the catalog rows alone. The finished features are absent from the Features cell. The open feature, if any, is present.

**Acceptance Scenarios**:

1. **Given** the product catalog, **When** a product is accepted, **Then** it is one row with ID, Folder, Title, Summary, Implementations, Features, and Status.
2. **Given** a feature that starts the product, adds an implementation, records an integration, or changes the summary, **When** it is accepted, **Then** the Features cell gains `001-<action> | one sentence`.
3. **Given** a finished feature that did none of those, **When** the catalog is written, **Then** that feature is not in the Features cell.
4. **Given** an open feature, **When** the catalog is written, **Then** that feature stays in the Features cell until it is finished, and leaves the cell when it is finished and did none of the decision changes above.
5. **Given** a suggestion whose title matches a recorded feature, same words, ignoring case, **When** suggestions are prepared, **Then** that suggestion is left out and the open feature is resumed when it is that feature.
6. **Given** a feature sentence or the product summary that means the same action, **When** suggestions are prepared, **Then** that suggestion is left out.
7. **Given** a summary that means the same consumer and outcome, and a new action, **When** the proposal is prepared, **Then** the suggestion is kept and the proposal joins that folder.
8. **Given** no row that fits, **When** the proposal is prepared, **Then** the proposal starts a folder named from the product title.
9. **Given** a removed row, **When** a proposal is prepared, **Then** its folder and feature titles stay taken, and it is not a candidate.

---

### User Story 3 - An accepted proposal records its integration (Priority: P1)

When the person accepts a proposal that includes an integration, that pair is written to the integrations catalog. Highway does not ask them to accept the integration again. The next proposal can use it.

**Why this priority**: The integration is how two implementations become one product, or a feature of the product that already has one of them.

**Independent Test**: Accept a proposal that connects Cursor to Shopify. The integrations catalog gains that pair. A later Cursor action proposes joining the product that serves Cursor, and Shopify is added to that product's implementations. Accept a frontend and backend pair. One folder lists both implementations.

**Acceptance Scenarios**:

1. **Given** a proposal that includes an integration, **When** the person accepts it, **Then** the integrations catalog gains one row with From, To, Kind, Summary, and Status, and no second acceptance is asked.
2. **Given** Kind `composition` and only one side has a product, **When** the proposal is prepared, **Then** it joins that folder and the product lists both implementations.
3. **Given** Kind `composition` and both sides have products, **When** the proposal is prepared, **Then** it joins the folder of the implementation being codified, that product lists both implementations, and the other folder stays in place. The person can change the proposed project.
4. **Given** Kind `composition` and neither side has a product, **When** the proposal is prepared, **Then** it starts one folder listing both implementations.
5. **Given** Kind `capability`, **When** the proposal is prepared, **Then** it joins the product that serves From and adds To to that product's implementations. The other product stays its own folder.
6. **Given** an integration row and no recorded feature for that action, **When** suggestions are prepared, **Then** the action is still suggested.
7. **Given** a suggestion, **When** integrations are considered, **Then** Highway uses accepted rows whose From is the selected implementation, and composition rows where either side is selected. It does not invent a pair from vendor documentation.

---

### User Story 4 - The person sees why, and can change the project (Priority: P1)

The proposal states whether the project is new or existing, then a rationale in plain words. When a coding standard or an integration changed the decision, the rationale cites it after the plain reason. The person can change the proposal. Highway reads the matching coding standard before the proposal, and a rule there replaces the base decision it speaks to.

**Why this priority**: Join or start is the decision the person is accepting. The reason has to be understandable, and their correction has to win.

**Independent Test**: Propose a SonataFlow action while a standard says every SonataFlow is its own project and an integration says to join Terraform. The proposal starts a folder. The rationale says, in plain words, why a separate project is the right home, then cites the standard. Change the project to the Terraform folder and accept. That folder is written.

**Acceptance Scenarios**:

1. **Given** a proposal, **When** it names the project, **Then** it shows **Proposed project:** as `New <folder>` or `Existing <folder>`, and the next line is **Rationale:**.
2. **Given** that rationale, **When** it is shown, **Then** the first sentence says in plain words why this project is the right home.
3. **Given** a coding standard or an integration that changed the base decision, **When** the rationale is shown, **Then** it cites that rule after the plain sentence.
4. **Given** no rule changed the base decision, **When** the rationale is shown, **Then** it is the plain reason alone.
5. **Given** a matching coding standard, **When** the proposal is prepared, **Then** Highway has read that standard, and a rule in it replaces the base decision it speaks to.
6. **Given** the SonataFlow standard says every SonataFlow is its own project, **When** an integration would join Terraform, **Then** the proposal starts a folder and the rationale cites that standard.
7. **Given** the person changes the project, the folder, or sets a standard rule aside, **When** they accept, **Then** their edit is written.
8. **Given** any accepted edit, **When** it is written, **Then** the folder is unique in the catalog, the CDY is in `.highway/metadata.md`, the feature record is under that folder's `.highway/features/`, and paths are relative to the folder.

---

### Edge Cases

- The suggested folder is already in the catalog, including a removed row. Highway says so, and the person names another folder.
- A folder change does not require a product-title change. A title change does not by itself rename an existing folder.
- The first feature of a product is `001`. The number is the next integer in that product.
- A removed product keeps its folder and recorded feature titles taken, and is not joined.
- Both sides of a composition already have products. The proposal joins the folder of the implementation being codified and leaves the other folder in place. The person can change the proposed project.
- A finished feature that did not change a later decision leaves the Features cell. Its directory remains.
- An integration the proposal does not include is not written.
- Vendor documentation is not a source of integration rows during a suggestion.
- Highway's own `.highway` remains the system folder. The product `.highway` holds `metadata.md` and `features/` only.
- No existing `code/CDY…/` folder is preserved or migrated.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: An accepted product MUST be a folder named from the product title, containing no CDY. The name MUST be unique among catalog paths, including removed rows. Product files and the README MUST sit at that folder's root, with paths relative to the folder.
- **FR-002**: The product MUST contain one `.highway/metadata.md` whose frontmatter holds the CDY, and feature records at `.highway/features/<number>-<action>/codify.md` and `codify-tasks.md`. The number MUST start at `001` and MUST be the next integer in that product. An open feature MUST be resumed. A new acceptance MUST add the next directory and MUST leave earlier directories in place.
- **FR-003**: The product catalog MUST have one row per product, with ID, Folder, Title, Summary, Implementations, Features, and Status. A new feature MUST update that row and MUST NOT add a row.
- **FR-004**: A feature MUST be added to the Features cell only when it starts the product, adds an implementation, records an integration, changes the summary, or is the open feature. The value MUST be `<number>-<action> | one sentence`. A finished feature that did none of the decision changes MUST leave the cell. Its directory MUST remain.
- **FR-005**: Join, start, and suggestion deduplication MUST be decided from the product catalog and the integrations catalog. Highway MUST NOT open product files or feature directories to make that decision, and MUST NOT invent an integration from vendor documentation.
- **FR-006**: A suggestion MUST be left out when a recorded feature title matches it, same words, ignoring case, or when a feature sentence or the product summary means the same action. A new action whose summary means the same consumer and outcome MUST be kept and MUST join that folder. When no row fits, the proposal MUST start a folder named from the product title.
- **FR-007**: Accepting a proposal that includes an integration MUST write one integrations row with From, To, Kind, Summary, and Status, without a second acceptance. Kind `composition` MUST join the only existing side, or start one folder listing both implementations when neither side has a product. When both sides already have products, it MUST join the folder of the implementation being codified, list both implementations on that product, and leave the other folder in place. The person can change that proposed project. Kind `capability` MUST join the product that serves From, add To to that product, and leave the other product as its own folder.
- **FR-008**: Before the proposal, Highway MUST read the matching coding standard. A rule there MUST replace the base decision it speaks to. The coding-standards catalog MUST NOT gain a field for this.
- **FR-009**: The proposal MUST show **Proposed project:** as `New <folder>` or `Existing <folder>`, then **Rationale:**. The rationale MUST begin with one plain sentence of why this project is the right home. It MUST cite a coding standard or integration only when that rule changed the base decision.
- **FR-010**: The person's edit of the proposal MUST be what is written. The written result MUST keep the folder unique, store the CDY in `.highway/metadata.md`, place the feature record under that folder's `.highway/features/`, and keep paths relative to the folder.
- **FR-011**: Removed rows MUST keep their folder and recorded feature titles taken, and MUST NOT be join candidates. Existing `code/CDY…/` folders MUST NOT be preserved or migrated.
- **FR-012**: Additions to `highway-codify` MUST be ordered imperative steps. A step says what to read, which condition applies, and what to do next. A new decision that does not fit an existing step MUST be its own step. No step MAY exceed 400 words. The skill MUST NOT add a paragraph that explains why products exist.

### Key Entities

- **Product**: One catalog row and one folder. The CDY identifies it. The folder name is what the person sees and can copy.
- **Feature**: One accepted action, stored as `001-<action>` under the product's `.highway/features/`. The catalog lists it only while a later decision needs it.
- **Integration**: An accepted pair of implementations, written because a proposal that includes it was accepted. Kind is `composition` or `capability`.
- **Rationale**: The plain reason for the proposed project, followed by a citation only when a rule changed the decision.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A new product is one folder the person can copy, with the CDY only in `.highway/metadata.md`, and the first feature at `001-<action>`.
- **SC-002**: In a catalog of at least 20 products, the join or start decision names the product and the reason without opening any product file.
- **SC-003**: A finished feature that changed no later decision is absent from the Features cell. A feature that starts a product, adds an implementation, records an integration, changes the summary, or is open is present.
- **SC-004**: Accepting one proposal that includes an integration writes exactly one integrations row, and the next matching proposal joins or starts from that row.
- **SC-005**: Every proposal shows **Proposed project:** and **Rationale:**. The rationale's first sentence is plain language. A cited standard or integration appears only when it changed the decision.
- **SC-006**: Changing the proposed project and accepting writes the folder the person named, and the four write invariants in FR-010 still hold.
- **SC-007**: Every added step is an ordered instruction, and each added step is at or under 400 words.

## Assumptions

- The current one-action `code/CDY…/` layout and its catalog columns are replaced. Nothing already written there is moved.
- The CDY remains the stable product id and is derived as it is today. It is stored in the catalog and in `metadata.md`, and it is not the folder name.
- The product catalog remains `code/code.md`. The integrations catalog is `code/integrations.md`.
- The folder suggestion is the product title in lowercase words separated by hyphens.
- `<action>` is the action title in lowercase words separated by hyphens.
- A matching coding standard is one that already applies to the technology being codified. Its text is read before the proposal. No project field is added to the coding-standards catalog.
- The person's edit wins. FR-010 names the limits on that edit.
- `highway-codify` moves from `9.0.1` to `10.0.0`. The product catalog template, the feature record, and the task list change to this shape, and `metadata.md` and the integrations catalog are new.
- Highway's own `.highway` is unchanged. A product `.highway` does not make that folder a Highway project.
- New skill text follows the existing step style: a condition, then the action. The 400-word count is the words in a step, excluding its heading.
