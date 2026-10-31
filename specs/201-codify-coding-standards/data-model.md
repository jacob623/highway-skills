# Data Model: Codify Coding Standards and Task List

## Coding Standards Catalog

File: `library/coding-standards/coding-standards.md`. Owned by the organization. Read by codify, never written by it.

| Field | Rule |
|---|---|
| Standard Title | Short name, such as `Terraform Coding Standard` |
| Technology | One technology, such as `Terraform` |
| File Patterns | Comma-separated name patterns, such as `*.tf, *.tfvars` |
| Summary | One sentence |
| Standard Path | `library/coding-standards/<file>.md` in the same folder |

- One row per standard. Rows keep the order the organization wrote.
- The first row whose pattern matches a file name applies to that file.
- A second row for the same technology is a duplicate. The first row is used, and the close names the duplicate.
- A row whose path does not exist is unavailable. Its files get no standard, and the close names the path.

## Coding Standard

File: `library/coding-standards/<technology>.md`. Owned by the organization.

| Section | Rule |
|---|---|
| `# <Technology> Coding Standard` | Title |
| `## Scope` | The technology and the file patterns it covers |
| `## Rules` | Numbered rules for writing code in this technology |
| `## Tests` | First line `Tests: required` or `Tests: not required`. When required, how a test file is named and where it goes |

## Task List

File: `code/<id>/codify-tasks.md`, shaped by `.highway/library/templates/output/codify-tasks.md`.

| Field | Rule |
|---|---|
| `automation` | The `CDY` id |
| Title | `# Tasks: <automation title>` |
| Tasks | One line per task, in order |

## Task

`- [ ] T001 [<component>] <description>. File: \`<path>\`. Standard: \`<path>\`.`

| Field | Rule |
|---|---|
| Checkbox | `[ ]` open, `[X]` done |
| Number | `T` plus three digits, sequential from `T001` |
| Component | A component the accepted proposal names, or `README` |
| Description | One line of work |
| File | One path under `code/<id>/` |
| Standard | A catalog Standard Path, or `No coding standard applies.` |

### Ordering

1. Components in the order the accepted proposal names them.
2. Within a component, a file before any file that relies on it.
3. A test task directly after the task for the file it tests, naming the same standard.
4. The README task last, with `Standard: No coding standard applies.`

### State

- Open → done: after the file is written, before the next task starts.
- Open stays open when the run stops at or before it.
- A done task is never reopened by codify.

## Relationships

- One accepted automation has one task list.
- One task points to zero or one standard.
- One standard may be named by many tasks across automations.
