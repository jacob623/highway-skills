# Quickstart: Discovery Option Review and Implementation Exploration

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The repository must contain the canonical Discovery skill, Discovery record and catalog templates,
existing Discovery contract fixtures, and generated agent adapters.

## Validate the design artifacts

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-discovery
.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md
```

Expected result: both canonical artifacts pass their applicable checks.

## Focused contract validation

After implementation, run:

```sh
bash .highway/tools/tests/highway-discovery.test.sh
bash .highway/tools/tests/output-template.test.sh
```

Expected result: the Discovery contract test passes option review, comparison, evidence labeling,
score invariance, unsupported-option, no-write, and ADR-boundary assertions. The shared output test
passes the complete-template citation and validation checks.

## Generated correspondence validation

Regenerate derived artifacts from canonical sources:

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
```

Then verify the generated Discovery adapters contain the canonical skill content:

```sh
for adapter in .github/skills/highway-discovery/SKILL.md \
  .claude/skills/highway-discovery/SKILL.md \
  .cursor/skills/highway-discovery/SKILL.md \
  .agents/skills/highway-discovery/SKILL.md; do
  cmp -s .highway/skills/highway-discovery/SKILL.md "$adapter" || exit 1
done
```

## Behavioral fixture matrix

| Scenario | Expected result |
|---|---|
| `Describe OPT000001` for a valid option | Nine-section advisory review; no writes |
| `Review OPT000001` with no Objective, Control, or NFR relationship | Alignment sections identify unavailable evidence; no inferred relationship |
| `Compare OPT000001 and OPT000002` | Two-option advisory comparison; scores and recommendation unchanged |
| `Show implementation examples for OPT000001` with evidence | Named advisory examples, optionally with realization matrix |
| `Show implementation costs for OPT000001` without reliable evidence | `Unknown`; no invented estimate |
| Duplicate option in comparison | Rejection before mutation |
| Cross-Discovery option reference | Rejection before mutation |
| Any exploration request | No identifier allocation and no ADR creation or modification |
| Evidence added or removed | Candidate scores and recommendation remain identical |
| Completed Discovery | Review prompts and explicit advisory ADR handoff are shown |

## Full validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the complete repository suite passes, generated artifacts correspond to canonical
sources, and no whitespace errors are reported.

See [discovery-option-review.md](contracts/discovery-option-review.md) for the complete interaction,
immutability, evidence, and ownership contract.
