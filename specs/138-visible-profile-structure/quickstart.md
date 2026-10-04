# Quickstart: Visible Profile Structure

## Prerequisites

- Repository root is the Highway skills repository.
- Bash 3.2-compatible shell.
- No new packages.

## Validate the template

1. Open `.highway/library/templates/output/profile-record.md`.
2. Confirm template metadata version `3.1.0`, description `Complete output skeleton for retained organizational Profile evidence.`, and sections `## File Frontmatter` and `## Body`.
3. Confirm the fenced frontmatter contains `schema_version: 3.0.0` and the four `domains` keys.
4. Confirm the fenced body contains `# Organizational Profile`, the four retained domain headings, and optional Context children in the contract order.
5. Confirm the rendering sentences in [contracts/profile-record.md](contracts/profile-record.md) are present and the old hidden HTML comment is gone.
6. Confirm `validate-profile.sh` rejects the template file and still accepts a retained empty-profile fixture.

## Validate the skill

1. Open `.highway/skills/highway-profile/SKILL.md`.
2. Confirm `metadata.version` is `7.0.0` and the retained path is `.highway/library/knowledge/profile.md`.
3. Confirm the required sentences in [contracts/profile-skill.md](contracts/profile-skill.md) are present.
4. Confirm the duplicate website-only acquisition sentence, literal `<br>`, and malformed persistence fragment are absent.
5. Confirm generated adapters match the source and catalog metadata shows `7.0.0`.
6. Confirm the library catalog shows template version `3.1.0` and the new description.

## Commands

```bash
bash .highway/tools/tests/profile-structure.test.sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: each command exits 0. A failure that names a superseded template-as-profile assertion is expected only before that assertion is retargeted to a retained fixture.
