# Research: Standard Alignment Catalog Seeding

Each entry records a decision, why it was chosen, and what else was considered.

## R1. Skeleton names and location

**Decision**: highway-setup's `assets/` holds 12 skeletons named after the templates they replace, plus
the storage record:

| Asset | Project file |
| --- | --- |
| `request-catalog.md` | `requests/requests.md` |
| `discovery-catalog.md` | `discoveries/discoveries.md` |
| `adr-catalog.md` | `adrs/adrs.md` |
| `architecture-catalog.md` | `architectures/architectures.md` |
| `implementation-catalog.md` | `implementations/implementations.md` |
| `capability-catalog.md` | `implementations/capabilities.md` |
| `codify-catalog.md` | `code/code.md` |
| `codify-integrations.md` | `code/integrations.md` |
| `codify-platforms.md` | `library/coding-standards/codify-platforms.md` |
| `coding-standards-catalog.md` | `library/coding-standards/coding-standards.md` |
| `assessment-findings.md` | `library/knowledge/assessment-findings.md` |
| `storage.md` | `library/knowledge/storage.md` |

Each catalog skeleton is the fenced body of its template's empty baseline: frontmatter where the template
declares a `## File Frontmatter` fence, then the body fence with its placeholder row removed. The storage
record is a heading and a `Mode: Local` line.

**Rationale**: Keeping the template names means `hw_template`, `harness/fixtures/templates.map`, and every
scenario's `template` argument change location only. `standard-alignment.md` already names
`assets/storage.md`.

**Alternatives considered**: naming each asset after its project file (`requests.md`, `code.md`). That
renames every reference and makes `code.md` and `integrations.md` ambiguous.

## R2. One declaration of the seeded set

**Decision**: `framework/lib/paths.sh` gains `hw_seeded`, which prints one `<asset>\t<project path>` line per
seeded file, and `HW_SETUP` for highway-setup's folder. `hw_template` resolves the 11 catalog names and
`storage` to `$HW_SETUP/assets/`, and the three governance catalogs to their skills' `assets/`.
`HW_KNOWLEDGE` and `hw_doc assessment-findings` are removed with the shipped findings file.

**Rationale**: The validator (R7), the seeding test, and the harness fixtures all need the same list. D2.5
puts every location in the paths helper.

**Alternatives considered**: a list in each consumer, which drifts; a manifest file under `framework/`, which
adds a second declaration format.

## R3. When setup seeds

**Decision**: A new `### Seed` step runs first in every setup run, before the welcome. It writes each absent
seeded file from its asset as one group and shows nothing. An existing file is never read for change or
rewritten. The storage contract's mode check runs before it, so a non-Local record stops setup first.

**Rationale**: Clarification 1. Seeding before Profile satisfies the catalog rule even when an owner stops
early.

## R4. The entry check

**Decision**: Nine skills that can edit a seeded file carry the same check as the second paragraph of their
Procedure, directly after the activation sentence:

```markdown
Before the first question, confirm these seeded files exist: `requests/requests.md`.
When any is absent, emit the message below exactly, stop, and write nothing.

**Oops... we need to setup your repository.**

Highway needs to gather your organizational preferences and set up your repository. Run /highway-setup to get started.
```

The first line's file list varies by skill. The other lines are identical in every skill.

| Skill | Seeded files it can edit |
| --- | --- |
| highway-request | `requests/requests.md` |
| highway-discovery | `discoveries/discoveries.md` |
| highway-adr | `adrs/adrs.md`, `architectures/architectures.md` |
| highway-architecture | `architectures/architectures.md` |
| highway-implementation | `implementations/implementations.md`, `implementations/capabilities.md`, `library/coding-standards/codify-platforms.md` |
| highway-onboarding | `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, `implementations/capabilities.md`, `library/coding-standards/codify-platforms.md` |
| highway-codify | `code/code.md`, `code/integrations.md` |
| highway-codify-config | `library/coding-standards/codify-platforms.md`, `library/coding-standards/coding-standards.md` |
| highway-assessment | `library/knowledge/assessment-findings.md` |

**Rationale**: Clarifications 2 and 3. Checking at entry means the skill never stops after the person has
answered questions. highway-onboarding still writes ADR and architecture rows itself until Phase 10, and
reaches implementations, capabilities, and platforms through highway-implementation, so it checks all five.

**Alternatives considered**: checking only at the write, which loses answers; checking only the file each
path needs, which would put the check deep inside conditional steps.

## R5. Where catalog rules go

**Decision**: In each writing skill, the line "The catalog follows `<template>`." becomes "Edit
`<project file>` in its existing structure." followed by the template's rule paragraphs, verbatim, and the
skill's existing bullets. Rules that a writer does not apply stay out of it: highway-implementation states
only the codify-platforms rules for the row it adds, and highway-adr states only the ADR ID cell rule for
the architecture catalog. The two shared rules (R6) replace each "Title rule in `<template>`" reference with
"the capability title rule", stated once in the skill.

**Rationale**: Verbatim moves keep every test string that asserted a template rule true when the test
points at the skill, so no assertion is weakened (D3.5). Placeholder cells (`<accepted or removed>`) have no
skeleton to live in; the prose already states each value set, and the tests that matched placeholders
change to match that prose.

**Alternatives considered**: rewriting the rules as new bullets, which risks changing meaning and breaks
every assertion.

## R6. Shared rules

**Decision**: `framework/shared-rules/capability-title.txt` and `framework/shared-rules/adr-id-cell.txt`. Each
file has a `skills:` line naming the skills that state the rule and a `rule:` line holding the exact text.
Each named skill holds that text as a whole line. `tests/shared-rules.test.sh` fails, naming the skill and
the rule, when a line is missing or differs. No generator writes either rule.

**Rationale**: Clarification 4. `framework/` does not ship.

## R7. P9.1 with seeded files and assets

**Decision**: `rc_check_P9_1` passes when the Outputs section cites a template under
`.highway/library/templates/output/`, or a file under the skill's own `assets/`, or names only seeded project
files (from `hw_seeded`). The Highway Skills Constitution's P9.1 Observable says the same, a MINOR amendment
from 10.2.0 to 10.3.0.

**Rationale**: highway-assessment's only output becomes a seeded file, with no template anywhere.
highway-setup and the governance skills cite their own `assets/`. Phase 9 moves the record templates to
`assets/` too, so accepting `assets/` now is the end state.

**Alternatives considered**: exempting highway-assessment by name; letting it cite highway-setup's asset,
which is a path into another skill's folder.

## R8. Template check on a skeleton

**Decision**: `harness/bin/template-check.sh` treats a file with no `## File Frontmatter`, `## Body`, or
`## Catalog Structure` section as a skeleton. Its required parts are the keys of its leading frontmatter,
each `## ` heading, and each table header row. Template mode is unchanged.

**Rationale**: Skeletons are project files, with no fence to read. The required parts stay the same kinds,
so a fixture's verdict is unchanged.

## R9. Harness `shows:`

**Decision**: Scenarios gain a repeatable `shows:` key. After an ended run, each value must appear in the
agent's output, or the run fails as an `assertion` with check `shows`. The new scenario
`harness/scenarios/highway-request/request-setup-needed.scenario` runs highway-request on the `empty` fixture
with two `shows:` lines, no `ask`, and no `writes:`. A question makes it `unmatched-question`, and any write
makes it `outside-writes`.

**Rationale**: Clarification 5. The existing assertions read files only.

## R10. Fixtures

**Decision**: Each stage fixture gains every seeded file it lacks, copied from its skeleton. The setup
scenarios' `writes:` cover the seeded paths, and `setup-smoke` asserts `template` for all 12.
`templates.map` maps `library/knowledge/assessment-findings.md` and `library/knowledge/storage.md`. The
assessment scenario uses `library/knowledge/assessment-findings.md`.

**Rationale**: Stage fixtures stand for a project after setup. Without the seeded files every writing
skill's scenario would stop at the entry check.

## R11. Governance catalog templates

**Decision**: `mv` `objective-catalog.md`, `control-catalog.md`, and `nfr-catalog.md` into each skill's
`assets/`, byte-identical. Each skill names `assets/<name>.md`. Their absent-catalog branches are unchanged.

## R12. Versions and constitutions

**Decision**: MINOR for every skill whose text changes: highway-setup, highway-request, highway-discovery,
highway-adr, highway-architecture, highway-implementation, highway-onboarding, highway-codify,
highway-codify-config, highway-assessment, highway-objectives, highway-controls, and highway-nfrs. The Highway
Skills Constitution moves to 10.3.0 (R7). The development constitution names no catalog template location,
declared generator change, or gate affected by this phase, so it is unchanged.

## R13. Removed

- The 14 catalog templates from `.highway/library/templates/output/` (11 become skeletons, 3 move to their
  skills).
- `.highway/library/knowledge/assessment-findings.md`, and with it `.highway/library/knowledge/`.
- Their rows in `framework/.distribution-manifest`.
