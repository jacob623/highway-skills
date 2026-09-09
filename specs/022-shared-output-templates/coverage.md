# Feature 022 Requirement Coverage

| Requirement | Satisfying artifact | Evidence |
|---|---|---|
| FR-001 | `.highway/governance/constitution.md` | P9.1 requires every file-emitting skill to cite a complete shared template. |
| FR-002 | `.highway/governance/constitution.md` | P9.1 is under Principle IX, tagged `[auto]`, with an Outputs-section observable. |
| FR-003 | `.specify/memory/constitution.md` | D8.1 requires review of every skill citing a changed shared library artifact. |
| FR-004 | `.specify/memory/constitution.md` | D8.1 requires complete frontmatter/body re-validation and reports mismatches. |
| FR-005 | `.highway/library/templates/output/` | Output skeletons are separated from `requirements-inquiry.md`. |
| FR-006 | `.highway/library/templates/output/nfr-record.md` | NFR fields and statement/rationale body are preserved. |
| FR-007 | `.highway/library/templates/output/control-record.md` | Control fields and statement/rationale body are preserved. |
| FR-008 | `.highway/skills/highway-nfrs/SKILL.md` | Outputs cites `nfr-record.md` instead of restating its structure. |
| FR-009 | `.highway/skills/highway-controls/SKILL.md` | Outputs cites `control-record.md` instead of restating its structure. |
| FR-010 | `.highway/tools/tests/output-template.test.sh` | Contract assertions cover fields, body sections, and placeholders. |
| FR-011 | `.highway/skills/highway-nfrs/SKILL.md` and generated artifacts | Both skills are PATCH-bumped to 1.0.1 and catalogs/adapters regenerated. |
| FR-012 | Governance constitution Sync Impact Reports | P9.1, X1.5, and D8.1 amendments record version and self-application review. |
| FR-013 | `.highway/tools/tests/output-template.test.sh` | Both affected skills and templates pass before the new citation rule is enabled. |
| FR-014 | `.highway/library/templates/output/` | Placeholder values are explicitly user-owned and not semantically judged. |
| FR-015 | `.highway/governance/experience-standard.md` | X1.5 requires frontmatter on retained files and excludes transient output. |
