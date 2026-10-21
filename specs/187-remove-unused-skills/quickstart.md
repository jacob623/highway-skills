# Quickstart: Remove Unused Skills

Validate this removal after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `187-remove-unused-skills`
- The four skills still present at the start of the work

## Confirm the skills are gone

1. Confirm these directories are absent: `.highway/skills/highway-clarify`, `highway-inquiry`, `highway-relationships`, and `highway-new`.
2. Confirm the same four names are absent under `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/`.
3. Confirm `.highway/catalog/index.md` does not list them.
4. Confirm `.highway/tools/.distribution-manifest` has no `include` row for them.

## Confirm the templates

1. Confirm these files are absent: `.highway/library/templates/output/clarification-record.md`, `clarification-catalog.md`, and `.highway/library/templates/requirements-inquiry.md`.
2. Confirm `.highway/library/templates/output/request-record.md` and `request-catalog.md` are unchanged.
3. Confirm `.highway/skills/highway-request/SKILL.md` still cites both request templates. See [contracts/removal.md](contracts/removal.md).

## Confirm what stays

1. Confirm `.highway/governance/constitution.md`, `.specify/memory/constitution.md`, and `.highway/governance/experience-standard.md` have no content diff.
2. Confirm `.highway/skills/highway-discovery/SKILL.md` is unchanged.
3. Run `.highway/tools/tests/run-all.sh` from the repository root. The expected result is exit 0.
