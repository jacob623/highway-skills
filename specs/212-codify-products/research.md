# Research: Codify Products

## R1. Where the decision lives

- **Decision**: A new `### project` step after `align` and before `layout`. It is the numbered list in [contracts/product-steps.md](contracts/product-steps.md). It is 277 words.
- **Rationale**: `suggest` is 388 words and `propose` is 392. FR-012 gives a new decision its own step and keeps every step at or under 400 words. Layout needs the folder before it places files.
- **Alternatives considered**: Put the decision in `propose`. Rejected because the two new lines would push it over 400. Put it in `codified`. Rejected because dedup and placement are different results.

## R2. What `propose` keeps

- **Decision**: `propose` keeps every diagram rule, including `No arrow leaves a target.` It emits the block, including **Proposed project:** `[From project.]` and **Rationale:** `[From project.]`, then goes to `revise`. `revise` holds the edit, accept, unknown, question, and decline lines. An edit of the proposed project is its own line there. The lines that said `Stay on propose` say `Stay on revise`.
- **Rationale**: The block is 165 words. The routing is 227. Adding the two fields leaves `propose` near 173 words, and `revise` stays under 400. Splitting keeps the diagram rule and every edit consequence.
- **Alternatives considered**: Drop `No arrow leaves a target.` Rejected. That sentence is a drawing rule, and the word limit is met by a new step.

## R3. Dedup without opening a product

- **Decision**: Replace the `codified` step that reads `codify.md` at the Automation Path. A recorded feature title that matches, same words, ignoring case, leaves the suggestion out. A feature sentence or the product Summary that means the same action leaves it out. Do not open a product folder. An integration row does not leave a suggestion out.
- **Rationale**: FR-005 and FR-006. The Features cell and Summary are the index.
- **Alternatives considered**: Keep opening the feature record when the words differ. Rejected because a proposal must not scan product files.

## R4. Feature cell gate

- **Decision**: On write, add `<number>-<action> | one sentence` to Features only when the feature starts the product, adds an implementation, records an integration, changes the summary, or is open. When a finished feature did none of those, remove it from the cell and keep the directory.
- **Rationale**: FR-004. The cell stays a decision index.

## R5. Integrations

- **Decision**: `code/integrations.md` has From, To, Kind, Summary, and Status. Accepting a proposal that includes a pair writes that row. When an accepted row already has the same From, To, and Kind, do not write a second row. Kind `composition` joins the only existing side, starts one folder when neither side has a product, and when both have products joins the folder of the implementation being codified and leaves the other folder. Kind `capability` joins the product that lists From and adds To.
- **Rationale**: FR-007 and the 2026-11-04 clarification. The duplicate-row case was deferred at clarify and is settled here so the catalog stays one row per pair.

## R6. Paths

- **Decision**: The product folder is `code/<folder>/`. `<folder>` is the product title in lowercase words separated by hyphens, unique among catalog paths including removed rows. Metadata is `.highway/metadata.md` with `id`. The feature files are `.highway/features/<number>-<action>/codify.md` and `codify-tasks.md`. `<number>` starts at `001` and is the next integer in that product. `<action>` is the action title in lowercase words separated by hyphens. Product files and `README.md` are at the folder root. `highway-adr` reads `code/<folder>/.highway/features/<number>-<action>/codify.md`.
- **Rationale**: FR-001, FR-002, and FR-011. The CDY stays the id derived as it is today. It is not the folder name. No old folder is moved.

## R7. Record and task templates

- **Decision**: `codify-record.md` 8.0.0 adds **Proposed project:** and **Rationale:** to the saved feature. `codify-tasks.md` 5.0.0 says the list lives in the feature directory and `Files:` paths are relative to the product folder. `codify-catalog.md` 3.0.0 uses the columns ID, Folder, Title, Summary, Implementations, Features, and Status.
- **Rationale**: The saved feature has to match the proposal the person accepted. The task list is no longer beside a `code/<id>/` record.

## R8. Replaced assertions (D3.5)

- `codify-file-layout.test.sh`, `codify-config-skill.test.sh`, `codify-platform-catalog.test.sh`, `codify-closing-guide.test.sh`, `codify-write-refactor.test.sh`, and `propose-edit-lines.test.sh`: the `highway-codify` pin moves from `version: 9.0.1` to `version: 10.0.0`. The onboarding pin in `codify-platform-catalog.test.sh` stays. Reason: MAJOR bump of codify only.
- `propose-edit-lines.test.sh`: the edit lines are read from `### revise` through `### identifier`. The first edit line says `Re-emit the proposal` and `Stay on \`revise\`` instead of `Re-emit this block` and `Stay on \`propose\``. Its word limit now applies to `revise`. Reason: the routing moved so `propose` can keep the diagram rules and the two project lines.
- `codify-write-refactor.test.sh`: `codified` keeps `same words, in the same order` and `Do not open that record.`, now compared against a recorded feature's `<action>`.
- `codify-write-refactor.test.sh`: `codified` no longer requires `Automation Path`. Reason: dedup no longer opens that path. The new check requires `Do not open a product folder.`
- `codify-closing-guide.test.sh`: `Order the index by Automation ID.` becomes `Order the index by ID.` Reason: the catalog column is ID.
- `codify-closing-guide.test.sh`: the catalog pin moves from `version: 2.0.0` to `version: 3.0.0`. Reason: the catalog columns changed.
- `codify-file-layout.test.sh`, `codify-config-skill.test.sh`, and `codify-platform-catalog.test.sh`: the record pin moves from `version: 7.0.0` to `version: 8.0.0`, and the task-list pin moves from `version: 4.0.0` to `version: 5.0.0`. Reason: the record gains the project lines, and the task list moves under the feature directory.
- `adr-span-progression.test.sh`: the `highway-adr` pin moves from `version: 5.0.1` to `version: 6.0.0`. Reason: the record path it reads changed.
- `codify-proposal-tasks.test.sh`: `that automation's title is this decision's title` becomes `a recorded feature's action is this decision's title`. Reason: a catalog row is a product, and the feature that added the implementation is the recorded entry.

## R8a. Rows in their own step

- **Decision**: `index` holds the catalog row, the Features gate, and the integrations row. `write` writes its files and those rows together, and none until all are valid.
- **Rationale**: `codify-write-refactor.test.sh` caps `write` at 250 words, and `write` was 247. The cap stays. The rows are a separate decision from the file paths.
- `highway-codify.test.sh`: the task list frontmatter `automation: CDYXXXXXX` becomes `product: CDYXXXXXX`. Reason: the id is the product's CDY, and a product holds several features.

## R9. Product id and title conflicts

- **Decision**: A new product's CDY is derived, as today, from the product title. A joined product keeps its CDY. `identifier` compares that id with the catalog, including removed rows. An accepted row with the same product title is joined. An id taken by a different title or by a removed row goes to `title`. A new title does not rename the folder. The same action title is caught earlier by `project` step 2, which resumes that feature at `code`, or goes to `close` when it is finished. A free id goes to `write`.
- **Rationale**: FR-001 and FR-002. The CDY identifies the product, not the action.

## R10. Span coverage in `highway-adr`

- **Decision**: An implementation is covered when an accepted row in `code/code.md` lists it in Implementations, and a recorded feature's action is this decision's title, in lowercase words separated by hyphens. The input reads `code/<folder>/.highway/features/<number>-<action>/codify.md`.
- **Rationale**: The feature that adds an implementation is always recorded in Features (R4). Coverage reads the catalog alone, which matches FR-005.
