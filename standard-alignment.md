# Purpose

Deliver Highway as one plugin that conforms to the open
[Agent Plugins 1.0 specification](https://agent-plugins.org), so it installs on any agent that
supports the standard. The plugin is the only delivery model.

Agent Plugins requires every skill in a plugin to conform to the open
[Agent Skills specification](https://agentskills.io/specification), which defines the format of
one skill folder. The plugin cannot conform unless every Highway skill does, so both standards
are targets:

- Agent Plugins: the package, its manifest, and where skills are found in it.
- Agent Skills: everything inside each skill folder.

Under these standards, an installed skill can rely only on:

- its own folder;
- the other Highway skills, because the plugin installs them all as one unit;
- the project it works on.

The plugin root, the always-on instructions (`AGENTS.md`, the agent rule files), and anything
else outside the skill folder are not portable. Agent Plugins 1.0 defines skills and MCP servers
only; rules and instructions remain client-specific.

## Repository model

The source conforms to Agent Skills. The plugin is a build of that source.

- Source: this private repository authors each skill as a standard skill folder,
  `skills/<name>/`, with its `SKILL.md` and its own `references/`, `assets/`, and `scripts/`.
  Every source folder conforms to Agent Skills as written and is validated where it is edited.
- Generated content: the generator writes the shared rules that more than one skill states, and
  highway-help's `assets/index.json`, into the source skill folders, and they are committed.
  A drift check fails when a copy is out of date. No source skill holds a placeholder, so every
  one is complete without a build.
- Plugin: the generator builds `highway-agent-plugin/` from the source skill folders. It holds
  `plugin.json`, `skills/`, and the files the public repository needs, and nothing else.
- Publishing: `highway-agent-plugin/` is pushed to a public repository whose root is the plugin
  root. Nothing outside that folder is published.
- Framework: the generators, validators, and constitution live in `framework/`, the bash tests in
  `tests/`, and the behavioral harness in `harness/` (Phase 3). The framework no longer ships;
  none of it is in the plugin.

Phases 1 to 3 record the decisions: every file under `.highway/` and its resolution. They are
complete in this document and have no spec of their own.

Phases 4 to 14 carry out those decisions. Each is one speckit spec and leaves the full suite
passing:

| Phase | Spec | Depends on | Status |
| --- | --- | --- | --- |
| 4 | Removals | None | Complete: `specs/233-standard-alignment-removals/` |
| 5 | Path Indirection | 4 | Complete: `specs/234-standard-alignment-path-indirection/` |
| 6 | Relocate the Framework, Tests, and Skills | 5 | Complete: `specs/235-standard-alignment-relocation/` |
| 7 | highway-experience | 6 | Complete: `specs/236-standard-alignment-experience/` |
| 8 | Catalog Seeding | 7 | |
| 9 | Record Templates in Their Skills | 6 | |
| 10 | Onboarding Handoffs | 8 | |
| 11 | Self-Contained Skills | 7 to 10 | |
| 12 | Agent Skills Format Conformance | 6 | |
| 13 | Progressive Disclosure | 11 | |
| 14 | Agent Plugins Package | 11 to 13 | |

## Conformance map

Each requirement of the two standards, where Highway stands today, and the phase that closes it.

| Standard | Requirement | Today | Phase |
| --- | --- | --- | --- |
| Agent Skills | A folder with a `SKILL.md` of YAML frontmatter and a Markdown body | Conforms | 12 checks it |
| Agent Skills | `name`: 1 to 64 characters, lowercase letters, digits, and single hyphens, matching the folder | Conforms | 12 checks it |
| Agent Skills | `description`: 1 to 1,024 characters, saying what the skill does and when to use it | Length conforms; none says when to use it | 12 |
| Agent Skills | Only the defined fields: `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools` | Every skill adds `usage` | 12 |
| Agent Skills | `compatibility`, if present: 1 to 500 characters stating real environment requirements | Every skill has `compatibility: all` | 12 |
| Agent Skills | `metadata`: string keys to string values | Conforms (`version`) | 12 checks it |
| Agent Skills | `license` (optional, needed for a public release) | Missing | 12 |
| Agent Skills | `allowed-tools` (optional, experimental) | Not used | 12 decides |
| Agent Skills | Files a skill uses sit inside its folder (`scripts/`, `references/`, `assets/`) | Skills read templates and guidance from `.highway/` | 7 to 11 |
| Agent Skills | References are relative to the skill folder, one level deep | Skills name `.highway/` paths | 7 to 11 |
| Agent Skills | `SKILL.md` under 500 lines and about 5,000 tokens | 1 skill over 500 lines, 7 over 5,000 tokens | 13 |
| Agent Skills | Valid by `skills-ref validate` | Not checked | 12 |
| Agent Plugins | Root `plugin.json` with the 1.0.0 `$schema` | None | 14 |
| Agent Plugins | Skills discovered from `skills/<name>/SKILL.md` | Source in `.highway/skills/`; four per-agent copies instead | 6 (source), 14 (plugin) |
| Agent Plugins | Plugin files stay inside the plugin root | Skills read the project's `.highway/` | 7 to 11 |
| Agent Plugins | Client-specific data only under a reverse-domain extension namespace | Agent rule files and `AGENTS.md` sit beside the skills | 7 removes them, 14 |

# Phase 1: Rationalize the Shared Files

Each file below sits under `.highway/` and is read by more than one skill. Every skill reads the
three files named in the always-on instructions (`AGENTS.md` and the agent rule files).

Seeded by highway-setup: a resolution can name a template as seeded. That pattern means:

- The template's skeleton (frontmatter, headings, and table header) moves to highway-setup's
  `assets/`. highway-setup is its only reader.
- highway-setup writes the empty file into the project once, from the skeleton, when the file is
  absent. It never overwrites an existing file.
- From then on, the project file is the only copy any skill reads or edits. Each skill that edits
  it follows the file's existing structure.
- The template's rules (row order, status values, id formats, removed rows, version changes, and
  cell formats) move into the skills that write the file. When two skills write the same file, the
  generator inserts the shared rule into both from one source in this repo, and a bash check fails
  when a copy differs.
- A skill that must edit a seeded file that is still absent follows highway-setup's seeding step
  for that file, then continues.
- The bash fixture check and the harness template assertions still compare project files against
  the template, so a skill that drifts from the structure is caught.

Catalog rule: when highway-setup finishes, every catalog exists.

- highway-setup seeds these 11 catalogs:

  | Template | Project file |
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

- The three governance catalogs are not seeded. highway-objectives, highway-controls, and
  highway-nfrs each keep their catalog template and write their catalog when highway-setup runs
  them, with content or, on decline, empty. For these three, an absent catalog means the baseline
  was never set up and starts with recommendations, while an empty one means the person declined.
  Seeding them empty would erase that difference.
- Seeding creates folders a project may never use, such as `code/`. That is accepted.

## `.highway/governance/experience-standard.md`

Skills:

- highway-adr
- highway-architecture
- highway-assessment
- highway-codify
- highway-codify-config
- highway-controls
- highway-discovery
- highway-help
- highway-implementation
- highway-nfrs
- highway-objectives
- highway-onboarding
- highway-profile
- highway-request
- highway-setup

Resolution: move to a new skill, highway-experience, as `references/experience-standard.md`.

- highway-experience holds Highway's identity, output standard, and storage rules for the other
  Highway skills (see `storage.md` below). Its `SKILL.md` stays short and says when to read each
  reference.
- Each skill above activates highway-experience by name as its first step, before any output the
  person sees. No skill reads the file by path, since a path into another skill's folder is not
  portable under either standard.
- The description says the skill holds Highway's identity and output standard and is loaded by
  the other Highway skills, so agents do not activate it for unrelated requests.
- Invoked directly by a person, it gives a short summary of what Highway is.
- A harness invariant checks that every Highway scenario loads highway-experience before the
  first output the person sees.
- One source, so no bundled copies and no drift check.

## `.highway/governance/storage.md`

Skills:

- highway-adr
- highway-architecture
- highway-assessment
- highway-codify
- highway-codify-config
- highway-controls
- highway-discovery
- highway-help
- highway-implementation
- highway-nfrs
- highway-objectives
- highway-onboarding
- highway-profile
- highway-request
- highway-setup

Resolution: split the file into the fixed rules and the project's choice of mode.

- The fixed rules move to highway-experience as `references/storage-contract.md`: the four
  operations, what each does in each mode, the paths rule, and what a skill does not do.
  They are the same for every project, ship with the plugin, and update with it. Skills load them
  when they activate highway-experience, so they cost no extra activation.
- The mode is a project record. highway-setup writes `library/knowledge/storage.md` next to the
  profile, from a template in its own `assets/storage.md`. The record holds the mode, and later
  the Remote settings.
- A skill that finds no storage record uses Local mode. Skills already run before setup, since a
  missing profile changes their path rather than stopping them, and Local is the only supported mode.
- Local mode reads and writes through the agent's own file tools.
- Agent Plugins 1.0 has no portable place for a per-project setting that skills can read:
  `PLUGIN_DATA` and `${PLUGIN_ROOT}` reach only MCP servers, and `extensions` is client-specific.
  The project is the only portable place for the mode.
- Chat mode cannot read a project file, so it is detected, not configured: no working tree, and
  Highway's git host MCP server available. That belongs to the Chat phase of `rollout-plan.md`,
  where the MCP server can keep its own settings in `PLUGIN_DATA`.
- Considered and rejected: one MCP server implementing the four operations in every mode.
  - Fewer agents could run Highway, since MCP support is optional and many agents cannot launch a local server.
  - The standard gives a server no portable way to find the project.
  - It means building and shipping a program for every platform, which reverses retiring the executable.
  - Trust prompts and organization policies often block MCP servers.
  - Local mode would lose the editor's diff review, checkpoints, and undo.
  - Models drift back to their own file tools.
  - Chat mode would still need a separate hosted server.
  MCP is added only where file tools cannot do the job: Chat mode, and possibly Remote mode's
  commit and push.

## `.highway/library/knowledge/highway-identity.md`

Skills:

- highway-adr
- highway-architecture
- highway-assessment
- highway-codify
- highway-codify-config
- highway-controls
- highway-discovery
- highway-help
- highway-implementation
- highway-nfrs
- highway-objectives
- highway-onboarding
- highway-profile
- highway-request
- highway-setup

Resolution: move to highway-experience as `references/highway-identity.md`, loaded the same way
as the Experience Standard (see `experience-standard.md` above).

## `.highway/library/templates/output/codify-platforms.md`

Skills:

- highway-codify
- highway-codify-config
- highway-implementation
- highway-onboarding

Resolution: seeded by highway-setup (see the Phase 1 introduction).

- highway-setup seeds `library/coding-standards/codify-platforms.md` with the frontmatter, the
  heading, and the table header, and no rows.
- highway-implementation edits the project file: one row per Implementation ID, added with Kind,
  When to use, and When not to use blank.
- highway-codify-config edits the project file: it adds, updates, and removes rows, and is the
  only skill that sets Kind and the two guidance lists. It no longer rewrites the file from the
  template.
- highway-onboarding and highway-codify read the project file only. highway-onboarding drops the
  template from its inputs.

## `.highway/library/templates/output/capability-catalog.md`

Skills:

- highway-architecture
- highway-codify-config
- highway-implementation

Resolution: seeded by highway-setup (see the Phase 1 introduction), with the capability title
rule stated in the skills that apply it.

- highway-setup seeds `implementations/capabilities.md` with `Version: 1.0.0` and the index
  header, and no rows.
- highway-implementation is the only writer. Each write replaces that implementation's rows and
  leaves every other implementation's rows unchanged.
- highway-assessment reads the project file only.
- The title rule: a capability title is one noun phrase of five words or fewer, with no `and`,
  `or`, `&`, `/`, `+`, or comma, and a title that joins two things becomes two capabilities.
  The seeded file holds only the table, so the rule cannot come from it.
  - highway-architecture and highway-implementation state the rule in their own text. The
    generator inserts it into both `SKILL.md` files from one source in this repo, and a bash
    check fails when either copy differs from the source.
  - highway-codify-config stops checking titles and drops the template from its inputs. It passes
    new capabilities to highway-implementation, which already leaves out any title that breaks
    the rule.

## `.highway/library/templates/output/adr-record.md`

Skills:

- highway-adr
- highway-architecture
- highway-onboarding

Resolution: move to highway-adr's `assets/`. highway-adr is the only skill that creates an ADR.

- highway-onboarding hands ADR creation to highway-adr, the same way it already follows
  highway-architecture and highway-implementation for their records.
  - highway-onboarding passes the provider, the capabilities it serves, the decision, the
    alternatives, the rationale, and the limitations.
  - highway-adr gains an onboarding entry step. It writes the onboarding variant without asking
    the person to accept it: `request: onboarding` and `discovery: highway`; Discovery, Request,
    Recommendation, Recommendation Rationale, Comparison Matrix, Reference Architecture Matches,
    and Discovery Confidence `None`; no Recommendation Override; Selected Option the provider name
    and Selection Source `Accepted onboarding mapping`; alternatives headed by name with no option
    id; and the catalog row with Discovery ID `highway` and Request ID `onboarding`.
  - The template's onboarding paragraph moves with the template.
  - highway-onboarding drops the template from its inputs and loses its ADR-writing section,
    which also shrinks it for Phase 13.
- highway-architecture drops the template from its inputs. It never creates an ADR. It reads the
  accepted ADR from the project record `adrs/[ID].md`, and its `name` step sets the existing
  `Reference Architecture` field to the new `RA` id and changes no other byte. Both work from the
  person's file, which already has the template's structure, and the skill's own text states the
  edit rule. Creating a file needs the template; editing an existing file follows the file.

## `.highway/library/templates/output/architecture-record.md`

Skills:

- highway-adr
- highway-architecture
- highway-onboarding

Resolution: move to highway-architecture's `assets/`. highway-architecture is the only skill that
creates an architecture.

- highway-adr drops the template from its inputs. It never creates an architecture. When a
  decision replaces, runs beside, reuses an implemented architecture, or spans architectures, it
  edits the existing record's Current Decisions and changes nothing else in it.
- highway-onboarding hands architecture creation to highway-architecture, the same way it hands
  ADR creation to highway-adr.
  - highway-architecture gains an onboarding entry step that writes the record as accepted
    without asking the person: Current Decisions is the onboarding ADR, no Key Technologies, and
    the catalog ADR ID cell is that ADR id.
  - Onboarding's architecture rules move into that entry step, and highway-onboarding drops the
    template from its inputs.
- Gap for the spec: after the architecture is written, highway-onboarding sets the ADR's
  `Reference Architecture` field and the ADR catalog's Architecture ID, while highway-architecture's
  `name` step sets only the ADR field and never updates `adrs/adrs.md`. Both paths must leave the
  ADR catalog in the same state.

## `.highway/library/templates/output/adr-catalog.md`

Skills:

- highway-adr
- highway-onboarding

Resolution: seeded by highway-setup (see the catalog rule in the Phase 1 introduction).

- highway-setup seeds `adrs/adrs.md` with `Version: 1.0.0` and the index header, and no rows.
- highway-adr edits the project file: it adds rows, including onboarding ADRs, and marks replaced
  decisions `superseded`. It states the catalog's rules in its own text.
- Filling in the Architecture ID cell is an edit to the existing file (see the gap under
  `architecture-record.md`).
- highway-onboarding drops the template from its inputs and keeps reading `adrs/adrs.md`.
  highway-architecture and highway-assessment read it only.

## `.highway/library/templates/output/architecture-catalog.md`

Skills:

- highway-adr
- highway-architecture

Resolution: seeded by highway-setup (see the catalog rule in the Phase 1 introduction).

- highway-setup seeds `architectures/architectures.md` with `Version: 1.0.0` and the index header,
  and no rows.
- highway-architecture edits the project file: it adds a row with each architecture, including
  onboarding architectures, and states the catalog's rules in its own text.
- highway-adr edits only an existing row's ADR ID cell, when a decision replaces, runs beside,
  reuses an implemented architecture, or spans architectures, and drops the template from its
  inputs.
- The ADR ID cell format is a shared rule, inserted into highway-architecture and highway-adr from
  one source: ids in id order, separated by a comma and a space; a superseded or removed decision
  is not in the cell; an ADR id is on at most one row, except a span decision, which is on the row
  of each architecture it names.
- highway-implementation, highway-codify, and highway-assessment read it only.

## `.highway/library/templates/output/implementation-record.md`

Skills:

- highway-implementation
- highway-onboarding

Resolution: move to highway-implementation's `assets/`. highway-implementation is the only skill
that creates an implementation.

- highway-onboarding hands implementation creation to highway-implementation, the same way it
  hands ADR creation to highway-adr and architecture creation to highway-architecture.
  - highway-implementation gains an onboarding entry step that writes the record as accepted
    without asking the person. It skips the `execution` proposal and the questions, and writes
    Execution as `Deployed by: Needed`, `Managed by: Needed`, and `Language: Needed`.
  - Onboarding's implementation rules move into that entry step: the `RI` id and `RA` parent, the
    variation choice or `None`, coverage rows for each architecture responsibility, conformance
    that agrees with them, no gap or conflict section, the realized interface, how conformance
    was shown, and the limitations, each or `None`, one technology choice, and the architecture
    named once.
  - The entry step writes the row in `implementations/implementations.md` and the capability rows
    in `implementations/capabilities.md`, then continues to `platforms`, which already returns to
    highway-onboarding without asking. Onboarding makes one handoff instead of two.
  - highway-onboarding drops the template from its inputs.
- Nothing else records the implementation id. Onboarding does not set it on the ADR, and no skill
  sets it on the architecture, so there is no catalog gap to close.
- For the spec: when highway-implementation's `execution` step starts onboarding for a platform
  with no implementation, onboarding calls the entry step, and the entry step returns to
  onboarding, not to the held step. Onboarding then returns to `execution` in the original visit.
  A test covers that chain.

# Phase 2: Rationalize the Single-Consumer Files

Each file below sits under `.highway/`, is read by exactly one skill, and is not in Phase 1.
Files under a code product's own `code/<folder>/.highway/` are the person's records and are not listed.

## `.highway/catalog/index.json`

Consumer:

- highway-help

Resolution: move to highway-help's `assets/index.json`, as generated output.

- `generate-catalog.sh` writes the file to `skills/highway-help/assets/index.json` instead of
  `.highway/catalog/`. Nobody edits it by hand. The drift check compares that file, so a change to
  any skill's frontmatter still forces a rebuild.
- highway-help is the only reader. The plugin installs every skill together, so the list matches
  what is installed.
- The generator adds each skill's dependencies and its `## Example` invocation to the entry, so
  Single-Skill mode reads only this asset (see `skills/<id>/SKILL.md` below).
- Drop `generated_at`, so the same sources always build the same file.
- Drop the stale references: the `overlap_flags` field, `.highway/catalog/index.md`, and the
  highway-help "When not to use" line that points to `overlap_flags`. No skill reads them.

## `.highway/skills/<id>/SKILL.md`

Consumer:

- highway-help

Resolution: highway-help stops reading other skills' folders. A plugin skill cannot rely on a
sibling's files.

- Single-Skill mode reads the description, usage, version, dependencies, and Example from its own
  `assets/index.json` (see `catalog/index.json` above).
- The generator validates that each skill's frontmatter `name` equals its folder name, which
  highway-help checks at run time today.
- highway-help drops `skills/<id>/SKILL.md` from its inputs.

## `.highway/library/knowledge/assessment-findings.md`

Consumer:

- highway-assessment

Resolution: move to the project's `library/knowledge/assessment-findings.md`, next to the storage
record. It is project data that highway-assessment reads and writes, not shipped material.

- highway-assessment reads and writes `library/knowledge/assessment-findings.md` and no longer
  touches `.highway/`.
- The copy under `.highway/library/knowledge/` is removed, along with its entries in
  `.highway/catalog/library-index.json` and `library-index.md`. It is an empty table with a stale
  Fingerprint column that the template no longer has.
- highway-setup seeds the file (see the template entry below).

## `.highway/library/templates/output/assessment-findings.md`

Consumer:

- highway-assessment

Resolution: seeded by highway-setup as `library/knowledge/assessment-findings.md` (see the catalog
rule in the Phase 1 introduction). It is an index table with one row per finding, like the
catalogs. highway-assessment already treats an absent file the same as an empty one, so seeding it
loses no meaning. highway-assessment states the table's rules in its own text: the `F` id derived
from the observation, rows ordered by ID, the Category, Domain, and Status values, and no
fingerprint column.

## `.highway/library/templates/output/codify-catalog.md`

Consumer:

- highway-codify

Resolution: seeded by highway-setup as `code/code.md` (see the catalog rule in the Phase 1
introduction). highway-codify states the catalog's rules in its own text.

## `.highway/library/templates/output/codify-integrations.md`

Consumer:

- highway-codify

Resolution: seeded by highway-setup as `code/integrations.md` (see the catalog rule in the Phase 1
introduction). highway-codify states the catalog's rules in its own text.

## `.highway/library/templates/output/codify-metadata.md`

Consumer:

- highway-codify

Resolution: move to highway-codify's `assets/`. highway-codify is the only skill that creates a
product's `code/<folder>/.highway/metadata.md`, once per new product, from that asset. A joined
product keeps its file, and appending a feature's Features row is an edit to the existing file.

## `.highway/library/templates/output/codify-plan.md`

Consumer:

- highway-codify

Resolution: move to highway-codify's `assets/`. highway-codify is the only skill that creates a
feature's `code/<folder>/.highway/features/<number>-<action>/plan.md`, once per feature, from that
asset.

## `.highway/library/templates/output/codify-record.md`

Consumer:

- highway-codify

Resolution: move to highway-codify's `assets/`. highway-codify is the only skill that creates a
feature's `code/<folder>/.highway/features/<number>-<action>/codify.md`, once per feature, from
that asset.

## `.highway/library/templates/output/codify-tasks.md`

Consumer:

- highway-codify

Resolution: move to highway-codify's `assets/`. highway-codify is the only skill that creates a
feature's `code/<folder>/.highway/features/<number>-<action>/codify-tasks.md`, beside the plan,
from that asset when the person continues from the plan. Working through tasks and reading progress
for the recent list are edits and reads of the existing file.

## `.highway/library/templates/output/coding-standard.md`

Consumer:

- highway-codify-config

Resolution: move to highway-codify-config's `assets/`. highway-codify-config is the only skill that
writes a standard at `library/coding-standards/[technology].md`, from that asset, when the person
accepts the standard proposal. Its catalog row goes in the seeded
`library/coding-standards/coding-standards.md`, so the skill drops its "create the catalog when
absent" step.

## `.highway/library/templates/output/coding-standards-catalog.md`

Consumer:

- highway-codify-config

Resolution: seeded by highway-setup as `library/coding-standards/coding-standards.md` (see the
catalog rule in the Phase 1 introduction). highway-codify-config states the catalog's rules in its
own text.

## `.highway/library/templates/output/control-catalog.md`

Consumer:

- highway-controls

Resolution: move to highway-controls' `assets/`. Not seeded: an absent catalog means the baseline
was never set up, and an empty one means the person declined (see the catalog rule in the Phase 1
introduction). highway-controls writes it when highway-setup runs it.

## `.highway/library/templates/output/control-record.md`

Consumer:

- highway-controls

Resolution: move to highway-controls' `assets/`, next to its catalog template. highway-controls is
the only skill that writes `library/governance/controls/[ID].md`, one per held Control, from that
asset.

## `.highway/library/templates/output/discovery-catalog.md`

Consumer:

- highway-discovery

Resolution: seeded by highway-setup as `discoveries/discoveries.md` (see the catalog rule in the
Phase 1 introduction). highway-discovery states the catalog's rules in its own text.

## `.highway/library/templates/output/discovery-record.md`

Consumer:

- highway-discovery

Resolution: move to highway-discovery's `assets/`. highway-discovery is the only skill that writes
`discoveries/[ID].md`, once per Discovery, from that asset, before the option list is shown. Its
catalog row goes in the seeded `discoveries/discoveries.md`.

## `.highway/library/templates/output/implementation-catalog.md`

Consumer:

- highway-implementation

Resolution: seeded by highway-setup as `implementations/implementations.md` (see the catalog rule
in the Phase 1 introduction). highway-implementation states the catalog's rules in its own text.

## `.highway/library/templates/output/nfr-catalog.md`

Consumer:

- highway-nfrs

Resolution: move to highway-nfrs' `assets/`. Not seeded: an absent catalog means the baseline was
never set up, and an empty one means the person declined (see the catalog rule in the Phase 1
introduction). highway-nfrs writes it when highway-setup runs it.

## `.highway/library/templates/output/nfr-record.md`

Consumer:

- highway-nfrs

Resolution: move to highway-nfrs' `assets/`, next to its catalog template. highway-nfrs is the only
skill that writes `library/governance/nfrs/[ID].md`, one per held NFR, from that asset.

## `.highway/library/templates/output/objective-catalog.md`

Consumer:

- highway-objectives

Resolution: move to highway-objectives' `assets/`. Not seeded: an absent catalog means the
baseline was never set up, and an empty one means the person declined (see the catalog rule in the
Phase 1 introduction). highway-objectives writes it when highway-setup runs it.

## `.highway/library/templates/output/objective-record.md`

Consumer:

- highway-objectives

Resolution: move to highway-objectives' `assets/`, next to its catalog template. highway-objectives
is the only skill that writes `library/objectives/[ID].md`, one per held Objective, from that
asset.

## `.highway/library/templates/output/profile-record.md`

Consumer:

- highway-profile

Resolution: move to highway-profile's `assets/`. highway-profile is the only skill that writes
`library/knowledge/profile.md`, once, from that asset at the end of the guided flow. A review edit
changes the existing file.

- Not seeded: an absent Profile starts the guided flow, while an existing one opens the review, so
  seeding it empty would erase that difference.
- highway-profile drops its guards against reading or writing `.highway/library/knowledge/profile.md`.
  No such file ships, and `.highway/` no longer holds project data.

## `.highway/library/templates/output/request-catalog.md`

Consumer:

- highway-request

Resolution: seeded by highway-setup as `requests/requests.md` (see the catalog rule in the Phase 1
introduction). highway-request states the catalog's rules in its own text.

## `.highway/library/templates/output/request-record.md`

Consumer:

- highway-request

Resolution: move to highway-request's `assets/`. highway-request is the only skill that writes
`requests/[ID].md`, once per Request, from that asset after the complete proposal is accepted. Its
catalog row goes in the seeded `requests/requests.md`, written together with the record.
highway-discovery reads the completed record only.

# Phase 3: Rationalize the Remaining .highway Files

Each file below sits under `.highway/` and is not in Phase 1 or 2. No Highway skill reads any of
them. Their consumers are the repository's tooling, the harness, and its documentation.
`.highway/catalog/index.md` is already dropped under `catalog/index.json` in Phase 2, and the
`.DS_Store` files are deleted.

The framework no longer ships. Users get only the plugin, and anyone writing their own skills
follows the Agent Skills specification. The repository root becomes:

```text
skills/                 one folder per skill, nothing else
tests/                  the bash suite and its fixtures
framework/              the authoring framework: generators, validators, lib/, manifests,
                        constitution, authoring standard, word list, README.md, and plugin/
harness/                the behavioral harness, unchanged
highway-agent-plugin/   the built plugin (Phase 14)
```

`skills/` holds nothing but skill folders, so it matches `highway-agent-plugin/skills/` exactly and
every tool can treat each child as a skill. `framework/plugin/` holds the files the generator puts
into the plugin beside `skills/`: the public `README.md`, the `LICENSE`, and the source fields for
`plugin.json`.

## `.highway/DISTRIBUTION.md`

Consumers:

- `generate-distribution.sh`, which ships it as the distribution's `README.md`
  (`.distribution-manifest`)
- `.specify/memory/constitution.md`

Resolution: move to `framework/README.md`, the authoring guide for this repository. It never
ships.

- Its paths change to `skills/`, `framework/`, and `tests/`.
- The per-agent adapter, always-on instruction, earlier Cursor rule, and "skills in this
  distribution are registered" sections are removed.
- `.highway/tools/README.md` merges into it.
- The public plugin README is a new file, `framework/plugin/README.md`: what Highway is, how to
  install the plugin, and the skills in it.
- `.specify/memory/constitution.md` points to the new path.

## `.highway/catalog/README.md`

Consumers:

- `generate-catalog.sh`
- `generate-library-catalog.sh`
- `.highway/catalog/index.md` and `.highway/catalog/library-index.md`, which link to it

Resolution: drop. Nothing it describes remains: `index.json` moves to highway-help's `assets/`
(Phase 2), and `index.md` and the library index are dropped. `framework/README.md` states that
highway-help's index is generated. The generators stop referencing it.

## `.highway/catalog/library-index.json`

Consumers:

- `generate-library-catalog.sh`, which writes it
- Tests: `generate-library-catalog.test.sh`, `adapter-coverage.test.sh`,
  `distribution-packaging.test.sh`, `feature-092-correspondence.test.sh`
- `.highway/catalog/README.md` and `.highway/tools/README.md`
- `.specify/memory/constitution.md`

Resolution: drop, with `generate-library-catalog.sh` and `generate-library-catalog.test.sh`. It
indexes the shared library, which Phases 1 and 2 empty. The other tests and
`.specify/memory/constitution.md` stop referencing it.

## `.highway/catalog/library-index.md`

Consumers:

- `generate-library-catalog.sh`, which writes it
- Tests: `generate-library-catalog.test.sh`, `adapter-coverage.test.sh`,
  `distribution-packaging.test.sh`
- `.highway/catalog/README.md` and `.highway/tools/README.md`

Resolution: drop, with `library-index.json` above.

## `.highway/governance/constitution.md`

Consumers:

- Validators: `validate-skill.sh`, `validate-library.sh`, `lib/constitution.sh`,
  `lib/rule-checks.sh`
- Tests: `authoring-standard`, `constitution-experience-alignment`, `constitution-inventory`,
  `constitution-profile-context`, `coverage-summary`, `experience-standard-amendment`,
  `harness-path-map`, `output-template`, `rule-checks`, `storage-contract`, `validation-cache`
- `.highway/skills/_authoring-standard.md`, `.highway/DISTRIBUTION.md`, `.highway/tools/README.md`
- Harness: `selection/shared.txt`
- `.specify/memory/constitution.md`, `README.md`, `governance-plan.md`

Resolution: move to `framework/constitution.md`. It never ships. The validators, tests, harness
selection, and documents point to the new path. Phase 12 reconciles its skill-format rules with the
Agent Skills specification.

## `.highway/instructions/highway-agent-context.md`

Consumers:

- `generate-instructions.sh`, which publishes it to `AGENTS.md`,
  `.cursor/rules/highway-agent-context.mdc`, `.claude/CLAUDE.md`, and
  `.github/copilot-instructions.md` (`.instruction-manifest`)
- Tests: `harness-path-map.test.sh`, `storage-contract.test.sh`
- Harness: `selection/shared.txt`

Resolution: drop. highway-experience replaces it (Phase 1), and every skill activates
highway-experience by name first.

- The files it points to (identity, the experience standard, and the storage rules) are already
  in highway-experience.
- Its own two rules move into highway-experience's `SKILL.md`: when a Highway skill applies, defer
  the workflow, artifacts, inputs, outputs, and decisions to that skill; and do not treat Highway
  identity or experience guidance as organizational facts.
- Removed with it: `generate-instructions.sh`, `.instruction-manifest`, and the four generated
  files, `AGENTS.md`, `.cursor/rules/highway-agent-context.mdc`, `.claude/CLAUDE.md`, and
  `.github/copilot-instructions.md`. The tests and harness selection stop referencing them.
- Accepted: an agent working in a Highway project with no Highway skill active no longer gets the
  Highway framing. Agent Plugins has no portable rules; Phase 14 allows client-specific rules as an
  optional extra.

## `.highway/library/governance/README.md`

Consumers:

- Harness: `selection/shared.txt`

Resolution: drop in Phase 4. It describes a folder that Phases 7 to 11 empty and remove. The
harness selection stops listing it.

## `.highway/library/knowledge/README.md`

Consumers:

- Harness: `selection/shared.txt`

Resolution: drop in Phase 4. It describes a folder that Phases 7 to 11 empty and remove. The
harness selection stops listing it.

## `.highway/library/knowledge/frontmatter-lexicon.txt`

Consumers:

- `lib/frontmatter-lexicon.sh`, loaded by `validate-skill.sh`
- Harness: `selection/shared.txt`
- `governance-plan.md`

Resolution: move to `framework/frontmatter-lexicon.txt`. It never ships. `lib/frontmatter-lexicon.sh`,
the harness selection, and `governance-plan.md` point to the new path. Phase 12 checks that the closed
word list does not block descriptions written in the words a person would use.

## `.highway/library/templates/README.md`

Consumers:

- Harness: `selection/shared.txt`

Resolution: drop in Phase 4. It describes a folder that Phases 7 to 11 empty and remove. The
harness selection stops listing it.

## `.highway/skills/_authoring-standard.md`

Consumers:

- `validate-skill.sh`, `generate-catalog.sh`, `lib/frontmatter.sh`
- Tests: `authoring-standard.test.sh`
- `.highway/governance/constitution.md`, `.highway/DISTRIBUTION.md`,
  `.highway/catalog/README.md`, `.highway/tools/README.md`
- `README.md`, `governance-plan.md`

Resolution: move to `framework/authoring-standard.md`. It never ships. The leading underscore kept
it from being read as a skill while it sat among the skills; outside `skills/` it is not needed.
The validators, test, and documents point to the new path.

## `.highway/tools/`

Contents:

- `tests/`: the bash suite and its fixtures, 265 of the folder's 294 files
- Generators: `generate-agent-adapters.sh`, `generate-catalog.sh`, `generate-distribution.sh`,
  `generate-instructions.sh`, `generate-library-catalog.sh`
- Validators: `validate-skill.sh`, `validate-library.sh`, `validate-profile.sh`
- One-off audits: `audit-objective-rename.sh`, `audit-profile-migration.sh`
- `seed-library-context.sh`
- `lib/`: 12 shared shell helpers
- Manifests: `.adapter-manifest`, `.distribution-manifest`, `.frontmatter-contract`,
  `.instruction-manifest`, `.objective-rename-allowlist`
- `README.md`

Consumers:

- The bash suite and the people who run it
- Harness: `bin/path-map.sh`, `test/runner.test.ts`, `test/select.test.ts`, `README.md`
- `.specify/memory/constitution.md`
- The distribution: `.distribution-manifest` ships `.highway/tools/` to users today, without
  `tests/`, the distribution generator, and the rename audit

Resolution: split by role. Nothing in it ships.

- `tests/` moves to `tests/` at the repository root. The harness path map and harness tests
  follow it.
- Moving to `framework/`:
  - the generators `generate-agent-adapters.sh`, `generate-catalog.sh`, and
    `generate-distribution.sh`;
  - the validators `validate-skill.sh` and `validate-profile.sh`;
  - `lib/`;
  - the manifests `.adapter-manifest`, `.distribution-manifest`, and `.frontmatter-contract`.
  - Phase 14 replaces `generate-distribution.sh` and `.distribution-manifest` with the plugin
    build, and stops the per-agent copies.
- `validate-library.sh` merges into `validate-skill.sh`. The files it checked now sit in skill
  `references/` and `assets/`, so a skill's validation covers them with the same checks.
- Dropped:
  - `generate-library-catalog.sh`, with the library index;
  - `generate-instructions.sh` and `.instruction-manifest`, with the always-on instructions;
  - `seed-library-context.sh`, which copies three root files that no longer exist;
  - `audit-objective-rename.sh`, `audit-profile-migration.sh`, and `.objective-rename-allowlist`,
    whose migrations are finished;
  - the tests for each of these.
- `README.md` merges into `framework/README.md`.

# Phase 4: Removals

Goal: remove the files Phase 3 drops that nothing else depends on, before any move, so later
phases convert and move fewer files.

1. Remove the library index: `library-index.json`, `library-index.md`,
   `generate-library-catalog.sh`, and its test. The other tests,
   `.specify/memory/constitution.md`, and the READMEs stop referencing it.
2. Remove the three library READMEs and `.highway/catalog/README.md`. The harness selection and
   the generators stop referencing them.
3. Remove `.highway/catalog/index.md`, the `overlap_flags` field, and `generated_at`.
   highway-help drops its "When not to use" line about `overlap_flags`.
4. Remove `audit-objective-rename.sh`, `audit-profile-migration.sh`,
   `.objective-rename-allowlist`, `seed-library-context.sh`, and their tests.
5. Delete the `.DS_Store` files.

Not in this phase: the always-on instructions wait for highway-experience (Phase 7), and
`validate-library.sh` waits until the library is empty (Phase 11).

Exit: the removed files are gone, nothing references them, and the full suite passes.

Status: complete in `specs/233-standard-alignment-removals/`. The suite went from 92 tests to 88.
Beyond the steps above:
- The distribution manifest lost its rows for the three missing root context files that only the
  seeding script read.
- `.specify/memory/constitution.md` is 3.0.0: D4.2 and D4.7 no longer allow a timestamp
  difference.
- highway-help is 3.1.1.

# Phase 5: Path Indirection

Goal: every bash test and framework script finds files through one paths helper, so a later move
changes the helper, not every test. Nothing moves in this phase.

1. Retire the tests whose only purpose is regression checking, before converting any test, so
   none is converted only to be deleted later. Record each dropped assertion as superseded, or keep
   it in a remaining test, as Phase 4 did.
   - Remove the tests that only guard a finished change:
     - `profile-yaml.test.sh` guards the removed `profile.yaml` template.
       `profile-template-migration.test.sh` repeats that check.
     - `path-integrity.test.sh` guards against paths from before the `.highway/` relocation.
       Phase 6 changes the layout it scans.
   - Remove the tests that check past-feature evidence files rather than behavior, with the
     fixtures only they read:
     - `feature-092-correspondence.test.sh`, with
       `fixtures/profile-092/dependent-artifact-inventory.tsv` and `impact-review.tsv`.
       `adapter-coverage.test.sh` already checks the generated files it names.
     - `profile-adaptive.test.sh`, with `fixtures/profile-091/adaptive-corpus.md`.
   - Reduce the tests that are mostly regression checks to their current-behavior assertions, or
     remove them when nothing remains:
     - `profile-template-migration.test.sh`: drop the obsolete template checks.
     - `experience-standard-amendment.test.sh`, `feature-141-experience-standard-refactor.test.sh`,
       and `experience-standard-convergence.test.sh` repeat the same 64-rule count, the same
       retired-rule and removed-section checks, and two exact version pins. Keep one copy of each
       current check, in one test. Drop the exact version pins and the protected-path check,
       which can never fail.
     - `constitution-experience-alignment.test.sh`: drop the exact version line and the checks
       that removed text stays absent.
     - `runtime-contract-hygiene.test.sh`: covers only highway-profile and highway-setup.
       `shipped-tree-independence.test.sh` covers its `specs/` and `.specify/` checks for the whole
       distribution. Drop the test, and record its `FR-` and `Feature NNN` scan as superseded.
   - Remove every exact skill and template version check from the remaining tests: 34 tests,
     about 90 checks. A version bump then fails no test by itself, and the validator still checks
     the version's form and that the Example matches the frontmatter.
2. Add one paths helper that defines where the skills, the framework, the tests, the governance
   files, and each template live.
3. Every bash test and framework script sources the helper instead of building paths from
   `HIGHWAY_ROOT`. Before step 1, 87 of the 88 tests build their own paths: 44 name `skills/`,
   34 name `tools/`, and 31 name `library/templates/`.
4. The harness reads the same locations through `bin/path-map.sh`.
5. A bash check fails when a test or framework script builds a path to a moved location without
   the helper.

Exit: no regression-only test remains, every dropped assertion is accounted for, no test or
framework script names a skill, tool, governance, or template path except through the helper, and
the full suite passes.

Status: complete in `specs/234-standard-alignment-path-indirection/`. The suite went from 88 tests
to 82: seven removed, `path-construction.test.sh` added. Beyond the steps above:
- The exact version checks removed came to 89 in 30 tests; `dropped-assertions.md` in the spec
  lists each one.
- The helper is `.highway/tools/lib/paths.sh`. Tests reach it through `.highway/tools/tests/paths.sh`
  and harness scripts through `harness/bin/lib/paths.sh`; each shim is one `source` line.
- `harness/bin/path-map.sh --location <skills|tools>` gives the TypeScript harness the same
  locations.
- `.specify/memory/constitution.md` is 3.1.0: D2.5, decided by `path-construction.test.sh`,
  requires every script to get repository locations from the helper.

# Phase 6: Relocate the Framework, Tests, and Skills

Goal: the repository has the Phase 3 layout. The move is mechanical: no `SKILL.md` content
changes.

1. `.highway/tools/tests/` moves to `tests/`.
2. The rest of `.highway/tools/` moves to `framework/`. `.highway/governance/constitution.md`,
   `.highway/skills/_authoring-standard.md` (as `authoring-standard.md`), and
   `.highway/library/knowledge/frontmatter-lexicon.txt` move to `framework/`.
3. `.highway/DISTRIBUTION.md` becomes `framework/README.md`, with `.highway/tools/README.md`
   merged in and its paths and sections updated (Phase 3).
4. Each `.highway/skills/<id>/` moves to `skills/<name>/`. Skills still read `.highway/library/`
   and `.highway/governance/`, which remain until later phases empty them.
5. The paths helper, the harness path map, the generators, highway-help's index, and the
   documents follow the moves.

Exit: `skills/`, `tests/`, and `framework/` hold their Phase 3 contents, no `SKILL.md` body
changed, and the full suite passes.

Status: complete in `specs/235-standard-alignment-relocation/`. The suite stays at 82 tests, all
passing, and the harness tests at 75. Beyond the steps above:
- The framework no longer ships. Skills ship from `skills/` to `.highway/skills/`, and packaging
  validates them with `framework/validate-skill.sh` from a verification tree: the distribution
  plus `framework/`, with the skills moved back to `skills/`.
- `framework/README.md` ships as the distribution's `README.md` until Phase 14.
- The Highway Skills Constitution is 10.1.0 at `framework/constitution.md`; P2.6 and its check
  name `framework/`. The development constitution is 3.2.0.
- `harness/bin/path-map.sh --location <skills|framework>` replaces `--location tools`; `tests/`
  selects no scenario.
- The committed test leftovers are gone, and the three tests that add temporary skills or adapter
  rows remove them on exit.

# Phase 7: highway-experience

Goal: every skill gets identity, the output standard, and the storage rules by activating
highway-experience, and the always-on instructions are gone.

1. Create highway-experience (Phase 1): `references/highway-identity.md`,
   `references/experience-standard.md`, and `references/storage-contract.md`, with a
   description written for its supporting role and a short Highway summary when invoked directly.
2. Split the storage contract (Phase 1): the fixed rules go to highway-experience; the mode becomes
   a project record, and no record means Local.
3. The storage contract separates reading a skill's own bundled files, and activating
   highway-experience, from the four repository operations, which still govern every read and
   write of the project.
4. Every skill activates highway-experience by name as its first step and drops its paths into
   `.highway/governance/` and `.highway/library/knowledge/highway-identity.md`.
5. The always-on instructions' two own rules move into highway-experience's `SKILL.md`.
6. Remove the always-on instructions, `generate-instructions.sh`, `.instruction-manifest`, and
   the four generated files. No skill depends on them: a skill behaves the same whether or not
   `AGENTS.md` or an agent rule file exists.
7. A harness invariant checks that highway-experience loads before a skill's first output.

Exit: no skill reads `.highway/governance/`, no always-on file exists, and the full suite and
harness pass.

Status: complete in `specs/236-standard-alignment-experience/`. The suite went from 82 tests to 81,
all passing, and the harness tests from 75 to 77. Beyond the steps above:
- The project's mode record is `library/knowledge/storage.md`. A record naming a mode other than
  Local stops the skill before any other repository read or write. Nothing writes the record yet.
- The activation step is one sentence, identical in every skill, as the first line of its
  Procedure. `tests/experience-activation.test.sh` checks it, and highway-help gains a Procedure
  for it. Each of the 15 skills took a MINOR version.
- The adapter generator copies every file in a skill folder, so each agent tree holds
  highway-experience's `references/`.
- The harness records the skills loaded before the first output and fails a run with
  `experience-order` when highway-experience is not among them. Every file under
  `skills/highway-experience/` selects the smoke set, which gains `experience-smoke`.
- `framework/lib/paths.sh` declares `HW_EXPERIENCE`, and `hw_doc` resolves the three references
  there. The governance, instruction, and always-on variables are gone.
- The frontmatter lexicon gains the words highway-experience's description and usage need.
- The Highway Skills Constitution is 10.2.0 and the development constitution is 3.3.0.

# Phase 8: Catalog Seeding

Goal: highway-setup guarantees every catalog exists (Phase 1 catalog rule), and each catalog's
rules live in the skills that write it.

1. highway-setup's `assets/` holds the skeletons of the 11 seeded catalogs and the storage record.
   Setup writes each one once when absent and never overwrites.
2. The catalog templates' rules move into the skills that write each catalog. The generator
   inserts each shared rule, the capability title rule and the ADR ID cell format, into every
   skill that states it, from one source, with a drift check.
3. Skills drop their "create the catalog when absent" steps. A skill that must edit a seeded file
   that is still absent follows highway-setup's seeding step for it, then continues.
4. The ownership changes for `codify-platforms.md`, `capability-catalog.md`, `adr-catalog.md`,
   and `architecture-catalog.md` (Phase 1).
5. The three governance catalog templates move to highway-objectives, highway-controls, and
   highway-nfrs `assets/`. They are not seeded.
6. The findings file moves to the project's `library/knowledge/assessment-findings.md` and is
   seeded (Phase 2).
7. The bash fixture checks and harness template assertions compare project files against the
   skeletons.

Exit: a fresh highway-setup run leaves every catalog in place, no catalog template remains in
`.highway/library/templates/`, and the full suite and harness pass.

# Phase 9: Record Templates in Their Skills

Goal: each single-consumer record template lives in the `assets/` of the skill that creates the
record (Phase 2).

1. Move to highway-codify: `codify-metadata.md`, `codify-plan.md`, `codify-record.md`, and
   `codify-tasks.md`.
2. Move `coding-standard.md` to highway-codify-config.
3. Move `control-record.md`, `nfr-record.md`, and `objective-record.md` to their governance skills.
4. Move `discovery-record.md`, `request-record.md`, and `profile-record.md` to their skills.
   highway-profile drops its guards against `.highway/library/knowledge/profile.md`.
5. Each skill names its asset by a path relative to its own folder.

Exit: only `adr-record.md`, `architecture-record.md`, and `implementation-record.md` remain in
`.highway/library/templates/`, and the full suite and harness pass.

# Phase 10: Onboarding Handoffs

Goal: highway-adr, highway-architecture, and highway-implementation are the only creators of their
records, and highway-onboarding hands each record to its owner (Phase 1). This is the only phase
that changes behavior.

1. Move `adr-record.md`, `architecture-record.md`, and `implementation-record.md` to the `assets/`
   of highway-adr, highway-architecture, and highway-implementation.
2. Each of the three gains an onboarding entry step that writes its record as accepted without
   asking the person, with the onboarding rules from highway-onboarding.
3. highway-onboarding drops its ADR-writing section and its architecture and implementation rules,
   and hands each record to its owner.
4. highway-architecture drops the ADR template, and highway-adr drops the architecture template.
5. Close the ADR catalog gap: onboarding and highway-architecture's `name` step leave
   `adrs/adrs.md` in the same state.
6. Harness scenarios cover onboarding end to end, including the chain where highway-implementation's
   `execution` step starts onboarding and returns.

Exit: `.highway/library/templates/` is empty, onboarding produces the same records as before, and
the full suite and harness pass.

# Phase 11: Self-Contained Skills

Goal: no skill reads a file outside its own folder, `.highway/` is gone, and the skills are proven
self-contained before Phase 14 packages them.

1. highway-help's index moves to its `assets/index.json`, with each skill's dependencies and
   Example (Phase 2). highway-help stops reading other skills' folders, and the generator checks
   that each skill's `name` matches its folder.
2. `validate-library.sh` merges into `validate-skill.sh`, which checks each skill's `references/`
   and `assets/`.
3. Each skill names every bundled file by a path relative to its own folder, one level deep.
4. `highway-setup` copies no shipped material into the project.
5. `.highway/` is removed.
6. The harness test project gets the skill folders from `skills/` and holds no shipped material.

Exit: `.highway/` does not exist, no skill reads a file outside its own folder, and the full suite
and harness pass.

# Phase 12: Agent Skills Format Conformance

Goal: every skill passes the Agent Skills specification's rules, enforced by the bash suite.
Runs after Phase 6, when the skills are in their final folders. Independent of Phases 7 to 11.

1. Frontmatter uses only the standard fields:
   - `usage` moves under `metadata`;
   - `compatibility` states real environment requirements, or is left out;
   - add `license`;
   - decide whether to declare `allowed-tools`. It is experimental and support varies, so the
     storage contract, not this field, stays the rule on which tools a skill uses.
2. Frontmatter parses as strict YAML, so a client with a strict parser loads every skill.
3. Each `description` says what the skill does and when to use it, with the words a person would use.
4. Handoff text names the next skill without assuming one way to invoke it.
   Agents differ: `/highway-adr`, `$highway-adr`, and the plugin-namespaced `highway:highway-adr`.
5. `validate-skill.sh` runs on the source folders and enforces every rule in the specification, the
   same checks as `skills-ref validate`:
   - the frontmatter block and strict YAML;
   - `name` format and its match with the folder;
   - `description` and `compatibility` lengths;
   - only the defined fields, and `metadata` values as strings.
6. The development constitution names the Agent Skills specification as the authority on skill format,
   and replaces its own frontmatter rules that conflict with it.

Exit: every skill passes the specification's validation in the bash suite.

# Phase 13: Progressive Disclosure

Goal: each `SKILL.md` meets the specification's size guidance,
with detail moved into `references/` that the skill loads only when it needs it.
Runs after Phase 11, once Phases 7 to 10 have changed the skills; the sizes below are from before
them and are measured again at the start.

1. Targets: under 500 lines and about 5,000 tokens for each `SKILL.md`.
   - Over 500 lines: highway-codify (744).
   - Over 5,000 tokens: highway-codify (about 13,300), highway-implementation (7,400),
     highway-codify-config (6,600), highway-onboarding (6,300), highway-adr (6,200),
     highway-discovery (5,900), and highway-nfrs (5,400).
2. Move step detail, examples, and edge cases into `references/`, one level deep from `SKILL.md`.
   `SKILL.md` keeps the steps, the decisions, and when to load each reference.
3. Verification and Error Handling stay in `SKILL.md`, so harness coverage still reads them.
4. A bash check warns on a `SKILL.md` over either target.

Exit: every `SKILL.md` is under both targets, or has a recorded reason it is not,
and the harness passes on the affected skills.

# Phase 14: Agent Plugins Package

Goal: the generator builds `highway-agent-plugin/`, one Agent Plugins 1.0 plugin, from the source
skill folders. That folder is tested as installed and is what the public repository publishes.

1. The generator builds `highway-agent-plugin/`:
   - `plugin.json` with the 1.0.0 `$schema`, name `highway`, description, version, license, and
     the public repository as `repository` and `homepage`;
   - `skills/<name>/` for each Highway skill, including highway-experience, copied byte for byte
     from the source;
   - the public repository's `README.md` and `LICENSE`, copied from `framework/plugin/`;
   - nothing else: no specs, tests, harness, tooling, or path into this private repository.
2. The build is reproducible: the same sources always build the same bytes, with no timestamps.
3. The plugin layout replaces the distribution manifest. What ships is exactly `plugin.json`,
   `skills/`, and the public `README.md` and `LICENSE`.
4. The generator stops emitting the per-agent skill copies into the distribution.
5. Client-specific extras are optional and sit outside the portable core:
   - always-on instructions and rules, under the client's reverse-domain extension namespace
     or its own plugin format;
   - a Claude Code manifest, if Claude Code needs one to install the plugin.
6. `highway-agent-plugin/` is committed and regenerated, never edited by hand. Bash checks:
   - validate `plugin.json` and the plugin layout against the specification;
   - run the Agent Skills validation from Phase 12 on every skill in `skills/`;
   - fail when the folder differs from a fresh build;
   - fail when the folder holds anything outside the shipped set.
7. Publishing pushes `highway-agent-plugin/` to the public repository, with the folder as its
   root. The spec decides the mechanism, such as a subtree split or a release job that copies
   the folder. Each release bumps `version` in `plugin.json`.
8. The harness installs the built plugin into the test project, the same way a person would.

Exit: the built plugin loads in an agent that supports Agent Plugins, every skill in it passes
Agent Skills validation, the harness passes from that install, and the folder holds only the
shipped set.
