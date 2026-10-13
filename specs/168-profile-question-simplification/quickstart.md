# Quickstart: Profile Question-Bias Simplification

## Prerequisites

Run from the repository root with macOS system tools available:

```bash
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
```

The repository must contain the authoritative Profile source, generated adapter trees, and the existing Bash test harness.

## Focused Contract

After implementation, run:

```bash
bash .highway/tools/tests/feature-168-profile-question-simplification.test.sh
```

Expected result:

```text
OK: Feature 168 Profile Question-Bias Simplification contract passes
```

The focused contract should verify replacement guidance, removal of the three question-centric worked examples, retention of the unsupported-reasoning counter-example, protected Profile boundaries, and source-to-adapter correspondence.

## Source Validation and Regeneration

```bash
bash .highway/tools/validate-skill.sh .highway/skills/highway-profile
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/generate-catalog.sh
git diff --check
```

Expected outcomes: the Profile validator passes, all generated Profile adapters are regenerated from source, catalog artifacts are written successfully, and no whitespace errors are reported.

## Full Suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expected outcome: the complete repository suite exits successfully with zero failures.

## Evidence Boundary

These checks establish static document and generated-correspondence properties. They do not by themselves prove how an agent behaves in a live conversation; runtime conversational evaluation remains outside this feature's validation claim.
