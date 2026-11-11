# Dropped-Assertion Record: Standard Alignment Path Indirection

Every assertion that left a test in spec 234, with its disposition: **kept** (another test holds
it), **consolidated** (a duplicate; one test keeps the shared check), or **superseded** (the
behavior it guarded is finished, and no current behavior depends on the check). Decisions are in
[research.md](research.md) R1 to R3.

## Removed tests

| Test | Assertion | Disposition |
|---|---|---|
| `profile-yaml.test.sh` | The removed YAML Profile output template does not exist | Superseded: guards the finished Feature 026 removal |
| `profile-yaml.test.sh` | No runtime fallback names the removed YAML template | Superseded: same |
| `path-integrity.test.sh` | No `tools/<name>.sh`, `tools/.adapter-manifest`, or `](tools/`, `](skills/`, `](catalog/` reference under `.highway/` outside a `.highway/`-prefixed path | Superseded: guards the finished Feature 010 relocation. Path construction in scripts is now decided by `path-construction.test.sh` (D2.5) |
| `path-integrity.test.sh` | A seeded stale reference is detected | Superseded with the check it proved |
| `feature-092-correspondence.test.sh` | The Feature 092 inventory and impact review exist and are non-empty | Superseded: past-feature evidence files |
| `feature-092-correspondence.test.sh` | The inventory names `generate-agent-adapters.sh`, `generate-catalog.sh`, and `PASS` | Superseded: same |
| `feature-092-correspondence.test.sh` | `.adapter-manifest`, `.distribution-manifest`, and `catalog/index.json` exist | Kept: `adapter-coverage.test.sh` reads all three |
| `profile-adaptive.test.sh` | The Feature 091 corpus names four organization sizes | Superseded: past-feature evidence file |
| `profile-adaptive.test.sh` | The corpus covers multiple domains and deterministic rendering | Superseded: same |
| `runtime-contract-hygiene.test.sh` | No `FR-` or `Feature NNN` identifier, or feature-folder plan path, in highway-profile, highway-setup, or the Profile template | Superseded (FR-004) |
| `runtime-contract-hygiene.test.sh` | No `specs/` or `.specify/` reference in the same files | Kept: `shipped-tree-independence.test.sh` |
| `runtime-contract-hygiene.test.sh` | highway-profile and highway-setup have a well-formed `metadata.version` | Kept: `validate-skill.sh` (P7.2), run by every skill test |
| `experience-standard-amendment.test.sh` | Section headings, rule rows X2.36, X2.37, X2.38, X2.41 | Consolidated: `experience-standard-convergence.test.sh` |
| `experience-standard-amendment.test.sh` | 64 Experience Standard rules | Consolidated: `experience-standard-convergence.test.sh` |
| `experience-standard-amendment.test.sh` | No development-governance term in the Experience Standard | Consolidated: `experience-standard-convergence.test.sh` |
| `experience-standard-amendment.test.sh` | `Layer 2` and `**Version**` lines name 11.1.0 | Superseded: exact version |
| `experience-standard-amendment.test.sh` | Retired rules X2.8, X2.14, X2.23, X2.25, X2.26, X2.39, X2.40 absent | Superseded: guards finished retirements |
| `experience-standard-amendment.test.sh` | `Historical amendment record`, `## Candidates`, and four Non-Normative Guidance headings absent | Superseded: guards finished removals |
| `experience-standard-amendment.test.sh` | Protected paths unchanged unless the constitution names `Version change: 6.1.0` | Superseded: the exemption matches the current constitution, so the check cannot fail |
| `feature-141-experience-standard-refactor.test.sh` | 33 rule rows, section headings, X5 heading, three content phrases | Consolidated: `experience-standard-convergence.test.sh` |
| `feature-141-experience-standard-refactor.test.sh` | 64 rules; at least 33 table rows; X5 before the Interaction Model; one boundary-example table with five rows | Consolidated: `experience-standard-convergence.test.sh` |
| `feature-141-experience-standard-refactor.test.sh` | `**Version**` line names 11.1.0 | Superseded: exact version |
| `feature-141-experience-standard-refactor.test.sh` | Four Non-Normative Guidance headings, Context Awareness, `## Candidates`, `Historical amendment record` absent | Superseded: guards finished removals |
| `feature-141-experience-standard-refactor.test.sh` | `Version change: 8.1.0`, `7.2.0`, `8.0.0`, `8.3.0` absent | Superseded: exact version history |

Fixtures removed with them: `fixtures/profile-092/dependent-artifact-inventory.tsv`,
`fixtures/profile-092/impact-review.tsv`, `fixtures/profile-091/adaptive-corpus.md`.

## Reduced tests

| Test | Assertion | Disposition |
|---|---|---|
| `experience-standard-convergence.test.sh` | Rule rows X2.4, X2.13, X2.37, X2.38, X2.41, headings, content phrases, 64 rules | Kept in place (now the consolidated test) |
| `experience-standard-convergence.test.sh` | Retired rules X2.8, X2.14, X2.39, X2.40 absent | Superseded: guards finished retirements |
| `experience-standard-convergence.test.sh` | `CLAR identifiers`, `persisted clarification history`, `## Candidates` absent | Superseded: guards finished removals |
| `highway-ux-alignment.test.sh` | 64 Experience Standard rules | Consolidated: `experience-standard-convergence.test.sh` |
| `constitution-experience-alignment.test.sh` | `**Version**: 10.0.0` line | Superseded: exact version |
| `constitution-experience-alignment.test.sh` | Seven collaborative-interaction phrases, `common failure model`, `this model`, and `\| P13.1 \|` absent | Superseded: guard the finished Feature 146 refactor |
| `constitution-experience-alignment.test.sh` | 64 Experience Standard rules | Consolidated: `experience-standard-convergence.test.sh` |
| `constitution-experience-alignment.test.sh` | No development-governance term in the Experience Standard | Consolidated: `experience-standard-convergence.test.sh` |
| `profile-template-migration.test.sh` | Obsolete Markdown and YAML Profile templates absent | Superseded: guards the finished Feature 092 migration |
| `profile-template-migration.test.sh` | The distribution manifest names no obsolete Profile template | Superseded: same |
| `profile-template-migration.test.sh` | No skill, governance, or library file names the obsolete Markdown template | Superseded: same |
| `constitution-inventory.test.sh` | `Version change: 2.6.0 → 3.0.0 (MAJOR)` present | Superseded: exact version history. The conflict-resolution amendment text it was paired with is kept in place |
| `constitution-inventory.test.sh` | `3.0.1 → 4.0.0 (MAJOR)` and `4.0.0 → 4.1.0 (MINOR)` reports present | Superseded: exact version history |
| `constitution-inventory.test.sh` | `**Version**: 10.0.0`, `**Ratified**`, `**Last Amended**` line | Superseded: exact version |

## Exact version checks removed

Every row is superseded: it pinned the exact version of a skill, an output template, or the Highway
Skills Constitution at the time a change landed. The validator still requires a well-formed
version (P7.2) and an Example that matches the frontmatter (P9.5). 89 checks in 30 tests, plus
the Experience Standard and constitution version lines listed in the tables above. A row ending
in `; do` was the last item of a list; the list stays and now ends at the previous item.

| Test | Removed check |
|---|---|
| `adr-span-progression.test.sh` | `require "$ADR" 'version: 6.0.0'` |
| `adr-span-progression.test.sh` | `require "$ASSESSMENT" 'version: 5.0.0'` |
| `adr-span-progression.test.sh` | `require "$DISCOVERY" 'version: 5.0.0'` |
| `code-project.test.sh` | `require "$CODIFY" 'version: 14.1.0'` |
| `code-project.test.sh` | `require "$IMPL" 'version: 7.9.0'` |
| `code-project.test.sh` | `require "$ONBOARD" 'version: 10.6.0'` |
| `code-project.test.sh` | `require "$RI_RECORD" 'version: 2.3.0'` |
| `code-project.test.sh` | `require "$CDY_RECORD" 'version: 9.1.0'` |
| `codify-closing-guide.test.sh` | `'version: 14.1.0'; do` |
| `codify-closing-guide.test.sh` | `require "$RECORD" 'version: 9.1.0'` |
| `codify-closing-guide.test.sh` | `require "$CATALOG" 'version: 3.0.0'` |
| `codify-config-skill.test.sh` | `'version: 3.5.0'; do` |
| `codify-config-skill.test.sh` | `require "$PLATFORMS" 'version: 2.1.0'` |
| `codify-config-skill.test.sh` | `require "$RECORD" 'version: 9.1.0'` |
| `codify-config-skill.test.sh` | `require "$TASKS" 'version: 6.0.0'` |
| `codify-config-skill.test.sh` | `'version: 14.1.0'; do` |
| `codify-deterministic-steps.test.sh` | `require "$CODIFY" 'version: 14.1.0'` |
| `codify-deterministic-steps.test.sh` | `require "$PLAN" 'version: 2.0.0'` |
| `codify-feature-wording.test.sh` | `require "$CODIFY" 'version: 14.1.0'` |
| `codify-feature-wording.test.sh` | `require "$RECORD" 'version: 9.1.0'` |
| `codify-feature-wording.test.sh` | `require "$TASKS" 'version: 6.0.0'` |
| `codify-feature-wording.test.sh` | `require "$PLAN" 'version: 2.0.0'` |
| `codify-file-layout.test.sh` | `require "$STANDARD_TEMPLATE" 'version: 3.0.1'` |
| `codify-file-layout.test.sh` | `'version: 3.5.0'; do` |
| `codify-file-layout.test.sh` | `'version: 14.1.0'; do` |
| `codify-file-layout.test.sh` | `require "$RECORD" 'version: 9.1.0'` |
| `codify-file-layout.test.sh` | `'version: 6.0.0'; do` |
| `codify-plan-review.test.sh` | `require 'version: 14.1.0'` |
| `codify-platform-catalog.test.sh` | `require "$PLATFORMS" 'version: 2.1.0'` |
| `codify-platform-catalog.test.sh` | `'version: 7.9.0'; do` |
| `codify-platform-catalog.test.sh` | `require "$ONBOARD" 'version: 10.6.0'` |
| `codify-platform-catalog.test.sh` | `'version: 14.1.0'; do` |
| `codify-platform-catalog.test.sh` | `require "$RECORD" 'version: 9.1.0'` |
| `codify-platform-catalog.test.sh` | `require "$TASKS" 'version: 6.0.0'` |
| `codify-platform-prompt.test.sh` | `require "$ONBOARD" 'version: 10.6.0'` |
| `codify-platform-prompt.test.sh` | `require "$IMPL" 'version: 7.9.0'` |
| `codify-platform-prompt.test.sh` | `require "$CONFIG" 'version: 3.5.0'` |
| `codify-products.test.sh` | `'version: 14.1.0'; do` |
| `codify-products.test.sh` | `require "$ADR" 'version: 6.0.0'` |
| `codify-products.test.sh` | `require "$CATALOG" 'version: 3.0.0'` |
| `codify-products.test.sh` | `require "$RECORD" 'version: 9.1.0'` |
| `codify-products.test.sh` | `require "$TASKS" 'version: 6.0.0'` |
| `codify-products.test.sh` | `require "$METADATA" 'version: 2.0.0'` |
| `codify-products.test.sh` | `require "$INTEGRATIONS" 'version: 1.0.0'` |
| `codify-write-refactor.test.sh` | `require_in skill "$skill_body" 'version: 14.1.0'` |
| `config-live-rules.test.sh` | `'version: 3.5.0'; do` |
| `config-live-rules.test.sh` | `require "$TEMPLATE" 'version: 3.0.1'` |
| `configure-handoff.test.sh` | `require "$ONBOARD" 'version: 10.6.0'` |
| `configure-handoff.test.sh` | `require "$IMPL" 'version: 7.9.0'` |
| `configure-handoff.test.sh` | `require "$CONFIG" 'version: 3.5.0'` |
| `delivery-platform-handoff.test.sh` | `require "$CODIFY" 'version: 14.1.0'` |
| `delivery-platform-handoff.test.sh` | `require "$IMPL" 'version: 7.9.0'` |
| `delivery-platform-handoff.test.sh` | `require "$ONBOARD" 'version: 10.6.0'` |
| `delivery-platform-proposal.test.sh` | `grep -Fq 'version: 7.9.0' "$IMPL" \|\| {` |
| `entry-level.test.sh` | `require "$CONFIG" 'version: 3.5.0'` |
| `establish-from-record.test.sh` | `require "$PLATFORMS" 'version: 2.1.0'` |
| `establish-from-record.test.sh` | `require "$RECORD" 'version: 2.3.0'` |
| `establish-from-record.test.sh` | `'version: 7.9.0'; do` |
| `establish-from-record.test.sh` | `require "$ONBOARD" 'version: 10.6.0'` |
| `establish-from-record.test.sh` | `'version: 3.5.0'; do` |
| `establish-from-record.test.sh` | `'version: 14.1.0'; do` |
| `group-realized-capabilities.test.sh` | `require "$CONFIG" 'version: 3.5.0'` |
| `labeled-proposal-lines.test.sh` | `grep -Fq 'version: 3.5.0' "$CONFIG" \|\| {` |
| `nfr-safeguard-rationale.test.sh` | `require 'version: 9.1.0'` |
| `onboarding-technology-capabilities.test.sh` | `require 'version: 10.6.0'` |
| `output-template.test.sh` | `require_text "$NFR_TEMPLATE" "version: 2.0.0"` |
| `output-template.test.sh` | `require_text "$CONTROL_TEMPLATE" "version: 2.0.0"` |
| `platform-starting-point.test.sh` | `require "$CONFIG" 'version: 3.5.0'` |
| `platform-starting-point.test.sh` | `require "$IMPL" 'version: 7.9.0'` |
| `propose-edit-lines.test.sh` | `if ! grep -Fq 'version: 14.1.0' "$CODIFY"; then` |
| `record-purpose-titles.test.sh` | `'version: 5.1.0'; do` |
| `record-purpose-titles.test.sh` | `'version: 7.9.0'; do` |
| `record-purpose-titles.test.sh` | `require "$ARCH_RECORD" 'version: 2.2.0'` |
| `record-purpose-titles.test.sh` | `require "$IMPL_RECORD" 'version: 2.3.0'` |
| `single-noun-capabilities.test.sh` | `'version: 2.1.0'; do` |
| `single-noun-capabilities.test.sh` | `require "$ARCH_RECORD" 'version: 2.2.0'` |
| `single-noun-capabilities.test.sh` | `'version: 7.9.0'; do` |
| `single-noun-capabilities.test.sh` | `'version: 10.6.0'; do` |
| `single-noun-capabilities.test.sh` | `require "$ARCH" 'version: 5.1.0'` |
| `single-noun-capabilities.test.sh` | `require "$CONFIG" 'version: 3.5.0'` |
| `single-noun-capabilities.test.sh` | `'version: 14.1.0'; do` |
| `single-rule-shape.test.sh` | `require "$CONFIG" 'version: 3.5.0'` |
| `single-rule-shape.test.sh` | `require "$TEMPLATE" 'version: 3.0.1'` |
| `standard-starting-point.test.sh` | `require "$CONFIG" 'version: 3.5.0'` |
| `storage-contract.test.sh` | `require "$CONSTITUTION" '**Version**: 10.0.0 \| **Ratified**: 2026-09-06 \| **Last Amended**: 2026-11-09'` |
| `storage-contract.test.sh` | `require "$CONSTITUTION" 'Version change: 9.1.0 → 10.0.0 (MAJOR), 2026-11-09'` |
| `storage-contract.test.sh` | `require "$HELP" 'version: 3.1.1'` |
| `storage-contract.test.sh` | `require "$CODIFY" 'version: 14.1.0'` |
| `storage-contract.test.sh` | `require "$METADATA" 'version: 2.0.0'` |
