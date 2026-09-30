# NFR Skill Contract Simplification Quickstart

## Prerequisites

Run from the repository root with the existing Highway shell tooling available.

## Focused validation

1. Confirm `.highway/skills/highway-nfrs/SKILL.md` is version `11.0.0`, uses the short workflow,
   has the exact four-field readiness and collection results, and contains no `Created Control IDs`
   or post-write verification contract.
2. Confirm `.highway/catalog/nfr-candidate-state.md` defines one NFR-owned durable schema with
   originating Control identity, ordered candidate entries, decisions, resume position, and readiness.
3. Confirm `.highway/library/templates/output/nfr-record.md` is version `2.0.0`, retains unchanged
   frontmatter fields, and uses accepted-content placeholders.
4. Validate the canonical NFR skill and template:

```sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-nfrs
bash .highway/tools/validate-library.sh .highway/library/templates/output/nfr-record.md
```

5. Regenerate distributed outputs:

```sh
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/generate-library-catalog.sh
```

## Focused tests

Run the NFR management, onboarding, Control-derived NFR, readiness, template, and setup contract
tests. Verify direct NFRs retain `controls: []`, selected recommendations bypass redundant review,
pending candidates precede broad discovery, and collection `Finished` requires explicit user intent.

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: zero failures, aligned generated artifacts, preserved Control/NFR ownership,
correct readiness and collection separation, atomic relationship persistence, and no post-write
persistence-verification requirement.
