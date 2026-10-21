# Research: Promote Rewritten Skills

## Decision: Use the sibling draft suite as the only behavior source

- **Decision**: Copy skill behavior and catalog shape from the sibling folder `highway-skills-v2`. Do not transcribe the interaction into this spec.
- **Rationale**: The maintainer selected that folder during clarification. The drafts already contain the interaction, catalogs, and statuses.
- **Alternatives considered**: Rewriting the skills again inside this repository was rejected because the spec forbids redesign. Using the skills already in `.highway/skills/` was rejected because those are the previous interaction.

## Decision: Promote twelve skills and reserve the old request name

- **Decision**: Map drafts to source skills as follows. `request.md` becomes `.highway/skills/highway-request/SKILL.md`. `.highway/skills/highway-new/SKILL.md` stays so the name remains reserved, and its body stops collecting a request. It tells the person to invoke `highway-request` and writes nothing. The transcript `fullsuite-copilot-gemini.md` is not promoted.

| Draft | Source skill |
|---|---|
| `profile.md` | `highway-profile` |
| `objectives.md` | `highway-objectives` |
| `controls.md` | `highway-controls` |
| `nfrs.md` | `highway-nfrs` |
| `setup.md` | `highway-setup` |
| `request.md` | `highway-request` |
| `discovery.md` | `highway-discovery` |
| `adr.md` | `highway-adr` |
| `architecture.md` | `highway-architecture` |
| `implementation.md` | `highway-implementation` |
| `onboarding.md` | `highway-onboarding` |
| `assessment.md` | `highway-assessment` |

- **Rationale**: The spec lists these twelve skills. Leaving `highway-new` able to collect a request would keep the previous request workflow available.
- **Alternatives considered**: Deleting `highway-new` was rejected because the spec says that name stays reserved. Replacing `highway-new` with the request draft was rejected because the rewritten skill has its own name.

## Decision: Update shared templates in place, using the repository's existing file names

- **Decision**: The draft catalog files replace the content of the existing output templates. File names in `.highway/library/templates/output/` stay as they are. Draft `objectives-catalog.md` updates `objective-catalog.md`. Draft `controls-catalog.md` updates `control-catalog.md`. Draft `nfrs-catalog.md` updates `nfr-catalog.md`. The request, discovery, ADR, architecture, and implementation catalog drafts update the matching `*-catalog.md` templates. `assessment-findings.md` updates that template. Record templates change only where a promoted skill's written shape no longer matches them. The capability catalog has no separate draft; `.highway/library/templates/output/capability-catalog.md` is updated to the columns and identifier rules in `implementation.md`, including removal of `Next ID` and of sequential `CAP######` allocation.
- **Rationale**: Skills cite the existing template paths. Renaming those files would break every citation. The capability catalog is specified by the implementation draft.
- **Alternatives considered**: Adding a second set of plural catalog filenames was rejected because the skills and tests already cite the singular template names.

## Decision: Retire interaction checks and edit mixed checks

- **Decision**: A test whose assertions only require the previous skill interaction is removed. A test that also protects authoring, a constitution, the experience standard, or a shared template is edited so only the obsolete assertions are removed. Each removal is recorded in `specs/186-promote-skill-rewrites/retirements.md` with the superseded behavior. Readiness assertions inside promoted skills are superseded because those skills no longer report readiness. Checks that do not read a promoted skill stay. `highway-clarify`, `highway-help`, `highway-relationships`, and `highway-inquiry` stay, along with their checks.
- **Rationale**: The spec requires obsolete interaction checks to go and still-valid governance checks to pass. Deleting a mixed file would drop those governance checks.
- **Alternatives considered**: Updating every old conversation test to the new wording was rejected because that recreates transcript locks. Deleting the whole test directory was rejected because constitution, experience, authoring, and generator checks must remain.

## Decision: Add invariant checks before treating the promotion as complete

- **Decision**: New shell checks cover identifier shape, reuse of the same title, collision handling, one Decision per Discovery, absence of a platform, product, vendor, or named technology in a Reference Architecture, and the status vocabularies in the spec. They are run once against the current skills and the failure is recorded before the drafts replace those skills.
- **Rationale**: The constitution requires a behavioral check to be seen failing before the behavior is complete. The spec limits these checks to invariants and excludes transcript locks.
- **Alternatives considered**: Checking the invariants only by reading the skill text was rejected because a static document check cannot by itself satisfy the behavioral evidence rule.

## Decision: Regenerate published copies; do not hand-edit them

- **Decision**: After the sources and templates are valid, run the declared generators. Confirm each declared agent tree matches the source skill and that `highway-request` has a catalog entry and an adapter in each tree.
- **Rationale**: Generated adapters are the product surface. Hand edits drift from the source.
- **Alternatives considered**: Copying `SKILL.md` into the agent trees by hand was rejected because those trees are generated artifacts.
