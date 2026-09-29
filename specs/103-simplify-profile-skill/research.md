# Research: Simplify the Profile Skill

## 1. Where the contract lives

**Decision**: Rewrite `.highway/skills/highway-profile/SKILL.md` and `.highway/library/templates/output/profile-record.md`. Update `.highway/tools/lib/profile.sh` and `.highway/tools/validate-profile.sh` so structural classification matches the template. The skill does not name the validator script.

**Rationale**: The skill is the behavior a person and an agent follow. The template is the retained record. The helper already decides whether a file has the required frontmatter, schema, domains, and narrative rules. Leaving that helper on schema 2.0.0 and five domains would reject every new Profile. Putting the script name back into the skill would violate the requirement that Profile not instruct a validator run.

**Alternatives considered**: Delete the validator and leave classification as prose only. The existing Profile tests execute the helper, and usability still has to be decidable. Retargeting the helper keeps that decision executable while the skill stays free of the script name.

## 2. Schema 2.0.0

**Decision**: The only supported schema is 3.0.0. A retained Markdown Profile at schema 2.0.0 is unsupported, Blocked, and left byte-for-byte unchanged. Profile does not read its domains as current evidence, migrate it, or rewrite it. An obsolete YAML Profile stays ignored. The unsupported example used by tests moves off 3.0.0, because 3.0.0 is now valid.

**Rationale**: The 2026-09-29 clarification says Profile is still in development and no backward compatibility is required. The failure model already blocks an unsupported schema without mutation.

**Alternatives considered**: Read the four domains out of a 2.0.0 file and save schema 3.0.0 on the next accept. That is a migration. Keep 2.0.0 readable beside 3.0.0. That is a second supported schema.

## 3. Optional context

**Decision**: Optional context is body Markdown, rendered only when accepted, under these headings: `## Repository Name`, `## Organization Name`, `## Organization URL`, and `## Organizational Context`. These headings are not domain keys and do not appear in the domain map. An absent value omits its heading. No placeholder is written.

**Rationale**: The specification requires Markdown rather than YAML, and it requires omission instead of a placeholder. Fixed headings make presence and absence checkable without adding readiness fields.

**Alternatives considered**: Frontmatter keys for the three names. That stores optional context as structured fields beside the domain map and makes an empty key look like a placeholder. A single free-form section for every optional fact. That hides which of the three named values was accepted.

## 4. What the skill stops repeating

**Decision**: The Experience section stays two sentences: Profile follows the Highway Experience Standard, and that standard remains the normative authority. Remove the rest of that section, the eight-step workflow, and the per-step failure table. Keep order only for classifying the retained record, acquiring context, accepting evidence, persisting, and reporting readiness. Failure text lists only the unsupported schema, the obsolete YAML Profile, and the malformed record.

**Rationale**: Those removed passages restate interaction and failure behavior the Experience Standard and the common failure model already own. The authority sentence is the citation the current Profile contract test requires.

**Alternatives considered**: Leave the presentation labels in the skill so the alignment test keeps passing without an edit. That keeps the restatement this feature removes. The alignment assertions that require those removed labels are updated, and the comment names that superseded restatement.

## 5. Versions and generated copies

**Decision**: Skill `metadata.version` becomes 4.0.0. Template `metadata.version` and `schema_version` become 3.0.0. Content edits do not bump the schema again. After the source edits, regenerate agent copies and the library catalog. Do not hand-edit generated files.

**Rationale**: The skill contract breaks, so the skill version is major. Removing a domain breaks the retained record, so the schema is major. Generated copies and the catalog entry that still says template 2.0.0 would ship the old contract.

**Alternatives considered**: Bump only `schema_version` and leave the template metadata at 2.0.0. The catalog reports that metadata version, so the shipped template would still announce 2.0.0.
