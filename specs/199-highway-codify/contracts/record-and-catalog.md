# Contract: Codify Record, Catalog, and Folder

## Record

`codify-record.md` is the saved proposal. Frontmatter is `id`, `implementation`, `architecture`, and `status: accepted`. The body states the current state, one action, `Day 1` or `Day 2`, the means by architecture title, and the components of that one action, or `None`.

The record does not contain a plan, tasks, a second copy of the implementation, or an instruction to run the automation.

## Catalog

`codify-catalog.md` is `code/code.md`. Columns are Automation ID, Implementation ID, Automation Title, Automation Path, and Status. More than one row may name the same Implementation ID. A removed row keeps its id and has no folder. Rows are ordered by Automation ID. The template has no `Next ID` field.

## Folder and readme

Acceptance creates one folder for that id. It contains `codify.md`, `README.md`, and one subfolder for each component the accepted proposal names. It contains no other component folder.

`README.md` contains `## Implement` and `## Use`, in that order. Implement includes the preparation this automation needs. Use follows the interface of the accepted means.

## Write

Acceptance writes the catalog row and the folder together. A failed write leaves no partial folder and no new catalog row, and leaves every existing record unchanged. The write does not run the automation. It does not change the implementation, its architecture, its decision, the request, the assessment finding, Controls, or NFRs.
