# Research: Organize Profile Context

## Decision: Keep both versions

**Decision**: The Profile skill stays at metadata version 4.0.0. The shared record stays at template version 3.0.0 and `schema_version` 3.0.0.

**Rationale**: The Skill Versioning Policy treats a breaking contract change as MAJOR and an added capability as MINOR. This change reorganizes sections and removes duplicated interaction rules. Readiness, the canonical questions, the website trust boundary, acceptance, operations, inputs, and outputs stay in force. Optional Context does not change the four domain outcomes. A schema 3.0.0 record with no Context section still conforms, so the addition does not invalidate a current record.

**Alternatives considered**: Bumping the template to 3.1.0 because a heading group was added. Rejected because an omitted optional section does not make a current record fail. Bumping the skill to 4.1.0 or 5.0.0. Rejected because no capability is added and no existing contract element is removed.

## Decision: Peer behavior sections

**Decision**: Replace `## Evidence` with four peer sections: `## Profile model`, `## Acquisition`, `## Enrichment`, and `## Operations`.

**Rationale**: The spec requires those four names and the removal of the single Evidence block. A third-level heading would nest under Outputs. Peer sections keep each block inside the skill size limits and make the acquisition order its own section.

**Alternatives considered**: Four subsections under `## Evidence`. Rejected because the spec removes that single block. Four third-level headings with no new parent. Rejected because they would attach to Outputs.

## Decision: Context lives in the template guidance

**Decision**: The template's structural guidance owns `## Context` and the child sections `### Repository Name`, `### Organization Name`, `### Organization URL`, and `### Organizational Context`. The default template body does not emit those headings. A retained record emits `## Context` only after readiness narratives, and only with the children that have accepted values.

**Rationale**: Domain headings already live in that guidance and are omitted when `not_discussed`. Empty Context would be a placeholder, which the spec forbids. The skill cites the template and does not repeat the heading skeleton. The structural helper matches domain headings on a whole line, so guidance lines that mention those headings do not become false narratives.

**Alternatives considered**: Putting empty Context headings in the template body. Rejected because the default record has no accepted optional context. Leaving the skeleton only in the skill. Rejected because the spec gives that structure to the shared record.

## Decision: Do not change the structural helper

**Decision**: `.highway/tools/lib/profile.sh` and `.highway/tools/validate-profile.sh` stay on schema 3.0.0 and the four domain keys.

**Rationale**: Context is not a domain outcome. The helper already ignores headings that are not the four domain headings. A `## Context` section after the narratives does not change domain order or readiness. No new validation check is enabled.

**Alternatives considered**: Teaching the helper to require or forbid Context. Rejected because absence is valid and presence does not affect readiness.

## Decision: One Experience sentence

**Decision**: The Experience section is exactly `User-visible interaction follows the Highway Experience Standard.` The sentence that the Experience Standard remains the normative authority is removed from the skill.

**Rationale**: Clarification on 2026-09-29 chose one sentence that only states that user-visible interaction follows the Highway Experience Standard. The Experience Standard document is not amended. Checks that still require the authority sentence inside the Profile skill are updated and name that sentence as superseded.

**Alternatives considered**: Keeping both current sentences. Rejected by the clarification. Folding the authority sentence into the new sentence. Rejected because the chosen answer is the follow sentence alone.

## Decision: No Intent Summary and no brownfield edit

**Decision**: Do not create a Highway Profile Intent Summary. Do not edit a Brownfield Onboarding Idea.

**Rationale**: No document with the Intent Summary title is in the repository. The spec updates that document only when it is present. Brownfield onboarding is a later review and is out of scope. Profile does not gain a technology or platform inventory.

**Alternatives considered**: Creating the Intent Summary so the spec's update has a target. Rejected because the spec says not to create it. Rewriting brownfield Profile text in this change. Rejected because the spec leaves that review for later.
