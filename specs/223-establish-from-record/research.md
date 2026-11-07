# Research: Establish From Record

## R1 Executor and task platform

- **Decision**: The codify proposal shows **Executor:** once. An establishing action uses Deployed by. A run, change, or recover action uses Managed by. Each task keeps **Provider:** as the platform that task uses. Method names how, and may name Helm, Terraform, CloudFormation, or another tool. The executor is not copied onto a task.
- **Rationale**: The record names who runs the automation. The model still breaks the work into tasks, and a pipeline can use another tool inside it.
- **Alternatives considered**: One fixed task per kind. Rejected. The same Provider on every task. Rejected.

## R2 Kind order

- **Decision**: Deployed by is the earliest row whose Kind is `pipeline`, otherwise `orchestrator`, otherwise `desired-state`, otherwise `agent`. Managed by is the earliest `self-service`, otherwise `agent`, otherwise the Deployed by row. A blank Kind is not a candidate. When to use is not read. Catalog order breaks a tie inside one kind.
- **Rationale**: Kind is already chosen when a platform is configured. Reading it again is the same result on every run.
- **Alternatives considered**: A meaning match on When to use. The person picks both with no pre-selection.

## R3 Language

- **Decision**: Language is the earliest coding-standards row whose Technology appears on its own in a Technology Choice `Choice:`, compared without regard to case. None when none match. The record stores the standard title, or None. A version stays on the technology choice.
- **Rationale**: The catalog can be matched. A version cannot.
- **Alternatives considered**: A separate custom-developed flag. Storing the version in Language.

## R4 Platform-standard entries

- **Decision**: When a standard's Technology is a platforms-catalog title, the whole value, compared without regard to case, When to use is `[Platform] is used` and When not to use is `[Platform] is not used`. No other entry is proposed. Saved entries are not carried. The two phrases are not split and are not rewritten. Each keeps its **Why it matters:** line on the proposal. The saved cell keeps the entry only. A language standard keeps the class list.
- **Rationale**: A platform standard applies when that platform is the one doing the work.
- **Alternatives considered**: Keeping the class list and adding the two phrases.

## R5 Missing executor platform

- **Decision**: A name that is already a row is used. A name with an accepted implementation and no row follows `highway-codify-config` and returns to `execution`. A name with no accepted implementation follows `highway-onboarding` and returns to `execution` after the row exists. A task platform that is not a catalog row does not start either path. An empty executor field names the field and waits. It does not take this implementation's row or the first catalog row.
- **Rationale**: Deployed by and Managed by are catalog rows. A tool named on a task is not one of those fields.
- **Alternatives considered**: Leaving the person to re-open the proposal after onboarding.

## R6 Moved pins

Each assertion below moves because the behavior it pinned is replaced. The new test pins the replacement.

- `version: 3.2.5` becomes `version: 3.3.0` in `standard-starting-point.test.sh`, `single-rule-shape.test.sh`, `platform-starting-point.test.sh`, `labeled-proposal-lines.test.sh`, `group-realized-capabilities.test.sh`, `entry-level.test.sh`, `configure-handoff.test.sh`, `config-live-rules.test.sh`, `codify-file-layout.test.sh`, and `codify-config-skill.test.sh`.
- `version: 12.0.0` becomes `version: 12.1.0` in `codify-file-layout.test.sh`, `codify-config-skill.test.sh`, `propose-edit-lines.test.sh`, `codify-write-refactor.test.sh`, `codify-products.test.sh`, `codify-feature-wording.test.sh`, `codify-deterministic-steps.test.sh`, `codify-closing-guide.test.sh`, and `codify-platform-catalog.test.sh`.
- `version: 7.2.0` becomes `version: 7.3.0` in `platform-starting-point.test.sh`, `configure-handoff.test.sh`, `record-purpose-titles.test.sh`, and `codify-platform-catalog.test.sh`.
- `version: 10.1.0` becomes `version: 10.2.0` in `configure-handoff.test.sh`, `onboarding-technology-capabilities.test.sh`, and `codify-platform-catalog.test.sh`.
- `codify-platforms.md` header and `version: 2.0.0` become the Kind header and `version: 2.1.0` in `codify-config-skill.test.sh` and `codify-platform-catalog.test.sh`.
- `implementation-record.md` `version: 2.1.0` becomes `version: 2.2.0` in `record-purpose-titles.test.sh`. The architecture record pin stays `2.1.0`.
- `codify-deterministic-steps.test.sh` stops requiring `appears on its own` and `this implementation's row, then the first row` inside `provider`. It requires the Executor lines instead. `standards` still contains `appears on its own`.
- `codify-platform-catalog.test.sh` stops requiring `Every task names that same Provider`, the unlisted-platform sentence, and the empty-catalog sentence. It requires `**Executor:**` and `[Field] is needed. Name it on the implementation.` The executor is read from the record.
- `propose-edit-lines.test.sh` requires an Executor edit to change the diagram start and leave task Providers unchanged. A Provider edit changes that task only.
- `platform-starting-point.test.sh` and `entry-level.test.sh` require `platform entries` in `use entries` step 2. `platform proposal` step 1 follows `kind` before `use entries`.

## R7 Standards that stay

- **Decision**: A missing When to use entry does not remove Language from a task that writes the custom solution, and does not remove the standard whose Technology appears on its own in the task's Provider. A task writes the custom solution when its Provider or Method names that standard's Technology on its own. Any other candidate still uses the existing drop.
- **Rationale**: Platform standards now say `[Platform] is used`, which will not appear in the task text. Language is attached from the record.
- **Alternatives considered**: Dropping the When to use check for every standard.
